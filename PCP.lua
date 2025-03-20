local version, build, date, tocversion = GetBuildInfo()

function PCPFrameRemake_OnLoad(self)
    -- Output the game version for debugging
    if string.find(version, "^1.12") then
        DEFAULT_CHAT_FRAME:AddMessage("Running on WoW Vanilla: " .. version)
        
        -- Use 'this' for 1.12.x (Vanilla)
        this:SetMovable(true)
        this:SetUserPlaced(true)
        this:EnableMouse(true)
        this:RegisterForDrag("LeftButton")

        -- Dragging behavior for 1.12.x
        this:SetScript("OnDragStart", function()
            this:StartMoving()
        end)

        this:SetScript("OnDragStop", function()
            this:StopMovingOrSizing()
        end)
		PCPFrameRemake:Hide()
		
    else
        -- Code for WoW Classic Era (1.14+)
        DEFAULT_CHAT_FRAME:AddMessage("Running on WoW Classic: " .. version)
        
        -- Use 'self' for 1.14+
        self:SetMovable(true)
        self:SetUserPlaced(true)
        self:EnableMouse(true)
        self:RegisterForDrag("LeftButton")

        -- Dragging behavior for 1.14+
        self:SetScript("OnDragStart", function()
            self:StartMoving()
        end)

        self:SetScript("OnDragStop", function()
            self:StopMovingOrSizing()
        end)
		PCPFrameRemake:Show()	-- ändra till hide
		
    end
end

SLASH_MOVEFRAME1 = "/movepcp"
SlashCmdList["MOVEFRAME"] = function()
    if not PCPFrameRemake then return end  -- Ensure the frame exists

    -- Get cursor position
    local x, y = GetCursorPosition()
    local scale = UIParent:GetEffectiveScale()  -- Adjust for UI scaling

    -- Convert to UIParent-relative coordinates
    x = x / scale
    y = y / scale

    -- Move frame to cursor position
    PCPFrameRemake:ClearAllPoints()
    PCPFrameRemake:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end


if not PCPFrameRemake then
	local frame = CreateFrame("Frame", "PCPFrameRemake", UIParent) -- No "BackdropTemplate"
	frame:SetWidth(260) -- Use SetWidth() instead of SetSize()
	frame:SetHeight(550)

	-- Correcting the SetPoint() usage
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)  -- Explicit parameters

	-- Function to enable/disable backdrops
	function ToggleBackdrop(frame, enable)
		if enable then
			frame:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
				edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
				tile = true, tileSize = 16, edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 },
			})
			frame:SetBackdropColor(0, 0, 0, 0.5)
			frame:SetBackdropBorderColor(1, 1, 1, 1)
		else
			frame:SetBackdrop(nil) -- Removes the backdrop
		end
	end
	function ToggletitlesBgCheck(PCPFrameRemake, isChecked)
		if isChecked then
			comeCommandTitleFrame.bg:Show()  -- Show the background if checkbox is checked
			moveCommandTitleFrame.bg:Show()
			stayCommandTitleFrame.bg:Show()
		else
			comeCommandTitleFrame.bg:Hide()  -- Hide the background if unchecked
			moveCommandTitleFrame.bg:Hide()
			stayCommandTitleFrame.bg:Hide()			
		end
	end	

    -- Enable dragging
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        frame:StartMoving()
    end)
    frame:SetScript("OnDragStop", function()
        frame:StopMovingOrSizing()
    end)

-- Enable resizing
frame:SetResizable(true)
frame:SetMinResize(200, 300)

-- Create a resize grip
local resizeGrip = CreateFrame("Frame", nil, frame)
resizeGrip:SetWidth(20)
resizeGrip:SetHeight(20)
resizeGrip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, -5)  -- Position inside the frame

-- Use your custom texture for resizing grip
resizeGrip.texture = resizeGrip:CreateTexture(nil, "ARTWORK")
resizeGrip.texture:SetAllPoints()
resizeGrip.texture:SetTexture("Interface\\AddOns\\PCP\\img\\ResizeGrip.tga")
  -- Path to your custom texture

-- Optional: Adjust texture size or positioning within the frame if needed
resizeGrip.texture:SetTexCoord(0, 1, 0, 1)  -- You can adjust this if your texture has specific coordinates
resizeGrip.texture:SetVertexColor(1, 1, 1, 1)  -- Adjust color if needed

-- Enable mouse interactions
resizeGrip:EnableMouse(true)
resizeGrip:SetScript("OnMouseDown", function()
    frame:StartSizing("BOTTOMRIGHT")
end)
resizeGrip:SetScript("OnMouseUp", function()
    frame:StopMovingOrSizing()
end)

    -- Ensure the frame is created and all scripts are set
    -- Create overlay layer for labels
    local overlayLayer = CreateFrame("Frame", nil, frame)
    overlayLayer:SetFrameLevel(2) -- OVERLAY level
	
    -- Create FontStrings for overlay
    local titleFontString = overlayLayer:CreateFontString("AddCustomBot", "OVERLAY", "GameFontNormal")

    titleFontString:SetHeight(20)
	titleFontString:SetWidth(220)
    titleFontString:SetPoint("CENTER", 0, -25)


	-- Class switching functionality
	local classNames = {"Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Shaman", "Mage", "Warlock", "Druid"}
	local currentClassIndex = 1  -- Start with the first class

	-- Display the current class as a label
	local classDisplayFontString = overlayLayer:CreateFontString("classDisplay", "OVERLAY", "GameFontNormal")
	classDisplayFontString:SetText(classNames[currentClassIndex])
	classDisplayFontString:SetHeight(220)
	classDisplayFontString:SetWidth(20)
	classDisplayFontString:SetPoint("CENTER", 0, -60)

	-- Function to update the displayed class
	local function UpdateClassDisplay()
		classDisplayFontString:SetText(classNames[currentClassIndex])
	end

------------------------------------------------- settings-----------------------------------------------------------
local isCustomAppearanceEnabled = false
local defaultColor = "originalButtons"  -- Default color if no saved color exists
local settingsLoaded = false




local function SaveSettings(color, backdropEnabled, titlesBgEnabled)
    if not PCP_Settings then
        PCP_Settings = {}  -- Initialize table if it doesn't exist
    end
    -- Preserve existing values if new values are not provided
    if color ~= nil then
        PCP_Settings.color = color
    end
    if backdropEnabled ~= nil then
        PCP_Settings.backdropEnabled = backdropEnabled
    end
    if titlesBgEnabled ~= nil then
        PCP_Settings.titlesBgEnabled = titlesBgEnabled  -- Save the title background state
    end
end

-- Table to hold all the created buttons
local allButtons = {}

local closeButton = CreateFrame("Button", nil, PCPFrameRemake)
closeButton:SetHeight(24)  -- Match the settingsButton size
closeButton:SetWidth(24)
closeButton:SetPoint("TOPRIGHT", PCPFrameRemake, "TOPRIGHT", -5, -5) -- Position in the upper right

-- Set normal texture (change path if needed)
closeButton:SetNormalTexture("Interface\\AddOns\\PCP\\img\\close.tga")

-- Set highlight texture (for hover effect)
closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")

-- Set pushed texture (when clicking)
closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")

-- Close functionality: Hide the frame when clicked
closeButton:SetScript("OnClick", function()
    PCPFrameRemake:Hide()
end)

-- Tooltip for close button
closeButton:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Close", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
closeButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- Add to allButtons table (if needed)
table.insert(allButtons, closeButton)



-- Create the settings button
local settingsButton = CreateFrame("Button", nil, PCPFrameRemake, "UIPanelButtonTemplate")
settingsButton:SetHeight(24)  -- Adjust size as needed
settingsButton:SetWidth(24)
settingsButton:SetPoint("TOPLEFT", PCPFrameRemake, "TOPLEFT", 5, -5) -- Position in the upper right
settingsButton:SetNormalTexture("Interface\\AddOns\\PCP\\img\\settings.tga")

