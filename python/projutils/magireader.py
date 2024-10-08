import os
import re
import traceback
import projutils.utils as utils
import projutils.collision as collision
import projutils.color as color
import projutils.hotspot as hotspot
import projutils.encoding as encoding
import projutils.sprite as sprite
import projutils.config as config
import projutils.creature as creature


# Reads the rom file to interpret the script
# Also sets up hotspots
# Sample usage:
# magireader.interpret(BankAddress(0x2A,0x6CB5),BankAddress(0x2A,0x73E7))
# magireader.buildHotspots()
# magireader.buildTriggers()
# magireader.buildSprites()

MAGIREADER_FOLDER = config.outdir + "magireader/"

# Keep track of identified hotspots and triggers
hotspots = set()
triggers = set()
sprites = set()


_shorthands_color = {
    color.Color(0x1F*8, 0x1F*8, 0x1F*8, 255).get_word(): "WHITE_A",
}


# _shorthands_math = {
#     # 0, "FALSE",
#     0xFFFF, "TRUE",
# }

# Lookup table for LoadArena argument
_shorthands_arena = {
    0x00: "Arderial",
    0x01: "ArderialGeyser",
    0x02: "Cald",
    0x03: "UnderneathTunnels",
    0x04: "CaldGeyser",
    0x05: "Core",
    0x06: "Naroom",
    0x07: "NaroomUnderneathGeysers",
    0x08: "OrotheGeyser",
    0x09: "OrotheWarrada",
    0x0A: "Orothe",
    0x0B: "OrotheTunnels",
    0x0C: "Shadowhold",
    0x0D: "Underneath",
}

_battle_slot = {
    0x00: 'HERO',
    0x01: 'ALLY0',
    0x02: 'ALLY1',
    0x03: 'ALLY2',
    0x04: 'ALLY3',
    0x05: 'ENEMY0',
    0x06: 'ENEMY1',
    0x07: 'ENEMY2',
    0x08: 'ENEMY3',
    0x09: 'MAGI',
}

_cheat_code = [
    "Cheat_Up",
    "Cheat_Right",
    "Cheat_Down",
    "Cheat_Left",
    "Cheat_A",
    "Cheat_B",
    "Cheat_Select",
    "Cheat_7",
    "Cheat_8",
    "Cheat_Null",
]


class DepthTracker:
    defaultdepth = 4
    defaultdepthdelta = 4

    """Keeps track of indentation"""
    def __init__(self):
        self.depth = 0

    def indent(self):
        """Indent by 1"""
        self.depth += 1

    def dedent(self):
        """Dedent by 1"""
        self.depth -= 1

    def getWhitespace(self):
        """Returns the appropriate amount of whitespace for the current indentation"""
        return " "*DepthTracker.defaultdepth + " "*DepthTracker.defaultdepthdelta*self.depth


# Load the rom
rom = utils.Rom(utils.Rom.KQ)

# Keep track of the current WRAM bank used in Math
rambank = 1

# Load the symbol file for labels
# sym = utils.SymFile()

# Load the sfxid and songid. This assumes that the musyx file has been compiled
musyx = utils.MusyXIDs()

# Load collision ids
collision_ids = collision.CollisionIDs()

depthtracker = DepthTracker()


class CommandBuilder:
    """A quick wrapper around script commands"""
    def __init__(self, type, name, *instructions):
        self.type = type
        self.name = name
        self.instructions = instructions


