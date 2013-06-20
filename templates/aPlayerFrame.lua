local toc, data = ...
local AddonId = toc.identifier

-- Local config options ---------------------------------------------------------
local aPlayerFrameWidth = 336
local aPlayerFrameHeight = 30
--------------------------------------------------------------------------------
local aGadgets = {}

-- Frame Configuration Options --------------------------------------------------
local aPlayerFrame = WT.UnitFrame:Template("aPlayer")
aPlayerFrame.Configuration.Name = "aUI Player Frame"
aPlayerFrame.Configuration.Raidsuitable = false
aPlayerFrame.Configuration.FrameType = "Frame"
aPlayerFrame.Configuration.Width = aPlayerFrameWidth
aPlayerFrame.Configuration.Height = aPlayerFrameHeight


-- Override the buff filter to hide some buffs ----------------------------------
local buffPriorities = 
{
	
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
				-- Aggro frame
				id="cBackdrop", type="Frame", parent="frame", layer=0, 
				attach = 
				{ 
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT" },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT" } 
				}, 				
				visibilityBinding="id", 
				colorBinding="combatN"
				--color={r=1,g=0,b=0,a=1}
			},
			{
				-- Border Frame
				id="fBackdrop", type="Frame", parent="frame", layer=1,
				attach = 
				{ 
					{ point="TOPLEFT", element="cBackdrop", targetPoint="TOPLEFT", offsetX=1, offsetY=1 },
					{ point="BOTTOMRIGHT", element="cBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=-1 } 
				},
				color={r=0,g=0,b=0,a=1}
			},
			{
				-- Health bar
				id="health", type="Bar", parent="fBackdrop", layer=5,
				attach = 
				{
					{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=6 },
					{ point="BOTTOMRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-0, offsetY=0 },
				},
				growthDirection = "right",  --height=47, 
				binding="healthPercent", colorBinding="cColor", 		
				--texAddon=AddonId, texFile="media/textures/Kait.tga", alpha = .5, 
				--backgroundColor={r=0, g=0, b=0, a=0}
			},
			{
				-- Resource bar background
				id="rBackdrop", type="Frame", parent="fBackdrop", layer=2,
				attach = 
				{
					{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=0 },
					{ point="BOTTOMRIGHT", element="health",targetPoint="TOPRIGHT", offsetX=0, offsetY=0 },
				},
				height=5, colorBinding="ccColor",
			},
			{
				-- Rescoure bar
				id="resource", type="Bar", parent="fBackdrop", layer=10,
				attach = 
				{
					{ point="TOPLEFT", element="rBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=0 },
					{ point="BOTTOMRIGHT", element="rBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=-1 },
				},
				binding="resourcePercent", colorBinding="rColor",
				--texAddon=AddonId, texFile="media/textures/Normtex.tga", Alpha = .8,
				--backgroundColor={r=1, g=0, b=0, a=.5}
			},			
			{
				--	Absorb bar
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
				-- Health Text
				id="Health", type="Label", parent="frame", layer=20,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=2.5 }},
				visibilityBinding="health",  --colorBinding="healthT",
				text="{health}",font="HM", fontSize=22, outline=true, 
			},
			{
				-- Resource Text
				id="Resource", type="Label", parent="frame", layer=20,
				attach = {{ point="CENTERRIGHT", element="Health", targetPoint="CENTERLEFT", offsetX=-10, offsetY=0}},
				visibilityBinding="resource", colorBinding="rColor",
				text="{resource}",font="HM", fontSize=22, outline=true
			},
			{
				-- Name and Status text
				id="Status", type="Label", parent="frame", layer=30,
				attach = {{ point="BOTTOMCENTER", element="fBackdrop", targetPoint="BOTTOMCENTER", offsetX=0, offsetY=0 }},
				visibilityBinding="name", colorBinding="rsColor",
				text="{nameStatus}", font="HM", fontSize=26, outline=true,
			},
			{
				-- Cast bar
				id="cast", type="Bar", parent="fBackdrop", layer=25,
				attach = {
					{ point="TOPLEFT", element="resource", targetPoint="TOPLEFT" },
					{ point="BOTTOMRIGHT", element="resource", targetPoint="BOTTOMRIGHT" },
				},
				visibilityBinding="castName",
				binding="castPercent",
				texAddon=AddonId, texFile="img/textures/BantoBar.png", colorBinding="castColor",
				backgroundColor={r=0, g=0, b=0, a=.7}
			},
			{
				-- Cast name text
				id="Cast", type="Label", parent="cast", layer=30,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="TOPRIGHT", offsetX=-3, offsetY=-3 }},
				visibilityBinding="castName",
				text="{castName}", font="UnitframeF", fontSize=18, outline = true
			},
			{
				-- Planar indicator
				id="planar", type="Label", parent="frame", layer=40,
				attach = {{ point="TOPLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=2, offsetY=2.5 }},
				text="{planar}", font="HM", fontSize=20, color = {r=0/255,g=204/255,b=204/255,a=1}, outline = true, 
			},
			{
				-- Soul % text
				id="soul", type="Label", parent="frame", layer=30,
				attach = {{ point="CENTERLEFT", element="planar", targetPoint="CENTERRIGHT", offsetX=0, offsetY=0}},
				text="{vitalSoul}", font="HM", fontSize=20, outline = true, 
			},	
--[[			{
				-- Old buff bar (WIP)
				id="buffs", type="BuffPanel", parent="HorizontalBar", layer=30,
				attach = {{ point="TOPLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=3 }},
				rows=3, cols=5, iconSize=36, iconSpacingHorizontal=1, iconSpacingVertical=13, borderThickness=1.5, 
				acceptLowPriorityBuffs=true, acceptMediumPriorityBuffs=true, acceptHighPriorityBuffs=true, acceptCriticalPriorityBuffs=true,
				acceptLowPriorityDebuffs=false, acceptMediumPriorityDebuffs=false, acceptHighPriorityDebuffs=false, acceptCriticalPriorityDebuffs=false,
				growthDirection = "right_down", selfCast=false,
				timerSize=16, timerOffsetX=0, timerOffsetY=12, font="HM", timerBackgroundColor={r=0,g=0,b=0,a=0},
				stackSize=18, stackOffsetX=-8, stackOffsetY=-8, font="HM", stackBackgroundColor={r=0,g=0,b=0,a=0.7},
				borderColor={r=0,g=0,b=0,a=1}, 
				sweepOverlay=false,
			},
			{
				-- Old debuff bar (WIP)
				id="debuffs", type="BuffPanel", parent="HorizontalBar", layer=30,
				attach = {{ point="TOPRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=3 }},
				rows=3, cols=3, iconSize=36, iconSpacingHorizontal=1, iconSpacingVertical=13, borderThickness=1.5, 
				acceptLowPriorityBuffs=false, acceptMediumPriorityBuffs=false, acceptHighPriorityBuffs=false, acceptCriticalPriorityBuffs=false,
				acceptLowPriorityDebuffs=true, acceptMediumPriorityDebuffs=true, acceptHighPriorityDebuffs=true, acceptCriticalPriorityDebuffs=true,
				growthDirection = "left_down",
				timerSize=20, timerOffsetX=0, timerOffsetY=22, font="Pixel", timerBackgroundColor={r=0,g=0,b=0,a=1},
				stackSize=16, stackOffsetX=-8, stackOffsetY=-8, font ="Pixel", stackBackgroundColor={r=0,g=0,b=0,a=0.7},
				borderColor={r=1,g=0,b=0,a=1},
				sweepOverlay=false,
			},]]
			{
				-- Combo/Charge bar (Works with all classes) Need to modify to at splits
				id="combo", type="Bar", parent="frame", layer=10, --alpha=1,
				attach = 
				{
					{ point="BOTTOMLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=-2 },
					{ point="BOTTOMRIGHT", element="fBackdrop", targetPoint="TOPRIGHT", offsetX=0, offsetY=-2},
				},
				growthdirection = "right", height =8, colorBinding="healthT",
				binding="testCombo", color={r=0,g=0,b=0,a=1},
			},
			----------------Testing Remove before release------------------------
--[[			{
				id="charge", type="Bar", parent="frame", layer=10,
				attach = 
				{
					{ point="TOPLEFT", element="health", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=-9 },
					{ point="BOTTOMRIGHT", element="health", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=-1 },
				},
				growthdirection = "right",
				binding="testCombo", color={r=0,g=0.8,b=0.8,a=0.8},
			},		
			{
				id="fcharge", type="Frame", parent="frame", layer=9,
				attach = 
				{
					{ point="TOPLEFT", element="health", targetPoint="BOTTOMLEFT", offsetX=0, offsetY=-10 },
					{ point="BOTTOMRIGHT", element="health", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=0 },
				},
				growthdirection = "right",
				visibilityBinding="testCombo", color={r=0,g=0,b=0,a=1},
			},
			{
				id="imgTest", type="Image", parent="frame", layer=100, 
				attach = 
				{
					{ point="CENTER", element="health", targetPoint="CENTER"},
				},
				visibilityBinding="combat",
			--	height = 15, width=15,
				texAddon=AddonId, texFile="media/img/combat.png", alpha=1,
			},]]
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

