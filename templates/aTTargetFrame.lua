local toc, data = ...
local AddonId = toc.identifier

-- Local config options ---------------------------------------------------------
local aTTargetFrameWidth = 160
local aTTargetFrameHeight = 24
--------------------------------------------------------------------------------
local aGadgets = {}

-- Frame Configuration Options --------------------------------------------------
local aTTargetFrame = WT.UnitFrame:Template("aTTarget")
aTTargetFrame.Configuration.Name = "aUI Target of Target Frame"
aTTargetFrame.Configuration.Raidsuitable = false
aTTargetFrame.Configuration.FrameType = "Frame"
aTTargetFrame.Configuration.Width = aTTargetFrameWidth
aTTargetFrame.Configuration.Height = aTTargetFrameHeight

---------------------------------------------------------------------------------
function aTTargetFrame:Construct(options)
	
	table.insert(aGadgets, self)

	local template =
	{
		elements = 
		{
			{
				-- Border frame
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
				-- Health bar
				id="health", type="Bar", parent="fBackdrop", layer=5,
				attach = 
				{
					{ point="TOPLEFT", element="fBackdrop", targetPoint="TOPLEFT", offsetX=1, offsetY=1 },
					{ point="BOTTOMRIGHT", element="fBackdrop", targetPoint="BOTTOMRIGHT", offsetX=-1, offsetY=-1 },
				},
				growthDirection="right", 
				binding="healthPercent",  colorBinding="cColor", 
			},							
			{
				-- Name text
				id="Name", type="Label", parent="frame", layer=30,
				attach = {{ point="CENTER", element="fBackdrop", targetPoint="CENTER", offsetX=0, offsetY=0 }},
				visibilityBinding="name", --colorBinding="cColor",
				text="{nName}", font="HM", fontSize=18, outline=true,
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

