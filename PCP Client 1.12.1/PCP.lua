local version, build, date, tocversion = GetBuildInfo()

local PCP_ADDON_NAME = "PCP"
local PCP_VERSION_PREFIX = "PCPRemakeVersion"
local PCP_VERSION = "3.0.0"
local PCP_VA = "3"



if not string.gmatch and string.gfind then
    string.gmatch = string.gfind
end








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



function PCP_RunSlashOrChatLine(line)
    if not line or line == "" then return end

    local first = string.sub(line, 1, 1)
    if first == "/" then
        local editBox = ChatFrameEditBox or ChatFrame1EditBox or (DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.editBox)
        if editBox and ChatEdit_SendText then
            editBox:SetText(line)
            ChatEdit_SendText(editBox)
        elseif ChatFrame_OpenChat and ChatEdit_SendText then
            ChatFrame_OpenChat(line)
            editBox = ChatFrameEditBox or ChatFrame1EditBox or (DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.editBox)
            if editBox then ChatEdit_SendText(editBox) end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cffff4444[PCP]|r Could not run slash command: " .. line)
        end
    else
        SendChatMessage(line, GetChatChannel())
    end
end

function PCP_RunCustomMacroText(commandText)
    if not commandText or commandText == "" then return end

    if macroMode then
        DispatchCommand(commandText)
        return
    end

    local text = string.gsub(commandText, "\r\n", "\n")
    text = string.gsub(text, "\r", "\n")

    for line in string.gmatch(text .. "\n", "([^\n]*)\n") do
        line = string.gsub(line or "", "^%s+", "")
        line = string.gsub(line or "", "%s+$", "")
        if line ~= "" then
            PCP_RunSlashOrChatLine(line)
        end
    end
end

function PCP_DispatchCustomFrameCommand(commandText)
    if not commandText or commandText == "" then return end
    PCP_RunCustomMacroText(commandText)
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

local function PCP_RegisterThemedButton(button)
    if not button then return end
    for i = 1, table.getn(allButtons) do
        if allButtons[i] == button then return end
    end
    table.insert(allButtons, button)
end

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
versionText:SetText("Version " .. PCP_VERSION) 
versionText:SetTextColor(1, 1, 1, 1) 
PCP_VersionText = versionText

function PCP_NewVersion(newVersionDetected)
    if not PCP_VersionText then return end
    if newVersionDetected then
        PCP_VersionText:SetText("You are running: " .. PCP_VERSION .. " - Update available: " .. newVersionDetected)
    else
        PCP_VersionText:SetText("Version " .. PCP_VERSION)
    end
end

local versionClickButton = CreateFrame("Button", "PCPVersionClickButton", settingsFrame)
versionClickButton:SetPoint("TOPLEFT", versionText, "TOPLEFT", -4, 2)
versionClickButton:SetPoint("BOTTOMRIGHT", versionText, "BOTTOMRIGHT", 4, -2)
versionClickButton:EnableMouse(true)
versionClickButton:RegisterForClicks("LeftButtonUp")
versionClickButton:SetScript("OnClick", function()
    if PCP_ShowUpdateVersionPopup then
        PCP_ShowUpdateVersionPopup()
    end
end)
versionClickButton:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this or versionClickButton, "ANCHOR_TOPLEFT")
    GameTooltip:SetText("Click to show update info.")
    GameTooltip:Show()
end)
versionClickButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)


local dropdownMenu

local ClickBlockerFrame = CreateFrame("Frame", "ClickBlockerFrame", UIParent)
ClickBlockerFrame:SetAllPoints(UIParent) 
ClickBlockerFrame:EnableMouse(true) 
ClickBlockerFrame:SetFrameStrata("DIALOG")  
ClickBlockerFrame:SetFrameLevel(1)  
ClickBlockerFrame:Hide() 

local function PCP_UpdateClickBlockerVisibility()
    if (settingsFrame and settingsFrame:IsShown()) or (PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown()) then
        ClickBlockerFrame:Show()
    else
        ClickBlockerFrame:Hide()
    end
end

ClickBlockerFrame:SetScript("OnMouseDown", function()
    if dropdownMenu then dropdownMenu:Hide() end
    if settingsFrame then settingsFrame:Hide() end
    if PCPSpawnOptionsFrame then PCPSpawnOptionsFrame:Hide() end
    ClickBlockerFrame:Hide()
end)


local function ToggleSettingsFrame()
    if settingsFrame:IsShown() then
        if dropdownMenu then dropdownMenu:Hide() end
        settingsFrame:Hide()
        if PCP_UpdateClickBlockerVisibility then PCP_UpdateClickBlockerVisibility() end
    else
        if settingsFrame.SetFrameStrata then settingsFrame:SetFrameStrata("FULLSCREEN_DIALOG") end
        if settingsFrame.SetFrameLevel then settingsFrame:SetFrameLevel(200) end
        if settingsFrame.SetToplevel then settingsFrame:SetToplevel(true) end
        settingsFrame:Show()
        if PCP_UpdateSettingsFrameSize then PCP_UpdateSettingsFrameSize() end
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
dropdownButton:SetHeight(24)
dropdownButton:SetPoint("CENTER", dropdownFrame, "CENTER")
dropdownButton:SetText("Select Color")
PCP_RegisterThemedButton(dropdownButton)

local dropdownArrow = dropdownButton:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
dropdownArrow:SetPoint("RIGHT", dropdownButton, "RIGHT", -8, 0)
dropdownArrow:SetText("v")


dropdownMenu = CreateFrame("Frame", "PCPColorDropdownMenu", dropdownFrame)
dropdownMenu:SetWidth(180)
dropdownMenu:SetHeight(360)
dropdownMenu:SetPoint("TOP", dropdownButton, "BOTTOM", 0, -5)
dropdownMenu:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
dropdownMenu:SetBackdropColor(0, 0, 0, 0.92)
dropdownMenu:SetFrameStrata("FULLSCREEN_DIALOG")
dropdownMenu:SetFrameLevel((settingsFrame:GetFrameLevel() or 200) + 20)
dropdownMenu:EnableMouse(true)
dropdownMenu:Hide()