class MagiScriptLine:
    """Main engine script commands"""
    commands = {
        0x00: CommandBuilder("func", "HeroFromDoor"),
        0x01: CommandBuilder("func", "HeroToDoor", "$db", "$db"),
        0x02: CommandBuilder("func", "HeroToRelativeDoor", "-$db", "-$db", "-$db", "-$db"),
        0x03: CommandBuilder("func", "ThatDrawTile", "db", "YXTileaddress", "CollID", "$db"),
        0x04: CommandBuilder("func", "ThatDrawMaskTile", "db", "Tileaddress", "CollID", "$db"),
        0x05: CommandBuilder("func", "ThatInit", "db", "ActorStateAddress", "$db", "$db", "$dw", "$db", "BankAddress_ACTORSCRIPT0", "BankAddress_ACTORSCRIPT1"),
        0x06: CommandBuilder("func", "ThatTeleportTo", "db", "db"),
        0x07: CommandBuilder("func", "ThatAI", "db", "ActorStateAddress"),
        0x08: CommandBuilder("func", "ThatLoc", "db", "$db", "$db", "$db", "$db", "$dw"),
        0x09: CommandBuilder("func", "ThatScript", "db", "BankAddress_ACTORSCRIPT0"),
        0x0A: CommandBuilder("func", "ThatSpriteBase", "db", "$db"),
        0x0B: CommandBuilder("func", "ThatStart", "db"),
        0x0C: CommandBuilder("func", "ThatDelete", "db"),
        0x0D: CommandBuilder("func", "ThisDrawTile", "YXTileaddress", "CollID", "$db"),
        0x0E: CommandBuilder("func", "ThisDrawMaskTile", "Tileaddress", "CollID", "$db"),
        0x0F: CommandBuilder("func", "ThisTeleportTo", "db"),
        0x10: CommandBuilder("func", "ThisNewState", "ActorStateAddress"),
        0x11: CommandBuilder("func", "ThisRaindrop", "CollID"),
        0x12: CommandBuilder("func", "RestoreActorState"),
        0x13: CommandBuilder("func", "ThisAI", "ActorStateAddress"),
        0x14: CommandBuilder("func", "ThisSetAnimSingle", "BankAddress_ACTORSCRIPT1"),
        0x15: CommandBuilder("block", "ThisSetAnimDelay"),
        0x16: CommandBuilder("block", "ThisSetAnimScroll"),
        0x17: CommandBuilder("func", "ThisLoc", "$db", "$db", "$db", "$db", "$dw"),
        0x18: CommandBuilder("func", "ThisSpriteBase", "$db"),
        0x19: CommandBuilder("func", "ThisDelete"),
        0x1A: CommandBuilder("func", "ThisWaitTile", "$db"),
        0x1B: CommandBuilder("func", "ThatSetInterrupt", "db", "BankAddress_ACTORINTERRUPT"),
        0x1C: CommandBuilder("func", "ThisSetInterrupt", "BankAddress_ACTORINTERRUPT"),
        0x1D: CommandBuilder("func", "ThisSaveScriptBugged", "BankAddress_ACTORSCRIPT0", "$db"),
        0x1E: CommandBuilder("func", "StartSFX0", "SFXID"),
        0x1F: CommandBuilder("func", "StartSFX1", "SFXID"),
        0x20: CommandBuilder("func", "PauseSongBugged"),
        0x21: CommandBuilder("func", "ResumeSong"),
        0x22: CommandBuilder("func", "StartSong", "SONGID"),
        0x23: CommandBuilder("func", "StartJingle", "SONGID"),
        0x24: CommandBuilder("func", "StopSong"),
        0x25: CommandBuilder("func", "SetSongVolume", "$db"),
        0x26: CommandBuilder("func", "SongFadeIn", "SongFadeInterval"),
        0x27: CommandBuilder("func", "SongFadeOut", "SongFadeInterval"),
        0x28: CommandBuilder("func", "BattleNew", "Arena", "CreatureID", "db", "BankAddress_CARDSCENESCRIPT"),
        0x29: CommandBuilder("func", "BattleAttack", "BattleSlot", "BattleCmd_Table", "BattleAI_Target"),
        0x2A: CommandBuilder("func", "BattleAuto"),
        0x2B: CommandBuilder("func", "BattleSpell", "BattleSlot", "ItemSpell_Table", "BattleAI_Target"),
        0x2C: CommandBuilder("func", "BattleEvaluate"),
        0x2D: CommandBuilder("func", "BattleFocus", "BattleSlot"),
        0x2E: CommandBuilder("func", "BattleNextTurn"),
        0x2F: CommandBuilder("func", "ForgeRing", "CreatureID", "db"),
        0x30: CommandBuilder("func", "BattleSummonFast", "BattleSlot", "CreatureID", "db", "db"),
        0x31: CommandBuilder("func", "BattleSummon", "BattleSlot", "CreatureID", "db", "db", "db"),
        0x32: CommandBuilder("func", "BattleItem", "BattleSlot", "ItemSpell_Table", "BattleAI_Target"),
        0x33: CommandBuilder("func", "BattleScreenWipe", "07Address", "SONGID"),
        0x34: CommandBuilder("func", "BattleSetReturn", "BankAddress_SCRIPT", "BankAddress_SCRIPT"),
        0x35: CommandBuilder("func", "BattleSetEncounter", "BankAddress_BATSCRIPT", "RandDelayAddress"),
        0x36: CommandBuilder("func", "BlowAway"),
        0x37: CommandBuilder("func", "LoadArena", "Arena"),
        0x38: CommandBuilder("func", "LoadCreatureLeft", "CreatureID"),
        0x39: CommandBuilder("func", "DissolveFast"),
        0x3A: CommandBuilder("func", "DissolveSlow"),
        0x3B: CommandBuilder("func", "FightsceneNew", "Arena", "CreatureID", "CreatureID"),
        0x3C: CommandBuilder("func", "PanTable", "CreatureSide", "PanAddress"),  # Technically it is pan left vs pan right, not CreatureSide, but the reference is the same
        0x3D: CommandBuilder("func", "Recoil"),
        0x3E: CommandBuilder("func", "RecoilFast"),
        0x3F: CommandBuilder("func", "PanConstant", "CreatureSide", "db", "db"),
        0x40: CommandBuilder("func", "Shake"),
        0x41: CommandBuilder("func", "Sink"),
        0x42: CommandBuilder("func", "Tremble"),
        0x43: CommandBuilder("func", "Delay", "db"),
        0x44: CommandBuilder("func", "RandDelay", "RandDelayAddress"),
        0x45: CommandBuilder("func", "End"),
        0x46: CommandBuilder("func", "LongJumpIf", "MATH", "BankAddress_SCRIPT"),
        0x47: CommandBuilder("func", "InitSkip", "LocalAddress"),
        0x48: CommandBuilder("func", "LongJump", "BankAddress_SCRIPT"),
        0x49: CommandBuilder("func", "Jump", "LocalAddress"),
        0x4A: CommandBuilder("func", "RandLongJump", "RANDLONGJUMP"),
        0x4B: CommandBuilder("func", "Pass"),
        0x4C: CommandBuilder("block", "SwitchRange", "MATH"),
        0x4D: CommandBuilder("func", "ResetScript", "BankAddress_SCRIPT"),
        0x4E: CommandBuilder("block", "Switch", "MATH"),
        0x4F: CommandBuilder("block", "SpriteDraw"),
        0x50: CommandBuilder("block", "SpriteBlock", "silent_byte", "db", "-db", "-db"),
        0x51: CommandBuilder("func", "SpriteInvisible", "db", "-db", "-db"),
        0x52: CommandBuilder("block", "OverlayDraw"),
        0x53: CommandBuilder("func", "OverlayInit", "RAMAddress", "$db", "$db", "$db", "BankAddress_SCRIPT_ACTORSCRIPT0"),
        0x54: CommandBuilder("func", "OverlayInvisible"),
        0x55: CommandBuilder("func", "ClearSync", "db"),
        0x56: CommandBuilder("func", "SetAnyEventMaster"),
        0x57: CommandBuilder("func", "SetAnyEventScroll"),
        0x58: CommandBuilder("func", "SetAnyEventText"),
        0x59: CommandBuilder("func", "SetEventMaster", "db"),
        0x5A: CommandBuilder("func", "SetEventScroll", "db"),
        0x5B: CommandBuilder("func", "SetEventText", "db"),
        0x5C: CommandBuilder("func", "SetScriptMaster", "BankAddress_SCRIPT"),
        0x5D: CommandBuilder("func", "SetScriptScroll", "BankAddress_SCRIPT"),
        0x5E: CommandBuilder("func", "SetScriptText", "BankAddress_SCRIPT"),
        0x5F: CommandBuilder("func", "Sync", "db", "db"),
        0x60: CommandBuilder("func", "WaitAnyEventMaster"),
        0x61: CommandBuilder("func", "WaitAnyEventScroll"),
        0x62: CommandBuilder("func", "WaitAnyEventText"),
        0x63: CommandBuilder("func", "WaitEventMaster", "db"),
        0x64: CommandBuilder("func", "WaitEventScroll", "db"),
        0x65: CommandBuilder("func", "WaitEventText", "db"),
        0x66: CommandBuilder("func", "LoadFullTilemap", "AddressBank_ATTRTILE_RLE"),
        0x67: CommandBuilder("func", "LoadHotspots", "HotspotTableAddress"),
        0x68: CommandBuilder("func", "LoadScene", "AddressBank_SCENE"),
        0x69: CommandBuilder("func", "LoadSpritePalette", "AddressBank_PAL8"),
        0x6A: CommandBuilder("func", "LoadMap", "AddressBank_METAMAP", "AddressBank_COLLMAP"),
        0x6B: CommandBuilder("func", "LoadMapMask", "AddressBank_METAMAP_MASK", "AddressBank_COLLMAP_MASK"),
        0x6C: CommandBuilder("func", "LoadTriggers", "TriggerTableAddress"),
        0x6D: CommandBuilder("func", "LoadBitmapSet", "AddressBank_BITSET", "AddressBank_PAL"),
        0x6E: CommandBuilder("func", "LoadSingleBitmap", "$db", "BankAddress_BITMAP", "$dw", "$db"),
        0x6F: CommandBuilder("func", "LoadSolidHotspot", "SolidHotspotTableAddress"),
        0x70: CommandBuilder("func", "PalArenaFadeToColor", "Palette_PackedLoop", "Color"),
        0x71: CommandBuilder("func", "PalArenaFadeToBase", "Palette_PackedLoop"),
        0x72: CommandBuilder("func", "PalClearBase", "Palette_PackedInterval", "Color"),
        0x73: CommandBuilder("func", "PalClearAnim", "Palette_PackedInterval", "Color"),
        0x74: CommandBuilder("func", "PalCreatureCycle", "Palette_PackedLoop", "CreatureSide"),
        0x75: CommandBuilder("func", "PalCreatureFadeToColor", "Palette_PackedLoop", "Color", "CreatureSide"),
        0x76: CommandBuilder("func", "PalCreatureFadeToBase", "Palette_PackedLoop", "CreatureSide"),
        0x77: CommandBuilder("func", "PalCreatureLoad", "AddressBank_PALCREATURE", "CreatureSide"),
        0x78: CommandBuilder("func", "PalCreatureFlash", "Palette_PackedLoop", "Palette_SwapType", "CreatureSide"),
        0x79: CommandBuilder("func", "PalCreatureInvert", "CreatureSide"),
        0x7A: CommandBuilder("func", "PalFadeAnimToBase", "Palette_PackedLoop", "Palette_PackedInterval"),
        0x7B: CommandBuilder("func", "PalFadeAnimToColor", "Palette_PackedLoop", "Palette_PackedInterval", "Color"),
        0x7C: CommandBuilder("func", "PalLoad", "AddressBank_PAL", "Palette_PackedInterval"),
        0x7D: CommandBuilder("func", "PalRefresh", "Palette_PackedInterval"),
        0x7E: CommandBuilder("func", "PalCycle", "Palette_PackedLoop", "Palette_PackedInterval", "Palette_CyclePattern"),
        0x7F: CommandBuilder("func", "PalInvert", "Palette_PackedInterval"),
        0x80: CommandBuilder("func", "CameraSeekPos", "$db", "$db", "db"),
        0x81: CommandBuilder("func", "CameraSeekActor", "RAMAddress", "db"),
        0x82: CommandBuilder("func", "TransplantMap", "$dw", "$db", "$db", "$dw", "$db", "$db"),
        0x83: CommandBuilder("func", "TransplantMapMask", "$dw", "$db", "$db", "$dw", "$db", "$db"),
        0x84: CommandBuilder("func", "TransplantTile", "$db", "$db", "$dw", "CollID", "$db"),
        0x85: CommandBuilder("func", "TransplantMaskTile", "$db", "$db", "$dw", "CollID", "$db"),
        0x86: CommandBuilder("func", "HeroSetCamera"),
        0x87: CommandBuilder("block", "ScrollMap"),
        0x88: CommandBuilder("func", "SetCamera", "$db", "$db"),
        0x89: CommandBuilder("func", "SetCollMask", "%db"),
        0x8A: CommandBuilder("func", "BackgroundSceneNew"),
        # InventoryGive
        # InventoryTake
        0x8D: CommandBuilder("func", "LoadGame"),
        0x8E: CommandBuilder("func", "CopyLoadGame"),
        # MenuHistorian
        0x90: CommandBuilder("func", "MusicMenu", "MusicMenu"),  # TODO finalize
        # MenuRingBank
        # MenuRingSmith
        # MenuRingUpgrade
        # MenuShop
        0x95: CommandBuilder("func", "NewGame", "db"),  # TODO boolean how?
        0x96: CommandBuilder("func", "SaveGame", "db"),
        0x97: CommandBuilder("func", "SceneNew"),
        0x98: CommandBuilder("func", "SceneReady"),
        0x99: CommandBuilder("func", "SetItemSpellMapError", "BankAddress_SCRIPT_ITEMSPELLMAPERROR"),
        0x9A: CommandBuilder("func", "SaveLocation", "BankAddress_SCRIPT_SCENELOADER"),
        0x9B: CommandBuilder("func", "SetStartButtonScript", "BankAddress_SCRIPT_STARTBUTTON"),
        0x9C: CommandBuilder("func", "SetCheatCode", "db",
                             "CheatCode", "CheatCode", "CheatCode", "CheatCode", "CheatCode", "CheatCode", "CheatCode", "CheatCode", "CheatCode", "CheatCode", "CheatCode", "CheatCode"),
        0x9D: CommandBuilder("func", "AwaitCheatCode"),
        0x9E: CommandBuilder("func", "ResetActorList"),
        # Removed CommandBuilder("func", "Reboot"),
        0x9F: CommandBuilder("func", "FormatChar", "Address_VARDB"),
        0xA0: CommandBuilder("func", "Clear"),
        0xA1: CommandBuilder("func", "Close"),
        0xA2: CommandBuilder("func", "Icon", "PortraitAddressBank"),
        0xA3: CommandBuilder("func", "Menu", "TextMenu"),
        0xA4: CommandBuilder("func", "Open"),
        0xA5: CommandBuilder("func", "FormatWord", "Address_VARDW"),
        0xA6: CommandBuilder("func", "Write", "String🛑"),
        0xA7: CommandBuilder("func", "ToggleAlways", "Varbit", "BankAddress_SCRIPT_TOGGLEON", "$db", "$db", "$dw"),
        0xA8: CommandBuilder("func", "ToggleOnce", "Varbit", "BankAddress_SCRIPT_TOGGLEON", "$db", "$db", "$dw"),
        0xA9: CommandBuilder("func", "TriggerAlways", "Varbit", "BankAddress_SCRIPT_TRIGGERALREADYON", "$db", "$dw"),
        0xAA: CommandBuilder("func", "TriggerOnce", "Varbit", "BankAddress_SCRIPT_TRIGGERALREADYON", "$db", "$dw"),
        0xAB: CommandBuilder("func", "Treasure", "Varbit", "$db", "$db", "$dw"),
        0xAC: CommandBuilder("func", "VarBitExpr", "Varbit", "MATH"),
        0xAD: CommandBuilder("func", "VarByteExpr", "Address_xVARBYTE", "MATH"),
        0xAE: CommandBuilder("func", "VarWordExpr", "Address_xVARWORD", "MATH"),
        0xAF: CommandBuilder("func", "NextGameCount"),
        0xB0: CommandBuilder("func", "SetGameCount", "db"),
        0xB1: CommandBuilder("func", "SetWramByte", "AddressBank_WRAM", "$db"),
        0xB2: CommandBuilder("func", "SetWramWord", "AddressBank_WRAM", "$dw"),
        0xB3: CommandBuilder("func", "SetByte", "RAMAddress", "$db"),
        0xB4: CommandBuilder("func", "SetWord", "RAMAddress", "$dw"),
        0xB5: CommandBuilder("func", "AndByte", "RAMAddress", "%db"),
        0xB6: CommandBuilder("func", "OrByte", "RAMAddress", "%db"),
    }

    def isEnd(self):
        """Returns True if the function always changes the reading frame"""
        return self.name in [
            "End",
            "ResetScript",
            "Reboot",
            "NewGame",
            "RestoreActorState",
            "LongJump",
            "Jump",
            "RandLongJump",
            "BattleAuto",
            "Treasure",
        ]

    def __init__(self):
        """Interprets main engine script commands"""
        global curpos

        self.pos = curpos
        self.whitespace = DepthTracker.getWhitespace(depthtracker)

        command = rom.getByte(curpos)
        if command in MagiScriptLine.commands:
            self.commandbuilder = MagiScriptLine.commands[command]
        else:
            raise KeyError("Unknown Command: {}: {:02X}".format(curpos, command))
        curpos = curpos + 1

        self.type = self.commandbuilder.type
        self.name = self.commandbuilder.name

        self.args = []
        try:
            for instruction in self.commandbuilder.instructions:
                self.args.extend(self._interpretInstruction(instruction))

            if self.type == "block":
                self.lines = []
                depthtracker.indent()
                while True:
                    line = self._interpretInstruction("func_"+self.name)
                    if line:
                        self.lines.extend(line)
                    else:
                        break
                depthtracker.dedent()
        except Exception:
            print("An error in command {} at {}".format(self.name, curpos))
            raise

        # print(self.name, self.args, curpos)
        self.size = curpos - self.pos

    # getOutput functions
    def func(self):
        return "{}({})".format(self.name, ", ".join(self.args))

    def block(self):
        return "{}({}) {{\n{}\n{}}}".format(self.name, ", ".join(self.args), "\n".join(self.lines), self.whitespace)

    def getOutput(self):
        """Gets the pre-processed line of code"""
        out = ""
        bank = self.pos.getBank()
        address = self.pos.getAddress()
        if address in sym.symbols[bank]:
            out = "\n" + "\n".join([(label+"::") for label in sym.symbols[bank][address]])+"\n"
        return out + self.whitespace + getattr(self, self.type)()

    def _interpretInstruction(self, instruction: str) -> list[str]:

        global curpos, rambank

        def interpretBankAddress(bank: int, address: int, label: str) -> str:
            if 0x8000 <= address < 0xA000:
                raise NotImplementedError("VRAM not-implemented")
            if 0xE000 <= address < 0xFE00:
                raise KeyError("Address is Echo RAM!")
            if (0x0000 <= address < 0x4000) or (0xC000 <= address < 0xD000) or (0xFE00 <= address < 0x10000):
                if bank == -1:  # Unknown bank
                    bank = 0
                if bank != 0:
                    raise ValueError("Input Address ${:04X} should not have a non-zero bank (${:02X})".format(address, bank))
            if bank == -1:
                if 0x4000 <= address < 0x8000:
                    raise NotImplementedError("Unknown bank ROMX not implemented!")
                elif 0xA000 <= address < 0xC000:
                    bank = 0  # Assume bank 0 by default for XRAM
                elif 0xD000 <= address < 0xE000:
                    bank = rambank
                else:
                    raise ValueError("Unknown Error ${:04X}".format(address))

            return "/".join(sym.getSymbol(bank, address, label))

        def getString(length: int) -> str:
            global curpos
            name = rom.getRawSection(curpos, length)
            curpos += length
            return '"' + encoding.decode(name) + '"'

        def getByte() -> int:
            global curpos
            val = rom.getByte(curpos)
            curpos += 1
            return val

        def getSignedByte() -> int:
            global curpos
            val = rom.getSignedByte(curpos)
            curpos += 1
            return val

        def getWord() -> int:
            global curpos
            val = rom.getWord(curpos)
            curpos += 2
            return val

        def getSignedWord() -> int:
            global curpos
            val = rom.getSignedWord(curpos)
            curpos += 2
            return val

        # This code is a bit of a trainwreck, but it works and doesn't need to be pretty
        try:
            # DB
            if instruction == "db":
                val = getByte()
                return [str(val)]
            elif instruction == "-db":
                val = getSignedByte()
                return [str(val)]
            elif instruction == "%db":
                val = getByte()
                return ["%{:08b}".format(val)]
            elif instruction == "$db":
                val = getByte()
                return ["${:02X}".format(val)]
            elif instruction == "-$db":
                val = getSignedByte()
                sign = " "
                if val < 0:
                    sign = "-"
                return ["{}${:02X}".format(sign, abs(val))]

            # DW
            elif instruction == "dw":
                val = getWord()
                return [str(val)]
            elif instruction == "$dw":
                val = getWord()
                return ["${:04X}".format(val)]

            # Strings
            elif instruction == "String🛑":
                start = curpos
                end = curpos
                endchar = encoding.encode("🛑")

                looping = True  # do-while
                while looping:
                    looping = rom.getRawSection(end, 1) != endchar
                    end += 1

                text = getString((end-start)-1)  # Remove the EOF 🛑 character since by definition the string is EOF-terminated
                curpos = end
                return [text]

            # BankAddress
            elif instruction[:12] == "AddressBank_":
                address = getWord()
                bank = getByte()
                label = instruction[12:]
                return [interpretBankAddress(bank, address, label)]
            elif instruction[:12] == "BankAddress_":
                bank = getByte()
                address = getWord()
                label = instruction[12:]
                return [interpretBankAddress(bank, address, label)]

            # Naked Address
            elif instruction == "RAMAddress":
                address = getWord()
                return [interpretBankAddress(0, address, "RAM")]  # Assume it is bank 0 of WRAM or XRAM
            elif instruction == "LocalAddress":
                curbank = curpos.getBank()
                address = getWord()
                return [interpretBankAddress(curbank, address, "SCRIPT")]  # Stay in same bank
            elif instruction == "ActorStateAddress":
                address = getWord()
                return [interpretBankAddress(0x01, address, "AI")]  # Actor bank = $01
            elif instruction == "07Address":
                address = getWord()
                return [interpretBankAddress(0x07, address, "BANK07")]
            elif instruction == "HotspotTableAddress":
                address = getWord()
                hotspots.add(address)  # store a copy of all the unique hotspot addresses
                return [interpretBankAddress(0x13, address, "HOTSPOTX")]  # Hotspots are in 0x21
            elif instruction == "SolidHotspotTableAddress":
                address = getWord()
                hotspots.add(address)  # store a copy of all the unique hotspot addresses
                return [interpretBankAddress(0x13, address, "SOLIDHOTSPOTX")]  # Hotspots are in 0x21
            elif instruction == "TriggerTableAddress":
                address = getWord()
                triggers.add(address)  # store a copy of all the unique triggers addresses
                return [interpretBankAddress(0x13, address, "TRIGGERX")]  # Triggers are in 0x21
            elif instruction == "RandDelayAddress":
                address = getWord()
                return [interpretBankAddress(0x01, address, "RANDDELAYTABLE")]  # RandDelay lookup tables are in 0x01
            elif instruction[:8] == "Address_":
                label = instruction[8:]
                address = getWord()
                return [interpretBankAddress(-1, address, label)]  # Bank 0/undefined
            elif instruction == "SpriteTableAddress":
                curbank = curpos.getBank()
                address = getWord()
                sprites.add(utils.BankAddress(curbank, address))  # store a copy of all the unique sprite addresses
                return [interpretBankAddress(curbank, address, "OAMX")]  # Stay in same bank
            elif instruction == "PanAddress":
                address = getWord()
                return [interpretBankAddress(0x04, address, "FIGHTSCENEPAN")]  # Fightscene bank = $04
            elif instruction == "BattleCmd_Table":
                address = getWord()
                labels = sym.getSymbol(0x05, address, 'BATTLECMDUNK')  # BattleCmd_Table bank $05
                label = min(labels, key=len)  # Get BattleCmd_Table.BattleCmd_FIGHT instead of BattleCmd_Table.BattleCmd_FIGHT_Function
                label = label[label.find('.') + 1:]  # Remove BattleCmd_Table.
                return [label]
            elif instruction == "ItemSpell_Table":
                address = getWord()
                labels = sym.getSymbol(0x07, address, 'ITEMSPELLUNK')  # Item_Table/Spell_Table bank $07
                label = min(labels, key=len)  # Get Spell_Table.Spell_LEAFCUT instead of Spell_Table.Spell_LEAFCUT_LocalAddress1
                label = label[label.find('.') + 1:]  # Remove Spell_Table.
                return [label]
            elif instruction == "BattleAI_Target":
                val = getByte()
                address = 0x6FDF + val
                labels = sym.getSymbol(0x02, address, 'BATTLEAI_TARGET')  # BattleAI_Target_Table bank $02
                label = max(labels, key=len)  # Get sublabel
                label = label[label.rfind('_') + 1:]  # Remove everything except the end of the label
                return [label]

            # VARBIT
            elif instruction == "Varbit":
                address = getWord()
                mask = getByte()
                bit = mask.bit_length()-1  # Get a number 0-7
                assert 2**bit == mask  # Make sure the mask only refers to a single bit
                return ["/".join(sym.getSymbol(0, address, 'VARBIT')) + f'[{bit}]']
                #return ["/".join(sym.getVarbit(address, bit))]

            # Packed Objects: Palette, Color, Palette_PackedLoop, SongFadeInterval, PortraitAddressBank
            elif instruction == "Palette_PackedInterval":
                packed = getByte()
                index = (packed & 0b11110000) >> 4
                number = (packed & 0b00001111) + 1
                return [str(index), str(number)]
            elif instruction == "Color":
                packed = getWord()
                if packed in _shorthands_color:
                    return [_shorthands_color[packed]]
                else:
                    r, g, b, a = color.Color(packed).get_RGBA()
                    return ["${:02X}".format(r), "${:02X}".format(g), "${:02X}".format(b), str(a)]
            elif instruction == "Palette_PackedLoop":
                packed = getByte()
                framedelay = ((packed & (0b11000000)) >> 6) + 1
                totaliterations = packed & (0b00111111)
                return [str(framedelay), "${:02X}".format(totaliterations)]
            elif instruction == "SongFadeInterval":
                val = getByte()
                return [str((val >> 4) + 1)]
            elif instruction == "PortraitAddressBank":
                val = getWord()
                bank    = val & 0b0000000000001111  # noqa E221
                address = val & 0b1111111111110000
                return [interpretBankAddress(bank, address, "PORTRAITBITMAP")]

            # MATH
            elif instruction == "MATH":
                math = MagiScriptMath()
                return ["#{}#".format(math)]
            elif instruction == "math":
                math = MagiScriptMath()
                return ["{}".format(math)]
            elif instruction == "math_address":
                address = getWord()
                return [interpretBankAddress(-1, address, "MATHADDRESS")]  # Unknown bank
            elif instruction == "math_bank":
                bank = getByte()
                rambank = bank  # Update the current WRAM bank
                return [str(bank)]

            # ENUMS
            elif instruction == "Arena":
                val = getByte()
                if val in _shorthands_arena:
                    return [_shorthands_arena[val]]
                raise KeyError(val)
            elif instruction == "BattleSlot":
                val = getByte()
                if val in _battle_slot:
                    return [_battle_slot[val]]
                raise KeyError(val)
            elif instruction == "CreatureID":
                val = getByte()
                if val in creature.CREATURE_NAMES:
                    return ["CreatureID_"+creature.CREATURE_NAMES[val]]
                raise KeyError(val)
            elif instruction == "SFXID":
                val = getByte()
                return [musyx.sfxid[val]]
            elif instruction == "SONGID":
                val = getByte()
                return [musyx.songid[val]]
            elif instruction == "CreatureSide":
                val = getByte()
                return [["LEFT", "RIGHT"][val]]
            elif instruction == "Palette_SwapType":
                val = getByte()
                if val == 0:
                    raise NotImplementedError  # 0 ->"RGB" but it's supposed to be accessed as 4 instead
                return [[None, "RB", "BG", "RG_Bugged", "RGB"][val]]
            elif instruction == "CollID":
                val = getByte()
                return [collision_ids.ids[val]]
            elif instruction == "CheatCode":
                val = getByte()
                return [_cheat_code[val]]
            # Map tileaddresses
            elif instruction == "YXTileaddress":
                y = getSignedByte()
                x = getSignedByte()
                offset = getSignedWord()
                y_times_width = offset - x
                if y_times_width == 0:
                    width = 0
                else:
                    width = y_times_width//y
                    assert y_times_width % y == 0
                return [f"${x:02X}", f"${y:02X}", f"${width:02X}"]
            elif instruction == "Tileaddress":
                offset = getSignedWord()
                return [f"${offset:04X}", "0", "0"]  # TODO - we can't predict width unfortunately with the limited data

            # Special Objects
            elif instruction == "TextMenu":
                size = getByte()
                assert 4 >= size >= 2

                out = []
                for _ in range(size):
                    out.extend(self._interpretInstruction("BankAddress_SCRIPT"))
                return out
            elif instruction == "MusicMenu":
                size = getWord()
                songcount = getByte()
                assert size == 1 + songcount*0x0E
                songlist = []
                for _ in range(songcount):
                    songid = self._interpretInstruction("SONGID")[0]
                    name = getString(0x0D)
                    songlist.extend([songid, name])
                print(songlist)
                return songlist
            elif instruction == "RANDLONGJUMP":
                size = getByte()
                addresslist = []
                for _ in range(size):
                    bank = getByte()
                    address = getWord()
                    addresslist.append(interpretBankAddress(bank, address, "SCRIPT"))
                return addresslist
            elif instruction == "silent_byte":
                # Save the value but don't add it to args, so it can be modified by functions within a block
                self.param = getByte()
                return []

            # FUNC HANDLERS
            elif instruction == "func_ThisSetAnimDelay":
                bank = getByte()
                if bank == 0x00:
                    return []  # End
                address = getWord()
                bankaddress = interpretBankAddress(bank, address, "SCRIPT")
                frames = str(getByte())
                return ["{}ScriptDelay({})".format(depthtracker.getWhitespace(), ", ".join([bankaddress, frames]))]
            elif instruction == "func_ThisSetAnimScroll":
                bank = getByte()
                if bank == 0x00:
                    return []  # End
                address = getWord()
                bankaddress = interpretBankAddress(bank, address, "SCRIPT")
                frames = str(getByte())
                deltax = str(getSignedByte())
                deltay = str(getSignedByte())
                return ["{}ScriptScroll({})".format(depthtracker.getWhitespace(), ", ".join([bankaddress, frames, deltax, deltay]))]
            elif instruction == "func_Switch":
                bank = getByte()
                if bank == 0xFF:
                    return []  # End

                val = getWord()
                if self.args[0] == '#{}#'.format(MagiScriptMath.GETHERODIRECTION):
                    # Special case where the Switch is #DIRECTION# to check the direction the hero is facing
                    val = ['Actor_FLAGS_FACENORTH', 'Actor_FLAGS_FACEWEST', 'Actor_FLAGS_FACEEAST', 'Actor_FLAGS_FACESOUTH'][val]
                else:
                    val = str(val)

                address = getWord()
                return ["{}Case({})".format(depthtracker.getWhitespace(), ", ".join([val, interpretBankAddress(bank, address, "SCRIPT")]))]
            elif instruction == "func_SwitchRange":
                bank = getByte()
                if bank == 0xFF:
                    return []  # End

                low = str(getWord())
                high = str(getWord())
                address = getWord()

                return ["{}CaseRange({})".format(depthtracker.getWhitespace(), ", ".join([low, high, interpretBankAddress(bank, address, "SCRIPT")]))]
            elif instruction in ["func_OverlayDraw", "func_SpriteDraw"]:
                frameN = getByte()
                if frameN == 0x00:
                    return []  # End
                frameN = str(frameN)
                deltaX = self._interpretInstruction("-db")[0]
                deltaY = self._interpretInstruction("-db")[0]
                sprite_data = self._interpretInstruction("SpriteTableAddress")[0]
                return ["{}MoveDraw({})".format(depthtracker.getWhitespace(), ", ".join([frameN, deltaX, deltaY, sprite_data]))]
            elif instruction in ["func_ScrollMap"]:
                frameN = getByte()
                if frameN == 0x00:
                    return []  # End
                frameN = str(frameN)
                deltaX = self._interpretInstruction("-db")[0]
                deltaY = self._interpretInstruction("-db")[0]
                return ["{}Move({})".format(depthtracker.getWhitespace(), ", ".join([frameN, deltaX, deltaY]))]
            elif instruction == "func_SpriteBlock":
                if self.param < 0:
                    raise ValueError('Size is an odd number')
                if self.param == 0:
                    return []  # End
                self.param -= 2
                sprite_data = self._interpretInstruction("SpriteTableAddress")[0]
                return ["{}Draw({})".format(depthtracker.getWhitespace(), sprite_data)]

            raise KeyError("Unknown Instruction: " + instruction)
        except Exception:
            print("An exception occured interpreting: " + instruction)
            raise


