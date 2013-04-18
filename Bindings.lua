local toc, data = ...
local AddonId = toc.identifier

	
-----Better Resource Colors-------
WT.Unit.CreateVirtualProperty("rColor", { "energy", "mana", "power" },
	function(unit)
		if unit.energy then
			return { r = .65, g = .63, b = .35, a = 1.0 }
		elseif unit.mana then 
			return { r = 0.31, g = 0.45, b = 0.63, a = 1.0 }
		elseif unit.power then
			return { r = 0.69, g = .31, b = .31, a = 1.0 }
		else
			return { r = 1, g = 1, b = 1, a = 1.0 }
		end
	end)
	
--Better Class Colors--------------
WT.Unit.CreateVirtualProperty("cColor", { "calling" },
	function(unit)
		if unit.calling == "cleric" then
			return { r = 171/255, g = 225/255, b = 116/255, a = 1 }
		elseif unit.calling == "mage" then 
			return { r = 148/255, g = 130/255, b = 201/255, a = 1 }
		elseif unit.calling == "rogue" then
			return { r = 255/255, g = 243/255, b = 82/255 , a = 1 }
		elseif unit.calling == "warrior" then
			return { r = 196/255, g = 30/255, b = 60/255, a = 1}
		else
			return { r = 1, g = 1, b = 1, a = 1.0 }
		end
	end)

----------Gradiant Heallth-------------	
WT.Unit.CreateVirtualProperty("healthT", { "health", "healthMax" },
	function(unit)
		if unit.health and unit.healthMax and unit.healthMax > 0 then
			if (unit.health / unit.healthMax)  < 0.25 then
				return { r = 1, g = 0, b = 0 }
			elseif (unit.health / unit.healthMax) < 0.50 then
				return { r = 1, g = .5, b = 0 }
			elseif (unit.health / unit.healthMax) < 0.75  then
				return { r = 1, g = 1, b = 0 }
			end
        end
        return { r = 0, g = 1, b = 0 }
    end)

------------Name Changers------------
WT.Unit.CreateVirtualProperty("nameStatusT", { "name", "afk", "offline", "health", "offline" },
	function(unit)
		if unit.offline then
			return "D/C"
		elseif unit.afk then
			return "AFK"
		elseif unit.dead then
			return "Dead"
		else
			return unit.name
		end
	end)
	
WT.Unit.CreateVirtualProperty("nameStatusP", { "afk", "health",  "vitality", "vitalityMax" },
	function(unit)
		if unit.afk then
			return "AFK"
		elseif unit.dead then
			return "Dead"
		else 
			return nil
		end
	end)
	

----Combat Coloring------------------
WT.Unit.CreateVirtualProperty("combatN", { "combat" },
	function(unit)
		if unit.combat then
			return { r = 1, g = 0, b = 0, a = 1 }	
		else
			return { r = 0, g = 0, b = 0, a = 1 }
		end
	end)

	
------SmArT lEvEl----
WT.Unit.CreateVirtualProperty("levelS", { "level" },
	function(unit)
		if unit.level == "??" then
			return "??"	
		elseif unit.level < 60 then
			return unit.level
		elseif unit.level >60 then
			return unit.level
		else
			return nil
		end
	end)
	
-----------------Your Soul is in my hands!------
WT.Unit.CreateVirtualProperty("vitalSoul", { "vitality", "vitalityMax" },
	function(unit)
		local vitality = unit.vitality
		if not vitality then 
			return nil 
		end 
		if vitality > 90 then 
			return ""
		elseif vitality > 80 then 
			return "9"
		elseif vitality > 70 then 
			return "8"
		elseif vitality > 60 then 
			return "7"
		elseif vitality > 50 then 
			return "6"
		elseif vitality > 40 then 
			return "5"
		elseif vitality > 30 then 
			return "4"
		elseif vitality > 20 then 
			return "3"
		elseif vitality > 10 then 
			return "2"
		elseif vitality > 0 then 
			return "1"
		else
			return "HEAL"
		end
	end)
	
	
------------Mob teir identifier----------------

WT.Unit.CreateVirtualProperty("npcT", { "level", "tier", "guaranteedLoot" },
	function(unit)
		if unit.tier  == "raid" then
			return "++"
		elseif unit.tier == "group" then
			return "+"
		elseif unit.guaranteedLoot and unit.tier then
			return "R+"
		elseif unit.guaranteedLoot then
			return "R"
		else
			return nil
		end
	end)

	
	