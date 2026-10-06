
-- Replace these! You can look at the base game weapon files in the scripts folder for examples.

local path = mod_loader.mods[modApi.currentMod].resourcePath

-- these import your custom icons and animations, these filepaths must match your folders and the filepaths below
modApi:appendAsset("img/weapons/template_punchmech.png", path .."img/weapons/template_punchmech.png")
modApi:appendAsset("img/weapons/template_artillery.png", path .."img/weapons/template_artillery.png")
modApi:appendAsset("img/weapons/template_tankmech.png", path .."img/weapons/template_tankmech.png")
--==================================================================================================================================--
Cryobash_Punch = Prime_Punchmech:new{
	Class = "Prime",
	Name = "Cryo Bash",
	Description = "Freeze yourself and punch an adjacent tile.",
	Icon = "weapons/prime_punchmech.png",
	Rarity = 3,
	PowerCost = 0,
	Upgrades = 2,
	LaunchSound = "/weapons/titan_fist",
	ImpactSound = "/impact/generic/explosion",
	Damage = 3,
	SelfFreeze = 1,
	UpgradeCost = { 1,2 },
	UpgradeList = { "Rocket", "+1 Damage" },
	TipImage = StandardTips.Melee,
}

function Cryobash_Punch:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local doDamage = true
	local target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)
	local damage = SpaceDamage(target, self.Damage, direction)
	damage.sAnimation = "explopunch1_"..direction
	if self.Projectile and target:Manhattan(p1) ~= 1 then
		damage.loc = target
		--ret:AddDamage(SpaceDamage(p1,0,(direction+2)%4))
		ret:AddProjectile(damage, "effects/shot_fist", NO_DELAY)
		doDamage = false--damage covered here
	else
		target = p2
	end
	
	if doDamage then
		damage.loc = target
		ret:AddDamage(damage)
	end
	
	if self.PushBack then
		local backdir = GetDirection(p1-p2)
		damage = SpaceDamage(p1, 0, backdir)
		damage.sAnimation = "airpush_"..backdir
		ret:AddDamage(damage)
	end
	
	if self.SelfFreeze == 1 then
		local damage = SpaceDamage(p1, 0)
		damage.iFrozen = EFFECT_CREATE
		ret:AddDamage(damage)
	end
	
	return ret
end

Cryobash_Punch_A = Cryobash_Punch:new{
	UpgradeDescription = "Turns Cryo Bash into a projectile.",
	Projectile = true,
	ZoneTargeting = ZONE_DIR,
	PathSize = INT_MAX, 
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}

Cryobash_Punch_B = Cryobash_Punch:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 4,
}

Cryobash_Punch_AB = Cryobash_Punch:new{
	Damage = 4,
	Projectile = true,
	ZoneTargeting = ZONE_DIR,
	PathSize = INT_MAX, 
}

Heat_Converter = Skill:new{
	Class = "Science",
	Name = "Heat Converter",
	Description = "Freeze the tile in front but light the tile behind on Fire in the process.",
	Icon = "weapons/support_refrigerate.png",
	LaunchSound = "/weapons/refrigerate",
	Range = 1, -- Tooltip?
	PathSize = 1,
	Damage = 0,
	PowerCost = 0,
	Upgrades = 0,
	TipImage = StandardTips.Melee
}
				
function Heat_Converter:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	
	damage = SpaceDamage(p2, 0)
	damage.iFrozen = 1
	ret:AddDamage(damage)
	
	damage = SpaceDamage(p1 - DIR_VECTORS[dir], 0)
	damage.iFire = 1
	ret:AddDamage(damage)
	
	return ret
end	

Trebuchet_Arty = LineArtillery:new{
	Name = "Trebuchet Artillery",
	Description = "Fire a powerful artillery strike that damages and push tiles in a large area.",
	Icon = "weapons/ranged_defensestrike.png",
	Rarity = 3,
	Sound = "/general/combat/explode_small",
	UpShot = "effects/shotup_dstrike_missile.png",
	BuildingDamage = true,
	PowerCost = 1, 
	Damage = 1,
	Class = "Ranged",
	Upgrades = 2,
	UpgradeCost = {1,3}, 
	UpgradeList = { "Buildings Immune", "+1 Damage" },
	LaunchSound = "/weapons/defense_strike",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Building = Point(2,2),
		Enemy = Point(2,1),
		Enemy2 = Point(3,2),
		Target = Point(2,2)
	}
}

function Trebuchet_Arty:GetSkillEffect(p1,p2) 
	local ret = SkillEffect() 
	local dir = GetDirection(p2 - p1) 

	ret:AddBounce(p1, 1) 

	local damage = SpaceDamage(p1, self.SelfDamage) 
	ret:AddDamage(damage) 

	-- Artillery projectile
	local dummy_damage = SpaceDamage(p2, 0) 
	ret:AddArtillery(dummy_damage, self.UpShot, FULL_DELAY) 

	local forward = DIR_VECTORS[dir] 
	local left = DIR_VECTORS[(dir + 1) % 4] 
	local right = DIR_VECTORS[(dir + 3) % 4] 

	-- Center: 3 tiles of damage
	for width = -1, 1 do
		local offset

		if width == -1 then
			offset = left
		elseif width == 1 then
			offset = right
		else
			offset = Point(0, 0)
		end

		local target = p2 + offset

		local area_damage = SpaceDamage(target, self.Damage)

		if not self.BuildingDamage and Board:IsBuilding(target) then
			area_damage.iDamage = 0
		end

		ret:AddDamage(area_damage)
	end

	-- One tile forward: push only
	for width = -1, 1 do
		local offset

		if width == -1 then
			offset = left
		elseif width == 1 then
			offset = right
		else
			offset = Point(0, 0)
		end

		local target = p2 + forward + offset

		local push_damage = SpaceDamage(target, 0)
		push_damage.iPush = dir

		ret:AddDamage(push_damage)
	end

	-- One tile backward: push only
	for width = -1, 1 do
		local offset

		if width == -1 then
			offset = left
		elseif width == 1 then
			offset = right
		else
			offset = Point(0, 0)
		end

		local target = p2 - forward + offset

		local push_damage = SpaceDamage(target, 0)
		push_damage.iPush = (dir + 2) % 4

		ret:AddDamage(push_damage)
	end

	ret:AddBounce(p2, 1) 

	return ret 
end

Trebuchet_Arty_A = Trebuchet_Arty:new{
	UpgradeDescription = "Building become immune to damage.",
	BuildingDamage = false,
	TipImage = {
		Unit = Point(2,4),
		Building = Point(2,2),
		Building2 = Point(3,2),
		Enemy3 = Point(2,1),
		Target = Point(2,2)
	}	
}

Trebuchet_Arty_B = Trebuchet_Arty:new{
	UpgradeDescription = "Increases damage by 1.",
	Damage = 2,---USED FOR TOOLTIPS
	BounceOuterAmount = 3,
}
			
Trebuchet_Arty_AB = Trebuchet_Arty:new{
	Damage = 2,---USED FOR TOOLTIPS
	BuildingDamage = false,
}
