// ~Prototype~ Magi-Nation: Keeper's Quest
// #ID = 24989

//////////////////////
// Helper Functions //
//////////////////////

// Converts a ROM address from raw location to a bank_address. Only valid for ROM banks >= 1
// e.g. 0x047327 -> ROMX[0x11] 0x7327 -> 0x732711
function bank_address(raw_address) =>
    0x000100*(raw_address % 0x4000 + 0x4000) + // Address
    0x000001*(raw_address / 0x4000) // Bank

function changes_from(address, value) => (prev(address) == value) && (address != value)

function changes(address) => (prev(address) != address)

function increases(address) => (prev(address) < address)

///////////////////
// Lookup Tables //
///////////////////
Hotspot_Arderial_Main = 0x4001
Hotspot_Arderial_Puzzle1 = 0x403F
Hotspot_Arderial_Puzzle2 = 0x4044
Hotspot_Arderial_Puzzle4 = 0x4049
Hotspot_Arderial_Puzzle3 = 0x404E
Hotspot_Arderial_Puzzle5 = 0x4057
Hotspot_DeveloperRoom = 0x405C
Hotspot_StartRoom = 0x413D
Hotspot_Turret = 0x4157
Hotspot_Bograth_Main = 0x4160
Hotspot_Bograth_Puzzle1 = 0x41A6
Hotspot_Bograth_Puzzle24 = 0x4227
Hotspot_Bograth_Puzzle3 = 0x4269
Hotspot_Bograth_Puzzle5 = 0x431B
Hotspot_Cald_Main = 0x43A0
Hotspot_Cald_Puzzle1 = 0x43DE
Hotspot_Cald_Puzzle2 = 0x4403
Hotspot_Cald_Puzzle3 = 0x4430
Hotspot_Cald_Puzzle4 = 0x445D
Hotspot_Cald_Puzzle5 = 0x4486
Hotspot_Core_Main = 0x44AB
Hotspot_Core_Puzzle5 = 0x44E9
Hotspot_Core_Puzzle2 = 0x44FF
Hotspot_Core_Puzzle3 = 0x4545
Hotspot_Core_Puzzle1 = 0x4577
Hotspot_Core_Puzzle4 = 0x4599
Hotspot_dResh_Main = 0x45FB
Hotspot_dResh_Puzzle1 = 0x4641
Hotspot_dResh_Puzzle3 = 0x4646
Hotspot_dResh_Puzzle4 = 0x464B
Hotspot_dResh_Puzzle2 = 0x4650
Hotspot_dResh_Puzzle5 = 0x4661
Hotspot_Tavel_Entrance = 0x46CF
Hotspot_Tavel_Cave = 0x46D4
Hotspot_KybarsTeeth_Main = 0x46D9
Hotspot_KybarsTeeth_Puzzle1 = 0x4713
Hotspot_KybarsTeeth_Puzzle2 = 0x4764
Hotspot_KybarsTeeth_Puzzle3 = 0x47A9
Hotspot_KybarsTeeth_Puzzle4 = 0x47D2
Hotspot_KybarsTeeth_Puzzle5 = 0x483F
Hotspot_Naroom_Main = 0x4848
Hotspot_Naroom_Puzzle1 = 0x488A
Hotspot_Naroom_Puzzle2 = 0x488F
Hotspot_Naroom_Puzzle3 = 0x4894
Hotspot_Naroom_Puzzle4 = 0x48A9
Hotspot_Naroom_Puzzle5 = 0x48B2
Hotspot_Naroom_Puzzle25_End = 0x48B7
Hotspot_Orothe_Puzzle1 = 0x48C0
Hotspot_Orothe_Puzzle2 = 0x48FF
Hotspot_Orothe_Puzzle3 = 0x4939
Hotspot_Orothe_Puzzle4 = 0x496C
Hotspot_Orothe_Puzzle5 = 0x4993
Hotspot_Orothe_Main = 0x49CE
Hotspot_Overworld_1 = 0x4A21
Hotspot_Overworld_2 = 0x4A8B
Hotspot_Naroom_Demo = 0x4AED
Hotspot_House_Cald = 0x4B02
Hotspot_House_Weave = 0x4B18
Hotspot_House_Orothe = 0x4B2E
Hotspot_House_Bograth = 0x4B44
Hotspot_Naroom_TrainingRoom_Normal = 0x4B5A
Hotspot_Paradwyn_Main = 0x4B78
Hotspot_Paradwyn_Puzzle1 = 0x4BB2
Hotspot_Paradwyn_Puzzle2 = 0x4BC7
Hotspot_Paradwyn_Puzzle4 = 0x4BD8
Hotspot_Paradwyn_Puzzle3 = 0x4BF5
Hotspot_Paradwyn_Puzzle5 = 0x4C18
Hotspot_Underneath_Main = 0x4C3F
Hotspot_Underneath_Puzzle1 = 0x4C85
Hotspot_Underneath_Puzzle2 = 0x4CBA
Hotspot_Underneath_Puzzle3 = 0x4D0F
Hotspot_Underneath_Puzzle4 = 0x4D44
Hotspot_Underneath_Puzzle5 = 0x4DB9
Hotspot_Weave_Main = 0x4E2E
Hotspot_Weave_Puzzle1 = 0x4E90
Hotspot_Weave_Puzzle2 = 0x4E95
Hotspot_Weave_Puzzle3 = 0x4E9E
Hotspot_Weave_Puzzle4 = 0x4EA3
Hotspot_Weave_Puzzle5 = 0x4EA8