dropdownButton:SetScript("OnClick", function()
    if dropdownMenu:IsShown() then
        dropdownMenu:Hide()
    else
        dropdownMenu:SetFrameLevel((settingsFrame:GetFrameLevel() or 200) + 20)
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
    PCP_RegisterThemedButton(optionButton)
end

dropdownMenu:SetHeight((table.getn(colorOptions) * 22) + 10)


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
PCP_RegisterThemedButton(resetSectionLayoutButton)

local sectionVisibilityButton = CreateFrame("Button", "PCPSectionVisibilityButton", settingsFrame, "UIPanelButtonTemplate")
sectionVisibilityButton:SetWidth(150)
sectionVisibilityButton:SetHeight(22)
sectionVisibilityButton:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 25, -285)
sectionVisibilityButton:SetText("Visible sections")
sectionVisibilityButton:SetScript("OnClick", function()
    if PCP_ShowSectionOptions then PCP_ShowSectionOptions(true) end
    if PCPSectionOptionsFrame then
        if PCPSectionOptionsFrame.SetFrameStrata then PCPSectionOptionsFrame:SetFrameStrata("FULLSCREEN_DIALOG") end
        if PCPSectionOptionsFrame.SetFrameLevel then PCPSectionOptionsFrame:SetFrameLevel(220) end
        if PCPSectionOptionsFrame.SetToplevel then PCPSectionOptionsFrame:SetToplevel(true) end
        PCPSectionOptionsFrame:Show()
        if PCPSectionOptionsFrame.Raise then PCPSectionOptionsFrame:Raise() end
    end
end)
PCP_RegisterThemedButton(sectionVisibilityButton)



    
    if not math.mod then function math.mod(a, b) return a - math.floor(a / b) * b end end

    function PCP_CustomRoundNumber(value, fallback)
        local n = tonumber(value)
        if not n then return fallback end
        return math.floor(n + 0.5)
    end

    

    PCP_CustomFrameRuntime = {}
    PCP_CustomFrameEditorState = { selectedFrame = 1, selectedButton = nil, editingButtonIndex = nil, iconTarget = nil }

    function PCP_EnsureCustomFramesStorage()
        if not PCP_Settings then PCP_Settings = {} end
        if not PCP_Settings.customFrames then PCP_Settings.customFrames = {} end
        return PCP_Settings.customFrames
    end

    function PCP_AreCustomFramesLocked()
        return PCP_Settings and PCP_Settings.customFramesLocked == true
    end

    function PCP_ShouldShowCustomFrameNames()
        return PCP_Settings and PCP_Settings.showCustomFrameNames == true
    end

    function PCP_UpdateCustomFrameNameMode()
        local showNames = PCP_ShouldShowCustomFrameNames and PCP_ShouldShowCustomFrameNames()
        if PCPCustomFramesEditorFrame and PCPCustomFramesEditorFrame.showFrameNameCheck then
            PCPCustomFramesEditorFrame.showFrameNameCheck:SetChecked(showNames and true or false)
        end
        if PCP_UpdateAllCustomFrameVisibility then
            PCP_UpdateAllCustomFrameVisibility()
        end
    end

    function PCP_UpdateCustomFramesLockMode()
        local locked = PCP_AreCustomFramesLocked and PCP_AreCustomFramesLocked()
        if PCPCustomFramesEditorFrame and PCPCustomFramesEditorFrame.lockFramesCheck then
            PCPCustomFramesEditorFrame.lockFramesCheck:SetChecked(locked and true or false)
        end
        for _, f in pairs(PCP_CustomFrameRuntime or {}) do
            if f and f.resizeGrip then
                if locked then f.resizeGrip:Hide() else f.resizeGrip:Show() end
            end
        end
    end

    function PCP_IsCustomFramesEditorOpen()
        return PCPCustomFramesEditorFrame and PCPCustomFramesEditorFrame:IsShown()
    end

    function PCP_UpdateCustomFrameChrome(index)
        local f = PCP_CustomFrameRuntime and PCP_CustomFrameRuntime[index]
        if not f then return end

        local showNames = PCP_ShouldShowCustomFrameNames and PCP_ShouldShowCustomFrameNames()
        if f.title then
            f.title:ClearAllPoints()
            f.title:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 4, 2)
            f.title:SetWidth((f:GetWidth() or 120) + 40)
            f.title:SetJustifyH("LEFT")
            if showNames then f.title:Show() else f.title:Hide() end
        end
        if f.close then f.close:Hide() end
        if f.resizeGrip then
            if PCP_AreCustomFramesLocked and PCP_AreCustomFramesLocked() then f.resizeGrip:Hide() else f.resizeGrip:Show() end
        end

        if PCP_CustomFrameLayout then PCP_CustomFrameLayout(index) end
    end

    function PCP_ShouldShowCustomFrame(index)
        local data = PCP_EnsureCustomFramesStorage()[index]
        if not data then return false end
        if data.alwaysShow == true then return true end
        if PCP_IsCustomFramesEditorOpen and PCP_IsCustomFramesEditorOpen() then return true end
        return PCPFrameRemake and PCPFrameRemake:IsShown()
    end

    function PCP_UpdateCustomFrameVisibility(index)
        local f = PCP_CustomFrameRuntime and PCP_CustomFrameRuntime[index]
        if not f then return end
        if PCP_UpdateCustomFrameChrome then PCP_UpdateCustomFrameChrome(index) end
        if PCP_ShouldShowCustomFrame and PCP_ShouldShowCustomFrame(index) then
            f:Show()
        else
            f:Hide()
        end
    end

    function PCP_UpdateAllCustomFrameVisibility()
        if not PCP_CustomFrameRuntime then return end
        for index, f in pairs(PCP_CustomFrameRuntime) do
            if f then PCP_UpdateCustomFrameVisibility(index) end
        end
    end

    function PCP_GetCustomIconList()
        if PCP_IconList and table.getn(PCP_IconList) > 0 then return PCP_IconList end
        return {
            { name = "Question Mark", path = "Interface\\Icons\\INV_Misc_QuestionMark" },
            { name = "Attack", path = "Interface\\Icons\\Ability_Warrior_Charge" },
            { name = "Follow", path = "Interface\\Icons\\Ability_Hunter_Misdirection" },
            { name = "Stop", path = "Interface\\Icons\\Spell_Shadow_DeathScream" },
        }
    end

    function PCP_ApplyThemeToCustomFrame(targetFrame)
        if not targetFrame then return end
        local backdropEnabled = true
        if targetFrame._pcpIsCustomRuntime and PCP_Settings and PCP_Settings.backdropEnabled ~= nil then
            backdropEnabled = PCP_Settings.backdropEnabled == true
        end
        if targetFrame._pcpIsCustomRuntime and not backdropEnabled then
            if targetFrame.SetBackdrop then targetFrame:SetBackdrop(nil) end
        else
            local style = PCP_GetBackdropStyle and PCP_GetBackdropStyle() or nil
            if style and targetFrame.SetBackdrop then
                targetFrame:SetBackdrop({
                    bgFile = style.bgFile,
                    edgeFile = style.edgeFile,
                    tile = style.tile,
                    tileSize = style.tileSize,
                    edgeSize = style.edgeSize,
                    insets = style.insets,
                })
                if style.bgColor then targetFrame:SetBackdropColor(style.bgColor[1], style.bgColor[2], style.bgColor[3], style.bgColor[4]) end
                if style.borderColor then targetFrame:SetBackdropBorderColor(style.borderColor[1], style.borderColor[2], style.borderColor[3], style.borderColor[4]) end
            end
        end
        local theme = PCP_GetThemeColors and PCP_GetThemeColors() or nil
        if theme and theme.text and targetFrame._pcpThemeTexts then
            for _, fs in ipairs(targetFrame._pcpThemeTexts) do
                if fs and fs.SetTextColor then fs:SetTextColor(theme.text[1], theme.text[2], theme.text[3], theme.text[4]) end
            end
        end
    end


    function PCP_ApplySolidBlackCustomEditorBackground(targetFrame)
        if not targetFrame or not targetFrame.SetBackdrop then return end
        targetFrame:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        targetFrame:SetBackdropColor(0, 0, 0, 1)
        targetFrame:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)
    end

    function PCP_CreateCustomScrollVisuals(parent, owner, prefix, x, y, height, getOffset, setOffset, getMaxOffset)
        if not parent or not owner then return end
        local track = CreateFrame("Frame", nil, parent)
        track:SetWidth(14)
        track:SetHeight(height or 350)
        track:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        track:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true,
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        track:SetBackdropColor(0, 0, 0, 0.95)
        track:SetBackdropBorderColor(0.45, 0.45, 0.45, 1)

        local up = CreateFrame("Button", nil, track)
        up:SetWidth(12)
        up:SetHeight(14)
        up:SetPoint("TOP", track, "TOP", 0, -2)
        up:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
        up:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
        up:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
        up:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight", "ADD")

        local down = CreateFrame("Button", nil, track)
        down:SetWidth(12)
        down:SetHeight(14)
        down:SetPoint("BOTTOM", track, "BOTTOM", 0, 2)
        down:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
        down:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
        down:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
        down:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight", "ADD")

        local thumb = CreateFrame("Frame", nil, track)
        thumb:SetWidth(8)
        thumb:SetHeight(34)
        thumb:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
        thumb:SetBackdropColor(0.75, 0.75, 0.75, 0.85)

        local function scrollBy(delta)
            local maxOffset = getMaxOffset and getMaxOffset() or 0
            local offset = getOffset and getOffset() or 0
            offset = offset + delta
            if offset < 0 then offset = 0 end
            if offset > maxOffset then offset = maxOffset end
            if setOffset then setOffset(offset) end
            if PCP_RefreshCustomFramesEditor then PCP_RefreshCustomFramesEditor() end
        end

        up:SetScript("OnClick", function() scrollBy(-1) end)
        down:SetScript("OnClick", function() scrollBy(1) end)

        owner[prefix .. "Track"] = track
        owner[prefix .. "ScrollUp"] = up
        owner[prefix .. "ScrollDown"] = down
        owner[prefix .. "Thumb"] = thumb
    end

    function PCP_UpdateCustomScrollVisual(owner, prefix, offset, maxOffset)
        if not owner then return end
        local track = owner[prefix .. "Track"]
        local thumb = owner[prefix .. "Thumb"]
        local up = owner[prefix .. "ScrollUp"]
        local down = owner[prefix .. "ScrollDown"]
        if not track or not thumb then return end
        maxOffset = maxOffset or 0
        offset = offset or 0
        if maxOffset <= 0 then
            thumb:SetHeight((track:GetHeight() or 100) - 36)
            thumb:ClearAllPoints()
            thumb:SetPoint("TOP", track, "TOP", 0, -18)
            if up then up:Disable() end
            if down then down:Disable() end
            return
        end
        if up then if offset > 0 then up:Enable() else up:Disable() end end
        if down then if offset < maxOffset then down:Enable() else down:Disable() end end
        local trackH = track:GetHeight() or 100
        local movable = trackH - 70
        if movable < 10 then movable = 10 end
        local y = -18 - math.floor((offset / maxOffset) * movable)
        thumb:SetHeight(32)
        thumb:ClearAllPoints()
        thumb:SetPoint("TOP", track, "TOP", 0, y)
    end

    function PCP_CustomRegisterText(frameObj, fs)
        if not frameObj or not fs then return end
        if not frameObj._pcpThemeTexts then frameObj._pcpThemeTexts = {} end
        table.insert(frameObj._pcpThemeTexts, fs)
    end

    function PCP_SetCustomTooltip(widget, title, line1, line2, line3)
        if not widget then return end
        widget:SetScript("OnEnter", function(self) self = self or this
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(title or "Help", 1, 0.82, 0, 1, true)
            if line1 and line1 ~= "" then GameTooltip:AddLine(line1, 1, 1, 1, true) end
            if line2 and line2 ~= "" then GameTooltip:AddLine(line2, 0.75, 0.75, 0.75, true) end
            if line3 and line3 ~= "" then GameTooltip:AddLine(line3, 0.75, 0.75, 0.75, true) end
            GameTooltip:Show()
        end)
        widget:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    function PCP_SaveCustomFramePosition(index)
        local data = PCP_EnsureCustomFramesStorage()[index]
        local runtime = PCP_CustomFrameRuntime[index]
        if not data or not runtime then return end
        data.width = PCP_CustomRoundNumber(runtime:GetWidth(), data.width or 260)
        data.height = PCP_CustomRoundNumber(runtime:GetHeight(), data.height or 120)
        local point, relativeTo, relativePoint, x, y = runtime:GetPoint()
        data.point = point or "CENTER"
        data.relativePoint = relativePoint or "CENTER"
        data.x = x or 0
        data.y = y or 0
    end

    function PCP_RunCustomMacroText(commandText)
        if not commandText or commandText == "" then return end

        
        if macroMode then
            DispatchCommand(commandText)
            return
        end

        local editBox = ChatFrame1EditBox or (DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.editBox)

        local function runSlashLine(line)
            if not line or line == "" then return end
            if editBox and ChatEdit_SendText then
                editBox:SetText(line)
                ChatEdit_SendText(editBox)
            elseif ChatFrame_OpenChat and ChatEdit_SendText then
                ChatFrame_OpenChat(line)
                local openedEditBox = ChatFrame1EditBox or (DEFAULT_CHAT_FRAME and DEFAULT_CHAT_FRAME.editBox)
                if openedEditBox then ChatEdit_SendText(openedEditBox) end
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff4444[PCP]|r Could not run slash command: " .. line)
            end
        end

        local function runChatLine(line)
            if not line or line == "" then return end
            local chatChannel = GetChatChannel()
            SendChatMessage(line, chatChannel)
        end

        local text = string.gsub(commandText, "\r\n", "\n")
        text = string.gsub(text, "\r", "\n")

        for line in string.gmatch(text .. "\n", "([^\n]*)\n") do
            line = string.gsub(line or "", "^%s+", "")
            line = string.gsub(line or "", "%s+$", "")

            if line ~= "" then
                local first = string.sub(line, 1, 1)
                if first == "/" then
                    runSlashLine(line)
                else
                    
                    runChatLine(line)
                end
            end
        end
    end

    function PCP_DispatchCustomFrameCommand(commandText)
        if not commandText or commandText == "" then return end
        PCP_RunCustomMacroText(commandText)
    end

    function PCP_CustomFrameLayout(index)
        local data = PCP_EnsureCustomFramesStorage()[index]
        local f = PCP_CustomFrameRuntime[index]
        if not data or not f or not f.buttons then return end

        local buttons = data.buttons or {}
        local count = table.getn(buttons)
        if count < 1 then return end

        local allIcons = true
        for i = 1, count do
            if not buttons[i] or buttons[i].type ~= "icon" then
                allIcons = false
                break
            end
        end

        
        
        local padding = allIcons and 3 or 8
        local spacing = data.spacing or 6
        if allIcons and spacing > 3 then spacing = 3 end

        local frameW = f:GetWidth() or data.width or 260
        local frameH = f:GetHeight() or data.height or 120
        
        
        local startY = -padding
        local usableW = frameW - (padding * 2)
        local usableH = frameH - math.abs(startY) - padding
        if usableW < 10 then usableW = 10 end
        if usableH < 10 then usableH = 10 end

        
        
        
        local bestCols = 1
        local bestRows = count
        local bestScore = -999999
        local frameRatio = usableW / usableH
        for testCols = 1, count do
            local testRows = math.ceil(count / testCols)
            local testCellW = math.floor((usableW - ((testCols - 1) * spacing)) / testCols)
            local testCellH = math.floor((usableH - ((testRows - 1) * spacing)) / testRows)
            if testCellW > 0 and testCellH > 0 then
                local score = math.min(testCellW, testCellH)
                if allIcons then
                    local gridRatio = testCols / testRows
                    local ratioPenalty = math.abs(gridRatio - frameRatio) * 4
                    score = score - ratioPenalty
                end
                if score > bestScore then
                    bestScore = score
                    bestCols = testCols
                    bestRows = testRows
                end
            end
        end

        local cols = bestCols
        local rows = bestRows
        local cellW = math.floor((usableW - ((cols - 1) * spacing)) / cols)
        local cellH = math.floor((usableH - ((rows - 1) * spacing)) / rows)
        if cellW < 8 then cellW = 8 end
        if cellH < 8 then cellH = 8 end

        
        
        
        local compactIcons = false
        local compactStartX = padding
        local compactStartY = startY
        if allIcons then
            local compactSize = math.min(cellW, cellH)
            if compactSize < 8 then compactSize = 8 end
            cellW = compactSize
            cellH = compactSize
            compactIcons = true

            local packedW = (cols * cellW) + ((cols - 1) * spacing)
            local packedH = (rows * cellH) + ((rows - 1) * spacing)
            if usableW > packedW then
                compactStartX = padding + math.floor((usableW - packedW) / 2)
            end
            if usableH > packedH then
                compactStartY = startY - math.floor((usableH - packedH) / 2)
            end
        end

        for i, btn in ipairs(f.buttons) do
            local bdata = buttons[i] or {}
            local col = math.mod(i - 1, cols)
            local row = math.floor((i - 1) / cols)
            local isIcon = (bdata.type == "icon")
            local buttonW = cellW
            local buttonH = cellH
            local iconSize = math.min(cellW, cellH)

            if isIcon then
                
                if iconSize < 8 then iconSize = 8 end
                buttonW = iconSize
                buttonH = iconSize
            else
                
                if buttonW < 16 then buttonW = 16 end
                if buttonH < 14 then buttonH = 14 end
            end

            local x
            local y
            if compactIcons then
                x = compactStartX + (col * (cellW + spacing))
                y = compactStartY - (row * (cellH + spacing))
            else
                x = padding + (col * (cellW + spacing))
                if buttonW < cellW then
                    x = x + math.floor((cellW - buttonW) / 2)
                end
                y = startY - (row * (cellH + spacing))
                if buttonH < cellH then
                    y = y - math.floor((cellH - buttonH) / 2)
                end
            end

            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
            btn:SetWidth(buttonW); btn:SetHeight(buttonH)
            if btn.iconTexture then
                local texSize = iconSize - 4
                if texSize < 6 then texSize = 6 end
                if texSize > buttonW - 4 then texSize = buttonW - 4 end
                if texSize > buttonH - 4 then texSize = buttonH - 4 end
                if texSize < 6 then texSize = 6 end
                btn.iconTexture:SetWidth(texSize)
                btn.iconTexture:SetHeight(texSize)
            end
        end
    end

    function PCP_RenderCustomFrame(index)
        local data = PCP_EnsureCustomFramesStorage()[index]
        if not data then return end

        local f = PCP_CustomFrameRuntime[index]
        if not f then
            f = CreateFrame("Frame", "PCPCustomFrame" .. index, UIParent)
            PCP_CustomFrameRuntime[index] = f
            f._pcpIsCustomRuntime = true
            f:SetMovable(true)
            f:SetResizable(true)
            f:SetMinResize(24, 24)
            f:EnableMouse(true)
            f:RegisterForDrag("LeftButton")
            f:SetScript("OnDragStart", function(self) self = self or this
                if PCP_AreCustomFramesLocked and PCP_AreCustomFramesLocked() then return end
                self:StartMoving()
            end)
            f:SetScript("OnDragStop", function(self) self = self or this
                self:StopMovingOrSizing()
                PCP_SaveCustomFramePosition(index)
            end)
            f:SetScript("OnSizeChanged", function(self) self = self or this
                PCP_SaveCustomFramePosition(index)
                PCP_CustomFrameLayout(index)
            end)

            f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            f.title:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 4, 2)
            f.title:SetJustifyH("LEFT")
            PCP_CustomRegisterText(f, f.title)

            f.close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
            f.close:SetWidth(18); f.close:SetHeight(18)
            f.close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -5)
            f.close:SetText("X")
            f.close:SetScript("OnClick", function() f:Hide() end)
            f.close:Hide()
            PCP_RegisterThemedButton(f.close)

            f.resizeGrip = CreateFrame("Button", nil, f)
            f.resizeGrip:SetWidth(18); f.resizeGrip:SetHeight(18)
            f.resizeGrip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, -4)
            
            
            f.resizeGrip.tex = f.resizeGrip:CreateTexture(nil, "ARTWORK")
            f.resizeGrip.tex:SetAllPoints(f.resizeGrip)
            f.resizeGrip.tex:SetTexture("Interface\\AddOns\\PCP\\img\\ResizeGrip.tga")
            f.resizeGrip.tex:SetVertexColor(1, 1, 1, 1)
            f.resizeGrip:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
            f.resizeGrip:SetScript("OnMouseDown", function()
                if PCP_AreCustomFramesLocked and PCP_AreCustomFramesLocked() then return end
                f:StartSizing("BOTTOMRIGHT")
            end)
            f.resizeGrip:SetScript("OnMouseUp", function()
                if PCP_AreCustomFramesLocked and PCP_AreCustomFramesLocked() then return end
                f:StopMovingOrSizing()
                PCP_SaveCustomFramePosition(index)
                PCP_CustomFrameLayout(index)
            end)
        end

        f:SetWidth(data.width or 260); f:SetHeight(data.height or 120)
        f:ClearAllPoints()
        f:SetPoint(data.point or "CENTER", UIParent, data.relativePoint or "CENTER", data.x or 0, data.y or 0)
        f.title:SetText(data.name or ("Custom Frame " .. index))
        f.title:ClearAllPoints()
        f.title:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 4, 2)
        f.title:SetWidth((f:GetWidth() or data.width or 120) + 40)
        f.title:SetJustifyH("LEFT")
        if PCP_ShouldShowCustomFrameNames and PCP_ShouldShowCustomFrameNames() then f.title:Show() else f.title:Hide() end
        if f.close then f.close:Hide() end
        if f.resizeGrip then
            if PCP_AreCustomFramesLocked and PCP_AreCustomFramesLocked() then f.resizeGrip:Hide() else f.resizeGrip:Show() end
        end
        PCP_ApplyThemeToCustomFrame(f)

        if f.buttons then
            for _, btn in ipairs(f.buttons) do btn:Hide() end
        else
            f.buttons = {}
        end

        local buttons = data.buttons or {}
        for i, bdata in ipairs(buttons) do
            local btn = f.buttons[i]
            if not btn then
                btn = CreateFrame("Button", nil, f)
                f.buttons[i] = btn
                btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                btn.text:SetPoint("CENTER", btn, "CENTER", 0, 0)
                btn:SetFontString(btn.text)
                PCP_RegisterThemedButton(btn)
            end
            btn._pcpCustomFrameIndex = index
            btn._pcpCustomButtonIndex = i
            btn:SetScript("OnClick", function(self) self = self or this
                local cd = PCP_EnsureCustomFramesStorage()[self._pcpCustomFrameIndex]
                local bd = cd and cd.buttons and cd.buttons[self._pcpCustomButtonIndex]
                if bd then PCP_DispatchCustomFrameCommand(bd.command) end
            end)
            btn:SetScript("OnEnter", function(self) self = self or this
                local cd = PCP_EnsureCustomFramesStorage()[self._pcpCustomFrameIndex]
                local bd = cd and cd.buttons and cd.buttons[self._pcpCustomButtonIndex]
                if bd then
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetText(bd.tooltip ~= "" and bd.tooltip or (bd.label or bd.command or "Custom button"), 1, 1, 1, 1, true)
                    if bd.command and bd.command ~= "" then GameTooltip:AddLine(bd.command, 0.7, 0.7, 0.7, true) end
                    GameTooltip:Show()
                end
            end)
            btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

            if bdata.type == "icon" then
                btn:SetText("")
                if not btn.iconTexture then
                    btn.iconTexture = btn:CreateTexture(nil, "OVERLAY")
                    btn.iconTexture:SetPoint("CENTER", btn, "CENTER", 0, 0)
                    btn.iconTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                end
                btn.iconTexture:SetTexture(bdata.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
                btn.iconTexture:Show()
            else
                if btn.iconTexture then btn.iconTexture:Hide() end
                btn:SetText(bdata.label or "Button")
            end
            btn:Show()
        end

        PCP_CustomFrameLayout(index)
        
        
        if toggleButtonAppearance then toggleButtonAppearance(true, defaultColor) end
        if PCP_RefreshCustomFramesTheme then PCP_RefreshCustomFramesTheme() end
        if PCP_UpdateCustomFrameVisibility then
            PCP_UpdateCustomFrameVisibility(index)
        else
            f:Show()
        end
    end

    function PCP_RebuildCustomFrames()
        local list = PCP_EnsureCustomFramesStorage()
        for i = 1, table.getn(list) do
            if list[i] then PCP_RenderCustomFrame(i) end
        end
        for i, f in pairs(PCP_CustomFrameRuntime) do
            if i > table.getn(list) and f then f:Hide() end
        end
    end

    function PCP_NewCustomFrame()
        local list = PCP_EnsureCustomFramesStorage()
        local n = table.getn(list) + 1
        list[n] = {
            name = "Custom Frame " .. n,
            width = 260,
            height = 120,
            spacing = 6,
            alwaysShow = false,
            point = "CENTER",
            relativePoint = "CENTER",
            x = 0,
            y = 0,
            buttons = {},
        }
        PCP_CustomFrameEditorState.selectedFrame = n
        PCP_CustomFrameEditorState.frameScrollOffset = math.max(0, n - 10)
        PCP_CustomFrameEditorState.buttonScrollOffset = 0
        PCP_RenderCustomFrame(n)
        if PCP_ShowCustomButtonEditor then PCP_ShowCustomButtonEditor(nil) end
        PCP_RefreshCustomFramesEditor()
    end

    function PCP_DeleteCustomFrame(index)
        local list = PCP_EnsureCustomFramesStorage()
        if not index or not list[index] then return end

        
        
        for _, runtimeFrame in pairs(PCP_CustomFrameRuntime or {}) do
            if runtimeFrame and runtimeFrame.Hide then runtimeFrame:Hide() end
        end

        table.remove(list, index)
        PCP_CustomFrameRuntime = {}

        if table.getn(list) < 1 then
            PCP_CustomFrameEditorState.selectedFrame = 1
        elseif index > table.getn(list) then
            PCP_CustomFrameEditorState.selectedFrame = table.getn(list)
        else
            PCP_CustomFrameEditorState.selectedFrame = index
        end
        PCP_CustomFrameEditorState.selectedButton = nil
        PCP_CustomFrameEditorState.frameScrollOffset = 0
        PCP_CustomFrameEditorState.buttonScrollOffset = 0

        PCP_RebuildCustomFrames()
        PCP_RefreshCustomFramesEditor()
    end

    function PCP_MoveCustomButton(frameIndex, buttonIndex, delta)
        local data = PCP_EnsureCustomFramesStorage()[frameIndex]
        if not data or not data.buttons then return end
        local newIndex = buttonIndex + delta
        if newIndex < 1 or newIndex > table.getn(data.buttons) then return end
        data.buttons[buttonIndex], data.buttons[newIndex] = data.buttons[newIndex], data.buttons[buttonIndex]
        PCP_CustomFrameEditorState.selectedButton = newIndex
        PCP_RenderCustomFrame(frameIndex)
        PCP_RefreshCustomFramesEditor()
    end

    function PCP_DeleteCustomButton(frameIndex, buttonIndex)
        local data = PCP_EnsureCustomFramesStorage()[frameIndex]
        if data and data.buttons and data.buttons[buttonIndex] then
            table.remove(data.buttons, buttonIndex)
        end
        PCP_CustomFrameEditorState.selectedButton = nil
        PCP_CustomFrameEditorState.buttonScrollOffset = 0
        PCP_RenderCustomFrame(frameIndex)
        PCP_RefreshCustomFramesEditor()
    end

    function PCP_CreateLabeledEditBox(parent, label, x, y, w, h, multiLine)
        local fs = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        fs:SetText(label)
        PCP_CustomRegisterText(parent, fs)

        if multiLine then
            local boxW = w or 160
            local boxH = h or 80

            local bg = CreateFrame("Frame", nil, parent)
            bg:SetWidth(boxW); bg:SetHeight(boxH)
            bg:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y - 15)
            bg:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                tile = true, tileSize = 16, edgeSize = 10,
                insets = { left = 3, right = 3, top = 3, bottom = 3 },
            })
            bg:SetBackdropColor(0, 0, 0, 0.85)
            bg:SetBackdropBorderColor(0.55, 0.55, 0.55, 0.9)

            local sf = CreateFrame("ScrollFrame", nil, bg)
            sf:SetPoint("TOPLEFT", bg, "TOPLEFT", 6, -6)
            sf:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -6, 6)
            sf:EnableMouse(true)
            if sf.EnableMouseWheel then sf:EnableMouseWheel(true) end
            sf:SetScript("OnMouseWheel", function(self, delta) self = self or this; delta = delta or arg1;
                local current = self:GetVerticalScroll() or 0
                local maxScroll = self:GetVerticalScrollRange() or 0
                local nextScroll = current - ((delta or 0) * 20)
                if nextScroll < 0 then nextScroll = 0 end
                if nextScroll > maxScroll then nextScroll = maxScroll end
                self:SetVerticalScroll(nextScroll)
            end)

            local eb = CreateFrame("EditBox", nil, sf)
            eb:SetMultiLine(true)
            eb:SetAutoFocus(false)
            eb:SetMaxLetters(0)
            eb:SetWidth(boxW - 18)
            eb:SetHeight(1000)
            eb:SetFontObject(GameFontHighlightSmall)
            eb:SetJustifyH("LEFT")
            if eb.SetJustifyV then eb:SetJustifyV("TOP") end
            if eb.SetTextInsets then eb:SetTextInsets(0, 0, 0, 0) end
            eb:SetScript("OnEscapePressed", function(self) self = self or this; self:ClearFocus() end)
            eb:SetScript("OnCursorChanged", function(self, x, y, width, height) self = self or this
                if sf and sf.UpdateScrollChildRect then sf:UpdateScrollChildRect() end
            end)
            eb:SetScript("OnTextChanged", function(self) self = self or this
                if self:GetHeight() < 1000 then self:SetHeight(1000) end
                if sf and sf.UpdateScrollChildRect then sf:UpdateScrollChildRect() end
            end)
            sf:SetScrollChild(eb)
            bg:SetScript("OnMouseDown", function() eb:SetFocus() end)

            eb._pcpLabel = fs
            eb._pcpBoxBg = bg
            eb._pcpScrollFrame = sf
            eb._pcpTooltipOwner = bg
            return eb
        end

        
        
        
        local boxW = w or 160
        local boxH = h or 22
        local bg = CreateFrame("Frame", nil, parent)
        bg:SetWidth(boxW); bg:SetHeight(boxH)
        bg:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y - 15)
        bg:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        bg:SetBackdropColor(0, 0, 0, 0.85)
        bg:SetBackdropBorderColor(0.55, 0.55, 0.55, 0.9)

        local eb = CreateFrame("EditBox", nil, bg)
        eb:SetWidth(boxW - 10); eb:SetHeight(boxH - 4)
        eb:SetPoint("LEFT", bg, "LEFT", 5, 0)
        eb:SetAutoFocus(false)
        eb:SetFontObject(GameFontHighlightSmall)
        eb:SetJustifyH("LEFT")
        if eb.SetTextInsets then eb:SetTextInsets(0, 0, 0, 0) end
        eb:SetScript("OnEscapePressed", function(self) self = self or this; self:ClearFocus() end)
        bg:SetScript("OnMouseDown", function() eb:SetFocus() end)

        eb._pcpLabel = fs
        eb._pcpBoxBg = bg
        eb._pcpTooltipOwner = bg
        return eb
    end

    function PCP_SetEditBoxText(box, text)
        if not box then return end
        box:SetText(text or "")
        
        
        if box.SetCursorPosition then
            box:SetCursorPosition(0)
        end
    end

    function PCP_GetEditBoxText(box)
        if not box then return "" end
        return box:GetText() or ""
    end

    function PCP_ShowCustomButtonEditor(buttonIndex)
        PCP_EnsureCustomFramesEditor()
        local frameIndex = PCP_CustomFrameEditorState.selectedFrame or 1
        local data = PCP_EnsureCustomFramesStorage()[frameIndex]
        if not data then return end
        local bd = buttonIndex and data.buttons and data.buttons[buttonIndex] or { type = "text", label = "New", icon = "Interface\\Icons\\INV_Misc_QuestionMark", command = "", tooltip = "" }
        PCP_CustomFrameEditorState.editingButtonIndex = buttonIndex
        local f = PCPCustomButtonEditorFrame
        if f.title then f.title:SetText(buttonIndex and "Custom Button" or "New Custom Button") end
        PCP_SetEditBoxText(f.labelBox, bd.label or "")
        PCP_SetEditBoxText(f.commandBox, bd.command or "")
        PCP_SetEditBoxText(f.tooltipBox, bd.tooltip or "")
        PCP_SetEditBoxText(f.iconBox, bd.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        f.typeText:SetText("Type: " .. ((bd.type == "icon") and "Icon" or "Text"))
        f._pcpButtonType = bd.type or "text"
        if PCP_UpdateCustomButtonEditorTypeVisual then PCP_UpdateCustomButtonEditorTypeVisual() end
        f:Show()
        PCP_ApplySolidBlackCustomEditorBackground(f)
    end

    function PCP_SaveCustomButtonEditor()
        local frameIndex = PCP_CustomFrameEditorState.selectedFrame or 1
        local data = PCP_EnsureCustomFramesStorage()[frameIndex]
        if not data then return end
        if not data.buttons then data.buttons = {} end
        local idx = PCP_CustomFrameEditorState.editingButtonIndex or (table.getn(data.buttons) + 1)
        data.buttons[idx] = {
            type = PCPCustomButtonEditorFrame._pcpButtonType or "text",
            label = PCP_GetEditBoxText(PCPCustomButtonEditorFrame.labelBox),
            command = PCP_GetEditBoxText(PCPCustomButtonEditorFrame.commandBox),
            tooltip = PCP_GetEditBoxText(PCPCustomButtonEditorFrame.tooltipBox),
            icon = PCP_GetEditBoxText(PCPCustomButtonEditorFrame.iconBox),
        }
        PCP_CustomFrameEditorState.selectedButton = idx
        PCP_CustomFrameEditorState.buttonScrollOffset = math.max(0, idx - 7)
        PCP_RenderCustomFrame(frameIndex)
        PCP_RefreshCustomFramesEditor()
    end

    function PCP_UpdateCustomButtonEditorTypeVisual()
        local f = PCPCustomButtonEditorFrame
        if not f then return end
        local isIcon = (f._pcpButtonType == "icon")
        local iconPath = PCP_GetEditBoxText(f.iconBox)
        if iconPath == "" then iconPath = "Interface\\Icons\\INV_Misc_QuestionMark" end

        if f.typeText then f.typeText:SetText("Type: " .. (isIcon and "Icon" or "Text")) end

        
        
        if f.iconBox then f.iconBox:Hide() end
        if f.iconBox and f.iconBox._pcpBoxBg then f.iconBox._pcpBoxBg:Hide() end
        if f.iconBox and f.iconBox._pcpLabel then f.iconBox._pcpLabel:Hide() end
        if f.pickIcon then f.pickIcon:Hide() end

        if f.iconLabel then
            if isIcon then f.iconLabel:Show() else f.iconLabel:Hide() end
        end
        if f.iconSelect then
            if f.iconSelect.tex then f.iconSelect.tex:SetTexture(iconPath) end
            if isIcon then f.iconSelect:Show() else f.iconSelect:Hide() end
        end
    end

    function PCP_EnsureCustomButtonEditor()
        if PCPCustomButtonEditorFrame then
            if PCPCustomFramesEditorFrame and PCPCustomButtonEditorFrame:GetParent() ~= PCPCustomFramesEditorFrame then
                PCPCustomButtonEditorFrame:SetParent(PCPCustomFramesEditorFrame)
                PCPCustomButtonEditorFrame:ClearAllPoints()
                PCPCustomButtonEditorFrame:SetPoint("TOPLEFT", PCPCustomFramesEditorFrame, "TOPLEFT", 690, -85)
                PCPCustomButtonEditorFrame:SetWidth(330); PCPCustomButtonEditorFrame:SetHeight(330)
                PCPCustomButtonEditorFrame:SetFrameLevel(PCPCustomFramesEditorFrame:GetFrameLevel() + 5)
            end
            return
        end
        local parent = PCPCustomFramesEditorFrame or UIParent
        local f = CreateFrame("Frame", "PCPCustomButtonEditorFrame", parent)
        
        
        f:SetWidth(330); f:SetHeight(330)
        if parent == UIParent then
            f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            f:SetFrameStrata("FULLSCREEN_DIALOG")
            f:SetFrameLevel(230)
            f:EnableMouse(true)
            f:SetMovable(true)
            f:RegisterForDrag("LeftButton")
            f:SetScript("OnDragStart", function(self) self = self or this; self:StartMoving() end)
            f:SetScript("OnDragStop", function(self) self = self or this; self:StopMovingOrSizing() end)
            table.insert(UISpecialFrames, "PCPCustomButtonEditorFrame")
        else
            f:SetPoint("TOPLEFT", parent, "TOPLEFT", 690, -85)
            f:SetFrameLevel(parent:GetFrameLevel() + 5)
            f:EnableMouse(true)
        end
        f:Hide()
        PCP_ApplyThemeToCustomFrame(f)
        PCP_ApplySolidBlackCustomEditorBackground(f)

        f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        f.title:SetPoint("TOP", f, "TOP", 0, -12)
        f.title:SetText("Custom Button")
        PCP_CustomRegisterText(f, f.title)

        f.labelBox = PCP_CreateLabeledEditBox(f, "Label", 24, -42, 135)
        f.commandBox = PCP_CreateLabeledEditBox(f, "Command / Macro", 24, -88, 280, 96, true)
        f.tooltipBox = PCP_CreateLabeledEditBox(f, "Tooltip", 24, -204, 280)
        f.iconBox = PCP_CreateLabeledEditBox(f, "Icon", 24, -250, 1)
        PCP_SetCustomTooltip(f.labelBox._pcpTooltipOwner or f.labelBox, "Label", "Text shown on text buttons.", "Icon buttons can leave this empty.")
        PCP_SetCustomTooltip(f.commandBox._pcpTooltipOwner or f.commandBox, "Command / Macro", "Command sent when this button is clicked.", "Supports multiple lines when Macro Mode is enabled.")
        PCP_SetCustomTooltip(f.tooltipBox._pcpTooltipOwner or f.tooltipBox, "Tooltip", "Optional tooltip shown when hovering the custom button.", "If empty, the label or command is used instead.")

        f.iconLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.iconLabel:SetPoint("TOPLEFT", f, "TOPLEFT", 24, -250)
        f.iconLabel:SetText("Selected icon")
        PCP_CustomRegisterText(f, f.iconLabel)

        f.iconSelect = CreateFrame("Button", nil, f)
        f.iconSelect:SetWidth(42); f.iconSelect:SetHeight(42)
        f.iconSelect:SetPoint("TOPLEFT", f, "TOPLEFT", 24, -268)
        f.iconSelect:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        f.iconSelect.tex = f.iconSelect:CreateTexture(nil, "OVERLAY")
        f.iconSelect.tex:SetAllPoints(f.iconSelect)
        f.iconSelect.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        f.iconSelect:SetScript("OnClick", function()
            PCP_CustomFrameEditorState.iconTarget = f.iconBox
            PCP_ShowIconPicker()
        end)
        f.iconSelect:SetScript("OnEnter", function(self) self = self or this
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Click to pick icon", 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        f.iconSelect:SetScript("OnLeave", function() GameTooltip:Hide() end)

        f.typeText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.typeText:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -42)
        PCP_CustomRegisterText(f, f.typeText)

        f.typeToggle = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.typeToggle:SetWidth(90); f.typeToggle:SetHeight(22)
        f.typeToggle:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -60)
        f.typeToggle:SetText("Toggle type")
        PCP_SetCustomTooltip(f.typeToggle, "Toggle type", "Switch between a text button and an icon button.", "Icon buttons use the selected icon preview below.")
        f.typeToggle:SetScript("OnClick", function()
            f._pcpButtonType = (f._pcpButtonType == "icon") and "text" or "icon"
            if PCP_UpdateCustomButtonEditorTypeVisual then PCP_UpdateCustomButtonEditorTypeVisual() end
        end)
        PCP_RegisterThemedButton(f.typeToggle)

        f.pickIcon = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.pickIcon:SetWidth(70); f.pickIcon:SetHeight(22)
        f.pickIcon:SetPoint("LEFT", f.iconBox, "RIGHT", 8, 0)
        f.pickIcon:SetText("Pick")
        f.pickIcon:SetScript("OnClick", function()
            PCP_CustomFrameEditorState.iconTarget = f.iconBox
            PCP_ShowIconPicker()
        end)
        PCP_RegisterThemedButton(f.pickIcon)
        f.pickIcon:Hide()

        f.save = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.save:SetWidth(80); f.save:SetHeight(24)
        f.save:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 70, 14)
        f.save:SetText("Add/Save")
        PCP_SetCustomTooltip(f.save, "Save button", "Save this custom button to the selected frame.")
        f.save:SetScript("OnClick", PCP_SaveCustomButtonEditor)
        PCP_RegisterThemedButton(f.save)

        f.cancel = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.cancel:SetWidth(80); f.cancel:SetHeight(24)
        f.cancel:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -70, 14)
        f.cancel:SetText("Clear")
        PCP_SetCustomTooltip(f.cancel, "Clear editor", "Clear the button editor and start a new button.")
        f.cancel:SetScript("OnClick", function() PCP_ShowCustomButtonEditor(nil) end)
        PCP_RegisterThemedButton(f.cancel)
    end

    function PCP_EnsureIconPicker()
        if PCPIconPickerFrame then return end
        local f = CreateFrame("Frame", "PCPIconPickerFrame", UIParent)
        f:SetWidth(430); f:SetHeight(360)
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:SetFrameLevel(240)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(self) self = self or this; self:StartMoving() end)
        f:SetScript("OnDragStop", function(self) self = self or this; self:StopMovingOrSizing() end)
        f:Hide()
        PCP_ApplyThemeToCustomFrame(f)
        table.insert(UISpecialFrames, "PCPIconPickerFrame")

        f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        f.title:SetPoint("TOP", f, "TOP", 0, -12)
        f.title:SetText("Pick Icon")
        PCP_CustomRegisterText(f, f.title)

        f.search = PCP_CreateLabeledEditBox(f, "Search", 20, -38, 180)
        f.search:SetScript("OnTextChanged", function()
            f.iconScrollOffset = 0
            PCP_RefreshIconPicker()
        end)

        f.close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.close:SetWidth(70); f.close:SetHeight(22)
        f.close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -20, -35)
        f.close:SetText("Close")
        f.close:SetScript("OnClick", function() f:Hide() end)
        PCP_SetCustomTooltip(f.close, "Close", "Close the icon picker.")
        PCP_RegisterThemedButton(f.close)
        PCP_SetCustomTooltip(f.search._pcpTooltipOwner or f.search, "Search icons", "Filter icons by name or path.")

        f.icons = {}
        f.iconScrollOffset = 0
        f.iconCols = 9
        f.iconVisibleRows = 6
        local startX, startY = 20, -80
        local size, gap = 34, 8
        local cols = f.iconCols
        local visibleRows = f.iconVisibleRows
        for i = 1, cols * visibleRows do
            local btn = CreateFrame("Button", nil, f)
            btn:SetWidth(size); btn:SetHeight(size)
            local col = math.mod(i - 1, cols)
            local row = math.floor((i - 1) / cols)
            btn:SetPoint("TOPLEFT", f, "TOPLEFT", startX + col * (size + gap), startY - row * (size + gap))
            btn.tex = btn:CreateTexture(nil, "OVERLAY")
            btn.tex:SetAllPoints(btn)
            btn.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
            btn:SetScript("OnClick", function(self) self = self or this
                if PCP_CustomFrameEditorState.iconTarget and self._pcpIconPath then
                    PCP_CustomFrameEditorState.iconTarget:SetText(self._pcpIconPath)
                    if PCP_CustomFrameEditorState.iconTarget.SetCursorPosition then
                        PCP_CustomFrameEditorState.iconTarget:SetCursorPosition(0)
                    end
                    if PCP_UpdateCustomButtonEditorTypeVisual then PCP_UpdateCustomButtonEditorTypeVisual() end
                end
                f:Hide()
            end)
            btn:SetScript("OnEnter", function(self) self = self or this
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(self._pcpIconName or self._pcpIconPath or "Icon", 1, 1, 1, 1, true)
                if self._pcpIconPath then GameTooltip:AddLine(self._pcpIconPath, 0.7, 0.7, 0.7, true) end
                GameTooltip:Show()
            end)
            btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            if btn.EnableMouseWheel then btn:EnableMouseWheel(true) end
            btn:SetScript("OnMouseWheel", function(self, delta) self = self or this; delta = delta or arg1 or 0
                if PCP_SetIconPickerScrollOffset then
                    PCP_SetIconPickerScrollOffset((f.iconScrollOffset or 0) - delta)
                end
            end)
            f.icons[i] = btn
        end

        f.iconScrollTrack = CreateFrame("Frame", nil, f)
        f.iconScrollTrack:SetWidth(14); f.iconScrollTrack:SetHeight(250)
        f.iconScrollTrack:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, -80)
        f.iconScrollTrack:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true,
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        f.iconScrollTrack:SetBackdropColor(0, 0, 0, 0.95)
        f.iconScrollTrack:SetBackdropBorderColor(0.45, 0.45, 0.45, 1)
        if f.iconScrollTrack.EnableMouseWheel then f.iconScrollTrack:EnableMouseWheel(true) end
        f.iconScrollTrack:SetScript("OnMouseWheel", function(self, delta) self = self or this; delta = delta or arg1 or 0
            if PCP_SetIconPickerScrollOffset then
                PCP_SetIconPickerScrollOffset((f.iconScrollOffset or 0) - delta)
            end
        end)

        f.iconScrollUp = CreateFrame("Button", nil, f.iconScrollTrack)
        f.iconScrollUp:SetWidth(12); f.iconScrollUp:SetHeight(14)
        f.iconScrollUp:SetPoint("TOP", f.iconScrollTrack, "TOP", 0, -2)
        f.iconScrollUp:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
        f.iconScrollUp:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
        f.iconScrollUp:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
        f.iconScrollUp:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight", "ADD")
        f.iconScrollUp:SetScript("OnClick", function()
            if PCP_SetIconPickerScrollOffset then PCP_SetIconPickerScrollOffset((f.iconScrollOffset or 0) - 1) end
        end)

        f.iconScrollDown = CreateFrame("Button", nil, f.iconScrollTrack)
        f.iconScrollDown:SetWidth(12); f.iconScrollDown:SetHeight(14)
        f.iconScrollDown:SetPoint("BOTTOM", f.iconScrollTrack, "BOTTOM", 0, 2)
        f.iconScrollDown:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
        f.iconScrollDown:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
        f.iconScrollDown:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
        f.iconScrollDown:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight", "ADD")
        f.iconScrollDown:SetScript("OnClick", function()
            if PCP_SetIconPickerScrollOffset then PCP_SetIconPickerScrollOffset((f.iconScrollOffset or 0) + 1) end
        end)

        f.iconScrollThumb = CreateFrame("Frame", nil, f.iconScrollTrack)
        f.iconScrollThumb:SetWidth(8); f.iconScrollThumb:SetHeight(32)
        f.iconScrollThumb:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
        f.iconScrollThumb:SetBackdropColor(0.75, 0.75, 0.75, 0.85)

        f.iconCountText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.iconCountText:SetPoint("BOTTOM", f, "BOTTOM", 0, 12)
        f.iconCountText:SetText("")
        PCP_CustomRegisterText(f, f.iconCountText)

        if f.EnableMouseWheel then f:EnableMouseWheel(true) end
        f:SetScript("OnMouseWheel", function(self, delta) self = self or this; delta = delta or arg1 or 0
            if PCP_SetIconPickerScrollOffset then
                PCP_SetIconPickerScrollOffset((self.iconScrollOffset or 0) - delta)
            end
        end)
    end

    function PCP_GetIconPickerFilteredList()
        local filtered = {}
        if not PCPIconPickerFrame then return filtered end
        local list = PCP_GetCustomIconList()
        local q = string.lower(PCP_GetEditBoxText(PCPIconPickerFrame.search) or "")
        for i = 1, table.getn(list) do
            local item = list[i]
            local name = item.name or item[1] or "Icon"
            local path = item.path or item[2] or item[1]
            local hay = string.lower(name .. " " .. (path or ""))
            if q == "" or string.find(hay, q, 1, true) then
                table.insert(filtered, { name = name, path = path })
            end
        end
        return filtered
    end

    function PCP_GetIconPickerMaxOffset(matchCount)
        if not PCPIconPickerFrame then return 0 end
        local cols = PCPIconPickerFrame.iconCols or 9
        local visibleRows = PCPIconPickerFrame.iconVisibleRows or 6
        matchCount = matchCount or 0
        local totalRows = math.ceil(matchCount / cols)
        local maxOffset = totalRows - visibleRows
        if maxOffset < 0 then maxOffset = 0 end
        return maxOffset
    end

    function PCP_SetIconPickerScrollOffset(offset)
        if not PCPIconPickerFrame then return end
        local matches = PCPIconPickerFrame.iconFilteredCount or table.getn(PCP_GetIconPickerFilteredList())
        local maxOffset = PCP_GetIconPickerMaxOffset(matches)
        offset = offset or 0
        if offset < 0 then offset = 0 end
        if offset > maxOffset then offset = maxOffset end
        PCPIconPickerFrame.iconScrollOffset = offset
        PCP_RefreshIconPicker()
    end

    function PCP_UpdateIconPickerScrollVisual(maxOffset, matchCount)
        local f = PCPIconPickerFrame
        if not f or not f.iconScrollTrack then return end
        local offset = f.iconScrollOffset or 0
        maxOffset = maxOffset or 0
        matchCount = matchCount or 0

        if matchCount <= table.getn(f.icons or {}) then
            f.iconScrollTrack:Hide()
        else
            f.iconScrollTrack:Show()
        end

        if f.iconScrollUp then if offset > 0 then f.iconScrollUp:Enable() else f.iconScrollUp:Disable() end end
        if f.iconScrollDown then if offset < maxOffset then f.iconScrollDown:Enable() else f.iconScrollDown:Disable() end end

        if f.iconScrollThumb and f.iconScrollTrack then
            local trackH = f.iconScrollTrack:GetHeight() or 250
            local movable = trackH - 70
            if movable < 10 then movable = 10 end
            local y = -18
            if maxOffset > 0 then
                y = -18 - math.floor((offset / maxOffset) * movable)
            end
            f.iconScrollThumb:ClearAllPoints()
            f.iconScrollThumb:SetPoint("TOP", f.iconScrollTrack, "TOP", 0, y)
            f.iconScrollThumb:Show()
        end

        if f.iconCountText then
            if matchCount > 0 then
                local cols = f.iconCols or 9
                local visibleRows = f.iconVisibleRows or 6
                local first = (offset * cols) + 1
                local last = first + (cols * visibleRows) - 1
                if last > matchCount then last = matchCount end
                f.iconCountText:SetText(first .. "-" .. last .. " / " .. matchCount)
            else
                f.iconCountText:SetText("No icons found")
            end
        end
    end

    function PCP_RefreshIconPicker()
        if not PCPIconPickerFrame then return end
        local filtered = PCP_GetIconPickerFilteredList()
        local matchCount = table.getn(filtered)
        PCPIconPickerFrame.iconFilteredCount = matchCount

        local cols = PCPIconPickerFrame.iconCols or 9
        local visibleRows = PCPIconPickerFrame.iconVisibleRows or 6
        local pageSize = cols * visibleRows
        local maxOffset = PCP_GetIconPickerMaxOffset(matchCount)
        local offset = PCPIconPickerFrame.iconScrollOffset or 0
        if offset < 0 then offset = 0 end
        if offset > maxOffset then offset = maxOffset end
        PCPIconPickerFrame.iconScrollOffset = offset

        for i = 1, table.getn(PCPIconPickerFrame.icons) do
            PCPIconPickerFrame.icons[i]:Hide()
            PCPIconPickerFrame.icons[i]._pcpIconName = nil
            PCPIconPickerFrame.icons[i]._pcpIconPath = nil
        end

        local startIndex = (offset * cols) + 1
        local shown = 0
        for i = startIndex, matchCount do
            shown = shown + 1
            local btn = PCPIconPickerFrame.icons[shown]
            local item = filtered[i]
            if btn and item then
                btn._pcpIconName = item.name
                btn._pcpIconPath = item.path
                btn.tex:SetTexture(item.path)
                btn:Show()
            end
            if shown >= pageSize then break end
        end

        if PCP_UpdateIconPickerScrollVisual then
            PCP_UpdateIconPickerScrollVisual(maxOffset, matchCount)
        end
    end

    function PCP_ShowIconPicker()
        PCP_EnsureIconPicker()
        PCP_RefreshIconPicker()
        PCPIconPickerFrame:Show()
        PCP_ApplyThemeToCustomFrame(PCPIconPickerFrame)
    end

    function PCP_EnsureCustomFramesEditor()
        if PCPCustomFramesEditorFrame then return end

        local f = CreateFrame("Frame", "PCPCustomFramesEditorFrame", UIParent)
        f:SetWidth(1040); f:SetHeight(520)
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:SetFrameLevel(220)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(self) self = self or this; self:StartMoving() end)
        f:SetScript("OnDragStop", function(self) self = self or this; self:StopMovingOrSizing() end)
        f:Hide()
        f:SetScript("OnShow", function() if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end end)
        f:SetScript("OnHide", function() if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end end)
        PCP_ApplyThemeToCustomFrame(f)
        PCP_ApplySolidBlackCustomEditorBackground(f)
        table.insert(UISpecialFrames, "PCPCustomFramesEditorFrame")

        f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        f.title:SetPoint("TOP", f, "TOP", 0, -12)
        f.title:SetText("Custom Frames")
        PCP_CustomRegisterText(f, f.title)

        local function PCP_CreateCustomEditorPanel(name, x, y, w, h)
            local panel = CreateFrame("Frame", name, f)
            panel:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
            panel:SetWidth(w); panel:SetHeight(h)
            panel:SetFrameLevel(f:GetFrameLevel())
            panel:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                tile = true,
                tileSize = 16,
                edgeSize = 12,
                insets = { left = 3, right = 3, top = 3, bottom = 3 },
            })
            panel:SetBackdropColor(0.015, 0.015, 0.015, 0.96)
            panel:SetBackdropBorderColor(0.35, 0.35, 0.35, 0.90)
            return panel
        end

        f.frameListPanel = PCP_CreateCustomEditorPanel("PCPCustomFrameListPanel", 16, -78, 275, 410)
        f.frameSettingsPanel = PCP_CreateCustomEditorPanel("PCPCustomFrameSettingsPanel", 305, -78, 330, 410)
        f.buttonEditorPanel = PCP_CreateCustomEditorPanel("PCPCustomButtonEditorPanel", 650, -78, 370, 410)

        f.newFrame = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.newFrame:SetWidth(95); f.newFrame:SetHeight(22)
        f.newFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 20, -50)
        f.newFrame:SetText("New frame")
        f.newFrame:SetScript("OnClick", PCP_NewCustomFrame)
        PCP_SetCustomTooltip(f.newFrame, "New frame", "Create a new custom frame.", "Use it to group your own commands or macros.")
        PCP_RegisterThemedButton(f.newFrame)

        f.lockFramesCheck = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        f.lockFramesCheck:SetPoint("LEFT", f.newFrame, "RIGHT", 16, 0)
        f.lockFramesCheck:SetChecked(PCP_AreCustomFramesLocked and PCP_AreCustomFramesLocked())
        f.lockFramesCheck.text = f.lockFramesCheck:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.lockFramesCheck.text:SetPoint("LEFT", f.lockFramesCheck, "RIGHT", 4, 0)
        f.lockFramesCheck.text:SetText("Lock frames")
        PCP_CustomRegisterText(f, f.lockFramesCheck.text)
        PCP_SetCustomTooltip(f.lockFramesCheck, "Lock frames", "Locks all custom frames so they cannot be moved or resized.", "Turn this off when you want to edit their position or size.")
        f.lockFramesCheck:SetScript("OnClick", function(self) self = self or this
            if not PCP_Settings then PCP_Settings = {} end
            PCP_Settings.customFramesLocked = self:GetChecked() and true or false
            if PCP_UpdateCustomFramesLockMode then PCP_UpdateCustomFramesLockMode() end
        end)

        f.showFrameNameCheck = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        f.showFrameNameCheck:SetPoint("LEFT", f.lockFramesCheck.text, "RIGHT", 18, 0)
        f.showFrameNameCheck:SetChecked(PCP_ShouldShowCustomFrameNames and PCP_ShouldShowCustomFrameNames())
        f.showFrameNameCheck.text = f.showFrameNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.showFrameNameCheck.text:SetPoint("LEFT", f.showFrameNameCheck, "RIGHT", 4, 0)
        f.showFrameNameCheck.text:SetText("Show frame name")
        PCP_CustomRegisterText(f, f.showFrameNameCheck.text)
        PCP_SetCustomTooltip(f.showFrameNameCheck, "Show frame name", "Shows the name/title on each custom frame.", "When disabled, names stay hidden even while the Custom Frames editor is open.")
        f.showFrameNameCheck:SetScript("OnClick", function(self) self = self or this
            if not PCP_Settings then PCP_Settings = {} end
            PCP_Settings.showCustomFrameNames = self:GetChecked() and true or false
            if PCP_UpdateCustomFrameNameMode then PCP_UpdateCustomFrameNameMode() end
        end)

        
        f.deleteFrame = nil

        f.close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.close:SetWidth(70); f.close:SetHeight(22)
        f.close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -22, -28)
        f.close:SetText("Close")
        f.close:SetScript("OnClick", function() f:Hide() end)
        PCP_SetCustomTooltip(f.close, "Close", "Close the Custom Frames editor.")
        PCP_RegisterThemedButton(f.close)

        f.frameScroll = CreateFrame("ScrollFrame", nil, f)
        f.frameScroll:SetPoint("TOPLEFT", f, "TOPLEFT", 28, -112)
        f.frameScroll:SetWidth(220); f.frameScroll:SetHeight(290)
        if f.frameScroll.EnableMouseWheel then f.frameScroll:EnableMouseWheel(true) end
        f.frameScroll:SetScript("OnMouseWheel", function(self, delta) self = self or this; delta = delta or arg1;
            local list = PCP_EnsureCustomFramesStorage()
            local maxOffset = math.max(0, table.getn(list) - table.getn(f.frameRows))
            local offset = PCP_CustomFrameEditorState.frameScrollOffset or 0
            if delta < 0 then offset = offset + 1 else offset = offset - 1 end
            if offset < 0 then offset = 0 end
            if offset > maxOffset then offset = maxOffset end
            PCP_CustomFrameEditorState.frameScrollOffset = offset
            PCP_RefreshCustomFramesEditor()
        end)
        f.frameScrollChild = CreateFrame("Frame", nil, f.frameScroll)
        f.frameScrollChild:SetWidth(220); f.frameScrollChild:SetHeight(290)
        f.frameScroll:SetScrollChild(f.frameScrollChild)

        f.frameRows = {}
        for i = 1, 10 do
            local row = CreateFrame("Button", nil, f.frameScrollChild, "UIPanelButtonTemplate")
            row:SetWidth(184); row:SetHeight(24)
            row:SetPoint("TOPLEFT", f.frameScrollChild, "TOPLEFT", 0, -((i - 1) * 30))
            row._pcpRowIndex = i
            PCP_SetCustomTooltip(row, "Select frame", "Select this custom frame for editing.")
            row:SetScript("OnClick", function(self) self = self or this
                if not self._pcpFrameIndex then return end
                PCP_CustomFrameEditorState.selectedFrame = self._pcpFrameIndex
                PCP_CustomFrameEditorState.selectedButton = nil
                PCP_CustomFrameEditorState.buttonScrollOffset = 0
                if PCP_ShowCustomButtonEditor then PCP_ShowCustomButtonEditor(nil) end
                PCP_RefreshCustomFramesEditor()
            end)

            row.deleteButton = CreateFrame("Button", nil, f.frameScrollChild, "UIPanelButtonTemplate")
            row.deleteButton:SetWidth(22); row.deleteButton:SetHeight(22)
            row.deleteButton:SetPoint("LEFT", row, "RIGHT", 4, 0)
            row.deleteButton:SetText("X")
            PCP_SetCustomTooltip(row.deleteButton, "Delete frame", "Delete this custom frame and all buttons inside it.")
            row.deleteButton:SetScript("OnClick", function(self) self = self or this
                if self._pcpFrameIndex then
                    PCP_DeleteCustomFrame(self._pcpFrameIndex)
                end
            end)
            PCP_RegisterThemedButton(row.deleteButton)

            f.frameRows[i] = row
            PCP_RegisterThemedButton(row)
        end

        PCP_CreateCustomScrollVisuals(f, f, "frame", 252, -112, 290,
            function() return PCP_CustomFrameEditorState.frameScrollOffset or 0 end,
            function(v) PCP_CustomFrameEditorState.frameScrollOffset = v end,
            function() return math.max(0, table.getn(PCP_EnsureCustomFramesStorage()) - table.getn(f.frameRows)) end)

        f.frameNote = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.frameNote:SetPoint("TOPLEFT", f, "TOPLEFT", 28, -430)
        f.frameNote:SetWidth(235)
        f.frameNote:SetJustifyH("LEFT")
        f.frameNote:SetText("Note: Custom frames follow the main frame unless Always show is enabled.")
        PCP_CustomRegisterText(f, f.frameNote)

        f.frameSettingsTitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        f.frameSettingsTitle:SetPoint("TOPLEFT", f, "TOPLEFT", 325, -100)
        f.frameSettingsTitle:SetText("Frame settings")
        PCP_CustomRegisterText(f, f.frameSettingsTitle)

        f.nameBox = PCP_CreateLabeledEditBox(f, "Frame name", 325, -130, 260)
        f.widthBox = PCP_CreateLabeledEditBox(f, "Width", 325, -180, 80)
        f.heightBox = PCP_CreateLabeledEditBox(f, "Height", 425, -180, 80)
        f.spacingBox = PCP_CreateLabeledEditBox(f, "Spacing", 525, -180, 80)
        PCP_SetCustomTooltip(f.nameBox._pcpTooltipOwner or f.nameBox, "Frame name", "The name shown in the editor and on the frame while editing.")
        PCP_SetCustomTooltip(f.widthBox._pcpTooltipOwner or f.widthBox, "Width", "Custom frame width in pixels.", "Click Apply to update the frame.")
        PCP_SetCustomTooltip(f.heightBox._pcpTooltipOwner or f.heightBox, "Height", "Custom frame height in pixels.", "Click Apply to update the frame.")
        PCP_SetCustomTooltip(f.spacingBox._pcpTooltipOwner or f.spacingBox, "Spacing", "Space between buttons inside this custom frame.", "Higher value = more empty space between buttons.")

        f.alwaysShowCheck = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        f.alwaysShowCheck:SetPoint("TOPLEFT", f, "TOPLEFT", 325, -220)
        f.alwaysShowCheck.text = f.alwaysShowCheck:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.alwaysShowCheck.text:SetPoint("LEFT", f.alwaysShowCheck, "RIGHT", 4, 0)
        f.alwaysShowCheck.text:SetText("Always show")
        PCP_CustomRegisterText(f, f.alwaysShowCheck.text)
        f.alwaysShowCheck:SetScript("OnClick", function(self) self = self or this
            local data = PCP_EnsureCustomFramesStorage()[PCP_CustomFrameEditorState.selectedFrame or 1]
            if not data then return end
            data.alwaysShow = self:GetChecked() and true or false
            if PCP_UpdateCustomFrameVisibility then PCP_UpdateCustomFrameVisibility(PCP_CustomFrameEditorState.selectedFrame or 1) end
        end)
        PCP_SetCustomTooltip(f.alwaysShowCheck, "Always show", "Keep this custom frame visible even when the main PCP frame is hidden.")

        f.saveFrame = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.saveFrame:SetWidth(80); f.saveFrame:SetHeight(22)
        f.saveFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 525, -220)
        f.saveFrame:SetText("Apply")
        PCP_SetCustomTooltip(f.saveFrame, "Apply frame settings", "Save frame name, width, height, spacing and Always show.", "The frame preview updates immediately.")
        f.saveFrame:SetScript("OnClick", function()
            local data = PCP_EnsureCustomFramesStorage()[PCP_CustomFrameEditorState.selectedFrame or 1]
            if not data then return end
            data.name = PCP_GetEditBoxText(f.nameBox)
            data.width = PCP_CustomRoundNumber(PCP_GetEditBoxText(f.widthBox), data.width or 260)
            data.height = PCP_CustomRoundNumber(PCP_GetEditBoxText(f.heightBox), data.height or 120)
            data.spacing = PCP_CustomRoundNumber(PCP_GetEditBoxText(f.spacingBox), data.spacing or 6)
            data.alwaysShow = f.alwaysShowCheck and f.alwaysShowCheck:GetChecked() and true or false
            PCP_RenderCustomFrame(PCP_CustomFrameEditorState.selectedFrame or 1)
            PCP_RefreshCustomFramesEditor()
        end)
        PCP_RegisterThemedButton(f.saveFrame)

        f.addButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.addButton:SetWidth(90); f.addButton:SetHeight(22)
        f.buttonListTitle = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        f.buttonListTitle:SetPoint("TOPLEFT", f, "TOPLEFT", 325, -275)
        f.buttonListTitle:SetText("Buttons in this frame")
        PCP_CustomRegisterText(f, f.buttonListTitle)

        f.addButton:SetPoint("TOPLEFT", f, "TOPLEFT", 325, -303)
        f.addButton:SetText("Add button")
        PCP_SetCustomTooltip(f.addButton, "Add button", "Create a new button in the selected custom frame.")
        f.addButton:SetScript("OnClick", function() PCP_ShowCustomButtonEditor(nil) end)
        PCP_RegisterThemedButton(f.addButton)

        
        f.deleteButton = nil

        f.buttonScroll = CreateFrame("ScrollFrame", nil, f)
        f.buttonScroll:SetPoint("TOPLEFT", f, "TOPLEFT", 325, -335)
        f.buttonScroll:SetWidth(280); f.buttonScroll:SetHeight(145)
        if f.buttonScroll.EnableMouseWheel then f.buttonScroll:EnableMouseWheel(true) end
        f.buttonScroll:SetScript("OnMouseWheel", function(self, delta) self = self or this; delta = delta or arg1;
            local frameIndex = PCP_CustomFrameEditorState.selectedFrame or 1
            local data = PCP_EnsureCustomFramesStorage()[frameIndex]
            local count = data and data.buttons and table.getn(data.buttons) or 0
            local maxOffset = math.max(0, count - table.getn(f.buttonRows))
            local offset = PCP_CustomFrameEditorState.buttonScrollOffset or 0
            if delta < 0 then offset = offset + 1 else offset = offset - 1 end
            if offset < 0 then offset = 0 end
            if offset > maxOffset then offset = maxOffset end
            PCP_CustomFrameEditorState.buttonScrollOffset = offset
            PCP_RefreshCustomFramesEditor()
        end)
        f.buttonScrollChild = CreateFrame("Frame", nil, f.buttonScroll)
        f.buttonScrollChild:SetWidth(280); f.buttonScrollChild:SetHeight(145)
        f.buttonScroll:SetScrollChild(f.buttonScrollChild)

        f.buttonRows = {}
        for i = 1, 6 do
            local row = CreateFrame("Button", nil, f.buttonScrollChild, "UIPanelButtonTemplate")
            row:SetWidth(184); row:SetHeight(22)
            row:SetPoint("TOPLEFT", f.buttonScrollChild, "TOPLEFT", 0, -((i - 1) * 24))
            row._pcpButtonRowIndex = i
            row.iconTexture = row:CreateTexture(nil, "OVERLAY")
            row.iconTexture:SetWidth(18)
            row.iconTexture:SetHeight(18)
            row.iconTexture:SetPoint("LEFT", row, "LEFT", 30, 0)
            row.iconTexture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            row.iconTexture:Hide()
            row.indexText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            row.indexText:SetPoint("LEFT", row, "LEFT", 10, 0)
            row.indexText:SetWidth(35)
            row.indexText:SetJustifyH("LEFT")
            row.labelText = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            row.labelText:SetPoint("LEFT", row, "LEFT", 30, 0)
            row.labelText:SetWidth(120)
            row.labelText:SetJustifyH("LEFT")
            PCP_CustomRegisterText(f, row.indexText)
            PCP_CustomRegisterText(f, row.labelText)
            PCP_SetCustomTooltip(row, "Edit button", "Select this button and load its settings in the editor.")
            row:SetScript("OnClick", function(self) self = self or this
                if not self._pcpButtonIndex then return end
                PCP_CustomFrameEditorState.selectedButton = self._pcpButtonIndex
                PCP_ShowCustomButtonEditor(self._pcpButtonIndex)
                PCP_RefreshCustomFramesEditor()
            end)

            row.upButton = CreateFrame("Button", nil, f.buttonScrollChild, "UIPanelButtonTemplate")
            row.upButton:SetWidth(24); row.upButton:SetHeight(22)
            row.upButton:SetPoint("LEFT", row, "RIGHT", 5, 0)
            row.upButton:SetText("")
            row.upButton:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
            row.upButton:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
            row.upButton:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight", "ADD")
            row.upButton.iconTexture = row.upButton:CreateTexture(nil, "OVERLAY")
            row.upButton.iconTexture:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
            row.upButton.iconTexture:SetWidth(18)
            row.upButton.iconTexture:SetHeight(18)
            row.upButton.iconTexture:SetPoint("CENTER", row.upButton, "CENTER", 0, 0)
            row.upButton.iconTexture:Show()
            PCP_SetCustomTooltip(row.upButton, "Move up", "Move this button one step up in the order.")
            row.upButton:SetScript("OnClick", function(self) self = self or this
                if self._pcpButtonIndex then
                    PCP_MoveCustomButton(PCP_CustomFrameEditorState.selectedFrame or 1, self._pcpButtonIndex, -1)
                end
            end)
            PCP_RegisterThemedButton(row.upButton)

            row.downButton = CreateFrame("Button", nil, f.buttonScrollChild, "UIPanelButtonTemplate")
            row.downButton:SetWidth(24); row.downButton:SetHeight(22)
            row.downButton:SetPoint("LEFT", row.upButton, "RIGHT", 3, 0)
            row.downButton:SetText("")
            row.downButton:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
            row.downButton:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
            row.downButton:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight", "ADD")
            row.downButton.iconTexture = row.downButton:CreateTexture(nil, "OVERLAY")
            row.downButton.iconTexture:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
            row.downButton.iconTexture:SetWidth(18)
            row.downButton.iconTexture:SetHeight(18)
            row.downButton.iconTexture:SetPoint("CENTER", row.downButton, "CENTER", 0, 0)
            row.downButton.iconTexture:Show()
            PCP_SetCustomTooltip(row.downButton, "Move down", "Move this button one step down in the order.")
            row.downButton:SetScript("OnClick", function(self) self = self or this
                if self._pcpButtonIndex then
                    PCP_MoveCustomButton(PCP_CustomFrameEditorState.selectedFrame or 1, self._pcpButtonIndex, 1)
                end
            end)
            PCP_RegisterThemedButton(row.downButton)

            row.deleteButton = CreateFrame("Button", nil, f.buttonScrollChild, "UIPanelButtonTemplate")
            row.deleteButton:SetWidth(22); row.deleteButton:SetHeight(22)
            row.deleteButton:SetPoint("LEFT", row.downButton, "RIGHT", 3, 0)
            row.deleteButton:SetText("X")
            PCP_SetCustomTooltip(row.deleteButton, "Delete button", "Delete this button from the selected custom frame.")
            row.deleteButton:SetScript("OnClick", function(self) self = self or this
                if self._pcpButtonIndex then
                    PCP_DeleteCustomButton(PCP_CustomFrameEditorState.selectedFrame or 1, self._pcpButtonIndex)
                    if PCP_CustomFrameEditorState.selectedButton == self._pcpButtonIndex then
                        PCP_CustomFrameEditorState.selectedButton = nil
                        if PCP_ShowCustomButtonEditor then PCP_ShowCustomButtonEditor(nil) end
                    end
                end
            end)
            PCP_RegisterThemedButton(row.deleteButton)

            f.buttonRows[i] = row
            PCP_RegisterThemedButton(row)
        end

        PCP_CreateCustomScrollVisuals(f, f, "button", 610, -335, 145,
            function() return PCP_CustomFrameEditorState.buttonScrollOffset or 0 end,
            function(v) PCP_CustomFrameEditorState.buttonScrollOffset = v end,
            function()
                local frameIndex = PCP_CustomFrameEditorState.selectedFrame or 1
                local data = PCP_EnsureCustomFramesStorage()[frameIndex]
                local count = data and data.buttons and table.getn(data.buttons) or 0
                return math.max(0, count - table.getn(f.buttonRows))
            end)

        
        f.moveUpButton = nil
        f.moveDownButton = nil

        PCP_EnsureCustomButtonEditor()
        if PCPCustomButtonEditorFrame then
            PCPCustomButtonEditorFrame:SetParent(f)
            PCPCustomButtonEditorFrame:ClearAllPoints()
            PCPCustomButtonEditorFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 670, -110)
            PCPCustomButtonEditorFrame:SetFrameLevel(f:GetFrameLevel() + 5)
            PCPCustomButtonEditorFrame:Show()
        end
    end

    function PCP_RefreshCustomFramesEditor()
        if not PCPCustomFramesEditorFrame then return end
        local f = PCPCustomFramesEditorFrame
        local list = PCP_EnsureCustomFramesStorage()
        local selected = PCP_CustomFrameEditorState.selectedFrame or 1
        if selected < 1 then selected = 1 end
        if selected > table.getn(list) then selected = table.getn(list) end
        if selected < 1 then selected = 1 end
        PCP_CustomFrameEditorState.selectedFrame = selected

        local frameMaxOffset = math.max(0, table.getn(list) - table.getn(f.frameRows))
        local frameOffset = PCP_CustomFrameEditorState.frameScrollOffset or 0
        if frameOffset > frameMaxOffset then frameOffset = frameMaxOffset end
        if frameOffset < 0 then frameOffset = 0 end
        PCP_CustomFrameEditorState.frameScrollOffset = frameOffset

        for i = 1, table.getn(f.frameRows) do
            local realIndex = i + frameOffset
            local data = list[realIndex]
            local row = f.frameRows[i]
            if data then
                row._pcpFrameIndex = realIndex
                if row.deleteButton then row.deleteButton._pcpFrameIndex = realIndex; row.deleteButton:Show() end
                row:SetText((realIndex == selected and "> " or "") .. (data.name or ("Custom Frame " .. realIndex)))
                row:Show()
            else
                row._pcpFrameIndex = nil
                if row.deleteButton then row.deleteButton._pcpFrameIndex = nil; row.deleteButton:Hide() end
                row:Hide()
            end
        end

        if f.lockFramesCheck and PCP_AreCustomFramesLocked then
            f.lockFramesCheck:SetChecked(PCP_AreCustomFramesLocked() and true or false)
        end
        if f.showFrameNameCheck and PCP_ShouldShowCustomFrameNames then
            f.showFrameNameCheck:SetChecked(PCP_ShouldShowCustomFrameNames() and true or false)
        end

        local data = list[selected]
        if data then
            PCP_SetEditBoxText(f.nameBox, data.name or "")
            PCP_SetEditBoxText(f.widthBox, tostring(PCP_CustomRoundNumber(data.width, 260)))
            PCP_SetEditBoxText(f.heightBox, tostring(PCP_CustomRoundNumber(data.height, 120)))
            PCP_SetEditBoxText(f.spacingBox, tostring(PCP_CustomRoundNumber(data.spacing, 6)))
            if f.alwaysShowCheck then f.alwaysShowCheck:SetChecked(data.alwaysShow == true) end
        else
            PCP_SetEditBoxText(f.nameBox, "")
            if f.alwaysShowCheck then f.alwaysShowCheck:SetChecked(false) end
        end

        local buttonCount = data and data.buttons and table.getn(data.buttons) or 0
        local buttonMaxOffset = math.max(0, buttonCount - table.getn(f.buttonRows))
        local buttonOffset = PCP_CustomFrameEditorState.buttonScrollOffset or 0
        if buttonOffset > buttonMaxOffset then buttonOffset = buttonMaxOffset end
        if buttonOffset < 0 then buttonOffset = 0 end
        PCP_CustomFrameEditorState.buttonScrollOffset = buttonOffset

        for i = 1, table.getn(f.buttonRows) do
            local realIndex = i + buttonOffset
            local bd = data and data.buttons and data.buttons[realIndex]
            local row = f.buttonRows[i]
            if bd then
                row._pcpButtonIndex = realIndex
                if row.upButton then row.upButton._pcpButtonIndex = realIndex end
                if row.downButton then row.downButton._pcpButtonIndex = realIndex end
                if row.deleteButton then row.deleteButton._pcpButtonIndex = realIndex end
                local selectedPrefix = (PCP_CustomFrameEditorState.selectedButton == realIndex) and "> " or ""
                row:SetText("")
                if row.indexText then row.indexText:SetText(selectedPrefix .. realIndex .. ".") end
                if bd.type == "icon" then
                    if row.iconTexture then
                        row.iconTexture:SetTexture(bd.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
                        row.iconTexture:Show()
                    end
                    if row.labelText then row.labelText:SetText("") end
                else
                    if row.iconTexture then row.iconTexture:Hide() end
                    if row.labelText then row.labelText:SetText(bd.label ~= "" and bd.label or bd.command or ("Button " .. realIndex)) end
                end
                if row.upButton then
                    row.upButton:Show()
                    if realIndex > 1 then row.upButton:Enable() else row.upButton:Disable() end
                end
                if row.downButton then
                    row.downButton:Show()
                    if realIndex < buttonCount then row.downButton:Enable() else row.downButton:Disable() end
                end
                if row.deleteButton then row.deleteButton:Show() end
                row:Show()
            else
                row._pcpButtonIndex = nil
                if row.iconTexture then row.iconTexture:Hide() end
                if row.indexText then row.indexText:SetText("") end
                if row.labelText then row.labelText:SetText("") end
                if row.upButton then row.upButton:Hide() end
                if row.downButton then row.downButton:Hide() end
                if row.deleteButton then row.deleteButton._pcpButtonIndex = nil; row.deleteButton:Hide() end
                row:Hide()
            end
        end
        if f.moveUpButton then
            if PCP_CustomFrameEditorState.selectedButton and PCP_CustomFrameEditorState.selectedButton > 1 then f.moveUpButton:Enable() else f.moveUpButton:Disable() end
        end
        if f.moveDownButton then
            if PCP_CustomFrameEditorState.selectedButton and PCP_CustomFrameEditorState.selectedButton < buttonCount then f.moveDownButton:Enable() else f.moveDownButton:Disable() end
        end

        if PCP_UpdateCustomScrollVisual then PCP_UpdateCustomScrollVisual(f, "frame", frameOffset, frameMaxOffset) end
        if PCP_UpdateCustomScrollVisual then PCP_UpdateCustomScrollVisual(f, "button", buttonOffset, buttonMaxOffset) end

        PCP_ApplyThemeToCustomFrame(f)
        PCP_ApplySolidBlackCustomEditorBackground(f)
        if toggleButtonAppearance then toggleButtonAppearance(true, defaultColor) end
        if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
        if PCP_UpdateCustomFramesLockMode then PCP_UpdateCustomFramesLockMode() end
        if PCP_UpdateCustomFrameNameMode then PCP_UpdateCustomFrameNameMode() end
    end

    function PCP_ShowCustomFramesEditor()
        PCP_EnsureCustomFramesEditor()
        PCPCustomFramesEditorFrame:Show()
        if PCP_ShowCustomButtonEditor then PCP_ShowCustomButtonEditor(PCP_CustomFrameEditorState.selectedButton) end
        PCP_RefreshCustomFramesEditor()
        PCP_ApplyThemeToCustomFrame(PCPCustomFramesEditorFrame)
        PCP_ApplySolidBlackCustomEditorBackground(PCPCustomFramesEditorFrame)
        if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
        if PCP_UpdateCustomFramesLockMode then PCP_UpdateCustomFramesLockMode() end
        if PCP_UpdateCustomFrameNameMode then PCP_UpdateCustomFrameNameMode() end
    end

    function PCP_RefreshCustomFramesTheme()
        if PCPCustomFramesEditorFrame then PCP_ApplyThemeToCustomFrame(PCPCustomFramesEditorFrame); PCP_ApplySolidBlackCustomEditorBackground(PCPCustomFramesEditorFrame) end
        if PCPCustomButtonEditorFrame then PCP_ApplyThemeToCustomFrame(PCPCustomButtonEditorFrame); PCP_ApplySolidBlackCustomEditorBackground(PCPCustomButtonEditorFrame) end
        if PCPIconPickerFrame then PCP_ApplyThemeToCustomFrame(PCPIconPickerFrame) end
        for _, f in pairs(PCP_CustomFrameRuntime or {}) do
            PCP_ApplyThemeToCustomFrame(f)
        end
    end

    local pcpCustomVisibilityWatcher = CreateFrame("Frame")
    pcpCustomVisibilityWatcher._pcpLastMainShown = nil
    pcpCustomVisibilityWatcher._pcpElapsed = 0
    pcpCustomVisibilityWatcher:SetScript("OnUpdate", function(self, elapsed) self = self or this; elapsed = elapsed or arg1;
        self._pcpElapsed = (self._pcpElapsed or 0) + (elapsed or 0)
        if self._pcpElapsed < 0.10 then return end
        self._pcpElapsed = 0
        local shown = PCPFrameRemake and PCPFrameRemake:IsShown() and true or false
        if self._pcpLastMainShown ~= shown then
            self._pcpLastMainShown = shown
            if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
        end
    end)

    
    


local customFramesButton = CreateFrame("Button", "PCPCustomFramesButton", settingsFrame, "UIPanelButtonTemplate")
customFramesButton:SetWidth(150)
customFramesButton:SetHeight(22)
customFramesButton:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 25, -315)
customFramesButton:SetText("Custom frames")
customFramesButton:SetScript("OnClick", function()
    if settingsFrame then settingsFrame:Hide() end
    if ClickBlockerFrame then ClickBlockerFrame:Hide() end
    if PCP_ShowCustomFramesEditor then PCP_ShowCustomFramesEditor() end
    if PCP_RefreshCustomFramesTheme then PCP_RefreshCustomFramesTheme() end
end)
PCP_RegisterThemedButton(customFramesButton)
if PCP_SetCustomTooltip then
    PCP_SetCustomTooltip(customFramesButton, "Custom frames", "Create and edit your own command/macro frames.", "Supports text buttons, icon buttons, scroll lists and tooltips.")