class MagiScriptMath(MagiScriptLine):
    """Expr (i.e. Math) engine script commands"""

    GETHERODIRECTION = "DIRECTION"

    commands = {
        0x00: CommandBuilder("bitmatch", None, "math_address", "%db"),
        0x01: CommandBuilder("pointer", "c", "math_address"),
        0x02: CommandBuilder("pointer", "w", "math_address"),
        0x03: CommandBuilder("const", GETHERODIRECTION),
        0x04: CommandBuilder("const", "GAMECOUNT"),
        0x05: CommandBuilder("value", "c", "db"),
        0x06: CommandBuilder("value", "w", "dw"),
        0x07: CommandBuilder("op2", "&", "math", "math"),
        0x08: CommandBuilder("op2", "and", "math", "math"),
        0x09: CommandBuilder("op2", "or", "math", "math"),
        0x0A: CommandBuilder("op1_right", "not ", "math"),
        0x0B: CommandBuilder("op2", "+", "math", "math"),
        0x0C: CommandBuilder("op2", "-", "math", "math"),
        0x0D: CommandBuilder("op1_left", "++", "math"),
        0x0E: CommandBuilder("op1_left", "--", "math"),
        0x0F: CommandBuilder("op2", "==", "math", "math"),
        0x10: CommandBuilder("op2", "!=", "math", "math"),
        0x11: CommandBuilder("op2", ">", "math", "math"),
        0x12: CommandBuilder("op2", ">=", "math", "math"),
        0x13: CommandBuilder("op2", "<", "math", "math"),
        0x14: CommandBuilder("op2", "<=", "math", "math"),
        0x15: CommandBuilder("const", "RAND16"),
        0x16: CommandBuilder("bank", None, "math_bank", "math"),
    }

    def __init__(self):
        global curpos, rambank

        self.address = curpos

        command = rom.getByte(curpos)
        if command in MagiScriptMath.commands:
            self.commandbuilder = MagiScriptMath.commands[command]
        else:
            raise KeyError("Unknown Math Command: {}: {:02X}".format(curpos, command))
        curpos = curpos + 1

        self.type = self.commandbuilder.type
        self.name = self.commandbuilder.name

        self.args = []
        temp_rambank = rambank  # Push the wram bank
        for instruction in self.commandbuilder.instructions:
            self.args.extend(self._interpretInstruction(instruction))
        rambank = temp_rambank  # Pop the wram bank

    # getOutput functions
    def bitmatch(self):
        # TODO - use direction constants?
        return "bitmatch(c[{}], c{})".format(self.args[0], self.args[1])

    def const(self):
        return self.name

    def pointer(self):
        return "{}[{}]".format(self.name, self.args[0])

    def value(self):
        return "{}{}".format(self.name, self.args[0])

    def op2(self):
        return "({} {} {})".format(self.args[0], self.name, self.args[1])

    def op1_left(self):
        return "{}{}".format(self.args[0], self.name)

    def op1_right(self):
        return "{}{}".format(self.name, self.args[0])

    def bank(self):
        return "bank({}, {})".format(self.args[0], self.args[1])

    def getOutput(self):
        """Gets the pre-processed line of code"""
        out = ""
        # if(self.labels):
        #    out = "\n".join(labels)+"\n"
        return out + getattr(self, self.type)()

    def __str__(self):
        return self.getOutput()


