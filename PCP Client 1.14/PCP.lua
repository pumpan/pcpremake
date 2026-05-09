local version, build, date, tocversion = GetBuildInfo()

local PCP_ADDON_NAME = "PCP"
local PCP_VERSION_PREFIX = "PCPRemake1142"
local PCP_VERSION = "3.0.1"
local PCP_VA = "3"

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
		PCPFrameRemake:Hide()	
		
    end
end










macroMode = false   

function DispatchCommand(text)
    if macroMode then
        
        if not MacroFrame then
            if MacroFrame_LoadUI then
                MacroFrame_LoadUI()
            end
        end

        
        if MacroFrame and not MacroFrame:IsShown() then
            ShowMacroFrame()
        end

        
        if MacroFrameText then
            MacroFrameText:SetFocus()
            MacroFrameText:Insert(text .. "\n")
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cff88ccff[PCP]|r Could not find MacroFrameText. Open /macro once and try again.")
        end

        return
    end

    local chatChannel = GetChatChannel()
    SendChatMessage(text, chatChannel)
end


if not PCPFrameRemake then
    local frame = CreateFrame("Frame", "PCPFrameRemake", UIParent, "BackdropTemplate")
    frame:SetSize(260, 550)
    frame:SetPoint("CENTER")

    local PCP_UpdateFreeBackdropMode
    local defaultColor = "originalButtons"

    local function PCP_GetCurrentThemeColor()
        local color = defaultColor
        if PCP_Settings and PCP_Settings.color then
            color = PCP_Settings.color
        end
        return color or "originalButtons"
    end

    local function PCP_IsDathWTheme()
        local color = PCP_GetCurrentThemeColor()
        return color == "dathw" or color == "DathW"
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
            return {
                bg = { 0.05, 0.05, 0.05, 0.82 },
                gradTop = { 0.90, 0.90, 0.90, 0.18 },
                gradBottom = { 0.00, 0.00, 0.00, 0.30 },
                border = { 0.32, 0.32, 0.32, 0.70 },
                text = { 1, 1, 1, 1 },
                highlight = { 1, 1, 1, 0.13 },
                pushed = { 0.02, 0.02, 0.02, 1 },
                frameBg = { 0.04, 0.04, 0.04, 0.86 },
                frameBorder = { 0.32, 0.32, 0.32, 0.70 },
            }
        elseif color == "warcraftgold" then
            return {
                bg = { 0.15, 0.10, 0.02, 0.94 },
                gradTop = { 1.00, 0.85, 0.25, 0.35 },
                gradBottom = { 0.00, 0.00, 0.00, 0.30 },
                border = { 1.00, 0.82, 0.00, 0.92 },
                text = { 1, 0.82, 0, 1 },
                highlight = { 1, 0.82, 0, 0.18 },
                pushed = { 0.35, 0.18, 0.02, 1 },
                frameBg = { 0.08, 0.06, 0.02, 0.90 },
                frameBorder = { 1.00, 0.82, 0.00, 1 },
            }
        elseif color == "shadowblue" then
            return {
                bg = { 0.02, 0.04, 0.12, 0.90 },
                gradTop = { 0.40, 0.60, 1.00, 0.35 },
                gradBottom = { 0.00, 0.00, 0.05, 0.30 },
                border = { 0.30, 0.50, 1.00, 0.76 },
                text = { 0.82, 0.92, 1, 1 },
                highlight = { 0.35, 0.55, 1, 0.20 },
                pushed = { 0.02, 0.08, 0.24, 1 },
                frameBg = { 0.02, 0.04, 0.12, 0.90 },
                frameBorder = { 0.30, 0.50, 1.00, 0.76 },
            }
        elseif color == "bloodred" then
            return {
                bg = { 0.12, 0.02, 0.02, 0.94 },
                gradTop = { 1.00, 0.20, 0.20, 0.35 },
                gradBottom = { 0.00, 0.00, 0.00, 0.35 },
                border = { 0.80, 0.10, 0.10, 0.95 },
                text = { 1, 0.86, 0.82, 1 },
                highlight = { 1, 0.18, 0.14, 0.18 },
                pushed = { 0.28, 0.02, 0.02, 1 },
                frameBg = { 0.10, 0.02, 0.02, 0.90 },
                frameBorder = { 0.80, 0.10, 0.10, 1 },
            }
        elseif color == "minimalflat" then
            return {
                bg = { 0.12, 0.12, 0.12, 0.60 },
                gradTop = { 1.00, 1.00, 1.00, 0.12 },
                gradBottom = { 0.00, 0.00, 0.00, 0.22 },
                border = { 0, 0, 0, 0 },
                text = { 1, 1, 1, 1 },
                highlight = { 1, 1, 1, 0.08 },
                pushed = { 0.06, 0.06, 0.06, 1 },
                frameBg = { 0.10, 0.10, 0.10, 0.62 },
                frameBorder = { 0, 0, 0, 0 },
                edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 },
            }
        elseif color == "pink" then
            return {
                bg = { 0.55, 0.20, 0.32, 0.72 },
                gradTop = { 1.00, 0.72, 0.86, 0.18 },
                gradBottom = { 0.12, 0.00, 0.04, 0.34 },
                border = { 1.00, 0.55, 0.72, 0.58 },
                text = { 1, 0.92, 0.96, 1 },
                highlight = { 1.00, 0.55, 0.72, 0.16 },
                pushed = { 0.35, 0.06, 0.14, 1 },
                frameBg = { 0.12, 0.03, 0.07, 0.78 },
                frameBorder = { 1.00, 0.55, 0.72, 0.55 },
            }
        elseif color == "solidpink" then
            return {
                bg = { 0.72, 0.30, 0.44, 0.94 },
                gradTop = { 1.00, 1.00, 1.00, 0.22 },
                gradBottom = { 0.10, 0.00, 0.05, 0.35 },
                border = { 1.00, 0.58, 0.76, 0.86 },
                text = { 1, 0.94, 0.98, 1 },
                highlight = { 1.00, 0.60, 0.78, 0.20 },
                pushed = { 0.45, 0.08, 0.18, 1 },
                frameBg = { 0.14, 0.04, 0.08, 0.88 },
                frameBorder = { 1.00, 0.58, 0.76, 0.75 },
            }
        elseif color == "green" then
            return {
                bg = { 0.06, 0.28, 0.08, 0.72 },
                gradTop = { 0.45, 0.95, 0.45, 0.18 },
                gradBottom = { 0.00, 0.05, 0.00, 0.36 },
                border = { 0.35, 0.82, 0.35, 0.58 },
                text = { 0.88, 1, 0.88, 1 },
                highlight = { 0.40, 1.00, 0.40, 0.16 },
                pushed = { 0.02, 0.18, 0.04, 1 },
                frameBg = { 0.02, 0.09, 0.03, 0.78 },
                frameBorder = { 0.35, 0.82, 0.35, 0.55 },
            }
        elseif color == "solidgreen" then
            return {
                bg = { 0.04, 0.45, 0.07, 0.94 },
                gradTop = { 1.00, 1.00, 1.00, 0.22 },
                gradBottom = { 0.00, 0.10, 0.00, 0.35 },
                border = { 0.38, 0.92, 0.38, 0.86 },
                text = { 0.90, 1, 0.90, 1 },
                highlight = { 0.42, 1.00, 0.42, 0.20 },
                pushed = { 0.02, 0.24, 0.04, 1 },
                frameBg = { 0.02, 0.10, 0.03, 0.88 },
                frameBorder = { 0.38, 0.92, 0.38, 0.75 },
            }
        elseif color == "blue" then
            return {
                bg = { 0.03, 0.08, 0.34, 0.72 },
                gradTop = { 0.35, 0.55, 1.00, 0.18 },
                gradBottom = { 0.00, 0.00, 0.08, 0.38 },
                border = { 0.35, 0.55, 1.00, 0.58 },
                text = { 0.86, 0.93, 1, 1 },
                highlight = { 0.35, 0.55, 1.00, 0.16 },
                pushed = { 0.02, 0.06, 0.22, 1 },
                frameBg = { 0.02, 0.03, 0.10, 0.78 },
                frameBorder = { 0.35, 0.55, 1.00, 0.55 },
            }
        elseif color == "solidblue" then
            return {
                bg = { 0.04, 0.12, 0.55, 0.94 },
                gradTop = { 1.00, 1.00, 1.00, 0.25 },
                gradBottom = { 0.00, 0.00, 0.10, 0.35 },
                border = { 0.38, 0.60, 1.00, 0.86 },
                text = { 0.88, 0.94, 1, 1 },
                highlight = { 0.40, 0.62, 1.00, 0.20 },
                pushed = { 0.02, 0.08, 0.28, 1 },
                frameBg = { 0.02, 0.04, 0.12, 0.88 },
                frameBorder = { 0.38, 0.60, 1.00, 0.75 },
            }
        elseif color == "gray" then
            return {
                bg = { 0.26, 0.26, 0.26, 0.72 },
                gradTop = { 1.00, 1.00, 1.00, 0.20 },
                gradBottom = { 0.00, 0.00, 0.00, 0.30 },
                border = { 0.70, 0.70, 0.70, 0.58 },
                text = { 1, 1, 1, 1 },
                highlight = { 1, 1, 1, 0.12 },
                pushed = { 0.12, 0.12, 0.12, 1 },
                frameBg = { 0.08, 0.08, 0.08, 0.78 },
                frameBorder = { 0.70, 0.70, 0.70, 0.50 },
            }
        elseif color == "solidgray" then
            return {
                bg = { 0.42, 0.42, 0.42, 0.94 },
                gradTop = { 1.00, 1.00, 1.00, 0.22 },
                gradBottom = { 0.00, 0.00, 0.00, 0.35 },
                border = { 0.82, 0.82, 0.82, 0.84 },
                text = { 1, 1, 1, 1 },
                highlight = { 1, 1, 1, 0.16 },
                pushed = { 0.18, 0.18, 0.18, 1 },
                frameBg = { 0.10, 0.10, 0.10, 0.88 },
                frameBorder = { 0.82, 0.82, 0.82, 0.70 },
            }
        elseif color == "black" then
            return {
                bg = { 0.02, 0.02, 0.02, 0.86 },
                gradTop = { 0.80, 0.80, 0.80, 0.18 },
                gradBottom = { 0.00, 0.00, 0.00, 0.30 },
                border = { 0.30, 0.30, 0.30, 0.82 },
                text = { 1, 1, 1, 1 },
                highlight = { 1, 1, 1, 0.10 },
                pushed = { 0.00, 0.00, 0.00, 1 },
                frameBg = { 0.01, 0.01, 0.01, 0.88 },
                frameBorder = { 0.30, 0.30, 0.30, 0.75 },
            }
        end

        return nil
    end

    local function PCP_GetBackdropStyle()
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

        return {
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
            bgColor = { 0, 0, 0, 0.5 },
            borderColor = { 1, 1, 1, 1 },
        }
    end

	function ToggleBackdrop(frame, enable)
		if enable then
            local style = PCP_GetBackdropStyle()
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
        if PCP_UpdateFreeBackdropMode then
            PCP_UpdateFreeBackdropMode()
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
		DEFAULT_CHAT_FRAME:AddMessage(isChecked and "Dead bot control enabled" or "Dead bot control disabled")
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
    frame:SetMinResize(216, 140)  

    
    local resizeGrip = CreateFrame("Button", nil, frame)
    resizeGrip:SetSize(16, 16)  
    resizeGrip:SetPoint("BOTTOMRIGHT")  
    resizeGrip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeGrip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    resizeGrip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")

    
    resizeGrip:SetScript("OnMouseDown", function()
        frame._pcpManualResizing = true
        
        
        
        frame._pcpSizingHeightOverride = nil
        frame._pcpLastManualMainFrameHeight = frame:GetHeight() or frame._pcpLastManualMainFrameHeight
        frame:StartSizing("BOTTOMRIGHT")
    end)

    resizeGrip:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
        frame._pcpManualResizing = false
        frame._pcpSizingHeightOverride = nil
        frame._pcpLastManualMainFrameHeight = frame:GetHeight() or frame._pcpLastManualMainFrameHeight
    end)

    
    
    local overlayLayer = CreateFrame("Frame", nil, frame)
    overlayLayer:SetFrameLevel(2) 

    
    local titleFontString = overlayLayer:CreateFontString("AddCustomBot", "OVERLAY", "GameFontNormal")

    titleFontString:SetSize(220, 20)
    titleFontString:SetPoint("CENTER", 0, -25)


	
	local classNames = {"Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Shaman", "Mage", "Warlock", "Druid"}
	local currentClassIndex = 1  

	
	local classDisplayFontString = overlayLayer:CreateFontString("classDisplay", "OVERLAY", "GameFontNormal")
	classDisplayFontString:SetText(classNames[currentClassIndex])
	classDisplayFontString:SetSize(220, 20)
	classDisplayFontString:SetPoint("CENTER", 0, -60)

	
	local function UpdateClassDisplay()
		classDisplayFontString:SetText(classNames[currentClassIndex])
	end


local isCustomAppearanceEnabled = false
local settingsLoaded = false
local ApplyPCPSectionLayout
local ResetPCPSectionPositions
local PCP_ShowSectionOptions
local PCP_ApplySectionVisibility
local PCP_UpdateSectionResizeMode


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
function ShowReloadConfirmation(selectedColor)
    
    if PCPReloadFrame then
        PCPReloadFrame:Show()
        return
    end

    
    local reloadFrame = CreateFrame("Frame", "PCPReloadFrame", UIParent, "BackdropTemplate")
    reloadFrame:SetSize(300, 100)
    reloadFrame:SetPoint("CENTER", UIParent, "CENTER")
    reloadFrame:SetMovable(true)
    reloadFrame:EnableMouse(true)
    reloadFrame:RegisterForDrag("LeftButton")
    reloadFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    reloadFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    
    local bg = reloadFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(reloadFrame)
    bg:SetColorTexture(0, 0, 0, 0.8)

    
    local border = CreateFrame("Frame", nil, reloadFrame, "BackdropTemplate")
    border:SetAllPoints(reloadFrame)
    border:SetBackdrop({
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })

    
    local reloadText = reloadFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    reloadText:SetPoint("TOP", reloadFrame, "TOP", 0, -10)
    reloadText:SetText("Reload UI to apply changes?")

    
    local yesButton = CreateFrame("Button", nil, reloadFrame, "UIPanelButtonTemplate")
    yesButton:SetSize(80, 30)
    yesButton:SetPoint("BOTTOMLEFT", reloadFrame, "BOTTOMLEFT", 40, 10)
    yesButton:SetText("Yes")
    yesButton:SetScript("OnClick", function()
        if InCombatLockdown() then
            print("Cannot reload UI while in combat!")
        else
            toggleButtonAppearance(true, selectedColor) 
            ReloadUI() 
        end
    end)

    
    local noButton = CreateFrame("Button", nil, reloadFrame, "UIPanelButtonTemplate")
    noButton:SetSize(80, 30)
    noButton:SetPoint("BOTTOMRIGHT", reloadFrame, "BOTTOMRIGHT", -40, 10)
    noButton:SetText("No")
    noButton:SetScript("OnClick", function()
        reloadFrame:Hide() 
    end)

    
    PCPReloadFrame = reloadFrame
end


local allButtons = {}


local function PCP_HideUIPanelButtonTemplateChrome(button)
    if not button then return end

    
    
    
    
    local name = button.GetName and button:GetName() or nil
    if name then
        local suffixes = { "Left", "Middle", "Right", "LeftDisabled", "MiddleDisabled", "RightDisabled" }
        for _, suffix in ipairs(suffixes) do
            local region = _G[name .. suffix]
            if region then
                if region.SetTexture then region:SetTexture(nil) end
                if region.SetAlpha then region:SetAlpha(0) end
                if region.Hide then region:Hide() end
            end
        end
    end

    if button.GetRegions then
        local regions = { button:GetRegions() }
        for _, region in ipairs(regions) do
            if region and region.GetTexture and region.SetTexture then
                local tex = region:GetTexture()
                tex = tex and tostring(tex) or ""
                if string.find(tex, "UI%-Panel%-Button") or string.find(tex, "UI%-DialogBox%-Button") then
                    region:SetTexture(nil)
                    if region.SetAlpha then region:SetAlpha(0) end
                    if region.Hide then region:Hide() end
                end
            end
        end
    end
end

local function PCP_RegisterThemedButton(button)
    if not button then return end
    for _, existing in ipairs(allButtons) do
        if existing == button then
            PCP_HideUIPanelButtonTemplateChrome(button)
            return
        end
    end
    table.insert(allButtons, button)
    PCP_HideUIPanelButtonTemplateChrome(button)
end

local closeButton = CreateFrame("Button", nil, PCPFrameRemake)
closeButton:SetHeight(16)  
closeButton:SetWidth(16)
closeButton:SetPoint("TOPRIGHT", PCPFrameRemake, "TOPRIGHT", -5, -5) 


closeButton:SetNormalTexture("Interface/AddOns/PCP/img/close.tga")


closeButton:SetHighlightTexture("Interface/Buttons/UI-Panel-MinimizeButton-Highlight")


closeButton:SetPushedTexture("Interface/Buttons/UI-Panel-MinimizeButton-Down")


closeButton:SetScript("OnClick", function(self)
    PCPFrameRemake:Hide()
end)


closeButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Close", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
closeButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)


PCP_RegisterThemedButton(closeButton)



local settingsButton = CreateFrame("Button", nil, PCPFrameRemake)
settingsButton:SetSize(16, 16)  
settingsButton:SetPoint("TOPLEFT", PCPFrameRemake, "TOPLEFT", 5, -5) 
settingsButton:SetNormalTexture("Interface/AddOns/PCP/img/settings.tga")

PCP_RegisterThemedButton(settingsButton)

settingsButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Settings", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
settingsButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)



local controlsFrame = CreateFrame("Frame", "PCPControlsFrame", frame)
controlsFrame:SetSize(300, 28)
controlsFrame:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 8)
controlsFrame:Hide()

local function ResizeControlsButtons()
    if not controlsFrame then return end
    local w = controlsFrame:GetWidth() or 240
    local h = controlsFrame:GetHeight() or 28
    local size = math.min(h - 8, (w - 18) / 2)
    if size < 12 then size = 12 end
    if size > 24 then size = 24 end

    settingsButton:SetSize(size, size)
    closeButton:SetSize(size, size)

    settingsButton:ClearAllPoints()
    settingsButton:SetPoint("LEFT", controlsFrame, "LEFT", 7, 0)

    closeButton:ClearAllPoints()
    closeButton:SetPoint("RIGHT", controlsFrame, "RIGHT", -7, 0)
end


local settingsFrame = CreateFrame("Frame", "PCPSettingsFrame", PCPFrameRemake, "BackdropTemplate")
settingsFrame:SetSize(230, 285) 
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
versionClickButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
    GameTooltip:SetText("Click to show update info.")
    GameTooltip:Show()
end)
versionClickButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

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
    if settingsFrame then settingsFrame:Hide() end
    if PCPSpawnOptionsFrame then PCPSpawnOptionsFrame:Hide() end
    ClickBlockerFrame:Hide()
end)


local function ToggleSettingsFrame()
    if settingsFrame:IsShown() then
        settingsFrame:Hide()
        if PCP_UpdateClickBlockerVisibility then PCP_UpdateClickBlockerVisibility() end
    else
        if settingsFrame.SetFrameStrata then settingsFrame:SetFrameStrata("FULLSCREEN_DIALOG") end
        if settingsFrame.SetFrameLevel then settingsFrame:SetFrameLevel(200) end
        if settingsFrame.SetToplevel then settingsFrame:SetToplevel(true) end
        settingsFrame:Show()
        if PCP_UpdateSettingsFrameSize then
            PCP_UpdateSettingsFrameSize()
        end
        ClickBlockerFrame:Show()  
        if settingsFrame.Raise then settingsFrame:Raise() end
    end
end

settingsButton:SetScript("OnClick", ToggleSettingsFrame)


local colorDropdown = CreateFrame("Frame", "PCPColorDropdown", settingsFrame, "UIDropDownMenuTemplate")
colorDropdown:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -10)


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


local function InitializeDropdown(self, level)
    for _, option in ipairs(colorOptions) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = option.text
        info.func = function()
            UIDropDownMenu_SetSelectedName(colorDropdown, option.text)  
            toggleButtonAppearance(true, option.color)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

UIDropDownMenu_Initialize(colorDropdown, InitializeDropdown)
UIDropDownMenu_SetWidth(colorDropdown, 120)
UIDropDownMenu_SetButtonWidth(colorDropdown, 140)
UIDropDownMenu_SetSelectedName(colorDropdown, "Select Color")
UIDropDownMenu_JustifyText(colorDropdown, "LEFT")


local function CloseSettingsOnClick(_, button)
    if button == "LeftButton" and settingsFrame:IsShown() then
        local x, y = GetCursorPosition()
        local scale = settingsFrame:GetEffectiveScale()
        local left, bottom, width, height = settingsFrame:GetRect()
        left, bottom = left * scale, bottom * scale
        width, height = width * scale, height * scale

        if not (x >= left and x <= left + width and y >= bottom and y <= bottom + height) then
            settingsFrame:Hide()
        end
    end
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