-- Add the settings button to the allButtons table
table.insert(allButtons, settingsButton)

-- Tooltip for settings button
settingsButton:SetScript("OnEnter", function()
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
    GameTooltip:SetText("Settings", 1, 1, 1, 1, true)
    GameTooltip:Show()
end)
settingsButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
-- Create the settings frame (hidden by default)
local settingsFrame = CreateFrame("Frame", "PCPSettingsFrame", PCPFrameRemake)
settingsFrame:SetHeight(200)
settingsFrame:SetWidth(150) -- Adjust size as needed
settingsFrame:SetPoint("RIGHT", PCPFrameRemake, "LEFT", -10, 0) -- Position to the left of PCPFrameRemake
settingsFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
settingsFrame:SetBackdropColor(0, 0, 0, 0.8) -- Semi-transparent background
settingsFrame:Hide() -- Initially hidden

-- Add version text inside settingsFrame
local versionText = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
versionText:SetPoint("BOTTOMRIGHT", settingsFrame, "BOTTOMRIGHT", -10, 10) -- Adjust position
versionText:SetText("Version 1.0") -- Change this to your actual version number
versionText:SetTextColor(1, 1, 1, 1) -- White color

-- Create the ClickBlockerFrame
local ClickBlockerFrame = CreateFrame("Frame", "ClickBlockerFrame", UIParent)
ClickBlockerFrame:SetAllPoints(UIParent) 
ClickBlockerFrame:EnableMouse(true) 
ClickBlockerFrame:SetFrameStrata("DIALOG") 
ClickBlockerFrame:SetFrameStrata("BACKGROUND")  -- Set to a lower strata than settingsFrame
ClickBlockerFrame:SetFrameLevel(1)  -- Set to a lower level than settingsFrame
ClickBlockerFrame:Hide() -- Initially hidden

ClickBlockerFrame:SetScript("OnMouseDown", function()
    ClickBlockerFrame:Hide() 
    settingsFrame:Hide()  -- Ensure it hides the settings frame
end)

-- Function to toggle settings frame visibility
local function ToggleSettingsFrame()
    if settingsFrame:IsShown() then
        settingsFrame:Hide()
        ClickBlockerFrame:Hide()  -- Hide the blocker when settings are hidden
    else
        settingsFrame:Show()
        ClickBlockerFrame:Show()  -- Show the blocker when settings are visible
    end
end


-- Open settings frame when clicking the button
settingsButton:SetScript("OnClick", ToggleSettingsFrame)

-- Function to toggle button appearance (example)
local function toggleButtonAppearance(enable, color)
    -- Your logic to change button appearance based on the selected color
    DEFAULT_CHAT_FRAME:AddMessage("Selected color: " .. color)
end

-- Create the dropdown frame
local dropdownFrame = CreateFrame("Frame", "PCPColorDropdown", settingsFrame)
dropdownFrame:SetWidth(120)
dropdownFrame:SetHeight(30)
dropdownFrame:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -10)

-- Create the dropdown button (the visible part of the dropdown)
local dropdownButton = CreateFrame("Button", "PCPColorDropdownButton", dropdownFrame, "UIPanelButtonTemplate")
dropdownButton:SetWidth(120)
dropdownButton:SetHeight(30)
dropdownButton:SetPoint("CENTER", dropdownFrame, "CENTER")
dropdownButton:SetText("Select Color")

-- Create the dropdown menu (the list of options)
local dropdownMenu = CreateFrame("Frame", "PCPColorDropdownMenu", dropdownFrame)
dropdownMenu:SetWidth(120)
dropdownMenu:SetHeight(150)
dropdownMenu:SetPoint("TOP", dropdownButton, "BOTTOM", 0, -5)
dropdownMenu:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
dropdownMenu:SetBackdropColor(0, 0, 0, 0.8)
dropdownMenu:Hide()

-- Toggle dropdown menu on button click
dropdownButton:SetScript("OnClick", function()
    if dropdownMenu:IsShown() then
        dropdownMenu:Hide()
    else
        dropdownMenu:Show()
    end
end)

-- Color options
local colorOptions = {
    { text = "Original", color = "originalButtons" },
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

-- Function to handle option selection
-- Function to handle color selection and show confirmation dialog
local function OnOptionClick()
    dropdownButton:SetText(this:GetText()) -- Update button text
    dropdownMenu:Hide()
    
    -- Show confirmation frame
    ShowReloadConfirmation(this.color)
end


-- Add options to the dropdown menu
for i, option in ipairs(colorOptions) do
    local optionButton = CreateFrame("Button", nil, dropdownMenu, "UIPanelButtonTemplate")
    optionButton:SetWidth(120)
    optionButton:SetHeight(20)
    optionButton:SetPoint("TOPLEFT", dropdownMenu, "TOPLEFT", 5, -((i - 1) * 22 + 5))
    optionButton:SetText(option.text)
    optionButton.color = option.color

    -- Highlight effect
    optionButton:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight", "ADD")

    -- Set script using 'this' for WoW 1.12.1
    optionButton:SetScript("OnClick", OnOptionClick)
end


function ShowReloadConfirmation(selectedColor)
    -- If the frame already exists, just show it again
    if PCPReloadFrame then
        PCPReloadFrame:Show()
        return
    end

    -- Create the confirmation frame
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

    -- Add text
    local reloadText = reloadFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    reloadText:SetPoint("TOP", reloadFrame, "TOP", 0, -10)
    reloadText:SetText("Reload UI to apply changes?")

    -- Yes Button
    local yesButton = CreateFrame("Button", nil, reloadFrame, "UIPanelButtonTemplate")
    yesButton:SetWidth(80)
	yesButton:SetHeight(30)
    yesButton:SetPoint("BOTTOMLEFT", reloadFrame, "BOTTOMLEFT", 40, 10)
    yesButton:SetText("Yes")
    yesButton:SetScript("OnClick", function()
        toggleButtonAppearance(true, selectedColor) -- Apply color
        ReloadUI() -- Reload UI
    end)

    -- No Button
    local noButton = CreateFrame("Button", nil, reloadFrame, "UIPanelButtonTemplate")
    noButton:SetWidth(80)
	noButton:SetHeight(30)
    noButton:SetPoint("BOTTOMRIGHT", reloadFrame, "BOTTOMRIGHT", -40, 10)
    noButton:SetText("No")
    noButton:SetScript("OnClick", function()
        reloadFrame:Hide() -- Hide frame if the player cancels
    end)

    -- Save the frame globally
    PCPReloadFrame = reloadFrame
end


-- Register the close event for mouse clicks
local eventFrame = CreateFrame("Frame")
eventFrame:SetScript("OnMouseDown", CloseSettingsOnClick)
eventFrame:SetFrameStrata("TOOLTIP")
eventFrame:EnableMouse(true)

-- Create a checkbox to toggle backdrop
local backdropCheck = CreateFrame("CheckButton", "PCPBackdropCheck", settingsFrame, "UICheckButtonTemplate")
backdropCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -40)
backdropCheck.text = backdropCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
backdropCheck.text:SetPoint("LEFT", backdropCheck, "RIGHT", 5, 0)
backdropCheck.text:SetText("Enable Backdrop")
backdropCheck:SetChecked(true)  -- Default to enabled

-- Function to handle checkbox click
backdropCheck:SetScript("OnClick", function()
    local isChecked = this:GetChecked() == 1  -- Convert 1/nil to true/false
    ToggleBackdrop(PCPFrameRemake, isChecked)
    SaveSettings(defaultColor, isChecked)  -- Save both color and backdrop state
end)


