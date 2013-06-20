local toc, data = ...
local AddonId = toc.identifier

-- Local config options ---------------------------------------------------------
local aFocusFrameWidth = 336
local aFocusFrameHeight = 30
--------------------------------------------------------------------------------
local aGadgets = {}

-- Frame Configuration Options --------------------------------------------------
local aFocusFrame = WT.UnitFrame:Template("aFocus")
aFocusFrame.Configuration.Name = "aUI Focus Frame"
aFocusFrame.Configuration.Raidsuitable = false
aFocusFrame.Configuration.FrameType = "Frame"
aFocusFrame.Configuration.Width = aFocusFrameWidth
aFocusFrame.Configuration.Height = aFocusFrameHeight



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
function aFocusFrame:GetBuffPriority(buff)
	if not buff then return 2 end 
	return buffPriorities[buff.name] or 2
end
---------------------------------------------------------------------------------
function aFocusFrame:Construct(options)
	
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
				--color={r=0,g=1,b=0,a=1}
			},
			{
				-- Generic Element Configuration
				id="fBackdrop", type="Frame", parent="frame", layer=1,
				attach = 
				{ 
					{ point="TOPLEFT", element="cBackdrop", targetPoint="TOPLEFT", offsetX=1, offsetY=1 },
					{ point="BOTTOMRIGHT", element="cBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=-1 } 
				},
				visibilityBinding="id",
				color={r=0,g=0,b=0,a=1}
				
			},
			{
				id="rBackdrop", type="Frame", parent="fBackdrop", layer=2,
				attach = 
				{
					{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=0 },
					{ point="BOTTOMRIGHT", element="fBackdrop",targetPoint="TOPRIGHT", offsetX=0, offsetY=6 },
				},
				height=5, colorBinding="ccColor",
			},
			{
				id="resource", type="Bar", parent="fBackdrop", layer=10,
				attach = 
				{
					{ point="TOPLEFT", element="rBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=0 },
					{ point="BOTTOMRIGHT", element="rBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=0 },
				},
				binding="resourcePercent", height=5, colorBinding="rColor",
				--texAddon=AddonId, texFile="media/textures/Normtex.tga", Alpha = .8,
				--backgroundColor={r=1, g=0, b=0, a=.5}
			},
			{
				id="health", type="Bar", parent="fBackdrop", layer=5,
				attach = 
				{
					{ point="TOPLEFT", element="resource", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=1 },
					{ point="BOTTOMRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-0, offsetY=0 },
				},
				growthdirection="right", --height=41
				binding="healthPercent", colorBinding="cColor", 
				--texAddon=AddonId, texFile="media/textures/Slash2.png", alpha = 1,
				--bagroundColor={r=0, g=0, b=0, a=0}
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
				id="Health", type="Label", parent="frame", layer=20,
				attach = {{ point="TOPLEFT", element="health", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=2.5 }},
				visibilityBinding="health",  color={r=1,g=1,b=1,a=1},
				text="{health}",font="HM", fontSize=22, outline=true,
			},
			{
				id="Resource", type="Label", parent="frame", layer=20,
				attach = {{ point="CENTERLEFT", element="Health", targetPoint="CENTERRIGHT", offsetX=10, offsetY=0 }},
				visibilityBinding="resource", colorBinding="rColor",
				text="{resource}",font="HM", fontSize=22, outline=true
			},	
			{
				id="Status", type="Label", parent="frame", layer=30,
				attach = {{ point="BOTTOMCENTER", element="fBackdrop", targetPoint="BOTTOMCENTER", offsetX=0, offsetY=0 }},
				visibilityBinding="name", colorBinding="rsColor",
				text="{nameStatus}", font="HM", fontSize=26, outline=true,
			},			
			{
				id="Name", type="Label", parent="frame", layer=30,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=2.5 }},
				visibilityBinding="name", --colorBinding="cColor",
				text="{nName}", font="HM", fontSize=20, outline=true,
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
				texAddon=AddonId, texFile="img/textures/BantoBar.png", colorBinding="castColor",
				backgroundColor={r=0, g=0, b=0, a=0.7}
			},
			{
				id="Cast", type="Label", parent="cast", layer=30,
				attach = {{ point="BOTTOMLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=3, offsetY=-2 }},
				visibilityBinding="castName",
				text="{castName}", font="UnitframeF", fontSize=16, outline = true
			},
			
--[[			{
				id="buffs", type="BuffPanel", parent="HorizontalBar", layer=30,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=3 }},
				rows=3, cols=3, iconSize=34, iconSpacingHorizontal=2, iconSpacingVertical=13, borderThickness=1.5, 
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
				attach = {{ point="TOPLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=23 }},
				rows=3, cols=5, iconSize=34, iconSpacingHorizontal=2, iconSpacingVertical=13, borderThickness=1.5,
				acceptLowPriorityBuffs=false, acceptMediumPriorityBuffs=false, acceptHighPriorityBuffs=false, acceptCriticalPriorityBuffs=false,
				acceptLowPriorityDebuffs=true, acceptMediumPriorityDebuffs=true, acceptHighPriorityDebuffs=true, acceptCriticalPriorityDebuffs=true,
				growthDirection = "right_down",
				timerSize=20, timerOffsetX=0, timerOffsetY=22, font="Pixel", timerBackgroundColor={r=0,g=0,b=0,a=1},
				stackSize=16, stackOffsetX=-8, stackOffsetY=-8, font ="Pixel", stackBackgroundColor={r=0,g=0,b=0,a=0.7},
				borderColor={r=1,g=0,b=0,a=1},
				sweepOverlay=true,
			},]]
			{
				id="imgMark", type="MediaSet", parent="fBackdrop", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="TOPCENTER", offsetX=0, offsetY=0 }},
				width = 20, height = 20,
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
		},
	}
	

	
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