end
local function PCP_UpdateSettingsFrameSize()
    settingsFrame:SetWidth(230)
    settingsFrame:SetHeight(390)
    versionText:ClearAllPoints()
    versionText:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -10, 10)
end
PCP_UpdateSettingsFrameSize()

PCP_VB = "0"

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

local pcpDelayedCustomFrameLoad = CreateFrame("Frame")
pcpDelayedCustomFrameLoad:Hide()
pcpDelayedCustomFrameLoad.ticks = 0
pcpDelayedCustomFrameLoad.elapsed = 0
pcpDelayedCustomFrameLoad:SetScript("OnUpdate", function(self, elapsed)
    self = self or this
    elapsed = elapsed or arg1 or 0
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed < 0.20 then return end
    self.elapsed = 0
    self.ticks = (self.ticks or 0) + 1

    
    
    if LoadSavedSettings then LoadSavedSettings() end
    if PCP_RebuildCustomFrames then PCP_RebuildCustomFrames() end
    if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
    if PCP_RefreshCustomFramesTheme then PCP_RefreshCustomFramesTheme() end
    if PCP_UpdateCustomFramesLockMode then PCP_UpdateCustomFramesLockMode() end

    if self.ticks >= 6 then
        self:Hide()
    end
end)

local function PCP_StartDelayedCustomFrameLoad()
    if not pcpDelayedCustomFrameLoad then return end
    pcpDelayedCustomFrameLoad.ticks = 0
    pcpDelayedCustomFrameLoad.elapsed = 0
    pcpDelayedCustomFrameLoad:Show()
