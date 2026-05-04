local version, build, date, tocversion = GetBuildInfo()








macroMode = false

function PCP_GetMacroBodyEditBox()
    if MacroFrameText then return MacroFrameText end
    if MacroFrame and MacroFrameText then return MacroFrameText end
    return nil
end

function DispatchCommand(text)
    if macroMode then
        if not MacroFrame and MacroFrame_LoadUI then
            MacroFrame_LoadUI()
        end

        if MacroFrame and not MacroFrame:IsShown() and ShowMacroFrame then
            ShowMacroFrame()
        end

        local editBox = PCP_GetMacroBodyEditBox()
        if editBox then
            editBox:SetFocus()
            editBox:Insert(text .. "\n")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cff88ccff[PCP]|r Macro Mode: open /macro once, click inside the macro body, then try again.")
        end

        return
    end

    local chatChannel = GetChatChannel()
    SendChatMessage(text, chatChannel)
end

function PCPFrameRemake_OnLoad(self)
    
    if string.find(version, "^1.12") then
        DEFAULT_CHAT_FRAME:AddMessage("Running on WoW Vanilla: " .. version)
        
        
        this:SetMovable(true)
        this:SetUserPlaced(true)
        this:EnableMouse(true)
        this:RegisterForDrag("LeftButton")

        
        this:SetScript("OnDragStart", function()
            this:StartMoving()
        end)

        this:SetScript("OnDragStop", function()
            this:StopMovingOrSizing()
        end)
		PCPFrameRemake:Hide()
		
    else
        
        DEFAULT_CHAT_FRAME:AddMessage("Running on WoW Classic: " .. version)
        
        
        self:SetMovable(true)
        self:SetUserPlaced(true)
        self:EnableMouse(true)
        self:RegisterForDrag("LeftButton")

        
        self:SetScript("OnDragStart", function()
            self:StartMoving()
        end)

        self:SetScript("OnDragStop", function()
            self:StopMovingOrSizing()
        end)
		PCPFrameRemake:Show()	
		
    end
end

SLASH_MOVEFRAME1 = "/movepcp"
SlashCmdList["MOVEFRAME"] = function()
    if not PCPFrameRemake then return end  

    
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()  

    
    x = x / scale
    y = y / scale

    
    PCPFrameRemake:ClearAllPoints()
    PCPFrameRemake:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end


if not PCPFrameRemake then
	local frame = CreateFrame("Frame", "PCPFrameRemake", UIParent) 
	frame:SetWidth(260) 
	frame:SetHeight(550)

	
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)  

	local PCP_GetBackdropStyle

	
	function ToggleBackdrop(frame, enable)
		if not frame then return end
		if enable then
			local style = nil
			if PCP_GetBackdropStyle then style = PCP_GetBackdropStyle() end
			if not style then
				style = {
					bgFile = "Interface/Tooltips/UI-Tooltip-Background",
					edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
					tile = true, tileSize = 16, edgeSize = 16,
					insets = { left = 4, right = 4, top = 4, bottom = 4 },
					bgColor = { 0, 0, 0, 0.5 },
					borderColor = { 1, 1, 1, 1 },
				}
			end
			frame:SetBackdrop({
				bgFile = style.bgFile,
				edgeFile = style.edgeFile,
				tile = style.tile, tileSize = style.tileSize, edgeSize = style.edgeSize,
				insets = style.insets,
			})
			frame:SetBackdropColor(style.bgColor[1], style.bgColor[2], style.bgColor[3], style.bgColor[4])
			frame:SetBackdropBorderColor(style.borderColor[1], style.borderColor[2], style.borderColor[3], style.borderColor[4])
		else
			frame:SetBackdrop(nil) 
		end
	end
	function ToggletitlesBgCheck(PCPFrameRemake, isChecked)
		if isChecked then
			comeCommandTitleFrame.bg:Show()  
			moveCommandTitleFrame.bg:Show()
			stayCommandTitleFrame.bg:Show()
		else
			comeCommandTitleFrame.bg:Hide()  
			moveCommandTitleFrame.bg:Hide()
			stayCommandTitleFrame.bg:Hide()			
		end
	end	

	function TogglecontrollDeadBotsCheck(PCPFrameRemake, isChecked)
		controlDeadBotsEnabled = isChecked 
	end	

	function ToggleMacroModeCheck(PCPFrameRemake, isChecked)
		macroMode = isChecked
		DEFAULT_CHAT_FRAME:AddMessage(isChecked and "|cff88ccff[PCP]|r Macro mode enabled" or "|cff88ccff[PCP]|r Macro mode disabled")
	end
    
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        frame:StartMoving()
    end)
    frame:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
    end)


frame:SetResizable(true)
frame:SetMinResize(200, 300)


local resizeGrip = CreateFrame("Frame", nil, frame)
resizeGrip:SetWidth(20)
resizeGrip:SetHeight(20)
resizeGrip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, -5)  


resizeGrip.texture = resizeGrip:CreateTexture(nil, "ARTWORK")
resizeGrip.texture:SetAllPoints()
resizeGrip.texture:SetTexture("Interface\\AddOns\\PCP\\img\\ResizeGrip.tga")
  


resizeGrip.texture:SetTexCoord(0, 1, 0, 1)  
resizeGrip.texture:SetVertexColor(1, 1, 1, 1)  


resizeGrip:EnableMouse(true)
resizeGrip:SetScript("OnMouseDown", function()
    frame._pcpManualResizing = true
    frame._pcpAutoFitInProgress = false
    frame._pcpBaseLayoutHeight = frame:GetHeight() or frame._pcpBaseLayoutHeight or 550
    frame:StartSizing("BOTTOMRIGHT")
end)
resizeGrip:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
    frame._pcpManualResizing = false
    frame._pcpBaseLayoutHeight = frame:GetHeight() or frame._pcpBaseLayoutHeight or 550
    if frame:GetScript("OnSizeChanged") then frame:GetScript("OnSizeChanged")(frame) end
end)

    
    
    local overlayLayer = CreateFrame("Frame", nil, frame)
    overlayLayer:SetFrameLevel(2) 
	
    
    local titleFontString = overlayLayer:CreateFontString("AddCustomBot", "OVERLAY", "GameFontNormal")

    titleFontString:SetHeight(20)
	titleFontString:SetWidth(220)
    titleFontString:SetPoint("CENTER", 0, -25)


	
	local classNames = {"Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Shaman", "Mage", "Warlock", "Druid"}
	local currentClassIndex = 1  

	
	local classDisplayFontString = overlayLayer:CreateFontString("classDisplay", "OVERLAY", "GameFontNormal")
	classDisplayFontString:SetText(classNames[currentClassIndex])
	classDisplayFontString:SetHeight(220)
	classDisplayFontString:SetWidth(20)
	classDisplayFontString:SetPoint("CENTER", 0, -60)

	
	local function UpdateClassDisplay()
		classDisplayFontString:SetText(classNames[currentClassIndex])
	end


local isCustomAppearanceEnabled = false
local defaultColor = "originalButtons"  
local settingsLoaded = false


local function PCP_GetCurrentThemeColor()
    if PCP_Settings and PCP_Settings.color then
        return PCP_Settings.color
    end
    return defaultColor or "originalButtons"
end

local function PCP_GetThemeColors(color)
    color = color or PCP_GetCurrentThemeColor()

    if color == "dathw" or color == "DathW" then
        return {
            bg = { 0.04, 0.05, 0.09, 0.92 },
            gradTop = { 0.25, 0.30, 0.50, 0.35 },
            gradBottom = { 0.00, 0.00, 0.00, 0.30 },
            border = { 0.10, 0.12, 0.18, 1 },
            text = { 1, 0.82, 0, 1 },
            highlight = { 1, 0.82, 0, 0.16 },
            pushed = { 0.02, 0.02, 0.04, 1 },
            frameBg = { 0.02, 0.03, 0.05, 0.78 },
            frameBorder = { 0.10, 0.12, 0.18, 1 },
            edgeSize = 12, tileSize = 32, insets = { left = 3, right = 3, top = 3, bottom = 3 },
        }
    elseif color == "darkglass" then
        return { bg = { 0.05, 0.05, 0.05, 0.82 }, gradTop = { 0.90, 0.90, 0.90, 0.18 }, gradBottom = { 0, 0, 0, 0.30 }, border = { 0.32, 0.32, 0.32, 0.70 }, text = { 1, 1, 1, 1 }, highlight = { 1, 1, 1, 0.13 }, pushed = { 0.02, 0.02, 0.02, 1 }, frameBg = { 0.04, 0.04, 0.04, 0.86 }, frameBorder = { 0.32, 0.32, 0.32, 0.70 } }
    elseif color == "warcraftgold" then
        return { bg = { 0.15, 0.10, 0.02, 0.94 }, gradTop = { 1.00, 0.85, 0.25, 0.35 }, gradBottom = { 0, 0, 0, 0.30 }, border = { 1.00, 0.82, 0.00, 0.92 }, text = { 1, 0.82, 0, 1 }, highlight = { 1, 0.82, 0, 0.18 }, pushed = { 0.35, 0.18, 0.02, 1 }, frameBg = { 0.08, 0.06, 0.02, 0.90 }, frameBorder = { 1.00, 0.82, 0.00, 1 } }
    elseif color == "shadowblue" then
        return { bg = { 0.02, 0.04, 0.12, 0.90 }, gradTop = { 0.40, 0.60, 1.00, 0.35 }, gradBottom = { 0, 0, 0.05, 0.30 }, border = { 0.30, 0.50, 1.00, 0.76 }, text = { 0.82, 0.92, 1, 1 }, highlight = { 0.35, 0.55, 1, 0.20 }, pushed = { 0.02, 0.08, 0.24, 1 }, frameBg = { 0.02, 0.04, 0.12, 0.90 }, frameBorder = { 0.30, 0.50, 1.00, 0.76 } }
    elseif color == "bloodred" then
        return { bg = { 0.12, 0.02, 0.02, 0.94 }, gradTop = { 1.00, 0.20, 0.20, 0.35 }, gradBottom = { 0, 0, 0, 0.35 }, border = { 0.80, 0.10, 0.10, 0.95 }, text = { 1, 0.86, 0.82, 1 }, highlight = { 1, 0.18, 0.14, 0.18 }, pushed = { 0.28, 0.02, 0.02, 1 }, frameBg = { 0.10, 0.02, 0.02, 0.90 }, frameBorder = { 0.80, 0.10, 0.10, 1 } }
    elseif color == "minimalflat" then
        return { bg = { 0.12, 0.12, 0.12, 0.60 }, gradTop = { 1, 1, 1, 0.12 }, gradBottom = { 0, 0, 0, 0.22 }, border = { 0, 0, 0, 0 }, text = { 1, 1, 1, 1 }, highlight = { 1, 1, 1, 0.08 }, pushed = { 0.06, 0.06, 0.06, 1 }, frameBg = { 0.10, 0.10, 0.10, 0.62 }, frameBorder = { 0, 0, 0, 0 }, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 } }
    elseif color == "pink" then
        return { bg = { 0.55, 0.20, 0.32, 0.72 }, gradTop = { 1.00, 0.72, 0.86, 0.18 }, gradBottom = { 0.12, 0, 0.04, 0.34 }, border = { 1.00, 0.55, 0.72, 0.58 }, text = { 1, 0.92, 0.96, 1 }, highlight = { 1, 0.55, 0.72, 0.16 }, pushed = { 0.35, 0.06, 0.14, 1 }, frameBg = { 0.12, 0.03, 0.07, 0.78 }, frameBorder = { 1, 0.55, 0.72, 0.55 } }
    elseif color == "solidpink" then
        return { bg = { 0.72, 0.30, 0.44, 0.94 }, gradTop = { 1, 1, 1, 0.22 }, gradBottom = { 0.10, 0, 0.05, 0.35 }, border = { 1, 0.58, 0.76, 0.86 }, text = { 1, 0.94, 0.98, 1 }, highlight = { 1, 0.60, 0.78, 0.20 }, pushed = { 0.45, 0.08, 0.18, 1 }, frameBg = { 0.14, 0.04, 0.08, 0.88 }, frameBorder = { 1, 0.58, 0.76, 0.75 } }
    elseif color == "green" then
        return { bg = { 0.06, 0.28, 0.08, 0.72 }, gradTop = { 0.45, 0.95, 0.45, 0.18 }, gradBottom = { 0, 0.05, 0, 0.36 }, border = { 0.35, 0.82, 0.35, 0.58 }, text = { 0.88, 1, 0.88, 1 }, highlight = { 0.40, 1, 0.40, 0.16 }, pushed = { 0.02, 0.18, 0.04, 1 }, frameBg = { 0.02, 0.09, 0.03, 0.78 }, frameBorder = { 0.35, 0.82, 0.35, 0.55 } }
    elseif color == "solidgreen" then
        return { bg = { 0.04, 0.45, 0.07, 0.94 }, gradTop = { 1, 1, 1, 0.22 }, gradBottom = { 0, 0.10, 0, 0.35 }, border = { 0.38, 0.92, 0.38, 0.86 }, text = { 0.90, 1, 0.90, 1 }, highlight = { 0.42, 1, 0.42, 0.20 }, pushed = { 0.02, 0.24, 0.04, 1 }, frameBg = { 0.02, 0.10, 0.03, 0.88 }, frameBorder = { 0.38, 0.92, 0.38, 0.75 } }
    elseif color == "blue" then
        return { bg = { 0.03, 0.08, 0.34, 0.72 }, gradTop = { 0.35, 0.55, 1, 0.18 }, gradBottom = { 0, 0, 0.08, 0.38 }, border = { 0.35, 0.55, 1, 0.58 }, text = { 0.86, 0.93, 1, 1 }, highlight = { 0.35, 0.55, 1, 0.16 }, pushed = { 0.02, 0.06, 0.22, 1 }, frameBg = { 0.02, 0.03, 0.10, 0.78 }, frameBorder = { 0.35, 0.55, 1, 0.55 } }
    elseif color == "solidblue" then
        return { bg = { 0.04, 0.12, 0.55, 0.94 }, gradTop = { 1, 1, 1, 0.25 }, gradBottom = { 0, 0, 0.10, 0.35 }, border = { 0.38, 0.60, 1, 0.86 }, text = { 0.88, 0.94, 1, 1 }, highlight = { 0.40, 0.62, 1, 0.20 }, pushed = { 0.02, 0.08, 0.28, 1 }, frameBg = { 0.02, 0.04, 0.12, 0.88 }, frameBorder = { 0.38, 0.60, 1, 0.75 } }
    elseif color == "gray" then
        return { bg = { 0.26, 0.26, 0.26, 0.72 }, gradTop = { 1, 1, 1, 0.20 }, gradBottom = { 0, 0, 0, 0.30 }, border = { 0.70, 0.70, 0.70, 0.58 }, text = { 1, 1, 1, 1 }, highlight = { 1, 1, 1, 0.12 }, pushed = { 0.12, 0.12, 0.12, 1 }, frameBg = { 0.08, 0.08, 0.08, 0.78 }, frameBorder = { 0.70, 0.70, 0.70, 0.50 } }
    elseif color == "solidgray" then
        return { bg = { 0.42, 0.42, 0.42, 0.94 }, gradTop = { 1, 1, 1, 0.22 }, gradBottom = { 0, 0, 0, 0.35 }, border = { 0.82, 0.82, 0.82, 0.84 }, text = { 1, 1, 1, 1 }, highlight = { 1, 1, 1, 0.16 }, pushed = { 0.18, 0.18, 0.18, 1 }, frameBg = { 0.10, 0.10, 0.10, 0.88 }, frameBorder = { 0.82, 0.82, 0.82, 0.70 } }
    elseif color == "black" then
        return { bg = { 0.02, 0.02, 0.02, 0.86 }, gradTop = { 0.80, 0.80, 0.80, 0.18 }, gradBottom = { 0, 0, 0, 0.30 }, border = { 0.30, 0.30, 0.30, 0.82 }, text = { 1, 1, 1, 1 }, highlight = { 1, 1, 1, 0.10 }, pushed = { 0, 0, 0, 1 }, frameBg = { 0.01, 0.01, 0.01, 0.88 }, frameBorder = { 0.30, 0.30, 0.30, 0.75 } }
    end

    return nil
end

PCP_GetBackdropStyle = function()
    local theme = PCP_GetThemeColors()
    if theme then
        return {
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = theme.tileSize or 16, edgeSize = theme.edgeSize or 12,
            insets = theme.insets or { left = 3, right = 3, top = 3, bottom = 3 },
            bgColor = theme.frameBg or theme.bg,
            borderColor = theme.frameBorder or theme.border,
        }
    end
    return nil
end




local function SaveSettings(color, backdropEnabled, titlesBgEnabled, controllDeadBotsEnabled)
    if not PCP_Settings then
        PCP_Settings = {}  
    end
    
    if color ~= nil then
        PCP_Settings.color = color
    end
    if backdropEnabled ~= nil then
        PCP_Settings.backdropEnabled = backdropEnabled
    end
    if titlesBgEnabled ~= nil then
        PCP_Settings.titlesBgEnabled = titlesBgEnabled  
    end
    if controllDeadBotsEnabled ~= nil then
        PCP_Settings.controllDeadBotsEnabled = controllDeadBotsEnabled  
    end	
end


local allButtons = {}

local closeButton = CreateFrame("Button", nil, PCPFrameRemake)
closeButton:SetHeight(16)  
closeButton:SetWidth(16)
closeButton:SetPoint("TOPRIGHT", PCPFrameRemake, "TOPRIGHT", -5, -5) 


closeButton:SetNormalTexture("Interface\\AddOns\\PCP\\img\\close.tga")


closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")


closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")


closeButton:SetScript("OnClick", function()
    PCPFrameRemake:Hide()
end)


closeButton:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Close", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
closeButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)


table.insert(allButtons, closeButton)




local settingsButton = CreateFrame("Button", nil, PCPFrameRemake, "UIPanelButtonTemplate")
settingsButton:SetHeight(16)  
settingsButton:SetWidth(16)
settingsButton:SetPoint("TOPLEFT", PCPFrameRemake, "TOPLEFT", 5, -5) 
settingsButton:SetNormalTexture("Interface\\AddOns\\PCP\\img\\settings.tga")


table.insert(allButtons, settingsButton)


settingsButton:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Settings", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
settingsButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)




local controlsFrame = CreateFrame("Frame", "PCPControlsFrame", frame)
controlsFrame:SetWidth(220)
controlsFrame:SetHeight(28)
controlsFrame:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 8)
controlsFrame:Hide()

local function ResizeControlsButtons()
    if not controlsFrame then return end
    local w = controlsFrame:GetWidth() or 220
    local h = controlsFrame:GetHeight() or 28
    local size = math.min(h - 8, (w - 18) / 2)
    if size < 12 then size = 12 end
    if size > 24 then size = 24 end

    settingsButton:SetWidth(size)
    settingsButton:SetHeight(size)
    closeButton:SetWidth(size)
    closeButton:SetHeight(size)

    settingsButton:ClearAllPoints()
    settingsButton:SetPoint("LEFT", controlsFrame, "LEFT", 7, 0)

    closeButton:ClearAllPoints()
    closeButton:SetPoint("RIGHT", controlsFrame, "RIGHT", -7, 0)
end


local settingsFrame = CreateFrame("Frame", "PCPSettingsFrame", PCPFrameRemake)
settingsFrame:SetHeight(250)
settingsFrame:SetWidth(230) 
settingsFrame:SetPoint("RIGHT", PCPFrameRemake, "LEFT", -10, 0) 
settingsFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
settingsFrame:SetBackdropColor(0, 0, 0, 0.8) 
settingsFrame:SetFrameStrata("FULLSCREEN_DIALOG")
settingsFrame:SetFrameLevel(200)
if settingsFrame.SetToplevel then settingsFrame:SetToplevel(true) end
settingsFrame:Hide() 


local versionText = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
versionText:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -10, 10) 
versionText:SetText("Version 2.0") 
versionText:SetTextColor(1, 1, 1, 1) 


local ClickBlockerFrame = CreateFrame("Frame", "ClickBlockerFrame", UIParent)
ClickBlockerFrame:SetAllPoints(UIParent) 
ClickBlockerFrame:EnableMouse(true) 
ClickBlockerFrame:SetFrameStrata("DIALOG")  
ClickBlockerFrame:SetFrameLevel(1)  
ClickBlockerFrame:Hide() 

ClickBlockerFrame:SetScript("OnMouseDown", function()
    ClickBlockerFrame:Hide() 
    settingsFrame:Hide()  
end)


local function ToggleSettingsFrame()
    if settingsFrame:IsShown() then
        settingsFrame:Hide()
        ClickBlockerFrame:Hide()  
    else
        if settingsFrame.SetFrameStrata then settingsFrame:SetFrameStrata("FULLSCREEN_DIALOG") end
        if settingsFrame.SetFrameLevel then settingsFrame:SetFrameLevel(200) end
        if settingsFrame.SetToplevel then settingsFrame:SetToplevel(true) end
        settingsFrame:Show()
        ClickBlockerFrame:Show()  
        if settingsFrame.Raise then settingsFrame:Raise() end
    end
end



settingsButton:SetScript("OnClick", ToggleSettingsFrame)


local dropdownFrame = CreateFrame("Frame", "PCPColorDropdown", settingsFrame)
dropdownFrame:SetWidth(180)
dropdownFrame:SetHeight(30)
dropdownFrame:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -10)


local dropdownButton = CreateFrame("Button", "PCPColorDropdownButton", dropdownFrame, "UIPanelButtonTemplate")
dropdownButton:SetWidth(180)
dropdownButton:SetHeight(30)
dropdownButton:SetPoint("CENTER", dropdownFrame, "CENTER")
dropdownButton:SetText("Select Color")


