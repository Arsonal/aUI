local toc, data = ...
local AddonId = toc.identifier
-- Local config options ---------------------------------------------------------
local aRaidFrameWidth = 160
local aRaidFrameHeight = 24

---------------------------------------------------------------------------------

-- Frame Configuration Options --------------------------------------------------
local aRaidFrame = WT.UnitFrame:Template("aRaidFrame")
aRaidFrame.Configuration.Name = "aUI Raid Frames"
aRaidFrame.Configuration.RaidSuitable = true
aRaidFrame.Configuration.FrameType = "Frame"
aRaidFrame.Configuration.Width = aRaidFrameWidth
aRaidFrame.Configuration.Height = aRaidFrameHeight

-- Only enable resizing if the installed version of Gadgets can handle it:
if WT.UnitFrame.EnableResizableTemplate then
      aRaidFrame.Configuration.Resizable = { aRaidFrameWidth * 1, aRaidFrameHeight * 1, aRaidFrameWidth * 2, aRaidFrameHeight * 2 }
end
---------------------------------------------------------------------------------

function aRaidFrame:Construct(options)

	local template =
	{
		elements = 
		{
			{
				-- Border frame
				id="fBackdrop", type="Frame", parent="frame", layer=1,
				attach = 
				{ 
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=1, offsetY=1 },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=-1 },
				},
				visibilityBinding="id", 
				color={r=0,g=0,b=0,a=.7},
			},
			{ 
				-- Health bar background
				id="hBackdrop", type="Frame", parent="fBackdrop", layer=1, alpha=.5,
				attach=
				{
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=2, offsetY=2 },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=-2, offsetY=-2 },
				},
				colorBinding="ccColor",
			},
			{
				-- Health bar
				id="health", type="Bar", parent="fBackdrop", layer=2, alpha=.5,
				attach = 
				{
					{ point="TOPLEFT", element="hBackdrop", targetPoint="TOPLEFT", offsetX=0, offsetY=0 },
					{ point="BOTTOMRIGHT", element="hBackdrop", targetPoint="BOTTOMRIGHT", offsetX=0, offsetY=0 },
				},
				growthDirection = "right",  
				binding="healthPercent", colorBinding="cColor", 
			},
			{
				-- Absorb bar
				id="absorb", type="Bar", parent="health", layer=12,
				attach = 
				{
					{ point="TOPLEFT", element="health", targetPoint="TOPLEFT", offsetX=0, offsetY=0 },
					{ point="BOTTOMRIGHT", element="health", targetPoint="TOPRIGHT", offsetX=0, offsetY=2 },
				},
				growthDirection="right",
				binding="absorbPercent", color={r=0,g=1,b=1,a=1},
			},
			{
				-- Name text
				id="Name", type="Label", parent="frame", layer=30,
				attach = {{ point="CENTERLEFT", element="fBackdrop", targetPoint="CENTERRIGHT", offsetX=5, offsetY=0 }},
				visibilityBinding="name", colorBinding="bColor",
				text="{nName}", font="HM", fontSize=16, outline=true,
			},		
			{
				-- Status text
				id="Status", type="Label", parent="frame", layer=30,
				attach = {{ point="CENTERLEFT", element="Name", targetPoint="CENTERRIGHT", offsetX=0, offsetY=0 }},
				visibilityBinding="name", colorBinding="rsColor",
				text="{nStatus}", font="HM", fontSize=16, outline=true,
			},
			{
				-- Blocked/Out of Range cover frame
				id="frameBlocked", type="Frame", parent="frame", layer=110, 
				attach = 
				{ 
					{ point="TOPLEFT", element="frame", targetPoint="TOPLEFT", offsetX=1, offsetY=1, },
					{ point="BOTTOMRIGHT", element="frame", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=-1, }
				},
				visibilityBinding="blockedOrOutOfRange",
				color={r=0,g=0,b=0,a=0.7},
			}, 
			{
				-- Raid marks
				id="imgMark", type="MediaSet", parent="fBackdrop", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="TOPCENTER", offsetX=0, offsetY=0 }},
				width = 20, height = 15,
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
			{
				-- Ready check (WIP)
				id="imgReady", type="ImageSet", parent="fBackdrop", layer=30,
				attach = {{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT" }},				
				texAddon=AddonId, texFile="media/img/wtReady.png", nameBinding="readyStatus", cols=1, rows=2, 
				names = { ["ready"] = 0, ["notready"] = 1 }, defaultIndex = "hide"
			},
		}
	}
	
	if WT.UnitFrame.EnableResizableTemplate then
            WT.UnitFrame.EnableResizableTemplate(self, aRaidFrameWidth, aRaidFrameHeight, template.elements)
    end
	
		
	for idx,element in ipairs(template.elements) do
		if not options.showAbsorb and element.id == "barAbsorb" then 
			-- showElement = false
		else 
			self:CreateElement(element)
		end
	end
	

	self:SetSecureMode("restricted")
	self:SetMouseoverUnit(self.UnitSpec)
	self:SetMouseMasking("limited")
	if options.clickToTarget then
		self.Event.LeftClick = "target @" .. self.UnitSpec
	end
	if options.contextMenu then
		self.Event.RightClick = function() if self.UnitId then Command.Unit.Menu(self.UnitId) end end
	end

end

