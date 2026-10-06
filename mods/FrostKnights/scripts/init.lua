local mod = {
	id = "frost_knights_squad", --replace this, make it unique! it's only internal so it doesn't really matter.
	name = "Frost Knights", -- this name is what shows up in the mod list 
	version = "1.0.0", 
	requirements = {}, 
	modApiVersion = "2.3.0",
	icon = "img/mod_icon.png"
}

function mod:init() -- these are the files that the modloader will load
	require(self.scriptPath .."palettes")
	require(self.scriptPath .."pawns")
	require(self.scriptPath .."weapons")
	
end
	-- to add your weapons to the weapon decks, add the following line for each with the weapon's ID
    --modApi:addWeaponDrop("WeaponNameHere")

function mod:load(options, version)
	modApi:addSquad( 
		{
			"Frost Knights",	--this name is what shows up in the hangar
			"Yeti_MeleeMech",			
			"Trebuchet_ArtilleryMech",			
			"CoolFire_ScienceMech"			
		},
		"Frost Knights", -- this name is what shows up in the squad list
		"These Mechs have mastered frost manipulation and will use it to annihilate any threat.", -- description when moused over
		self.resourcePath .."img/mod_icon.png"
	)
end

return mod