Script_dResh_Puzzle1_Complete = bank_address(0x0282F4)
Script_dResh_Puzzle3_Complete = bank_address(0x0286B2)
Script_dResh_Puzzle4_Complete = bank_address(0x028A19)
Script_dResh_Puzzle2_Complete = bank_address(0x028E50)
Script_dResh_Puzzle5_Complete = bank_address(0x02926B)
Script_Weave_Puzzle1_Complete = bank_address(0x029D41)
Script_Weave_Puzzle2_Complete = bank_address(0x02A127)
Script_Weave_Puzzle3_Complete = bank_address(0x02A62D)
Script_Weave_Puzzle4_Complete = bank_address(0x02A9B8)
Script_Weave_Puzzle5_Complete = bank_address(0x02AD99)
Script_KybarsTeeth_Puzzle1_Complete = bank_address(0x030F8D)
Script_KybarsTeeth_Puzzle2_Complete = bank_address(0x0312A4)
Script_KybarsTeeth_Puzzle3_Complete = bank_address(0x031D93)
Script_KybarsTeeth_Puzzle4_Complete = bank_address(0x032249)
Script_KybarsTeeth_Puzzle5_Complete = bank_address(0x03277F)
Script_Naroom_Puzzle1_Complete = bank_address(0x03EBF4)
Script_Naroom_Puzzle2_Complete = bank_address(0x03EF96)
Script_Naroom_Puzzle3_Complete = bank_address(0x03F359)
Script_Naroom_Puzzle4_Complete = bank_address(0x03F8E6)
Script_Naroom_Puzzle5_Complete = bank_address(0x03FD33)
Script_Bograth_Puzzle5_Complete = bank_address(0x043157)
Script_Arderial_Puzzle1_Complete = bank_address(0x0481FF)
Script_Arderial_Puzzle2_Complete = bank_address(0x0485AC)
Script_Arderial_Puzzle4_Complete = bank_address(0x048924)
Script_Arderial_Puzzle3_Complete = bank_address(0x048CAD)
Script_Arderial_Puzzle5_Complete = bank_address(0x0491FF)
Script_Underneath_Puzzle1_Complete = bank_address(0x054369)
Script_Underneath_Puzzle2_Complete = bank_address(0x054766)
Script_Underneath_Puzzle3_Complete = bank_address(0x054C19)
Script_Underneath_Puzzle4_Complete = bank_address(0x05514B)
Script_Underneath_Puzzle5_Complete = bank_address(0x055A50)
Script_Paradwyn_Puzzle1_Complete = bank_address(0x056078)
Script_Paradwyn_Puzzle2_Complete = bank_address(0x0563B7)
Script_Paradwyn_Puzzle4_Complete = bank_address(0x056711)
Script_Paradwyn_Puzzle3_Complete = bank_address(0x056A05)
Script_Paradwyn_Puzzle5_Complete = bank_address(0x056EE9)
Script_Core_Puzzle5_Complete = bank_address(0x05821C)
Script_Core_Puzzle2_Complete = bank_address(0x05887A)
Script_Core_Puzzle3_Complete = bank_address(0x0592D6)
Script_Core_Puzzle1_Complete = bank_address(0x059A75)
Script_Core_Puzzle4_Complete = bank_address(0x05A407)
Script_Orothe_Puzzle1_Complete = bank_address(0x05C28A)
Script_Orothe_Puzzle2_Complete = bank_address(0x05CB1B)
Script_Orothe_Puzzle3_Complete = bank_address(0x05CE90)
Script_Orothe_Puzzle4_Complete = bank_address(0x05D379)
Script_Orothe_Puzzle5_Complete = bank_address(0x05D870)
Script_Bograth_Puzzle1_Complete = bank_address(0x05E0B4)
Script_Bograth_Puzzle2_Complete = bank_address(0x05E61B)
Script_Bograth_Puzzle3_Complete = bank_address(0x05F064)
Script_Bograth_Puzzle4_Complete = bank_address(0x05F2B6)
Script_Cald_Puzzle5_Complete = bank_address(0x062632)
Script_Cald_Puzzle1_Complete = bank_address(0x062C56)
Script_Cald_Puzzle2_Complete = bank_address(0x063088)
Script_Cald_Puzzle3_Complete = bank_address(0x06374F)
Script_Cald_Puzzle4_Complete = bank_address(0x063C77)
Script_dResh_Puzzle2_SecretComplete = bank_address(0x028FC5)
Script_Weave_Puzzle2_SecretComplete = bank_address(0x02A2A2)
Script_KybarsTeeth_Puzzle2_SecretComplete = bank_address(0x0317C2)
Script_Naroom_Puzzle4_SecretComplete = bank_address(0x03F76C)
Script_Arderial_Puzzle3_SecretComplete = bank_address(0x048E6B)
Script_Underneath_Puzzle4_SecretComplete = bank_address(0x055537)
Script_Paradwyn_Puzzle3_SecretComplete = bank_address(0x056B7F)
Script_Core_Puzzle2_SecretComplete = bank_address(0x0589F6)
Script_Bograth_Puzzle2_SecretComplete = bank_address(0x05E796)
Script_Cald_Puzzle2_SecretComplete = bank_address(0x063205)
Script_Orothe_Puzzle1_SecretComplete = bank_address(0x05C404)
Script_StartRoom_SecretComplete = bank_address(0x061F2A)

// Transition: System can be the first frame of the hotspot
// Master takes over when SceneNew(), include the value on the first frame that screen is on for safety purposes
Script_Underneath_Puzzle2_Transition = [bank_address(0x0546D6), bank_address(0x054708)]
Script_Underneath_Puzzle3_Transition = [bank_address(0x054BDC), bank_address(0x054C0E)]
Script_Naroom_Puzzle2_Transition = [bank_address(0x03EF64), bank_address(0x03EF8F)]
Script_Naroom_Puzzle5_Transition = [bank_address(0x03FCFF), bank_address(0x03FD2A)]

Script_EndCredits = bank_address(0x038728) //0E:4728

//////////
// WRAM //
//////////

// The game has 4 different bytecode scripts running simultaneously, pointed to by these 4 variables,
// plus each Actor (49 of them) (up to 10 simultaneously) has 1-2 scripts,
// for a total of 98 different threads, (maximum of 24 simultaneous threads)
// The large majority of achievements simply track the bytecode script pointers running in the intended thread,
// as we know with 100% reliability when these will trigger
wScript_Master = tbyte(0xC70A)
wScript_Scroll = tbyte(0xC711)
wScript_System = tbyte(0xC718)
wScript_Text = tbyte(0xC71F)

wHotspot_Table = word(0xC6DF)
wScreenVisible = byte(0xC959)

wSalafyInvincible = byte(0xC9CB)

wScript_StartButtonDisabled = byte(0xC731)
function start_button_enabled() =>
    wScript_StartButtonDisabled == 0

wActorSave_Flags = byte(0xC188)
function flarp_kicked() =>
    wActorSave_Flags == 1 && prev(wActorSave_Flags) == 0