backdropCheck:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()
    ToggleBackdrop(PCPFrameRemake, isChecked)
    SaveSettings(defaultColor, isChecked)
    if PCP_UpdateFreeBackdropMode then
        PCP_UpdateFreeBackdropMode()
    end
    if PCP_RefreshCustomFramesTheme then
        PCP_RefreshCustomFramesTheme()
    end
end)

local titlesBgCheck = CreateFrame("CheckButton", "PCPtitlesBgCheck", settingsFrame, "UICheckButtonTemplate")
titlesBgCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -70)
titlesBgCheck.text = titlesBgCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titlesBgCheck.text:SetPoint("LEFT", titlesBgCheck, "RIGHT", 5, 0)
titlesBgCheck.text:SetText("Title background")
titlesBgCheck:SetChecked(true)  


titlesBgCheck:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()  
    ToggletitlesBgCheck(PCPFrameRemake, isChecked)
    SaveSettings(defaultColor, nil, isChecked)  
end)

local controllDeadBotsCheck = CreateFrame("CheckButton", "PCPcontrollDeadBotsCheck", settingsFrame, "UICheckButtonTemplate")
controllDeadBotsCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -100)
controllDeadBotsCheck.text = controllDeadBotsCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
controllDeadBotsCheck.text:SetPoint("LEFT", controllDeadBotsCheck, "RIGHT", 5, 0)
controllDeadBotsCheck.text:SetText("Dead Control")
controllDeadBotsCheck:SetChecked(true)  
controllDeadBotsCheck:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Allows you to control bots even after dying.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)

controllDeadBotsCheck:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)


controllDeadBotsCheck:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()
    TogglecontrollDeadBotsCheck(PCPFrameRemake, isChecked)
    SaveSettings(defaultColor, nil, nil, isChecked)  
end)



local macroModeCheck = CreateFrame("CheckButton", "PCPmacroModeCheck", settingsFrame, "UICheckButtonTemplate")
macroModeCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -130)
macroModeCheck.text = macroModeCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
macroModeCheck.text:SetPoint("LEFT", macroModeCheck, "RIGHT", 5, 0)
macroModeCheck.text:SetText("Macro Mode")
macroModeCheck:SetChecked(false)
macroModeCheck:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Click PCP buttons to insert commands into the focused macro body instead of sending them to your bots.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
macroModeCheck:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
macroModeCheck:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()
    ToggleMacroModeCheck(PCPFrameRemake, isChecked)
end)



local paladinBuffRotationCheck = CreateFrame("CheckButton", "PCPPaladinBuffRotationCheck", settingsFrame, "UICheckButtonTemplate")
paladinBuffRotationCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -160)
paladinBuffRotationCheck.text = paladinBuffRotationCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
paladinBuffRotationCheck.text:SetPoint("LEFT", paladinBuffRotationCheck, "RIGHT", 5, 0)
paladinBuffRotationCheck.text:SetText("Paladin buff rotation")
paladinBuffRotationCheck:SetChecked(true)
paladinBuffRotationCheck:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Automatically rotates blessings when adding Paladins. Each new Paladin gets the currently shown blessing, then the selector moves to the next blessing (BoK -> BoM -> BoW -> BoL -> BoS). Default is skipped while enabled.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
paladinBuffRotationCheck:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
paladinBuffRotationCheck:SetScript("OnClick", function(self)
    if not PCP_Settings then PCP_Settings = {} end
    PCP_Settings.paladinBuffRotation = self:GetChecked() and true or false
    if PCP_NormalizePaladinBlessingForRotation then
        PCP_NormalizePaladinBlessingForRotation()
    end
    if PCP_UpdateSpawnConfigButtonText then
        PCP_UpdateSpawnConfigButtonText()
    end
    if PCP_RefreshSpawnOptionsFrame and PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown() then
        PCP_RefreshSpawnOptionsFrame()
    end
end)



local freeSectionLayoutCheck = CreateFrame("CheckButton", "PCPFreeSectionLayoutCheck", settingsFrame, "UICheckButtonTemplate")
freeSectionLayoutCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -190)
freeSectionLayoutCheck.text = freeSectionLayoutCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
freeSectionLayoutCheck.text:SetPoint("LEFT", freeSectionLayoutCheck, "RIGHT", 5, 0)
freeSectionLayoutCheck.text:SetText("Free section layout")
freeSectionLayoutCheck:SetChecked(false)
freeSectionLayoutCheck:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Enable this, then hold ALT + drag a section background to move it. Positions are saved.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
freeSectionLayoutCheck:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
freeSectionLayoutCheck:SetScript("OnClick", function(self)
    if not PCP_Settings then PCP_Settings = {} end
    PCP_Settings.freeSectionLayout = self:GetChecked() and true or false
    if ApplyPCPSectionLayout then
        ApplyPCPSectionLayout(PCPFrameRemake)
    end
    if PCP_UpdateFreeBackdropMode then
        PCP_UpdateFreeBackdropMode()
    end
end)


local snapSectionLayoutCheck = CreateFrame("CheckButton", "PCPSnapSectionLayoutCheck", settingsFrame, "UICheckButtonTemplate")
snapSectionLayoutCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -220)
snapSectionLayoutCheck.text = snapSectionLayoutCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
snapSectionLayoutCheck.text:SetPoint("LEFT", snapSectionLayoutCheck, "RIGHT", 5, 0)
snapSectionLayoutCheck.text:SetText("Snap sections")
snapSectionLayoutCheck:SetChecked(false)
snapSectionLayoutCheck:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("When Free section layout is enabled, dropped sections snap to a 20 px grid.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
snapSectionLayoutCheck:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
snapSectionLayoutCheck:SetScript("OnClick", function(self)
    if not PCP_Settings then PCP_Settings = {} end
    PCP_Settings.snapSectionLayout = self:GetChecked() and true or false
    if PCP_Settings.snapSectionLayout and PCP_SnapAllSectionsToGrid then
        PCP_SnapAllSectionsToGrid()
    end
end)


local resizableSectionsCheck = CreateFrame("CheckButton", "PCPResizableSectionsCheck", settingsFrame, "UICheckButtonTemplate")
resizableSectionsCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -250)
resizableSectionsCheck.text = resizableSectionsCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
resizableSectionsCheck.text:SetPoint("LEFT", resizableSectionsCheck, "RIGHT", 5, 0)
resizableSectionsCheck.text:SetText("Resizable sections")
resizableSectionsCheck:SetChecked(false)
resizableSectionsCheck:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Shows a small bottom-right resize grip on each section. Section sizes are saved individually.", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
resizableSectionsCheck:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
resizableSectionsCheck:SetScript("OnClick", function(self)
    if not PCP_Settings then PCP_Settings = {} end
    PCP_Settings.resizableSections = self:GetChecked() and true or false
    if PCP_UpdateSectionResizeMode then
        PCP_UpdateSectionResizeMode()
    end
    if ApplyPCPSectionLayout then
        ApplyPCPSectionLayout(PCPFrameRemake)
    end
end)


local resetSectionLayoutButton = CreateFrame("Button", "PCPResetSectionLayoutButton", settingsFrame, "UIPanelButtonTemplate")
resetSectionLayoutButton:SetSize(150, 22)
resetSectionLayoutButton:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 25, -285)
resetSectionLayoutButton:SetText("Reset section layout")
resetSectionLayoutButton:SetScript("OnClick", function()
    if ResetPCPSectionPositions then
        ResetPCPSectionPositions()
    end
end)
PCP_RegisterThemedButton(resetSectionLayoutButton)


local sectionVisibilityButton = CreateFrame("Button", "PCPSectionVisibilityButton", settingsFrame, "UIPanelButtonTemplate")
sectionVisibilityButton:SetSize(150, 22)
sectionVisibilityButton:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 25, -315)
sectionVisibilityButton:SetText("Visible sections")
sectionVisibilityButton:SetScript("OnClick", function()
    
    
    if PCP_ShowSectionOptions then
        PCP_ShowSectionOptions(true)
    end

    if PCPSectionOptionsFrame then
        if PCPSectionOptionsFrame.SetFrameStrata then PCPSectionOptionsFrame:SetFrameStrata("FULLSCREEN_DIALOG") end
        if PCPSectionOptionsFrame.SetFrameLevel then PCPSectionOptionsFrame:SetFrameLevel(220) end
        if PCPSectionOptionsFrame.SetToplevel then PCPSectionOptionsFrame:SetToplevel(true) end
        PCPSectionOptionsFrame:Show()
        if PCPSectionOptionsFrame.Raise then PCPSectionOptionsFrame:Raise() end
    end
end)
PCP_RegisterThemedButton(sectionVisibilityButton)


PCPCustomFramesButton = CreateFrame("Button", "PCPCustomFramesButton", settingsFrame, "UIPanelButtonTemplate")
PCPCustomFramesButton:SetSize(150, 22)
PCPCustomFramesButton:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 25, -345)
PCPCustomFramesButton:SetText("Custom frames")
PCPCustomFramesButton:SetScript("OnClick", function()
    
    if settingsFrame then settingsFrame:Hide() end
    if ClickBlockerFrame then ClickBlockerFrame:Hide() end
    if PCP_ShowCustomFramesEditor then
        PCP_ShowCustomFramesEditor()
    end
    if PCP_RefreshCustomFramesTheme then
        PCP_RefreshCustomFramesTheme()
    end
end)
PCP_RegisterThemedButton(PCPCustomFramesButton)


function PCP_UpdateSettingsFrameSize()
    if not settingsFrame then return end

    local maxDepth = 0
    local rows = {
        { colorDropdown, 10, 34 },
        { backdropCheck, 40, 26 },
        { titlesBgCheck, 70, 26 },
        { controllDeadBotsCheck, 100, 26 },
        { macroModeCheck, 130, 26 },
        { paladinBuffRotationCheck, 160, 26 },
        { freeSectionLayoutCheck, 190, 26 },
        { snapSectionLayoutCheck, 220, 26 },
        { resizableSectionsCheck, 250, 26 },
        { resetSectionLayoutButton, 285, 22 },
        { sectionVisibilityButton, 315, 22 },
        { PCPCustomFramesButton, 345, 22 },
    }

    for _, row in ipairs(rows) do
        local obj = row[1]
        local y = row[2]
        local h = row[3]
        if obj and (not obj.IsShown or obj:IsShown()) then
            local depth = y + h + 22
            if depth > maxDepth then maxDepth = depth end
        end
    end

    if maxDepth < 180 then maxDepth = 180 end
    settingsFrame:SetHeight(maxDepth)
    settingsFrame:SetWidth(230)

    if versionText then
        versionText:ClearAllPoints()
        versionText:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -10, 10)
    end
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
        if colorDropdown then
            local selectedThemeName = nil
            for _, option in ipairs(colorOptions) do
                if option.color == defaultColor or (defaultColor == "DathW" and option.color == "dathw") then
                    selectedThemeName = option.text
                end
            end
            if selectedThemeName then
                UIDropDownMenu_SetSelectedName(colorDropdown, selectedThemeName)
            end
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
            paladinBuffRotationCheck:SetChecked(PCP_Settings.paladinBuffRotation == true)
        end

        if PCP_Settings.freeSectionLayout ~= nil then
            freeSectionLayoutCheck:SetChecked(PCP_Settings.freeSectionLayout)
        end
        if PCP_Settings.snapSectionLayout ~= nil then
            snapSectionLayoutCheck:SetChecked(PCP_Settings.snapSectionLayout)
        end
        if PCP_Settings.resizableSections ~= nil then
            resizableSectionsCheck:SetChecked(PCP_Settings.resizableSections)
        end		
    else
        if not PCP_Settings then PCP_Settings = {} end
        PCP_Settings.paladinBuffRotation = true
        if paladinBuffRotationCheck then
            paladinBuffRotationCheck:SetChecked(true)
        end
    end

    if PCP_NormalizePaladinBlessingForRotation then
        PCP_NormalizePaladinBlessingForRotation()
    end

    
    if PCP_ApplySectionVisibility then
        PCP_ApplySectionVisibility()
    end

    toggleButtonAppearance(true, defaultColor)
    if PCP_UpdateSettingsFrameSize then
        PCP_UpdateSettingsFrameSize()
    end
    if PCP_UpdateFreeBackdropMode then
        PCP_UpdateFreeBackdropMode()
    end
end


function createButton(name, text, xOffset, yOffset, onClickFunc, width, height, parentFrame)
    local button

        button = CreateFrame("Button", name, parentFrame)
        local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
        fontString:SetPoint("CENTER")
        button:SetFontString(fontString) 


    button:SetSize(width, height)
    button:SetPoint("CENTER", parentFrame, "CENTER", xOffset, yOffset)
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

    
    PCP_RegisterThemedButton(button)

    
    if parentFrame == ComeCommandFrame then 
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Come " .. text .. " ")
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    elseif parentFrame == MoveCommandFrame then 
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Move " .. text .. " ")
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)    
    elseif parentFrame == StayCommandFrame then 
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Stay " .. text .. " ")
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    return button
end





local PCPGradientAnimFrame = CreateFrame("Frame")
PCPGradientAnimFrame.enabled = false
PCPGradientAnimFrame.elapsed = 0
PCPGradientAnimFrame.phase = 0
PCPGradientAnimFrame:SetScript("OnUpdate", function(self, elapsed)
    if not self.enabled then return end

    self.elapsed = (self.elapsed or 0) + (elapsed or 0)
    if self.elapsed < 0.05 then return end

    self.phase = (self.phase or 0) + self.elapsed
    self.elapsed = 0

    local pulse = (math.sin(self.phase * 1.25) + 1) * 0.5
    local topBoost = 0.010 + (pulse * 0.025)
    local bottomBoost = 0.004 + (pulse * 0.010)
    local anyVisible = false

    for _, button in ipairs(allButtons) do
        if button and button._pcpThemeGradientTop and button._pcpThemeGradientTop:IsShown() and button._pcpThemeGradTopBase then
            local t = button._pcpThemeGradTopBase
            button._pcpThemeGradientTop:SetVertexColor(t[1], t[2], t[3], math.min(1, t[4] + topBoost))
            anyVisible = true
        end

        if button and button._pcpThemeGradientBottom and button._pcpThemeGradientBottom:IsShown() and button._pcpThemeGradBottomBase then
            local b = button._pcpThemeGradBottomBase
            button._pcpThemeGradientBottom:SetVertexColor(b[1], b[2], b[3], math.min(1, b[4] + bottomBoost))
            anyVisible = true
        end
    end

    if not anyVisible then
        self.enabled = false
    end
end)