local titlesBgCheck = CreateFrame("CheckButton", "PCPtitlesBgCheck", settingsFrame, "UICheckButtonTemplate")
titlesBgCheck:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 10, -70)
titlesBgCheck.text = titlesBgCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titlesBgCheck.text:SetPoint("LEFT", titlesBgCheck, "RIGHT", 5, 0)
titlesBgCheck.text:SetText("Enable title bg")
titlesBgCheck:SetChecked(true)  -- Default to enabled

-- Function to handle checkbox click
titlesBgCheck:SetScript("OnClick", function()
    local isChecked = this:GetChecked() == 1  -- Convert 1/nil to true/false
    ToggletitlesBgCheck(PCPFrameRemake, isChecked)
    SaveSettings(defaultColor, nil, isChecked)  -- Save both color and backdrop state
end)


-- Apply initial backdrop state
ToggleBackdrop(PCPFrameRemake, backdropCheck:GetChecked())

function LoadSavedSettings()
    if PCP_Settings then
        -- Load last used color if available
        if PCP_Settings.color then
            defaultColor = PCP_Settings.color
        else
            defaultColor = "originalButtons"  -- Fallback default color
        end

        -- Load backdropEnabled state and apply
        if PCP_Settings.backdropEnabled ~= nil then
            backdropCheck:SetChecked(PCP_Settings.backdropEnabled)
            ToggleBackdrop(PCPFrameRemake, PCP_Settings.backdropEnabled)
        end

        -- Load titlesBgEnabled state and apply
        if PCP_Settings.titlesBgEnabled ~= nil then
            titlesBgCheck:SetChecked(PCP_Settings.titlesBgEnabled)  -- Set checkbox state
            ToggletitlesBgCheck(PCPFrameRemake, PCP_Settings.titlesBgEnabled)  -- Toggle background visibility
        end
    end

    -- Update button appearance (assuming this is unrelated to the settings you're loading)
    toggleButtonAppearance(true, defaultColor)
end


-------------------------------------------------end settings-----------------------------------------------------------


-- Function to create a button
function createButton(name, text, xOffset, yOffset, onClickFunc, width, height, parentFrame)
	local button = CreateFrame("Button", name, parentFrame, "UIPanelButtonTemplate")  -- testar
    --local button
        --button = CreateFrame("Button", name, parentFrame)
        --local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- Assign a default font
        --fontString:SetPoint("CENTER", UIParent, "CENTER")
        --button:SetFontString(fontString) -- Ensure the button uses the new font string


    button:SetHeight(height)
	button:SetWidth(width)
    button:SetPoint("CENTER", parentFrame, "CENTER", xOffset, yOffset)
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

    -- Store the button in the table
    table.insert(allButtons, button)

    -- Tooltip functionality
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
-- Flag to enable/disable custom appearance



function toggleButtonAppearance(enabled, color)
    isCustomAppearanceEnabled = enabled
    SaveSettings(color)

    for _, button in ipairs(allButtons) do
        -- Clear existing background textures (but preserve the mark icon)
        button:SetNormalTexture(nil)
        button:SetHighlightTexture(nil)
        button:SetPushedTexture(nil)
        button:SetDisabledTexture(nil)

        if color == "originalButtons" then
            -- Apply default WoW button textures
            local normalTexture = button:CreateTexture(nil, "ARTWORK")
            normalTexture:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
            normalTexture:SetTexCoord(0, 0.625, 0, 0.6875) -- Adjust texcoords to fit the texture
            normalTexture:SetAllPoints(button) -- Ensure it covers the full button
            button:SetNormalTexture(normalTexture)

            local highlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
            highlightTexture:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
            highlightTexture:SetTexCoord(0, 0.625, 0, 0.6875)
            highlightTexture:SetAllPoints(button)
            button:SetHighlightTexture(highlightTexture)

            local pushedTexture = button:CreateTexture(nil, "PUSHED")
            pushedTexture:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
            pushedTexture:SetTexCoord(0, 0.625, 0, 0.6875)
            pushedTexture:SetAllPoints(button)
            button:SetPushedTexture(pushedTexture)

            local disabledTexture = button:CreateTexture(nil, "DISABLED")
            disabledTexture:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
            disabledTexture:SetTexCoord(0, 0.625, 0, 0.6875)
            disabledTexture:SetAllPoints(button)
            button:SetDisabledTexture(disabledTexture)
        else
            -- Default background texture
            local bgTexture = button:CreateTexture(nil, "BACKGROUND")
            bgTexture:SetAllPoints(button)
            bgTexture:SetTexture("Interface\\AddOns\\PCP\\img\\bg.tga")

            -- Apply color themes
            if color == "pink" then
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
                if button.Text then
                    button.Text:SetTextColor(1, 1, 1, 1)
                end
            else
                bgTexture:SetVertexColor(0, 0, 0, 1)
            end
        local normalTexture = button:CreateTexture(nil, "ARTWORK")
        normalTexture:SetTexCoord(0, 0.625, 0, 0.6875) -- Adjust texcoords to fit the texture
        normalTexture:SetAllPoints(button) -- Ensure it covers the full button
        button:SetNormalTexture(normalTexture)
			
        -- Highlight texture
        local highlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
        highlightTexture:SetTexture("Interface\\AddOns\\PCP\\img\\bg.tga")		
        highlightTexture:SetAllPoints(button)
        highlightTexture:SetVertexColor(1, 1, 0, 0.1)
        button:SetHighlightTexture(highlightTexture)

        -- Pushed texture
        local pushedTexture = button:CreateTexture(nil, "PUSHED")
        pushedTexture:SetTexture("Interface\\AddOns\\PCP\\img\\bg.tga")
        pushedTexture:SetAllPoints(button)
        pushedTexture:SetVertexColor(0.8, 0.2, 0.2)
        button:SetPushedTexture(pushedTexture)

        -- Border
        local border = CreateFrame("Frame", nil, button)
        border:SetPoint("TOPLEFT", button, "TOPLEFT", -1, 1)
        border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, -1)
        border:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 6,
        })
        border:SetBackdropBorderColor(1, 1, 0, 1)
        border:SetFrameLevel(button:GetFrameLevel() + 1)			
        end

        -- Ensure the mark icon is always displayed on top
        if button.iconTexture then
            button.iconTexture:SetDrawLayer("OVERLAY")  -- Ensure it's on top
        end
		if button == settingsButton then
			local settingsIcon = button:CreateTexture(nil, "OVERLAY")
			settingsIcon:SetTexture("Interface\\AddOns\\PCP\\img\\settings.tga")
			
			-- Set a smaller size for the icon using SetWidth and SetHeight
			local iconSize = 16  -- Adjust the size to your liking
			settingsIcon:SetWidth(iconSize)
			settingsIcon:SetHeight(iconSize)

			-- Position it within the button (you can adjust the position as needed)
			settingsIcon:SetPoint("CENTER", button, "CENTER", 0, 0)

			settingsIcon:SetDrawLayer("OVERLAY")  -- Ensure it's on top
		elseif button == closeButton then
			local closeIcon = button:CreateTexture(nil, "OVERLAY")
			closeIcon:SetTexture("Interface\\AddOns\\PCP\\img\\close.tga")
			
			-- Set a smaller size for the icon using SetWidth and SetHeight
			local iconSize = 16  -- Adjust the size to your liking
			closeIcon:SetWidth(iconSize)
			closeIcon:SetHeight(iconSize)

			-- Position it within the button (you can adjust the position as needed)
			closeIcon:SetPoint("CENTER", button, "CENTER", 0, 0)

			closeIcon:SetDrawLayer("OVERLAY")  -- Ensure it's on top		
		end


    end
end