local dropdownMenu = CreateFrame("Frame", "PCPColorDropdownMenu", dropdownFrame)
dropdownMenu:SetWidth(180)
dropdownMenu:SetHeight(360)
dropdownMenu:SetPoint("TOP", dropdownButton, "BOTTOM", 0, -5)
dropdownMenu:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
dropdownMenu:SetBackdropColor(0, 0, 0, 0.8)
dropdownMenu:Hide()


dropdownButton:SetScript("OnClick", function()
    if dropdownMenu:IsShown() then
        dropdownMenu:Hide()
    else
        dropdownMenu:Show()
    end
end)


local colorOptions = {
    { text = "Original", color = "originalButtons" },
    { text = "DathW", color = "dathw" },
    { text = "DarkGlass", color = "darkglass" },
    { text = "WarcraftGold", color = "warcraftgold" },
    { text = "ShadowBlue", color = "shadowblue" },
    { text = "BloodRed", color = "bloodred" },
    { text = "MinimalFlat", color = "minimalflat" },
    { text = "Pink", color = "pink" },
    { text = "Pink solid", color = "solidpink" },
    { text = "Green", color = "green" },
    { text = "Green solid", color = "solidgreen" },
    { text = "Blue", color = "blue" },
    { text = "Blue solid", color = "solidblue" },
    { text = "Gray", color = "gray" },
    { text = "Gray solid", color = "solidgray" },
    { text = "Black", color = "black" }
}


local function OnOptionClick()
    local selectedText = this:GetText()
    local selectedColor = this.color

    dropdownButton:SetText(selectedText or "Select Color")
    dropdownMenu:Hide()

    if selectedColor then
        
        
        if not PCP_Settings then PCP_Settings = {} end
        PCP_Settings.color = selectedColor
        defaultColor = selectedColor
        SaveSettings(selectedColor)

        toggleButtonAppearance(true, selectedColor)
        DEFAULT_CHAT_FRAME:AddMessage("|cff88ccff[PCP]|r Theme changed to " .. (selectedText or selectedColor))
    end
end



for i, option in ipairs(colorOptions) do
    local optionButton = CreateFrame("Button", nil, dropdownMenu, "UIPanelButtonTemplate")
    optionButton:SetWidth(170)
    optionButton:SetHeight(20)
    optionButton:SetPoint("TOPLEFT", dropdownMenu, "TOPLEFT", 5, -((i - 1) * 22 + 5))
    optionButton:SetText(option.text)
    optionButton.color = option.color

    
    optionButton:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight", "ADD")

    
    optionButton:SetScript("OnClick", OnOptionClick)
end


function ShowReloadConfirmation(selectedColor)
    
    
    if PCPReloadFrame then
        PCPReloadFrame:Show()
        return
    end

    
    local reloadFrame = CreateFrame("Frame", "PCPReloadFrame", UIParent)
	reloadFrame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	reloadFrame:SetBackdropColor(0, 0, 0, 0.8)

    reloadFrame:SetWidth(300)
	reloadFrame:SetHeight(100)
    reloadFrame:SetPoint("CENTER", UIParent, "CENTER")
    reloadFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    reloadFrame:SetBackdropColor(0, 0, 0, 0.8)
    reloadFrame:SetMovable(true)
    reloadFrame:EnableMouse(true)
    reloadFrame:RegisterForDrag("LeftButton")
    reloadFrame:SetScript("OnDragStart", reloadFrame.StartMoving)
    reloadFrame:SetScript("OnDragStop", reloadFrame.StopMovingOrSizing)

    
    local reloadText = reloadFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    reloadText:SetPoint("TOP", reloadFrame, "TOP", 0, -10)
    reloadText:SetText("Reload UI to apply changes?")

    
    local yesButton = CreateFrame("Button", nil, reloadFrame, "UIPanelButtonTemplate")
    yesButton:SetWidth(80)
	yesButton:SetHeight(30)
    yesButton:SetPoint("BOTTOMLEFT", reloadFrame, "BOTTOMLEFT", 40, 10)
    yesButton:SetText("Yes")
    yesButton:SetScript("OnClick", function()
        toggleButtonAppearance(true, selectedColor) 
        ReloadUI() 
    end)

    
    local noButton = CreateFrame("Button", nil, reloadFrame, "UIPanelButtonTemplate")
    noButton:SetWidth(80)
	noButton:SetHeight(30)
    noButton:SetPoint("BOTTOMRIGHT", reloadFrame, "BOTTOMRIGHT", -40, 10)
    noButton:SetText("No")
    noButton:SetScript("OnClick", function()
        reloadFrame:Hide() 
    end)

    
    PCPReloadFrame = reloadFrame
end



local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnMouseDown", CloseSettingsOnClick)
eventFrame:SetFrameStrata("TOOLTIP")
eventFrame:EnableMouse(true)


local backdropCheck = CreateFrame("CheckButton", "PCPBackdropCheck", settingsFrame, "UICheckButtonTemplate")
backdropCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -40)
backdropCheck.text = backdropCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
backdropCheck.text:SetPoint("LEFT", backdropCheck, "RIGHT", 5, 0)
backdropCheck.text:SetText("Enable Backdrop")
backdropCheck:SetChecked(true)  


backdropCheck:SetScript("OnClick", function()
    local isChecked = this:GetChecked() == 1  
    ToggleBackdrop(PCPFrameRemake, isChecked)
    SaveSettings(defaultColor, isChecked)  
end)


local titlesBgCheck = CreateFrame("CheckButton", "PCPtitlesBgCheck", settingsFrame, "UICheckButtonTemplate")
titlesBgCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -70)
titlesBgCheck.text = titlesBgCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titlesBgCheck.text:SetPoint("LEFT", titlesBgCheck, "RIGHT", 5, 0)
titlesBgCheck.text:SetText("Enable title bg")
titlesBgCheck:SetChecked(true)  


titlesBgCheck:SetScript("OnClick", function()
    local isChecked = this:GetChecked() == 1  
    ToggletitlesBgCheck(PCPFrameRemake, isChecked)
    SaveSettings(defaultColor, nil, isChecked)  
end)

local controllDeadBotsCheck = CreateFrame("CheckButton", "PCPcontrollDeadBotsCheck", settingsFrame, "UICheckButtonTemplate")
controllDeadBotsCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -100)
controllDeadBotsCheck.text = controllDeadBotsCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
controllDeadBotsCheck.text:SetPoint("LEFT", controllDeadBotsCheck, "RIGHT", 5, 0)
controllDeadBotsCheck.text:SetText("Dead Controll")
controllDeadBotsCheck:SetChecked(true)  
controllDeadBotsCheck:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Allows you to control bots even after dying.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)

controllDeadBotsCheck:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)


controllDeadBotsCheck:SetScript("OnClick", function()
    local isChecked = this:GetChecked() == 1  
    TogglecontrollDeadBotsCheck(PCPFrameRemake, isChecked)
    SaveSettings(defaultColor, nil, nil, isChecked)  
	local status = isChecked and "|cFF00FF00enabled|r" or "|cFFFF0000disabled|r"
	DEFAULT_CHAT_FRAME:AddMessage("Dead bot control: "..status)
end)


local macroModeCheck = CreateFrame("CheckButton", "PCPmacroModeCheck", settingsFrame, "UICheckButtonTemplate")
macroModeCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -130)
macroModeCheck.text = macroModeCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
macroModeCheck.text:SetPoint("LEFT", macroModeCheck, "RIGHT", 5, 0)
macroModeCheck.text:SetText("Macro Mode")
macroModeCheck:SetChecked(false)
macroModeCheck:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Click PCP buttons to insert commands into the macro body instead of sending them to your bots.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
macroModeCheck:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
macroModeCheck:SetScript("OnClick", function()
    local isChecked = this:GetChecked() == 1
    ToggleMacroModeCheck(PCPFrameRemake, isChecked)
end)


local paladinBuffRotationCheck = CreateFrame("CheckButton", "PCPPaladinBuffRotationCheck", settingsFrame, "UICheckButtonTemplate")
paladinBuffRotationCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -160)
paladinBuffRotationCheck.text = paladinBuffRotationCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
paladinBuffRotationCheck.text:SetPoint("LEFT", paladinBuffRotationCheck, "RIGHT", 5, 0)
paladinBuffRotationCheck.text:SetText("Paladin buff rotation")
paladinBuffRotationCheck:SetChecked(true)
paladinBuffRotationCheck:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Automatically rotates blessings when adding Paladins. The shown blessing is used for the next Paladin, then it moves to the next blessing.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
paladinBuffRotationCheck:SetScript("OnLeave", function() GameTooltip:Hide() end)
paladinBuffRotationCheck:SetScript("OnClick", function()
    if not PCP_Settings then PCP_Settings = {} end
    PCP_Settings.paladinBuffRotation = this:GetChecked() == 1
    if PCP_NormalizePaladinBlessingForRotation then PCP_NormalizePaladinBlessingForRotation() end
    if PCP_UpdateSpawnConfigButtonText then PCP_UpdateSpawnConfigButtonText() end
    if PCP_RefreshSpawnOptionsFrame and PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown() then PCP_RefreshSpawnOptionsFrame() end
end)



local freeSectionLayoutCheck = CreateFrame("CheckButton", "PCPFreeSectionLayoutCheck", settingsFrame, "UICheckButtonTemplate")
freeSectionLayoutCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -190)
freeSectionLayoutCheck.text = freeSectionLayoutCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
freeSectionLayoutCheck.text:SetPoint("LEFT", freeSectionLayoutCheck, "RIGHT", 5, 0)
freeSectionLayoutCheck.text:SetText("Free section layout")
freeSectionLayoutCheck:SetChecked(false)
freeSectionLayoutCheck:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Enable this, then hold ALT + drag a section background to move it. Positions are saved.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
freeSectionLayoutCheck:SetScript("OnLeave", function() GameTooltip:Hide() end)
freeSectionLayoutCheck:SetScript("OnClick", function()
    if not PCP_Settings then PCP_Settings = {} end
    PCP_Settings.freeSectionLayout = this:GetChecked() == 1
    if ApplyPCPSectionLayout then ApplyPCPSectionLayout(PCPFrameRemake) end
    if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
end)


local resizableSectionsCheck = CreateFrame("CheckButton", "PCPResizableSectionsCheck", settingsFrame, "UICheckButtonTemplate")
resizableSectionsCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -220)
resizableSectionsCheck.text = resizableSectionsCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
resizableSectionsCheck.text:SetPoint("LEFT", resizableSectionsCheck, "RIGHT", 5, 0)
resizableSectionsCheck.text:SetText("Resizable sections")
resizableSectionsCheck:SetChecked(false)
resizableSectionsCheck:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Shows a small bottom-right resize grip on each section. Section sizes are saved individually.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
resizableSectionsCheck:SetScript("OnLeave", function() GameTooltip:Hide() end)
resizableSectionsCheck:SetScript("OnClick", function()
    if not PCP_Settings then PCP_Settings = {} end
    PCP_Settings.resizableSections = this:GetChecked() == 1
    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
    if ApplyPCPSectionLayout then ApplyPCPSectionLayout(PCPFrameRemake) end
end)

local resetSectionLayoutButton = CreateFrame("Button", "PCPResetSectionLayoutButton", settingsFrame, "UIPanelButtonTemplate")
resetSectionLayoutButton:SetWidth(150)
resetSectionLayoutButton:SetHeight(22)
resetSectionLayoutButton:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 25, -255)
resetSectionLayoutButton:SetText("Reset section layout")
resetSectionLayoutButton:SetScript("OnClick", function()
    if ResetPCPSectionPositions then ResetPCPSectionPositions() end
end)

local sectionVisibilityButton = CreateFrame("Button", "PCPSectionVisibilityButton", settingsFrame, "UIPanelButtonTemplate")
sectionVisibilityButton:SetWidth(150)
sectionVisibilityButton:SetHeight(22)
sectionVisibilityButton:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 25, -285)
sectionVisibilityButton:SetText("Visible sections")
sectionVisibilityButton:SetScript("OnClick", function()
    if PCP_ShowSectionOptions then PCP_ShowSectionOptions() end
end)

local function PCP_UpdateSettingsFrameSize()
    settingsFrame:SetWidth(230)
    settingsFrame:SetHeight(360)
    versionText:ClearAllPoints()
    versionText:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -10, 10)
end
PCP_UpdateSettingsFrameSize()


ToggleBackdrop(PCPFrameRemake, backdropCheck:GetChecked())

function LoadSavedSettings()
    if PCP_Settings then
        
        if PCP_Settings.color then
            defaultColor = PCP_Settings.color
        else
            defaultColor = "originalButtons"  
        end
        if dropdownButton and colorOptions then
            local selectedThemeName = nil
            for _, option in ipairs(colorOptions) do
                if option.color == defaultColor or (defaultColor == "DathW" and option.color == "dathw") then
                    selectedThemeName = option.text
                end
            end
            if selectedThemeName then dropdownButton:SetText(selectedThemeName) end
        end

        
        if PCP_Settings.backdropEnabled ~= nil then
            backdropCheck:SetChecked(PCP_Settings.backdropEnabled)
            ToggleBackdrop(PCPFrameRemake, PCP_Settings.backdropEnabled)
        end

        
        if PCP_Settings.titlesBgEnabled ~= nil then
            titlesBgCheck:SetChecked(PCP_Settings.titlesBgEnabled)  
            ToggletitlesBgCheck(PCPFrameRemake, PCP_Settings.titlesBgEnabled)  
        end
		
        if PCP_Settings.controllDeadBotsEnabled ~= nil then
            controllDeadBotsCheck:SetChecked(PCP_Settings.controllDeadBotsEnabled)  
            TogglecontrollDeadBotsCheck(PCPFrameRemake, PCP_Settings.controllDeadBotsEnabled)  
        end

        if PCP_Settings.paladinBuffRotation == nil then
            PCP_Settings.paladinBuffRotation = true
        end
        if paladinBuffRotationCheck then
            paladinBuffRotationCheck:SetChecked(PCP_Settings.paladinBuffRotation)
        end

        if PCP_Settings.freeSectionLayout ~= nil and freeSectionLayoutCheck then
            freeSectionLayoutCheck:SetChecked(PCP_Settings.freeSectionLayout)
        elseif freeSectionLayoutCheck then
            freeSectionLayoutCheck:SetChecked(false)
        end
        if PCP_Settings.resizableSections ~= nil and resizableSectionsCheck then
            resizableSectionsCheck:SetChecked(PCP_Settings.resizableSections)
        elseif resizableSectionsCheck then
            resizableSectionsCheck:SetChecked(false)
        end
    else
        if not PCP_Settings then PCP_Settings = {} end
        PCP_Settings.paladinBuffRotation = true
        if paladinBuffRotationCheck then paladinBuffRotationCheck:SetChecked(true) end
        if freeSectionLayoutCheck then freeSectionLayoutCheck:SetChecked(false) end
        if resizableSectionsCheck then resizableSectionsCheck:SetChecked(false) end
    end

    if PCP_NormalizePaladinBlessingForRotation then PCP_NormalizePaladinBlessingForRotation() end
    if PCP_UpdateSpawnOptionButtons then PCP_UpdateSpawnOptionButtons() end
    if PCP_ApplySectionVisibility then PCP_ApplySectionVisibility() end

    
    toggleButtonAppearance(true, defaultColor)
    if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
end






