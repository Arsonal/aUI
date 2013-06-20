local toc, data = ...
local AddonId = toc.identifier

-- Local config options ---------------------------------------------------------
local aPetFrameWidth = 160
local aPetFrameHeight = 24
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
				growthDirection="right", --height=25,
				binding="healthPercent",  colorBinding="cColor", 
				--texAddon=AddonId, texFile="media/textures/Glaze2.png", alpha = .6,
				--backgroundColor={r=0.0, g=0.0, b=0.0, a=0}
			},							
			{
				id="Name", type="Label", parent="frame", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="CENTER", offsetX=0, offsetY=0 }},
				visibilityBinding="name", --colorBinding="cColor",
				text="{nName}", font="HM", fontSize=18, outline=true,
			},
		},
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