-- Slash Command
SLASH_TOGGLEBUTTON1 = "/tgl"
SlashCmdList["TOGGLEBUTTON"] = function(msg)
    -- Extract the first word from the message
    local _, _, color = string.find(msg, "^(%S+)")  -- Use string.find instead of string.match

    if msg == "on" then
        toggleButtonAppearance(true, defaultColor)  
        print("Custom appearance enabled with last used color: " .. defaultColor)
    elseif msg == "off" then
        toggleButtonAppearance(false, defaultColor)  
        print("Custom appearance disabled")
    elseif color == "pink" or color == "green" or color == "blue" or color == "gray" or color == "black" or color == "originalButtons" then
        toggleButtonAppearance(true, color)  
        print("Custom appearance enabled with color: " .. color)
    else
        print("Usage: /tgl on | off | pink | green | blue | gray | black")
    end
end

-- Load settings when the addon is initialized
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function()

        LoadSavedSettings()

end)
LoadSavedSettings()




	-- Create a frame for adding bots
	local addBotFrame = CreateFrame("Frame", "AddBotFrame", frame)
	addBotFrame:SetWidth(300)  -- Size of the add bot frame
	addBotFrame:SetHeight(100)
	addBotFrame:SetPoint("TOP", frame, "TOP", 0, -10)  -- Position at the top of the main frame

	-- Set background color for addBotFrame
	addBotFrame.bg = addBotFrame:CreateTexture(nil, "BACKGROUND")
	addBotFrame.bg:SetAllPoints(true)
	--addBotFrame.bg:SetTexture(0.3, 0.5, 0.8, 0.5)  -- Light blue color for add bot frame

	-- Add title for AddBotFrame
--	local addBotTitle = addBotFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
--	addBotTitle:SetText("Add Party Bot")
--	addBotTitle:SetPoint("CENTER", addBotFrame, "TOP", 0, 10)  -- Position at the top center

	-- Add PartyBot Button with custom size (100x30)
--local AddCustomBot = CreateFrame("Button", "AddCustomBot", addBotFrame, "UIPanelButtonTemplate")
--AddCustomBot:SetText("Add")
--AddCustomBot:SetSize(80, 30)  -- Set the size of the button (change as needed)
--AddCustomBot:SetPoint("CENTER", addBotFrame, "CENTER", 0, -40)  -- Position the button with an offset
--AddCustomBot:SetScript("OnClick", function() SubPartyBotAddAdvanced() end)
	
function createClassRoleButton(name, text, xOffset, yOffset, onClickFunc, width, height, parentFrame)
local button = CreateFrame("Button", name, parentFrame, "UIPanelButtonTemplate")
--    local button
--
--        button = CreateFrame("Button", name, parentFrame)
--        local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- Assign a default font
--        fontString:SetPoint("CENTER", UIParent, "CENTER")
--        button:SetFontString(fontString) -- Ensure the button uses the new font string


    button:SetWidth(width)
    button:SetHeight(height)	
    button:SetPoint("CENTER", parentFrame, "CENTER", xOffset, yOffset)
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

    -- Hide the button initially (optional)
    button:Hide()

    -- Add to the list of buttons if needed
    table.insert(allButtons, button)

    return button
end



-- Creating a Class button (e.g., Warrior)
classButton = createClassRoleButton("ClassButton", "Warrior", 0, 20, function() print("Warrior class selected!") end, 80, 30, addBotFrame)
classButton:Show()
-- Creating a Role button (e.g., Tank)
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

	-- Class Stack Buttons (+ and - to switch class, both 30x30)
createButton("SetClassADDButton", "+", 58, 10, function() SetClassADD() end, 30, 30, addBotFrame)
createButton("SetClassSUBButton", "-", -58, 10, function() SetClassSUB() end, 30, 30, addBotFrame)
	-- Role Stack Buttons (+ and - to switch role, both 30x30)
	createButton("SetRoleADDButton", "+", 58, -10, function() SetRoleADD() end, 30, 30, addBotFrame)
	createButton("SetRoleSUBButton", "-", -58, -10, function() SetRoleSUB() end, 30, 30, addBotFrame)



	-- Create a frame for commands
	local commandsFrame = CreateFrame("Frame", "CommandsFrame", frame)
	commandsFrame:SetWidth(300)
    commandsFrame:SetHeight(130)	-- Size of the commands frame
	commandsFrame:SetPoint("TOP", addBotFrame, "BOTTOM", 0, 0)  -- Correct position under addBotFrame

	-- Set background color for CommandsFrame
	commandsFrame.bg = commandsFrame:CreateTexture(nil, "BACKGROUND")
	commandsFrame.bg:SetAllPoints(true)
	--commandsFrame.bg:SetTexture(0.4, 0.6, 0.2, 0.5)  -- Greenish color for move commands



	-- Add title for CommandsFrame
	local commandsTitle = commandsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	commandsTitle:SetPoint("CENTER", commandsFrame, "TOP", 0, -5)  -- Position at the top center

	-- Commands start
	-- Combined commands and additional commands
local commands = {
    {"CmdCome", "Come", -65, 80, function() SetCommand("come") end, 80, 30},
    {"CmdStart", "Start", 0, 80, function() SetCommand("attackstart") end, 80, 30},
    {"CmdStop", "Stop", 65, 80, function() SetCommand("attackstop") end, 80, 30},

    {"CmdUse", "Object", -65, 50, function() SetCommand("use") end, 80, 30},
    {"CmdPause", "Pause", 0, 50, function() SetPause() end, 80, 30},
    {"CmdUnpause", "Unpause", 65, 50, function() SetUnpause() end, 80, 30},

    {"CmdAOE", "AoE", -65, 20, function() SetCommand("aoe") end, 80, 30},  -- Moved to a new position
    {"CmdPauseAll", "Pause all", 0, 20, function() SetCommand("pause all") end, 80, 30},  -- Renamed to avoid conflict
    {"CmdUnpauseAll", "Unpause all", 65, 20, function() SetCommand("unpause") end, 80, 30},  -- Renamed to avoid conflict

    {"CmdStay", "Stay", -65, -10, function() SetCommand("stay") end, 80, 30},  -- Adjusted position
    {"CmdMove", "Move", 0, -10, function() SetCommand("move") end, 80, 30},   -- Adjusted position
    {"CmdPull", "Pull", 65, -10, function() SetCommand("pull") end, 80, 30},   -- Adjusted position
}


	for _, cmd in ipairs(commands) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6], cmd[7], commandsFrame)
	end


	-- Create PartyBot commands frame
	local partyBotCommandsFrame = CreateFrame("Frame", "PartyBotCommandsFrame", frame)
	partyBotCommandsFrame:SetWidth(300)
	partyBotCommandsFrame:SetHeight(130)-- Adjust size as needed
	partyBotCommandsFrame:SetPoint("TOP", commandsFrame, "BOTTOM", 0, 0)  

	-- Set background color for the PartyBot commands frame
	partyBotCommandsFrame.bg = partyBotCommandsFrame:CreateTexture(nil, "BACKGROUND")
	partyBotCommandsFrame.bg:SetAllPoints(true)
	--partyBotCommandsFrame.bg:SetTexture(0.2, 0.4, 0.6, 0.5)  -- Bluish transparent background

	-- Add title to the PartyBot commands frame
	local partyBotCommandsTitle = partyBotCommandsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	partyBotCommandsTitle:SetPoint("TOP", partyBotCommandsFrame, "TOP", 0, -5)  -- Positioned at the top center

	-- Define PartyBot command buttons
	local partyBotCommands = {
		{"PartyBotStayAll", "Stay All", -75, -5, function() SubPartyBotStayAll() end, 50, 30},  
		{"PartyBotMoveAll", "Move All", 75, -5, function() SubPartyBotMoveAll() end, 50, 30},
		{"PartyBotSpread", "Spread", -75, -5, function() SetCommand("spread") end, 50, 30},
		{"PartyBotSpreadStop", "Spread Stop", 50, -40, function() SetCommand("spreadoff") end, 50, 30},
		{"PartyBotDistance", "Distance", -50, -70, function() SetCommand("distance on") end, 50, 30},
		{"PartyBotDistanceOff", "Distance Off", 50, -70, function() SetCommand("distance off") end, 50, 30},
	}

	-- Create buttons for PartyBot commands
	for _, cmd in ipairs(partyBotCommands) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6], cmd[7], partyBotCommandsFrame)
	end

	-- Create frame for Come Command Buttons
	local comeCommandTitleFrame = CreateFrame("Frame", "comeCommandTitleFrame", commandsFrame)
	comeCommandTitleFrame:SetWidth(300)
	comeCommandTitleFrame:SetHeight(10)-- Size for come commands
	comeCommandTitleFrame:SetPoint("TOP", partyBotCommandsFrame, "BOTTOM", 0, -2)  -- Position below title

	-- Set background color for comeCommandTitleFrame
	comeCommandTitleFrame.bg = comeCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	comeCommandTitleFrame.bg:SetAllPoints(true)
	comeCommandTitleFrame.bg:SetTexture(0.6, 0.4, 0.2, 0.5)

	-- Add title for comeCommandTitleFrame
	local comeTitle = comeCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	comeTitle:SetText("Come Commands")
	comeTitle:SetPoint("CENTER", comeCommandTitleFrame, "TOP", 0, -5)  -- Position at the top center