end

local function PCP_LoadThemeOnce()
    if not pcpThemeLoaded then
        pcpThemeLoaded = true
        if LoadSavedSettings then LoadSavedSettings() end
        if PCP_RebuildCustomFrames then PCP_RebuildCustomFrames() end
        if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
        if PCP_RefreshCustomFramesTheme then PCP_RefreshCustomFramesTheme() end
        if PCP_UpdateCustomFramesLockMode then PCP_UpdateCustomFramesLockMode() end
    end
    PCP_StartDelayedCustomFrameLoad()
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
PCPMageSpecs = { "fire", "frost" }
PCPMageSpecItr = 1
PCPMageSpecIcons = {
    fire = "Interface\\Icons\\Spell_Fire_FlameBolt",
    frost = "Interface\\Icons\\Spell_Frost_FrostBolt02",
}
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
    if kind == "mage" then return PCPMageSpecIcons[value or "fire"] or PCPMageSpecIcons.fire or "Interface\\Icons\\INV_Misc_QuestionMark" end
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
local function PCP_GetMageSpecText() return PCPMageSpecs[PCPMageSpecItr or 1] or "fire" end
local function PCP_GetMageSpecDisplayName(spec) if spec == "fire" then return "Fire" elseif spec == "frost" then return "Frost" end return spec or "Fire" end
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
    elseif PCP_CurrentAddClass() == "mage" then
        local spec = PCP_GetMageSpecText()
        local icon = PCP_SpawnIcon("mage", spec)
        PCP_TooltipIconLine(icon, "Mage Spec", 1, 0.82, 0)
        GameTooltip:AddLine(" ")
        PCP_TooltipIconLine(icon, "Current: " .. PCP_GetMageSpecDisplayName(spec), 0, 1, 0)
        GameTooltip:AddLine("Left click: Configure mage spec", .7, .7, .7)
        GameTooltip:AddLine("Right click: Quick change mage spec", .7, .7, .7)
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
    elseif c == "mage" then
        PCP_SetSingleIcon(PCPSpawnConfigButton, PCP_SpawnIcon("mage", PCP_GetMageSpecText()), iconSize or 26)
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
    elseif PCP_CurrentAddClass() == "shaman" then
        
        
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
    elseif PCP_CurrentAddClass() == "mage" then
        f:SetWidth(280)
        f:SetHeight(150)
        f.title:SetText("Mage Spec")
        if f.shamanHeaders then for _, h in ipairs(f.shamanHeaders) do if h then h:Hide() end end end
        if f.shamanHeaderIcons then for _, t in ipairs(f.shamanHeaderIcons) do if t then t:Hide() end end end
        for i = 1, table.getn(PCPMageSpecs) do
            local spec = PCPMageSpecs[i]
            local cb = checkRow(i, PCP_GetMageSpecDisplayName(spec), (PCPMageSpecItr == i), function()
                PCPMageSpecItr = this._pcpMageSpecIndex or i
                PCP_RefreshSpawnOptionsFrame()
                PCP_UpdateSpawnConfigButtonText()
            end, 28, -50 - ((i - 1) * 28), 170, PCP_SpawnIcon("mage", spec))
            cb._pcpMageSpecIndex = i
        end
    end