function toggleButtonAppearance(enabled, color)
    isCustomAppearanceEnabled = enabled
    color = color or defaultColor or "originalButtons"
    defaultColor = color
    SaveSettings(color)

    
    
    if backdropCheck then
        ToggleBackdrop(PCPFrameRemake, backdropCheck:GetChecked())
    end
    if PCP_UpdateFreeBackdropMode then
        PCP_UpdateFreeBackdropMode()
    end

    local dathw = (color == "dathw" or color == "DathW")
    local useGradient = false
    local anyAnimatedGradient = false

    for _, button in ipairs(allButtons) do
        if button then PCP_HideUIPanelButtonTemplateChrome(button) end
        
        
        
        if button._pcpThemeBg then button._pcpThemeBg:Hide() end
        if button._pcpThemeGradientTop then button._pcpThemeGradientTop:Hide() end
        if button._pcpThemeGradientBottom then button._pcpThemeGradientBottom:Hide() end
        if button._pcpThemeHoverGradientTop then button._pcpThemeHoverGradientTop:Hide() end
        if button._pcpThemeHoverGradientBottom then button._pcpThemeHoverGradientBottom:Hide() end
        if button._pcpThemeBorder then button._pcpThemeBorder:Hide() end
        if button._pcpThemeHighlight then button._pcpThemeHighlight:Hide() end
        button._pcpThemeGradTopBase = nil
        button._pcpThemeGradBottomBase = nil
        if button._pcpThemePushed then button._pcpThemePushed:Hide() end
        if button._pcpOriginalNormal then button._pcpOriginalNormal:Hide() end
        if button._pcpOriginalHighlight then button._pcpOriginalHighlight:Hide() end
        if button._pcpOriginalPushed then button._pcpOriginalPushed:Hide() end
        if button._pcpOriginalDisabled then button._pcpOriginalDisabled:Hide() end
        if button._pcpSettingsIcon then button._pcpSettingsIcon:Hide() end
        if button._pcpCloseIcon then button._pcpCloseIcon:Hide() end

        button:SetNormalTexture(nil)
        button:SetHighlightTexture(nil)
        button:SetPushedTexture(nil)
        button:SetDisabledTexture(nil)

        local fs = button.GetFontString and button:GetFontString()
        local theme = PCP_GetThemeColors(color)
        useGradient = (theme and theme.gradTop and theme.gradBottom) and true or false
        if fs then
            if theme and theme.text then
                fs:SetTextColor(theme.text[1], theme.text[2], theme.text[3], theme.text[4])
            else
                fs:SetTextColor(1, 1, 1, 1)
            end
        end

        if color == "originalButtons" then
            
            if button._pcpThemePushed then
                button._pcpThemePushed:SetVertexColor(1, 1, 1, 1)
            end
            if button._pcpThemeHighlight then
                button._pcpThemeHighlight:SetVertexColor(1, 1, 1, 0)
            end

            if not button._pcpOriginalNormal then
                button._pcpOriginalNormal = button:CreateTexture(nil, "ARTWORK")
                button._pcpOriginalNormal:SetAllPoints(button)
            end
            
            
            
            button._pcpOriginalNormal:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
            button._pcpOriginalNormal:SetTexCoord(0, 0.625, 0, 0.6875)
            button._pcpOriginalNormal:SetVertexColor(1, 1, 1, 1)
            button._pcpOriginalNormal:Show()
            button:SetNormalTexture(button._pcpOriginalNormal)

            if not button._pcpOriginalHighlight then
                button._pcpOriginalHighlight = button:CreateTexture(nil, "HIGHLIGHT")
                button._pcpOriginalHighlight:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                button._pcpOriginalHighlight:SetTexCoord(0, 0.625, 0, 0.6875)
                button._pcpOriginalHighlight:SetAllPoints(button)
            end
            button._pcpOriginalHighlight:SetVertexColor(1, 1, 1, 0.15)
            button._pcpOriginalHighlight:Show()
            button:SetHighlightTexture(button._pcpOriginalHighlight)

            if not button._pcpOriginalPushed then
                button._pcpOriginalPushed = button:CreateTexture(nil, "PUSHED")
                button._pcpOriginalPushed:SetAllPoints(button)
            end
            button._pcpOriginalPushed:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
            button._pcpOriginalPushed:SetTexCoord(0, 0.625, 0, 0.6875)
            button._pcpOriginalPushed:SetVertexColor(1, 1, 1, 1)
            button._pcpOriginalPushed:Show()
            button:SetPushedTexture(button._pcpOriginalPushed)

            if not button._pcpOriginalDisabled then
                button._pcpOriginalDisabled = button:CreateTexture(nil, "DISABLED")
                button._pcpOriginalDisabled:SetAllPoints(button)
            end
            button._pcpOriginalDisabled:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
            button._pcpOriginalDisabled:SetTexCoord(0, 0.625, 0, 0.6875)
            button._pcpOriginalDisabled:SetVertexColor(1, 1, 1, 1)
            button._pcpOriginalDisabled:Show()
            button:SetDisabledTexture(button._pcpOriginalDisabled)
        else
            if not button._pcpThemeBg then
                button._pcpThemeBg = button:CreateTexture(nil, "BACKGROUND")
                button._pcpThemeBg:SetAllPoints(button)
                button._pcpThemeBg:SetTexture("Interface\\AddOns\\PCP\\img\\bg.tga")
            end
            local bgTexture = button._pcpThemeBg
            bgTexture:Show()

            if theme and theme.bg then
                bgTexture:SetVertexColor(theme.bg[1], theme.bg[2], theme.bg[3], theme.bg[4])
            elseif color == "pink" then
                bgTexture:SetVertexColor(1, 0.75, 0.8, 0.1)
            elseif color == "solidpink" then
                bgTexture:SetVertexColor(1, 0.75, 0.8, 1)
            elseif color == "green" then
                bgTexture:SetVertexColor(0.25, 0.55, 0.25, 0.15)
            elseif color == "solidgreen" then
                bgTexture:SetVertexColor(0, 0.6, 0, 1)
            elseif color == "blue" then
                bgTexture:SetVertexColor(0, 0, 1, 0.1)
            elseif color == "solidblue" then
                bgTexture:SetVertexColor(0, 0, 1, 1)
            elseif color == "gray" then
                bgTexture:SetVertexColor(0.5, 0.5, 0.5, 0.2)
            elseif color == "solidgray" then
                bgTexture:SetVertexColor(0.5, 0.5, 0.5, 1)
            elseif color == "black" then
                bgTexture:SetVertexColor(0, 0, 0, 0.5)
            else
                bgTexture:SetVertexColor(0, 0, 0, 1)
            end

            
            
            
            
            if theme and theme.gradTop and useGradient then
                if not button._pcpThemeGradientTop then
                    button._pcpThemeGradientTop = button:CreateTexture(nil, "BACKGROUND")
                    button._pcpThemeGradientTop:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                    if button._pcpThemeGradientTop.SetBlendMode then
                        button._pcpThemeGradientTop:SetBlendMode("BLEND")
                    end
                end
                if button._pcpThemeGradientTop.SetDrawLayer then
                    button._pcpThemeGradientTop:SetDrawLayer("ARTWORK")
                end
                button._pcpThemeGradientTop:ClearAllPoints()
                button._pcpThemeGradientTop:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
                button._pcpThemeGradientTop:SetPoint("BOTTOMRIGHT", button, "RIGHT", -1, 0)
                button._pcpThemeGradTopBase = { theme.gradTop[1], theme.gradTop[2], theme.gradTop[3], theme.gradTop[4] }
                button._pcpThemeGradientTop:SetVertexColor(theme.gradTop[1], theme.gradTop[2], theme.gradTop[3], theme.gradTop[4])
                button._pcpThemeGradientTop:Show()
                anyAnimatedGradient = true
            end
            if theme and theme.gradBottom and useGradient then
                if not button._pcpThemeGradientBottom then
                    button._pcpThemeGradientBottom = button:CreateTexture(nil, "BACKGROUND")
                    button._pcpThemeGradientBottom:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                    if button._pcpThemeGradientBottom.SetBlendMode then
                        button._pcpThemeGradientBottom:SetBlendMode("BLEND")
                    end
                end
                if button._pcpThemeGradientBottom.SetDrawLayer then
                    button._pcpThemeGradientBottom:SetDrawLayer("ARTWORK")
                end
                button._pcpThemeGradientBottom:ClearAllPoints()
                button._pcpThemeGradientBottom:SetPoint("TOPLEFT", button, "LEFT", 1, 0)
                button._pcpThemeGradientBottom:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
                button._pcpThemeGradBottomBase = { theme.gradBottom[1], theme.gradBottom[2], theme.gradBottom[3], theme.gradBottom[4] }
                button._pcpThemeGradientBottom:SetVertexColor(theme.gradBottom[1], theme.gradBottom[2], theme.gradBottom[3], theme.gradBottom[4])
                button._pcpThemeGradientBottom:Show()
                anyAnimatedGradient = true
            end

            if not button._pcpThemeBorder then
                button._pcpThemeBorder = CreateFrame("Frame", nil, button, "BackdropTemplate")
                
                
                
                button._pcpThemeBorder:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
                button._pcpThemeBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
                button._pcpThemeBorder:SetBackdrop({
                    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                    edgeSize = 5,
                    insets = { left = 1, right = 1, top = 1, bottom = 1 },
                })
                button._pcpThemeBorder:SetFrameLevel(button:GetFrameLevel() + 1)
            end
            button._pcpThemeBorder:Show()

            
            
            if theme and theme.border then
                button._pcpThemeBorder:SetBackdropBorderColor(theme.border[1], theme.border[2], theme.border[3], theme.border[4])
            elseif color == "pink" then
                button._pcpThemeBorder:SetBackdropBorderColor(1.00, 0.55, 0.70, 0.55)
            elseif color == "solidpink" then
                button._pcpThemeBorder:SetBackdropBorderColor(1.00, 0.55, 0.70, 0.85)
            elseif color == "green" then
                button._pcpThemeBorder:SetBackdropBorderColor(0.35, 0.75, 0.35, 0.55)
            elseif color == "solidgreen" then
                button._pcpThemeBorder:SetBackdropBorderColor(0.35, 0.85, 0.35, 0.85)
            elseif color == "blue" then
                button._pcpThemeBorder:SetBackdropBorderColor(0.35, 0.55, 1.00, 0.55)
            elseif color == "solidblue" then
                button._pcpThemeBorder:SetBackdropBorderColor(0.35, 0.55, 1.00, 0.85)
            elseif color == "gray" then
                button._pcpThemeBorder:SetBackdropBorderColor(0.70, 0.70, 0.70, 0.55)
            elseif color == "solidgray" then
                button._pcpThemeBorder:SetBackdropBorderColor(0.80, 0.80, 0.80, 0.85)
            elseif color == "black" then
                button._pcpThemeBorder:SetBackdropBorderColor(0.25, 0.25, 0.25, 0.85)
            else
                button._pcpThemeBorder:SetBackdropBorderColor(0.65, 0.55, 0.25, 0.60)
            end
        end

        if button.iconTexture then
            button.iconTexture:SetDrawLayer("OVERLAY")
        end

        if button == settingsButton then
            if not button._pcpSettingsIcon then
                button._pcpSettingsIcon = button:CreateTexture(nil, "OVERLAY")
                button._pcpSettingsIcon:SetTexture("Interface/AddOns/PCP/img/settings.tga")
                button._pcpSettingsIcon:SetPoint("CENTER", button, "CENTER", 0, 0)
                button._pcpSettingsIcon:SetDrawLayer("OVERLAY")
            end
            button._pcpSettingsIcon:SetWidth(12)
            button._pcpSettingsIcon:SetHeight(12)
            button._pcpSettingsIcon:Show()
        elseif button == closeButton then
            if not button._pcpCloseIcon then
                button._pcpCloseIcon = button:CreateTexture(nil, "OVERLAY")
                button._pcpCloseIcon:SetTexture("Interface/AddOns/PCP/img/close.tga")
                button._pcpCloseIcon:SetPoint("CENTER", button, "CENTER", 0, 0)
                button._pcpCloseIcon:SetDrawLayer("OVERLAY")
            end
            button._pcpCloseIcon:SetWidth(10)
            button._pcpCloseIcon:SetHeight(10)
            button._pcpCloseIcon:Show()
        end

        if color ~= "originalButtons" then
            if not button._pcpThemeHighlight then
                button._pcpThemeHighlight = button:CreateTexture(nil, "HIGHLIGHT")
                button._pcpThemeHighlight:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                button._pcpThemeHighlight:SetAllPoints(button)
                button._pcpThemeHighlight:SetDrawLayer("HIGHLIGHT")
            end
            if theme and theme.highlight then
                
                
                button._pcpThemeHighlight:SetVertexColor(theme.highlight[1], theme.highlight[2], theme.highlight[3], math.min(1, (theme.highlight[4] or 0.12) + 0.08))
            else
                button._pcpThemeHighlight:SetVertexColor(1, 1, 0, 0.18)
            end
            button._pcpThemeHighlight:Show()

            
            
            
            if theme and theme.gradTop and useGradient then
                if not button._pcpThemeHoverGradientTop then
                    button._pcpThemeHoverGradientTop = button:CreateTexture(nil, "HIGHLIGHT")
                    button._pcpThemeHoverGradientTop:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                    if button._pcpThemeHoverGradientTop.SetBlendMode then
                        button._pcpThemeHoverGradientTop:SetBlendMode("ADD")
                    end
                end
                button._pcpThemeHoverGradientTop:ClearAllPoints()
                button._pcpThemeHoverGradientTop:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
                button._pcpThemeHoverGradientTop:SetPoint("BOTTOMRIGHT", button, "RIGHT", -1, 0)
                button._pcpThemeHoverGradientTop:SetVertexColor(theme.gradTop[1], theme.gradTop[2], theme.gradTop[3], math.min(1, (theme.gradTop[4] or 0.15) + 0.12))
                button._pcpThemeHoverGradientTop:Show()
            end
            if theme and theme.gradBottom and useGradient then
                if not button._pcpThemeHoverGradientBottom then
                    button._pcpThemeHoverGradientBottom = button:CreateTexture(nil, "HIGHLIGHT")
                    button._pcpThemeHoverGradientBottom:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
                    if button._pcpThemeHoverGradientBottom.SetBlendMode then
                        button._pcpThemeHoverGradientBottom:SetBlendMode("BLEND")
                    end
                end
                button._pcpThemeHoverGradientBottom:ClearAllPoints()
                button._pcpThemeHoverGradientBottom:SetPoint("TOPLEFT", button, "LEFT", 1, 0)
                button._pcpThemeHoverGradientBottom:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
                button._pcpThemeHoverGradientBottom:SetVertexColor(theme.gradBottom[1], theme.gradBottom[2], theme.gradBottom[3], math.min(1, (theme.gradBottom[4] or 0.15) + 0.04))
                button._pcpThemeHoverGradientBottom:Show()
            end

            button:SetHighlightTexture(button._pcpThemeHighlight)

            if not button._pcpThemePushed then
                button._pcpThemePushed = button:CreateTexture(nil, "PUSHED")
                button._pcpThemePushed:SetTexture("Interface/AddOns/PCP/img/bg.tga")
                button._pcpThemePushed:SetAllPoints(button)
            end
            if theme and theme.pushed then
                button._pcpThemePushed:SetVertexColor(theme.pushed[1], theme.pushed[2], theme.pushed[3], theme.pushed[4])
            else
                button._pcpThemePushed:SetVertexColor(0.8, 0.2, 0.2, 1)
            end
            button._pcpThemePushed:Show()
            button:SetPushedTexture(button._pcpThemePushed)
        end

        if button._pcpTransparentIconButton and PCP_ClearSpawnConfigButtonTextures then
            PCP_ClearSpawnConfigButtonTextures(button)
        end
    end

    if PCPGradientAnimFrame then
        PCPGradientAnimFrame.enabled = (color ~= "originalButtons" and anyAnimatedGradient) and true or false
        PCPGradientAnimFrame.elapsed = 0
    end
    if PCP_RefreshCustomFramesTheme then
        PCP_RefreshCustomFramesTheme()
    end
end

SLASH_TOGGLEBUTTON1 = "/tgl"
SlashCmdList["TOGGLEBUTTON"] = function(msg)
    local color = msg:match("^(%S+)")  

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








	
	local addBotFrame = CreateFrame("Frame", "AddBotFrame", frame)
	addBotFrame:SetSize(300, 100)  
	addBotFrame:SetPoint("TOP", frame, "TOP", 0, -10)  

	
	addBotFrame.bg = addBotFrame:CreateTexture(nil, "BACKGROUND")
	addBotFrame.bg:SetAllPoints(true)
	


	





	
function createClassRoleButton(name, text, xOffset, yOffset, onClickFunc, width, height, parentFrame)
    local button

        button = CreateFrame("Button", name, parentFrame)
        local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
        fontString:SetPoint("CENTER")
        button:SetFontString(fontString) 


    button:SetSize(width, height)
    button:SetPoint("CENTER", parentFrame, "CENTER", xOffset, yOffset)
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

    
    button:Hide()

    
    PCP_RegisterThemedButton(button)

    return button
end




classButton = createClassRoleButton("ClassButton", "Warrior", 0, 20, function() print("Warrior class selected!") end, 80, 30, addBotFrame)
classButton:Show()

roleButton = createClassRoleButton("RoleButton", "Tank", 0, -30, function() SubPartyBotAddAdvanced() end, 80, 30, addBotFrame)
roleButton:Show()
        roleButton:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Click to add", 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
		roleButton:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
	
local function PCP_SetArrowButtonVisual(button, direction)
    if not button then return end

    local normalTexture = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up"
    local pushedTexture = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down"
    if direction == "prev" then
        normalTexture = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up"
        pushedTexture = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down"
    end

    button:SetText("")
    button:SetNormalTexture(normalTexture)
    button:SetPushedTexture(pushedTexture)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

    if not button.iconTexture then
        button.iconTexture = button:CreateTexture(nil, "OVERLAY")
        button.iconTexture:SetAllPoints(button)
    end
    button.iconTexture:SetTexture(normalTexture)
    button.iconTexture:SetTexCoord(0, 1, 0, 1)
    button.iconTexture:Show()
end

SetClassADDButton = createButton("SetClassADDButton", "", 58, 10, function() SetClassADD() end, 30, 30, addBotFrame)
SetClassSUBButton = createButton("SetClassSUBButton", "", -58, 10, function() SetClassSUB() end, 30, 30, addBotFrame)

SetRoleADDButton = createButton("SetRoleADDButton", "", 58, -10, function() SetRoleADD() end, 30, 30, addBotFrame)
SetRoleSUBButton = createButton("SetRoleSUBButton", "", -58, -10, function() SetRoleSUB() end, 30, 30, addBotFrame)