-----------------------------------------------------------------------------------------------------
	-- Create frame for Come Command Buttons
	local comeCommandFrame = CreateFrame("Frame", "ComeCommandFrame", commandsFrame)
	comeCommandFrame:SetWidth(300)
	comeCommandFrame:SetHeight(40)-- Size for come commands
	comeCommandFrame:SetPoint("TOP", comeCommandTitleFrame, "BOTTOM", 0, -2)  -- Position below title

	-- Set background color for ComeCommandFrame
	comeCommandFrame.bg = comeCommandFrame:CreateTexture(nil, "BACKGROUND")
	comeCommandFrame.bg:SetAllPoints(true)
	--comeCommandFrame.bg:SetTexture(0.6, 0.4, 0.2, 0.5)  -- Brownish color for come commands

	-- Command Buttons for Come roles
	local roleCommandButtons = {
		{"CmdCometank", "Tank", -75, -5, function() SetCommand("cometank") end, 50, 30},
		{"CmdComeheal", "Heal", -25, -5, function() SetCommand("comeheal") end, 50, 30},
		{"CmdComemelee", "Melee", 25, -5, function() SetCommand("comemelee") end, 50, 30},
		{"CmdComerange", "Range", 75, -5, function() SetCommand("comerange") end, 50, 30},
	}

	for _, cmd in ipairs(roleCommandButtons) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6], cmd[7], comeCommandFrame)
	end
-----------------------------------------------------------------------------------------------------
	-- Create frame for Move Command Buttons
	local moveCommandTitleFrame = CreateFrame("Frame", "moveCommandTitleFrame", commandsFrame)
	moveCommandTitleFrame:SetWidth(300)
	moveCommandTitleFrame:SetHeight(10)-- Size for move commands
	moveCommandTitleFrame:SetPoint("TOP", comeCommandFrame, "BOTTOM", 0, -2)  -- Position below ComeCommandFrame

	-- Set background color for moveCommandTitleFrame
	moveCommandTitleFrame.bg = moveCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	moveCommandTitleFrame.bg:SetAllPoints(true)
	moveCommandTitleFrame.bg:SetTexture(0.4, 0.6, 0.2, 0.5)  -- Greenish color for move commands

	-- Add title for moveCommandTitleFrame
	local moveTitle = moveCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	moveTitle:SetText("Move Commands")
	moveTitle:SetPoint("CENTER", moveCommandTitleFrame, "TOP", 0, -5)  -- Position at the top center
	-------------------------------------------------------------------------------------------
	local moveCommandFrame = CreateFrame("Frame", "MoveCommandFrame", commandsFrame)
	moveCommandFrame:SetWidth(300)
	moveCommandFrame:SetHeight(40)-- Size for move commands
	moveCommandFrame:SetPoint("TOP", moveCommandTitleFrame, "BOTTOM", 0, -2)  -- Position below ComeCommandFrame

	-- Set background color for MoveCommandFrame
	moveCommandFrame.bg = moveCommandFrame:CreateTexture(nil, "BACKGROUND")
	moveCommandFrame.bg:SetAllPoints(true)
	--moveCommandFrame.bg:SetTexture(0.4, 0.6, 0.2, 0.5)  -- Greenish color for move commands

	local moveRoleCommandButtons = {
		{"CmdMovetank", "Tank", -75, -5, function() SetCommand("movetank") end, 50, 30},
		{"CmdMoveheal", "Heal", -25, -5, function() SetCommand("moveheal") end, 50, 30},
		{"CmdMovemelee", "Melee", 25, -5, function() SetCommand("movemelee") end, 50, 30},
		{"CmdMoverange", "Range", 75, -5, function() SetCommand("moverange") end, 50, 30},
	}

	for _, cmd in ipairs(moveRoleCommandButtons) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], cmd[6], cmd[7], moveCommandFrame)
	end
--------------------------------------------------------------------------------------------------------
	local stayCommandTitleFrame = CreateFrame("Frame", "stayCommandTitleFrame", commandsFrame)
	stayCommandTitleFrame:SetWidth(300)
	stayCommandTitleFrame:SetHeight(10)-- Size for stay commands
	stayCommandTitleFrame:SetPoint("TOP", moveCommandFrame, "BOTTOM", 0, -2)  -- Position below MoveCommandFrame

	-- Set background color for stayCommandTitleFrame
	stayCommandTitleFrame.bg = stayCommandTitleFrame:CreateTexture(nil, "BACKGROUND")
	stayCommandTitleFrame.bg:SetAllPoints(true)
	stayCommandTitleFrame.bg:SetTexture(0.4, 0.2, 0.6, 0.5)  -- Purple color for stay commands


	local stayTitle = stayCommandTitleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	stayTitle:SetText("Stay Commands")
	stayTitle:SetPoint("CENTER", stayCommandTitleFrame, "TOP", 0, -5)  -- Position at the top center
----------------------------------------------------------------------------------------------------------

	-- Create frame for Stay Command Buttons
	local stayCommandFrame = CreateFrame("Frame", "StayCommandFrame", commandsFrame)
	stayCommandFrame:SetWidth(300)
	stayCommandFrame:SetHeight(40)-- Size for stay commands
	stayCommandFrame:SetPoint("TOP", stayCommandTitleFrame, "BOTTOM", 0, -2)  -- Position below stayCommandTitleFrame

	-- Set background color for StayCommandFrame
	stayCommandFrame.bg = stayCommandFrame:CreateTexture(nil, "BACKGROUND")
	stayCommandFrame.bg:SetAllPoints(true)
	--stayCommandFrame.bg:SetTexture(0.4, 0.2, 0.6, 0.5)  -- Purple color for stay commands

	-- Add title for StayCommandFrame
	local defaultButtonWidth = 50
	local defaultButtonHeight = 30


	-- Command Buttons for Stay roles
	local stayRoleCommandButtons = {
		{"CmdStaytank", "Tank", -75, -10, function() SetCommand("staytank") end},
		{"CmdStayheal", "Heal", -25, -10, function() SetCommand("stayheal") end},
		{"CmdStaymelee", "Melee", 25, -10, function() SetCommand("staymelee") end},
		{"CmdStayrange", "Range", 75, -10, function() SetCommand("stayrange") end},
	}

	for _, cmd in ipairs(stayRoleCommandButtons) do
		createButton(cmd[1], cmd[2], cmd[3], cmd[4], cmd[5], defaultButtonWidth, defaultButtonHeight, stayCommandFrame)
	end
--------------------------------------------------------------------------------------------------------------------------
-- Create a frame to contain the buttons
local markFrame = CreateFrame("Frame", "MarkFrame", PCPFrameRemake)
markFrame:SetWidth(300)
markFrame:SetHeight(50) -- Adjust frame size as needed
markFrame:SetPoint("TOP", stayCommandFrame, "BOTTOM", 0, 2)



