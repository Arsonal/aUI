local toc, data = ...
local AddonId = toc.identifier

-- Local config options ---------------------------------------------------------
local aPlayerFrameWidth = 325
local aPlayerFrameHeight = 58
--------------------------------------------------------------------------------
local aGadgets = {}

-- Frame Configuration Options --------------------------------------------------
local aPlayerFrame = WT.UnitFrame:Template("aPlayer")
aPlayerFrame.Configuration.Name = "aUI Player Frame"
aPlayerFrame.Configuration.Raidsuitable = false
aPlayerFrame.Configuration.FrameType = "Frame"
aPlayerFrame.Configuration.Width = aPlayerFrameWidth
aPlayerFrame.Configuration.Height = aPlayerFrameHeight

if WT.UnitFrame.EnableResizableTemplate then
      aPlayerFrame.Configuration.Resizable = { aPlayerFrameWidth * 1, aPlayerFrameHeight * 1, aPlayerFrameWidth * 1, aPlayerFrameHeight * 1 }
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
function aPlayerFrame:GetBuffPriority(buff)
	if not buff then return 2 end 
	return buffPriorities[buff.name] or 2
end
---------------------------------------------------------------------------------
function aPlayerFrame:Construct(options)
	
	table.insert(aGadgets, self)

	local template =
	{
		elements = 
		{
			{
				id="fBackdrop", type="Frame", parent="frame", layer=0, 
				attach = 
				{ 
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT" },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT" } 
				}, 				
				visibilityBinding="id", 
				--texAddon = AddonId, texFile = "img/wtMiniFrame_bg.png", 
				color={r=0,g=0,b=0,a=1}
			},
			{
				id="health", type="Bar", parent="fBackdrop", layer=5,
				attach = 
				{
					{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=3, offsetY=3 },
					{ point="RIGHT", element="fBackdrop", targetPoint="RIGHT", offsetX=-3 },
				},
				binding="healthPercent", height=41, color={r=0.2, g=0.2, b=0.2, a=.7}, 
				--texAddon=AddonId, texFile="media/textures/Normtex.tga", Alpha = 0,
				backgroundColor={r=0.0, g=0.0, b=0.0, a=0}
			},				
			{
				id="resource", type="Bar", parent="fBackdrop", layer=10,
				attach = 
				{
					{ point="BOTTOMLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=3, offsetY=-3 },
					{ point="RIGHT", element="fBackdrop", targetPoint="RIGHT", offsetX=-3 },
				},
				binding="resourcePercent", height=8, colorBinding="rColor",
				--texAddon=AddonId, texFile="media/textures/Normtex.tga", Alpha = .8,
				backgroundColor={r=0, g=0, b=0, a=.5}
			},			
			{
				id="absorb", type="Bar", parent="health", layer=12,
				attach = 
				{
					{ point="BOTTOMLEFT", element="health", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=-37 },
					{ point="TOPRIGHT", element="health", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=-41 },
				},
				growthDirection="right",
				binding="absorbPercent", color={r=0,g=1,b=1,a=1},
				media="wtBantoBar", 
				--backgroundColor={r=0, g=0, b=0, a=0},
			},
			{
				id="Resource", type="Label", parent="health", layer=20,
				attach = {{ point="CENTERLEFT", element="health", targetPoint="CENTERLEFT", offsetX=0, offsetY=0 }},
				visibilityBinding="resource", colorBinding="rColor",
				text="{resource}",font="Pixel", fontSize=24, outline=true
			},
			{
				id="Health", type="Label", parent="health", layer=20,
				attach = {{ point="CENTERRIGHT", element="health", targetPoint="CENTERRIGHT", offsetX=-5, offsetY=0 }},
				visibilityBinding="health",  colorBinding="healthT",
				text="{health}",font="Pixel", outline=true, fontSize=24
			},		
			{
				id="Name", type="Label", parent="health", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="CENTER", offsetX=0, offsetY=0 }},
				visibilityBinding="name", colorBinding="cColor",
				text="{nameStatusP}", font="UnitframeF", fontSize=18, outline=true,
			},
			{
				id="cast", type="Bar", parent="fBackdrop", layer=25,
				attach = {
					{ point="TOPLEFT", element="resource", targetPoint="TOPLEFT" },
					{ point="BOTTOMRIGHT", element="resource", targetPoint="BOTTOMRIGHT" },
				},
				visibilityBinding="castName",
				binding="castPercent",
				texAddon=AddonId, texFile="img/BantoBar.png", colorBinding="castColor",
				backgroundColor={r=0, g=0, b=0, a=0.7}
			},
			{
				id="Cast", type="Label", parent="cast", layer=30,
				attach = {{ point="BOTTOMRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-3, offsetY=-2 }},
				visibilityBinding="castName",
				text="{castName}", font="UnitframeF", fontSize=16, outline = true
			},
			{
				id="combat", type="Frame", parent="frame", layer=1, 
				attach = 
				{ 
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=0, offsetY=0 },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=-55 } 
				}, 				
				visibilityBinding="combat", 
				color={r=1,g=0,b=0,a=1}
			},
			{
				id="planar", type="Label", parent="health", layer=30,
				attach = {{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=-5 }},
				text="{planar}", font="Pixel", fontSize=20, outline = true
			},
			{
				id="soul", type="Label", parent="health", layer=30,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="TOPRIGHT", offsetX=0, offsetY=-5 }},
				text="{vitalSoul}", font="Pixel", fontSize=20, outline = true
			},			
			{
				id="buffs", type="BuffPanel", parent="HorizontalBar", layer=30,
				attach = {{ point="TOPLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=3 }},
				rows=3, cols=5, iconSize=34, iconSpacingHorizontal=2, iconSpacingVertical=13, borderThickness=3, 
				acceptLowPriorityBuffs=true, acceptMediumPriorityBuffs=true, acceptHighPriorityBuffs=true, acceptCriticalPriorityBuffs=true,
				acceptLowPriorityDebuffs=false, acceptMediumPriorityDebuffs=false, acceptHighPriorityDebuffs=false, acceptCriticalPriorityDebuffs=false,
				growthDirection = "right_down", selfCast=false,
				timerSize=20, timerOffsetX=0, timerOffsetY=22, font="Pixel", timerBackgroundColor={r=0,g=0,b=0,a=1},
				stackSize=18, stackOffsetX=-8, stackOffsetY=-8, font="Pixel", stackBackgroundColor={r=0,g=0,b=0,a=0.7},
				borderColor={r=0,g=0,b=0,a=1}, 
				sweepOverlay=true,
			},
			{
				id="debuffs", type="BuffPanel", parent="HorizontalBar", layer=30,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=3 }},
				rows=3, cols=3, iconSize=34, iconSpacingHorizontal=2, iconSpacingVertical=13, borderThickness=2, 
				acceptLowPriorityBuffs=false, acceptMediumPriorityBuffs=false, acceptHighPriorityBuffs=false, acceptCriticalPriorityBuffs=false,
				acceptLowPriorityDebuffs=true, acceptMediumPriorityDebuffs=true, acceptHighPriorityDebuffs=true, acceptCriticalPriorityDebuffs=true,
				growthDirection = "left_down",
				timerSize=20, timerOffsetX=0, timerOffsetY=22, font="Pixel", timerBackgroundColor={r=0,g=0,b=0,a=1},
				stackSize=16, stackOffsetX=-8, stackOffsetY=-8, font ="Pixel", stackBackgroundColor={r=0,g=0,b=0,a=0.7},
				borderColor={r=1,g=0,b=0,a=1},
				sweepOverlay=true,
			},
			{
				id="combo", type="ImageSet", parent="frame", layer=10, alpha=1,
				attach = 
				{
					{ point="CENTER", element="fBackdrop", targetPoint="CENTER", offsetX=287.5, offsetY=-39 },
				},
				indexBinding="comboIndex", rows=5, cols=1,
				visibilityBinding="comboIndex",
				texAddon=AddonId, texFile="media/img/scp1.png", alpha=1,
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
				id="imgMark", type="MediaSet", parent="frameBackdrop", layer=30,
				attach = {{ point="CENTER", element="frameBackdrop", targetPoint="CENTER", offsetX=20, offsetY=0 }},
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
            WT.UnitFrame.EnableResizableTemplate(self, aPlayerFrameWidth, aPlayerFrameHeight, template.elements)
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