class SpriteLine(MagiScriptLine):
    """.spr file"""

    def __init__(self, folder):

        global curpos, rambank

        # Get the filename of a Sprite (e.g. SPRITE_Zet_WalkLeft1 -> Zet_WalkLeft1)
        symbol = sym.getSymbol(curpos.getBank(), curpos.getAddress(), "SPRITE")[0]
        match = re.search(r'SPRITE_(.*)', symbol)
        if match is None:
            raise ValueError('Invalid Label at {}: {}'.format(curpos, symbol))
        self.name = match.group(1)
        if folder in ['Objects', 'Effects']:
            match = re.search(r'SPRITE_([^_]*)(_.*)?', symbol)
            self.folder = folder + '/' + match.group(1)
        else:
            self.folder = folder
        self.shortpath = self.name + '.spr'
        self.longpath = sprite.SPRITE_FOLDER + self.folder.lower() + '/' + self.shortpath
        self.rompath = 'assets/sprites/' + self.folder.lower() + '/' + self.shortpath
        self.type = 'spr'

        self.pos = curpos
        self.whitespace = DepthTracker.getWhitespace(depthtracker)

        self.sprite = sprite.Sprite.init_from_rom(sym, rom, curpos)
        curpos = self.sprite.end

    def save(self):
        self.sprite.save_original_file(self.longpath)

    def debug(self):
        """Debug getOutput()"""
        return str(self.sprite)[4:]

    def spr(self):
        """Via getOutput()"""
        return 'INCSPRITE("{}")'.format(self.rompath)

    def __str__(self):
        return self.getOutput()