-- Set background for the frame
markFrame.bg = markFrame:CreateTexture(nil, "BACKGROUND")
markFrame.bg:SetAllPoints(true)
--markFrame.bg:SetTexture(0.3, 0.5, 0.8, 0.5) -- Light blue background

-- Helper function to create buttons
local function createMarkButton(name, text, xOffset, onClickFunc, width, height, parentFrame)
	local button = CreateFrame("Button", name, parentFrame, "UIPanelButtonTemplate")
    --local button

    --    button = CreateFrame("Button", name, parentFrame)
    --    local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- Assign a default font
    --    fontString:SetPoint("CENTER", UIParent, "CENTER")
    --    button:SetFontString(fontString) -- Ensure the button uses the new font string


    button:SetWidth(width)
	button:SetHeight(height)
    button:SetPoint("TOP", parentFrame, "TOP", xOffset, -10) -- Position buttons at the top
    button:SetText(text)
    button:SetScript("OnClick", onClickFunc)

	table.insert(allButtons, button)
    return button
end



-- Mark cycling logic
Marks = { "CC Mark", "Focus Mark" }
MarkItr = 1 -- Start with the first mark

-- Function to update the displayed mark
local function UpdateMarkDisplay()
    markButton:SetText(Marks[MarkItr])
end
createButton("SetMarkADDButton", "+", 58, 10, function() MarkADD() end, 30, 30, markFrame)
createButton("SetMarkSUBButton", "-", -58, 10, function() MarkSUB() end, 30, 30, markFrame)
markButton = createMarkButton("MarkButton", Marks[MarkItr], 0, function() ShowMark() end, 95, 30, markFrame)

----------------------------------------------------------------------------------------------------------------------
-- Create frame for Mark Commands
local markCommandFrame = CreateFrame("Frame", "MarkCommandFrame", PCPFrameRemake)
markCommandFrame:SetWidth(300)
markCommandFrame:SetHeight(120)  -- Adjust size as needed
markCommandFrame:SetPoint("TOP", markFrame, "BOTTOM", 0, -2)  -- Position below MarkFrame

-- Set background color for MarkCommandFrame
markCommandFrame.bg = markCommandFrame:CreateTexture(nil, "BACKGROUND")
markCommandFrame.bg:SetAllPoints(true)
--markCommandFrame.bg:SetTexture(0.2, 0.8, 0.2, 0.5)  -- Green color for mark commands



-- Helper function to create mark command buttons with icons
-- Helper function to create mark command buttons with icons
local function createMarkCommandButton(name, iconPath, tooltipText, xOffset, yOffset, onClickFunc, width, height, parentFrame)
    local button


        button = CreateFrame("Button", name, parentFrame)
        local fontString = button:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- Assign a default font
        fontString:SetPoint("CENTER", UIParent, "CENTER")
        button:SetFontString(fontString) -- Ensure the button uses the new font string


    button:SetWidth(width)
    button:SetHeight(height)	
    button:SetPoint("TOP", parentFrame, "TOP", xOffset, yOffset)

    -- Create a separate texture for the mark icon
    local iconTexture = button:CreateTexture(nil, "OVERLAY")  -- Use "OVERLAY" to ensure it's on top
    iconTexture:SetTexture(iconPath)
    iconTexture:SetWidth(width * 0.4)
    iconTexture:SetHeight(height * 0.4)	-- Scale texture to 50% of button size
    iconTexture:SetPoint("CENTER", button, "CENTER", 0, 0)  -- Center the texture inside the button
    iconTexture:SetTexCoord(0.25, 0.75, 0.25, 0.75)  -- Crop the texture (optional)
    button.iconTexture = iconTexture  -- Store the icon texture in a custom property

    -- Add a background for better visibility
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(0, 0, 0, 0.1) -- Semi-transparent background

    button:SetScript("OnClick", onClickFunc)

    -- Add tooltip functionality
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


-- Define icon texture coordinates for raid markers
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

-- Define Mark Command Buttons and their properties
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

-- Generate the buttons using the new function
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
    -- If the button is a raid icon, apply the appropriate texture coordinates
    local coords = iconCoords[cmd[2]]
    if coords and button.iconTexture then
        button.iconTexture:SetTexCoord(unpack(coords))
    end
end

--------------------------------------------------------------------------------------------------------------------------------------
-- Function to resize and position command buttons (used for come, move, and stay buttons)
-- Define default button dimensions and padding
local function ResizeMarkCommandButtons(commandButtons, commandFrame, buttonsPerRow, extraWidth)
    buttonsPerRow = buttonsPerRow or 5  -- Default to 5 buttons per row
    local buttonCount = table.getn(commandButtons) -- Use table.getn() instead of #
    local rows = math.ceil(buttonCount / buttonsPerRow)  -- Calculate number of rows
    local padding = 5  -- Padding between buttons

    -- Calculate total padding and available space
    local totalHorizontalPadding = padding * (buttonsPerRow - 1)
    local availableWidth = commandFrame:GetWidth() - totalHorizontalPadding

    local totalVerticalPadding = padding * (rows - 1)
    local availableHeight = commandFrame:GetHeight() - totalVerticalPadding

    -- Calculate button size based on available space
    local baseButtonWidth = math.floor(availableWidth / buttonsPerRow)

    -- Add extra width (not directly to the base size, but adjusted here)
    local buttonWidth = baseButtonWidth + (extraWidth or 0)
    local buttonHeight = math.floor(availableHeight / rows)

    -- Ensure buttons are square, keeping the same width and height
    buttonHeight = math.min(buttonWidth, buttonHeight)

    -- Position buttons
    for i = 1, buttonCount do
        local cmd = commandButtons[i]
        local button = getglobal(cmd[1]) -- Use getglobal() instead of _G[]
        if button then
            -- Resize button to be square
            button:SetWidth(buttonWidth)
            button:SetHeight(buttonHeight)

            -- Dynamically adjust NormalTexture size
            local normalTexture = button:GetNormalTexture()
            if normalTexture then
                normalTexture:SetWidth(buttonWidth * 0.4)
                normalTexture:SetHeight(buttonHeight * 0.4)  -- Adjust to 40% of button size
            end

            -- Adjust font size dynamically (optional)
            local fontString = button:GetFontString()
            if fontString then
                local font, fontSize, flags = fontString:GetFont()
                fontString:SetFont(font, math.max(10, math.min(buttonWidth / 4, 12)), flags)
            end

            -- Position the button in grid (rows and columns)
            local row = math.floor((i - 1) / buttonsPerRow)  -- Row index
            local col = math.mod(i - 1, buttonsPerRow)


            if col == 0 then
                -- First button in the row
                button:SetPoint("TOPLEFT", commandFrame, "TOPLEFT", 0, -(row * (buttonHeight + padding)))
            else
                -- Position to the right of the previous button
                local previousButton = getglobal(commandButtons[i - 1][1])
                if previousButton then
                    button:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", padding, 0)
                end
            end
        end
    end

    -- Return total height occupied by the buttons
    return rows * (buttonHeight + padding)
end





local defaultButtonWidth = 50
local defaultButtonHeight = 30
local padding = 10