function createButton(name, text, xOffset, yOffset, onClickFunc, width, height, parentFrame)
	local button = CreateFrame("Button", name, parentFrame, "UIPanelButtonTemplate")  
    
        
        
        
        


    button:SetHeight(height)
	button:SetWidth(width)
    button:SetPoint("CENTER", parentFrame, "CENTER", xOffset, yOffset)
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

    
    table.insert(allButtons, button)

    
    if parentFrame == ComeCommandFrame then 
        button:SetScript("OnEnter", function()
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
            GameTooltip:SetText("Come " .. text .. " ")
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    elseif parentFrame == MoveCommandFrame then 
        button:SetScript("OnEnter", function()
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
            GameTooltip:SetText("Move " .. text .. " ")
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)    
    elseif parentFrame == StayCommandFrame then 
        button:SetScript("OnEnter", function()
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
            GameTooltip:SetText("Stay " .. text .. " ")
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    return button
end




function toggleButtonAppearance(enabled, color)
    isCustomAppearanceEnabled = enabled
    color = color or defaultColor or "originalButtons"
    defaultColor = color
    SaveSettings(color)

    local function PCP_CanVertexColor(obj)
        return obj and obj.SetVertexColor
    end
    local function PCP_CanShow(obj)
        return obj and obj.Show
    end
    local function PCP_CanHide(obj)
        return obj and obj.Hide
    end

    local function PCP_ApplyThemeNormalVisual(button, theme)
        if not button or not theme then return end
        if button._pcpThemeBg and button._pcpThemeBg.SetVertexColor and theme.bg then
            button._pcpThemeBg:SetVertexColor(theme.bg[1], theme.bg[2], theme.bg[3], theme.bg[4])
        end
        if button._pcpThemeGradientTop and button._pcpThemeGradientTop.SetVertexColor and button._pcpThemeGradTopBase then
            local t = button._pcpThemeGradTopBase
            button._pcpThemeGradientTop:SetVertexColor(t[1], t[2], t[3], t[4])
        end
        if button._pcpThemeGradientBottom and button._pcpThemeGradientBottom.SetVertexColor and button._pcpThemeGradBottomBase then
            local b = button._pcpThemeGradBottomBase
            button._pcpThemeGradientBottom:SetVertexColor(b[1], b[2], b[3], b[4])
        end
        if button._pcpThemePushed and button._pcpThemePushed.Hide then
            button._pcpThemePushed:Hide()
        end
        if button.SetButtonState then button:SetButtonState("NORMAL") end
    end

    local function PCP_ApplyThemePressedVisual(button, theme)
        if not button or not theme then return end
        if button._pcpThemeBg and button._pcpThemeBg.SetVertexColor and theme.pushed then
            button._pcpThemeBg:SetVertexColor(theme.pushed[1], theme.pushed[2], theme.pushed[3], theme.pushed[4])
        end
    end

    local function PCP_HookThemePressReset(button, theme)
        
        
        
        
        return
    end

    if backdropCheck then
        ToggleBackdrop(PCPFrameRemake, backdropCheck:GetChecked())
    end

    local theme = PCP_GetThemeColors(color)

    for _, button in ipairs(allButtons) do
        if button then
            
            local oldLayers = {
                "_pcpThemeBg", "_pcpThemeGradientTop", "_pcpThemeGradientBottom",
                "_pcpThemeBorder", "_pcpThemeHighlight", "_pcpThemePushed",
                "_pcpOriginalNormal", "_pcpOriginalHighlight", "_pcpOriginalPushed", "_pcpOriginalDisabled",
                "_pcpSettingsIcon", "_pcpCloseIcon",
            }
            for _, key in ipairs(oldLayers) do
                if PCP_CanHide(button[key]) then button[key]:Hide() end
            end

            button:SetNormalTexture(nil)
            button:SetHighlightTexture(nil)
            button:SetPushedTexture(nil)
            button:SetDisabledTexture(nil)

            local fs = button.GetFontString and button:GetFontString()
            if fs then
                if theme and theme.text then
                    fs:SetTextColor(theme.text[1], theme.text[2], theme.text[3], theme.text[4])
                else
                    fs:SetTextColor(1, 1, 1, 1)
                end
            end

            if color == "originalButtons" or not theme then
                
                
                
                
                
                button._pcpOriginalNormal = nil
                button._pcpOriginalHighlight = nil
                button._pcpOriginalPushed = nil
                button._pcpOriginalDisabled = nil

                button:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
                local normalTexture = button:GetNormalTexture()
                if normalTexture then
                    normalTexture:SetTexCoord(0, 0.625, 0, 0.6875)
                    normalTexture:SetVertexColor(1, 1, 1, 1)
                    normalTexture:Show()
                end

                button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
                local highlightTexture = button:GetHighlightTexture()
                if highlightTexture then
                    highlightTexture:SetTexCoord(0, 0.625, 0, 0.6875)
                    highlightTexture:SetVertexColor(1, 1, 1, 1)
                    if highlightTexture.SetBlendMode then highlightTexture:SetBlendMode("ADD") end
                end

                button:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
                local pushedTexture = button:GetPushedTexture()
                if pushedTexture then
                    pushedTexture:SetTexCoord(0, 0.625, 0, 0.6875)
                    pushedTexture:SetVertexColor(1, 1, 1, 1)
                    pushedTexture:Show()
                end

                button:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
                local disabledTexture = button:GetDisabledTexture()
                if disabledTexture then
                    disabledTexture:SetTexCoord(0, 0.625, 0, 0.6875)
                    disabledTexture:SetVertexColor(1, 1, 1, 1)
                end
            else
                if button._pcpThemeBg and not PCP_CanShow(button._pcpThemeBg) then
                    button._pcpThemeBg = nil
                end
                if not button._pcpThemeBg then
                    button._pcpThemeBg = button:CreateTexture(nil, "BACKGROUND")
                    button._pcpThemeBg:SetTexture("Interface\\AddOns\\PCP\\img\\bg.tga")
                    button._pcpThemeBg:SetAllPoints(button)
                end
                if PCP_CanVertexColor(button._pcpThemeBg) then button._pcpThemeBg:SetVertexColor(theme.bg[1], theme.bg[2], theme.bg[3], theme.bg[4]) end
                if PCP_CanShow(button._pcpThemeBg) then button._pcpThemeBg:Show() end

                if theme.gradTop then
                    if not button._pcpThemeGradientTop then
                        button._pcpThemeGradientTop = button:CreateTexture(nil, "ARTWORK")
                        button._pcpThemeGradientTop:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                    end
                    button._pcpThemeGradientTop:ClearAllPoints()
                    button._pcpThemeGradientTop:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
                    button._pcpThemeGradientTop:SetPoint("BOTTOMRIGHT", button, "RIGHT", -1, 0)
                    if PCP_CanVertexColor(button._pcpThemeGradientTop) then button._pcpThemeGradientTop:SetVertexColor(theme.gradTop[1], theme.gradTop[2], theme.gradTop[3], theme.gradTop[4]) end
                    if PCP_CanShow(button._pcpThemeGradientTop) then button._pcpThemeGradientTop:Show() end
                end

                if theme.gradBottom then
                    if not button._pcpThemeGradientBottom then
                        button._pcpThemeGradientBottom = button:CreateTexture(nil, "ARTWORK")
                        button._pcpThemeGradientBottom:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                    end
                    button._pcpThemeGradientBottom:ClearAllPoints()
                    button._pcpThemeGradientBottom:SetPoint("TOPLEFT", button, "LEFT", 1, 0)
                    button._pcpThemeGradientBottom:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
                    if PCP_CanVertexColor(button._pcpThemeGradientBottom) then button._pcpThemeGradientBottom:SetVertexColor(theme.gradBottom[1], theme.gradBottom[2], theme.gradBottom[3], theme.gradBottom[4]) end
                    if PCP_CanShow(button._pcpThemeGradientBottom) then button._pcpThemeGradientBottom:Show() end
                end

                if not button._pcpThemeBorder then
                    button._pcpThemeBorder = CreateFrame("Frame", nil, button)
                    button._pcpThemeBorder:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
                    button._pcpThemeBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
                    button._pcpThemeBorder:SetBackdrop({
                        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                        edgeSize = 5,
                        insets = { left = 1, right = 1, top = 1, bottom = 1 },
                    })
                    button._pcpThemeBorder:SetFrameLevel(button:GetFrameLevel() + 1)
                end
                button._pcpThemeBorder:SetBackdropBorderColor(theme.border[1], theme.border[2], theme.border[3], theme.border[4])
                if PCP_CanShow(button._pcpThemeBorder) then button._pcpThemeBorder:Show() end

                
                
                if button._pcpThemeHighlight and not PCP_CanVertexColor(button._pcpThemeHighlight) then
                    if button._pcpThemeHighlight.Hide then button._pcpThemeHighlight:Hide() end
                    button._pcpThemeHighlight = nil
                end
                if not button._pcpThemeHighlight then
                    button._pcpThemeHighlight = button:CreateTexture(nil, "HIGHLIGHT")
                    button._pcpThemeHighlight:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                    button._pcpThemeHighlight:SetAllPoints(button)
                end
                if PCP_CanVertexColor(button._pcpThemeHighlight) then
                    button._pcpThemeHighlight:SetVertexColor(theme.highlight[1], theme.highlight[2], theme.highlight[3], math.min(1, (theme.highlight[4] or 0.12) + 0.08))
                    if PCP_CanShow(button._pcpThemeHighlight) then button._pcpThemeHighlight:Show() end
                    button:SetHighlightTexture(button._pcpThemeHighlight)
                end

                
                
                
                
                button:SetPushedTexture(nil)
                if button._pcpThemePushed then button._pcpThemePushed:Hide() end
                PCP_HookThemePressReset(button, theme)
                PCP_ApplyThemeNormalVisual(button, theme)
            end

            
            if button.iconTexture then button.iconTexture:SetDrawLayer("OVERLAY") end
            if button._pcpSpawnIcon then button._pcpSpawnIcon:SetDrawLayer("OVERLAY") end
            if button._pcpTotemIcons then
                for i = 1, table.getn(button._pcpTotemIcons) do
                    if button._pcpTotemIcons[i] then button._pcpTotemIcons[i]:SetDrawLayer("OVERLAY") end
                end
            end

            if button == settingsButton then
                if not button._pcpSettingsIcon then
                    button._pcpSettingsIcon = button:CreateTexture(nil, "OVERLAY")
                    button._pcpSettingsIcon:SetTexture("Interface\\AddOns\\PCP\\img\\settings.tga")
                    button._pcpSettingsIcon:SetPoint("CENTER", button, "CENTER", 0, 0)
                end
                button._pcpSettingsIcon:SetWidth(12)
                button._pcpSettingsIcon:SetHeight(12)
                if PCP_CanShow(button._pcpSettingsIcon) then button._pcpSettingsIcon:Show() end
            elseif button == closeButton then
                if not button._pcpCloseIcon then
                    button._pcpCloseIcon = button:CreateTexture(nil, "OVERLAY")
                    button._pcpCloseIcon:SetTexture("Interface\\AddOns\\PCP\\img\\close.tga")
                    button._pcpCloseIcon:SetPoint("CENTER", button, "CENTER", 0, 0)
                end
                button._pcpCloseIcon:SetWidth(10)
                button._pcpCloseIcon:SetHeight(10)
                if PCP_CanShow(button._pcpCloseIcon) then button._pcpCloseIcon:Show() end
            end
        end
    end
end


SLASH_TOGGLEBUTTON1 = "/tgl"
SlashCmdList["TOGGLEBUTTON"] = function(msg)
    
    local _, _, color = string.find(msg, "^(%S+)")  

    if msg == "on" then
        toggleButtonAppearance(true, defaultColor)  
        print("Custom appearance enabled with last used color: " .. defaultColor)
    elseif msg == "off" then
        toggleButtonAppearance(false, defaultColor)  
        print("Custom appearance disabled")
    elseif color == "pink" or color == "solidpink" or color == "green" or color == "solidgreen" or color == "blue" or color == "solidblue" or color == "gray" or color == "solidgray" or color == "black" or color == "dathw" or color == "DathW" or color == "darkglass" or color == "warcraftgold" or color == "shadowblue" or color == "bloodred" or color == "minimalflat" or color == "originalButtons" then
        toggleButtonAppearance(true, color)  
        print("Custom appearance enabled with color: " .. color)
    else
        print("Usage: /tgl on | off | DathW | darkglass | warcraftgold | shadowblue | bloodred | minimalflat | pink | green | blue | gray | black")
    end
end



local pcpThemeLoadFrame = CreateFrame("Frame")
local pcpThemeLoaded = false
local function PCP_LoadThemeOnce()
    if pcpThemeLoaded then return end
    pcpThemeLoaded = true
    if LoadSavedSettings then LoadSavedSettings() end
end
pcpThemeLoadFrame:RegisterEvent("ADDON_LOADED")
pcpThemeLoadFrame:RegisterEvent("PLAYER_LOGIN")
pcpThemeLoadFrame:SetScript("OnEvent", function()
    PCP_LoadThemeOnce()
end)







	
	local addBotFrame = CreateFrame("Frame", "AddBotFrame", frame)
	addBotFrame:SetWidth(300)  
	addBotFrame:SetHeight(100)
	addBotFrame:SetPoint("TOP", frame, "TOP", 0, -10)  

	
	addBotFrame.bg = addBotFrame:CreateTexture(nil, "BACKGROUND")
	addBotFrame.bg:SetAllPoints(true)
	

	




	





	
function createClassRoleButton(name, text, xOffset, yOffset, onClickFunc, width, height, parentFrame)
local button = CreateFrame("Button", name, parentFrame, "UIPanelButtonTemplate")








    button:SetWidth(width)
    button:SetHeight(height)	
    button:SetPoint("CENTER", parentFrame, "CENTER", xOffset, yOffset)
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

    
    button:Hide()

    
    table.insert(allButtons, button)

    return button
end




classButton = createClassRoleButton("ClassButton", "Warrior", 0, 20, function() print("Warrior class selected!") end, 80, 30, addBotFrame)
classButton:Show()

roleButton = createClassRoleButton("RoleButton", "Tank", 0, -30, function() SubPartyBotAddAdvanced() end, 80, 30, addBotFrame)
roleButton:Show()
        roleButton:SetScript("OnEnter", function()
            GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
            GameTooltip:SetText("Click to add", 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
		roleButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

	
createButton("SetClassADDButton", "+", 58, 10, function() SetClassADD() end, 30, 30, addBotFrame)
createButton("SetClassSUBButton", "-", -58, 10, function() SetClassSUB() end, 30, 30, addBotFrame)
	
	createButton("SetRoleADDButton", "+", 58, -10, function() SetRoleADD() end, 30, 30, addBotFrame)
	createButton("SetRoleSUBButton", "-", -58, -10, function() SetRoleSUB() end, 30, 30, addBotFrame)



PCPPaladinBlessings = { "Default", "BoK", "BoM", "BoW", "BoL", "BoS" }
PCPBlessingFullNames = {
    Default = "Default",
    BoK = "Blessing of Kings",
    BoM = "Blessing of Might",
    BoW = "Blessing of Wisdom",
    BoL = "Blessing of Light",
    BoS = "Blessing of Salvation",
}
PCPPaladinBlessingItr = 1
PCPShamanTotems = {
    air = { "windfury", "graceofair", "tranquilair", "natureresistance" },
    earth = { "strengthofearth", "stoneskin", "earthbind", "tremor" },
    fire = { "searing", "magma", "firenova", "flametongue", "frostresistance" },
    water = { "manaspring", "healingstream", "poisoncleansing", "diseasecleansing", "fireresistance", "manatide" },
}
PCPShamanTotemItr = { air = 1, earth = 1, fire = 1, water = 3 }
PCPBlessingIcons = {
    Default = "Interface\\Icons\\INV_Misc_QuestionMark",
    BoK = "Interface\\Icons\\Spell_Magic_GreaterBlessingofKings",
    BoM = "Interface\\Icons\\Spell_Holy_GreaterBlessingofKings",
    BoW = "Interface\\Icons\\Spell_Holy_GreaterBlessingofWisdom",
    BoL = "Interface\\Icons\\Spell_Holy_GreaterBlessingofLight",
    BoS = "Interface\\Icons\\Spell_Holy_GreaterBlessingofSalvation",
}
PCPTotemIcons = {
    windfury = "Interface\\Icons\\Spell_Nature_Windfury", graceofair = "Interface\\Icons\\Spell_Nature_InvisibilityTotem",
    tranquilair = "Interface\\Icons\\Spell_Nature_Brilliance", natureresistance = "Interface\\Icons\\Spell_Nature_NatureResistanceTotem",
    strengthofearth = "Interface\\Icons\\Spell_Nature_EarthBindTotem", stoneskin = "Interface\\Icons\\Spell_Nature_StoneSkinTotem",
    earthbind = "Interface\\Icons\\Spell_Nature_StrengthOfEarthTotem02", tremor = "Interface\\Icons\\Spell_Nature_TremorTotem",
    searing = "Interface\\Icons\\Spell_Fire_SearingTotem", magma = "Interface\\Icons\\Spell_Fire_SelfDestruct",
    firenova = "Interface\\Icons\\Spell_Fire_SealOfFire", flametongue = "Interface\\Icons\\Spell_Nature_GuardianWard",
    frostresistance = "Interface\\Icons\\Spell_FrostResistanceTotem_01", manaspring = "Interface\\Icons\\Spell_Nature_ManaRegenTotem",
    healingstream = "Interface\\Icons\\INV_Spear_04", poisoncleansing = "Interface\\Icons\\Spell_Nature_PoisonCleansingTotem",
    diseasecleansing = "Interface\\Icons\\Spell_Nature_DiseaseCleansingTotem", fireresistance = "Interface\\Icons\\Spell_FireResistanceTotem_01",
    manatide = "Interface\\Icons\\Spell_Frost_SummonWaterElemental",
}

local function PCP_SpawnIcon(kind, value)
    if kind == "paladin" then return PCPBlessingIcons[value or "Default"] or PCPBlessingIcons.Default end
    return PCPTotemIcons[value or ""] or "Interface\\Icons\\INV_Misc_QuestionMark"
end
local function PCP_CurrentAddClass() return AddClass or "warrior" end
local function PCP_GetPaladinBlessingText() return PCPPaladinBlessings[PCPPaladinBlessingItr or 1] or "Default" end
local function PCP_GetBlessingFullName(shortName)
    if PCPBlessingFullNames and PCPBlessingFullNames[shortName or ""] then
        return PCPBlessingFullNames[shortName]
    end
    return shortName or "Default"
end
local function PCP_GetShamanTotemText(key) local l = PCPShamanTotems[key]; return l and l[PCPShamanTotemItr[key] or 1] or "Default" end
function PCP_IsPaladinBuffRotationEnabled() if PCP_Settings and PCP_Settings.paladinBuffRotation ~= nil then return PCP_Settings.paladinBuffRotation == true end return true end
function PCP_NormalizePaladinBlessingForRotation() if PCP_IsPaladinBuffRotationEnabled() and ((PCPPaladinBlessingItr or 1) <= 1) then PCPPaladinBlessingItr = 2 end end

local function PCP_SetSingleIcon(button, path, size)
    if not button then return end
    if not button._pcpSpawnIcon then
        button._pcpSpawnIcon = button:CreateTexture(nil, "OVERLAY")
        button._pcpSpawnIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end
    if button._pcpTotemIcons then
        for i = 1, table.getn(button._pcpTotemIcons) do
            if button._pcpTotemIcons[i] then button._pcpTotemIcons[i]:Hide() end
        end
    end
    size = size or 26
    button._pcpSpawnIcon:SetTexture(path)
    button._pcpSpawnIcon:SetWidth(size)
    button._pcpSpawnIcon:SetHeight(size)
    button._pcpSpawnIcon:ClearAllPoints()
    
    button._pcpSpawnIcon:SetPoint("CENTER", button, "CENTER", 0, 2)
    button._pcpSpawnIcon:Show()
    button:SetText("")
end
local function PCP_SetFourTotemIcons(button, size)
    if not button then return end
    if button._pcpSpawnIcon then button._pcpSpawnIcon:Hide() end
    if not button._pcpTotemIcons then button._pcpTotemIcons = {} end
    local paths = { PCP_SpawnIcon("shaman", PCP_GetShamanTotemText("air")), PCP_SpawnIcon("shaman", PCP_GetShamanTotemText("earth")), PCP_SpawnIcon("shaman", PCP_GetShamanTotemText("fire")), PCP_SpawnIcon("shaman", PCP_GetShamanTotemText("water")) }
    local gap = button._pcpIconGap or 3
    local off = (size + gap) / 2
    local pos = { { -off, off }, { off, off }, { -off, -off }, { off, -off } }
    for i = 1, 4 do
        if not button._pcpTotemIcons[i] then button._pcpTotemIcons[i] = button:CreateTexture(nil, "OVERLAY"); button._pcpTotemIcons[i]:SetTexCoord(0.08, 0.92, 0.08, 0.92) end
        local t = button._pcpTotemIcons[i]; t:SetTexture(paths[i]); t:SetWidth(size); t:SetHeight(size); t:ClearAllPoints(); t:SetPoint("CENTER", button, "CENTER", pos[i][1], pos[i][2]); t:Show()
    end
    button:SetText("")
end

local function PCP_TooltipIconLine(path, text, r, g, b)
    
    
    GameTooltip:AddLine(text or "", r or 1, g or 1, b or 1)
    if path and GameTooltip.AddTexture then
        GameTooltip:AddTexture(path)
    end
end
local function PCP_TotemDisplayName(key) if key == "air" then return "Air" elseif key == "earth" then return "Earth" elseif key == "fire" then return "Fire" elseif key == "water" then return "Water" end return "Totem" end
local function PCP_GetHoveredTotemKey(button)
    local x, y = GetCursorPosition(); local scale = button:GetEffectiveScale() or 1; x = x / scale; y = y / scale
    local left, right, top, bottom = button:GetLeft() or 0, button:GetRight() or 0, button:GetTop() or 0, button:GetBottom() or 0
    local midX, midY = (left + right) / 2, (top + bottom) / 2
    if y >= midY then if x < midX then return "air" else return "earth" end end
    if x < midX then return "fire" else return "water" end
end

local function PCP_ShowSpawnTooltip(button, hoveredKey)
    GameTooltip:SetOwner(button, "ANCHOR_RIGHT"); GameTooltip:ClearLines()
    if PCP_CurrentAddClass() == "paladin" then
        local b = PCP_GetPaladinBlessingText()
        local fullName = PCP_GetBlessingFullName(b)
        local icon = PCP_SpawnIcon("paladin", b)
        PCP_TooltipIconLine(icon, "Paladin Blessing", 1, 0.82, 0)
        GameTooltip:AddLine(" ")
        PCP_TooltipIconLine(icon, "Current: " .. fullName, 0, 1, 0)
        GameTooltip:AddLine("Left click: Configure blessings", .7, .7, .7)
        GameTooltip:AddLine("Right click: Quick change blessing", .7, .7, .7)
    elseif PCP_CurrentAddClass() == "shaman" then
        hoveredKey = hoveredKey or PCP_GetHoveredTotemKey(button); PCP_TooltipIconLine(PCP_SpawnIcon("shaman", PCP_GetShamanTotemText(hoveredKey)), "Shaman Totems", 1, 0.82, 0); GameTooltip:AddLine(" ")
        local order = { "air", "earth", "fire", "water" }; for i = 1, 4 do local k = order[i]; local prefix = (k == hoveredKey) and "> " or "  "; PCP_TooltipIconLine(PCP_SpawnIcon("shaman", PCP_GetShamanTotemText(k)), prefix .. PCP_TotemDisplayName(k) .. ": " .. PCP_GetShamanTotemText(k), (k == hoveredKey) and 0 or .85, (k == hoveredKey) and 1 or .85, (k == hoveredKey) and 0 or .85) end
        GameTooltip:AddLine(" "); GameTooltip:AddLine("Left click: Configure totems", .7,.7,.7); GameTooltip:AddLine("Right click: Quick change hovered totem", .7,.7,.7)
    end
    button._pcpTooltipLastTotemKey = hoveredKey; GameTooltip:Show()
end

local function PCP_GetSpawnButtonMetrics(c)
    local roleH = roleButton and roleButton.GetHeight and (roleButton:GetHeight() or 30) or 30
    local roleW = roleButton and roleButton.GetWidth and (roleButton:GetWidth() or 90) or 90
    local plusW = SetRoleADDButton and SetRoleADDButton.GetWidth and (SetRoleADDButton:GetWidth() or 30) or 30
    local parentW = addBotFrame and addBotFrame.GetWidth and (addBotFrame:GetWidth() or 300) or 300

    if roleH < 20 then roleH = 20 end

    
    local rightRoom = (parentW / 2) - (roleW / 2) - plusW - 8
    if rightRoom < 22 then rightRoom = 22 end

    if c == "shaman" then
        
        
        local gap = 3
        local iconSize = math.floor(math.min((rightRoom - gap) / 2, (roleH - gap) / 2))
        if iconSize < 12 then iconSize = 12 end
        if iconSize > 20 then iconSize = 20 end
        local grid = (iconSize * 2) + gap
        return iconSize, grid + 6, grid + 6, gap
    end

    
    local iconSize = math.floor(math.min(rightRoom, roleH - 2))
    if iconSize < 18 then iconSize = 18 end
    if iconSize > 28 then iconSize = 28 end
    return iconSize, iconSize + 10, iconSize + 8
end

function PCP_UpdateSpawnConfigButtonText()
    if not PCPSpawnConfigButton then return end
    local c = PCP_CurrentAddClass()
    local iconSize, buttonW, buttonH, iconGap = PCP_GetSpawnButtonMetrics(c)

    PCPSpawnConfigButton:ClearAllPoints()
    if SetRoleADDButton then
        
        PCPSpawnConfigButton:SetPoint("LEFT", SetRoleADDButton, "RIGHT", 4, 10)
    elseif roleButton then
        PCPSpawnConfigButton:SetPoint("LEFT", roleButton, "RIGHT", 4, 2)
    end
    PCPSpawnConfigButton:SetWidth(buttonW or 46)
    PCPSpawnConfigButton:SetHeight(buttonH or 34)
    PCPSpawnConfigButton._pcpIconGap = iconGap or 3

    if c == "paladin" then
        PCP_NormalizePaladinBlessingForRotation()
        PCP_SetSingleIcon(PCPSpawnConfigButton, PCP_SpawnIcon("paladin", PCP_GetPaladinBlessingText()), iconSize or 26)
        PCPSpawnConfigButton:Show()
    elseif c == "shaman" then
        PCP_SetFourTotemIcons(PCPSpawnConfigButton, iconSize or 14)
        PCPSpawnConfigButton:Show()
    else
        PCPSpawnConfigButton:Hide()
        return
    end
end

function PCP_RefreshSpawnOptionsFrame()
    if not PCPSpawnOptionsFrame then
        PCPSpawnOptionsFrame = CreateFrame("Frame", "PCPSpawnOptionsFrame", UIParent)
        PCPSpawnOptionsFrame:SetWidth(280)
        PCPSpawnOptionsFrame:SetHeight(240)
        PCPSpawnOptionsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        PCPSpawnOptionsFrame:SetFrameStrata("DIALOG")
        PCPSpawnOptionsFrame:EnableMouse(true)
        PCPSpawnOptionsFrame:SetMovable(true)
        PCPSpawnOptionsFrame:RegisterForDrag("LeftButton")
        PCPSpawnOptionsFrame:SetScript("OnDragStart", function() this:StartMoving() end)
        PCPSpawnOptionsFrame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
        PCPSpawnOptionsFrame:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        PCPSpawnOptionsFrame:SetBackdropColor(0, 0, 0, 0.9)
        PCPSpawnOptionsFrame.rows = {}
        PCPSpawnOptionsFrame.headers = {}

        PCPSpawnOptionsFrame.title = PCPSpawnOptionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        PCPSpawnOptionsFrame.title:SetPoint("TOP", PCPSpawnOptionsFrame, "TOP", 0, -12)

        PCPSpawnOptionsFrame.close = CreateFrame("Button", nil, PCPSpawnOptionsFrame, "UIPanelButtonTemplate")
        PCPSpawnOptionsFrame.close:SetWidth(60)
        PCPSpawnOptionsFrame.close:SetHeight(22)
        PCPSpawnOptionsFrame.close:SetPoint("BOTTOM", PCPSpawnOptionsFrame, "BOTTOM", 0, 10)
        PCPSpawnOptionsFrame.close:SetText("Close")
        PCPSpawnOptionsFrame.close:SetScript("OnClick", function() PCPSpawnOptionsFrame:Hide() end)
    end

    local f = PCPSpawnOptionsFrame

    if f.rows then
        for i = 1, table.getn(f.rows) do
            if f.rows[i] then f.rows[i]:Hide() end
        end
    end
    if f.headers then
        for i = 1, table.getn(f.headers) do
            if f.headers[i] then f.headers[i]:Hide() end
        end
    end

    local function header(index, text, x, y)
        if not f.headers[index] then
            f.headers[index] = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            f.headers[index]:SetJustifyH("LEFT")
        end
        local h = f.headers[index]
        h:ClearAllPoints()
        h:SetPoint("TOPLEFT", f, "TOPLEFT", x or 24, y or -45)
        h:SetText(text or "")
        h:SetTextColor(1, 0.82, 0, 1)
        h:Show()
        return h
    end

    local function checkRow(index, text, checked, clickFunc, x, y, width, iconPath)
        if not f.rows[index] then
            local cb = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
            cb:SetWidth(20)
            cb:SetHeight(20)

            cb.icon = cb:CreateTexture(nil, "OVERLAY")
            cb.icon:SetWidth(16)
            cb.icon:SetHeight(16)
            cb.icon:SetPoint("LEFT", cb, "RIGHT", 4, 0)
            cb.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

            cb.label = cb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            cb.label:SetPoint("LEFT", cb.icon, "RIGHT", 5, 0)
            cb.label:SetJustifyH("LEFT")
            f.rows[index] = cb
        end

        local cb = f.rows[index]
        cb:ClearAllPoints()
        cb:SetPoint("TOPLEFT", f, "TOPLEFT", x or 24, y or (-45 - ((index - 1) * 22)))
        cb:SetWidth(20)
        cb:SetHeight(20)
        cb:SetChecked(checked and 1 or nil)

        if iconPath and iconPath ~= "" then
            cb.icon:SetTexture(iconPath)
            cb.icon:Show()
            cb.label:ClearAllPoints()
            cb.label:SetPoint("LEFT", cb.icon, "RIGHT", 5, 0)
        else
            cb.icon:Hide()
            cb.label:ClearAllPoints()
            cb.label:SetPoint("LEFT", cb, "RIGHT", 4, 0)
        end

        cb.label:SetWidth(width or 190)
        cb.label:SetText(text or "")
        cb.label:SetTextColor(1, 0.82, 0, 1)
        cb:SetScript("OnClick", clickFunc or function() end)
        cb:SetScript("OnEnter", function()
            if this and this.label then this.label:SetTextColor(1, 1, 1, 1) end
        end)
        cb:SetScript("OnLeave", function()
            if this and this.label then this.label:SetTextColor(1, 0.82, 0, 1) end
        end)
        cb:Show()
        return cb
    end

    if PCP_CurrentAddClass() == "paladin" then
        f:SetWidth(280)
        f:SetHeight(230)
        f.title:SetText("Paladin Blessing")

        for i = 1, table.getn(PCPPaladinBlessings) do
            local blessing = PCPPaladinBlessings[i]
            checkRow(i, blessing, (PCPPaladinBlessingItr == i), function()
                PCPPaladinBlessingItr = this._pcpBlessingIndex or i
                PCP_RefreshSpawnOptionsFrame()
                PCP_UpdateSpawnConfigButtonText()
            end, 28, -45 - ((i - 1) * 24), 170, PCP_SpawnIcon("paladin", blessing))._pcpBlessingIndex = i
        end
        if f.shamanHeaders then
            for _, h in ipairs(f.shamanHeaders) do if h then h:Hide() end end
        end
        if f.shamanHeaderIcons then
            for _, t in ipairs(f.shamanHeaderIcons) do if t then t:Hide() end end
        end
    else
        
        
        f:SetWidth(680)
        f:SetHeight(255)
        f.title:SetText("Shaman Totems")

        if f.title then
            f.title:ClearAllPoints()
            f.title:SetPoint("TOP", f, "TOP", 0, -12)
        end

        if not f.shamanHeaders then f.shamanHeaders = {} end
        if not f.shamanHeaderIcons then f.shamanHeaderIcons = {} end

        local groups = {
            { key = "air",   title = "Air",   x = 22 },
            { key = "earth", title = "Earth", x = 187 },
            { key = "fire",  title = "Fire",  x = 352 },
            { key = "water", title = "Water", x = 517 },
        }

        local rowIndex = 1
        for gi = 1, table.getn(groups) do
            local group = groups[gi]
            local list = PCPShamanTotems[group.key]
            local selectedTotem = PCP_GetShamanTotemText(group.key)

            if not f.shamanHeaderIcons[gi] then
                f.shamanHeaderIcons[gi] = f:CreateTexture(nil, "OVERLAY")
                f.shamanHeaderIcons[gi]:SetWidth(18)
                f.shamanHeaderIcons[gi]:SetHeight(18)
                f.shamanHeaderIcons[gi]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end
            local titleIcon = f.shamanHeaderIcons[gi]
            titleIcon:ClearAllPoints()
            titleIcon:SetPoint("TOPLEFT", f, "TOPLEFT", group.x, -48)
            titleIcon:SetTexture(PCP_SpawnIcon("shaman", selectedTotem))
            titleIcon:Show()

            if not f.shamanHeaders[gi] then
                f.shamanHeaders[gi] = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            end
            local title = f.shamanHeaders[gi]
            title:ClearAllPoints()
            title:SetPoint("LEFT", titleIcon, "RIGHT", 5, 0)
            title:SetText(group.title)
            title:SetTextColor(1, 0.82, 0, 1)
            title:Show()

            if list then
                for i = 1, table.getn(list) do
                    local totem = list[i]
                    local checked = ((PCPShamanTotemItr[group.key] or 1) == i)
                    local cb = checkRow(rowIndex, totem, checked, function()
                        local groupKey = this._pcpTotemGroup
                        local groupIndex = this._pcpTotemIndex
                        if groupKey and groupIndex then
                            PCPShamanTotemItr[groupKey] = groupIndex
                        end
                        PCP_RefreshSpawnOptionsFrame()
                        PCP_UpdateSpawnConfigButtonText()
                    end, group.x, -74 - ((i - 1) * 21), 125, PCP_SpawnIcon("shaman", totem))
                    cb._pcpTotemGroup = group.key
                    cb._pcpTotemIndex = i
                    if cb.label then
                        cb.label:SetText((checked and "|cff00ff00" or "") .. totem .. (checked and "|r" or ""))
                        cb.label:SetWidth(125)
                    end
                    rowIndex = rowIndex + 1
                end
            end
        end
    end
end

function PCP_ShowSpawnOptionsFrame() if PCP_CurrentAddClass() ~= "paladin" and PCP_CurrentAddClass() ~= "shaman" then return end PCP_RefreshSpawnOptionsFrame(); if PCPSpawnOptionsFrame:IsShown() then PCPSpawnOptionsFrame:Hide() else PCPSpawnOptionsFrame:Show() end end
function PCP_QuickChangeSpawnOption(button)
    if PCP_CurrentAddClass() == "paladin" then PCPPaladinBlessingItr = (PCPPaladinBlessingItr or 1) + 1; if PCPPaladinBlessingItr > table.getn(PCPPaladinBlessings) then PCPPaladinBlessingItr = PCP_IsPaladinBuffRotationEnabled() and 2 or 1 end
    elseif PCP_CurrentAddClass() == "shaman" then local key = PCP_GetHoveredTotemKey(button); PCPShamanTotemItr[key] = (PCPShamanTotemItr[key] or 1) + 1; if PCPShamanTotemItr[key] > table.getn(PCPShamanTotems[key]) then PCPShamanTotemItr[key] = 1 end end
    PCP_UpdateSpawnConfigButtonText(); if PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown() then PCP_RefreshSpawnOptionsFrame() end; if button and button._pcpTooltipActive then PCP_ShowSpawnTooltip(button) end
end
function PCP_UpdateSpawnOptionButtons() if PCPSpawnConfigButton then PCP_UpdateSpawnConfigButtonText() end end

PCPSpawnConfigButton = createClassRoleButton("PCPSpawnConfigButton", "", 105, -30, function() PCP_ShowSpawnOptionsFrame() end, 46, 34, addBotFrame)
PCPSpawnConfigButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
PCPSpawnConfigButton:SetScript("OnClick", function() if arg1 == "RightButton" then PCP_QuickChangeSpawnOption(this) else PCP_ShowSpawnOptionsFrame() end end)
PCPSpawnConfigButton:SetScript("OnEnter", function() this._pcpTooltipActive = true; PCP_ShowSpawnTooltip(this) end)
PCPSpawnConfigButton:SetScript("OnUpdate", function() if this._pcpTooltipActive and PCP_CurrentAddClass() == "shaman" then local k = PCP_GetHoveredTotemKey(this); if k ~= this._pcpTooltipLastTotemKey then PCP_ShowSpawnTooltip(this, k) end end end)
PCPSpawnConfigButton:SetScript("OnLeave", function() this._pcpTooltipActive = false; GameTooltip:Hide() end)
PCPSpawnConfigButton:Hide()


	
	local commandsFrame = CreateFrame("Frame", "CommandsFrame", frame)
	commandsFrame:SetWidth(300)
    commandsFrame:SetHeight(130)	
	commandsFrame:SetPoint("TOP", addBotFrame, "BOTTOM", 0, 0)  

	
	commandsFrame.bg = commandsFrame:CreateTexture(nil, "BACKGROUND")
	commandsFrame.bg:SetAllPoints(true)
	



	
	local commandsTitle = commandsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	commandsTitle:SetPoint("CENTER", commandsFrame, "TOP", 0, -5)  

	
	
local commands = {
    {"CmdCome", "Come", -65, 80, function() SetCommand("come") end, 80, 30},
    {"CmdStart", "Start", 0, 80, function() SetCommand("attackstart") end, 80, 30},
    {"CmdStop", "Stop", 65, 80, function() SetCommand("attackstop") end, 80, 30},

    {"CmdUse", "Object", -65, 50, function() SetCommand("use") end, 80, 30},
    {"CmdPause", "Pause", 0, 50, function() SetPause() end, 80, 30},
    {"CmdUnpause", "Unpause", 65, 50, function() SetUnpause() end, 80, 30},

    {"CmdAOE", "AoE", -65, 20, function() SetCommand("aoe") end, 80, 30},  
    {"CmdPauseAll", "Pause all", 0, 20, function() SetCommand("pause all") end, 80, 30},  
    {"CmdUnpauseAll", "Unpause all", 65, 20, function() SetCommand("unpause all") end, 80, 30},  

    {"CmdStay", "Stay", -65, -10, function() SetCommand("stay") end, 80, 30},  
    {"CmdMove", "Move", 0, -10, function() SetCommand("move") end, 80, 30},   
    {"CmdPull", "Pull", 65, -10, function() SetCommand("pull") end, 80, 30},   
}


	for _, cmd in ipairs(commands) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6], cmd[7], commandsFrame)
	end


	
	local partyBotCommandsFrame = CreateFrame("Frame", "PartyBotCommandsFrame", frame)
	partyBotCommandsFrame:SetWidth(300)
	partyBotCommandsFrame:SetHeight(130)
	partyBotCommandsFrame:SetPoint("TOP", commandsFrame, "BOTTOM", 0, 0)  

	
	partyBotCommandsFrame.bg = partyBotCommandsFrame:CreateTexture(nil, "BACKGROUND")
	partyBotCommandsFrame.bg:SetAllPoints(true)
	

	
	local partyBotCommandsTitle = partyBotCommandsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	partyBotCommandsTitle:SetPoint("TOP", partyBotCommandsFrame, "TOP", 0, -5)  

	
	local partyBotCommands = {
		{"PartyBotStayAll", "Stay All", -75, -5, function() SubPartyBotStayAll() end, 50, 30},  
		{"PartyBotMoveAll", "Move All", 75, -5, function() SubPartyBotMoveAll() end, 50, 30},
		{"PartyBotSpread", "Spread", -75, -5, function() SetCommand("spread") end, 50, 30},
		{"PartyBotSpreadStop", "Spread Stop", 50, -40, function() SetCommand("spreadoff") end, 50, 30},
		{"PartyBotDistance", "Distance", -50, -70, function() SetCommand("distance on") end, 50, 30},
		{"PartyBotDistanceOff", "Distance Off", 50, -70, function() SetCommand("distance off") end, 50, 30},
	}

	
	for _, cmd in ipairs(partyBotCommands) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6], cmd[7], partyBotCommandsFrame)
	end

	
	local comeCommandTitleFrame = CreateFrame("Frame", "comeCommandTitleFrame", commandsFrame)
	comeCommandTitleFrame:SetWidth(300)
	comeCommandTitleFrame:SetHeight(10)
	comeCommandTitleFrame:SetPoint("TOP", partyBotCommandsFrame, "BOTTOM", 0, -2)  

	
	comeCommandTitleFrame.bg = comeCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	comeCommandTitleFrame.bg:SetAllPoints(true)
	comeCommandTitleFrame.bg:SetTexture(0.6, 0.4, 0.2, 0.5)

	
	local comeTitle = comeCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	comeTitle:SetText("Come Commands")
	comeTitle:SetPoint("CENTER", comeCommandTitleFrame, "TOP", 0, -5)  

	
	local comeCommandFrame = CreateFrame("Frame", "ComeCommandFrame", commandsFrame)
	comeCommandFrame:SetWidth(300)
	comeCommandFrame:SetHeight(40)
	comeCommandFrame:SetPoint("TOP", comeCommandTitleFrame, "BOTTOM", 0, -2)  

	
	comeCommandFrame.bg = comeCommandFrame:CreateTexture(nil, "BACKGROUND")
	comeCommandFrame.bg:SetAllPoints(true)
	

	
	local roleCommandButtons = {
		{"CmdCometank", "Tank", -75, -5, function() SetCommand("cometank") end, 50, 30},
		{"CmdComeheal", "Heal", -25, -5, function() SetCommand("comeheal") end, 50, 30},
		{"CmdComemelee", "Melee", 25, -5, function() SetCommand("comemelee") end, 50, 30},
		{"CmdComerange", "Range", 75, -5, function() SetCommand("comerange") end, 50, 30},
	}

	for _, cmd in ipairs(roleCommandButtons) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6], cmd[7], comeCommandFrame)
	end

	
	local moveCommandTitleFrame = CreateFrame("Frame", "moveCommandTitleFrame", commandsFrame)
	moveCommandTitleFrame:SetWidth(300)
	moveCommandTitleFrame:SetHeight(10)
	moveCommandTitleFrame:SetPoint("TOP", comeCommandFrame, "BOTTOM", 0, -2)  

	
	moveCommandTitleFrame.bg = moveCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	moveCommandTitleFrame.bg:SetAllPoints(true)
	moveCommandTitleFrame.bg:SetTexture(0.4, 0.6, 0.2, 0.5)  

	
	local moveTitle = moveCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	moveTitle:SetText("Move Commands")
	moveTitle:SetPoint("CENTER", moveCommandTitleFrame, "TOP", 0, -5)  
	
	local moveCommandFrame = CreateFrame("Frame", "MoveCommandFrame", commandsFrame)
	moveCommandFrame:SetWidth(300)
	moveCommandFrame:SetHeight(40)
	moveCommandFrame:SetPoint("TOP", moveCommandTitleFrame, "BOTTOM", 0, -2)  

	
	moveCommandFrame.bg = moveCommandFrame:CreateTexture(nil, "BACKGROUND")
	moveCommandFrame.bg:SetAllPoints(true)
	

	local moveRoleCommandButtons = {
		{"CmdMovetank", "Tank", -75, -5, function() SetCommand("movetank") end, 50, 30},
		{"CmdMoveheal", "Heal", -25, -5, function() SetCommand("moveheal") end, 50, 30},
		{"CmdMovemelee", "Melee", 25, -5, function() SetCommand("movemelee") end, 50, 30},
		{"CmdMoverange", "Range", 75, -5, function() SetCommand("moverange") end, 50, 30},
	}

	for _, cmd in ipairs(moveRoleCommandButtons) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6], cmd[7], moveCommandFrame)
	end

	local stayCommandTitleFrame = CreateFrame("Frame", "stayCommandTitleFrame", commandsFrame)
	stayCommandTitleFrame:SetWidth(300)
	stayCommandTitleFrame:SetHeight(10)
	stayCommandTitleFrame:SetPoint("TOP", moveCommandFrame, "BOTTOM", 0, -2)  

	
	stayCommandTitleFrame.bg = stayCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	stayCommandTitleFrame.bg:SetAllPoints(true)
	stayCommandTitleFrame.bg:SetTexture(0.4, 0.2, 0.6, 0.5)  


	local stayTitle = stayCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	stayTitle:SetText("Stay Commands")
	stayTitle:SetPoint("CENTER", stayCommandTitleFrame, "TOP", 0, -5)  


	
	local stayCommandFrame = CreateFrame("Frame", "StayCommandFrame", commandsFrame)
	stayCommandFrame:SetWidth(300)
	stayCommandFrame:SetHeight(40)
	stayCommandFrame:SetPoint("TOP", stayCommandTitleFrame, "BOTTOM", 0, -2)  

	
	stayCommandFrame.bg = stayCommandFrame:CreateTexture(nil, "BACKGROUND")
	stayCommandFrame.bg:SetAllPoints(true)
	

	
	local defaultButtonWidth = 50
	local defaultButtonHeight = 30


	
	local stayRoleCommandButtons = {
		{"CmdStaytank", "Tank", -75, -10, function() SetCommand("staytank") end},
		{"CmdStayheal", "Heal", -25, -10, function() SetCommand("stayheal") end},
		{"CmdStaymelee", "Melee", 25, -10, function() SetCommand("staymelee") end},
		{"CmdStayrange", "Range", 75, -10, function() SetCommand("stayrange") end},
	}

	for _, cmd in ipairs(stayRoleCommandButtons) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], defaultButtonWidth, defaultButtonHeight, stayCommandFrame)
	end