// Build the wActor array
wActorState = []
wActorX = []
wActorY = []
wActorScriptA = []
wActorScriptB = []
wActor_00 = 0xC1BF
wActor_Offset_State = 1
wActor_Offset_X = 5
wActor_Offset_Y = 6
wActor_Offset_ScriptA = 10
wActor_Offset_ScriptB = 17
wActor_Size = 27
for i in range(0, 0x2F) {
    array_push(wActorState, word(wActor_00 + wActor_Size*i + wActor_Offset_State))
    array_push(wActorX, byte(wActor_00 + wActor_Size*i + wActor_Offset_X))
    array_push(wActorY, byte(wActor_00 + wActor_Size*i + wActor_Offset_Y))
    array_push(wActorScriptA, tbyte(wActor_00 + wActor_Size*i + wActor_Offset_ScriptA))
    array_push(wActorScriptB, tbyte(wActor_00 + wActor_Size*i + wActor_Offset_ScriptB))
}
wActorSalafy = 0xC189
wActorSalafyState = word(wActorSalafy + wActor_Offset_State)
wActorSalafyX = byte(wActorSalafy + wActor_Offset_X)
wActorSalafyY = byte(wActorSalafy + wActor_Offset_Y)
wActorSalafyScriptA = tbyte(wActorSalafy + wActor_Offset_ScriptA)
wActorSalafyScriptB = tbyte(wActorSalafy + wActor_Offset_ScriptB)


//////////
// SRAM //
//////////

xBits_Puzzle_Bits1 = 0xA028
xBits_Puzzle_Bits2 = 0xA029
xBits_Puzzle_Bits3 = 0xA02A
xPuzzle_Misc_2 = byte(0xA133)
xPuzzle_Misc_3_B = byte(0xA13D)

is_Bograth4 = bit2(xBits_Puzzle_Bits3)

xStaffOfHyrenQuest = byte(0xA136)
xOverworld1_SecretsCompleted = byte(0xA138)
xOverworld2_SecretsCompleted = byte(0xA139)

//////////
// Misc //
//////////

wSound_SoundInit = byte(0xC940)
function booted() =>
    wSound_SoundInit == 0x55

function start_screen() =>
    prev(wHotspot_Table) == Hotspot_StartRoom || prev(wHotspot_Table) == 0

function game_loaded() =>
    booted() && no_cheat()

function master(address) =>
    wScript_Master == address
function scroll(address) =>
    wScript_Scroll == address
function system(address) =>
    wScript_System == address
function text(address) =>
    wScript_Text == address

function no_cheat() =>
    always_true()//wSalafyInvincible == 0 TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO TODO


/////////////////////////////
// Puzzle Helper Functions //
/////////////////////////////

ordinals = {
    1: "first",
    2: "second",
    3: "third",
    4: "fourth",
    5: "secret"
}
cardinals = {
    1: "Puzzle 1",
    2: "Puzzle 2",
    3: "Puzzle 3",
    4: "Puzzle 4",
    5: "Secret Puzzle"
}
// "first Underneath puzzle"
function ordinal(puzzle) =>
    ordinals[puzzle["level"]] + " " + puzzle["zone"] + " puzzle"
// "Underneath Puzzle 1"
function cardinal(puzzle) =>
    puzzle["zone"] + " " + cardinals[puzzle["level"]]

// The hotspot for the end of the puzzle is activated
function scene_end(puzzle) =>
    wHotspot_Table == puzzle["hotspot2"]

// The hotspot for the start of the puzzle is activated and the screen turns on
function scene_loads(puzzle) {
    // Hardcoded solution to Bograth 2 and 4 sharing hotspots
    if(puzzle["zone"] == "Bograth" && puzzle["level"] == 2) {
        return increases(wScreenVisible) && wHotspot_Table == puzzle["hotspot"] && is_Bograth4 == 0
    }
    if(puzzle["zone"] == "Bograth" && puzzle["level"] == 4) {
        return increases(wScreenVisible) && wHotspot_Table == puzzle["hotspot"] && is_Bograth4 == 1
    }
    if(puzzle["level"] == 5) {
        // Disable triggering on the secret cutscene as these scenes do not load any hotspots
        return increases(wScreenVisible) && wHotspot_Table == puzzle["hotspot"] && start_button_enabled()
    } else {
        return increases(wScreenVisible) && wHotspot_Table == puzzle["hotspot"]
    }
}


// Either hotspot for a puzzle is activated
function in_scenes(puzzle) {
    if(puzzle["hotspot"] == puzzle["hotspot2"]) {
        return wHotspot_Table == puzzle["hotspot2"]
    } else {
        return __ornext(wHotspot_Table == puzzle["hotspot"] || wHotspot_Table == puzzle["hotspot2"])
    }
}

// The screen turns off (the scene ends)
// Unless there are two hotspots, in which case we permit the screen to be off during the transition
function scene_unloaded(puzzle) {
    if(puzzle["hotspot"] == puzzle["hotspot2"]) {
        return wScreenVisible == 0
    } else {
        return (wScreenVisible == 0) && (wScript_System < puzzle["transition"][0] || wScript_System > puzzle["transition"][1]) && (wScript_Master < puzzle["transition"][0] || wScript_Master > puzzle["transition"][1])
    }
}

// The Congrats textbox opens at the end of a puzzle
function puzzle_end(puzzle) =>
    __ornext(any_of(puzzle["complete"], script => system(script)))
// Only the secret
function puzzle_end_secret(puzzle) =>
    system(puzzle["complete"][1])

// Count the number of times that the parmalags are triggered
// parmalags: total number of parmalag actors
// parmalags_move: maximum number of permitted movements
function parmalags_move(puzzle) =>
    tally_of(range(0, puzzle["parmalags"] - 1), puzzle["parmalags_move"] + 1, i => bit(i, xBits_Puzzle_Bits1) > prev(bit(i, xBits_Puzzle_Bits1)))

// Count the number of times that the arbolits are triggered
// arbolits: total number of arbolit actors
// arbolits_first: the bit offset of the first actor
// arbolits_move: maximum number of permitted movements
function arbolits_move(puzzle) =>
    tally_of(range(0, puzzle["arbolits"] - 1), puzzle["arbolits_move"] + 1, i => bit(i + puzzle["arbolits_first"], xBits_Puzzle_Bits1) > prev(bit(i + puzzle["arbolits_first"], xBits_Puzzle_Bits1)))

// If Salafy is within the bounds of rectangle
// x, y: topleft
// x2, y2: bottomright
function salafy_rectangle(puzzle) =>
    wActorSalafyX >= puzzle["x"] && wActorSalafyX <= puzzle["x2"] && wActorSalafyY >= puzzle["y"] && wActorSalafyY <= puzzle["y2"]

function salafy_locations(puzzle) =>
    tally_of(puzzle["locations"], length(puzzle["locations"]), location => once(wActorSalafyX == location[0] && wActorSalafyY == location[1]))

// Number of times that Salafy uses kicking action
// kicks: max number of kicks
Script_HeroKickLeft = 0x60F514
Script_HeroKickRight = 0x611B14
Script_HeroKickUp = 0x614114
Script_HeroKickDown = 0x616714
script_kicks = [Script_HeroKickLeft, Script_HeroKickRight, Script_HeroKickUp, Script_HeroKickDown]
function salafy_kicks_block(puzzle) =>
    repeated(puzzle["kicks"] + 1, any_of(script_kicks, script => wActorSalafyScriptA == script))