-- Function to resize role command buttons
local function ResizeRoleCommandButtons(commandButtons, commandFrame, buttonHeight)
    local width = commandFrame:GetWidth()
    local padding = 5 -- Adjust padding as needed
    local buttonsPerRow = 4 -- Default to 4 buttons per row
    local buttonCount = table.getn(commandButtons) -- Use table.getn() instead of #
    local rows = math.ceil(buttonCount / buttonsPerRow)
    local totalHorizontalPadding = padding * (buttonsPerRow - 1)
    local availableWidth = width - totalHorizontalPadding
    local buttonWidth = math.floor(availableWidth / buttonsPerRow)

    -- Use provided buttonHeight or calculate it dynamically
    buttonHeight = buttonHeight or (math.floor(commandFrame:GetHeight() / rows) - padding)

    for i = 1, buttonCount do
        local cmd = commandButtons[i]
        local button = getglobal(cmd[1]) -- Use getglobal() instead of _G[]
        if button then
            button:SetWidth(buttonWidth) -- Use SetWidth() instead of SetSize()
            button:SetHeight(buttonHeight)

            -- Adjust font size based on button size
            local fontString = button:GetFontString()
            if fontString then
                local font, _, flags = fontString:GetFont()
                local fontSize = math.max(8, math.min(buttonWidth / 2, buttonHeight / 2)) -- 8, 5, 3
                fontString:SetFont(font, fontSize, flags)
            end

            -- Position the buttons
            local row = math.floor((i - 1) / buttonsPerRow)
            local col = math.mod(i - 1, buttonsPerRow) -- Use math.mod() instead of %

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



-- Function to resize and position buttons in rows for commands and partyBotCommands
-- Define default button dimensions and padding
local defaultButtonWidth = 50
local defaultButtonHeight = 30
local padding = 5

-- Function to resize and position buttons in rows for commands and partyBotCommands
local function ResizeCommandButtons(commandButtons, commandFrame, buttonsPerRow, extraWidth, startingYOffset, isPartyBot)
    buttonsPerRow = buttonsPerRow or 3  -- Default to 3 buttons per row if not provided
    local buttonCount = table.getn(commandButtons) -- Use table.getn() instead of #
    local rows = math.ceil(buttonCount / buttonsPerRow)  -- Calculate the number of rows
    local padding = 2  -- Adjust padding as needed

    local totalHorizontalPadding = padding * (buttonsPerRow - 1)  -- Padding between buttons horizontally
    local availableWidth = commandFrame:GetWidth() - totalHorizontalPadding  -- Total available width for buttons

    local totalVerticalPadding = padding * (rows - 1)  -- Padding between rows
    local availableHeight = commandFrame:GetHeight() - totalVerticalPadding  -- Total available height for buttons

    -- Calculate button dimensions
    local buttonWidth = math.floor((availableWidth - (extraWidth or 0)) / buttonsPerRow)  -- Ensure no overflow
    local buttonHeight = math.floor(availableHeight / rows)  -- Adjust height based on rows

    -- Set the initial Y offset (vertical spacing)
    local yOffset = startingYOffset or 0

    -- Iterate over buttons and position them correctly
    for i = 1, buttonCount do
        local cmd = commandButtons[i]
        local button = getglobal(cmd[1]) -- Use getglobal() instead of _G[]
        if button then
            button:SetWidth(buttonWidth + (extraWidth or 0))  -- Set button width
            button:SetHeight(buttonHeight)  -- Set button height dynamically

            -- Adjust font size based on button dimensions
            local fontSize
            if isPartyBot then
                fontSize = math.max(6, math.min(buttonWidth / 4, buttonHeight / 2))  -- Adjust for PartyBot buttons
            else
                fontSize = math.max(8, math.min(buttonWidth / 2, buttonHeight / 2))  -- Adjust for regular commands
            end

            local fontString = button:GetFontString()
            if fontString then
                local font, _, flags = fontString:GetFont()  -- Get current font and flags
                fontString:SetFont(font, fontSize, flags)  -- Set new font size
            end

            -- Position the button
            local row = math.floor((i - 1) / buttonsPerRow)  -- Determine the row (0-indexed)
            local col = math.mod(i - 1, buttonsPerRow)  -- Use math.mod() instead of %

            if col == 0 then
                -- Position the first button in the row
                button:SetPoint("TOPLEFT", commandFrame, "TOPLEFT", 0, yOffset - (row * (buttonHeight + padding)))
            else
                -- Position subsequent buttons to the right of the previous button
                local previousButton = getglobal(commandButtons[i - 1][1])
                if previousButton then
                    button:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", padding, 0)
                end
            end
        end
    end

    -- Return the total height occupied by the buttons (rows * button height + padding)
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

    -- Adjust font size for classButton and roleButton
    local buttonWidth, buttonHeight = classButton:GetWidth(), classButton:GetHeight()


    local fontSize = math.max(9, math.min(buttonWidth / 2, buttonHeight / 2)) -- Dynamic font size calculation
    local font, _, flags = classButton:GetFontString():GetFont()
    classButton:GetFontString():SetFont(font, fontSize, flags)

    buttonWidth, buttonHeight = roleButton:GetWidth(), roleButton:GetHeight()
    fontSize = math.max(8, math.min(buttonWidth / 2, buttonHeight / 2))
    font, _, flags = roleButton:GetFontString():GetFont()
    roleButton:GetFontString():SetFont(font, fontSize, flags)

    -- Dynamic sizing for other buttons
    local squareSize = math.min(width, height) / 3
    SetClassADDButton:SetWidth(squareSize)
    SetClassADDButton:SetHeight(squareSize)	
    SetClassSUBButton:SetWidth(squareSize)  
    SetClassSUBButton:SetHeight(squareSize)  	
    SetRoleADDButton:SetWidth(squareSize) 
    SetRoleADDButton:SetHeight(squareSize) 	
    SetRoleSUBButton:SetWidth(squareSize)   
    SetRoleSUBButton:SetHeight(squareSize)   	

    -- Centering the AddCustomBot button
    AddCustomBot:SetPoint("CENTER", addBotFrame, "CENTER", 0, -40)

    -- Centering the classButton and roleButton with padding between them
    local buttonPadding = 5  -- Adjust padding here as needed
    classButton:SetPoint("CENTER", addBotFrame, "CENTER", 0, 10)
    roleButton:SetPoint("CENTER", classButton, "CENTER", 0, -(classButton:GetHeight() + buttonPadding))

    -- Positioning other buttons relative to classButton and roleButton
    SetClassADDButton:ClearAllPoints()
    SetClassADDButton:SetPoint("LEFT", classButton, "RIGHT", 0, 0)  
    SetClassSUBButton:ClearAllPoints()
    SetClassSUBButton:SetPoint("RIGHT", classButton, "LEFT", 0, 0)
    SetRoleADDButton:ClearAllPoints()
    SetRoleADDButton:SetPoint("LEFT", roleButton, "RIGHT", 0, 0)
    SetRoleSUBButton:ClearAllPoints()
    SetRoleSUBButton:SetPoint("RIGHT", roleButton, "LEFT", 0, 0)  
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



