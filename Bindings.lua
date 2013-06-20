local toc, data = ...
local AddonId = toc.identifier

	
-- Resource color
WT.Unit.CreateVirtualProperty("rColor", { "calling" },
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
			return { r = .2, g = .2, b = .2, a = 1.0 }
		end
	end)
	
-- Forgot what this is for???????
WT.Unit.CreateVirtualProperty("nrColor", { "energy", "mana", "power" },
	function(unit)
		if unit.energy then
			return { r = .65, g = .63, b = .35, a = 1.0 }
		elseif unit.mana then 
			return { r = 0.31, g = 0.45, b = 0.63, a = 1.0 }
		elseif unit.power then
			return { r = 0.69, g = .31, b = .31, a = 1.0 }
		else
			return nil
		end
	end)
	
-- Class colors for health bars
WT.Unit.CreateVirtualProperty("cColor", { "calling", "health" },
	function(unit)
	local calling = unit.calling
		if not calling then 
			return {r=175/255,g=175/255,b=175/255, a = 1}
		elseif unit.calling == "cleric" then
			return { r = 171/255, g = 225/255, b = 116/255, a = .6 }
		elseif unit.calling == "mage" then 
			return { r = 148/255, g = 130/255, b = 201/255, a = .6}
		elseif unit.calling == "rogue" then
			return { r = 255/255, g = 243/255, b = 82/255 , a = .6}
		elseif unit.calling == "warrior" then
			return { r = 196/255, g = 30/255, b = 60/255, a = .6}
		else 
			return {r=175/255,g=175/255,b=175/255,a=1}
		end
	end)
	
		
-- Resource background color
WT.Unit.CreateVirtualProperty("ccColor", { "calling" },
	function(unit)
		if unit.calling == "cleric" then
			return { r = 171/255, g = 225/255, b = 116/255, a= .3 }
		elseif unit.calling == "mage" then 
			return { r = 148/255, g = 130/255, b = 201/255, a=.3}
		elseif unit.calling == "rogue" then
			return { r = 255/255, g = 243/255, b = 82/255 , a=.3 }
		elseif unit.calling == "warrior" then
			return { r = 196/255, g = 30/255, b = 60/255, a=.3 }
		else
			return { r = 0, g = 0, b = 0, a=0 }
		end
	end)

-- Coloring for Out of range/Blocked Raid names
WT.Unit.CreateVirtualProperty("bColor", { "blocked", "aggro", "range" },
	function(unit)
		if unit.aggro and unit.outOfRange then
			return { r=.6, g=.2, b=.2, a=.7 }
		elseif unit.blocked or unit.outOfRange then
			return { r=.4, g=.4, b=.4, a=.7 }
		elseif unit.aggro then
			return { r=1, g=0, b=0, a=.8 }
		else
			return { r=1, g=1, b=1, a=.8 }
		end
	end)
	
-- Status coloring effect	
WT.Unit.CreateVirtualProperty("rsColor", { "afk", "offline", "health" },
	function(unit)
		if unit.dead or unit.offline then
			return { r=1, g=0, b=0, a=.8 }
		else
			return { r=1, g=1, b=1, a=1 }
		end
	end)
	
-- Gradient health testing(WIP)
WT.Unit.CreateVirtualProperty("healthT", { "health", "healthMax" },
	function(unit)
		if unit.health and unit.healthMax and unit.healthMax > 0 then
			if (unit.health / unit.healthMax)  < 0.21 then
				return { r = 1, g = 0, b = 0 }
			elseif (unit.health / unit.healthMax) < 0.41 then
				return { r = 1, g = .5, b = 0 }
			elseif (unit.health / unit.healthMax) < 0.61 then
				return { r = 1, g = 1, b = 0 }
			elseif (unit.health / unit.healthMax) < 0.81  then
				return { r = .5, g = 1, b = 0 }
			end
        end
        return {r=102/255,g=230/255,b=51/255,a=.7}
    end)


-- Status text
WT.Unit.CreateVirtualProperty("nStatus", { "afk", "health","offline" },
	function(unit)
		if unit.offline then
			return "D/C"
		elseif unit.afk then
			return "AFK"
		elseif unit.dead then
			return "DEAD"
		else 
			return nil
		end
	end)
	
-- @servername removal to (*)
WT.Unit.CreateVirtualProperty("nName", { "name" },
	function(unit)
		if unit.name then
			return (unit.name:gsub("@%w+", " (*)"))
		else 
			return "ERROR"
		end
	end)

-- Aggro/Combat border color
WT.Unit.CreateVirtualProperty("combatN", { "combat" },
	function(unit)
		if unit.combat then
			return { r = 1, g = 0, b = 0, a = 1 }	
		else
			return { r = 0, g = 0, b = 0, a = 0 }
		end
	end)

	
-- Level indicator
WT.Unit.CreateVirtualProperty("levelS", { "level" },
	function(unit)
		if unit.level == "??" then
			return "??"	
		elseif unit.level < 60 then
			return unit.level
		else
			return nil
		end
	end)
		
-- Soul level indicator
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
	
	
-- Mob teir indicator
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
	
	
-- Combo/Charge handler
WT.Unit.CreateVirtualProperty("testCombo", { "combo", "comboUnit", "calling", "charge", "chargeMax" },
	function(unit)
		if not (unit.combo or unit.charge) then
			return nil
		elseif unit.calling == "rogue" then
			return (unit.combo / 5) * 100
		elseif unit.calling == "warrior" then
			return (unit.combo / 3) * 100 
		elseif unit.charge then
			return (unit.charge / (unit.chargeMax or 100)) * 100 
		end
	end)

-- Cast time handler for timing remaining(WIP)
WT.Unit.CreateVirtualProperty("timeCast", { "cast", "castTime" },
	function(unit)
		if unit.castTime then
			return castbar.remaining
		else 
			return nil
		end
	end)
	