function salafy_kicks_flarp(puzzle) =>
    repeated(puzzle["kicks"] + 1, flarp_kicked())


function min_bubbles(puzzle) =>
    xPuzzle_Misc_2 >= puzzle["bubbles"]


function actor_moved(puzzle) =>
    wActorX[puzzle["actor"]] != puzzle["x"] || wActorY[puzzle["actor"]] != puzzle["y"]


function thirst_count(puzzle) =>
    repeated(puzzle["drinks"] + 1, puzzle["thirst_byte"] == 14 && prev(puzzle["thirst_byte"] < 14))


function dresh5_chunks(puzzle) =>
    tally_of(range(1, 20), 20, chunk_id => once(xPuzzle_Misc_2 == chunk_id && prev(xPuzzle_Misc_2) != xPuzzle_Misc_2)) // We check the delta as on puzzle init we would otherwise hit a random chunk

function dresh2_mud_count(puzzle) =>
    repeated(puzzle["tiles"] + 1, xPuzzle_Misc_2 > prev(xPuzzle_Misc_2))

function dresh4_switch_count(puzzle) =>
    repeated(puzzle["triggers"] + 1, xPuzzle_Misc_3_B > prev(xPuzzle_Misc_3_B)) // n.b. this fails when you hit the switch 9 times as the var rolls back to 0, but we Pause Lock before then so it doesn't matter

/*
RATOOLS 1.14.1 bugs out with this setup
function pow(exponent) {
    n = 1
    for i in range(1, exponent) {
        n = n*2
    }
    return n
}

function bitmask(bits) =>
    pow(bits) - 1
    
function core_switch_count(puzzle) =>
    repeated(puzzle["presses"], (dword(xBits_Puzzle_Bits1) & bitmask(puzzle["switches"])) > (prev(dword(xBits_Puzzle_Bits1)) & bitmask(puzzle["switches"]))) && byte(0) == pow(9)
*/

function _generate_bitcount(address, bits) {
    if(bits >= 8) {
        return _generate_bitcount(address + 1, bits - 8) + bitcount(address)
    }
    if(bits == 0) {
        return 0
    }
    return sum_of(range(0, bits - 1), i => bit(i, address))
}

function generate_bitcount(bits) {
    address = xBits_Puzzle_Bits1
    return _generate_bitcount(xBits_Puzzle_Bits1, bits)
}


function core_switch_count(puzzle) =>
    repeated(puzzle["presses"] + 1, generate_bitcount(puzzle["switches"]) > prev(generate_bitcount(puzzle["switches"])))

// Map to virtual address https://github.com/RetroAchievements/rcheevos/blob/develop/src/rcheevos/consoleinfo.c#L456
function wram(address, bank) =>
    byte(address - 0xD000 + 0x10000 + 0x1000*(bank-2))
core_beacon_on_tileid = 0x6F
core5_tiles = [0xD2E9, 0xD2ED, 0xD055, 0xD056, 0xD057]
function core4_count(puzzle) =>
    all_of(core5_tiles, tile_addr => wram(tile_addr, 3) == core_beacon_on_tileid)


//////////////////
// Achievements //
//////////////////



// hotspot: Scene load hotspot
// hotspot2: 0, or else hotspot for the second part of the puzzle
// complete: [Script_Complete, Script_SecretComplete]
// title, points
// title2, points2: for challenge achievement
//
// speedrun
// time (string), frames: for speedrun
//