end

function PCP_ShowSpawnOptionsFrame() if PCP_CurrentAddClass() ~= "paladin" and PCP_CurrentAddClass() ~= "shaman" and PCP_CurrentAddClass() ~= "mage" then return end PCP_RefreshSpawnOptionsFrame(); if PCPSpawnOptionsFrame:IsShown() then PCPSpawnOptionsFrame:Hide(); if PCP_UpdateClickBlockerVisibility then PCP_UpdateClickBlockerVisibility() end else PCPSpawnOptionsFrame:Show(); if ClickBlockerFrame then ClickBlockerFrame:Show() end end end
function PCP_QuickChangeSpawnOption(button)
    if PCP_CurrentAddClass() == "paladin" then PCPPaladinBlessingItr = (PCPPaladinBlessingItr or 1) + 1; if PCPPaladinBlessingItr > table.getn(PCPPaladinBlessings) then PCPPaladinBlessingItr = PCP_IsPaladinBuffRotationEnabled() and 2 or 1 end
    elseif PCP_CurrentAddClass() == "shaman" then local key = PCP_GetHoveredTotemKey(button); PCPShamanTotemItr[key] = (PCPShamanTotemItr[key] or 1) + 1; if PCPShamanTotemItr[key] > table.getn(PCPShamanTotems[key]) then PCPShamanTotemItr[key] = 1 end
    elseif PCP_CurrentAddClass() == "mage" then PCPMageSpecItr = (PCPMageSpecItr or 1) + 1; if PCPMageSpecItr > table.getn(PCPMageSpecs) then PCPMageSpecItr = 1 end end
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


	