frame:SetScript("OnSizeChanged", function()
    local width, height = frame:GetWidth(), frame:GetHeight()

    -- Dynamically calculate padding as a percentage of the frame's height
    local padding = height * 0.005 -- 1% of the frame's height (adjust as needed)

    -- Calculate available height after accounting for padding
    local totalHeight = height - padding * 2

    -- Define proportional heights for each frame
local frameHeights = {
    addBotFrame = totalHeight * 0.12,          -- 12%
    commandsFrame = totalHeight * 0.19,        -- 18%
    partyBotCommandsFrame = totalHeight * 0.19, -- 18%	
    comeCommandTitleFrame = 10,                -- Fixed height
    comeCommandFrame = totalHeight * 0.05,     -- 4%
    moveCommandTitleFrame = 10,                -- Fixed height
    moveCommandFrame = totalHeight * 0.05,     -- 4%
    stayCommandTitleFrame = 10,                -- Fixed height
    stayCommandFrame = totalHeight * 0.05,     -- 4%

    markFrame = totalHeight * 0.04,            -- 4%
    markCommandFrame = totalHeight * 0.15      -- 12%
}
    -- Update frame heights
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

    -- Maintain consistent widths
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

    -- Position frames vertically with dynamic padding
    local yOffset = -padding -- Start from the top with padding

    -- Position addBotFrame
    addBotFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.addBotFrame - padding

    -- Position commandsFrame
    commandsFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.commandsFrame - padding

    -- Position partyBotCommandsFrame (under commandsFrame)
    partyBotCommandsFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.partyBotCommandsFrame - padding

    -- Position comeCommandTitleFrame
    comeCommandTitleFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.comeCommandTitleFrame - padding

    -- Position comeCommandFrame
    comeCommandFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.comeCommandFrame - padding

    -- Position moveCommandTitleFrame
    moveCommandTitleFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.moveCommandTitleFrame - padding

    -- Position moveCommandFrame
    moveCommandFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.moveCommandFrame - padding

    -- Position stayCommandTitleFrame
    stayCommandTitleFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.stayCommandTitleFrame - padding

    -- Position stayCommandFrame
    stayCommandFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.stayCommandFrame - padding

    -- Position markFrame
    markFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)
    yOffset = yOffset - frameHeights.markFrame - padding

    -- Position markCommandFrame
    markCommandFrame:SetPoint("TOP", frame, "TOP", 0, yOffset)

    -- Resize command buttons and get button heights
    local commandsHeight = ResizeCommandButtons(commands, commandsFrame, 3, 0, 0, false)
    local partyBotHeight = ResizeCommandButtons(partyBotCommands, partyBotCommandsFrame, 2, 0, 0, true)
    local hej = commandsHeight / 4

    -- Use the same button height for roleCommandButtons
    ResizeRoleCommandButtons(roleCommandButtons, comeCommandFrame, hej)
    ResizeRoleCommandButtons(moveRoleCommandButtons, moveCommandFrame, hej)
    ResizeRoleCommandButtons(stayRoleCommandButtons, stayCommandFrame, hej)
    ResizeMarkCommandButtons(markCommandButtons, markCommandFrame)

    -- Resize the bot buttons inside addBotFrame
    ResizeMarkButtons()
    ResizeAddBotButtons()
end)
	
    PCPFrameRemake = frame
end	



------------------------------------------------------------------------
-- Create the PCPButtonFrame if it doesn't already exist
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

    PCPButtonFrame:SetPoint("TOP", Minimap, "TOP", 0, 0)  -- Position relative to the minimap
    PCPButtonFrame:EnableMouse(true)
    PCPButtonFrame:SetMovable(true)
    PCPButtonFrame:SetUserPlaced(true)
    PCPButtonFrame:RegisterForDrag("RightButton")  
    PCPButtonFrame:SetFrameStrata("LOW")
    PCPButtonFrame:Show()

    -- Set the icon/texture directly on the frame (since it now acts as a button)
    PCPButtonFrame:SetNormalTexture("Interface\\AddOns\\PCP\\img\\SoloCraft2.tga")
    PCPButtonFrame:SetPushedTexture("Interface\\AddOns\\PCP\\img\\SoloCraft2.tga")
    PCPButtonFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")



    -- Function to save and restore button position
    local function SaveButtonPosition()
        local point, relativeTo, relativePoint, xOffset, yOffset = PCPButtonFrame:GetPoint()
        PCPButtonFrame.position = {point, relativeTo, relativePoint, xOffset, yOffset}
    end

    local function RestoreButtonPosition()
        if PCPButtonFrame.position then
            local point, relativeTo, relativePoint, xOffset, yOffset = unpack(PCPButtonFrame.position)
            PCPButtonFrame:ClearAllPoints()
            PCPButtonFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)
        end
    end

    -- Dragging behavior

-- Set the frame scripts for dragging
    if string.find(version, "^1.12") then
		-- WoW 1.12.x (Vanilla) behavior
		PCPButtonFrame:SetScript("OnDragStart", function()
			this:StartMoving()
		end)

		PCPButtonFrame:SetScript("OnDragStop", function()
			this:StopMovingOrSizing()
			SaveButtonPosition()
		end)

		-- OnClick behavior for WoW 1.12.x
		PCPButtonFrame:SetScript("OnClick", function()
			PCPButtonFrame_Toggle() 
		end)

		-- Tooltip display for WoW 1.12.x
		PCPButtonFrame:SetScript("OnEnter", function()
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
			GameTooltip:SetText("PartyBot Control Panel \nPress Left Click to Open/Close \nHold Right Click to move the icon")
			GameTooltip:Show()
		end)

		PCPButtonFrame:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)

	else
		-- WoW 1.14+ (Classic Era) behavior
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
			GameTooltip:SetText("PartyBot Control Panel \nPress Left Click to Open/Close \nHold Right Click to move the icon")
			GameTooltip:Show()
		end)

		PCPButtonFrame:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
	end


    -- Restore saved position on load
    RestoreButtonPosition()

end

PCPFrameRemake:Hide()
-- frame:Hide() ta fram denna sen
-- Initialize the frame visibility state
local PCPFrameRemakeShown = false

-- Function to toggle the visibility of PCPFrameRemake
function PCPButtonFrame_Toggle()
    if PCPFrameRemakeShown then
        PCPFrameRemake:Hide()
    else
        PCPFrameRemake:Show()
    end
    PCPFrameRemakeShown = not PCPFrameRemakeShown  -- Toggle the state
end
--------------------------------------------
-- Create the PCPButtonFrame directly in Lua





BINDING_HEADER_CCP = "PartyBot Control Panel";
BINDING_NAME_CP = "Show/Hide PCP";

-- cmd
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

function SetCommand(arg)
		SendChatMessage(CMD_GENERAL .. arg);
end

function SetPause()
		SendChatMessage(CMD_GENERAL .. " pause ");
end

function SetUnpause()
		SendChatMessage(CMD_GENERAL .. " unpause ");
end

AddMark = "ccmark"
MarkItr = 1
function MarkStackHide()
	ccmark:Hide()
	focusmark:Hide()
end

function MarkADD()
    -- Define the marks
    Marks = { "ccmark", "focusmark" }

    -- Increment the iterator
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
    -- Define the marks
    Marks = { "ccmark", "focusmark" }

    -- Decrement the iterator
	MarkItr = MarkItr - 1	
	if MarkItr <= 0 then MarkItr = table.getn(Marks) end
	AddMark = Marks[MarkItr]
	
    -- Update the button text based on the current mark
    if Marks[MarkItr] == "ccmark" then
        markButton:SetText("CC Mark")
    elseif Marks[MarkItr] == "focusmark" then
        markButton:SetText("Fokus Mark")
    end
end

function SetMark(arg)
	SendChatMessage(CMD_GENERAL .. AddMark .. " " .. arg);

end

function ShowMark()
	SendChatMessage(CMD_GENERAL .. AddMark);
	
end

function ClearMark()
	SendChatMessage(CMD_GENERAL .. "clear " .. AddMark);
end

function ClearAllMark()
	SendChatMessage(CMD_GENERAL .. "clear");
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
	SendChatMessage(CMD_GENERAL .."toggle " .. AddToggle);
end

function SubPartyBotClone(self)
	SendChatMessage(CMD_PARTYBOT_CLONE);
end

function SubPartyBotRemove(self)
	SendChatMessage(CMD_PARTYBOT_REMOVE);
end

function SubPartyBotMoveAll()
	SendChatMessage(CMD_PARTYBOT_MAll);
end

function SubPartyBotStayAll()
	SendChatMessage(CMD_PARTYBOT_SAll);
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


-- Create a single role button


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

function SubPartyBotAddAdvanced(self)
	SendChatMessage(CMD_PARTYBOT_ADD .. AddClass .. " " .. AddRole .. " " .. AddGender);
end

function SubPartyBotAdd(self, arg)
	SendChatMessage(CMD_PARTYBOT_ADD .. arg);
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
	SendChatMessage(CMD_BATTLEBOT_ADD .. arg1 .. " " .. arg2 .. " " .. RanBotLevel);
end

function SubBattleGo(self, arg1)
	SendChatMessage(CMD_BATTLEGROUND_GO .. arg1);
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
function SlashCmdList.PCP(msg, editbox) -- 4.
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