function puzzle(puz) {
    achievement(
        title = cardinal(puz) + puz["title"], // TODO remove cardinal(puz)
        points = puz["points"],
        description = "Complete the " + ordinal(puz),
        trigger = game_loaded() && scene_end(puz) && puzzle_end(puz)
    )
}
function normal_only(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: " + puz["desc2"],
        trigger = game_loaded() && scene_end(puz) && system(puz["complete"][0])
    )
}
function timeboard(puz) {
    leaderboard(
        title = cardinal(puz),
        description = "Fastest time in the " + ordinal(puz),
        start = game_loaded() && scene_loads(puz),
        cancel = scene_unloaded(puz),
        submit = puzzle_end(puz),
        value = always_true(),
        format = "FRAMES",
        lower_is_better = true
    )
}
function speedrun(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " in under " + puz["time"],
        trigger = game_loaded() && in_scenes(puz) && disable_when(repeated(puz["frames"], always_true()), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function speedrun_secret(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: " + puz["desc2"],
        trigger = game_loaded() && in_scenes(puz) && disable_when(repeated(puz["frames"], always_true()), until=scene_loads(puz)) && trigger_when(puzzle_end_secret(puz))
    )
}
function parmalag_avoid(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " without triggering Parmalags more than " + puz["parmalags_move"] + " times",
        trigger = game_loaded() && in_scenes(puz) && disable_when(parmalags_move(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function arbolits_avoid(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " without triggering Arbolits more than " + puz["arbolits_move"] + " times",
        trigger = game_loaded() && in_scenes(puz) && disable_when(arbolits_move(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function enter_box(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: " + puz["desc2"],
        trigger = game_loaded() && in_scenes(puz) && never(scene_unloaded(puz)) && once(salafy_rectangle(puz)) && trigger_when(puzzle_end(puz))
    )
}
function enter_locations(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: " + puz["desc2"],
        trigger = game_loaded() && in_scenes(puz) && never(scene_unloaded(puz)) && once(salafy_locations(puz)) && trigger_when(puzzle_end(puz))
    )
}
function kicks(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " whilst kicking no more than " + puz["kicks"] + " times",
        trigger = game_loaded() && in_scenes(puz) && disable_when(salafy_kicks_block(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function bubbles(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " with at least " + puz["bubbles"] + " bubbles",
        trigger = game_loaded() && in_scenes(puz) && min_bubbles(puz) && trigger_when(puzzle_end(puz))
    )
}
function flarps(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " whilst kicking Flarps no more than " + puz["kicks"] + " times",
        trigger = game_loaded() && in_scenes(puz) && disable_when(salafy_kicks_flarp(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function actor_still(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: " + puz["desc2"],
        trigger = game_loaded() && in_scenes(puz) && disable_when(actor_moved(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function thirst(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " whilst drinking no more than " + puz["drinks"] + " times",
        trigger = game_loaded() && in_scenes(puz) && disable_when(thirst_count(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function dresh5(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " after exploring the entire map",
        trigger = game_loaded() && never(scene_unloaded(puz)) && measured(dresh5_chunks(puz), when=in_scenes(puz)) && puzzle_end(puz)
    )
}
function enter_locations(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: " + puz["desc2"],
        trigger = game_loaded() && never(scene_unloaded(puz)) && measured(salafy_locations(puz), when=in_scenes(puz)) && puzzle_end(puz)
    )
}
function dresh2_mud(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " whilst triggering a mudslide no more than " + puz["tiles"] + " times",
        trigger = game_loaded() && in_scenes(puz) && is_Bograth4 == 0 && disable_when(dresh2_mud_count(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function dresh4_switch(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: Complete the " + ordinal(puz) + " whilst only pressing the last three switches no more than " + puz["triggers"] + " times",
        trigger = game_loaded() && in_scenes(puz) && is_Bograth4 == 1 && disable_when(dresh4_switch_count(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function core_switches(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: " + puz["desc2"],
        trigger = game_loaded() && in_scenes(puz) && disable_when(core_switch_count(puz), until=scene_loads(puz)) && trigger_when(puzzle_end(puz))
    )
}
function core4(puz) {
    achievement(
        title = puz["title2"],
        points = puz["points2"],
        description = "Challenge: " + puz["desc2"],
        trigger = game_loaded() && in_scenes(puz) && core4_count(puz) && trigger_when(puzzle_end(puz))
    )
}
function no_challenge(puz) {
    return 0
}


function add_puzzle(zone, level, puz) {
    key = zone + level
    puz["zone"] = zone
    puz["level"] = level
    if(puz["hotspot2"] == 0) {
        puz["hotspot2"] = puz["hotspot"]
    }
    puzzle(puz)
    timeboard(puz)

    //puz["challenge"](puz) // crashes in 1.14.1 so
    challenge = puz["challenge"]
    challenge(puz)
}
add_puzzle("Underneath", 1, {
    "hotspot": Hotspot_Underneath_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Underneath_Puzzle1_Complete],
    "title": "World 1-1",
    "points": 1,
    "challenge": speedrun,
    "title2": "Off to a Great Start",
    "points2": 2,
    "time": "7 seconds",
    "frames": 7*60 - 1
})
add_puzzle("Underneath", 2, {
    "hotspot": Hotspot_Underneath_Puzzle2,
    "hotspot2": Hotspot_Underneath_Puzzle4,
    "transition": Script_Underneath_Puzzle2_Transition,
    "complete": [Script_Underneath_Puzzle2_Complete],
    "title": "Parmalag Ball",
    "points": 1,
    "challenge": parmalag_avoid,
    "title2": "Efficient Steps",
    "points2": 3,
    "parmalags": 5,
    "parmalags_move": 4,
})
add_puzzle("Underneath", 3, {
    "hotspot": Hotspot_Underneath_Puzzle3,
    "hotspot2": Hotspot_Underneath_Puzzle4,
    "transition": Script_Underneath_Puzzle3_Transition,
    "complete": [Script_Underneath_Puzzle3_Complete],
    "title": "Parmalag Implosion",
    "points": 1,
    "challenge": speedrun,
    "title2": "Panic Run",
    "points2": 2,
    "time": "5 seconds",
    "frames": 5*60 - 1
})
add_puzzle("Underneath", 4, {
    "hotspot": Hotspot_Underneath_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_Underneath_Puzzle4_Complete, Script_Underneath_Puzzle4_SecretComplete],
    "title": "Digging Out",
    "points": 5,
    "challenge": enter_box,
    "title2": "Exploration",
    "points2": 3,
    "desc2": "Head to the bottom-right corner of the puzzle, then turn around and finish the puzzle in the top-right corner",
    "x": 0x1A,
    "y": 0x13,
    "x2": 0x1C,
    "y2": 0x17
})
add_puzzle("Underneath", 5, {
    "hotspot": Hotspot_Underneath_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_Underneath_Puzzle5_Complete],
    "title": "Secret Mission",
    "points": 5,
    "challenge": parmalag_avoid,
    "title2": "Brainiac",
    "points2": 4,
    "parmalags": 11,
    "parmalags_move": 11,
})
add_puzzle("Cald", 1, {
    "hotspot": Hotspot_Cald_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Cald_Puzzle1_Complete],
    "title": "Getting Hot",
    "points": 1,
    "challenge": speedrun,
    "title2": "Sweating It Out",
    "points2": 2,
    "time": "10 seconds",
    "frames": 10*60 - 1
})
add_puzzle("Cald", 2, {
    "hotspot": Hotspot_Cald_Puzzle2,
    "hotspot2": 0,
    "complete": [Script_Cald_Puzzle2_Complete, Script_Cald_Puzzle2_SecretComplete],
    "title": "Valkan's Arbolits",
    "points": 1,
    "challenge": speedrun,
    "title2": "Valkan's ArboLit!",
    "points2": 2,
    "time": "7 seconds",
    "frames": 7*60 - 1
})
add_puzzle("Cald", 3, {
    "hotspot": Hotspot_Cald_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_Cald_Puzzle3_Complete],
    "title": "Button Masher",
    "points": 1,
    "challenge": arbolits_avoid,
    "title2": "Button Clicker",
    "points2": 2,
    "arbolits_first": 1,
    "arbolits": 10,
    "arbolits_move": 10
})
add_puzzle("Cald", 4, {
    "hotspot": Hotspot_Cald_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_Cald_Puzzle4_Complete],
    "title": "Out of the Hot Tub",
    "points": 5,
    "challenge": arbolits_avoid,
    "title2": "Button Avoider",
    "points2": 3,
    "arbolits_first": 1,
    "arbolits": 9,
    "arbolits_move": 8
})
add_puzzle("Cald", 5, {
    "hotspot": Hotspot_Cald_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_Cald_Puzzle5_Complete],
    "title": "Loop-de-Loop",
    "points": 5,
    "challenge": speedrun,
    "title2": "Rollercoaster",
    "points2": 3,
    "time": "14 seconds",
    "frames": 14*60 - 1
})
add_puzzle("Naroom", 1, {
    "hotspot": Hotspot_Naroom_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Naroom_Puzzle1_Complete],
    "title": "Home",
    "points": 3,
    "challenge": kicks,
    "title2": "Broken Toe",
    "points2": 3,
    "kicks": 57
})
add_puzzle("Naroom", 2, {
    "hotspot": Hotspot_Naroom_Puzzle2,
    "hotspot2": Hotspot_Naroom_Puzzle25_End,
    "transition": Script_Naroom_Puzzle2_Transition,
    "complete": [Script_Naroom_Puzzle2_Complete],
    "title": "Diggy Hole",
    "points": 3,
    "challenge": speedrun,
    "title2": "Shovelling Like No Tomorrow",
    "points2": 3,
    "time": "1 minute",
    "frames": 60*60 - 1
})
add_puzzle("Naroom", 3, {
    "hotspot": Hotspot_Naroom_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_Naroom_Puzzle3_Complete],
    "title": "Two Ways",
    "points": 3,
    "challenge": kicks,
    "title2": "Left Way",
    "points2": 3,
    "kicks": 44
})
add_puzzle("Naroom", 4, {
    "hotspot": Hotspot_Naroom_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_Naroom_Puzzle4_Complete, Script_Naroom_Puzzle4_SecretComplete],
    "title": "The Great Divide",
    "points": 5,
    "challenge": normal_only,
    "title2": "Too Many Blocks",
    "points2": 3,
    "desc2": "Complete the fourth Naroom puzzle via the top route"
})
add_puzzle("Naroom", 5, {
    "hotspot": Hotspot_Naroom_Puzzle5,
    "hotspot2": Hotspot_Naroom_Puzzle25_End,
    "transition": Script_Naroom_Puzzle5_Transition,
    "complete": [Script_Naroom_Puzzle5_Complete],
    "title": "Star Wars",
    "points": 3,
    "challenge": speedrun,
    "title2": "Podrace",
    "points2": 3,
    "time": "13 seconds",
    "frames": 13*60 - 1
})
add_puzzle("Orothe", 1, {
    "hotspot": Hotspot_Orothe_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Orothe_Puzzle1_Complete, Script_Orothe_Puzzle1_SecretComplete],
    "title": "Water Hazard",
    "points": 3,
    "challenge": bubbles,
    "title2": "Bubbles!",
    "points2": 3,
    "bubbles": 2,
})
add_puzzle("Orothe", 2, {
    "hotspot": Hotspot_Orothe_Puzzle2,
    "hotspot2": 0,
    "complete": [Script_Orothe_Puzzle2_Complete],
    "title": "Abaquists",
    "points": 3,
    "challenge": bubbles,
    "title2": "Watermazing",
    "points2": 3,
    "bubbles": 2,
})
add_puzzle("Orothe", 3, {
    "hotspot": Hotspot_Orothe_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_Orothe_Puzzle3_Complete],
    "title": "Switchfusion",
    "points": 3,
    "challenge": bubbles,
    "title2": "Untouchable",
    "points2": 3,
    "bubbles": 3,
})
add_puzzle("Orothe", 4, {
    "hotspot": Hotspot_Orothe_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_Orothe_Puzzle4_Complete],
    "title": "Tic Tac Toe",
    "points": 3,
    "challenge": speedrun,
    "title2": "TicTacToe!",
    "points2": 3,
    "time": "70 seconds",
    "frames": 70*60 - 1
})
add_puzzle("Orothe", 5, {
    "hotspot": Hotspot_Orothe_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_Orothe_Puzzle5_Complete],
    "title": "Back to Square One",
    "points": 3,
    "challenge": bubbles,
    "title2": "Blocktastic",
    "points2": 3,
    "bubbles": 3,
})
add_puzzle("Arderial", 1, {
    "hotspot": Hotspot_Arderial_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Arderial_Puzzle1_Complete],
    "title": "Islands in the Sky",
    "points": 3,
    "challenge": flarps,
    "title2": "Flarping Around",
    "points2": 3,
    "kicks": 19
})
add_puzzle("Arderial", 2, {
    "hotspot": Hotspot_Arderial_Puzzle2,
    "hotspot2": 0,
    "complete": [Script_Arderial_Puzzle2_Complete],
    "title": "Stacks of Flarps",
    "points": 3,
    "challenge": speedrun,
    "title2": "Flarp Juggling",
    "points2": 3,
    "time": "75 seconds",
    "frames": 75*60 - 1
})
add_puzzle("Arderial", 3, {
    "hotspot": Hotspot_Arderial_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_Arderial_Puzzle3_Complete, Script_Arderial_Puzzle3_SecretComplete],
    "title": "Flarp Wall",
    "points": 3,
    "challenge": actor_still,
    "title2": "Flarp Hop",
    "points2": 3,
    "desc2": "Complete the third Arderial puzzle without moving the topleft Flarp",
    "actor": 14 - 2,
    "x": 0x0C,
    "y": 0x03
})
add_puzzle("Arderial", 4, {
    "hotspot": Hotspot_Arderial_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_Arderial_Puzzle4_Complete],
    "title": "Quartered",
    "points": 5,
    "challenge": speedrun,
    "title2": "Piece of Pie",
    "points2": 3,
    "time": "40 seconds",
    "frames": 40*60 - 1
})
add_puzzle("Arderial", 5, {
    "hotspot": Hotspot_Arderial_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_Arderial_Puzzle5_Complete],
    "title": "Pepe Silvia",
    "points": 3,
    "challenge": flarps,
    "title2": "Detective",
    "points2": 3,
    "kicks": 15
})
add_puzzle("Weave", 1, {
    "hotspot": Hotspot_Weave_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Weave_Puzzle1_Complete],
    "title": "Blocky Jungle",
    "points": 3,
    "challenge": speedrun,
    "title2": "Kick Kick",
    "points2": 3,
    "time": "70 seconds",
    "frames": 70*60 - 1
})
add_puzzle("Weave", 2, {
    "hotspot": Hotspot_Weave_Puzzle2,
    "hotspot2": 0,
    "complete": [Script_Weave_Puzzle2_Complete, Script_Weave_Puzzle2_SecretComplete],
    "title": "Flarps and Blocks",
    "points": 3,
    "challenge": normal_only,
    "title2": "Blocks and Flarps",
    "points2": 3,
    "desc2": "Complete the second Weave puzzle via the middle top route"
})
add_puzzle("Weave", 3, {
    "hotspot": Hotspot_Weave_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_Weave_Puzzle3_Complete],
    "title": "Flarp Conveyer",
    "points": 3,
    "challenge": flarps,
    "title2": "Flarp Chain",
    "points2": 3,
    "kicks": 45 // I see a solution for 42, but let's be a bit generous
})
add_puzzle("Weave", 4, {
    "hotspot": Hotspot_Weave_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_Weave_Puzzle4_Complete],
    "title": "Flarp Highway",
    "points": 3,
    "challenge": flarps,
    "title2": "Getting the Hang of This",
    "points2": 3,
    "kicks": 35 // I see a solution for 29, but let's be a bit generous
})
add_puzzle("Weave", 5, {
    "hotspot": Hotspot_Weave_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_Weave_Puzzle5_Complete],
    "title": "Shooty Tooty",
    "points": 3,
    "challenge": speedrun,
    "title2": "Dodgey Modgey",
    "points2": 3,
    "time": "14 seconds",
    "frames": 14*60 - 1
})
add_puzzle("d'Resh", 1, {
    "hotspot": Hotspot_dResh_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_dResh_Puzzle1_Complete],
    "title": "Grand Canyon",
    "points": 3,
    "challenge": speedrun,
    "title2": "Daredevil",
    "points2": 3,
    "time": "90 seconds",
    "frames": 90*60 - 1
})
add_puzzle("d'Resh", 2, {
    "hotspot": Hotspot_dResh_Puzzle2,
    "hotspot2": 0,
    "complete": [Script_dResh_Puzzle2_Complete, Script_dResh_Puzzle2_SecretComplete],
    "title": "Dehydration",
    "points": 3,
    "challenge": thirst,
    "title2": "Hydro Homie",
    "points2": 3,
    "thirst_byte": xPuzzle_Misc_2,
    "drinks": 2
})
add_puzzle("d'Resh", 3, {
    "hotspot": Hotspot_dResh_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_dResh_Puzzle3_Complete],
    "title": "Merry-Go-Round",
    "points": 3,
    "challenge": flarps,
    "title2": "Precision Operator",
    "points2": 3,
    "kicks": 21
})
add_puzzle("d'Resh", 4, {
    "hotspot": Hotspot_dResh_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_dResh_Puzzle4_Complete],
    "title": "Laser Watch",
    "points": 3,
    "challenge": speedrun,
    "title2": "Cyclops",
    "points2": 3,
    "time": "40 seconds",
    "frames": 40*60 - 1
})
add_puzzle("d'Resh", 5, {
    "hotspot": Hotspot_dResh_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_dResh_Puzzle5_Complete],
    "title": "Searching for the Oacis",
    "points": 3,
    "challenge": dresh5,
    "title2": "Cartographer",
    "points2": 3,
})
add_puzzle("Kybar's Teeth", 1, {
    "hotspot": Hotspot_KybarsTeeth_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_KybarsTeeth_Puzzle1_Complete],
    "title": "Cacophony",
    "points": 3,
    "challenge": speedrun,
    "title2": "Pure Chaos",
    "points2": 3,
    "time": "2 seconds",
    "frames": 2*60 - 1
})
add_puzzle("Kybar's Teeth", 2, {
    "hotspot": Hotspot_KybarsTeeth_Puzzle2,
    "hotspot2": 0,
    "complete": [Script_KybarsTeeth_Puzzle2_Complete, Script_KybarsTeeth_Puzzle2_SecretComplete],
    "title": "Cave In",
    "points": 3,
    "challenge": enter_locations,
    "title2": "Spelunker",
    "points2": 3,
    "desc2": "Complete the second Kybar's Teeth puzzle after stepping on all 3 grey moons in the middle of the first room",
    "locations": [[15, 52], [12, 58], [18, 56]]
})
add_puzzle("Kybar's Teeth", 3, {
    "hotspot": Hotspot_KybarsTeeth_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_KybarsTeeth_Puzzle3_Complete],
    "title": "More Parmlagas",
    "points": 3,
    "challenge": parmalag_avoid,
    "title2": "No Time for Chit-Chat",
    "points2": 4,
    "parmalags": 8,
    "parmalags_move": 8,
})
add_puzzle("Kybar's Teeth", 4, {
    "hotspot": Hotspot_KybarsTeeth_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_KybarsTeeth_Puzzle4_Complete],
    "title": "Stop With the Parmalags",
    "points": 3,
    "challenge": speedrun,
    "title2": "Dancing with the Parmalags",
    "points2": 3,
    "time": "11 seconds",
    "frames": 11*60 - 1
})
add_puzzle("Kybar's Teeth", 5, {
    "hotspot": Hotspot_KybarsTeeth_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_KybarsTeeth_Puzzle5_Complete],
    "title": "Moga Stampede",
    "points": 3,
    "challenge": speedrun,
    "title2": "Moga Pup, Moba What?",
    "points2": 3,
    "time": "3 seconds",
    "frames": 3*60 - 1
})
add_puzzle("Bograth", 1, {
    "hotspot": Hotspot_Bograth_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Bograth_Puzzle1_Complete],
    "title": "Trekking Through Mud",
    "points": 3,
    "challenge": parmalag_avoid,
    "title2": "Keeping Dry",
    "points2": 4,
    "parmalags": 12,
    "parmalags_move": 12,
})
add_puzzle("Bograth", 2, {
    "hotspot": Hotspot_Bograth_Puzzle24, // Hardcoded differentiation of these two hotspots in the mud function
    "hotspot2": 0,
    "complete": [Script_Bograth_Puzzle2_Complete, Script_Bograth_Puzzle2_SecretComplete],
    "title": "Bogged Down",
    "points": 3,
    "challenge": dresh2_mud,
    "title2": "Conserving Energy",
    "points2": 4,
    "tiles": 54 //52 is possible but let's give a bit of leeway
})
add_puzzle("Bograth", 3, {
    "hotspot": Hotspot_Bograth_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_Bograth_Puzzle3_Complete],
    "title": "Need a Wash",
    "points": 3,
    "challenge": parmalag_avoid,
    "title2": "Tight Corners",
    "points2": 4,
    "parmalags": 8,
    "parmalags_move": 8,
})
add_puzzle("Bograth", 4, {
    "hotspot": Hotspot_Bograth_Puzzle24, // Hardcoded differentiation of these two hotspots in the mud function
    "hotspot2": 0,
    "complete": [Script_Bograth_Puzzle4_Complete],
    "title": "Ganges",
    "points": 3,
    "challenge": dresh4_switch,
    "title2": "Genius",
    "points2": 4,
    "triggers": 4
})
add_puzzle("Bograth", 5, {
    "hotspot": Hotspot_Bograth_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_Bograth_Puzzle5_Complete],
    "title": "Parmesan Cheese",
    "points": 3,
    "challenge": speedrun,
    "title2": "Grating Fast",
    "points2": 3,
    "time": "13 seconds",
    "frames": 13*60 - 1
})
add_puzzle("Paradwyn", 1, {
    "hotspot": Hotspot_Paradwyn_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Paradwyn_Puzzle1_Complete],
    "title": "Paradise Lost",
    "points": 3,
    "challenge": speedrun,
    "title2": "Star Trek",
    "points2": 3,
    "time": "30 seconds",
    "frames": 30*60 - 1
})
add_puzzle("Paradwyn", 2, {
    "hotspot": Hotspot_Paradwyn_Puzzle2,
    "hotspot2": 0,
    "complete": [Script_Paradwyn_Puzzle2_Complete],
    "title": "Headache",
    "points": 3,
    "challenge": speedrun,
    "title2": "Memorized",
    "points2": 3,
    "time": "50 seconds",
    "frames": 50*60 - 1
})
add_puzzle("Paradwyn", 3, {
    "hotspot": Hotspot_Paradwyn_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_Paradwyn_Puzzle3_Complete, Script_Paradwyn_Puzzle3_SecretComplete],
    "title": "Tropical Fun",
    "points": 3,
    "challenge": speedrun_secret,
    "title2": "Marathon Swimmer",
    "points2": 3,
    "desc2": "Complete the third Paradwyn puzzle after hitting all 4 switches in under 40 seconds",
    "time": "40 seconds",
    "frames": 40*60 - 1
})
add_puzzle("Paradwyn", 4, {
    "hotspot": Hotspot_Paradwyn_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_Paradwyn_Puzzle4_Complete],
    "title": "Ancient Guardian",
    "points": 3,
    "challenge": kicks,
    "title2": "Nimble Link",
    "points2": 3,
    "kicks": 25
})
add_puzzle("Paradwyn", 5, {
    "hotspot": Hotspot_Paradwyn_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_Paradwyn_Puzzle5_Complete],
    "title": "A Whirl of Fun",
    "points": 3,
    "challenge": speedrun,
    "title2": "Vortex Man",
    "points2": 3,
    "time": "1 minute",
    "frames": 60*60 - 1
})
add_puzzle("Core", 1, {
    "hotspot": Hotspot_Core_Puzzle1,
    "hotspot2": 0,
    "complete": [Script_Core_Puzzle1_Complete],
    "title": "Endless Pit",
    "points": 3,
    "challenge": speedrun,
    "title2": "Tightrope Walking",
    "points2": 3,
    "time": "20 seconds",
    "frames": 20*60 - 1
})
add_puzzle("Core", 2, {
    "hotspot": Hotspot_Core_Puzzle2,
    "hotspot2": 0,
    "complete": [Script_Core_Puzzle2_Complete, Script_Core_Puzzle2_SecretComplete],
    "title": "Why Do I Keep Falling?",
    "points": 3,
    "challenge": core_switches,
    "title2": "Again and Again",
    "points2": 3,
    "desc2": "Complete the second Core puzzle whilst pressing no more than 10 switches",
    "switches": 9, // We are only counting the 9 outside switches, and not the 5 inner ones since we know they will all be pressed once
    "presses": 5, // We are only counting the outside switches since the 5 inner ones must all be pressed once and can only be pressed once
})
add_puzzle("Core", 3, {
    "hotspot": Hotspot_Core_Puzzle3,
    "hotspot2": 0,
    "complete": [Script_Core_Puzzle3_Complete],
    "title": "Game of Chance",
    "points": 3,
    "challenge": speedrun,
    "title2": "Card Counter",
    "points2": 3,
    "time": "30 seconds",
    "frames": 30*60 - 1
})
add_puzzle("Core", 4, {
    "hotspot": Hotspot_Core_Puzzle4,
    "hotspot2": 0,
    "complete": [Script_Core_Puzzle4_Complete],
    "title": "Final Level",
    "points": 3,
    "challenge": core4,
    "title2": "Don't Skip the Dishes",
    "desc2": "Complete the fourth Core puzzle after lighting up all 5 beacons on the right side of the map",
    "points2": 3,
})
add_puzzle("Core", 5, {
    "hotspot": Hotspot_Core_Puzzle5,
    "hotspot2": 0,
    "complete": [Script_Core_Puzzle5_Complete],
    "title": "Agram's Puzzle",
    "points": 3,
    "challenge": no_challenge, // Let's be nice, no challenge for this one
})


