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
Script_StartRoom_SecretComplete = bank_address(0x061F2A)

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
wActorTony = 0xC189
function wActorTonyState() => word(wActorTony + wActor_Offset_State)
function wActorTonyX() => byte(wActorTony + wActor_Offset_X)
function wActorTonyY() => byte(wActorTony + wActor_Offset_Y)
function wActorTonyScriptA() => tbyte(wActorTony + wActor_Offset_ScriptA)
function wActorTonyScriptB() => tbyte(wActorTony + wActor_Offset_ScriptB)

//////////
// Misc //
//////////

wSound_SoundInit = byte(0xC940)
function booted() =>
    wSound_SoundInit == 0x55

function start_screen() =>
    prev(wHotspot_Table) == Hotspot_StartRoom || prev(wHotspot_Table) == 0

function game_loaded() =>
    booted() && !start_screen() && no_cheat()

function scene_loaded(hotspot) =>
    increases(wScreenVisible) && wHotspot_Table == hotspot

function scene_unloaded() =>
    wScreenVisible == 0

function system(address) =>
    wScript_System == address

function no_cheat() => wSalafyInvincible == 0
    
//////////////////
// Achievements //
//////////////////

achievement(
    title = "Underneath 1", points = 1,
    description = "Complete Underneath 1",
    trigger = game_loaded() && system(Script_Underneath_Puzzle1_Complete)
)
leaderboard(
    title = "Underneath Puzzle 1",
    description = "Fastest time in Underneath Puzzle 1",
    start = game_loaded() && scene_loaded(Hotspot_Underneath_Puzzle1),
    cancel = scene_unloaded(),
    submit = system(Script_Underneath_Puzzle1_Complete),
    value = always_true(),
    format = "FRAMES",
    lower_is_better = true
)

