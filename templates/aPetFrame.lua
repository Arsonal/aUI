local toc, data = ...
local AddonId = toc.identifier

-- Local config options ---------------------------------------------------------
local aPetFrameWidth = 175
local aPetFrameHeight = 40
--------------------------------------------------------------------------------
local aGadgets = {}

-- Frame Configuration Options --------------------------------------------------
local aPetFrame = WT.UnitFrame:Template("aPet")
aPetFrame.Configuration.Name = "aUI Pet Frame"
aPetFrame.Configuration.Raidsuitable = false
aPetFrame.Configuration.FrameType = "Frame"
aPetFrame.Configuration.Width = aPetFrameWidth
aPetFrame.Configuration.Height = aPetFrameHeight

if WT.UnitFrame.EnableResizableTemplate then
      aPetFrame.Configuration.Resizable = { aPetFrameWidth * 1, aPetFrameHeight * 1, aPetFrameWidth * 1, aPetFrameHeight * 1 }
end


---------------------------------------------------------------------------------
function aPetFrame:Construct(options)
	
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
				color={r=0,g=0,b=0,a=1}
			},
			{
				id="health", type="Bar", parent="fBackdrop", layer=5,
				attach = 
				{
					{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=1, offsetY=1 },
					{ point="BOTTOMRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=-1 },
				},
				growthDirection="right", --height=25
				binding="healthPercent",  color={r=0.2, g=0.2, b=0.2, a=.7}, 
				texAddon=AddonId, texFile="media/textures/Glaze2.png", alpha = .6,
				--backgroundColor={r=0.0, g=0.0, b=0.0, a=0}
			},				
--[[			{
				id="resource", type="Bar", parent="fBackdrop", layer=10,
				attach = 
				{
					{ point="BOTTOMLEFT", element="fBackdrop", targetPoint="BOTTOMLEFT", offsetX=3, offsetY=-3 },
					{ point="RIGHT", element="fBackdrop", targetPoint="RIGHT", offsetX=-3 },
				},
				binding="resourcePercent", height=6, colorBinding="rColor",
				--texAddon=AddonId, texFile="media/textures/Normtex.tga", Alpha = .8,
				backgroundColor={r=0, g=0, b=0, a=.5}
			},]]
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
				id="Name", type="Label", parent="frame", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="CENTER", offsetX=0, offsetY=0 }},
				visibilityBinding="name", colorBinding="cColor",
				text="{nameStatusT}", font="UnitframeF", fontSize=18, outline=true,
			},
		}
	}
	
	if WT.UnitFrame.EnableResizableTemplate then
            WT.UnitFrame.EnableResizableTemplate(self, aPetFrameWidth, aPetFrameHeight, template.elements)
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