local markFrame = CreateFrame("Frame", "MarkFrame", PCPFrameRemake)
markFrame:SetWidth(300)
markFrame:SetHeight(50) 
markFrame:SetPoint("TOP", stayCommandFrame, "BOTTOM", 0, 2)




markFrame.bg = markFrame:CreateTexture(nil, "BACKGROUND")
markFrame.bg:SetAllPoints(true)



local function createMarkButton(name, text, xOffset, onClickFunc, width, height, parentFrame)
	local button = CreateFrame("Button", name, parentFrame, "UIPanelButtonTemplate")
    

    
    
    
    


    button:SetWidth(width)
	button:SetHeight(height)
    button:SetPoint("TOP", parentFrame, "TOP", xOffset, -10) 
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

	table.insert(allButtons, button)
    return button
end




Marks = { "CC Mark", "Focus Mark" }
MarkItr = 1 


local function UpdateMarkDisplay()
    markButton:SetText(Marks[MarkItr])
end
createButton("SetMarkADDButton", "+", 58, 10, function() MarkADD() end, 30, 30, markFrame)
createButton("SetMarkSUBButton", "-", -58, 10, function() MarkSUB() end, 30, 30, markFrame)
markButton = createMarkButton("MarkButton", Marks[MarkItr], 0, function() ShowMark() end, 95, 30, markFrame)



local markCommandFrame = CreateFrame("Frame", "MarkCommandFrame", PCPFrameRemake)
markCommandFrame:SetWidth(300)
markCommandFrame:SetHeight(120)  
markCommandFrame:SetPoint("TOP", markFrame, "BOTTOM", 0, -2)  


markCommandFrame.bg = markCommandFrame:CreateTexture(nil, "BACKGROUND")
markCommandFrame.bg:SetAllPoints(true)