local PCPPullTimerFrame = nil
local PCPPullTimerText = nil
local PCPPullTimerRemaining = 0

function PCP_ResetPullTimer()
    PCPPullTimerRemaining = 0
    if PCPPullTimerText then
        PCPPullTimerText:SetText("")
        PCPPullTimerText:Hide()
    end
    if PCPPullTimerFrame then
        PCPPullTimerFrame:SetScript("OnUpdate", nil)
    end
end

function PCP_UpdatePullTimerTextSize(baseFontSize)
    if not PCPPullTimerText or not CmdPull then return end
    local pullFontString = CmdPull:GetFontString()
    if pullFontString then
        PCPPullTimerText:ClearAllPoints()
        PCPPullTimerText:SetPoint("LEFT", pullFontString, "RIGHT", 4, 0)
    end
    local font, size, flags = nil, baseFontSize, nil
    if pullFontString and pullFontString.GetFont then
        font, size, flags = pullFontString:GetFont()
    end
    size = baseFontSize or size or 10
    local timerSize = math.floor(size * 0.92)
    if timerSize < 6 then timerSize = 6 end
    if timerSize > 12 then timerSize = 12 end
    if font then PCPPullTimerText:SetFont(font, timerSize, flags) end
end

function PCP_EnsurePullTimerText()
    if not CmdPull then return nil end
    if not PCPPullTimerText then
        PCPPullTimerText = CmdPull:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        PCPPullTimerText:SetPoint("LEFT", CmdPull:GetFontString(), "RIGHT", 4, 0)
        PCPPullTimerText:SetTextColor(1, 0.82, 0, 1)
        PCPPullTimerText:Hide()
    end
    PCP_UpdatePullTimerTextSize()
    return PCPPullTimerText
