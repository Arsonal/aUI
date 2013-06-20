local toc, data = ...
local AddonId = toc.identifier

-- Local config options ---------------------------------------------------------
local aTargetFrameWidth = 325
local aTargetFrameHeight = 58
--------------------------------------------------------------------------------
local aGadgets = {}

-- Frame Configuration Options --------------------------------------------------
local aTargetFrame = WT.UnitFrame:Template("aTarget")
aTargetFrame.Configuration.Name = "aUI Target Frame"
aTargetFrame.Configuration.Raidsuitable = false
aTargetFrame.Configuration.FrameType = "Frame"
aTargetFrame.Configuration.Width = aTargetFrameWidth
aTargetFrame.Configuration.Height = aTargetFrameHeight

if WT.UnitFrame.EnableResizableTemplate then
      aTargetFrame.Configuration.Resizable = { aTargetFrameWidth * 1, aTargetFrameHeight * 1, aTargetFrameWidth * 1, aTargetFrameHeight * 1 }
end

-- Override the buff filter to hide some buffs ----------------------------------
local buffPriorities = 
{
	["Track Wood"] = 0,
	["Track Ore"] = 0,
	["Track Plants"] = 0,
	["Rested"] = 0,
	["Prismatic Glory"] = 0,
	["Looking for Group Cooldown"] = 0,
	["Crucia's Touch"] = 0,
}
function aTargetFrame:GetBuffPriority(buff)
	if not buff then return 2 end 
	return buffPriorities[buff.name] or 2