local function createMarkCommandButton(name, iconPath, tooltipText, xOffset, yOffset, onClickFunc, width, height, parentFrame)
    local button


        button = CreateFrame("Button", name, parentFrame)
        local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
        fontString:SetPoint("CENTER", UIParent, "CENTER")
        button:SetFontString(fontString) 


    button:SetWidth(width)
    button:SetHeight(height)	
    button:SetPoint("TOP", parentFrame, "TOP", xOffset, yOffset)

    
    local iconTexture = button:CreateTexture(nil, "OVERLAY")  
    iconTexture:SetTexture(iconPath)
    iconTexture:SetWidth(width * 0.4)
    iconTexture:SetHeight(height * 0.4)	
    iconTexture:SetPoint("CENTER", button, "CENTER", 0, 0)  
    iconTexture:SetTexCoord(0.25, 0.75, 0.25, 0.75)  
    button.iconTexture = iconTexture  

    
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0, 0, 0, 0.1) 

    button:SetScript("OnClick", onClickFunc)

    
    button:SetScript("OnEnter", function()
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText, 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    table.insert(allButtons, button)
    return button
end



local iconCoords = {
    moon = {0.00, 0.25, 0.25, 0.50},
    star = {0.00, 0.25, 0.00, 0.25},
    circle = {0.25, 0.50, 0.00, 0.25},
    diamond = {0.50, 0.75, 0.00, 0.25},
    triangle = {0.75, 1.00, 0.00, 0.25},
    square = {0.25, 0.50, 0.25, 0.50},
    cross = {0.50, 0.75, 0.25, 0.50},
    skull = {0.75, 1.00, 0.25, 0.50},
}


local defaultButtonWidth = 40
local defaultButtonHeight = 30

local markCommandButtons = {
    {"PartyBotCCSkull", "skull", "Skull", 40, -50, function() SetMark("skull") end},
    {"PartyBotCCCross", "cross", "Cross", 0, -50, function() SetMark("cross") end},	
    {"PartyBotCCSquare", "square", "Square", -40, -50, function() SetMark("square") end},	
    {"PartyBotCCMoon", "moon", "Moon", -80, -10, function() SetMark("moon") end},
    {"PartyBotCCTriangle", "triangle", "Triangle", -80, -50, function() SetMark("triangle") end},
    {"PartyBotCCDiamond", "diamond", "Diamond", 40, -10, function() SetMark("diamond") end},
    {"PartyBotCCCircle", "circle", "Circle", 0, -10, function() SetMark("circle") end},
    {"PartyBotCCStar", "star", "Star", -40, -10, function() SetMark("star") end},






    {"PartyBotCCClear", "Interface\\Buttons\\UI-GroupLoot-Pass-Up", "Clear", 80, -10, function() ClearMark() end},
    {"PartyBotCCClearAll", "Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Clear All", 80, -50, function() ClearAllMark() end},
}


for _, cmd in ipairs(markCommandButtons) do
    local button = createMarkCommandButton(
        cmd[1], 
        "Interface\\TargetingFrame\\UI-RaidTargetingIcons", 
        cmd[3], 
        cmd[4], 
        cmd[5], 
        cmd[6], 
        defaultButtonWidth, 
        defaultButtonHeight, 
        markCommandFrame
    )
    
    local coords = iconCoords[cmd[2]]
    if coords and button.iconTexture then
        button.iconTexture:SetTexCoord(unpack(coords))
    end
end




local function ResizeMarkCommandButtons(commandButtons, commandFrame, buttonsPerRow, extraWidth)
    buttonsPerRow = buttonsPerRow or 5  
    local buttonCount = table.getn(commandButtons) 
    local rows = math.ceil(buttonCount / buttonsPerRow)  
    local padding = 5  

    
    local totalHorizontalPadding = padding * (buttonsPerRow - 1)
    local availableWidth = commandFrame:GetWidth() - totalHorizontalPadding

    local totalVerticalPadding = padding * (rows - 1)
    local availableHeight = commandFrame:GetHeight() - totalVerticalPadding

    
    local baseButtonWidth = math.floor(availableWidth / buttonsPerRow)

    
    local buttonWidth = baseButtonWidth + (extraWidth or 0)
    local buttonHeight = math.floor(availableHeight / rows)

    
    buttonHeight = math.min(buttonWidth, buttonHeight)

    
    for i = 1, buttonCount do
        local cmd = commandButtons[i]
        local button = getglobal(cmd[1]) 
        if button then
            
            button:SetWidth(buttonWidth)
            button:SetHeight(buttonHeight)

            
            local normalTexture = button:GetNormalTexture()
            if normalTexture then
                normalTexture:SetWidth(buttonWidth * 0.4)
                normalTexture:SetHeight(buttonHeight * 0.4)  
            end

            
            local fontString = button:GetFontString()
            if fontString then
                local font, fontSize, flags = fontString:GetFont()
                fontString:SetFont(font, math.max(10, math.min(buttonWidth / 4, 12)), flags)
            end

            
            local row = math.floor((i - 1) / buttonsPerRow)  
            local col = math.mod(i - 1, buttonsPerRow)


            if col == 0 then
                
                button:SetPoint("TOPLEFT", commandFrame, "TOPLEFT", 0, -(row * (buttonHeight + padding)))
            else
                
                local previousButton = getglobal(commandButtons[i - 1][1])
                if previousButton then
                    button:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", padding, 0)
                end
            end
        end
    end

    
    return rows * (buttonHeight + padding)
end





local defaultButtonWidth = 50
local defaultButtonHeight = 30
local padding = 10


local function ResizeRoleCommandButtons(commandButtons, commandFrame, buttonHeight)
    local width = commandFrame:GetWidth()
    local padding = 5 
    local buttonsPerRow = 4 
    local buttonCount = table.getn(commandButtons) 
    local rows = math.ceil(buttonCount / buttonsPerRow)
    local totalHorizontalPadding = padding * (buttonsPerRow - 1)
    local availableWidth = width - totalHorizontalPadding
    local buttonWidth = math.floor(availableWidth / buttonsPerRow)

    
    buttonHeight = buttonHeight or (math.floor(commandFrame:GetHeight() / rows) - padding)

    for i = 1, buttonCount do
        local cmd = commandButtons[i]
        local button = getglobal(cmd[1]) 
        if button then
            button:SetWidth(buttonWidth) 
            button:SetHeight(buttonHeight)

            
            local fontString = button:GetFontString()
            if fontString then
                local font, _, flags = fontString:GetFont()
                local fontSize = math.max(8, math.min(buttonWidth / 2, buttonHeight / 2)) 
                fontString:SetFont(font, fontSize, flags)
            end

            
            local row = math.floor((i - 1) / buttonsPerRow)
            local col = math.mod(i - 1, buttonsPerRow) 

            if col == 0 then
                button:SetPoint("TOPLEFT", commandFrame, "TOPLEFT", 0, -row * (buttonHeight + padding))
            else
                local prevButton = getglobal(commandButtons[i - 1][1])
                if prevButton then
                    button:SetPoint("TOPLEFT", prevButton, "TOPRIGHT", padding, 0)
                end
            end
        end
    end
end





local defaultButtonWidth = 50
local defaultButtonHeight = 30
local padding = 5


local function ResizeCommandButtons(commandButtons, commandFrame, buttonsPerRow, extraWidth, startingYOffset, isPartyBot)
    buttonsPerRow = buttonsPerRow or 3  
    local buttonCount = table.getn(commandButtons) 
    local rows = math.ceil(buttonCount / buttonsPerRow)  
    local padding = 2  

    local totalHorizontalPadding = padding * (buttonsPerRow - 1)  
    local availableWidth = commandFrame:GetWidth() - totalHorizontalPadding  

    local totalVerticalPadding = padding * (rows - 1)  
    local availableHeight = commandFrame:GetHeight() - totalVerticalPadding  

    
    local buttonWidth = math.floor((availableWidth - (extraWidth or 0)) / buttonsPerRow)  
    local buttonHeight = math.floor(availableHeight / rows)  

    
    local yOffset = startingYOffset or 0

    
    for i = 1, buttonCount do
        local cmd = commandButtons[i]
        local button = getglobal(cmd[1]) 
        if button then
            button:SetWidth(buttonWidth + (extraWidth or 0))  
            button:SetHeight(buttonHeight)  

            
            local fontSize
            if isPartyBot then
                fontSize = math.max(6, math.min(buttonWidth / 4, buttonHeight / 2))  
            else
                fontSize = math.max(8, math.min(buttonWidth / 2, buttonHeight / 2))  
            end

            local fontString = button:GetFontString()
            if fontString then
                local font, _, flags = fontString:GetFont()  
                fontString:SetFont(font, fontSize, flags)  
            end

            
            local row = math.floor((i - 1) / buttonsPerRow)  
            local col = math.mod(i - 1, buttonsPerRow)  

            if col == 0 then
                
                button:SetPoint("TOPLEFT", commandFrame, "TOPLEFT", 0, yOffset - (row * (buttonHeight + padding)))
            else
                
                local previousButton = getglobal(commandButtons[i - 1][1])
                if previousButton then
                    button:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", padding, 0)
                end
            end
        end
    end

    
    return rows * (buttonHeight + padding)
end


local function ResizeAddBotButtons()
    local width, height = addBotFrame:GetWidth(), addBotFrame:GetHeight()
	
    AddCustomBot:SetWidth(width / 3)  
    AddCustomBot:SetHeight(height / 4)  	
    classButton:SetWidth(width / 3 + 10)  
    classButton:SetHeight(height / 4 + 5)  	
    roleButton:SetWidth(width / 3 + 10) 
    roleButton:SetHeight(height / 4 + 5) 	

    
    local buttonWidth, buttonHeight = classButton:GetWidth(), classButton:GetHeight()


    local fontSize = math.max(9, math.min(buttonWidth / 2, buttonHeight / 2)) 
    local font, _, flags = classButton:GetFontString():GetFont()
    classButton:GetFontString():SetFont(font, fontSize, flags)

    buttonWidth, buttonHeight = roleButton:GetWidth(), roleButton:GetHeight()
    fontSize = math.max(8, math.min(buttonWidth / 2, buttonHeight / 2))
    font, _, flags = roleButton:GetFontString():GetFont()
    roleButton:GetFontString():SetFont(font, fontSize, flags)

    
    local squareSize = math.min(width, height) / 3
    SetClassADDButton:SetWidth(squareSize)
    SetClassADDButton:SetHeight(squareSize)	
    SetClassSUBButton:SetWidth(squareSize)  
    SetClassSUBButton:SetHeight(squareSize)  	
    SetRoleADDButton:SetWidth(squareSize) 
    SetRoleADDButton:SetHeight(squareSize) 	
    SetRoleSUBButton:SetWidth(squareSize)   
    SetRoleSUBButton:SetHeight(squareSize)   	

    
    AddCustomBot:SetPoint("CENTER", addBotFrame, "CENTER", 0, -40)

    
    local buttonPadding = 5  
    classButton:SetPoint("CENTER", addBotFrame, "CENTER", 0, 10)
    roleButton:SetPoint("CENTER", classButton, "CENTER", 0, -(classButton:GetHeight() + buttonPadding))

    
    SetClassADDButton:ClearAllPoints()
    SetClassADDButton:SetPoint("LEFT", classButton, "RIGHT", 0, 0)  
    SetClassSUBButton:ClearAllPoints()
    SetClassSUBButton:SetPoint("RIGHT", classButton, "LEFT", 0, 0)
    SetRoleADDButton:ClearAllPoints()
    SetRoleADDButton:SetPoint("LEFT", roleButton, "RIGHT", 0, 0)
    SetRoleSUBButton:ClearAllPoints()
    SetRoleSUBButton:SetPoint("RIGHT", roleButton, "LEFT", 0, 0)
    if PCP_UpdateSpawnOptionButtons then PCP_UpdateSpawnOptionButtons() end
end

local function ResizeMarkButtons()
    local width, height = addBotFrame:GetWidth(), addBotFrame:GetHeight()
    local squareSize = math.min(width, height) / 3
    SetMarkADDButton:SetWidth(squareSize)
    SetMarkADDButton:SetHeight(squareSize)	
    SetMarkSUBButton:SetWidth(squareSize)
    SetMarkSUBButton:SetHeight(squareSize)	
    markButton:SetWidth(squareSize * 2 + 50)
    markButton:SetHeight(squareSize)	
    
    local padding = 0  

    markButton:ClearAllPoints()
    markButton:SetPoint("CENTER", markFrame, "CENTER", 0, 0)

    SetMarkADDButton:ClearAllPoints()
    SetMarkADDButton:SetPoint("LEFT", markButton, "RIGHT", padding, 0)
    SetMarkSUBButton:ClearAllPoints()
    SetMarkSUBButton:SetPoint("RIGHT", markButton, "LEFT", -padding, 0)
end







local pcpForceNormalLayout = false
local pcpUpdatingBackdropMode = false
local pcpSectionList = {
    { key = "Controls", frame = controlsFrame, text = "Settings / Close", isControls = true },
    { key = "AddBot", frame = addBotFrame, text = "Add Bot" },
    { key = "Commands", frame = commandsFrame, text = "Main Commands" },
    { key = "PartyBot", frame = partyBotCommandsFrame, text = "PartyBot Commands" },
    { key = "ComeTitle", frame = comeCommandTitleFrame, text = "Come Title" },
    { key = "Come", frame = comeCommandFrame, text = "Come Commands" },
    { key = "MoveTitle", frame = moveCommandTitleFrame, text = "Move Title" },
    { key = "Move", frame = moveCommandFrame, text = "Move Commands" },
    { key = "StayTitle", frame = stayCommandTitleFrame, text = "Stay Title" },
    { key = "Stay", frame = stayCommandFrame, text = "Stay Commands" },
    { key = "Mark", frame = markFrame, text = "Mark" },
    { key = "MarkCommands", frame = markCommandFrame, text = "Mark Commands" },
}

local function PCP_GetSectionBackdropStyle()
    local style = nil
    if PCP_GetBackdropStyle then style = PCP_GetBackdropStyle() end
    if not style then
        style = {
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
            bgColor = { 0, 0, 0, 0.65 },
            borderColor = { 0.6, 0.6, 0.6, 0.8 },
        }
    end
    return style
end

local function PCP_SetFrameBackdrop(target, enable)
    if not target then return end

    if enable then
        if not target._pcpSectionBackdropFrame then
            target._pcpSectionBackdropFrame = CreateFrame("Frame", nil, target)
            if target._pcpSectionBackdropFrame.SetFrameLevel and target.GetFrameLevel then
                local lvl = (target:GetFrameLevel() or 1) - 1
                if lvl < 0 then lvl = 0 end
                target._pcpSectionBackdropFrame:SetFrameLevel(lvl)
            end
        end

        local bg = target._pcpSectionBackdropFrame
        bg:ClearAllPoints()
        bg:SetPoint("TOPLEFT", target, "TOPLEFT", -7, 7)
        bg:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", 7, -7)

        local style = PCP_GetSectionBackdropStyle()
        bg:SetBackdrop({
            bgFile = style.bgFile,
            edgeFile = style.edgeFile,
            tile = style.tile, tileSize = style.tileSize, edgeSize = style.edgeSize,
            insets = style.insets,
        })
        bg:SetBackdropColor(style.bgColor[1], style.bgColor[2], style.bgColor[3], style.bgColor[4])
        bg:SetBackdropBorderColor(style.borderColor[1], style.borderColor[2], style.borderColor[3], style.borderColor[4])
        bg:Show()
    else
        if target._pcpSectionBackdropFrame then
            target._pcpSectionBackdropFrame:Hide()
        end
    end
end

PCP_UpdateFreeBackdropMode = function()
    if pcpUpdatingBackdropMode then return end
    pcpUpdatingBackdropMode = true

    local freeMode = PCP_Settings and PCP_Settings.freeSectionLayout == true
    local backdropEnabled = true
    if PCP_Settings and PCP_Settings.backdropEnabled ~= nil then
        backdropEnabled = PCP_Settings.backdropEnabled == true
    elseif backdropCheck then
        backdropEnabled = backdropCheck:GetChecked() == 1
    end

    local useSectionBackdrops = freeMode and backdropEnabled

    if useSectionBackdrops then
        if frame.SetBackdrop then frame:SetBackdrop(nil) end
        if resizeGrip then resizeGrip:Hide() end
    else
        ToggleBackdrop(frame, backdropEnabled)
        if resizeGrip then resizeGrip:Show() end
    end

    if freeMode then
        controlsFrame:Show()
        if controlsFrame.EnableMouse then controlsFrame:EnableMouse(true) end
        if settingsButton:GetParent() ~= controlsFrame then settingsButton:SetParent(controlsFrame) end
        if closeButton:GetParent() ~= controlsFrame then closeButton:SetParent(controlsFrame) end
        if settingsButton.SetFrameLevel then settingsButton:SetFrameLevel((controlsFrame:GetFrameLevel() or 1) + 50) end
        if closeButton.SetFrameLevel then closeButton:SetFrameLevel((controlsFrame:GetFrameLevel() or 1) + 50) end
        if settingsButton.EnableMouse then settingsButton:EnableMouse(true) end
        if closeButton.EnableMouse then closeButton:EnableMouse(true) end
        settingsButton:Show()
        closeButton:Show()
        ResizeControlsButtons()
    else
        
        
        
        if settingsButton:GetParent() ~= frame then settingsButton:SetParent(frame) end
        if closeButton:GetParent() ~= frame then closeButton:SetParent(frame) end

        settingsButton:ClearAllPoints()
        settingsButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
        settingsButton:SetWidth(16)
        settingsButton:SetHeight(16)
        if settingsButton.SetFrameLevel then settingsButton:SetFrameLevel((frame:GetFrameLevel() or 1) + 50) end
        if settingsButton.EnableMouse then settingsButton:EnableMouse(true) end
        settingsButton:Show()

        closeButton:ClearAllPoints()
        closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
        closeButton:SetWidth(16)
        closeButton:SetHeight(16)
        if closeButton.SetFrameLevel then closeButton:SetFrameLevel((frame:GetFrameLevel() or 1) + 50) end
        if closeButton.EnableMouse then closeButton:EnableMouse(true) end
        closeButton:Show()

        controlsFrame:Hide()
    end

    for _, sec in ipairs(pcpSectionList) do
        if sec.frame then
            PCP_SetFrameBackdrop(sec.frame, useSectionBackdrops and PCP_IsSectionEnabled(sec))
        end
    end

    pcpUpdatingBackdropMode = false
end

local function PCP_GetSettingBool(key)
    return PCP_Settings and PCP_Settings[key] == true
end

local function PCP_EnsureSectionSettings()
    if not PCP_Settings then PCP_Settings = {} end
    if type(PCP_Settings.sectionPositions) ~= "table" then PCP_Settings.sectionPositions = {} end
    if type(PCP_Settings.sectionSizes) ~= "table" then PCP_Settings.sectionSizes = {} end
    if type(PCP_Settings.sectionEnabled) ~= "table" then PCP_Settings.sectionEnabled = {} end
    for _, sec in ipairs(pcpSectionList) do
        if sec and sec.key and not sec.isControls and PCP_Settings.sectionEnabled[sec.key] == nil then
            PCP_Settings.sectionEnabled[sec.key] = true
        end
    end
end

function PCP_IsSectionEnabled(sec)
    if not sec then return false end
    PCP_EnsureSectionSettings()
    if sec.isControls then
        return PCP_GetSettingBool("freeSectionLayout")
    end
    return PCP_Settings.sectionEnabled[sec.key] ~= false
end

PCP_ApplySectionVisibility = function()
    PCP_EnsureSectionSettings()
    for _, sec in ipairs(pcpSectionList) do
        if sec.frame then
            if PCP_IsSectionEnabled(sec) then
                
                
                
                if frame and sec.frame:GetParent() ~= frame then
                    sec.frame:SetParent(frame)
                end
                sec.frame:Show()
            else
                sec.frame:Hide()
                if sec.resizeGrip then sec.resizeGrip:Hide() end
                if sec.frame._pcpSectionBackdropFrame then sec.frame._pcpSectionBackdropFrame:Hide() end
            end
        end
    end
    if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
end

local function PCP_SnapValue(value, grid)
    grid = grid or 20
    if value >= 0 then return math.floor((value / grid) + 0.5) * grid end
    return math.ceil((value / grid) - 0.5) * grid
end

local function PCP_SaveSectionPosition(sec)
    if not sec or not sec.frame then return end
    PCP_EnsureSectionSettings()
    local parentLeft = frame:GetLeft() or 0
    local parentTop = frame:GetTop() or 0
    local left = sec.frame:GetLeft() or parentLeft
    local top = sec.frame:GetTop() or parentTop
    local x = left - parentLeft
    local y = top - parentTop
    if PCP_GetSettingBool("snapSectionLayout") then
        x = PCP_SnapValue(x, 20)
        y = PCP_SnapValue(y, 20)
    end
    PCP_Settings.sectionPositions[sec.key] = { x = x, y = y }
    sec.frame:ClearAllPoints()
    sec.frame:SetParent(frame)
    sec.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y)
end

local function PCP_SaveSectionSize(sec)
    if not sec or not sec.frame then return end
    PCP_EnsureSectionSettings()
    local w = sec.frame:GetWidth() or 0
    local h = sec.frame:GetHeight() or 0
    if w < 80 then w = 80 end
    if h < 20 then h = 20 end
    PCP_Settings.sectionSizes[sec.key] = { width = w, height = h }
end

local function PCP_ApplySectionSize(sec)
    if not sec or not sec.frame then return end
    PCP_EnsureSectionSettings()
    local size = PCP_Settings.sectionSizes[sec.key]
    if size and size.width and size.height then
        sec.frame:SetWidth(size.width)
        sec.frame:SetHeight(size.height)
    end
end

local function PCP_HasSavedSectionSize(sec)
    if not sec or not sec.key then return false end
    PCP_EnsureSectionSettings()
    local size = PCP_Settings.sectionSizes[sec.key]
    return size and size.width and size.height
end

local function PCP_ApplySavedSectionSizes()
    for _, sec in ipairs(pcpSectionList) do
        PCP_ApplySectionSize(sec)
    end
end

local function PCP_RefreshSectionContents(sec)
    if not sec or sec.key == "Controls" then
        ResizeControlsButtons()
    end
    if not sec or sec.key == "Commands" then
        ResizeCommandButtons(commands, commandsFrame, 3, 0, 0, false)
    end
    if not sec or sec.key == "PartyBot" then
        ResizeCommandButtons(partyBotCommands, partyBotCommandsFrame, 2, 0, 0, true)
    end
    if not sec or sec.key == "Come" then
        ResizeRoleCommandButtons(roleCommandButtons, comeCommandFrame)
    end
    if not sec or sec.key == "Move" then
        ResizeRoleCommandButtons(moveRoleCommandButtons, moveCommandFrame)
    end
    if not sec or sec.key == "Stay" then
        ResizeRoleCommandButtons(stayRoleCommandButtons, stayCommandFrame)
    end
    if not sec or sec.key == "MarkCommands" then
        ResizeMarkCommandButtons(markCommandButtons, markCommandFrame)
    end
    if not sec or sec.key == "Mark" then
        ResizeMarkButtons()
    end
    if not sec or sec.key == "AddBot" then
        ResizeAddBotButtons()
    end