end

function PCP_StartPullTimer()
    local timerText = PCP_EnsurePullTimerText()
    if not timerText then return end
    PCPPullTimerRemaining = 30
    timerText:SetText("30")
    timerText:Show()
    if not PCPPullTimerFrame then PCPPullTimerFrame = CreateFrame("Frame") end
    PCPPullTimerFrame:SetScript("OnUpdate", function()
        local elapsed = arg1 or 0
        PCPPullTimerRemaining = (PCPPullTimerRemaining or 0) - elapsed
        if PCPPullTimerRemaining <= 0 then PCP_ResetPullTimer(); return end
        local shown = math.ceil(PCPPullTimerRemaining)
        if shown < 1 then shown = 1 end
        if PCPPullTimerText then
            PCPPullTimerText:SetText(tostring(shown))
            PCPPullTimerText:Show()
        end
    end)
end

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
    {"CmdStart", "Start", 0, 80, function() PCP_ResetPullTimer() SetCommand("attackstart") end, 80, 30},
    {"CmdStop", "Stop", 65, 80, function() SetCommand("attackstop") end, 80, 30},

    {"CmdUse", "Object", -65, 50, function() SetCommand("use") end, 80, 30},
    {"CmdPause", "Pause", 0, 50, function() SetPause() end, 80, 30},
    {"CmdUnpause", "Unpause", 65, 50, function() SetUnpause() end, 80, 30},

    {"CmdAOE", "AoE", -65, 20, function() SetCommand("aoe") end, 80, 30},  
    {"CmdPauseAll", "Pause all", 0, 20, function() SetCommand("pause all") end, 80, 30},  
    {"CmdUnpauseAll", "Unpause all", 65, 20, function() PCP_ResetPullTimer() SetCommand("unpause all") end, 80, 30},  

    {"CmdStay", "Stay", -65, -10, function() SetCommand("stay") end, 80, 30},  
    {"CmdMove", "Move", 0, -10, function() SetCommand("move") end, 80, 30},   
    {"CmdPull", "Pull", 65, -10, function() SetCommand("pull") PCP_StartPullTimer() end, 80, 30},   
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
                if button == CmdPull and PCP_UpdatePullTimerTextSize then PCP_UpdatePullTimerTextSize(fontSize) end
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
        table.insert(allButtons, showAll)
        if toggleButtonAppearance then toggleButtonAppearance(true, defaultColor) end
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
        table.insert(allButtons, close)
        if toggleButtonAppearance then toggleButtonAppearance(true, defaultColor) end
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
    elseif AddClass == "mage" and PCPMageSpecs then
        local spec = PCPMageSpecs[PCPMageSpecItr or 1]
        if spec and spec ~= "" then extra = " " .. spec end
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
    if PCP_RebuildCustomFrames then PCP_RebuildCustomFrames() end
    if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