end
---------------------------------------------------------------------------------
function aTargetFrame:Construct(options)
	
	table.insert(aGadgets, self)

	local template =
	{
		elements = 
		{
			{
				id="cBackdrop", type="Frame", parent="frame", layer=0, 
				attach = 
				{ 
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT" },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT" } 
				}, 				
				visibilityBinding="id", 
				colorBinding="combatN",
			},
			{
				-- Generic Element Configuration
				id="fBackdrop", type="Frame", parent="frame", layer=1,
				attach = 
				{ 
					{ point="TOPLEFT", element="cBackdrop", targetPoint="TOPLEFT", offsetX=1, offsetY=1 },
					{ point="BOTTOMRIGHT", element="cBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-2, offsetY=-1 } 
				},
				visibilityBinding="id",
				color={r=0,g=0,b=0,a=1}
			},
			{
				id="health", type="Bar", parent="fBackdrop", layer=5,
				attach = 
				{
					{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=1, offsetY=1 },
					{ point="BOTTOMRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=-10 },
				},
				growthdirection="right", --height=41
				binding="healthPercent", color={r=0.2, g=0.2, b=0.2, a=.7}, 
				texAddon=AddonId, texFile="media/textures/Glaze2.png", alpha = .6,
				--backgroundColor={r=0.0, g=0.0, b=0.0, a=0}
			},				
			{
				id="resource", type="Bar", parent="fBackdrop", layer=10,
				attach = 
				{
					{ point="BOTTOMLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=1, offsetY=-1 },
					{ point="RIGHT", element="fBackdrop", targetPoint="RIGHT", offsetX=-1 },
				},
				binding="resourcePercent", height=8, colorBinding="rColor",
				--texAddon=AddonId, texFile="media/textures/Normtex.tga", Alpha = .8,
				backgroundColor={r=0, g=0, b=0, a=.5}
			},			
			{
				id="absorb", type="Bar", parent="health", layer=12,
				attach = 
				{
					{ point="TOPLEFT", element="health", targetPoint="TOPLEFT", offsetX=0, offsetY=0 },
					{ point="BOTTOMRIGHT", element="health", targetPoint="TOPRIGHT", offsetX=0, offsetY=4 },
				},
				growthDirection="right",
				binding="absorbPercent", color={r=0,g=1,b=1,a=1},
				--backgroundColor={r=0, g=0, b=0, a=0},
			},
			{
				id="Resource", type="Label", parent="frane", layer=20,
				attach = {{ point="CENTERRIGHT", element="health", targetPoint="CENTERRIGHT", offsetX=0, offsetY=0 }},
				visibilityBinding="resource", colorBinding="rColor",
				text="{resource}",font="Pixel", fontSize=24, outline=true
			},
			{
				id="Health", type="Label", parent="frame", layer=20,
				attach = {{ point="CENTERLEFT", element="health", targetPoint="CENTERLEFT", offsetX=0, offsetY=0 }},
				visibilityBinding="health",  colorBinding="healthT",
				text="{health}",font="Pixel", outline=true, fontSize=24
			},		
			{
				id="Name", type="Label", parent="frame", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="CENTER", offsetX=0, offsetY=0 }},
				visibilityBinding="name", colorBinding="cColor",
				text="{nameStatusT}", font="UnitframeF", fontSize=18, outline=true,
			},
			{
				id="cast", type="Bar", parent="fBackdrop", layer=25,
				attach = 
				{
					{ point="TOPRIGHT", element="resource", targetPoint="TOPRIGHT" },
					{ point="BOTTOMLEFT", element="resource", targetPoint="BOTTOMLEFT" },
				},
				growthDirection="left", visibilityBinding="castName",
				binding="castPercent",
				texAddon=AddonId, texFile="img/BantoBar.png", colorBinding="castColor",
				backgroundColor={r=0, g=0, b=0, a=0.7}
			},
			{
				id="Cast", type="Label", parent="cast", layer=30,
				attach = {{ point="BOTTOMLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=3, offsetY=-2 }},
				visibilityBinding="castName",
				text="{castName}", font="UnitframeF", fontSize=16, outline = true
			},
			{
				id="Level", type="Label", parent="frame	", layer=30,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="TOPRIGHT", offsetX=0, offsetY=-3 }},
				visibilityBinding="level",
				text="{levelS}", font="Pixel", fontSize=20, outline = true
			},
			{
				id="npc", type="Label", parent="frame ", layer=40,
				attach = {{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=-3 }},
				visibilityBinding="id",
				text="{npcT}", font="Pixel", fontSize=20, outline=true
				
			},			
			{
				id="buffs", type="BuffPanel", parent="HorizontalBar", layer=30,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=3 }},
				rows=3, cols=3, iconSize=34, iconSpacingHorizontal=2, iconSpacingVertical=13, borderThickness=3, 
				acceptLowPriorityBuffs=true, acceptMediumPriorityBuffs=true, acceptHighPriorityBuffs=true, acceptCriticalPriorityBuffs=true,
				acceptLowPriorityDebuffs=false, acceptMediumPriorityDebuffs=false, acceptHighPriorityDebuffs=false, acceptCriticalPriorityDebuffs=false,
				growthDirection = "left_down", selfCast=false,
				timerSize=20, timerOffsetX=0, timerOffsetY=22, font="Pixel", timerBackgroundColor={r=0,g=0,b=0,a=1},
				stackSize=18, stackOffsetX=-8, stackOffsetY=-8, font="Pixel", stackBackgroundColor={r=0,g=0,b=0,a=0.7},
				borderColor={r=0,g=0,b=0,a=1}, 
				sweepOverlay=true,
			},
			{
				id="debuffs", type="BuffPanel", parent="HorizontalBar", layer=30,
				attach = {{ point="TOPLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=3 }},
				rows=3, cols=5, iconSize=34, iconSpacingHorizontal=2, iconSpacingVertical=13, borderThickness=2, 
				acceptLowPriorityBuffs=false, acceptMediumPriorityBuffs=false, acceptHighPriorityBuffs=false, acceptCriticalPriorityBuffs=false,
				acceptLowPriorityDebuffs=true, acceptMediumPriorityDebuffs=true, acceptHighPriorityDebuffs=true, acceptCriticalPriorityDebuffs=true,
				growthDirection = "right_down",
				timerSize=20, timerOffsetX=0, timerOffsetY=22, font="Pixel", timerBackgroundColor={r=0,g=0,b=0,a=1},
				stackSize=16, stackOffsetX=-8, stackOffsetY=-8, font ="Pixel", stackBackgroundColor={r=0,g=0,b=0,a=0.7},
				borderColor={r=1,g=0,b=0,a=1},
				sweepOverlay=true,
			},

			--[[			
			--------------------------------------------------------------------------------------------------
			{
				id="imgPVP", type="MediaSet", parent="frame", layer=100, width=16, height=16,
				attach = {{ point="CENTERLEFT", element="imgRole", targetPoint="CENTERRIGHT", offsetX=0, offsetY=0 }}, 
				nameBinding="pvpAlliance",
				names = 
				{
					["defiant"] = "FactionDefiant",
					["guardian"] = "FactionGuardian",
					["nightfall"] = "FactionNightfall",
					["oathsworn"] = "FactionOathsworn",
					["dominion"] = "FactionDominion",
				},
			},
			{
				id="imgMark", type="MediaSet", parent="fBackdrop", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="CENTER", offsetX=20, offsetY=0 }},
				width = 32, height = 32,
				nameBinding="mark",
				names = 
				{
					["1"] = "riftMark01",
					["2"] = "riftMark02",
					["3"] = "riftMark03",
					["4"] = "riftMark04",
					["5"] = "riftMark05",
			        ["6"] = "riftMark06",
			        ["7"] = "riftMark07",
			        ["8"] = "riftMark08",
			        ["9"] = "riftMark09",
			        ["10"] = "riftMark10",
			        ["11"] = "riftMark11",
			        ["12"] = "riftMark12",
			        ["13"] = "riftMark13",
			        ["14"] = "riftMark14",
			        ["15"] = "riftMark15",
			        ["16"] = "riftMark16",
			        ["17"] = "riftMark17",
				},
				visibilityBinding="mark",alpha=1.0,
			},
			]]
		},
	}
	
	if WT.UnitFrame.EnableResizableTemplate then
            WT.UnitFrame.EnableResizableTemplate(self, aTargetFrameWidth, aTargetFrameHeight, template.elements)
    end
	
	for idx,element in ipairs(template.elements) do
		local showElement = true
		if options.excludeBuffs and element.type=="BuffPanel" then showElement = false end
		if options.excludeCasts and ((element.id == "cast") or (element.id == "Cast")) then showElement = false end
		if not options.showAbsorb and element.id == "absorb" then showElement = false end
		if showElement then
			self:CreateElement(element)
		end 
	end 

	if options.showBackground then
		self:SetBackgroundColor(0,0,0,0.2)
	end
	
	self:SetSecureMode("restricted")
	self:SetMouseoverUnit(self.UnitSpec)
	
	if options.clickToTarget then 
		self.Event.LeftClick = "target @" .. self.UnitSpec 
	end
	
	if options.contextMenu then 
		self.Event.RightClick = 
			function() 
				if self.UnitId then 
					Command.Unit.Menu(self.UnitId) 
				end 
			end 
	end

	self.ConfigurationDialog = configDialog
end