end

local function PCP_RestackSectionsUsingCurrentSizes()
    if not frame or (PCP_Settings and PCP_Settings.freeSectionLayout == true and not pcpForceNormalLayout) then return end
    local frameHeight = frame:GetHeight() or 0
    local padding = frameHeight * 0.005
    local outerMargin = 8
    local yOffset = -(padding + outerMargin)
    for _, sec in ipairs(pcpSectionList) do
        if sec.frame then
            sec.frame:SetParent(frame)
            sec.frame:Show()
            sec.frame:ClearAllPoints()
            sec.frame:SetPoint("TOP", frame, "TOP", 0, yOffset)
            yOffset = yOffset - ((sec.frame.GetHeight and sec.frame:GetHeight()) or 0) - padding
        end
    end
end

local function PCP_UpdateSectionResizeLive(sec, saveSize)
    if not sec or not sec.frame then return end
    if saveSize then PCP_SaveSectionSize(sec) end
    PCP_RefreshSectionContents(sec)
    PCP_RestackSectionsUsingCurrentSizes()
    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
    if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
end

local function PCP_StartSectionAltDrag(sec)
    if not sec or not sec.frame then return end
    if not PCP_GetSettingBool("freeSectionLayout") then return end
    if IsAltKeyDown and not IsAltKeyDown() then return end
    sec._pcpDragging = true
    sec.frame:StartMoving()
end

local function PCP_StopSectionAltDrag(sec)
    if not sec or not sec.frame then return end
    if not sec._pcpDragging then return end
    sec._pcpDragging = false
    sec.frame:StopMovingOrSizing()
    PCP_SaveSectionPosition(sec)
end

local function PCP_GetSectionForFrame(obj)
    if not obj then return nil end
    for _, sec in ipairs(pcpSectionList) do
        if sec and sec.frame and (obj == sec.frame or obj:GetParent() == sec.frame) then
            return sec
        end
    end
    return nil
end

local function PCP_HookButtonForSectionDrag(button)
    if not button or button._pcpSectionDragHooked then return end
    button._pcpSectionDragHooked = true
    button._pcpOldOnMouseDown = button:GetScript("OnMouseDown")
    button._pcpOldOnMouseUp = button:GetScript("OnMouseUp")
    button._pcpOldOnClick = button:GetScript("OnClick")

    button:SetScript("OnClick", function()
        if this._pcpSuppressNextClick then
            this._pcpSuppressNextClick = nil
            return
        end
        if this._pcpOldOnClick then this._pcpOldOnClick() end
    end)

    button:SetScript("OnMouseDown", function()
        local sec = PCP_GetSectionForFrame(this)
        if sec and PCP_GetSettingBool("freeSectionLayout") and IsAltKeyDown and IsAltKeyDown() then
            this._pcpStartedSectionDrag = sec
            PCP_StartSectionAltDrag(sec)
            return
        end
        if this._pcpOldOnMouseDown then this._pcpOldOnMouseDown() end
    end)

    button:SetScript("OnMouseUp", function()
        if this._pcpStartedSectionDrag then
            PCP_StopSectionAltDrag(this._pcpStartedSectionDrag)
            this._pcpStartedSectionDrag = nil
            this._pcpSuppressNextClick = true
            return
        end
        if this._pcpOldOnMouseUp then this._pcpOldOnMouseUp() end
    end)
end

local function PCP_EnableButtonSectionDragHooks()
    if not allButtons then return end
    for _, button in ipairs(allButtons) do
        PCP_HookButtonForSectionDrag(button)
    end
end