PCP_SetArrowButtonVisual(SetClassADDButton, "next")
PCP_SetArrowButtonVisual(SetClassSUBButton, "prev")
PCP_SetArrowButtonVisual(SetRoleADDButton, "next")
PCP_SetArrowButtonVisual(SetRoleSUBButton, "prev")

    
    
    PCPPaladinBlessings = { "Default", "BoK", "BoM", "BoW", "BoL", "BoS" }
    PCPPaladinBlessingItr = 1

    PCPMageSpecs = { "fire", "frost" }
    PCPMageSpecItr = 1

    PCPShamanTotems = {
        
        
        air   = { "windfury", "graceofair", "tranquilair", "natureresistance" },
        earth = { "strengthofearth", "stoneskin", "earthbind", "tremor" },
        fire  = { "searing", "magma", "firenova", "flametongue", "frostresistance" },
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

    PCPMageSpecIcons = {
        fire = "Interface\\Icons\\Spell_Fire_FlameBolt",
        frost = "Interface\\Icons\\Spell_Frost_FrostBolt02",
    }

    PCPTotemIcons = {
        windfury = "Interface\\Icons\\Spell_Nature_Windfury",
        graceofair = "Interface\\Icons\\Spell_Nature_InvisibilityTotem",
        tranquilair = "Interface\\Icons\\Spell_Nature_Brilliance",
        natureresistance = "Interface\\Icons\\Spell_Nature_NatureResistanceTotem",
        strengthofearth = "Interface\\Icons\\Spell_Nature_EarthBindTotem",
        stoneskin = "Interface\\Icons\\Spell_Nature_StoneSkinTotem",
        earthbind = "Interface\\Icons\\Spell_Nature_StrengthOfEarthTotem02",
        tremor = "Interface\\Icons\\Spell_Nature_TremorTotem",
        searing = "Interface\\Icons\\Spell_Fire_SearingTotem",
        magma = "Interface\\Icons\\Spell_Fire_SelfDestruct",
        firenova = "Interface\\Icons\\Spell_Fire_SealOfFire",
        flametongue = "Interface\\Icons\\Spell_Nature_GuardianWard",
        frostresistance = "Interface\\Icons\\Spell_FrostResistanceTotem_01",
        manaspring = "Interface\\Icons\\Spell_Nature_ManaRegenTotem",
        healingstream = "Interface\\Icons\\INV_Spear_04",
        poisoncleansing = "Interface\\Icons\\Spell_Nature_PoisonCleansingTotem",
        diseasecleansing = "Interface\\Icons\\Spell_Nature_DiseaseCleansingTotem",
        fireresistance = "Interface\\Icons\\Spell_FireResistanceTotem_01",
        manatide = "Interface\\Icons\\Spell_Frost_SummonWaterElemental",
    }

    local function PCP_GetSpawnIconPath(kind, value)
        if kind == "paladin" then
            return PCPBlessingIcons[value or "Default"] or PCPBlessingIcons.Default
        elseif kind == "mage" then
            return PCPMageSpecIcons[value or "fire"] or PCPMageSpecIcons.fire or "Interface\\Icons\\INV_Misc_QuestionMark"
        end
        return PCPTotemIcons[value or ""] or "Interface\\Icons\\Spell_Nature_Windfury"
    end

    local PCP_HideButtonTotemIcons

    local function PCP_SetButtonIcon(button, texturePath, size)
        if not button then return end
        PCP_HideButtonTotemIcons(button)
        if not button._pcpSpawnIcon then
            button._pcpSpawnIcon = button:CreateTexture(nil, "OVERLAY")
            button._pcpSpawnIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        end
        size = size or 18
        button._pcpSpawnIcon:ClearAllPoints()
        button._pcpSpawnIcon:SetPoint("CENTER", button, "CENTER", 0, 0)
        button._pcpSpawnIcon:SetWidth(size)
        button._pcpSpawnIcon:SetHeight(size)
        button._pcpSpawnIcon:SetTexture(texturePath or "Interface\\Icons\\INV_Misc_QuestionMark")
        button._pcpSpawnIcon:Show()

        
        local fs = button.GetFontString and button:GetFontString()
        if fs then
            fs:SetText("")
            fs:ClearAllPoints()
            fs:SetPoint("CENTER", button, "CENTER", 0, 0)
        end
    end

    PCP_HideButtonTotemIcons = function(button)
        if not button or not button._pcpTotemIcons then return end
        for _, tex in ipairs(button._pcpTotemIcons) do
            if tex then tex:Hide() end
        end
    end

    local function PCP_SetButtonTotemIcons(button, airPath, earthPath, firePath, waterPath, size)
        if not button then return end

        
        if button._pcpSpawnIcon then
            button._pcpSpawnIcon:Hide()
            button._pcpSpawnIcon:SetTexture(nil)
            button._pcpSpawnIcon:SetWidth(1)
            button._pcpSpawnIcon:SetHeight(1)
        end

        if not button._pcpTotemIcons then button._pcpTotemIcons = {} end

        local paths = { airPath, earthPath, firePath, waterPath }
        size = size or 14
        local gap = button._pcpIconGap or 2
        local offset = (size + gap) / 2
        local positions = {
            { -offset,  offset }, 
            {  offset,  offset }, 
            { -offset, -offset }, 
            {  offset, -offset }, 
        }

        for i = 1, 4 do
            if not button._pcpTotemIcons[i] then
                button._pcpTotemIcons[i] = button:CreateTexture(nil, "OVERLAY")
                button._pcpTotemIcons[i]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end
            local tex = button._pcpTotemIcons[i]
            tex:ClearAllPoints()
            tex:SetPoint("CENTER", button, "CENTER", positions[i][1], positions[i][2])
            tex:SetWidth(size)
            tex:SetHeight(size)
            tex:SetTexture(paths[i] or "Interface\\Icons\\INV_Misc_QuestionMark")
            tex:Show()
        end

        local fs = button.GetFontString and button:GetFontString()
        if fs then
            fs:SetText("")
            fs:ClearAllPoints()
            fs:SetPoint("CENTER", button, "CENTER", 0, 0)
        end
    end

    local function PCP_ClearSpawnConfigButtonTextures(button)
        if not button then return end

        button:SetNormalTexture(nil)
        button:SetHighlightTexture(nil)
        button:SetPushedTexture(nil)
        button:SetDisabledTexture(nil)

        local layers = {
            "_pcpOriginalNormal",
            "_pcpOriginalHighlight",
            "_pcpOriginalPushed",
            "_pcpOriginalDisabled",
            "_pcpThemeBg",
            "_pcpThemeGradientTop",
            "_pcpThemeGradientBottom",
            "_pcpThemeBorder",
            "_pcpThemeHighlight",
            "_pcpThemePushed",
        }

        for _, key in ipairs(layers) do
            local layer = button[key]
            if layer and layer.Hide then
                layer:Hide()
            end
        end

        
        
    end

    local function PCP_SetRowIcon(row, texturePath, size)
        if not row then return end
        if not row.icon then
            row.icon = row:CreateTexture(nil, "OVERLAY")
            row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        end
        size = size or 16
        row.icon:SetWidth(size)
        row.icon:SetHeight(size)
        row.icon:SetTexture(texturePath or "Interface\\Icons\\INV_Misc_QuestionMark")
        row.icon:Show()
        return row.icon
    end

    local function PCP_SetSpawnOptionTooltip(button, text)
        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(text, 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        button:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    local function PCP_CapitalizeFirst(text)
        if not text or text == "" then return "" end
        return string.upper(string.sub(text, 1, 1)) .. string.sub(text, 2)
    end

    local function PCP_GetPaladinBlessingText()
        if not PCPPaladinBlessings then return "Default" end
        return PCPPaladinBlessings[PCPPaladinBlessingItr or 1] or "Default"
    end

    local function PCP_GetMageSpecText()
        if not PCPMageSpecs then return "fire" end
        return PCPMageSpecs[PCPMageSpecItr or 1] or "fire"
    end

    function PCP_IsPaladinBuffRotationEnabled()
        if PCP_Settings and PCP_Settings.paladinBuffRotation ~= nil then
            return PCP_Settings.paladinBuffRotation == true
        end
        return true
    end

    function PCP_NormalizePaladinBlessingForRotation()
        if not PCP_IsPaladinBuffRotationEnabled or not PCP_IsPaladinBuffRotationEnabled() then return end
        if not PCPPaladinBlessings then return end
        if not PCPPaladinBlessingItr or PCPPaladinBlessingItr <= 1 then
            PCPPaladinBlessingItr = 2
        end
        if PCPPaladinBlessingItr > table.getn(PCPPaladinBlessings) then
            PCPPaladinBlessingItr = 2
        end
    end

    local function PCP_GetShamanTotemText(key)
        if not PCPShamanTotems or not PCPShamanTotemItr then return "Default" end
        local list = PCPShamanTotems[key]
        if not list then return "Default" end
        return list[PCPShamanTotemItr[key] or 1] or "Default"
    end

    local function PCP_GetCurrentAddClass()
        
        
        local c = AddClass
        if (not c or c == "") and Classes and ClassItr and Classes[ClassItr] then
            c = Classes[ClassItr]
        end
        if (not c or c == "") and classNames and currentClassIndex and classNames[currentClassIndex] then
            c = string.lower(classNames[currentClassIndex])
        end
        if c then c = string.lower(c) end
        return c or ""
    end

    local function PCP_GetSpawnButtonMetrics(currentAddClass)
        currentAddClass = currentAddClass or (PCP_GetCurrentAddClass and PCP_GetCurrentAddClass()) or ""

        local parentW = addBotFrame and addBotFrame.GetWidth and (addBotFrame:GetWidth() or 240) or 240
        local parentH = addBotFrame and addBotFrame.GetHeight and (addBotFrame:GetHeight() or 80) or 80
        local roleH = roleButton and roleButton.GetHeight and (roleButton:GetHeight() or 22) or 22
        local classW = classButton and classButton.GetWidth and (classButton:GetWidth() or 80) or 80
        local plusW = SetClassADDButton and SetClassADDButton.GetWidth and (SetClassADDButton:GetWidth() or 24) or 24

        if roleH < 10 then roleH = 10 end

        
        local rightRoom = (parentW / 2) - (classW / 2) - plusW - 10
        if rightRoom < 14 then rightRoom = 14 end

        if currentAddClass == "shaman" then
            local gap = math.floor(rightRoom * 0.10)
            if gap < 1 then gap = 1 end
            if gap > 4 then gap = 4 end

            local iconByWidth = math.floor((rightRoom - gap) / 2)
            local iconByHeight = math.floor(((roleH * 2) + 5 - gap) / 2)
            local iconSize = math.min(iconByWidth, iconByHeight)
            if iconSize < 7 then iconSize = 7 end
            if iconSize > 20 then iconSize = 20 end

            local gridW = (iconSize * 2) + gap
            local gridH = (iconSize * 2) + gap
            return iconSize, gap, gridW, gridH
        end

        local iconSize = math.min(rightRoom, roleH - 6)
        if iconSize < 8 then iconSize = 8 end
        if iconSize > 20 then iconSize = 20 end
        return iconSize, 0, iconSize + 4, iconSize + 4
    end

    local function PCP_PositionSpawnConfigButton(currentAddClass)
        if not PCPSpawnConfigButton then return end
        currentAddClass = currentAddClass or (PCP_GetCurrentAddClass and PCP_GetCurrentAddClass()) or ""

        local iconSize, gap, buttonW, buttonH = PCP_GetSpawnButtonMetrics(currentAddClass)
        PCPSpawnConfigButton._pcpIconGap = gap or 2
        PCPSpawnConfigButton:ClearAllPoints()

        if currentAddClass == "shaman" then
            PCPSpawnConfigButton:SetSize(buttonW, buttonH)
            if SetClassADDButton then
                
                PCPSpawnConfigButton:SetPoint("TOPLEFT", SetClassADDButton, "TOPRIGHT", 4, 0)
            elseif roleButton then
                PCPSpawnConfigButton:SetPoint("LEFT", roleButton, "RIGHT", 4, 0)
            end
        else
            PCPSpawnConfigButton:SetSize(buttonW, buttonH)
            if SetRoleADDButton then
                PCPSpawnConfigButton:SetPoint("LEFT", SetRoleADDButton, "RIGHT", 4, 0)
            elseif roleButton then
                PCPSpawnConfigButton:SetPoint("LEFT", roleButton, "RIGHT", 4, 0)
            end
        end

        return iconSize
    end

    function PCP_UpdateSpawnConfigButtonText()
        if not PCPSpawnConfigButton then return end
        local currentAddClass = PCP_GetCurrentAddClass()
        PCP_ClearSpawnConfigButtonTextures(PCPSpawnConfigButton)
        local iconSize = PCP_PositionSpawnConfigButton(currentAddClass)

        if currentAddClass == "paladin" then
            if PCP_NormalizePaladinBlessingForRotation then
                PCP_NormalizePaladinBlessingForRotation()
            end
            local blessing = PCP_GetPaladinBlessingText()
            PCPSpawnConfigButton:SetText("")
            PCP_SetButtonIcon(PCPSpawnConfigButton, PCP_GetSpawnIconPath("paladin", blessing), iconSize or 16)
        elseif currentAddClass == "shaman" then
            PCPSpawnConfigButton:SetText("")
            PCP_SetButtonTotemIcons(
                PCPSpawnConfigButton,
                PCP_GetSpawnIconPath("shaman", PCP_GetShamanTotemText("air")),
                PCP_GetSpawnIconPath("shaman", PCP_GetShamanTotemText("earth")),
                PCP_GetSpawnIconPath("shaman", PCP_GetShamanTotemText("fire")),
                PCP_GetSpawnIconPath("shaman", PCP_GetShamanTotemText("water")),
                iconSize or 16
            )
        elseif currentAddClass == "mage" then
            local spec = PCP_GetMageSpecText()
            PCPSpawnConfigButton:SetText("")
            PCP_SetButtonIcon(PCPSpawnConfigButton, PCP_GetSpawnIconPath("mage", spec), iconSize or 16)
        else
            
            PCPSpawnConfigButton:SetText("")
            PCP_HideButtonTotemIcons(PCPSpawnConfigButton)
            if PCPSpawnConfigButton._pcpSpawnIcon then
                PCPSpawnConfigButton._pcpSpawnIcon:Hide()
                PCPSpawnConfigButton._pcpSpawnIcon:SetTexture(nil)
            end
            PCPSpawnConfigButton:Hide()
            PCP_ClearSpawnConfigButtonTextures(PCPSpawnConfigButton)
            return
        end
        PCP_ClearSpawnConfigButtonTextures(PCPSpawnConfigButton)
        if PCP_UpdateSpawnButtonTooltip then
            PCP_UpdateSpawnButtonTooltip(PCPSpawnConfigButton)
        end
    end

    local function PCP_CloseSpawnOptionsFrame()
        if PCPSpawnOptionsFrame then PCPSpawnOptionsFrame:Hide() end
    end

    local function PCP_HideSpawnOptionRows()
        if not PCPSpawnOptionsFrame or not PCPSpawnOptionsFrame.rows then return end
        for _, row in ipairs(PCPSpawnOptionsFrame.rows) do
            if row then
                row:Hide()
                if row.hit then row.hit:Hide() end
            end
        end
    end

    local function PCP_MakeRadioRow(parent, groupKey, index, label, x, y, onSelect)
        local row = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
        row:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        
        
        row:SetWidth(20)
        row:SetHeight(20)
        row.groupKey = groupKey
        row.index = index

        PCP_SetRowIcon(row, PCP_GetSpawnIconPath("paladin", label), 16)
        row.icon:SetPoint("LEFT", row, "RIGHT", 2, 0)

        row.label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.label:SetPoint("LEFT", row.icon, "RIGHT", 5, 1)
        row.label:SetText(label)

        
        row.hit = CreateFrame("Button", nil, parent)
        row.hit:SetPoint("LEFT", row, "LEFT", 0, 0)
        row.hit:SetWidth(190)
        row.hit:SetHeight(20)
        row.hit.groupKey = groupKey
        row.hit.index = index
        row.hit:SetScript("OnClick", function(self)
            onSelect(self.groupKey, self.index)
        end)

        row:SetScript("OnClick", function(self)
            onSelect(self.groupKey, self.index)
        end)

        if not parent.rows then parent.rows = {} end
        table.insert(parent.rows, row)
        return row
    end


    local function PCP_MakeTextRadioRow(parent, groupKey, index, label, x, y, width, onSelect)
        local row = CreateFrame("Button", nil, parent)
        row:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        row:SetWidth(width or 130)
        row:SetHeight(18)
        row.groupKey = groupKey
        row.index = index

        PCP_SetRowIcon(row, PCP_GetSpawnIconPath("shaman", label), 16)
        row.icon:SetPoint("LEFT", row, "LEFT", 0, 0)

        row.text = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.text:SetPoint("LEFT", row.icon, "RIGHT", 5, 0)
        row.text:SetJustifyH("LEFT")
        row.text:SetWidth((width or 130) - 22)
        row.text:SetText(label)

        row:SetScript("OnClick", function(self)
            onSelect(self.groupKey, self.index)
        end)
        row:SetScript("OnEnter", function(self)
            if self.text then self.text:SetTextColor(1, 1, 1, 1) end
        end)
        row:SetScript("OnLeave", function(self)
            if self.text then self.text:SetTextColor(1, 0.82, 0, 1) end
        end)

        if not parent.rows then parent.rows = {} end
        table.insert(parent.rows, row)
        return row
    end

    local function PCP_EnsureSpawnOptionsFrame()
        if PCPSpawnOptionsFrame then return end

        local popup = CreateFrame("Frame", "PCPSpawnOptionsFrame", UIParent, "BackdropTemplate")
        popup:SetSize(260, 320)
        popup:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        popup:SetFrameStrata("FULLSCREEN_DIALOG")
        popup:SetFrameLevel(210)
        if popup.SetToplevel then popup:SetToplevel(true) end
        popup:SetMovable(true)
        popup:EnableMouse(true)
        popup:RegisterForDrag("LeftButton")
        popup:SetScript("OnDragStart", function(self) self:StartMoving() end)
        popup:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
        popup:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        popup:SetBackdropColor(0, 0, 0, 0.92)
        popup:SetBackdropBorderColor(1, 0.82, 0, 1)
        popup:Hide()

        popup.titleIcon = popup:CreateTexture(nil, "OVERLAY")
        popup.titleIcon:SetWidth(20)
        popup.titleIcon:SetHeight(20)
        popup.titleIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        popup.titleIcon:SetPoint("TOP", popup, "TOP", -70, -8)
        popup.titleIcon:SetTexture("Interface\\Icons\\INV_Misc_Gear_01")

        popup.title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        popup.title:SetPoint("LEFT", popup.titleIcon, "RIGHT", 6, 0)
        popup.title:SetText("Spawn Options")

        popup.help = popup:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        popup.help:SetPoint("TOP", popup.title, "BOTTOM", 0, -6)
        popup.help:SetWidth(230)
        popup.help:SetJustifyH("CENTER")
        popup.help:SetText("Default sends no extra command args.")

        popup.close = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
        popup.close:SetSize(55, 20)
        popup.close:SetPoint("BOTTOM", popup, "BOTTOM", 0, 10)
        popup.close:SetText("Close")
        popup.close:SetScript("OnClick", function()
            popup:Hide()
            if PCP_UpdateClickBlockerVisibility then PCP_UpdateClickBlockerVisibility() end
        end)

        popup.rows = {}
        PCPSpawnOptionsFrame = popup
    end

    function PCP_RefreshSpawnOptionsFrame()
        PCP_EnsureSpawnOptionsFrame()
        local popup = PCPSpawnOptionsFrame
        PCP_HideSpawnOptionRows()

        local y = -55

        local currentAddClass = PCP_GetCurrentAddClass()
        if currentAddClass == "paladin" then
            popup:SetWidth(280)
            if popup.titleIcon then
                popup.titleIcon:ClearAllPoints()
                popup.titleIcon:SetPoint("TOP", popup, "TOP", -72, -8)
                popup.titleIcon:SetTexture(PCP_GetSpawnIconPath("paladin", PCP_GetPaladinBlessingText()))
            end
            popup.title:SetText("Paladin Blessing")
            popup.help:SetText("Select blessing for new paladins. Default uses server default.")
            popup:SetHeight(230)

            if not popup.paladinRows then popup.paladinRows = {} end
            for i, blessing in ipairs(PCPPaladinBlessings) do
                if not popup.paladinRows[i] then
                    popup.paladinRows[i] = PCP_MakeRadioRow(popup, "paladin", i, blessing, 22, y - ((i - 1) * 22), function(groupKey, index)
                        PCPPaladinBlessingItr = index
                        PCP_RefreshSpawnOptionsFrame()
                        PCP_UpdateSpawnConfigButtonText()
                    end)
                end
                popup.paladinRows[i]:SetPoint("TOPLEFT", popup, "TOPLEFT", 22, y - ((i - 1) * 22))
                if popup.paladinRows[i].hit then
                    popup.paladinRows[i].hit:ClearAllPoints()
                    popup.paladinRows[i].hit:SetPoint("LEFT", popup.paladinRows[i], "LEFT", 0, 0)
                end
                popup.paladinRows[i]:SetChecked((PCPPaladinBlessingItr or 1) == i)
                popup.paladinRows[i]:Show()
                if popup.paladinRows[i].hit then popup.paladinRows[i].hit:Show() end
            end

        elseif currentAddClass == "shaman" then
            if popup.titleIcon then
                popup.titleIcon:ClearAllPoints()
                popup.titleIcon:SetPoint("TOP", popup, "TOP", -68, -8)
                popup.titleIcon:SetTexture(PCP_GetSpawnIconPath("shaman", PCP_GetShamanTotemText("air")))
            end
            popup.title:SetText("Shaman Totems")
            popup.help:SetText("Select one totem from each group. Command order is air -> earth -> fire -> water.")
            popup:SetWidth(680)
            popup:SetHeight(240)

            local groups = {
                { key = "air",   title = "Air",   x = 20 },
                { key = "earth", title = "Earth", x = 185 },
                { key = "fire",  title = "Fire",  x = 350 },
                { key = "water", title = "Water", x = 515 },
            }

            if not popup.shamanTitles then popup.shamanTitles = {} end
            if not popup.shamanRows then popup.shamanRows = {} end

            for _, group in ipairs(groups) do
                local list = PCPShamanTotems[group.key]
                if list then
                    if not popup.shamanTitleIcons then popup.shamanTitleIcons = {} end
                    if not popup.shamanTitleIcons[group.key] then
                        popup.shamanTitleIcons[group.key] = popup:CreateTexture(nil, "OVERLAY")
                        popup.shamanTitleIcons[group.key]:SetWidth(18)
                        popup.shamanTitleIcons[group.key]:SetHeight(18)
                        popup.shamanTitleIcons[group.key]:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    end
                    local titleIcon = popup.shamanTitleIcons[group.key]
                    titleIcon:ClearAllPoints()
                    titleIcon:SetPoint("TOPLEFT", popup, "TOPLEFT", group.x, -53)
                    titleIcon:SetTexture(PCP_GetSpawnIconPath("shaman", PCP_GetShamanTotemText(group.key)))
                    titleIcon:Show()

                    if not popup.shamanTitles[group.key] then
                        popup.shamanTitles[group.key] = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                    end
                    local title = popup.shamanTitles[group.key]
                    title:ClearAllPoints()
                    title:SetPoint("LEFT", titleIcon, "RIGHT", 5, 0)
                    title:SetText(group.title)
                    title:Show()

                    if not popup.shamanRows[group.key] then popup.shamanRows[group.key] = {} end
                    for i, totem in ipairs(list) do
                        if not popup.shamanRows[group.key][i] then
                            popup.shamanRows[group.key][i] = PCP_MakeTextRadioRow(popup, group.key, i, totem, group.x, -78 - ((i - 1) * 20), 155, function(groupKey, index)
                                PCPShamanTotemItr[groupKey] = index
                                PCP_RefreshSpawnOptionsFrame()
                                PCP_UpdateSpawnConfigButtonText()
                            end)
                        end
                        local row = popup.shamanRows[group.key][i]
                        row:ClearAllPoints()
                        row:SetPoint("TOPLEFT", popup, "TOPLEFT", group.x, -78 - ((i - 1) * 20))
                        local checked = ((PCPShamanTotemItr[group.key] or 1) == i)
                        if row.text then
                            row.text:SetText((checked and "|cff00ff00(*)|r " or "( ) ") .. totem)
                            row.text:SetTextColor(1, 0.82, 0, 1)
                        end
                        row:Show()
                    end
                end
            end
        elseif currentAddClass == "mage" then
            popup:SetWidth(280)
            popup:SetHeight(160)
            if popup.titleIcon then
                popup.titleIcon:ClearAllPoints()
                popup.titleIcon:SetPoint("TOP", popup, "TOP", -55, -8)
                popup.titleIcon:SetTexture(PCP_GetSpawnIconPath("mage", PCP_GetMageSpecText()))
            end
            popup.title:SetText("Mage Spec")
            popup.help:SetText("Select mage spec for new Mage bots.")

            if not popup.mageRows then popup.mageRows = {} end
            for i, spec in ipairs(PCPMageSpecs) do
                if not popup.mageRows[i] then
                    popup.mageRows[i] = PCP_MakeRadioRow(popup, "mage", i, spec, 22, y - ((i - 1) * 22), function(groupKey, index)
                        PCPMageSpecItr = index
                        PCP_RefreshSpawnOptionsFrame()
                        PCP_UpdateSpawnConfigButtonText()
                    end)
                end
                popup.mageRows[i]:SetPoint("TOPLEFT", popup, "TOPLEFT", 22, y - ((i - 1) * 22))
                if popup.mageRows[i].hit then
                    popup.mageRows[i].hit:ClearAllPoints()
                    popup.mageRows[i].hit:SetPoint("LEFT", popup.mageRows[i], "LEFT", 0, 0)
                end
                PCP_SetRowIcon(popup.mageRows[i], PCP_GetSpawnIconPath("mage", spec), 16)
                popup.mageRows[i]:SetChecked((PCPMageSpecItr or 1) == i)
                if popup.mageRows[i].label then
                    popup.mageRows[i].label:SetText(spec)
                end
                popup.mageRows[i]:Show()
                if popup.mageRows[i].hit then popup.mageRows[i].hit:Show() end
            end
        end

        if popup.shamanTitles then
            for key, title in pairs(popup.shamanTitles) do
                if PCP_GetCurrentAddClass() ~= "shaman" then title:Hide() end
            end
        end
        if popup.shamanTitleIcons then
            for key, titleIcon in pairs(popup.shamanTitleIcons) do
                if PCP_GetCurrentAddClass() ~= "shaman" then titleIcon:Hide() end
            end
        end
    end

    local function PCP_GetClickedShamanTotemKey(button)
        if not button then return "air" end

        local x, y = GetCursorPosition()
        local scale = button:GetEffectiveScale() or 1
        x = x / scale
        y = y / scale

        local left = button:GetLeft() or 0
        local right = button:GetRight() or left
        local top = button:GetTop() or 0
        local bottom = button:GetBottom() or top
        local midX = (left + right) / 2
        local midY = (top + bottom) / 2

        
        
        if y >= midY then
            if x < midX then return "air" end
            return "earth"
        end
        if x < midX then return "fire" end
        return "water"
    end

    local function PCP_GetShamanTotemDisplayName(key)
        if key == "air" then return "Air" end
        if key == "earth" then return "Earth" end
        if key == "fire" then return "Fire" end
        if key == "water" then return "Water" end
        return "Totem"
    end

	local function PCP_TooltipAddIconLine(iconPath, text, r, g, b)
		local size = 16 
		local icon = iconPath and ("|T" .. iconPath .. ":" .. size .. ":" .. size .. "|t ") or ""
		GameTooltip:AddLine(icon .. text, r or 1, g or 1, b or 1)
	end

    local function PCP_AddShamanTooltipLine(key, hoveredKey)
        local name = PCP_GetShamanTotemDisplayName(key)
        local totem = PCP_GetShamanTotemText(key) or "Default"
        local icon = PCP_GetSpawnIconPath("shaman", totem)

        if key == hoveredKey then
            PCP_TooltipAddIconLine(icon, "> " .. name .. ": " .. totem, 0, 1, 0)
        else
            PCP_TooltipAddIconLine(icon, "  " .. name .. ": " .. totem, 0.85, 0.85, 0.85)
        end
    end

    local function PCP_ShowSpawnButtonTooltip(button, hoveredKey)
        if not button then return end

        local currentAddClass = PCP_GetCurrentAddClass()
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
        if GameTooltip.ClearLines then GameTooltip:ClearLines() end

        if currentAddClass == "paladin" then
            local blessing = PCP_GetPaladinBlessingText() or "Default"
            local rotation = PCP_IsPaladinBuffRotationEnabled() and "Enabled" or "Disabled"
            local blessingIcon = PCP_GetSpawnIconPath("paladin", blessing)

            PCP_TooltipAddIconLine(blessingIcon, "Paladin Blessing", 1, 0.82, 0)
            GameTooltip:AddLine(" ")
            PCP_TooltipAddIconLine(blessingIcon, "Current: " .. blessing, 0, 1, 0)
            if PCP_IsPaladinBuffRotationEnabled() then
                GameTooltip:AddLine("Rotation: |cff00ff00" .. rotation .. "|r")
            else
                GameTooltip:AddLine("Rotation: |cffff4444" .. rotation .. "|r")
            end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Left click: Configure blessings", 0.7, 0.7, 0.7)
            GameTooltip:AddLine("Right click: Quick change blessing", 0.7, 0.7, 0.7)

        elseif currentAddClass == "shaman" then
            hoveredKey = hoveredKey or PCP_GetClickedShamanTotemKey(button)
            local hoveredName = PCP_GetShamanTotemDisplayName(hoveredKey)
            local hoveredTotem = PCP_GetShamanTotemText(hoveredKey) or "Default"
            local hoveredIcon = PCP_GetSpawnIconPath("shaman", hoveredTotem)

            PCP_TooltipAddIconLine(hoveredIcon, "Shaman Totems", 1, 0.82, 0)
            GameTooltip:AddLine(" ")
            PCP_AddShamanTooltipLine("air", hoveredKey)
            PCP_AddShamanTooltipLine("earth", hoveredKey)
            PCP_AddShamanTooltipLine("fire", hoveredKey)
            PCP_AddShamanTooltipLine("water", hoveredKey)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Left click: Configure totems", 0.7, 0.7, 0.7)
            GameTooltip:AddLine("Right click: Quick change hovered totem", 0.7, 0.7, 0.7)
        elseif currentAddClass == "mage" then
            local spec = PCP_GetMageSpecText() or "fire"
            local specIcon = PCP_GetSpawnIconPath("mage", spec)
            PCP_TooltipAddIconLine(specIcon, "Mage Spec", 1, 0.82, 0)
            GameTooltip:AddLine(" ")
            PCP_TooltipAddIconLine(specIcon, "Current: " .. PCP_CapitalizeFirst(spec), 0, 1, 0)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("Left click: Configure mage spec", 0.7, 0.7, 0.7)
            GameTooltip:AddLine("Right click: Quick change mage spec", 0.7, 0.7, 0.7)
        else
            GameTooltip:AddLine("No spawn options available")
        end

        button._pcpTooltipLastTotemKey = hoveredKey
        GameTooltip:Show()
    end

    function PCP_UpdateSpawnButtonTooltip(button)
        if not button then return end

        button:SetScript("OnEnter", function(self)
            self._pcpTooltipActive = true
            self._pcpTooltipLastTotemKey = nil
            self._pcpTooltipElapsed = 0
            PCP_ShowSpawnButtonTooltip(self)
        end)

        button:SetScript("OnUpdate", function(self, elapsed)
            if not self._pcpTooltipActive then return end

            local currentAddClass = PCP_GetCurrentAddClass()
            if currentAddClass ~= "shaman" then return end

            elapsed = elapsed or arg1 or 0.05
            self._pcpTooltipElapsed = (self._pcpTooltipElapsed or 0) + elapsed
            if self._pcpTooltipElapsed < 0.03 then return end
            self._pcpTooltipElapsed = 0

            
            
            
            local key = PCP_GetClickedShamanTotemKey(self)
            if key ~= self._pcpTooltipLastTotemKey or not GameTooltip:IsShown() then
                PCP_ShowSpawnButtonTooltip(self, key)
            end
        end)

        button:SetScript("OnLeave", function(self)
            self._pcpTooltipActive = false
            self._pcpTooltipLastTotemKey = nil
            self._pcpTooltipElapsed = 0
            GameTooltip:Hide()
        end)
    end

    local function PCP_QuickChangeShamanTotem(groupKey)
        groupKey = groupKey or "air"
        if not PCPShamanTotems or not PCPShamanTotemItr or not PCPShamanTotems[groupKey] then return end

        PCPShamanTotemItr[groupKey] = (PCPShamanTotemItr[groupKey] or 1) + 1
        if PCPShamanTotemItr[groupKey] > table.getn(PCPShamanTotems[groupKey]) then
            PCPShamanTotemItr[groupKey] = 1
        end

        if PCP_UpdateSpawnConfigButtonText then PCP_UpdateSpawnConfigButtonText() end
        if PCP_RefreshSpawnOptionsFrame and PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown() then
            PCP_RefreshSpawnOptionsFrame()
        end

        
        
        
        
        if PCPSpawnConfigButton and PCPSpawnConfigButton._pcpTooltipActive and GameTooltip:IsShown() then
            PCP_ShowSpawnButtonTooltip(PCPSpawnConfigButton, groupKey)
        end
    end

    function PCP_QuickChangeSpawnOption(button)
        local currentAddClass = PCP_GetCurrentAddClass()
        if currentAddClass == "paladin" then
            if not PCPPaladinBlessings then return end
            PCPPaladinBlessingItr = (PCPPaladinBlessingItr or 1) + 1
            if PCPPaladinBlessingItr > table.getn(PCPPaladinBlessings) then
                PCPPaladinBlessingItr = PCP_IsPaladinBuffRotationEnabled() and 2 or 1
            end
            if PCP_IsPaladinBuffRotationEnabled() and PCPPaladinBlessingItr <= 1 then
                PCPPaladinBlessingItr = 2
            end
            if PCP_UpdateSpawnConfigButtonText then PCP_UpdateSpawnConfigButtonText() end
            if PCP_RefreshSpawnOptionsFrame and PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown() then
                PCP_RefreshSpawnOptionsFrame()
            end

            
            if button and button._pcpTooltipActive and GameTooltip:IsShown() then
                PCP_ShowSpawnButtonTooltip(button)
            end
        elseif currentAddClass == "shaman" then
            
            
            PCP_QuickChangeShamanTotem(PCP_GetClickedShamanTotemKey(button))
        elseif currentAddClass == "mage" then
            if not PCPMageSpecs then return end
            PCPMageSpecItr = (PCPMageSpecItr or 1) + 1
            if PCPMageSpecItr > table.getn(PCPMageSpecs) then
                PCPMageSpecItr = 1
            end
            if PCP_UpdateSpawnConfigButtonText then PCP_UpdateSpawnConfigButtonText() end
            if PCP_RefreshSpawnOptionsFrame and PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown() then
                PCP_RefreshSpawnOptionsFrame()
            end
            if button and button._pcpTooltipActive and GameTooltip:IsShown() then
                PCP_ShowSpawnButtonTooltip(button)
            end
        end
    end

    function PCP_ShowSpawnOptionsFrame()
        local currentAddClass = PCP_GetCurrentAddClass()
        if currentAddClass ~= "paladin" and currentAddClass ~= "shaman" and currentAddClass ~= "mage" then
            DEFAULT_CHAT_FRAME:AddMessage("|cff88ccff[PCP]|r Spawn options are only available for Paladin, Shaman and Mage. Current class: " .. tostring(currentAddClass))
            return
        end

        PCP_RefreshSpawnOptionsFrame()
        if not PCPSpawnOptionsFrame then
            DEFAULT_CHAT_FRAME:AddMessage("|cffff4444[PCP]|r Could not create spawn options frame.")
            return
        end

        PCPSpawnOptionsFrame:ClearAllPoints()
        PCPSpawnOptionsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        PCPSpawnOptionsFrame:SetFrameStrata("FULLSCREEN_DIALOG")
        PCPSpawnOptionsFrame:SetFrameLevel(210)
        if PCPSpawnOptionsFrame.SetToplevel then PCPSpawnOptionsFrame:SetToplevel(true) end

        if PCPSpawnOptionsFrame:IsShown() then
            PCPSpawnOptionsFrame:Hide()
            if PCP_UpdateClickBlockerVisibility then PCP_UpdateClickBlockerVisibility() end
        else
            PCPSpawnOptionsFrame:Show()
            if PCP_UpdateClickBlockerVisibility then PCP_UpdateClickBlockerVisibility() end
            --DEFAULT_CHAT_FRAME:AddMessage("|cff88ccff[PCP debug]|r Opened spawn options for " .. currentAddClass)
        end
    end

    PCPSpawnConfigButton = createClassRoleButton("PCPSpawnConfigButton", "", 108, -30, function()
        PCP_ShowSpawnOptionsFrame()
    end, 92, 24, addBotFrame)
    PCPSpawnConfigButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    PCPSpawnConfigButton:SetScript("OnClick", function(self, button)
        local clickedButton = button or arg1
        if clickedButton == "RightButton" then
            if PCP_QuickChangeSpawnOption then PCP_QuickChangeSpawnOption(self) end
        else
            PCP_ShowSpawnOptionsFrame()
        end
    end)
    PCPSpawnConfigButton._pcpTransparentIconButton = true
    PCPSpawnConfigButton:Hide()
    PCP_ClearSpawnConfigButtonTextures(PCPSpawnConfigButton)
    PCP_UpdateSpawnButtonTooltip(PCPSpawnConfigButton)

    function PCP_UpdateSpawnOptionButtons()
        if PCPSpawnConfigButton then PCPSpawnConfigButton:Hide() end
        if PCPSpawnOptionsFrame then PCPSpawnOptionsFrame:Hide() end

        local currentAddClass = PCP_GetCurrentAddClass()
        if currentAddClass == "paladin" or currentAddClass == "shaman" or currentAddClass == "mage" then
            PCP_UpdateSpawnConfigButtonText()
            PCPSpawnConfigButton:Show()
        end

        
        
        
        
        if ResizeAddBotButtons then ResizeAddBotButtons() end
    end




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

    if font then
        PCPPullTimerText:SetFont(font, timerSize, flags)
    end
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

    if not PCPPullTimerFrame then
        PCPPullTimerFrame = CreateFrame("Frame")
    end

    PCPPullTimerFrame:SetScript("OnUpdate", function(self, elapsed)
        PCPPullTimerRemaining = (PCPPullTimerRemaining or 0) - (elapsed or 0)
        if PCPPullTimerRemaining <= 0 then
            PCP_ResetPullTimer()
            return
        end

        local shown = math.ceil(PCPPullTimerRemaining)
        if shown < 1 then shown = 1 end
        if PCPPullTimerText then
            PCPPullTimerText:SetText(tostring(shown))
            PCPPullTimerText:Show()
        end
    end)
end

	
	local commandsFrame = CreateFrame("Frame", "CommandsFrame", frame)
	commandsFrame:SetSize(300, 130)  
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
	partyBotCommandsFrame:SetSize(300, 130)  
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
	comeCommandTitleFrame:SetSize(300, 60)  
	comeCommandTitleFrame:SetPoint("TOP", partyBotCommandsFrame, "BOTTOM", 0, -2)  

	
	comeCommandTitleFrame.bg = comeCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	comeCommandTitleFrame.bg:SetAllPoints(true)
	comeCommandTitleFrame.bg:SetColorTexture(0.6, 0.4, 0.2, 0.5)  

	
	local comeTitle = comeCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	comeTitle:SetText("Come Commands")
	comeTitle:SetPoint("CENTER", comeCommandTitleFrame, "TOP", 0, -5)  

	
	local comeCommandFrame = CreateFrame("Frame", "ComeCommandFrame", commandsFrame)
	comeCommandFrame:SetSize(300, 10)  
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
	moveCommandTitleFrame:SetSize(300, 10)  
	moveCommandTitleFrame:SetPoint("TOP", comeCommandFrame, "BOTTOM", 0, -2)  

	
	moveCommandTitleFrame.bg = moveCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	moveCommandTitleFrame.bg:SetAllPoints(true)
	moveCommandTitleFrame.bg:SetColorTexture(0.4, 0.6, 0.2, 0.5)  

	
	local moveTitle = moveCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	moveTitle:SetText("Move Commands")
	moveTitle:SetPoint("CENTER", moveCommandTitleFrame, "TOP", 0, -5)  
	
	local moveCommandFrame = CreateFrame("Frame", "MoveCommandFrame", commandsFrame)
	moveCommandFrame:SetSize(300, 60)  
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
	stayCommandTitleFrame:SetSize(300, 60)  
	stayCommandTitleFrame:SetPoint("TOP", moveCommandFrame, "BOTTOM", 0, -2)  

	
	stayCommandTitleFrame.bg = stayCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	stayCommandTitleFrame.bg:SetAllPoints(true)
	stayCommandTitleFrame.bg:SetColorTexture(0.4, 0.2, 0.6, 0.5)  


	local stayTitle = stayCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	stayTitle:SetText("Stay Commands")
	stayTitle:SetPoint("CENTER", stayCommandTitleFrame, "TOP", 0, -5)  


	
	local stayCommandFrame = CreateFrame("Frame", "StayCommandFrame", commandsFrame)
	stayCommandFrame:SetSize(300, 60)  
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
markFrame:SetSize(300, 50) 
markFrame:SetPoint("TOP", stayCommandFrame, "BOTTOM", 0, 2)




markFrame.bg = markFrame:CreateTexture(nil, "BACKGROUND")
markFrame.bg:SetAllPoints(true)



local function createMarkButton(name, text, xOffset, onClickFunc, width, height, parentFrame)
    local button

        button = CreateFrame("Button", name, parentFrame)
        local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
        fontString:SetPoint("CENTER")
        button:SetFontString(fontString) 


    button:SetSize(width, height)
    button:SetPoint("TOP", parentFrame, "TOP", xOffset, -10) 
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

	PCP_RegisterThemedButton(button)
    return button
end




Marks = { "CC Mark", "Focus Mark" }
MarkItr = 1 


local function UpdateMarkDisplay()
    markButton:SetText(Marks[MarkItr])
end
SetMarkADDButton = createButton("SetMarkADDButton", "", 58, 10, function() MarkADD() end, 30, 30, markFrame)
SetMarkSUBButton = createButton("SetMarkSUBButton", "", -58, 10, function() MarkSUB() end, 30, 30, markFrame)

PCP_SetArrowButtonVisual(SetMarkADDButton, "next")
PCP_SetArrowButtonVisual(SetMarkSUBButton, "prev")
markButton = createMarkButton("MarkButton", Marks[MarkItr], 0, function() ShowMark() end, 95, 30, markFrame)



local markCommandFrame = CreateFrame("Frame", "MarkCommandFrame", PCPFrameRemake)
markCommandFrame:SetSize(300, 120)  
markCommandFrame:SetPoint("TOP", markFrame, "BOTTOM", 0, -2)  


markCommandFrame.bg = markCommandFrame:CreateTexture(nil, "BACKGROUND")
markCommandFrame.bg:SetAllPoints(true)






local function createMarkCommandButton(name, iconPath, tooltipText, xOffset, yOffset, onClickFunc, width, height, parentFrame)
    local button


        button = CreateFrame("Button", name, parentFrame)
        local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") 
        fontString:SetPoint("CENTER")
        button:SetFontString(fontString) 


    button:SetSize(width, height)
    button:SetPoint("TOP", parentFrame, "TOP", xOffset, yOffset)

    
    local iconTexture = button:CreateTexture(nil, "OVERLAY")  
    iconTexture:SetTexture(iconPath)
    iconTexture:SetSize(width * 0.4, height * 0.4)  
    iconTexture:SetPoint("CENTER", button, "CENTER", 0, 0)  
    iconTexture:SetTexCoord(0.25, 0.75, 0.25, 0.75)  
    button.iconTexture = iconTexture  

    
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.1) 

    button:SetScript("OnClick", onClickFunc)

    
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText, 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    PCP_RegisterThemedButton(button)
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
    local buttonCount = #commandButtons
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

    
    for i, cmd in ipairs(commandButtons) do
        local button = _G[cmd[1]]
        if button then
            
            button:SetWidth(buttonWidth)
            button:SetHeight(buttonHeight)

            
            local normalTexture = button:GetNormalTexture()
            if normalTexture then
                normalTexture:SetSize(buttonWidth * 0.4, buttonHeight * 0.4)  
            end

            
            local fontSize = math.max(10, math.min(buttonWidth / 4, 12))
            local font, _, flags = button:GetFontString():GetFont()
            button:GetFontString():SetFont(font, fontSize, flags)

            
            local row = math.floor((i - 1) / buttonsPerRow)  
            local col = (i - 1) % buttonsPerRow  

            if col == 0 then
                
                button:SetPoint("TOPLEFT", commandFrame, "TOPLEFT", 0, -(row * (buttonHeight + padding)))
            else
                
                local previousButton = _G[commandButtons[i - 1][1]]
                button:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", padding, 0)
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
    local buttonCount = #commandButtons
    local rows = math.ceil(buttonCount / buttonsPerRow)
    local totalHorizontalPadding = padding * (buttonsPerRow - 1)
    local availableWidth = width - totalHorizontalPadding
    local buttonWidth = math.floor(availableWidth / buttonsPerRow)

    
    buttonHeight = buttonHeight or math.floor(commandFrame:GetHeight() / rows) - padding

    for i, cmd in ipairs(commandButtons) do
        local button = _G[cmd[1]]
        if button then
            button:SetSize(buttonWidth, buttonHeight)

            
            local fontSize = math.max(8, math.min(buttonWidth / 5, buttonHeight / 3))
            local font, _, flags = button:GetFontString():GetFont()
            button:GetFontString():SetFont(font, fontSize, flags)

            
            local row = math.floor((i - 1) / buttonsPerRow)
            local col = (i - 1) % buttonsPerRow

            if col == 0 then
                button:SetPoint("TOPLEFT", commandFrame, "TOPLEFT", 0, -row * (buttonHeight + padding))
            else
                local prevButton = _G[commandButtons[i - 1][1]]
                button:SetPoint("TOPLEFT", prevButton, "TOPRIGHT", padding, 0)
            end
        end
    end
end




local defaultButtonWidth = 50
local defaultButtonHeight = 30
local padding = 5


local function ResizeCommandButtons(commandButtons, commandFrame, buttonsPerRow, extraWidth, startingYOffset, isPartyBot)
    buttonsPerRow = buttonsPerRow or 3  
    local buttonCount = #commandButtons
    local rows = math.ceil(buttonCount / buttonsPerRow)  
    local padding = 2  

    local totalHorizontalPadding = padding * (buttonsPerRow - 1)  
    local availableWidth = commandFrame:GetWidth() - totalHorizontalPadding  

    local totalVerticalPadding = padding * (rows - 1)  
    local availableHeight = commandFrame:GetHeight() - totalVerticalPadding  

    
    local buttonWidth = math.floor((availableWidth - (extraWidth or 0)) / buttonsPerRow)  
    local buttonHeight = math.floor(availableHeight / rows)  

    
    local yOffset = startingYOffset or 0

    
    for i, cmd in ipairs(commandButtons) do
        local button = _G[cmd[1]]
        if button then
            button:SetWidth(buttonWidth + (extraWidth or 0))  
            button:SetHeight(buttonHeight)  

            
            local fontSize
            if isPartyBot then
                fontSize = math.max(6, math.min(buttonWidth / 4, buttonHeight / 2))  
            else
                fontSize = math.max(8, math.min(buttonWidth / 2, buttonHeight / 2))  
            end

            local font, _, flags = button:GetFontString():GetFont()  
            button:GetFontString():SetFont(font, fontSize, flags)  
            if button == CmdPull and PCP_UpdatePullTimerTextSize then
                PCP_UpdatePullTimerTextSize(fontSize)
            end

            
            local row = math.floor((i - 1) / buttonsPerRow)  
            local col = (i - 1) % buttonsPerRow  

            if col == 0 then
                
                button:SetPoint("TOPLEFT", commandFrame, "TOPLEFT", 0, yOffset - (row * (buttonHeight + padding)))
            else
                
                local previousButton = _G[commandButtons[i - 1][1]]
                button:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", padding, 0)
            end
        end
    end

    
    return rows * (buttonHeight + padding)
end

function ResizeAddBotButtons()
    local width, height = addBotFrame:GetSize()     
    AddCustomBot:SetSize(width / 3, height / 4)  
    classButton:SetSize(width / 3 + 10, height / 4 + 5)  
    roleButton:SetSize(width / 3 + 10, height / 4 + 5)  

    
    local buttonWidth, buttonHeight = classButton:GetSize()
    local fontSize = math.max(9, math.min(buttonWidth / 5, buttonHeight / 3)) 
    local font, _, flags = classButton:GetFontString():GetFont()
    classButton:GetFontString():SetFont(font, fontSize, flags)

    buttonWidth, buttonHeight = roleButton:GetSize()
    fontSize = math.max(8, math.min(buttonWidth / 5, buttonHeight / 3))
    font, _, flags = roleButton:GetFontString():GetFont()
    roleButton:GetFontString():SetFont(font, fontSize, flags)

    
    local squareSize = math.min(width, height) / 3
    SetClassADDButton:SetSize(squareSize, squareSize)  
    SetClassSUBButton:SetSize(squareSize, squareSize)  
    SetRoleADDButton:SetSize(squareSize, squareSize)   
    SetRoleSUBButton:SetSize(squareSize, squareSize)   

    
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

    if PCPSpawnConfigButton then
        
        
        if PCP_UpdateSpawnConfigButtonText then
            PCP_UpdateSpawnConfigButtonText()
        end
        local currentAddClass = PCP_GetCurrentAddClass and PCP_GetCurrentAddClass() or ""
        if currentAddClass == "paladin" or currentAddClass == "shaman" or currentAddClass == "mage" then
            PCPSpawnConfigButton:Show()
        else
            PCPSpawnConfigButton:Hide()
        end
    end
end

local function ResizeMarkButtons()
    local width, height = markFrame:GetSize()
    width = width or 0
    height = height or 0

    
    
    
    
    local padding = math.floor(math.min(width, height) * 0.08)
    if padding < 2 then padding = 2 end

    local availableHeight = (height - (padding * 2)) * 1.3
    if availableHeight < 8 then availableHeight = 8 end

    local availableWidth = width - (padding * 4)
    if availableWidth < 60 then availableWidth = 60 end

    
    local sideSize = math.floor(math.min(availableHeight, availableWidth / 6))
    if sideSize < 8 then sideSize = 8 end

    
    local maxMainWidth = availableWidth - (sideSize * 2) - (padding * 2)
    local targetMainWidth = math.floor((sideSize * 2) + (width * 0.30))
    if targetMainWidth < 80 then targetMainWidth = 80 end
    if targetMainWidth > maxMainWidth then targetMainWidth = maxMainWidth end

    SetMarkADDButton:SetSize(sideSize, sideSize)
    SetMarkSUBButton:SetSize(sideSize, sideSize)
    markButton:SetSize(targetMainWidth, availableHeight)

    local fontSize = math.max(7, math.min(targetMainWidth / 8, availableHeight / 2))
    local font, _, flags = markButton:GetFontString():GetFont()
    markButton:GetFontString():SetFont(font, fontSize, flags)

    fontSize = math.max(6, math.min(sideSize / 2, 12))
    font, _, flags = SetMarkADDButton:GetFontString():GetFont()
    SetMarkADDButton:GetFontString():SetFont(font, fontSize, flags)
    font, _, flags = SetMarkSUBButton:GetFontString():GetFont()
    SetMarkSUBButton:GetFontString():SetFont(font, fontSize, flags)

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
    { key = "Controls", text = "Settings / Close", frame = controlsFrame, isControls = true },
    { key = "AddBot", text = "Add Bot", frame = addBotFrame, isAddBot = true },
    { key = "Commands", text = "Commands", frame = commandsFrame },
    { key = "PartyBot", text = "PartyBot Commands", frame = partyBotCommandsFrame },
    { key = "ComeTitle", text = "Come Title", frame = comeCommandTitleFrame, isTitle = true },
    { key = "Come", text = "Come Commands", frame = comeCommandFrame },
    { key = "MoveTitle", text = "Move Title", frame = moveCommandTitleFrame, isTitle = true },
    { key = "Move", text = "Move Commands", frame = moveCommandFrame },
    { key = "StayTitle", text = "Stay Title", frame = stayCommandTitleFrame, isTitle = true },
    { key = "Stay", text = "Stay Commands", frame = stayCommandFrame },
    { key = "Mark", text = "Mark Configurator", frame = markFrame },
    { key = "MarkCommands", text = "Mark Commands", frame = markCommandFrame },
}