end


SLASH_PCP1 = '/PCP'
function SlashCmdList.PCP(msg, editbox) 
    if (msg == "" or msg == "cp") then
        if (PCPFrameRemake:IsVisible()) then
            PCPFrameRemake:Hide()
        else
			PCPFrameRemake:Show()
        end
        if PCP_RebuildCustomFrames then PCP_RebuildCustomFrames() end
        if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
    end
end

function ShowToggle()
	if (PCPFrameRemake:IsVisible()) then
		PCPFrameRemake:Hide()
	else
		PCPFrameRemake:Show()
	end
    if PCP_RebuildCustomFrames then PCP_RebuildCustomFrames() end
    if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
end

function JoinWorld()
	id, name = GetChannelName(1)
	if (name ~= "World") then
		JoinChannelByName("World", nil, ChatFrame1:GetID(), 0)
	end
end



local PCP_VC = "0"

local PCP_GUARD = string.format("%d.%d.%d", PCP_VA, PCP_VB, PCP_VC)
local PCP_GITHUB_URL = "https://github.com/pumpan/PCPRemake"
local PCP_UpdateVersionPopup
local PCP_UpdateVersionPopupLinkBox
local PCP_UpdateVersionPopupCurrentText
local PCP_UpdateVersionPopupLatestText
local PCP_SessionUserID
local PCP_SessionUniqueUsers = {}

local function PCP_GenerateUserID()
    return math.random(1000000, 9999999)
end

local function PCP_StrSplit(delimiter, input)
    local result = {}
    local start_pos = 1
    local delim_pos
    if not input then return nil end
    delim_pos = strfind(input, delimiter, start_pos)
    while delim_pos do
        table.insert(result, strsub(input, start_pos, delim_pos - 1))
        start_pos = delim_pos + 1
        delim_pos = strfind(input, delimiter, start_pos)
    end
    table.insert(result, strsub(input, start_pos))
    return unpack(result)
end

local function PCP_SplitVersion(versionValue)
    local major, minor, patch = 0, 0, 0
    local dot1, dot2
    if not versionValue then return major, minor, patch end
    dot1 = strfind(versionValue, "%.")
    dot2 = dot1 and strfind(versionValue, "%.", dot1 + 1)
    if dot1 then
        major = tonumber(strsub(versionValue, 1, dot1 - 1)) or 0
        if dot2 then
            minor = tonumber(strsub(versionValue, dot1 + 1, dot2 - 1)) or 0
            patch = tonumber(strsub(versionValue, dot2 + 1)) or 0
        else
            minor = tonumber(strsub(versionValue, dot1 + 1)) or 0
        end
    else
        major = tonumber(versionValue) or 0
    end
    return major, minor, patch
end

local function PCP_IsNewerVersion(current, received)
    local cMajor, cMinor, cPatch = PCP_SplitVersion(current)
    local rMajor, rMinor, rPatch = PCP_SplitVersion(received)
    if rMajor > cMajor then return true end
    if rMajor == cMajor and rMinor > cMinor then return true end
    if rMajor == cMajor and rMinor == cMinor and rPatch > cPatch then return true end
    return false
end

local function PCP_HasTrackedUpdateVersion()
    local latestVersion
    if not PCP_Settings then return false end
    latestVersion = PCP_Settings.lastNotifiedVersion
    if not latestVersion or latestVersion == "" then return false end
    return PCP_IsNewerVersion(PCP_VERSION, latestVersion)
end

local function PCP_EnsureUpdateVersionPopup()
    local okButton, ignoreButton, linkLabel
    if PCP_UpdateVersionPopup then return PCP_UpdateVersionPopup end

    PCP_UpdateVersionPopup = CreateFrame("Frame", "PCPUpdateVersionPopup", UIParent)
    PCP_UpdateVersionPopup:SetWidth(430)
    PCP_UpdateVersionPopup:SetHeight(170)
    PCP_UpdateVersionPopup:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    PCP_UpdateVersionPopup:SetFrameStrata("DIALOG")
    PCP_UpdateVersionPopup:SetMovable(true)
    PCP_UpdateVersionPopup:EnableMouse(true)
    PCP_UpdateVersionPopup:RegisterForDrag("LeftButton")
    PCP_UpdateVersionPopup:SetScript("OnDragStart", function() this:StartMoving() end)
    PCP_UpdateVersionPopup:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
    PCP_UpdateVersionPopup:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    PCP_UpdateVersionPopup:SetBackdropColor(0, 0, 0, 1)
    PCP_UpdateVersionPopup:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, "PCPUpdateVersionPopup") end

    PCP_UpdateVersionPopup.header = PCP_UpdateVersionPopup:CreateTexture(nil, "ARTWORK")
    PCP_UpdateVersionPopup.header:SetWidth(220)
    PCP_UpdateVersionPopup.header:SetHeight(64)
    PCP_UpdateVersionPopup.header:SetPoint("TOP", PCP_UpdateVersionPopup, 0, 18)
    PCP_UpdateVersionPopup.header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    PCP_UpdateVersionPopup.header:SetVertexColor(.2, .2, .2)

    PCP_UpdateVersionPopup.headerText = PCP_UpdateVersionPopup:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    PCP_UpdateVersionPopup.headerText:SetPoint("TOP", PCP_UpdateVersionPopup.header, 0, -14)
    PCP_UpdateVersionPopup.headerText:SetText("Update Available")

    PCP_UpdateVersionPopupCurrentText = PCP_UpdateVersionPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    PCP_UpdateVersionPopupCurrentText:SetPoint("TOPLEFT", PCP_UpdateVersionPopup, "TOPLEFT", 20, -42)
    PCP_UpdateVersionPopupCurrentText:SetJustifyH("LEFT")

    PCP_UpdateVersionPopupLatestText = PCP_UpdateVersionPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    PCP_UpdateVersionPopupLatestText:SetPoint("TOPLEFT", PCP_UpdateVersionPopupCurrentText, "BOTTOMLEFT", 0, -10)
    PCP_UpdateVersionPopupLatestText:SetJustifyH("LEFT")

    linkLabel = PCP_UpdateVersionPopup:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    linkLabel:SetPoint("TOPLEFT", PCP_UpdateVersionPopupLatestText, "BOTTOMLEFT", 0, -14)
    linkLabel:SetJustifyH("LEFT")
    linkLabel:SetText("GitHub:")

    PCP_UpdateVersionPopupLinkBox = CreateFrame("EditBox", "PCPUpdateVersionPopupLinkBox", PCP_UpdateVersionPopup, "InputBoxTemplate")
    PCP_UpdateVersionPopupLinkBox:SetPoint("TOPLEFT", linkLabel, "BOTTOMLEFT", 0, -5)
    PCP_UpdateVersionPopupLinkBox:SetWidth(380)
    PCP_UpdateVersionPopupLinkBox:SetHeight(20)
    PCP_UpdateVersionPopupLinkBox:SetAutoFocus(false)
    PCP_UpdateVersionPopupLinkBox:SetScript("OnEscapePressed", function() this:ClearFocus(); this:HighlightText(0, 0) end)
    PCP_UpdateVersionPopupLinkBox:SetScript("OnEditFocusGained", function() this:HighlightText() end)
    PCP_UpdateVersionPopupLinkBox:SetScript("OnMouseUp", function() this:SetFocus(); this:HighlightText() end)

    okButton = CreateFrame("Button", nil, PCP_UpdateVersionPopup, "UIPanelButtonTemplate")
    okButton:SetWidth(90)
    okButton:SetHeight(22)
    okButton:SetPoint("BOTTOMRIGHT", PCP_UpdateVersionPopup, "BOTTOMRIGHT", -20, 14)
    okButton:SetText("OK")
    okButton:SetScript("OnClick", function() PCP_UpdateVersionPopup:Hide() end)

    ignoreButton = CreateFrame("Button", nil, PCP_UpdateVersionPopup, "UIPanelButtonTemplate")
    ignoreButton:SetWidth(140)
    ignoreButton:SetHeight(22)
    ignoreButton:SetPoint("RIGHT", okButton, "LEFT", -10, 0)
    ignoreButton:SetText("Ignore this version")
    ignoreButton:SetScript("OnClick", function()
        if not PCP_Settings then PCP_Settings = {} end
        if PCP_HasTrackedUpdateVersion() then
            PCP_Settings.ignoredUpdateVersion = PCP_Settings.lastNotifiedVersion
        end
        PCP_UpdateVersionPopup:Hide()
    end)

    return PCP_UpdateVersionPopup
end

function PCP_ShowUpdateVersionPopup()
    local latestVersion, popup
    if not PCP_Settings then PCP_Settings = {} end
    latestVersion = PCP_Settings.lastNotifiedVersion or PCP_VERSION
    popup = PCP_EnsureUpdateVersionPopup()
    PCP_UpdateVersionPopupCurrentText:SetText("You are using: " .. PCP_VERSION)
    PCP_UpdateVersionPopupLatestText:SetText("Latest version: " .. latestVersion)
    PCP_UpdateVersionPopupLinkBox:SetText(PCP_GITHUB_URL)
    PCP_UpdateVersionPopupLinkBox:ClearFocus()
    PCP_UpdateVersionPopupLinkBox:HighlightText(0, 0)
    popup:Show()
end

local function PCP_MaybeShowUpdateVersionPopup()
    if not PCP_HasTrackedUpdateVersion() then return end
    if PCP_Settings and PCP_Settings.ignoredUpdateVersion == PCP_Settings.lastNotifiedVersion then return end
    PCP_ShowUpdateVersionPopup()
end

local function PCP_RegisterVersionPrefix()
    if C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
        C_ChatInfo.RegisterAddonMessagePrefix(PCP_VERSION_PREFIX)
    end
end

local function PCP_SendVersionMessage(versionValue, userID)
    local message = versionValue .. ";" .. userID
    if C_ChatInfo and C_ChatInfo.SendAddonMessage then
        C_ChatInfo.SendAddonMessage(PCP_VERSION_PREFIX, message, "GUILD")
    elseif SendAddonMessage then
        SendAddonMessage(PCP_VERSION_PREFIX, message, "GUILD")
    end
end

local PCP_VersionFrame = CreateFrame("Frame")
PCP_VersionFrame:RegisterEvent("PLAYER_LOGIN")
PCP_VersionFrame:RegisterEvent("CHAT_MSG_ADDON")
PCP_VersionFrame:SetScript("OnEvent", function(self, eventName, prefix, message, channel, sender)
    local currentEvent = eventName or event
    local receivedPrefix = prefix or arg1
    local receivedMessage = message or arg2
    local receivedSender = sender or arg4
    local receivedVersion, receivedUserID, lastNotifiedVersion

    if currentEvent == "PLAYER_LOGIN" then
        PCP_RegisterVersionPrefix()
        if not PCP_Settings then PCP_Settings = {} end
        if not PCP_Settings.userID then PCP_Settings.userID = PCP_GenerateUserID() end
        PCP_SessionUserID = PCP_Settings.userID
        if not PCP_Settings.lastNotifiedVersion then PCP_Settings.lastNotifiedVersion = PCP_VERSION end
        if not PCP_Settings.userCount or PCP_Settings.userCount == "" then PCP_Settings.userCount = 0 end
        if not PCP_Settings.uniqueUsers then PCP_Settings.uniqueUsers = {} end

        if PCP_IsNewerVersion(PCP_VERSION, PCP_Settings.lastNotifiedVersion) then
            PCP_SendVersionMessage(PCP_Settings.lastNotifiedVersion, PCP_SessionUserID)
            if PCP_NewVersion then PCP_NewVersion(PCP_Settings.lastNotifiedVersion) end
            PCP_MaybeShowUpdateVersionPopup()
        else
            if PCP_VERSION == PCP_GUARD then
                if PCP_NewVersion then PCP_NewVersion() end
                PCP_SendVersionMessage(PCP_VERSION, PCP_SessionUserID)
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff4444[PCP]|r Version guard failed. Not sending version.")
            end
        end
        return
    end

    if currentEvent == "CHAT_MSG_ADDON" and receivedPrefix == PCP_VERSION_PREFIX then
        if receivedSender == UnitName("player") then return end
        if not receivedMessage or receivedMessage == "" then return end

        receivedVersion, receivedUserID = PCP_StrSplit(";", receivedMessage)
        if not tonumber(receivedUserID) then return end
        if not receivedVersion or not strfind(receivedVersion, "^%d+%.%d+%.%d+$") then return end

        if not PCP_Settings then PCP_Settings = {} end
        if not PCP_Settings.uniqueUsers then PCP_Settings.uniqueUsers = {} end
        if not PCP_SessionUniqueUsers[receivedUserID] and not PCP_Settings.uniqueUsers[receivedUserID] then
            PCP_SessionUniqueUsers[receivedUserID] = true
            PCP_Settings.uniqueUsers[receivedUserID] = true
            PCP_Settings.userCount = (PCP_Settings.userCount or 0) + 1
        end

        if PCP_IsNewerVersion(PCP_VERSION, receivedVersion) then
            lastNotifiedVersion = PCP_Settings.lastNotifiedVersion or ""
            if PCP_IsNewerVersion(lastNotifiedVersion, receivedVersion) then
                PCP_Settings.lastNotifiedVersion = receivedVersion
                PCP_SendVersionMessage(receivedVersion, PCP_SessionUserID or PCP_Settings.userID or PCP_GenerateUserID())
                if PCP_NewVersion then PCP_NewVersion(receivedVersion) end
                PCP_MaybeShowUpdateVersionPopup()
            end
        end
    end
end)

if LoadSavedSettings then
    LoadSavedSettings()
end
if PCP_RebuildCustomFrames then
    PCP_RebuildCustomFrames()
end
if PCP_UpdateAllCustomFrameVisibility then
    PCP_UpdateAllCustomFrameVisibility()
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