Script_WeaveStatue1 = bank_address(0x027D74)
Script_WeaveStatue2 = bank_address(0x027DDA)
achievement(
    title = "Yaki's Secret",
    points = 1,
    description = "Learn how to open the Training Room closet by finding the instructions on two of the Weave statues",
    trigger = game_loaded() && measured(tally_of([Script_WeaveStatue1, Script_WeaveStatue2], 2, script => once(system(script))))
)

function ending_core_wand() =>
    xStaffOfHyrenQuest == 1 && xOverworld2_SecretsCompleted == 5

function ending_core_crystal() =>
    xStaffOfHyrenQuest == 2 && xOverworld1_SecretsCompleted == 5 && xOverworld2_SecretsCompleted == 5

function ending_core_backup() =>
    xStaffOfHyrenQuest == 3 && xOverworld2_SecretsCompleted == 5

function ending_normal_vash() =>
    (xStaffOfHyrenQuest == 1 || xStaffOfHyrenQuest == 3) && xOverworld2_SecretsCompleted < 5

function ending_normal_glade() =>
    (xStaffOfHyrenQuest == 2 && xOverworld1_SecretsCompleted + xOverworld2_SecretsCompleted < 10) ||
    (xStaffOfHyrenQuest == 0)

function credits(title, points, desc, func) {
    achievement(
        title = title,
        points = points,
        description = desc,
        trigger = game_loaded() && master(Script_EndCredits) && func()
    )
}