local function PCP_GetSectionBackdropStyle()
    local style = PCP_GetBackdropStyle()
    if PCP_IsDathWTheme() then
        style.bgColor = { 0.03, 0.04, 0.07, 0.72 }
        style.borderColor = { 0.08, 0.10, 0.15, 1 }
    end
    return style
end

local function PCP_SetFrameBackdrop(target, enable, section)
    if not target then return end

    
    
    if target.SetBackdrop then
        target:SetBackdrop(nil)
    end

    if enable then
        if not target._pcpSectionBackdropFrame then
            target._pcpSectionBackdropFrame = CreateFrame("Frame", nil, target, "BackdropTemplate")
            target._pcpSectionBackdropFrame:SetFrameLevel(math.max(0, target:GetFrameLevel() - 1))
        end

        target._pcpSectionBackdropFrame:ClearAllPoints()
        local sidePad = 7
        local topPad = 7
        local bottomPad = 7
        target._pcpSectionBackdropFrame:SetPoint("TOPLEFT", target, "TOPLEFT", -sidePad, topPad)
        target._pcpSectionBackdropFrame:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", sidePad, -bottomPad)

        local style = PCP_GetSectionBackdropStyle()
        target._pcpSectionBackdropFrame:SetBackdrop({
            bgFile = style.bgFile,
            edgeFile = style.edgeFile,
            tile = style.tile, tileSize = style.tileSize, edgeSize = style.edgeSize,
            insets = style.insets,
        })
        target._pcpSectionBackdropFrame:SetBackdropColor(style.bgColor[1], style.bgColor[2], style.bgColor[3], style.bgColor[4])
        target._pcpSectionBackdropFrame:SetBackdropBorderColor(style.borderColor[1], style.borderColor[2], style.borderColor[3], style.borderColor[4])
        target._pcpSectionBackdropFrame:Show()
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
        backdropEnabled = backdropCheck:GetChecked() and true or false
    end

    local useSectionBackdrops = freeMode and backdropEnabled

    if useSectionBackdrops then
        if frame.SetBackdrop then frame:SetBackdrop(nil) end
        if frame._pcpMainBackdropFrame then frame._pcpMainBackdropFrame:Hide() end
        if resizeGrip then resizeGrip:Hide() end
    else
        ToggleBackdrop(frame, backdropEnabled)
        if resizeGrip then resizeGrip:Show() end
    end

    if freeMode then
        controlsFrame:Show()
        if settingsButton:GetParent() ~= controlsFrame then settingsButton:SetParent(controlsFrame) end
        if closeButton:GetParent() ~= controlsFrame then closeButton:SetParent(controlsFrame) end
        settingsButton:SetFrameLevel(controlsFrame:GetFrameLevel() + 50)
        closeButton:SetFrameLevel(controlsFrame:GetFrameLevel() + 50)
        ResizeControlsButtons()
    else
        controlsFrame:Hide()
        if settingsButton:GetParent() ~= frame then settingsButton:SetParent(frame) end
        if closeButton:GetParent() ~= frame then closeButton:SetParent(frame) end

        settingsButton:ClearAllPoints()
        settingsButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)
        settingsButton:SetFrameLevel(frame:GetFrameLevel() + 50)

        closeButton:ClearAllPoints()
        closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
        closeButton:SetFrameLevel(frame:GetFrameLevel() + 50)
    end

    for _, sec in ipairs(pcpSectionList) do
        PCP_SetFrameBackdrop(sec.frame, useSectionBackdrops and (not sec.isControls or freeMode), sec)
    end

    pcpUpdatingBackdropMode = false