local function PCP_MakeSectionDraggable(sec)
    if not sec or not sec.frame or sec.dragReady then return end
    sec.dragReady = true
    sec.frame:SetMovable(true)
    sec.frame:RegisterForDrag("LeftButton")
    sec.frame:SetScript("OnDragStart", function() PCP_StartSectionAltDrag(sec) end)
    sec.frame:SetScript("OnDragStop", function() PCP_StopSectionAltDrag(sec) end)
    sec.frame:SetScript("OnEnter", function()
        if not PCP_GetSettingBool("freeSectionLayout") then return end
        GameTooltip:SetOwner(sec.frame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Hold ALT + drag to move this section", 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    sec.frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function PCP_SetFreeSectionScriptsEnabled(enabled)
    for _, sec in ipairs(pcpSectionList) do
        PCP_MakeSectionDraggable(sec)
        if sec.frame then
            if enabled then
                sec.frame:EnableMouse(true)
            else
                
                if sec.isControls then
                    sec.frame:EnableMouse(false)
                else
                    sec.frame:EnableMouse(false)
                end
            end
        end
    end
    if settingsButton and settingsButton.EnableMouse then settingsButton:EnableMouse(true) end
    if closeButton and closeButton.EnableMouse then closeButton:EnableMouse(true) end
    if enabled then PCP_EnableButtonSectionDragHooks() end
end

local function PCP_MakeSectionResizable(sec)
    if not sec or not sec.frame or sec.resizeReady then return end
    sec.resizeReady = true
    if sec.frame.SetResizable then sec.frame:SetResizable(true) end
    if sec.frame.SetMinResize then sec.frame:SetMinResize(80, 20) end

    local grip = CreateFrame("Button", nil, sec.frame)
    grip:SetWidth(20)
    grip:SetHeight(20)
    grip:SetPoint("BOTTOMRIGHT", sec.frame, "BOTTOMRIGHT", 5, -5)

    
    
    
    grip.texture = grip:CreateTexture(nil, "OVERLAY")
    grip.texture:SetAllPoints(grip)
    grip.texture:SetTexture("Interface\\AddOns\\PCP\\img\\ResizeGrip.tga")
    grip.texture:SetTexCoord(0, 1, 0, 1)
    grip.texture:SetVertexColor(1, 1, 1, 1)

    if grip.SetFrameLevel and sec.frame.GetFrameLevel then grip:SetFrameLevel((sec.frame:GetFrameLevel() or 1) + 80) end
    grip:EnableMouse(true)
    grip:Hide()
    grip:SetScript("OnEnter", function()
        if not PCP_GetSettingBool("resizableSections") then return end
        GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
        GameTooltip:SetText("Drag to resize this section", 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    grip:SetScript("OnLeave", function() GameTooltip:Hide() end)
    grip:SetScript("OnMouseDown", function()
        if not PCP_GetSettingBool("resizableSections") then return end
        sec._pcpResizing = true
        sec.frame:StartSizing("BOTTOMRIGHT")
    end)
    grip:SetScript("OnMouseUp", function()
        if not sec._pcpResizing then return end
        sec._pcpResizing = false
        sec.frame:StopMovingOrSizing()
        PCP_SaveSectionSize(sec)
        if PCP_GetSettingBool("freeSectionLayout") then
            PCP_SaveSectionPosition(sec)
            if ApplyPCPSectionLayout then ApplyPCPSectionLayout(frame) end
        end
        PCP_UpdateSectionResizeLive(sec, false)
    end)
    grip:SetScript("OnUpdate", function()
        if not sec._pcpResizing then return end
        sec._pcpResizeElapsed = (sec._pcpResizeElapsed or 0) + (arg1 or 0)
        if sec._pcpResizeElapsed < 0.03 then return end
        sec._pcpResizeElapsed = 0
        PCP_UpdateSectionResizeLive(sec, false)
    end)
    sec.resizeGrip = grip
end

PCP_UpdateSectionResizeMode = function()
    local enabled = PCP_GetSettingBool("resizableSections") and PCP_GetSettingBool("freeSectionLayout")
    for _, sec in ipairs(pcpSectionList) do
        PCP_MakeSectionResizable(sec)
        if sec.resizeGrip then
            if enabled and PCP_IsSectionEnabled(sec) then
                sec.resizeGrip:Show()
                if sec.resizeGrip.texture then sec.resizeGrip.texture:Show() end
            else
                sec.resizeGrip:Hide()
            end
        end
    end
end

ApplyPCPSectionLayout = function(parent)
    PCP_EnsureSectionSettings()
    if PCP_ApplySectionVisibility then PCP_ApplySectionVisibility() end
    local freeMode = PCP_GetSettingBool("freeSectionLayout")
    PCP_SetFreeSectionScriptsEnabled(freeMode)
    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
    PCP_ApplySavedSectionSizes()

    if not freeMode then
        if parent and parent:GetScript("OnSizeChanged") then parent:GetScript("OnSizeChanged")(parent) end
        if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
        return
    end

    
    
    
    local frameW = frame:GetWidth() or 260
    local frameH = frame:GetHeight() or 550
    local padding = frameH * 0.005
    if padding < 2 then padding = 2 end
    local defaultX = 7
    local defaultY = -7

    for _, sec in ipairs(pcpSectionList) do
        if sec.frame and PCP_IsSectionEnabled(sec) then
            sec.frame:SetParent(frame)
            sec.frame:Show()
            PCP_ApplySectionSize(sec)

            if not PCP_HasSavedSectionSize(sec) then
                local defaultW = frameW - (padding * 2) - 14
                if defaultW < 160 then defaultW = 160 end
                if sec.isControls then
                    sec.frame:SetWidth(defaultW)
                    sec.frame:SetHeight(28)
                else
                    sec.frame:SetWidth(defaultW)
                end
            end

            local pos = PCP_Settings.sectionPositions[sec.key]
            sec.frame:ClearAllPoints()
            if pos and pos.x and pos.y then
                sec.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", pos.x, pos.y)
            else
                sec.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", defaultX, defaultY)
                defaultY = defaultY - ((sec.frame.GetHeight and sec.frame:GetHeight()) or 0) - padding - 4
            end
        end
    end
    if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
end

ResetPCPSectionPositions = function()
    PCP_EnsureSectionSettings()
    PCP_Settings.sectionPositions = {}
    PCP_Settings.sectionSizes = {}
    pcpForceNormalLayout = true
    for _, sec in ipairs(pcpSectionList) do
        if sec.frame then
            sec.frame:SetParent(frame)
            sec.frame:ClearAllPoints()
        end
    end
    if frame and frame:GetScript("OnSizeChanged") then frame:GetScript("OnSizeChanged")(frame) end
    pcpForceNormalLayout = false
    PCP_SetFreeSectionScriptsEnabled(PCP_GetSettingBool("freeSectionLayout"))
    if PCP_ApplySectionVisibility then PCP_ApplySectionVisibility() end
    if ApplyPCPSectionLayout then ApplyPCPSectionLayout(frame) end
    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
    if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
end

PCP_ShowSectionOptions = function()
    PCP_EnsureSectionSettings()
    if not PCPSectionOptionsFrame then
        local popup = CreateFrame("Frame", "PCPSectionOptionsFrame", UIParent)
        local h = 72 + (table.getn(pcpSectionList) * 24) + 42
        popup:SetWidth(230)
        popup:SetHeight(h)
        popup:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        popup:SetFrameStrata("DIALOG")
        popup:SetFrameLevel(220)
        popup:SetMovable(true)
        popup:EnableMouse(true)
        popup:RegisterForDrag("LeftButton")
        popup:SetScript("OnDragStart", function() this:StartMoving() end)
        popup:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
        popup:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        popup:SetBackdropColor(0, 0, 0, 0.92)

        local title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", popup, "TOP", 0, -14)
        title:SetText("Visible sections")
        popup.rows = {}

        local rowIndex = 1
        for _, sec in ipairs(pcpSectionList) do
            if not sec.isControls then
                local cb = CreateFrame("CheckButton", nil, popup, "UICheckButtonTemplate")
                cb:SetPoint("TOPLEFT", popup, "TOPLEFT", 18, -38 - ((rowIndex - 1) * 24))
                cb.sectionKey = sec.key
                cb.sectionText = sec.text
                cb.text = cb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                cb.text:SetPoint("LEFT", cb, "RIGHT", 4, 0)
                cb.text:SetText(sec.text)
                cb:SetChecked(PCP_Settings.sectionEnabled[sec.key] ~= false)
                cb:SetScript("OnClick", function()
                    PCP_EnsureSectionSettings()
                    PCP_Settings.sectionEnabled[this.sectionKey] = this:GetChecked() == 1
                    if PCP_ApplySectionVisibility then PCP_ApplySectionVisibility() end
                    pcpVisibleAutoFitRunning = true
                    if frame and frame:GetScript("OnSizeChanged") then frame:GetScript("OnSizeChanged")(frame) end
                    pcpVisibleAutoFitRunning = false
                    if ApplyPCPSectionLayout then ApplyPCPSectionLayout(frame) end
                    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
                    if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
                end)
                popup.rows[rowIndex] = cb
                rowIndex = rowIndex + 1
            end
        end

        local showAll = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
        showAll:SetWidth(80)
        showAll:SetHeight(22)
        showAll:SetPoint("BOTTOMLEFT", popup, "BOTTOMLEFT", 20, 12)
        showAll:SetText("Show all")
        showAll:SetScript("OnClick", function()
            PCP_EnsureSectionSettings()
            for _, sec in ipairs(pcpSectionList) do
                if not sec.isControls then PCP_Settings.sectionEnabled[sec.key] = true end
            end
            if PCPSectionOptionsFrame and PCPSectionOptionsFrame.rows then
                for _, cb in ipairs(PCPSectionOptionsFrame.rows) do
                    if cb and cb.sectionKey then cb:SetChecked(true) end
                end
            end
            if PCP_ApplySectionVisibility then PCP_ApplySectionVisibility() end
            pcpVisibleAutoFitRunning = true
            if frame and frame:GetScript("OnSizeChanged") then frame:GetScript("OnSizeChanged")(frame) end
            pcpVisibleAutoFitRunning = false
            if ApplyPCPSectionLayout then ApplyPCPSectionLayout(frame) end
            if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
            if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
        end)

        local close = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
        close:SetWidth(80)
        close:SetHeight(22)
        close:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -20, 12)
        close:SetText("Close")
        close:SetScript("OnClick", function() popup:Hide() end)

        PCPSectionOptionsFrame = popup
    end

    PCP_EnsureSectionSettings()
    if PCPSectionOptionsFrame.rows then
        for _, cb in ipairs(PCPSectionOptionsFrame.rows) do
            if cb and cb.sectionKey then
                cb:SetChecked(PCP_Settings.sectionEnabled[cb.sectionKey] ~= false)
            end
        end
    end

    if PCPSectionOptionsFrame:IsShown() then
        PCPSectionOptionsFrame:Hide()
    else
        PCPSectionOptionsFrame:Show()
    end
end


pcpVisibleAutoFitRunning = false
frame._pcpBaseLayoutHeight = frame:GetHeight() or 550

frame:SetScript("OnSizeChanged", function()
    local width, height = frame:GetWidth(), frame:GetHeight()

    
    
    
    
    local autoFitting = frame._pcpAutoFitInProgress == true
    local sizingHeight = height
    if autoFitting then
        sizingHeight = frame._pcpBaseLayoutHeight or height
    elseif frame._pcpManualResizing then
        frame._pcpBaseLayoutHeight = height
        sizingHeight = height
    elseif not (PCP_GetSettingBool and PCP_GetSettingBool("freeSectionLayout")) then
        
        if not pcpVisibleAutoFitRunning and (not frame._pcpLastVisibleFitHeight or math.abs((frame._pcpLastVisibleFitHeight or 0) - height) > 2) then
            frame._pcpBaseLayoutHeight = height
        end
        sizingHeight = frame._pcpBaseLayoutHeight or height
    end

    
    local padding = sizingHeight * 0.005

    
    local totalHeight = sizingHeight - padding * 2

    
local frameHeights = {
    addBotFrame = totalHeight * 0.12,          
    commandsFrame = totalHeight * 0.19,        
    partyBotCommandsFrame = totalHeight * 0.19, 
    comeCommandTitleFrame = 10,                
    comeCommandFrame = totalHeight * 0.05,     
    moveCommandTitleFrame = 10,                
    moveCommandFrame = totalHeight * 0.05,     
    stayCommandTitleFrame = 10,                
    stayCommandFrame = totalHeight * 0.05,     

    markFrame = totalHeight * 0.04,            
    markCommandFrame = totalHeight * 0.15      
}
    
    addBotFrame:SetHeight(frameHeights.addBotFrame)
    commandsFrame:SetHeight(frameHeights.commandsFrame)
    comeCommandTitleFrame:SetHeight(frameHeights.comeCommandTitleFrame)
    comeCommandFrame:SetHeight(frameHeights.comeCommandFrame)
    moveCommandTitleFrame:SetHeight(frameHeights.moveCommandTitleFrame)
    moveCommandFrame:SetHeight(frameHeights.moveCommandFrame)
    stayCommandTitleFrame:SetHeight(frameHeights.stayCommandTitleFrame)
    stayCommandFrame:SetHeight(frameHeights.stayCommandFrame)
    partyBotCommandsFrame:SetHeight(frameHeights.partyBotCommandsFrame)
    markFrame:SetHeight(frameHeights.markFrame)
    markCommandFrame:SetHeight(frameHeights.markCommandFrame)

    
    local frameWidth = width - padding * 2
    addBotFrame:SetWidth(frameWidth)
    commandsFrame:SetWidth(frameWidth)
    comeCommandTitleFrame:SetWidth(frameWidth)
    comeCommandFrame:SetWidth(frameWidth)
    moveCommandTitleFrame:SetWidth(frameWidth)
    moveCommandFrame:SetWidth(frameWidth)
    stayCommandTitleFrame:SetWidth(frameWidth)
    stayCommandFrame:SetWidth(frameWidth)
    partyBotCommandsFrame:SetWidth(frameWidth)
    markFrame:SetWidth(frameWidth)
    markCommandFrame:SetWidth(frameWidth)

    if PCP_GetSettingBool and PCP_GetSettingBool("freeSectionLayout") and not pcpForceNormalLayout then
        if ApplyPCPSectionLayout then ApplyPCPSectionLayout(frame) end
        local commandsHeight = ResizeCommandButtons(commands, commandsFrame, 3, 0, 0, false)
        local partyBotHeight = ResizeCommandButtons(partyBotCommands, partyBotCommandsFrame, 2, 0, 0, true)
        local hej = commandsHeight / 4
        ResizeRoleCommandButtons(roleCommandButtons, comeCommandFrame, hej)
        ResizeRoleCommandButtons(moveRoleCommandButtons, moveCommandFrame, hej)
        ResizeRoleCommandButtons(stayRoleCommandButtons, stayCommandFrame, hej)
        ResizeMarkCommandButtons(markCommandButtons, markCommandFrame)
        ResizeMarkButtons()
        ResizeAddBotButtons()
        return
    end

    
    
    local yOffset = -padding

    local function PCP_PositionVisibleSection(sec, sectionHeight)
        if not sec or not sec.frame then return end
        if PCP_IsSectionEnabled and not PCP_IsSectionEnabled(sec) then
            sec.frame:Hide()
            if sec.resizeGrip then sec.resizeGrip:Hide() end
            if sec.frame._pcpSectionBackdropFrame then sec.frame._pcpSectionBackdropFrame:Hide() end
            return
        end

        
        
        
        sec.frame:SetParent(frame)
        sec.frame:Show()
        sec.frame:ClearAllPoints()
        sec.frame:SetPoint("TOP", frame, "TOP", 0, yOffset)
        yOffset = yOffset - sectionHeight - padding
    end

    PCP_PositionVisibleSection(pcpSectionList[2], frameHeights.addBotFrame)
    PCP_PositionVisibleSection(pcpSectionList[3], frameHeights.commandsFrame)
    PCP_PositionVisibleSection(pcpSectionList[4], frameHeights.partyBotCommandsFrame)
    PCP_PositionVisibleSection(pcpSectionList[5], frameHeights.comeCommandTitleFrame)
    PCP_PositionVisibleSection(pcpSectionList[6], frameHeights.comeCommandFrame)
    PCP_PositionVisibleSection(pcpSectionList[7], frameHeights.moveCommandTitleFrame)
    PCP_PositionVisibleSection(pcpSectionList[8], frameHeights.moveCommandFrame)
    PCP_PositionVisibleSection(pcpSectionList[9], frameHeights.stayCommandTitleFrame)
    PCP_PositionVisibleSection(pcpSectionList[10], frameHeights.stayCommandFrame)
    PCP_PositionVisibleSection(pcpSectionList[11], frameHeights.markFrame)
    PCP_PositionVisibleSection(pcpSectionList[12], frameHeights.markCommandFrame)

    
    local commandsHeight = ResizeCommandButtons(commands, commandsFrame, 3, 0, 0, false)
    local partyBotHeight = ResizeCommandButtons(partyBotCommands, partyBotCommandsFrame, 2, 0, 0, true)
    local hej = commandsHeight / 4

    
    ResizeRoleCommandButtons(roleCommandButtons, comeCommandFrame, hej)
    ResizeRoleCommandButtons(moveRoleCommandButtons, moveCommandFrame, hej)
    ResizeRoleCommandButtons(stayRoleCommandButtons, stayCommandFrame, hej)
    ResizeMarkCommandButtons(markCommandButtons, markCommandFrame)

    
    ResizeMarkButtons()
    ResizeAddBotButtons()

    
    
    if not (PCP_GetSettingBool and PCP_GetSettingBool("freeSectionLayout")) and not frame._pcpManualResizing then
        local fittedHeight = (-yOffset) + padding
        if fittedHeight < 120 then fittedHeight = 120 end
        frame._pcpLastVisibleFitHeight = fittedHeight

        if math.abs((height or 0) - fittedHeight) > 1 then
            pcpVisibleAutoFitRunning = true
            frame._pcpAutoFitInProgress = true
            frame:SetHeight(fittedHeight)
            pcpVisibleAutoFitRunning = false
        end
    end

    if autoFitting then
        frame._pcpAutoFitInProgress = false
    end
end)
	
    PCPFrameRemake = frame
end	














if not PCP_MinimapDB then PCP_MinimapDB = {} end
if not PCP_MinimapDB.MinimapAngle then PCP_MinimapDB.MinimapAngle = 0 end

local radius = 80
local buttonSize = 32


if not PCPButtonFrame then
    local template = string.find(version or "", "^1.14") and "BackdropTemplate" or nil
    PCPButtonFrame = CreateFrame("Button", "PCPButtonFrame", Minimap, template)
    PCPButtonFrame:SetWidth(buttonSize)
    PCPButtonFrame:SetHeight(buttonSize)
    PCPButtonFrame:SetFrameStrata("MEDIUM")
    PCPButtonFrame:EnableMouse(true)
    PCPButtonFrame:RegisterForDrag("RightButton")

    
    local tex = PCPButtonFrame:CreateTexture(nil, "BACKGROUND")
    tex:SetTexture("Interface\\AddOns\\PCP\\img\\SoloCraft3.tga")
    tex:SetAllPoints(PCPButtonFrame)
    PCPButtonFrame.texture = tex

    
    PCPButtonFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

    
    
    
    local function ShowTooltip(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine("|cff33ffccPartyBot Control Panel|r")
        GameTooltip:AddLine("Left-click: Open/Close panel", 1, 1, 1)
        GameTooltip:AddLine("Right-click + drag: Move button", 0.7, 0.7, 0.7)
        GameTooltip:Show()
    end
    local function HideTooltip() GameTooltip:Hide() end

    
    
    
    local function UpdateMinimapPosition()
        local angle = PCP_MinimapDB.MinimapAngle
        local x = radius * math.cos(angle)
        local y = radius * math.sin(angle)
        PCPButtonFrame:ClearAllPoints()
        PCPButtonFrame:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end

    
    
    
    local function OnClick()
        if arg1 == "LeftButton" then
            if PCPFrameRemake:IsShown() then
                PCPFrameRemake:Hide()
            else
                PCPFrameRemake:Show()
            end
        end
    end

    local function OnDragStart()
        this.isDragging = true
        this:SetScript("OnUpdate", function()
            if not this.isDragging then return end
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            local angle = math.atan2(py - my, px - mx)
            PCP_MinimapDB.MinimapAngle = angle
            UpdateMinimapPosition()
        end)
    end

    local function OnDragStop()
        this.isDragging = false
        this:SetScript("OnUpdate", nil)
    end

    
    
    
    if string.find(version or "", "^1.12") then
        PCPButtonFrame:SetScript("OnClick", function() OnClick() end)
        PCPButtonFrame:SetScript("OnMouseDown", function()
            if arg1 == "RightButton" then OnDragStart() end
        end)
        PCPButtonFrame:SetScript("OnMouseUp", function() OnDragStop() end)
        PCPButtonFrame:SetScript("OnEnter", function() ShowTooltip(this) end)
        PCPButtonFrame:SetScript("OnLeave", function() HideTooltip() end)
    else
        PCPButtonFrame:SetScript("OnClick", OnClick)
        PCPButtonFrame:SetScript("OnMouseDown", function(self, btn)
            if btn == "RightButton" then
                self.isDragging = true
                self:SetScript("OnUpdate", function()
                    if not self.isDragging then return end
                    local mx, my = Minimap:GetCenter()
                    local px, py = GetCursorPosition()
                    local scale = Minimap:GetEffectiveScale()
                    px, py = px / scale, py / scale
                    local angle = math.atan2(py - my, px - mx)
                    PCP_MinimapDB.MinimapAngle = angle
                    UpdateMinimapPosition()
                end)
            end
        end)
        PCPButtonFrame:SetScript("OnMouseUp", function(self)
            self.isDragging = false
            self:SetScript("OnUpdate", nil)
        end)
        PCPButtonFrame:SetScript("OnEnter", ShowTooltip)
        PCPButtonFrame:SetScript("OnLeave", HideTooltip)
    end

    
    
    
    local f = CreateFrame("Frame")
    f:RegisterEvent("ADDON_LOADED")
    f:SetScript("OnEvent", function()
        if arg1 == "PCP" then
            UpdateMinimapPosition()
        end
    end)

    
    local saveFrame = CreateFrame("Frame")
    saveFrame:RegisterEvent("PLAYER_LOGOUT")
    saveFrame:SetScript("OnEvent", function()
        if PCPButtonFrame and PCP_MinimapDB then
            PCP_MinimapDB.MinimapAngle = PCP_MinimapDB.MinimapAngle or 0
        end
    end)

    UpdateMinimapPosition()
end







BINDING_HEADER_CCP = "PartyBot Control Panel";
BINDING_NAME_CP = "Show/Hide PCP";


CMD_PARTYBOT_CLONE = ".partybot clone";
CMD_PARTYBOT_REMOVE = ".partybot remove";
CMD_PARTYBOT_ADD = ".partybot add ";
CMD_PARTYBOT_MAll = ".partybot moveall";
CMD_PARTYBOT_SAll = ".partybot stayall";
CMD_BATTLEGROUND_GO = ".go ";
CMD_BATTLEBOT_ADD = ".battlebot add ";
CMD_TOGGLE_HELM = ".partybot togglehelm ";
CMD_TOGGLE_CLOAK = ".partybot togglecloak ";
CMD_GENERAL = ".partybot ";

AddCmd = ""
CmdItr = 1
function CmdStackHide()
	CmdAll:Hide()
	CmdTank:Hide()
	CmdHealer:Hide()
	CmdDPS:Hide()
	CmdMDPS:Hide()
	CmdRDPS:Hide()
	CmdWarrior:Hide()
	CmdPaladin:Hide()
	CmdHunter:Hide()
	CmdRogue:Hide()
	CmdPriest:Hide()
	CmdShaman:Hide()
	CmdMage:Hide()
	CmdWarlock:Hide()
	CmdDruid:Hide()
end

function CmdADD()
	Cmds = { "", "tank", "healer", "dps", "mdps", "rdps", "warrior", "paladin", "hunter", "rogue", "priest", "shaman", "mage", "warlock", "druid" }

	CmdItr = CmdItr + 1	
	if CmdItr >= table.getn(Cmds) + 1 then CmdItr = 1 end
	AddCmd = Cmds[CmdItr]

	if Cmds[CmdItr] == "" then CmdStackHide() CmdAll:Show() end
	if Cmds[CmdItr] == "tank" then CmdStackHide() CmdroleButton:SetText("Tank") end
	if Cmds[CmdItr] == "healer" then CmdStackHide() CmdroleButton:SetText("Healer") end
	if Cmds[CmdItr] == "dps" then CmdStackHide() CmdDPS:Show() end
	if Cmds[CmdItr] == "mdps" then CmdStackHide() CmdMDPS:Show() end
	if Cmds[CmdItr] == "rdps" then CmdStackHide() CmdRDPS:Show() end
	if Cmds[CmdItr] == "warrior" then CmdStackHide() CmdroleButton:SetText("Warrior") end
	if Cmds[CmdItr] == "paladin" then CmdStackHide() CmdroleButton:SetText("Paladin") end
	if Cmds[CmdItr] == "hunter" then CmdStackHide() CmdroleButton:SetText("Hunter") end
	if Cmds[CmdItr] == "rogue" then CmdStackHide() CmdroleButton:SetText("Rogue") end
	if Cmds[CmdItr] == "priest" then CmdStackHide() CmdroleButton:SetText("Priest") end
	if Cmds[CmdItr] == "shaman" then CmdStackHide() CmdroleButton:SetText("Shaman") end
	if Cmds[CmdItr] == "mage" then CmdStackHide() CmdroleButton:SetText("Mage") end
	if Cmds[CmdItr] == "warlock" then CmdStackHide() CmdroleButton:SetText("Warlock") end
	if Cmds[CmdItr] == "druid" then CmdStackHide() CmdroleButton:SetText("Druid") end
end

function CmdSUB()
	Cmds = { "", "tank", "healer", "dps", "mdps", "rdps", "warrior", "paladin", "hunter", "rogue", "priest", "shaman", "mage", "warlock", "druid" }

	CmdItr = CmdItr - 1	
	if CmdItr <= 0 then CmdItr = table.getn(Cmds) end
	AddCmd = Cmds[CmdItr]

	if Cmds[CmdItr] == "" then CmdStackHide() CmdAll:Show() end
	if Cmds[CmdItr] == "tank" then CmdStackHide() CmdroleButton:SetText("Tank") end
	if Cmds[CmdItr] == "healer" then CmdStackHide() CmdroleButton:SetText("Healer") end
	if Cmds[CmdItr] == "dps" then CmdStackHide() CmdDPS:Show() end
	if Cmds[CmdItr] == "mdps" then CmdStackHide() CmdMDPS:Show() end
	if Cmds[CmdItr] == "rdps" then CmdStackHide() CmdRDPS:Show() end
	if Cmds[CmdItr] == "warrior" then CmdStackHide() CmdroleButton:SetText("Warrior") end
	if Cmds[CmdItr] == "paladin" then CmdStackHide() CmdroleButton:SetText("Paladin") end
	if Cmds[CmdItr] == "hunter" then CmdStackHide() CmdroleButton:SetText("Hunter") end
	if Cmds[CmdItr] == "rogue" then CmdStackHide() CmdroleButton:SetText("Rogue") end
	if Cmds[CmdItr] == "priest" then CmdStackHide() CmdroleButton:SetText("Priest") end
	if Cmds[CmdItr] == "shaman" then CmdStackHide() CmdroleButton:SetText("Shaman") end
	if Cmds[CmdItr] == "mage" then CmdStackHide() CmdroleButton:SetText("Mage") end
	if Cmds[CmdItr] == "warlock" then CmdStackHide() CmdroleButton:SetText("Warlock") end
	if Cmds[CmdItr] == "druid" then CmdStackHide() CmdroleButton:SetText("Druid") end
end

function GetChatChannel()
    if GetNumRaidMembers() > 0 then
        return "RAID"
    elseif GetNumPartyMembers() > 0 then
        return "PARTY"
    else
        return "SAY"  
    end
end

function SetCommand(arg)
    DispatchCommand(CMD_GENERAL .. arg)
end

function SetPause()
    DispatchCommand(CMD_GENERAL .. "pause")
end

function SetUnpause()
    DispatchCommand(CMD_GENERAL .. "unpause")
end

AddMark = "ccmark"
MarkItr = 1
function MarkStackHide()
	ccmark:Hide()
	focusmark:Hide()
end

function MarkADD()
    
    Marks = { "ccmark", "focusmark" }

    
	MarkItr = MarkItr + 1	
	if MarkItr >= table.getn(Marks) + 1 then MarkItr = 1 end
	AddMark = Marks[MarkItr]
    if Marks[MarkItr] == "ccmark" then
        markButton:SetText("CC Mark")
    elseif Marks[MarkItr] == "focusmark" then
        markButton:SetText("Focus Mark")
    end
end

function MarkSUB()
    
    Marks = { "ccmark", "focusmark" }

    
	MarkItr = MarkItr - 1	
	if MarkItr <= 0 then MarkItr = table.getn(Marks) end
	AddMark = Marks[MarkItr]
	
    
    if Marks[MarkItr] == "ccmark" then
        markButton:SetText("CC Mark")
    elseif Marks[MarkItr] == "focusmark" then
        markButton:SetText("Fokus Mark")
    end
end

function SetMark(arg)
	DispatchCommand(CMD_GENERAL .. AddMark .. " " .. arg)
end

function ShowMark()
	DispatchCommand(CMD_GENERAL .. AddMark)
end

function ClearMark()
	DispatchCommand(CMD_GENERAL .. "clear " .. AddMark)
end

function ClearAllMark()
	DispatchCommand(CMD_GENERAL .. "clear")
end

AddToggle = "aoe"
ToggleItr = 1
function ToggleStackHide()
	ToggleAOE:Hide()
	ToggleHelmCloak:Hide()
	helm:Hide()
	cloak:Hide()
end

function ToggleADD()
	Toggles = { "aoe", "ToggleHelmCloak", "helm", "cloak" }

	ToggleItr = ToggleItr + 1	
	if ToggleItr >= table.getn(Toggles) + 1 then ToggleItr = 1 end
	AddToggle = Toggles[ToggleItr]

	if Toggles[ToggleItr] == "aoe" then ToggleStackHide() ToggleAOE:Show() end
	if Toggles[ToggleItr] == "ToggleHelmCloak" then ToggleStackHide() ToggleHelmCloak:Show() end
	if Toggles[ToggleItr] == "helm" then ToggleStackHide() helm:Show() end
	if Toggles[ToggleItr] == "cloak" then ToggleStackHide() cloak:Show() end
end

function ToggleSUB()
	Toggles = { "aoe", "ToggleHelmCloak", "helm", "cloak" }

	ToggleItr = ToggleItr - 1	
	if ToggleItr <= 0 then ToggleItr = table.getn(Toggles) end
	AddToggle = Toggles[ToggleItr]

	if Toggles[ToggleItr] == "aoe" then ToggleStackHide() ToggleAOE:Show() end
	if Toggles[ToggleItr] == "ToggleHelmCloak" then ToggleStackHide() ToggleHelmCloak:Show() end
	if Toggles[ToggleItr] == "helm" then ToggleStackHide() helm:Show() end
	if Toggles[ToggleItr] == "cloak" then ToggleStackHide() cloak:Show() end
end

function SetToggle()
	DispatchCommand(CMD_GENERAL .. "toggle " .. AddToggle)
end

function SubPartyBotClone(self)
	DispatchCommand(CMD_PARTYBOT_CLONE)
end

function SubPartyBotRemove(self)
	DispatchCommand(CMD_PARTYBOT_REMOVE)
end

function SubPartyBotMoveAll()
    DispatchCommand(CMD_PARTYBOT_MAll)
end

function SubPartyBotStayAll()
    DispatchCommand(CMD_PARTYBOT_SAll)
end

AddClass = "warrior"
ClassItr = 1
function SetClassADD()
	Classes = { "warrior" , "paladin", "hunter", "rogue", "priest", "shaman", "mage", "warlock", "druid" }
		
	ClassItr = ClassItr + 1	
	if ClassItr == 10 then ClassItr = 1 end
	
	if UnitFactionGroup("player") == "Alliance" then
		if Classes[ClassItr] == "shaman" then 
			ClassItr = ClassItr + 1 
			AddClass = Classes[ClassItr]
		end
	else AddClass = Classes[ClassItr]
	end
	
	if UnitFactionGroup("player") == "Horde" then
		if Classes[ClassItr] == "paladin" then 
			ClassItr = ClassItr + 1 
			AddClass = Classes[ClassItr]
		end
	else AddClass = Classes[ClassItr]
	end	
	
	if Classes[ClassItr] == "warrior" then classButton:SetText("Warrior") end
	if UnitFactionGroup("player") == "Alliance" then 
		if Classes[ClassItr] == "paladin" then classButton:SetText("Paladin") end
		if Classes[ClassItr] == "hunter" then classButton:SetText("Hunter") end	
	else
		if Classes[ClassItr] == "hunter" then classButton:SetText("Hunter") end
	end	
	if Classes[ClassItr] == "rogue" then classButton:SetText("Rogue") end
	if Classes[ClassItr] == "priest" then classButton:SetText("Priest") end
	if UnitFactionGroup("player") == "Horde" then 
		if Classes[ClassItr] == "shaman" then classButton:SetText("Shaman")end
		if Classes[ClassItr] == "mage" then classButton:SetText("Mage") end	
	else
		if Classes[ClassItr] == "mage" then classButton:SetText("Mage") end
	end	
	if Classes[ClassItr] == "warlock" then classButton:SetText("Warlock") end
	if Classes[ClassItr] == "druid" then classButton:SetText("Druid") end
	
	RoleUpdate()
	RoleItr = 1
	if PCP_UpdateSpawnOptionButtons then PCP_UpdateSpawnOptionButtons() end
end

function SetClassSUB()
    Classes = { "warrior", "paladin", "hunter", "rogue", "priest", "shaman", "mage", "warlock", "druid" }
    
    ClassItr = ClassItr - 1
    if ClassItr == 0 then ClassItr = 9 end
    
    if UnitFactionGroup("player") == "Alliance" then
        if Classes[ClassItr] == "shaman" then 
            ClassItr = ClassItr - 1
            if ClassItr == 0 then ClassItr = 9 end
            AddClass = Classes[ClassItr]
        end
    else 
        AddClass = Classes[ClassItr]
    end
    
    if UnitFactionGroup("player") == "Horde" then
        if Classes[ClassItr] == "paladin" then 
            ClassItr = ClassItr - 1
            if ClassItr == 0 then ClassItr = 9 end
            AddClass = Classes[ClassItr]
        end
    else 
        AddClass = Classes[ClassItr]
    end
    
    if Classes[ClassItr] == "warrior" then classButton:SetText("Warrior") end
    if UnitFactionGroup("player") == "Alliance" then
        if Classes[ClassItr] == "paladin" then classButton:SetText("Paladin") end
        if Classes[ClassItr] == "hunter" then classButton:SetText("Hunter") end
    else
        if Classes[ClassItr] == "hunter" then classButton:SetText("Hunter") end
    end
    if Classes[ClassItr] == "rogue" then classButton:SetText("Rogue") end
    if Classes[ClassItr] == "priest" then classButton:SetText("Priest") end
    if UnitFactionGroup("player") == "Horde" then
        if Classes[ClassItr] == "shaman" then classButton:SetText("Shaman") end
        if Classes[ClassItr] == "mage" then classButton:SetText("Mage") end
    else
        if Classes[ClassItr] == "mage" then classButton:SetText("Mage") end
    end
    if Classes[ClassItr] == "warlock" then classButton:SetText("Warlock") end
    if Classes[ClassItr] == "druid" then classButton:SetText("Druid") end
    
    RoleUpdate()
    RoleItr = 1
    if PCP_UpdateSpawnOptionButtons then PCP_UpdateSpawnOptionButtons() end
end


function RaceUpdate()
	if Classes[ClassItr] == "warrior" then 
		if UnitFactionGroup("player") == "Alliance" then 
			RaceStackHide()
			human:Show()
			AddRace = "human" 
		elseif UnitFactionGroup("player") == "Horde" then 
			RaceStackHide()
			orc:Show()
			AddRace = "orc"
		else
			RaceStackHide()
			race:Show()
			AddRace = "race"
		end
	end

	if Classes[ClassItr] == "paladin" then 
		RaceStackHide()
		human:Show()		
		AddRace = "human" 
	end

	if Classes[ClassItr] == "hunter" then 
		if UnitFactionGroup("player") == "Alliance" then
			RaceStackHide()	
			dwarf:Show()			
			AddRace = "dwarf" 
		elseif UnitFactionGroup("player") == "Horde" then 
			RaceStackHide()
			orc:Show()		
			AddRace = "orc"
		else
			RaceStackHide()
			race:Show()
			AddRace = "race"
		end	
	end
	if Classes[ClassItr] == "rogue" then 
		if UnitFactionGroup("player") == "Alliance" then
			RaceStackHide()	
			human:Show()			
			AddRace = "human" 
		elseif UnitFactionGroup("player") == "Horde" then 
			RaceStackHide()
			orc:Show()		
			AddRace = "orc"
		else
			RaceStackHide()
			race:Show()
			AddRace = "race"
		end		
	end
	if Classes[ClassItr] == "priest" then 
		if UnitFactionGroup("player") == "Alliance" then
			RaceStackHide()	
			human:Show()			
			AddRace = "human" 
		elseif UnitFactionGroup("player") == "Horde" then 
			RaceStackHide()
			undead:Show()		
			AddRace = "undead"
		else
			RaceStackHide()
			race:Show()
			AddRace = "race"
		end		
	end
	if Classes[ClassItr] == "shaman" then 
		RaceStackHide()
		orc:Show()		
		AddRace = "orc"
	end
	if Classes[ClassItr] == "mage" then 
		if UnitFactionGroup("player") == "Alliance" then
			RaceStackHide()	
			human:Show()			
			AddRace = "human" 
		elseif UnitFactionGroup("player") == "Horde" then 
			RaceStackHide()
			undead:Show()		
			AddRace = "undead"
		else
			RaceStackHide()
			race:Show()
			AddRace = "race"
		end		 
	end
	if Classes[ClassItr] == "warlock" then 
		if UnitFactionGroup("player") == "Alliance" then
			RaceStackHide()	
			human:Show()			
			AddRace = "human" 
		elseif UnitFactionGroup("player") == "Horde" then 
			RaceStackHide()
			orc:Show()		
			AddRace = "orc"
		else
			RaceStackHide()
			race:Show()
			AddRace = "race"
		end		
	end
	if Classes[ClassItr] == "druid" then 
		if UnitFactionGroup("player") == "Alliance" then
			RaceStackHide()	
			nightelf:Show()			
			AddRace = "nightelf" 
		elseif UnitFactionGroup("player") == "Horde" then 
			RaceStackHide()
			tauren:Show()		
			AddRace = "tauren"
		else
			RaceStackHide()
			race:Show()
			AddRace = "race"
		end	
	end
end



function RaceStackHide()
	race:Hide()
	human:Hide()
	dwarf:Hide()
	nightelf:Hide()
	gnome:Hide()
	orc:Hide()
	undead:Hide()
	tauren:Hide()
	troll:Hide()	
end

AddRace = "race"
RaceItr = 0
function SetRaceADD()
	if AddClass == "warrior" then	
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "dwarf", "nightelf", "gnome", "race" }			
		else 			
			Races = { "orc", "undead", "tauren", "troll", "race" }		
		end		
		
		RaceItr = RaceItr + 1	
		if RaceItr >= table.getn(Races) + 1 then RaceItr = 1 end
		AddRace = Races[RaceItr]
		
		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		if Races[RaceItr] == "gnome" then RaceStackHide() gnome:Show() end
		
		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end
		if Races[RaceItr] == "tauren" then RaceStackHide() tauren:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end		
		
	elseif AddClass == "paladin" then		
		Races = { "human", "dwarf", "race" }
		
		RaceItr = RaceItr + 1	
		if RaceItr >= table.getn(Races) + 1 then RaceItr = 1 end
		AddRace = Races[RaceItr]
		
		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		
	elseif AddClass == "hunter" then	
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "dwarf", "nightelf", "race" }			
		else 			
			Races = { "orc", "tauren", "troll", "race" }		
		end		
		
		RaceItr = RaceItr + 1	
		if RaceItr >= table.getn(Races) + 1 then RaceItr = 1 end
		AddRace = Races[RaceItr]
		
		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		
		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "tauren" then RaceStackHide() tauren:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end

	elseif AddClass == "rogue" then		
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "dwarf", "nightelf", "gnome", "race" }			
		else 			
			Races = { "orc", "undead", "troll", "race" }		
		end
		
		RaceItr = RaceItr + 1	
		if RaceItr >= table.getn(Races) + 1 then RaceItr = 1 end
		AddRace = Races[RaceItr]	

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		if Races[RaceItr] == "gnome" then RaceStackHide() gnome:Show() end
		
		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end

	elseif AddClass == "priest" then
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "dwarf", "nightelf", "race" }			
		else 			
			Races = { "undead", "troll", "race" }		
		end	
		
		RaceItr = RaceItr + 1	
		if RaceItr >= table.getn(Races) + 1 then RaceItr = 1 end
		AddRace = Races[RaceItr]
		
		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		
		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end

	elseif AddClass == "shaman" then			
		Races = { "orc", "tauren", "troll", "race" }
		
		RaceItr = RaceItr + 1	
		if RaceItr >= table.getn(Races) + 1 then RaceItr = 1 end
		AddRace = Races[RaceItr]

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "tauren" then RaceStackHide() tauren:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end

	elseif AddClass == "mage" then	
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "gnome", "race" }			
		else 			
			Races = { "undead", "troll", "race" }		
		end	
		
		RaceItr = RaceItr + 1	
		if RaceItr >= table.getn(Races) + 1 then RaceItr = 1 end
		AddRace = Races[RaceItr]

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "gnome" then RaceStackHide() gnome:Show() end

		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end	

	elseif AddClass == "warlock" then			
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "gnome", "race" }			
		else 			
			Races = { "orc", "undead", "race" }		
		end
		
		RaceItr = RaceItr + 1	
		if RaceItr >= table.getn(Races) + 1 then RaceItr = 1 end
		AddRace = Races[RaceItr]		

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "gnome" then RaceStackHide() gnome:Show() end
		
		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end		

	elseif AddClass == "druid" then		
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "nightelf" }			
		else 			
			Races = { "tauren" }		
		end

		AddRace = Races[RaceItr]		
	
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		
		if Races[RaceItr] == "tauren" then RaceStackHide() tauren:Show() end
	end
