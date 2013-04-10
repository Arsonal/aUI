local toc, data = ...
local AddonId = toc.identifier

-- Local config options ---------------------------------------------------------
local aTTargetFrameWidth = 250
local aTTargetFrameHeight = 40
--------------------------------------------------------------------------------
local aGadgets = {}

-- Frame Configuration Options --------------------------------------------------
local aTTargetFrame = WT.UnitFrame:Template("aTTarget")
aTTargetFrame.Configuration.Name = "aUI Target of Target Frame"
aTTargetFrame.Configuration.Raidsuitable = false
aTTargetFrame.Configuration.FrameType = "Frame"
aTTargetFrame.Configuration.Width = aTTargetFrameWidth
aTTargetFrame.Configuration.Height = aTTargetFrameHeight

if WT.UnitFrame.EnableResizableTemplate then
      aTTargetFrame.Configuration.Resizable = { aTTargetFrameWidth * 1, aTTargetFrameHeight * 1, aTTargetFrameWidth * 1, aTTargetFrameHeight * 1 }
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
function aTTargetFrame:GetBuffPriority(buff)
	if not buff then return 2 end 
	return buffPriorities[buff.name] or 2
end
---------------------------------------------------------------------------------
function aTTargetFrame:Construct(options)
	
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
				binding="healthPercent", height=25	, color={r=0.2, g=0.2, b=0.2, a=.7}, 
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
				binding="resourcePercent", height=6, colorBinding="rColor",
				--texAddon=AddonId, texFile="media/textures/Normtex.tga", Alpha = .8,
				backgroundColor={r=0, g=0, b=0, a=.5}
			},			
			{
				id="Name", type="Label", parent="health", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="CENTER", offsetX=0, offsetY=-2 }},
				visibilityBinding="name", colorBinding="cColor",
				text="{nameStatusT}", font="UnitframeF", fontSize=18, outline=true,
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
            WT.UnitFrame.EnableResizableTemplate(self, aTTargetFrameWidth, aTTargetFrameHeight, template.elements)
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