end

local function PCP_RefreshControlsAndBackdrops()
    
    
    
    pcpLayoutRefreshNoManualSizing = true
    frame._pcpSizingHeightOverride = frame._pcpLastManualMainFrameHeight or frame:GetHeight() or 550
    if ApplyPCPSectionLayout then
        ApplyPCPSectionLayout(frame)
    end
    pcpLayoutRefreshNoManualSizing = false

    if PCP_UpdateFreeBackdropMode then
        PCP_UpdateFreeBackdropMode()
    end

    
    
    if PCP_AutoFitMainFrameToVisibleSections and not (PCP_Settings and PCP_Settings.freeSectionLayout == true) then
        PCP_AutoFitMainFrameToVisibleSections(frame._pcpLastFittedMainFrameHeight)
    end
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
        if PCP_Settings.sectionEnabled[sec.key] == nil then PCP_Settings.sectionEnabled[sec.key] = true end
    end
end

local function PCP_IsSectionEnabled(sec)
    PCP_EnsureSectionSettings()
    if sec and sec.isControls then
        return PCP_GetSettingBool("freeSectionLayout")
    end
    return PCP_Settings.sectionEnabled[sec.key] ~= false
end

PCP_ApplySectionVisibility = function()
    PCP_EnsureSectionSettings()
    for _, sec in ipairs(pcpSectionList) do
        if sec.frame then
            if PCP_IsSectionEnabled(sec) then sec.frame:Show() else sec.frame:Hide() end
        end
    end
    if PCP_UpdateFreeBackdropMode then
        PCP_UpdateFreeBackdropMode()
    end
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

    
    
    
    if not (PCP_Settings and PCP_Settings.freeSectionLayout == true) and PCP_Settings and PCP_Settings.sectionEnabled and PCP_Settings.sectionEnabled["AddBot"] == false then
        yOffset = yOffset - 24
    end

    if PCP_ApplySectionVisibility then
        PCP_ApplySectionVisibility()
    end

    for _, sec in ipairs(pcpSectionList) do
        if sec.frame then
            if PCP_IsSectionEnabled(sec) then
                sec.frame:SetParent(frame)
                sec.frame:Show()
                sec.frame:ClearAllPoints()
                sec.frame:SetPoint("TOP", frame, "TOP", 0, yOffset)
                yOffset = yOffset - ((sec.frame.GetHeight and sec.frame:GetHeight()) or 0) - padding
            else
                sec.frame:Hide()
            end
        end
    end
end

local function PCP_UpdateSectionResizeLive(sec, saveSize)
    if not sec or not sec.frame then return end
    if saveSize then
        PCP_SaveSectionSize(sec)
    end
    PCP_RefreshSectionContents(sec)
    PCP_RestackSectionsUsingCurrentSizes()
    if PCP_UpdateSectionResizeMode then
        PCP_UpdateSectionResizeMode()
    end
end


function PCP_SnapAllSectionsToGrid()
    if not PCP_GetSettingBool("freeSectionLayout") then return end
    PCP_EnsureSectionSettings()
    for _, sec in ipairs(pcpSectionList) do
        if sec.frame and PCP_IsSectionEnabled(sec) then
            PCP_SaveSectionPosition(sec)
        end
    end
    if ApplyPCPSectionLayout then
        ApplyPCPSectionLayout(frame)
    end
end

local function PCP_StartSectionAltDrag(sec)
    if not sec or not sec.frame then return end
    if not PCP_GetSettingBool("freeSectionLayout") then return end
    if not IsAltKeyDown() then return end

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

local function PCP_AttachAltDragToSectionChildren(sec)
    if not sec or not sec.frame then return end

    local children = { sec.frame:GetChildren() }
    for _, child in ipairs(children) do
        if child and child ~= sec.resizeGrip and not child._pcpAltDragHooked then
            child._pcpAltDragHooked = true

            if child.RegisterForDrag then
                child:RegisterForDrag("LeftButton")
            end

            child:SetScript("OnDragStart", function()
                PCP_StartSectionAltDrag(sec)
            end)

            child:SetScript("OnDragStop", function()
                PCP_StopSectionAltDrag(sec)
            end)
        end
    end
end

local function PCP_MakeSectionDraggable(sec)
    if not sec or not sec.frame or sec.dragReady then return end
    sec.dragReady = true
    sec.frame:EnableMouse(false)
    sec.frame:SetMovable(true)
    sec.frame:RegisterForDrag("LeftButton")
    sec.frame:SetScript("OnDragStart", function()
        PCP_StartSectionAltDrag(sec)
    end)
    sec.frame:SetScript("OnDragStop", function()
        PCP_StopSectionAltDrag(sec)
    end)
    sec.frame:SetScript("OnEnter", function()
        if not PCP_GetSettingBool("freeSectionLayout") then return end
        GameTooltip:SetOwner(sec.frame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Hold ALT + drag to move this section", 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    sec.frame:SetScript("OnLeave", function() GameTooltip:Hide() end)

    
    
    
    PCP_AttachAltDragToSectionChildren(sec)
end

local function PCP_SetFreeSectionScriptsEnabled(enabled)
    for _, sec in ipairs(pcpSectionList) do
        PCP_MakeSectionDraggable(sec)
        PCP_AttachAltDragToSectionChildren(sec)
        if sec.frame then
            if enabled and PCP_IsSectionEnabled(sec) then sec.frame:EnableMouse(true) else sec.frame:EnableMouse(false) end
        end
    end
end

local function PCP_MakeSectionResizable(sec)
    if not sec or not sec.frame or sec.resizeReady then return end
    sec.resizeReady = true
    if sec.frame.SetResizable then sec.frame:SetResizable(true) end
    if sec.frame.SetMinResize then sec.frame:SetMinResize(80, 20) end

    local grip = CreateFrame("Button", nil, sec.frame)
    grip:SetSize(12, 12)
    grip:SetPoint("BOTTOMRIGHT", sec.frame, "BOTTOMRIGHT", -1, 1)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetFrameLevel(sec.frame:GetFrameLevel() + 20)
    grip:EnableMouse(true)
    grip:Hide()
    grip:SetScript("OnEnter", function(self)
        if not PCP_GetSettingBool("resizableSections") then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
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
    grip:SetScript("OnUpdate", function(_, elapsed)
        if not sec._pcpResizing then return end
        sec._pcpResizeElapsed = (sec._pcpResizeElapsed or 0) + (elapsed or 0)
        if sec._pcpResizeElapsed < 0.03 then return end
        sec._pcpResizeElapsed = 0
        PCP_UpdateSectionResizeLive(sec, false)
    end)
    sec.resizeGrip = grip
end

PCP_UpdateSectionResizeMode = function()
    local enabled = PCP_GetSettingBool("resizableSections")
    for _, sec in ipairs(pcpSectionList) do
        PCP_MakeSectionResizable(sec)
        if sec.resizeGrip then
            if enabled and PCP_IsSectionEnabled(sec) then sec.resizeGrip:Show() else sec.resizeGrip:Hide() end
        end
    end
end

ApplyPCPSectionLayout = function(parent)
    PCP_EnsureSectionSettings()
    PCP_ApplySectionVisibility()
    local freeMode = PCP_GetSettingBool("freeSectionLayout")
    PCP_SetFreeSectionScriptsEnabled(freeMode)
    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
    PCP_ApplySavedSectionSizes()
    if not freeMode then
        if parent and parent:GetScript("OnSizeChanged") then parent:GetScript("OnSizeChanged")(parent) end
        return
    end
    for _, sec in ipairs(pcpSectionList) do
        if sec.frame and PCP_IsSectionEnabled(sec) then
            sec.frame:SetParent(frame)
            local pos = PCP_Settings.sectionPositions[sec.key]
            PCP_ApplySectionSize(sec)
            if pos and pos.x and pos.y then
                sec.frame:ClearAllPoints()
                sec.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", pos.x, pos.y)
            elseif sec.isControls then
                if not PCP_HasSavedSectionSize(sec) then
                    local frameH = frame:GetHeight() or 550
                    local defaultPadding = frameH * 0.005
                    local defaultW = (frame:GetWidth() or 260) - (defaultPadding * 2) - 14
                    if defaultW < 160 then defaultW = 160 end
                    sec.frame:SetWidth(defaultW)
                    sec.frame:SetHeight(28)
                end
                sec.frame:ClearAllPoints()
                
                
                sec.frame:SetPoint("BOTTOM", frame, "TOP", 0, 8)
            end
        end
    end
    if PCP_UpdateFreeBackdropMode then
        PCP_UpdateFreeBackdropMode()
    end
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
    PCP_ApplySectionVisibility()
    PCP_SetFreeSectionScriptsEnabled(PCP_GetSettingBool("freeSectionLayout"))
    if ApplyPCPSectionLayout then
        ApplyPCPSectionLayout(frame)
    end
    if PCP_UpdateSectionResizeMode then PCP_UpdateSectionResizeMode() end
    if PCP_UpdateFreeBackdropMode then PCP_UpdateFreeBackdropMode() end
end

PCP_ShowSectionOptions = function(forceOpen)
    PCP_EnsureSectionSettings()
    if not PCPSectionOptionsFrame then
        local popup = CreateFrame("Frame", "PCPSectionOptionsFrame", UIParent, "BackdropTemplate")
        popup:SetSize(230, 72 + (table.getn(pcpSectionList) * 24) + 42)
        popup:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        popup:SetFrameStrata("FULLSCREEN_DIALOG")
        popup:SetFrameLevel(220)
        if popup.SetToplevel then popup:SetToplevel(true) end
        popup:SetMovable(true)
        popup:EnableMouse(true)
        popup:RegisterForDrag("LeftButton")
        popup:SetScript("OnDragStart", function() popup:StartMoving() end)
        popup:SetScript("OnDragStop", function() popup:StopMovingOrSizing() end)
        popup:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } })
        popup:SetBackdropColor(0, 0, 0, 0.9)
        local title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetPoint("TOP", popup, "TOP", 0, -12)
        title:SetText("Visible sections")
        popup.checks = {}
        local y = -38
        for _, sec in ipairs(pcpSectionList) do
            if not sec.isControls then
                local cb = CreateFrame("CheckButton", nil, popup, "UICheckButtonTemplate")
                cb:SetPoint("TOPLEFT", popup, "TOPLEFT", 14, y)
                cb:SetHitRectInsets(0, -150, 0, 0)
                cb.text = cb:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                cb.text:SetPoint("LEFT", cb, "RIGHT", 4, 0)
                cb.text:SetText(sec.text or sec.key)
                cb._pcpSection = sec
                cb:SetScript("OnClick", function(self)
                    PCP_EnsureSectionSettings()
                    PCP_Settings.sectionEnabled[self._pcpSection.key] = self:GetChecked() and true or false
                    if PCP_RefreshControlsAndBackdrops then
                        PCP_RefreshControlsAndBackdrops()
                    elseif ApplyPCPSectionLayout then
                        ApplyPCPSectionLayout(frame)
                    end
                end)
                popup.checks[#popup.checks + 1] = cb
                y = y - 24
            end
        end
        local showAll = CreateFrame("Button", "PCPSectionOptionsShowAllButton", popup, "UIPanelButtonTemplate")
        showAll:SetSize(85, 22)
        showAll:SetPoint("BOTTOMLEFT", popup, "BOTTOMLEFT", 18, 12)
        showAll:SetText("Show All")
        popup.showAllButton = showAll
        PCP_RegisterThemedButton(showAll)
        showAll:SetScript("OnClick", function()
            PCP_EnsureSectionSettings()
            for _, sec in ipairs(pcpSectionList) do if not sec.isControls then PCP_Settings.sectionEnabled[sec.key] = true end end
            if PCP_RefreshControlsAndBackdrops then
                PCP_RefreshControlsAndBackdrops()
            elseif ApplyPCPSectionLayout then
                ApplyPCPSectionLayout(frame)
            end
            for _, cb in ipairs(PCPSectionOptionsFrame.checks or {}) do
                if cb and cb._pcpSection then cb:SetChecked(PCP_IsSectionEnabled(cb._pcpSection)) end
            end
        end)
        local close = CreateFrame("Button", "PCPSectionOptionsCloseButton", popup, "UIPanelButtonTemplate")
        close:SetSize(85, 22)
        close:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -18, 12)
        close:SetText("Close")
        popup.closeButton = close
        PCP_RegisterThemedButton(close)
        close:SetScript("OnClick", function() popup:Hide() end)
        if toggleButtonAppearance then toggleButtonAppearance(true, defaultColor) end
    end
    
    
    
    if PCPSectionOptionsFrame.showAllButton then PCP_RegisterThemedButton(PCPSectionOptionsFrame.showAllButton) end
    if PCPSectionOptionsFrame.closeButton then PCP_RegisterThemedButton(PCPSectionOptionsFrame.closeButton) end
    if toggleButtonAppearance then toggleButtonAppearance(true, defaultColor) end

    for _, cb in ipairs(PCPSectionOptionsFrame.checks or {}) do
        if cb and cb._pcpSection then cb:SetChecked(PCP_IsSectionEnabled(cb._pcpSection)) end
    end
    if forceOpen then
        PCPSectionOptionsFrame:Show()
        if PCPSectionOptionsFrame.Raise then PCPSectionOptionsFrame:Raise() end
    elseif PCPSectionOptionsFrame:IsShown() then
        PCPSectionOptionsFrame:Hide()
    else
        PCPSectionOptionsFrame:Show()
        if PCPSectionOptionsFrame.Raise then PCPSectionOptionsFrame:Raise() end
    end
end

local pcpAutoFitMainFrame = false
local pcpLayoutRefreshNoManualSizing = false
frame._pcpLastManualMainFrameHeight = frame:GetHeight() or 550

local function PCP_GetNormalLayoutHeaderGap()
    if not (PCP_Settings and PCP_Settings.freeSectionLayout == true)
        and PCP_Settings and PCP_Settings.sectionEnabled
        and PCP_Settings.sectionEnabled["AddBot"] == false then
        return 28
    end
    return 0
end

function PCP_AutoFitMainFrameToVisibleSections(targetHeight)
    if not targetHeight or targetHeight < 120 then targetHeight = 120 end
    if frame._pcpManualResizing then return end
    local currentHeight = frame:GetHeight() or 0
    if math.abs(currentHeight - targetHeight) <= 1 then return end

    
    
    
    frame._pcpSizingHeightOverride = frame._pcpLastManualMainFrameHeight or currentHeight
    pcpAutoFitMainFrame = true
    frame:SetHeight(targetHeight)
    pcpAutoFitMainFrame = false
end