end

function SetRaceSUB()
	if RaceItr == 0 then RaceItr = 5 end

	if AddClass == "warrior" then	
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "dwarf", "nightelf", "gnome", "race" }			
		else 			
			Races = { "orc", "undead", "tauren", "troll", "race" }		
		end
		
		RaceItr = RaceItr - 1	
		if RaceItr <= 0 then RaceItr = table.getn(Races) end
		AddRace = Races[RaceItr]
		
		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		if Races[RaceItr] == "gnome" then RaceStackHide() gnome:Show() end
		
		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end
		if Races[RaceItr] == "tauren" then RaceStackHide() tauren:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end	

	elseif AddClass == "paladin" then		
		Races = { "human", "dwarf", "race" }
		
		RaceItr = RaceItr - 1	
		if RaceItr <= 0 then RaceItr = table.getn(Races) end
		AddRace = Races[RaceItr]
		
		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end

	elseif AddClass == "hunter" then	
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "dwarf", "nightelf", "race" }			
		else 			
			Races = { "orc", "tauren", "troll", "race" }		
		end		
		
		RaceItr = RaceItr - 1	
		if RaceItr <= 0 then RaceItr = table.getn(Races) end
		AddRace = Races[RaceItr]

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		
		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "tauren" then RaceStackHide() tauren:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end

	elseif AddClass == "rogue" then		
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "dwarf", "nightelf", "gnome", "race" }			
		else 			
			Races = { "orc", "undead", "troll", "race" }		
		end
		
		RaceItr = RaceItr - 1	
		if RaceItr <= 0 then RaceItr = table.getn(Races) end
		AddRace = Races[RaceItr]	

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		if Races[RaceItr] == "gnome" then RaceStackHide() gnome:Show() end
		
		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end

	elseif AddClass == "priest" then
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "dwarf", "nightelf", "race" }			
		else 			
			Races = { "undead", "troll", "race" }		
		end	
		
		RaceItr = RaceItr - 1	
		if RaceItr <= 0 then RaceItr = table.getn(Races) end
		AddRace = Races[RaceItr]
		
		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "dwarf" then RaceStackHide() dwarf:Show() end
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		
		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end

	elseif AddClass == "shaman" then		
		Races = { "orc", "tauren", "troll", "race" }
		
		RaceItr = RaceItr - 1	
		if RaceItr <= 0 then RaceItr = table.getn(Races) end
		AddRace = Races[RaceItr]

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "tauren" then RaceStackHide() tauren:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end

	elseif AddClass == "mage" then	
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "gnome", "race" }			
		else 			
			Races = { "undead", "troll", "race" }		
		end	
		
		RaceItr = RaceItr - 1	
		if RaceItr <= 0 then RaceItr = table.getn(Races) end
		AddRace = Races[RaceItr]

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "gnome" then RaceStackHide() gnome:Show() end

		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end
		if Races[RaceItr] == "troll" then RaceStackHide() troll:Show() end	

	elseif AddClass == "warlock" then		
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "human", "gnome", "race" }			
		else 			
			Races = { "orc", "undead", "race" }		
		end
		
		RaceItr = RaceItr - 1	
		if RaceItr <= 0 then RaceItr = table.getn(Races) end
		AddRace = Races[RaceItr]		

		if Races[RaceItr] == "race" then RaceStackHide() race:Show() end

		if Races[RaceItr] == "human" then RaceStackHide() human:Show() end
		if Races[RaceItr] == "gnome" then RaceStackHide() gnome:Show() end
		
		if Races[RaceItr] == "orc" then RaceStackHide() orc:Show() end
		if Races[RaceItr] == "undead" then RaceStackHide() undead:Show() end		

	elseif AddClass == "druid" then	
		if UnitFactionGroup("player") == "Alliance" then 
			Races = { "nightelf" }			
		else 			
			Races = { "tauren" }		
		end

		AddRace = Races[RaceItr]		
	
		if Races[RaceItr] == "nightelf" then RaceStackHide() nightelf:Show() end
		
		if Races[RaceItr] == "tauren" then RaceStackHide() tauren:Show() end			
	end
end





AddRole = "tank"
RoleItr = 1
function SetRoleADD()
	if AddClass == "warrior" then
		Roles = { "tank", "meleedps" }
		
		RoleItr = RoleItr + 1	
		if RoleItr >= table.getn(Roles) + 1 then RoleItr = 1 end
		AddRole = Roles[RoleItr]

		if Roles[RoleItr] == "tank" then roleButton:SetText("Tank") end
		if Roles[RoleItr] == "meleedps" then roleButton:SetText("Melee") end

	elseif AddClass == "paladin" then
		Roles = { "tank", "healer", "meleedps" }
		
		RoleItr = RoleItr + 1	
		if RoleItr >= table.getn(Roles) + 1 then RoleItr = 1 end
		AddRole = Roles[RoleItr]

		if Roles[RoleItr] == "tank" then roleButton:SetText("Tank") end
		if Roles[RoleItr] == "healer" then roleButton:SetText("Healer") end
		if Roles[RoleItr] == "meleedps" then roleButton:SetText("Meleedps") end		
	
	elseif AddClass == "hunter" then		
		Roles = { "rangedps" }
		
		AddRole = "rangedps"

		if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end

	elseif AddClass == "rogue" then
		Roles = { "meleedps" }

		AddRole = "meleedps" 

		if Roles[RoleItr] == "meleedps" then roleButton:SetText("Meleedps") end
		
	elseif AddClass == "priest" then
		Roles = { "healer", "rangedps" }

		RoleItr = RoleItr + 1	
		if RoleItr >= table.getn(Roles) + 1 then RoleItr = 1 end
		AddRole = Roles[RoleItr]

		if Roles[RoleItr] == "healer" then roleButton:SetText("Healer") end
		if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end

	elseif AddClass == "shaman" then
		Roles = { "tank", "healer", "meleedps", "rangedps" }

		RoleItr = RoleItr + 1	
		if RoleItr >= table.getn(Roles) + 1 then RoleItr = 1 end
		AddRole = Roles[RoleItr]

		if Roles[RoleItr] == "tank" then roleButton:SetText("Tank") end
		if Roles[RoleItr] == "healer" then roleButton:SetText("Healer") end
		if Roles[RoleItr] == "meleedps" then roleButton:SetText("Meleedps") end
		if Roles[RoleItr] == "rangedps" then roleButton:SetText("Rangedps") end
		
	elseif AddClass == "mage" then	
		Roles = { "rangedps" }
		
		AddRole = "rangedps"

		if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end	
		
	elseif AddClass == "warlock" then
		Roles = { "rangedps" }
		
		AddRole = "rangedps"

		if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end
	
	elseif AddClass == "druid" then	
		Roles = { "tank", "healer", "meleedps", "rangedps" }
		
		RoleItr = RoleItr + 1	
		if RoleItr >= table.getn(Roles) + 1 then RoleItr = 1 end
		AddRole = Roles[RoleItr]
	
		if Roles[RoleItr] == "tank" then roleButton:SetText("Tank") end
		if Roles[RoleItr] == "healer" then roleButton:SetText("Healer") end
		if Roles[RoleItr] == "meleedps" then roleButton:SetText("MeleeDps") end		
		if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end
	end
	if PCP_UpdateSpawnOptionButtons then PCP_UpdateSpawnOptionButtons() end
end
function RoleUpdate()
	if Classes[ClassItr] == "warrior" then 
		
		roleButton:SetText("Tank")
		AddRole = "tank"
	end
	if Classes[ClassItr] == "paladin" then 
		
		roleButton:SetText("Tank")
		AddRole = "tank"
	end
	if Classes[ClassItr] == "hunter" then 
		
		roleButton:SetText("Rangedps")
		AddRole = "rangedps"
	end
	if Classes[ClassItr] == "rogue" then 
		
		roleButton:SetText("Meleedps")
		AddRole = "meleedps"
	end
	if Classes[ClassItr] == "priest" then 
		
		roleButton:SetText("Healer")
		AddRole = "healer"
	end
	if Classes[ClassItr] == "shaman" then 
		
		roleButton:SetText("Tank")
		AddRole = "tank"
	end
	if Classes[ClassItr] == "mage" then 
		
		roleButton:SetText("RangeDps")
		AddRole = "rangedps" 
	end
	if Classes[ClassItr] == "warlock" then 
		
		roleButton:SetText("RangeDps")
		AddRole = "rangedps"	
	end
	if Classes[ClassItr] == "druid" then 
		
		roleButton:SetText("Tank")
		AddRole = "tank"
	end	
end
function SetRoleSUB()
    if AddClass == "warrior" then
        Roles = { "tank", "meleedps" }

        RoleItr = RoleItr - 1
        if RoleItr <= 0 then RoleItr = table.getn(Roles) end
        AddRole = Roles[RoleItr]

        if Roles[RoleItr] == "tank" then roleButton:SetText("Tank") end
        if Roles[RoleItr] == "meleedps" then roleButton:SetText("MeleeDps") end

    elseif AddClass == "paladin" then
        Roles = { "tank", "healer", "meleedps" }

        RoleItr = RoleItr - 1
        if RoleItr <= 0 then RoleItr = table.getn(Roles) end
        AddRole = Roles[RoleItr]

        if Roles[RoleItr] == "tank" then roleButton:SetText("Tank") end
        if Roles[RoleItr] == "healer" then roleButton:SetText("Healer") end
        if Roles[RoleItr] == "meleedps" then roleButton:SetText("MeleeDps") end

    elseif AddClass == "hunter" then
        Roles = { "rangedps" }

        AddRole = "rangedps"

        if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end

    elseif AddClass == "rogue" then
        Roles = { "meleedps" }

        AddRole = "meleedps"

        if Roles[RoleItr] == "meleedps" then roleButton:SetText("MeleeDps") end

    elseif AddClass == "priest" then
        Roles = { "healer", "rangedps" }

        RoleItr = RoleItr - 1
        if RoleItr <= 0 then RoleItr = table.getn(Roles) end
        AddRole = Roles[RoleItr]

        if Roles[RoleItr] == "healer" then roleButton:SetText("Healer") end
        if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end

    elseif AddClass == "shaman" then
        Roles = { "tank", "healer", "meleedps", "rangedps" }

        RoleItr = RoleItr - 1
        if RoleItr <= 0 then RoleItr = table.getn(Roles) end
        AddRole = Roles[RoleItr]

        if Roles[RoleItr] == "tank" then roleButton:SetText("Tank") end
        if Roles[RoleItr] == "healer" then roleButton:SetText("Healer") end
        if Roles[RoleItr] == "meleedps" then roleButton:SetText("MeleeDps") end
        if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end

    elseif AddClass == "mage" then
        Roles = { "rangedps" }

        AddRole = "rangedps"

        if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end

    elseif AddClass == "warlock" then
        Roles = { "rangedps" }

        AddRole = "rangedps"

        if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end

    elseif AddClass == "druid" then
        Roles = { "tank", "healer", "meleedps", "rangedps" }

        RoleItr = RoleItr - 1
        if RoleItr <= 0 then RoleItr = table.getn(Roles) end
        AddRole = Roles[RoleItr]

        if Roles[RoleItr] == "tank" then roleButton:SetText("Tank") end
        if Roles[RoleItr] == "healer" then roleButton:SetText("Healer") end
        if Roles[RoleItr] == "meleedps" then roleButton:SetText("MeleeDps") end
        if Roles[RoleItr] == "rangedps" then roleButton:SetText("RangeDps") end
    end
    if PCP_UpdateSpawnOptionButtons then PCP_UpdateSpawnOptionButtons() end
end

function GenderStackHide()
	gender:Hide()
	male:Hide()
	female:Hide()
end

AddGender = "gender"
GenderItr = 1
function SetGenderADD()
		Genders = { "gender", "male", "female" }
		
		GenderItr = GenderItr + 1	
		if GenderItr >= table.getn(Genders) + 1 then GenderItr = 1 end
		AddGender = Genders[GenderItr]

		if Genders[GenderItr] == "gender" then GenderStackHide() gender:Show() end
		if Genders[GenderItr] == "male" then GenderStackHide() male:Show() end
		if Genders[GenderItr] == "female" then GenderStackHide() female:Show() end
end

function SetGenderSUB()
		Genders = { "gender", "male", "female" }

		GenderItr = GenderItr - 1	
		if GenderItr <= 0 then GenderItr = table.getn(Genders) end
		AddGender = Genders[GenderItr]

		if Genders[GenderItr] == "gender" then GenderStackHide() gender:Show() end
		if Genders[GenderItr] == "male" then GenderStackHide() male:Show() end
		if Genders[GenderItr] == "female" then GenderStackHide() female:Show() end
end

AddBG = "warsong"
BGItr = 1
function BGStackHide()
	warsong:Hide()
	arathi:Hide()
	alterac:Hide()
end

function SetBGADD()
	BGS = { "warsong", "arathi", "alterac" }
	
	BGItr = BGItr + 1	
	if BGItr == 4 then BGItr = 1 end
	AddBG = BGS[BGItr]
	
	if BGS[BGItr] == "warsong" then BGStackHide() warsong:Show() end
	if BGS[BGItr] == "arathi" then BGStackHide() arathi:Show() end
	if BGS[BGItr] == "alterac" then BGStackHide() alterac:Show() end
end

function SetBGSUB()
	BGS = { "warsong", "arathi", "alterac" }
	
	BGItr = BGItr - 1	
	if BGItr == 0 then BGItr = 3 end
	AddBG = BGS[BGItr]
	
	if BGS[BGItr] == "warsong" then BGStackHide() warsong:Show() end
	if BGS[BGItr] == "arathi" then BGStackHide() arathi:Show() end
	if BGS[BGItr] == "alterac" then BGStackHide() alterac:Show() end
end

function PCP_GetPartyBotSpawnExtraArgs()
    local extra = ""
    if AddClass == "paladin" and PCPPaladinBlessings then
        if PCP_NormalizePaladinBlessingForRotation then PCP_NormalizePaladinBlessingForRotation() end
        local blessing = PCPPaladinBlessings[PCPPaladinBlessingItr or 1]
        if blessing and blessing ~= "Default" then extra = " " .. blessing end
    elseif AddClass == "shaman" and PCPShamanTotems and PCPShamanTotemItr then
        local order = { "air", "earth", "fire", "water" }
        for i = 1, 4 do
            local key = order[i]
            local list = PCPShamanTotems[key]
            local val = list and list[PCPShamanTotemItr[key] or 1]
            if val then extra = extra .. " " .. val end
        end
    end
    return extra
end

function PCP_BuildPartyBotAddAdvancedCommand()
    local cmd = CMD_PARTYBOT_ADD .. AddClass .. " " .. AddRole
    if AddGender and AddGender ~= "" and AddGender ~= "gender" then
        cmd = cmd .. " " .. AddGender
    end
    cmd = cmd .. PCP_GetPartyBotSpawnExtraArgs()
    return cmd
end

function PCP_AdvancePaladinBlessingRotation()
    if AddClass ~= "paladin" then return end
    if not PCP_IsPaladinBuffRotationEnabled or not PCP_IsPaladinBuffRotationEnabled() then return end
    if not PCPPaladinBlessings then return end
    PCP_NormalizePaladinBlessingForRotation()
    PCPPaladinBlessingItr = (PCPPaladinBlessingItr or 2) + 1
    if PCPPaladinBlessingItr > table.getn(PCPPaladinBlessings) then PCPPaladinBlessingItr = 2 end
    if PCP_UpdateSpawnConfigButtonText then PCP_UpdateSpawnConfigButtonText() end
    if PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown() and PCP_RefreshSpawnOptionsFrame then PCP_RefreshSpawnOptionsFrame() end
end

function SubPartyBotAddAdvanced(self)
    DispatchCommand(PCP_BuildPartyBotAddAdvancedCommand())
    PCP_AdvancePaladinBlessingRotation()
end


function SubPartyBotAdd(self, arg)
	DispatchCommand(CMD_PARTYBOT_ADD .. arg)
end

function Brackets()
	if UnitLevel("player") >= 10 and UnitLevel("player") <= 19 then return math.random(10,19) 
	elseif UnitLevel("player") >= 20 and UnitLevel("player") <= 29 then return math.random(20,29)
	elseif UnitLevel("player") >= 30 and UnitLevel("player") <= 39 then return math.random(30,39)
	elseif UnitLevel("player") >= 40 and UnitLevel("player") <= 49 then return math.random(40,49)
	elseif UnitLevel("player") >= 50 and UnitLevel("player") <= 59 then return math.random(50,59)
	elseif UnitLevel("player") == 60 then return 60
	else return math.random(10,19)
	end
end

function SubBattleBotAdd(self, arg1, arg2)
	RanBotLevel = Brackets()
	DispatchCommand(CMD_BATTLEBOT_ADD .. arg1 .. " " .. arg2 .. " " .. RanBotLevel)
end

function SubBattleGo(self, arg1)
	DispatchCommand(CMD_BATTLEGROUND_GO .. arg1)
end

function CloseFrame()
	PCPFrameRemake:Hide();
end

function OpenFrame()
	DEFAULT_CHAT_FRAME:AddMessage("Loading PartyBot Control Panel...");
	DEFAULT_CHAT_FRAME:RegisterEvent('CHAT_MSG_SYSTEM')
	PCPFrameRemake:Show();
end


SLASH_PCP1 = '/PCP'
function SlashCmdList.PCP(msg, editbox) 
    if (msg == "" or msg == "cp") then
        if (PCPFrameRemake:IsVisible()) then
            PCPFrameRemake:Hide()
        else
			PCPFrameRemake:Show()
        end
    end
end

function ShowToggle()
	if (PCPFrameRemake:IsVisible()) then
		PCPFrameRemake:Hide()
	else
		PCPFrameRemake:Show()
	end
end

function JoinWorld()
	id, name = GetChannelName(1)
	if (name ~= "World") then
		JoinChannelByName("World", nil, ChatFrame1:GetID(), 0)
	end
end


if LoadSavedSettings then
    LoadSavedSettings()
end
if PCP_EnableButtonSectionDragHooks then
    PCP_EnableButtonSectionDragHooks()
end
if ApplyPCPSectionLayout then
    ApplyPCPSectionLayout(PCPFrameRemake)
end
if PCP_UpdateFreeBackdropMode then
    PCP_UpdateFreeBackdropMode()
end