def interpret(startpos: utils.BankAddress, endpos: utils.BankAddress, _sym: utils.SymFile = None) -> str:
    """Interprets raw bytecode of Magi Nation's scripting engine.
    Prints out the pre-processed code."""
    global curpos
    global sym
    if _sym is None:
        sym = utils.SymFile()
    else:
        sym = _sym
    curpos = startpos
    lines = []
    try:
        while curpos != endpos:
            if len(lines) == 0 or lines[-1].isEnd():
                # Add a label to the beginning of sections
                sym.getSymbol(curpos.getBank(), curpos.getAddress(), "SCRIPT")
            try:
                lines.append(MagiScriptLine())
            except KeyError as e:
                if str(e).endswith('FF\''):
                    print(e)
                    break
            # out += " "*defaultdepth + x.command_out + "\n\n"
    except Exception:
        traceback.print_exc()
    finally:
        return '\n'.join(line.getOutput() for line in lines)


def interpretSpriteAnim(startpos: utils.BankAddress, endpos: utils.BankAddress, _sym: utils.SymFile = None, debug: bool = True) -> str:
    """Interprets raw bytecode of Magi Nation's scripting engine.
    Returns the pre-processed code.
    Some banks are a collection of sprites + scripts containing animation
    (e.g. Bank 0x0E, 0x0F, 0x10, 0x11, 0x20, 0x40, 0x41). Specifically seek to parse these ones

    debug = True to write output to a single file
    debug = False to generate the files for importation into the main project"""
    global curpos
    global sym

    def getFolder():
        """Gets the folder of a Sprite (e.g. SPRITE_Zet_WalkLeft1 -> Zet)"""
        if curpos == utils.BankAddress(0x11, 0x4D99):
            return 'Objects'  # Special case
        if curpos == utils.BankAddress(0x11, 0x7a6e):
            return 'Effects'  # Special case
        symbol = sym.getSymbol(curpos.getBank(), curpos.getAddress(), "SPRITE")[0]
        match = re.search(r'SPRITE_([^_]*).*', symbol)
        return match.group(1)

    def setupBlock():
        """Setup the start of a _SPRITE + SCRIPT_ANIM_ block"""
        nonlocal lines, spriteMode, folder
        if not debug:
            lines = []
        spriteMode = True
        folder = getFolder()

    def endBlock():
        """Finish a SPRITE_ + SCRIPT_ANIM_ block by saving the .mgi file"""
        nonlocal lines, folder, includes
        includes.append('INCLUDE "autogenerated/magiscript/sprites/' + folder.lower() + '.mgi.asm"')
        if debug:
            return
        sprite_mgi_dir = config.outdir + 'magiscript/sprites/'
        os.makedirs(sprite_mgi_dir, exist_ok=True)
        with open(sprite_mgi_dir + folder.lower() + '.mgi', 'w') as f:
            f.write('\n'.join(line.getOutput() for line in lines))

    def isLikelySprite(val):
        if val > 0xAF:  # Out of range command
            return True
        if val <= 0x32:  # Heuristic
            return True
        return False

    if _sym is None:
        sym = utils.SymFile()
    else:
        sym = _sym

    includes = []
    lines = []
    folder = None
    spriteMode = True
    try:
        curpos = startpos
        setupBlock()
        restore_actor_state_count = 0
        while curpos < endpos:
            if spriteMode:
                curbyte = rom.getSignedByte(curpos)
                if not isLikelySprite(curbyte):  # heuristic to distinguish script from sprite
                    spriteMode = False
                    sym.getSymbol(curpos.getBank(), curpos.getAddress(), "SCRIPT")
                    continue
                lines.append(SpriteLine(folder))
                if debug:
                    lines[-1].type = 'debug'
                    # print(lines[-1].shortpath)
                else:
                    lines[-1].save()  # Save the .spr file

            else:
                # heuristic to distinguish script from sprite
                curbyte = rom.getByte(curpos)
                if curpos == utils.BankAddress(0x11, 0x74F4):  # Special exception where a Switch only has two RestoreActorState
                    restore_actor_state_count = 0
                if lines[-1].isEnd() and lines[-1].name == 'RestoreActorState':
                    restore_actor_state_count += 1
                    if (
                        restore_actor_state_count % 4 == 0
                        and curpos != utils.BankAddress(0x20, 0x6a49)  # Special exception
                       ):
                        endBlock()
                        setupBlock()
                        continue
                elif (
                    lines[-1].isEnd() and isLikelySprite(curbyte) and
                    curpos not in [utils.BankAddress(0x40, 0x7A3F), utils.BankAddress(0x40, 0x7B2A), utils.BankAddress(0x40, 0x7EA6), utils.BankAddress(0x40, 0x7EE1)]
                ):
                    endBlock()
                    setupBlock()
                    continue
                elif lines[-1].isEnd():
                    # Force a label here
                    sym.getSymbol(curpos.getBank(), curpos.getAddress(), "SCRIPT")
                lines.append(MagiScriptLine())
        endBlock()
    except Exception:
        traceback.print_exc()
    finally:
        with open(config.outdir + 'sprites.asm', 'w') as f:
            bank = startpos.getBank()
            f.write('SECTION "Sprites ${:02X}", ROMX[$4000], BANK[${:02X}]\n\n'.format(bank, bank) + '\n'.join(includes))
        if debug:
            # print(curpos)
            with open(config.outdir + 'temp.mgi', 'w') as f:
                f.write('\n'.join([line.getOutput() for line in lines]))


def buildHotspots() -> None:
    """Prints out a list of all the new hotspots identified.
    Creates files for all the new hotspots."""
    print("\n"*3)
    print("BUILD HOTSPOTS")
    for address in hotspots:
        label = "_".join(sym.getSymbol(0x13, address, "HOTSPOTX"))
        print(label)
        #if label[:8] == "HOTSPOTX":  # Unlabelled hotspot to process
        hotspot.Hotspot.rom_to_file(rom, address, label, sym)
        # TODO: rom_replace the hotspot files


def buildTriggers() -> None:
    """Prints out a list of all the new triggers identified.
    Creates files for all the new triggers."""
    print("\n"*3)
    print("BUILD TRIGGERS")
    for address in triggers:
        label = "_".join(sym.getSymbol(0x13, address, "TRIGGERX"))
        print(label)
        #if label[:8] == "TRIGGERX":  # Unlabelled trigger to process
        hotspot.Trigger.rom_to_file(rom, address, label, sym)
        # TODO: rom_replace the trigger files?