frame:SetScript("OnSizeChanged", function(self)
    local width, height = self:GetSize()

    
    
    
    local sizingHeight = height
    if frame._pcpManualResizing then
        
        
        frame._pcpSizingHeightOverride = nil
        sizingHeight = height
        frame._pcpLastManualMainFrameHeight = height
    elseif frame._pcpSizingHeightOverride then
        sizingHeight = frame._pcpSizingHeightOverride
        frame._pcpSizingHeightOverride = nil
    elseif pcpAutoFitMainFrame or pcpLayoutRefreshNoManualSizing then
        sizingHeight = frame._pcpLastManualMainFrameHeight or height
    else
        frame._pcpLastManualMainFrameHeight = height
    end

    local padding = sizingHeight * 0.005
    local outerMargin = 8


    local totalHeight = sizingHeight - (padding + outerMargin) * 2


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

    
    

    
    
    
    
    
    if frame._pcpManualResizing and PCP_Settings and PCP_Settings.sectionEnabled then
        local function IsVisibleSectionKey(key)
            return not (PCP_Settings.sectionEnabled and PCP_Settings.sectionEnabled[key] == false)
        end

        local visibleCount = 0
        local function CountVisible(key)
            if IsVisibleSectionKey(key) then visibleCount = visibleCount + 1 end
        end

        CountVisible("AddBot")
        CountVisible("Commands")
        CountVisible("PartyBot")
        CountVisible("ComeTitle")
        CountVisible("Come")
        CountVisible("MoveTitle")
        CountVisible("Move")
        CountVisible("StayTitle")
        CountVisible("Stay")
        CountVisible("Mark")
        CountVisible("MarkCommands")

        local fixedHeight = 0
        if IsVisibleSectionKey("ComeTitle") then fixedHeight = fixedHeight + 10 end
        if IsVisibleSectionKey("MoveTitle") then fixedHeight = fixedHeight + 10 end
        if IsVisibleSectionKey("StayTitle") then fixedHeight = fixedHeight + 10 end

        local headerGap = PCP_GetNormalLayoutHeaderGap()
        local spacingHeight = (visibleCount * padding) + ((padding + outerMargin) * 2) + headerGap

        local weights = {
            AddBot = 0.12,
            Commands = 0.19,
            PartyBot = 0.19,
            Come = 0.05,
            Move = 0.05,
            Stay = 0.05,
            Mark = 0.04,
            MarkCommands = 0.15,
        }

        local totalWeight = 0
        for key, weight in pairs(weights) do
            if IsVisibleSectionKey(key) then
                totalWeight = totalWeight + weight
            end
        end

        local flexibleHeight = sizingHeight - spacingHeight - fixedHeight
        if flexibleHeight < 40 then flexibleHeight = 40 end

        if totalWeight > 0 then
            if IsVisibleSectionKey("AddBot") then frameHeights.addBotFrame = flexibleHeight * (weights.AddBot / totalWeight) end
            if IsVisibleSectionKey("Commands") then frameHeights.commandsFrame = flexibleHeight * (weights.Commands / totalWeight) end
            if IsVisibleSectionKey("PartyBot") then frameHeights.partyBotCommandsFrame = flexibleHeight * (weights.PartyBot / totalWeight) end
            if IsVisibleSectionKey("Come") then frameHeights.comeCommandFrame = flexibleHeight * (weights.Come / totalWeight) end
            if IsVisibleSectionKey("Move") then frameHeights.moveCommandFrame = flexibleHeight * (weights.Move / totalWeight) end
            if IsVisibleSectionKey("Stay") then frameHeights.stayCommandFrame = flexibleHeight * (weights.Stay / totalWeight) end
            if IsVisibleSectionKey("Mark") then frameHeights.markFrame = flexibleHeight * (weights.Mark / totalWeight) end
            if IsVisibleSectionKey("MarkCommands") then frameHeights.markCommandFrame = flexibleHeight * (weights.MarkCommands / totalWeight) end
        end
    end
    
    local function PCP_FindSection(secKey)
        for _, sec in ipairs(pcpSectionList or {}) do
            if sec.key == secKey then return sec end
        end
        return nil
    end

    local function SetDefaultSectionHeight(secKey, sectionFrame, defaultHeight)
        if not PCP_HasSavedSectionSize(PCP_FindSection(secKey)) then
            sectionFrame:SetHeight(defaultHeight)
        end
    end

    SetDefaultSectionHeight("AddBot", addBotFrame, frameHeights.addBotFrame)
    SetDefaultSectionHeight("Commands", commandsFrame, frameHeights.commandsFrame)
    SetDefaultSectionHeight("ComeTitle", comeCommandTitleFrame, frameHeights.comeCommandTitleFrame)
    SetDefaultSectionHeight("Come", comeCommandFrame, frameHeights.comeCommandFrame)
    SetDefaultSectionHeight("MoveTitle", moveCommandTitleFrame, frameHeights.moveCommandTitleFrame)
    SetDefaultSectionHeight("Move", moveCommandFrame, frameHeights.moveCommandFrame)
    SetDefaultSectionHeight("StayTitle", stayCommandTitleFrame, frameHeights.stayCommandTitleFrame)
    SetDefaultSectionHeight("Stay", stayCommandFrame, frameHeights.stayCommandFrame)
    SetDefaultSectionHeight("PartyBot", partyBotCommandsFrame, frameHeights.partyBotCommandsFrame)
    SetDefaultSectionHeight("Mark", markFrame, frameHeights.markFrame)
    SetDefaultSectionHeight("MarkCommands", markCommandFrame, frameHeights.markCommandFrame)

    
    local frameWidth = width - (padding + outerMargin) * 2
    local function SetDefaultSectionWidth(secKey, sectionFrame, defaultWidth)
        if not PCP_HasSavedSectionSize(PCP_FindSection(secKey)) then
            sectionFrame:SetWidth(defaultWidth)
        end
    end

    SetDefaultSectionWidth("AddBot", addBotFrame, frameWidth)
    SetDefaultSectionWidth("Commands", commandsFrame, frameWidth)
    SetDefaultSectionWidth("ComeTitle", comeCommandTitleFrame, frameWidth)
    SetDefaultSectionWidth("Come", comeCommandFrame, frameWidth)
    SetDefaultSectionWidth("MoveTitle", moveCommandTitleFrame, frameWidth)
    SetDefaultSectionWidth("Move", moveCommandFrame, frameWidth)
    SetDefaultSectionWidth("StayTitle", stayCommandTitleFrame, frameWidth)
    SetDefaultSectionWidth("Stay", stayCommandFrame, frameWidth)
    SetDefaultSectionWidth("PartyBot", partyBotCommandsFrame, frameWidth)
    SetDefaultSectionWidth("Mark", markFrame, frameWidth)
    SetDefaultSectionWidth("MarkCommands", markCommandFrame, frameWidth)

    PCP_ApplySavedSectionSizes()

    
    
    if PCP_Settings and PCP_Settings.freeSectionLayout == true and not pcpForceNormalLayout then
        PCP_RefreshSectionContents()

        if ApplyPCPSectionLayout then
            ApplyPCPSectionLayout(frame)
        end
        return
    end

    
    local yOffset = -padding

    
    
    
    yOffset = yOffset - PCP_GetNormalLayoutHeaderGap()

    if PCP_ApplySectionVisibility then
        PCP_ApplySectionVisibility()
    end

    local function PositionSection(secKey, sectionFrame, h)
        if PCP_Settings and PCP_Settings.sectionEnabled and PCP_Settings.sectionEnabled[secKey] == false then
            sectionFrame:Hide()
            return
        end
        sectionFrame:SetParent(frame)
        sectionFrame:Show()
        sectionFrame:ClearAllPoints()
        sectionFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
        if sectionFrame.GetHeight then
            h = sectionFrame:GetHeight() or h
        end
        yOffset = yOffset - h - padding
    end

    PositionSection("AddBot", addBotFrame, frameHeights.addBotFrame)
    PositionSection("Commands", commandsFrame, frameHeights.commandsFrame)
    PositionSection("PartyBot", partyBotCommandsFrame, frameHeights.partyBotCommandsFrame)
    PositionSection("ComeTitle", comeCommandTitleFrame, frameHeights.comeCommandTitleFrame)
    PositionSection("Come", comeCommandFrame, frameHeights.comeCommandFrame)
    PositionSection("MoveTitle", moveCommandTitleFrame, frameHeights.moveCommandTitleFrame)
    PositionSection("Move", moveCommandFrame, frameHeights.moveCommandFrame)
    PositionSection("StayTitle", stayCommandTitleFrame, frameHeights.stayCommandTitleFrame)
    PositionSection("Stay", stayCommandFrame, frameHeights.stayCommandFrame)
    PositionSection("Mark", markFrame, frameHeights.markFrame)
    PositionSection("MarkCommands", markCommandFrame, frameHeights.markCommandFrame)

    local fittedHeight = (-yOffset) + padding + outerMargin
    if fittedHeight < 120 then fittedHeight = 120 end

    PCP_RefreshSectionContents()
    if PCP_UpdateFreeBackdropMode then
        PCP_UpdateFreeBackdropMode()
    end

    frame._pcpLastFittedMainFrameHeight = fittedHeight
end)
	frame:GetScript("OnSizeChanged")(frame)
    if ApplyPCPSectionLayout then
        ApplyPCPSectionLayout(frame)
    end



    ---------------------------------------------------------------------------
    -- Custom Frames
    ---------------------------------------------------------------------------

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
        local track = CreateFrame("Frame", nil, parent, "BackdropTemplate")
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

        local thumb = CreateFrame("Frame", nil, track, "BackdropTemplate")
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
        widget:SetScript("OnEnter", function(self)
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
        data.width = runtime:GetWidth() or data.width or 260
        data.height = runtime:GetHeight() or data.height or 120
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
            local col = ((i - 1) % cols)
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
            btn:SetSize(buttonW, buttonH)
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
            f = CreateFrame("Frame", "PCPCustomFrame" .. index, UIParent, "BackdropTemplate")
            PCP_CustomFrameRuntime[index] = f
            f._pcpIsCustomRuntime = true
            f:SetMovable(true)
            f:SetResizable(true)
            f:SetMinResize(24, 24)
            f:EnableMouse(true)
            f:RegisterForDrag("LeftButton")
            f:SetScript("OnDragStart", function(self)
                if PCP_AreCustomFramesLocked and PCP_AreCustomFramesLocked() then return end
                self:StartMoving()
            end)
            f:SetScript("OnDragStop", function(self)
                self:StopMovingOrSizing()
                PCP_SaveCustomFramePosition(index)
            end)
            f:SetScript("OnSizeChanged", function(self)
                PCP_SaveCustomFramePosition(index)
                PCP_CustomFrameLayout(index)
            end)

            f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            f.title:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 4, 2)
            f.title:SetJustifyH("LEFT")
            PCP_CustomRegisterText(f, f.title)

            f.close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
            f.close:SetSize(18, 18)
            f.close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -5)
            f.close:SetText("X")
            f.close:SetScript("OnClick", function() f:Hide() end)
            f.close:Hide()
            PCP_RegisterThemedButton(f.close)

            f.resizeGrip = CreateFrame("Button", nil, f)
            f.resizeGrip:SetSize(16, 16)
            f.resizeGrip:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
            f.resizeGrip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
            f.resizeGrip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
            f.resizeGrip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
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

        f:SetSize(data.width or 260, data.height or 120)
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
            btn:SetScript("OnClick", function(self)
                local cd = PCP_EnsureCustomFramesStorage()[self._pcpCustomFrameIndex]
                local bd = cd and cd.buttons and cd.buttons[self._pcpCustomButtonIndex]
                if bd then PCP_DispatchCustomFrameCommand(bd.command) end
            end)
            btn:SetScript("OnEnter", function(self)
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

            local bg = CreateFrame("Frame", nil, parent, "BackdropTemplate")
            bg:SetSize(boxW, boxH)
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
            sf:SetScript("OnMouseWheel", function(self, delta)
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
            eb:SetJustifyV("TOP")
            eb:SetTextInsets(0, 0, 0, 0)
            eb:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
            eb:SetScript("OnCursorChanged", function(self, x, y, width, height)
                if sf and sf.UpdateScrollChildRect then sf:UpdateScrollChildRect() end
            end)
            eb:SetScript("OnTextChanged", function(self)
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

        local eb = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
        eb:SetSize(w or 160, h or 22)
        eb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y - 15)
        eb:SetAutoFocus(false)
        eb._pcpLabel = fs
        eb._pcpTooltipOwner = eb
        return eb
    end

    function PCP_SetEditBoxText(box, text)
        if not box then return end
        box:SetText(text or "")
        box:SetCursorPosition(0)
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
                PCPCustomButtonEditorFrame:SetSize(330, 330)
                PCPCustomButtonEditorFrame:SetFrameLevel(PCPCustomFramesEditorFrame:GetFrameLevel() + 5)
            end
            return
        end
        local parent = PCPCustomFramesEditorFrame or UIParent
        local f = CreateFrame("Frame", "PCPCustomButtonEditorFrame", parent, "BackdropTemplate")
        
        
        f:SetSize(330, 330)
        if parent == UIParent then
            f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
            f:SetFrameStrata("FULLSCREEN_DIALOG")
            f:SetFrameLevel(230)
            f:EnableMouse(true)
            f:SetMovable(true)
            f:RegisterForDrag("LeftButton")
            f:SetScript("OnDragStart", function(self) self:StartMoving() end)
            f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
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
        f.iconSelect:SetSize(42, 42)
        f.iconSelect:SetPoint("TOPLEFT", f, "TOPLEFT", 24, -268)
        f.iconSelect:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
        f.iconSelect.tex = f.iconSelect:CreateTexture(nil, "OVERLAY")
        f.iconSelect.tex:SetAllPoints(f.iconSelect)
        f.iconSelect.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        f.iconSelect:SetScript("OnClick", function()
            PCP_CustomFrameEditorState.iconTarget = f.iconBox
            PCP_ShowIconPicker()
        end)
        f.iconSelect:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText("Click to pick icon", 1, 1, 1, 1, true)
            GameTooltip:Show()
        end)
        f.iconSelect:SetScript("OnLeave", function() GameTooltip:Hide() end)

        f.typeText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.typeText:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -42)
        PCP_CustomRegisterText(f, f.typeText)

        f.typeToggle = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.typeToggle:SetSize(90, 22)
        f.typeToggle:SetPoint("TOPLEFT", f, "TOPLEFT", 190, -60)
        f.typeToggle:SetText("Toggle type")
        PCP_SetCustomTooltip(f.typeToggle, "Toggle type", "Switch between a text button and an icon button.", "Icon buttons use the selected icon preview below.")
        f.typeToggle:SetScript("OnClick", function()
            f._pcpButtonType = (f._pcpButtonType == "icon") and "text" or "icon"
            if PCP_UpdateCustomButtonEditorTypeVisual then PCP_UpdateCustomButtonEditorTypeVisual() end
        end)
        PCP_RegisterThemedButton(f.typeToggle)

        f.pickIcon = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.pickIcon:SetSize(70, 22)
        f.pickIcon:SetPoint("LEFT", f.iconBox, "RIGHT", 8, 0)
        f.pickIcon:SetText("Pick")
        f.pickIcon:SetScript("OnClick", function()
            PCP_CustomFrameEditorState.iconTarget = f.iconBox
            PCP_ShowIconPicker()
        end)
        PCP_RegisterThemedButton(f.pickIcon)
        f.pickIcon:Hide()

        f.save = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.save:SetSize(80, 24)
        f.save:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 70, 14)
        f.save:SetText("Add/Save")
        PCP_SetCustomTooltip(f.save, "Save button", "Save this custom button to the selected frame.")
        f.save:SetScript("OnClick", PCP_SaveCustomButtonEditor)
        PCP_RegisterThemedButton(f.save)

        f.cancel = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.cancel:SetSize(80, 24)
        f.cancel:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -70, 14)
        f.cancel:SetText("Clear")
        PCP_SetCustomTooltip(f.cancel, "Clear editor", "Clear the button editor and start a new button.")
        f.cancel:SetScript("OnClick", function() PCP_ShowCustomButtonEditor(nil) end)
        PCP_RegisterThemedButton(f.cancel)
    end

    function PCP_EnsureIconPicker()
        if PCPIconPickerFrame then return end
        local f = CreateFrame("Frame", "PCPIconPickerFrame", UIParent, "BackdropTemplate")
        f:SetSize(430, 360)
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:SetFrameLevel(240)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(self) self:StartMoving() end)
        f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
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
        f.close:SetSize(70, 22)
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
            btn:SetSize(size, size)
            local col = ((i - 1) % cols)
            local row = math.floor((i - 1) / cols)
            btn:SetPoint("TOPLEFT", f, "TOPLEFT", startX + col * (size + gap), startY - row * (size + gap))
            btn.tex = btn:CreateTexture(nil, "OVERLAY")
            btn.tex:SetAllPoints(btn)
            btn.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
            btn:SetScript("OnClick", function(self)
                if PCP_CustomFrameEditorState.iconTarget and self._pcpIconPath then
                    PCP_CustomFrameEditorState.iconTarget:SetText(self._pcpIconPath)
                    PCP_CustomFrameEditorState.iconTarget:SetCursorPosition(0)
                    if PCP_UpdateCustomButtonEditorTypeVisual then PCP_UpdateCustomButtonEditorTypeVisual() end
                end
                f:Hide()
            end)
            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(self._pcpIconName or self._pcpIconPath or "Icon", 1, 1, 1, 1, true)
                if self._pcpIconPath then GameTooltip:AddLine(self._pcpIconPath, 0.7, 0.7, 0.7, true) end
                GameTooltip:Show()
            end)
            btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            btn:EnableMouseWheel(true)
            btn:SetScript("OnMouseWheel", function(self, delta)
                if PCP_SetIconPickerScrollOffset then
                    PCP_SetIconPickerScrollOffset((f.iconScrollOffset or 0) - (delta or 0))
                end
            end)
            f.icons[i] = btn
        end

        f.iconScrollTrack = CreateFrame("Frame", nil, f, "BackdropTemplate")
        f.iconScrollTrack:SetSize(14, 250)
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
        f.iconScrollTrack:EnableMouseWheel(true)
        f.iconScrollTrack:SetScript("OnMouseWheel", function(self, delta)
            if PCP_SetIconPickerScrollOffset then
                PCP_SetIconPickerScrollOffset((f.iconScrollOffset or 0) - (delta or 0))
            end
        end)

        f.iconScrollUp = CreateFrame("Button", nil, f.iconScrollTrack)
        f.iconScrollUp:SetSize(12, 14)
        f.iconScrollUp:SetPoint("TOP", f.iconScrollTrack, "TOP", 0, -2)
        f.iconScrollUp:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up")
        f.iconScrollUp:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down")
        f.iconScrollUp:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
        f.iconScrollUp:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight", "ADD")
        f.iconScrollUp:SetScript("OnClick", function()
            if PCP_SetIconPickerScrollOffset then PCP_SetIconPickerScrollOffset((f.iconScrollOffset or 0) - 1) end
        end)

        f.iconScrollDown = CreateFrame("Button", nil, f.iconScrollTrack)
        f.iconScrollDown:SetSize(12, 14)
        f.iconScrollDown:SetPoint("BOTTOM", f.iconScrollTrack, "BOTTOM", 0, 2)
        f.iconScrollDown:SetNormalTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up")
        f.iconScrollDown:SetPushedTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down")
        f.iconScrollDown:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
        f.iconScrollDown:SetHighlightTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight", "ADD")
        f.iconScrollDown:SetScript("OnClick", function()
            if PCP_SetIconPickerScrollOffset then PCP_SetIconPickerScrollOffset((f.iconScrollOffset or 0) + 1) end
        end)

        f.iconScrollThumb = CreateFrame("Frame", nil, f.iconScrollTrack, "BackdropTemplate")
        f.iconScrollThumb:SetSize(8, 32)
        f.iconScrollThumb:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
        f.iconScrollThumb:SetBackdropColor(0.75, 0.75, 0.75, 0.85)

        f.iconCountText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        f.iconCountText:SetPoint("BOTTOM", f, "BOTTOM", 0, 12)
        f.iconCountText:SetText("")
        PCP_CustomRegisterText(f, f.iconCountText)

        f:EnableMouseWheel(true)
        f:SetScript("OnMouseWheel", function(self, delta)
            if PCP_SetIconPickerScrollOffset then
                PCP_SetIconPickerScrollOffset((self.iconScrollOffset or 0) - (delta or 0))
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

        local f = CreateFrame("Frame", "PCPCustomFramesEditorFrame", UIParent, "BackdropTemplate")
        f:SetSize(1040, 520)
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        f:SetFrameStrata("FULLSCREEN_DIALOG")
        f:SetFrameLevel(220)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function(self) self:StartMoving() end)
        f:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
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
            local panel = CreateFrame("Frame", name, f, "BackdropTemplate")
            panel:SetPoint("TOPLEFT", f, "TOPLEFT", x, y)
            panel:SetSize(w, h)
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
        f.newFrame:SetSize(95, 22)
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
        f.lockFramesCheck:SetScript("OnClick", function(self)
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
        PCP_SetCustomTooltip(f.showFrameNameCheck, "Show frame name", "Shows the name/title above each custom frame.", "When disabled, names stay hidden even while the Custom Frames editor is open.")
        f.showFrameNameCheck:SetScript("OnClick", function(self)
            if not PCP_Settings then PCP_Settings = {} end
            PCP_Settings.showCustomFrameNames = self:GetChecked() and true or false
            if PCP_UpdateCustomFrameNameMode then PCP_UpdateCustomFrameNameMode() end
        end)

        
        f.deleteFrame = nil

        f.close = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.close:SetSize(70, 22)
        f.close:SetPoint("TOPRIGHT", f, "TOPRIGHT", -22, -28)
        f.close:SetText("Close")
        f.close:SetScript("OnClick", function() f:Hide() end)
        PCP_SetCustomTooltip(f.close, "Close", "Close the Custom Frames editor.")
        PCP_RegisterThemedButton(f.close)

        f.frameScroll = CreateFrame("ScrollFrame", nil, f)
        f.frameScroll:SetPoint("TOPLEFT", f, "TOPLEFT", 28, -112)
        f.frameScroll:SetSize(220, 290)
        f.frameScroll:EnableMouseWheel(true)
        f.frameScroll:SetScript("OnMouseWheel", function(self, delta)
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
        f.frameScrollChild:SetSize(220, 290)
        f.frameScroll:SetScrollChild(f.frameScrollChild)

        f.frameRows = {}
        for i = 1, 10 do
            local row = CreateFrame("Button", nil, f.frameScrollChild, "UIPanelButtonTemplate")
            row:SetSize(184, 24)
            row:SetPoint("TOPLEFT", f.frameScrollChild, "TOPLEFT", 0, -((i - 1) * 30))
            row._pcpRowIndex = i
            PCP_SetCustomTooltip(row, "Select frame", "Select this custom frame for editing.")
            row:SetScript("OnClick", function(self)
                if not self._pcpFrameIndex then return end
                PCP_CustomFrameEditorState.selectedFrame = self._pcpFrameIndex
                PCP_CustomFrameEditorState.selectedButton = nil
                PCP_CustomFrameEditorState.buttonScrollOffset = 0
                if PCP_ShowCustomButtonEditor then PCP_ShowCustomButtonEditor(nil) end
                PCP_RefreshCustomFramesEditor()
            end)

            row.deleteButton = CreateFrame("Button", nil, f.frameScrollChild, "UIPanelButtonTemplate")
            row.deleteButton:SetSize(22, 22)
            row.deleteButton:SetPoint("LEFT", row, "RIGHT", 4, 0)
            row.deleteButton:SetText("X")
            PCP_SetCustomTooltip(row.deleteButton, "Delete frame", "Delete this custom frame and all buttons inside it.")
            row.deleteButton:SetScript("OnClick", function(self)
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
        f.alwaysShowCheck:SetScript("OnClick", function(self)
            local data = PCP_EnsureCustomFramesStorage()[PCP_CustomFrameEditorState.selectedFrame or 1]
            if not data then return end
            data.alwaysShow = self:GetChecked() and true or false
            if PCP_UpdateCustomFrameVisibility then PCP_UpdateCustomFrameVisibility(PCP_CustomFrameEditorState.selectedFrame or 1) end
        end)
        PCP_SetCustomTooltip(f.alwaysShowCheck, "Always show", "Keep this custom frame visible even when the main PCP frame is hidden.")

        f.saveFrame = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.saveFrame:SetSize(80, 22)
        f.saveFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 525, -220)
        f.saveFrame:SetText("Apply")
        PCP_SetCustomTooltip(f.saveFrame, "Apply frame settings", "Save frame name, width, height, spacing and Always show.", "The frame preview updates immediately.")
        f.saveFrame:SetScript("OnClick", function()
            local data = PCP_EnsureCustomFramesStorage()[PCP_CustomFrameEditorState.selectedFrame or 1]
            if not data then return end
            data.name = PCP_GetEditBoxText(f.nameBox)
            data.width = tonumber(PCP_GetEditBoxText(f.widthBox)) or data.width or 260
            data.height = tonumber(PCP_GetEditBoxText(f.heightBox)) or data.height or 120
            data.spacing = tonumber(PCP_GetEditBoxText(f.spacingBox)) or data.spacing or 6
            data.alwaysShow = f.alwaysShowCheck and f.alwaysShowCheck:GetChecked() and true or false
            PCP_RenderCustomFrame(PCP_CustomFrameEditorState.selectedFrame or 1)
            PCP_RefreshCustomFramesEditor()
        end)
        PCP_RegisterThemedButton(f.saveFrame)

        f.addButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        f.addButton:SetSize(90, 22)
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
        f.buttonScroll:SetSize(280, 145)
        f.buttonScroll:EnableMouseWheel(true)
        f.buttonScroll:SetScript("OnMouseWheel", function(self, delta)
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
        f.buttonScrollChild:SetSize(280, 145)
        f.buttonScroll:SetScrollChild(f.buttonScrollChild)

        f.buttonRows = {}
        for i = 1, 6 do
            local row = CreateFrame("Button", nil, f.buttonScrollChild, "UIPanelButtonTemplate")
            row:SetSize(184, 22)
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
            row:SetScript("OnClick", function(self)
                if not self._pcpButtonIndex then return end
                PCP_CustomFrameEditorState.selectedButton = self._pcpButtonIndex
                PCP_ShowCustomButtonEditor(self._pcpButtonIndex)
                PCP_RefreshCustomFramesEditor()
            end)

            row.upButton = CreateFrame("Button", nil, f.buttonScrollChild, "UIPanelButtonTemplate")
            row.upButton:SetSize(24, 22)
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
            row.upButton:SetScript("OnClick", function(self)
                if self._pcpButtonIndex then
                    PCP_MoveCustomButton(PCP_CustomFrameEditorState.selectedFrame or 1, self._pcpButtonIndex, -1)
                end
            end)
            PCP_RegisterThemedButton(row.upButton)

            row.downButton = CreateFrame("Button", nil, f.buttonScrollChild, "UIPanelButtonTemplate")
            row.downButton:SetSize(24, 22)
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
            row.downButton:SetScript("OnClick", function(self)
                if self._pcpButtonIndex then
                    PCP_MoveCustomButton(PCP_CustomFrameEditorState.selectedFrame or 1, self._pcpButtonIndex, 1)
                end
            end)
            PCP_RegisterThemedButton(row.downButton)

            row.deleteButton = CreateFrame("Button", nil, f.buttonScrollChild, "UIPanelButtonTemplate")
            row.deleteButton:SetSize(22, 22)
            row.deleteButton:SetPoint("LEFT", row.downButton, "RIGHT", 3, 0)
            row.deleteButton:SetText("X")
            PCP_SetCustomTooltip(row.deleteButton, "Delete button", "Delete this button from the selected custom frame.")
            row.deleteButton:SetScript("OnClick", function(self)
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

        local data = list[selected]
        if data then
            PCP_SetEditBoxText(f.nameBox, data.name or "")
            PCP_SetEditBoxText(f.widthBox, tostring(data.width or 260))
            PCP_SetEditBoxText(f.heightBox, tostring(data.height or 120))
            PCP_SetEditBoxText(f.spacingBox, tostring(data.spacing or 6))
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
    pcpCustomVisibilityWatcher:SetScript("OnUpdate", function(self, elapsed)
        self._pcpElapsed = (self._pcpElapsed or 0) + (elapsed or 0)
        if self._pcpElapsed < 0.10 then return end
        self._pcpElapsed = 0
        local shown = PCPFrameRemake and PCPFrameRemake:IsShown() and true or false
        if self._pcpLastMainShown ~= shown then
            self._pcpLastMainShown = shown
            if PCP_UpdateAllCustomFrameVisibility then PCP_UpdateAllCustomFrameVisibility() end
        end
    end)

    
    
    local pcpThemeLoadFrame = CreateFrame("Frame")
    local pcpThemeLoaded = false

    local function PCP_GetSavedThemeForApply()
        if PCP_Settings and PCP_Settings.color then
            defaultColor = PCP_Settings.color
        end
        return defaultColor or "originalButtons"
    end

    local function PCP_ForceThemeRefresh()
        local color = PCP_GetSavedThemeForApply()
        if toggleButtonAppearance then
            toggleButtonAppearance(true, color)
        end
        if PCP_RefreshCustomFramesTheme then
            PCP_RefreshCustomFramesTheme()
        end
        if PCP_UpdateFreeBackdropMode then
            PCP_UpdateFreeBackdropMode()
        end
    end

    
    
    
    local pcpDelayedThemeFrame = CreateFrame("Frame")
    pcpDelayedThemeFrame:Hide()
    pcpDelayedThemeFrame.ticks = 0
    pcpDelayedThemeFrame.elapsed = 0
    pcpDelayedThemeFrame:SetScript("OnUpdate", function(self, elapsed)
        self.elapsed = (self.elapsed or 0) + (elapsed or 0)
        if self.elapsed < 0.15 then return end
        self.elapsed = 0
        self.ticks = (self.ticks or 0) + 1
        PCP_ForceThemeRefresh()
        if self.ticks >= 6 then
            self:Hide()
        end
    end)

    local function PCP_StartDelayedThemeRefresh()
        pcpDelayedThemeFrame.ticks = 0
        pcpDelayedThemeFrame.elapsed = 0
        pcpDelayedThemeFrame:Show()
    end

    local function PCP_LoadThemeOnce()
        if pcpThemeLoaded then
            PCP_StartDelayedThemeRefresh()
            return
        end
        pcpThemeLoaded = true
        if LoadSavedSettings then
            LoadSavedSettings()
        end
        if PCP_RebuildCustomFrames then
            PCP_RebuildCustomFrames()
        end
        PCP_ForceThemeRefresh()
        PCP_StartDelayedThemeRefresh()
    end
    pcpThemeLoadFrame:RegisterEvent("ADDON_LOADED")
    pcpThemeLoadFrame:RegisterEvent("PLAYER_LOGIN")
    pcpThemeLoadFrame:SetScript("OnEvent", function(self, event, addonName)
        local currentEvent = event or arg1
        if currentEvent == "ADDON_LOADED" then
            PCP_LoadThemeOnce()
        elseif currentEvent == "PLAYER_LOGIN" then
            PCP_LoadThemeOnce()
        end
    end)

    PCPFrameRemake = frame
end	





if not PCPButtonFrame then

    if string.find(version, "^1.14") then
		PCPButtonFrame = CreateFrame("Button", "PCPButtonFrame", Minimap, "BackdropTemplate")	
	else 
		PCPButtonFrame = CreateFrame("Button", "PCPButtonFrame", Minimap)

		PCPButtonFrame:SetWidth(100)
		PCPButtonFrame:SetHeight(100)

		PCPButtonFrame:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})

		PCPButtonFrame:SetBackdropColor(0, 0, 0, 0.5)
		PCPButtonFrame:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
		
	end
    

	PCPButtonFrame:SetWidth(32)
	PCPButtonFrame:SetHeight(32)

    PCPButtonFrame:SetPoint("TOP", Minimap, "TOP", 0, 0)  
    PCPButtonFrame:EnableMouse(true)
    PCPButtonFrame:SetMovable(true)
    PCPButtonFrame:SetUserPlaced(true)
    PCPButtonFrame:RegisterForDrag("RightButton")  
    PCPButtonFrame:SetFrameStrata("MEDIUM")
    PCPButtonFrame:Show()

    
    PCPButtonFrame:SetNormalTexture("Interface\\AddOns\\PCP\\img\\Solocraft3")
    PCPButtonFrame:SetPushedTexture("Interface\\AddOns\\PCP\\img\\Solocraft3")
    PCPButtonFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")



    
    local function SaveButtonPosition()
        if not PCP_Settings then PCP_Settings = {} end
        local point, relativeTo, relativePoint, xOffset, yOffset = PCPButtonFrame:GetPoint()

        PCP_Settings.minimapButtonPosition = {
            point = point or "TOP",
            relativePoint = relativePoint or "TOP",
            x = xOffset or 0,
            y = yOffset or 0,
        }
    end

    local function RestoreButtonPosition()
        if PCP_Settings and PCP_Settings.minimapButtonPosition then
            local pos = PCP_Settings.minimapButtonPosition
            PCPButtonFrame:ClearAllPoints()
            PCPButtonFrame:SetPoint(pos.point or "TOP", Minimap, pos.relativePoint or "TOP", pos.x or 0, pos.y or 0)
        end
    end

    


    if string.find(version, "^1.12") then
		
		PCPButtonFrame:SetScript("OnDragStart", function()
			this:StartMoving()
		end)

		PCPButtonFrame:SetScript("OnDragStop", function()
			this:StopMovingOrSizing()
			SaveButtonPosition()
		end)

		
		PCPButtonFrame:SetScript("OnClick", function()
			PCPButtonFrame_Toggle() 
		end)

		
		PCPButtonFrame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
			GameTooltip:SetText("PartyBot Control Panel\nLeft click: Open/Close\nRight-drag: Move icon")
			GameTooltip:Show()
		end)

		PCPButtonFrame:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

	else
		
		PCPButtonFrame:SetScript("OnDragStart", function(self)
			self:StartMoving()
		end)

		PCPButtonFrame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			SaveButtonPosition()
		end)

		PCPButtonFrame:SetScript("OnClick", function(self)
			PCPButtonFrame_Toggle()  
		end)


		PCPButtonFrame:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("PartyBot Control Panel\nLeft click: Open/Close\nRight-drag: Move icon")
			GameTooltip:Show()
		end)

		PCPButtonFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end


    
    RestoreButtonPosition()

    local pcpMinimapRestoreFrame = CreateFrame("Frame")
    pcpMinimapRestoreFrame:RegisterEvent("ADDON_LOADED")
    pcpMinimapRestoreFrame:RegisterEvent("PLAYER_LOGIN")
    pcpMinimapRestoreFrame:SetScript("OnEvent", function()
        RestoreButtonPosition()
    end)

