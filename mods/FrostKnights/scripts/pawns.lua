
local mod = modApi:getCurrentMod()
local autoOffset = 0 -- this and the function below sets the default squad palette to the colors in palettes.lua

local id = modApi:getPaletteImageOffset(mod.id)
if id ~= nil then
	autoOffset = id
end

-- pulled out of the filepaths for easier editing
-- put the folder names for each mech here
local mech1 = "primary"
local mech2 = "tertiary"
local mech3 = "secondary"

Yeti_MeleeMech = Pawn:new{ -- look at the base game pawns.lua for examples!
	Name = "Yeti Mech",
	Class = "Prime",
	Health = 3,
	MoveSpeed = 3,
	Massive = true,
	Image = mech1 .. "_mech", 
	
	ImageOffset = autoOffset, -- this is the default palette, keep it on autoOffset to make it use yours

	SkillList = { "Cryobash_Punch"}, -- this is the weapon ID(s) they start with
	SoundLocation = "/mech/prime/punch_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}

Trebuchet_ArtilleryMech = Pawn:new{
	Name = "Trebuchet Mech",
	Class = "Ranged",
	Health = 3,
	MoveSpeed = 3,
	Massive = true,
	Image = mech2 .. "_mech", 
	
	ImageOffset = autoOffset,

	SkillList = {"Trebuchet_Arty"},
	SoundLocation = "/mech/ranged/ranged_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}

CoolFire_ScienceMech = Pawn:new{
	Name = "Cool Fire Mech",
	Class = "Science",
	Health = 2,
	MoveSpeed = 4,
	Massive = true,
	Flying = true,
	Image = mech3 .. "_mech", 
	
	ImageOffset = autoOffset,

	SkillList = {"Heat_Converter"},
	SoundLocation = "/mech/science/science_mech/",
	ImpactMaterial = IMPACT_METAL,
	DefaultTeam = TEAM_PLAYER,
}

 -- everything below here adds the images from /units/
 -- if your images are misaligned (and they will be) adjust the PosX and PosY to fix them
 -- PosX negative is left, PosX positive is right; PosY negative is up, PosY positive is down

local path = mod_loader.mods[modApi.currentMod].resourcePath

local files = {
	"mech.png", -- default, with shadow
	"mech_a.png", -- animated sprite sheet
	"mech_w.png", -- in water
	"mech_w_broken.png", -- dead in water
	"mech_broken.png", -- dead on land
	"mech_ns.png", -- no shadow, used in menus
	"mech_h.png" -- shading for hangar, inherits PosX PosY from mech_a, adding 8 rows to the bottom of the sprite can help alignment
}

local mechPath = path .."img/units/" .. mech1 .. "/"

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/" .. mech1 .. "_".. file, mechPath .. file)
end

local a = ANIMS
a[mech1 .. "_mech"] =			a.MechUnit:new{Image = "units/player/" .. mech1 .. "_mech.png", PosX = -18, PosY = 0}
a[mech1 .. "_mecha"] =			a.MechUnit:new{Image = "units/player/" .. mech1 .. "_mech_a.png", PosX = -18, PosY = 0, NumFrames = 4 }
a[mech1 .. "_mechw"] =			a.MechUnit:new{Image = "units/player/" .. mech1 .. "_mech_w.png", PosX = -17, PosY = 8 }
a[mech1 .. "_mech_broken"] =	a.MechUnit:new{Image = "units/player/" .. mech1 .. "_mech_broken.png", PosX = -17, PosY = -2 }
a[mech1 .. "_mechw_broken"] =	a.MechUnit:new{Image = "units/player/" .. mech1 .. "_mech_w_broken.png", PosX = -17, PosY = 12 }
a[mech1 .. "_mech_ns"] =		a.MechIcon:new{Image = "units/player/" .. mech1 .. "_mech_ns.png"}

mechPath = path .."img/units/" .. mech2 .. "/"

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/" .. mech2 .. "_".. file, mechPath .. file)
end

a[mech2 .. "_mech"] =			a.MechUnit:new{Image = "units/player/" .. mech2 .. "_mech.png", PosX = -30, PosY = -10}
a[mech2 .. "_mecha"] =			a.MechUnit:new{Image = "units/player/" .. mech2 .. "_mech_a.png", PosX = -30, PosY = -10, NumFrames = 36, Time = 0.085 }
a[mech2 .. "_mechw"] =			a.MechUnit:new{Image = "units/player/" .. mech2 .. "_mech_w.png", PosX = -30, PosY = -8, NumFrames = 2, Time = 1.53 }
a[mech2 .. "_mech_broken"] =	a.MechUnit:new{Image = "units/player/" .. mech2 .. "_mech_broken.png", PosX = -30, PosY = -10 }
a[mech2 .. "_mechw_broken"] =	a.MechUnit:new{Image = "units/player/" .. mech2 .. "_mech_w_broken.png", PosX = -30, PosY = -2 }
a[mech2 .. "_mech_ns"] =		a.MechIcon:new{Image = "units/player/" .. mech2 .. "_mech_ns.png"}

LOG(a.uplink_mech)

mechPath = path .."img/units/" .. mech3 .. "/"

for _, file in ipairs(files) do
	modApi:appendAsset("img/units/player/" .. mech3 .. "_".. file, mechPath .. file)
end

a[mech3 .. "_mech"] =			a.MechUnit:new{Image = "units/player/" .. mech3 .. "_mech.png", PosX = -20, PosY = 0}
a[mech3 .. "_mecha"] =			a.MechUnit:new{Image = "units/player/" .. mech3 .. "_mech_a.png", PosX = -17, PosY = 1, NumFrames = 4 }
a[mech3 .. "_mechw"] =			a.MechUnit:new{Image = "units/player/" .. mech3 .. "_mech_w.png", PosX = -17, PosY = 9 }
a[mech3 .. "_mech_broken"] =	a.MechUnit:new{Image = "units/player/" .. mech3 .. "_mech_broken.png", PosX = -17, PosY = 0 }
a[mech3 .. "_mechw_broken"] =	a.MechUnit:new{Image = "units/player/" .. mech3 .. "_mech_w_broken.png", PosX = -17, PosY = 13 }
a[mech3 .. "_mech_ns"] =		a.MechIcon:new{Image = "units/player/" .. mech3 .. "_mech_ns.png"}

LOG(a.payload_mech)