credits(
    "Good Ending 1: Vanilla Victory",
    25, "Beat the Core after finding all 10 pieces of the Staff of Hyren, choosing to pursue the Wand first",
    ending_core_wand
)
credits(
    "Good Ending 2: Tyranny",
    25, "Beat the Core after finding all 10 pieces of the Staff of Hyren, choosing to pursue the Crystal first",
    ending_core_crystal
)
credits(
    "Good Ending 3: Lower Taxes",
    25, "Beat the Core after finding 0-4 Wand pieces, then finding all the Crystal pieces. If prompted, choose to pursue the Wand first",
    ending_core_backup
)
credits(
    "Normal Ending 1: Keeper's Staff",
    10, "Beat Paradwyn after finding no pieces of the Staff of Hyren at all, or alternatively beat Arderial after choosing to pursue the Crystal first while finding only 1-9 pieces of the Staff of Hyren",
    ending_normal_glade
)
credits(
    "Normal Ending 2: Crystal Pendant",
    10, "Beat Paradwyn after finding 0-4 Wand pieces, then finding 1-4 Crystal pieces. If prompted, choose to pursue the Wand first",
    ending_normal_vash
)

//Ormagon

// DONT FORGET TO ADD INVINCIBILITY CHECK

// Unlock TUrret room secret
// Beat turret room
// 