end

PCPFrameRemake:Hide()


local PCPFrameRemakeShown = false


function PCPButtonFrame_Toggle()
    if PCPFrameRemakeShown then
        PCPFrameRemake:Hide()
    else
        PCPFrameRemake:Show()
    end
    PCPFrameRemakeShown = not PCPFrameRemakeShown  
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
    if IsInRaid() then
        return "RAID"
    elseif IsInGroup() then
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
        markButton:SetText("Focus Mark")
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
    if PCP_UpdateSpawnOptionButtons then PCP_UpdateSpawnOptionButtons() end
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
        if PCP_NormalizePaladinBlessingForRotation then
            PCP_NormalizePaladinBlessingForRotation()
        end
        local blessing = PCPPaladinBlessings[PCPPaladinBlessingItr or 1]
        if blessing and blessing ~= "Default" then
            extra = " " .. blessing
        end
    elseif AddClass == "shaman" and PCPShamanTotems and PCPShamanTotemItr then
        
        
        local order = { "air", "earth", "fire", "water" }
        for _, key in ipairs(order) do
            local list = PCPShamanTotems[key]
            local val = list and list[PCPShamanTotemItr[key] or 1]
            if val then
                extra = extra .. " " .. val
            end
        end
    elseif AddClass == "mage" and PCPMageSpecs then
        local spec = PCPMageSpecs[PCPMageSpecItr or 1]
        if spec then
            extra = " " .. spec
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

    local max = table.getn(PCPPaladinBlessings)
    if max < 2 then return end

    PCP_NormalizePaladinBlessingForRotation()
    PCPPaladinBlessingItr = (PCPPaladinBlessingItr or 2) + 1
    if PCPPaladinBlessingItr > max then
        PCPPaladinBlessingItr = 2
    end

    if PCP_UpdateSpawnConfigButtonText then
        PCP_UpdateSpawnConfigButtonText()
    end
    if PCP_RefreshSpawnOptionsFrame and PCPSpawnOptionsFrame and PCPSpawnOptionsFrame:IsShown() then
        PCP_RefreshSpawnOptionsFrame()
    end
end

function SubPartyBotAddAdvanced(self)
    local cmd = PCP_BuildPartyBotAddAdvancedCommand()
    --DEFAULT_CHAT_FRAME:AddMessage("|cff88ccff[PCP debug]|r " .. cmd)
	DispatchCommand(cmd)
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

local PCP_VC = "1"

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

local function PCP_RegisterVersionPrefix()
    if C_ChatInfo and C_ChatInfo.IsAddonMessagePrefixRegistered and C_ChatInfo.RegisterAddonMessagePrefix then
        if not C_ChatInfo.IsAddonMessagePrefixRegistered(PCP_VERSION_PREFIX) then
            C_ChatInfo.RegisterAddonMessagePrefix(PCP_VERSION_PREFIX)
        end
    elseif C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix then
        C_ChatInfo.RegisterAddonMessagePrefix(PCP_VERSION_PREFIX)
    end
end

local function PCP_SendVersionMessage(versionValue, userID)
    if not versionValue or not userID then return end
    if IsInGuild and not IsInGuild() then return end

    local message = versionValue .. ";" .. userID
    if C_ChatInfo and C_ChatInfo.SendAddonMessage then
        C_ChatInfo.SendAddonMessage(PCP_VERSION_PREFIX, message, "GUILD")
    elseif SendAddonMessage then
        SendAddonMessage(PCP_VERSION_PREFIX, message, "GUILD")
    end

    if PCP_NewVersion then PCP_NewVersion() end
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
    local dot1 = versionValue and strfind(versionValue, "\.")
    local dot2 = dot1 and strfind(versionValue, "\.", dot1 + 1)
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
    return PCP_Settings and PCP_Settings.lastNotifiedVersion and PCP_IsNewerVersion(PCP_VERSION, PCP_Settings.lastNotifiedVersion)
end

local function PCP_EnsureUpdateVersionPopup()
    local popup, title, currentText, latestText, hintText, linkBox, okButton, ignoreButton
    if PCP_UpdateVersionPopup then return PCP_UpdateVersionPopup end

    popup = CreateFrame("Frame", "PCP_UpdateVersionPopup", UIParent, "BackdropTemplate")
    popup:SetSize(420, 180)
    popup:SetPoint("CENTER", UIParent, "CENTER")
    popup:SetFrameStrata("FULLSCREEN_DIALOG")
    popup:SetFrameLevel(500)
    popup:SetMovable(true)
    popup:EnableMouse(true)
    popup:RegisterForDrag("LeftButton")
    popup:SetScript("OnDragStart", function(self) self:StartMoving() end)
    popup:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    popup:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    popup:SetBackdropColor(0, 0, 0, 0.92)
    popup:Hide()

    title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", popup, "TOP", 0, -18)
    title:SetText("PCP update available")

    currentText = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    currentText:SetPoint("TOPLEFT", popup, "TOPLEFT", 25, -52)
    PCP_UpdateVersionPopupCurrentText = currentText

    latestText = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    latestText:SetPoint("TOPLEFT", popup, "TOPLEFT", 25, -74)
    PCP_UpdateVersionPopupLatestText = latestText

    hintText = popup:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hintText:SetPoint("TOPLEFT", popup, "TOPLEFT", 25, -98)
    hintText:SetText("Download/update link:")

    linkBox = CreateFrame("EditBox", nil, popup, "InputBoxTemplate")
    linkBox:SetSize(270, 20)
    linkBox:SetPoint("LEFT", hintText, "RIGHT", 10, 0)
    linkBox:SetAutoFocus(false)
    linkBox:SetText(PCP_GITHUB_URL)
    linkBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    linkBox:SetScript("OnMouseUp", function(self) self:SetFocus(); self:HighlightText() end)
    PCP_UpdateVersionPopupLinkBox = linkBox

    okButton = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
    okButton:SetSize(90, 22)
    okButton:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -20, 14)
    okButton:SetText("OK")
    okButton:SetScript("OnClick", function() popup:Hide() end)

    ignoreButton = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
    ignoreButton:SetSize(140, 22)
    ignoreButton:SetPoint("RIGHT", okButton, "LEFT", -10, 0)
    ignoreButton:SetText("Ignore this version")
    ignoreButton:SetScript("OnClick", function()
        if not PCP_Settings then PCP_Settings = {} end
        if PCP_HasTrackedUpdateVersion() then
            PCP_Settings.ignoredUpdateVersion = PCP_Settings.lastNotifiedVersion
        end
        popup:Hide()
    end)

    return popup
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
    if not PCP_Settings then PCP_Settings = {} end

    local latestVersion = PCP_Settings.lastNotifiedVersion
    if PCP_Settings.ignoredUpdateVersion == latestVersion then return end

    -- Avoid popup spam when several guild members report the same newer version.
    -- The popup is shown automatically only once per detected version.
    -- Clicking the version text in Settings still opens the popup manually.
    if PCP_Settings.lastUpdatePopupVersionSeen == latestVersion then return end
    PCP_Settings.lastUpdatePopupVersionSeen = latestVersion

    if PCP_UpdateVersionPopup and PCP_UpdateVersionPopup:IsShown() then return end
    PCP_ShowUpdateVersionPopup()
end

local PCP_VersionFrame = CreateFrame("Frame")
PCP_VersionFrame:RegisterEvent("PLAYER_LOGIN")
PCP_VersionFrame:RegisterEvent("CHAT_MSG_ADDON")
PCP_VersionFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
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

    if event == "CHAT_MSG_ADDON" then
        local prefix, message, _, sender = ...
        local receivedVersion, receivedUserID, lastNotifiedVersion

        if prefix ~= PCP_VERSION_PREFIX then return end
        if sender == UnitName("player") then return end
        if not message or message == "" then return end

        receivedVersion, receivedUserID = PCP_StrSplit(";", message)
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
            else
                PCP_MaybeShowUpdateVersionPopup()
            end
        else
            PCP_Settings.lastNotifiedVersion = receivedVersion
        end
    end
end)

