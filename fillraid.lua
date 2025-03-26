function CreateInstanceFrame(name, presets)
    local frame = CreateFrame("Frame", name, UIParent)
    frame:SetWidth(200)
    frame:SetHeight(350)
    frame:SetPoint("LEFT", FillRaidFrame, "RIGHT", 10, 0)
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0, 0, 0, 1) 
    frame:SetFrameStrata("DIALOG")
    frame:SetFrameLevel(10)
    frame:Hide() 

    local buttonWidth = 80
    local buttonHeight = 30
    local padding = 10
    local maxButtonsPerColumn = 8


    local totalButtonWidth = buttonWidth + padding
    local totalButtonHeight = buttonHeight + padding
    local numButtons = table.getn(presets)
    local numColumns = math.ceil(numButtons / maxButtonsPerColumn)
    local fixedStartY = -10 

    
    local function CreatePresetButton(preset, index)
        local button = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
        button:SetWidth(buttonWidth)
        button:SetHeight(buttonHeight)
        button:SetText(preset.label or "Unknown preset") 


        local column = math.floor((index - 1) / maxButtonsPerColumn)
        local row = (index - 1) - (column * maxButtonsPerColumn)


        button:SetPoint("TOPLEFT", frame, "TOPLEFT", (frame:GetWidth() - (numColumns * totalButtonWidth - padding)) / 2 + (column * totalButtonWidth), fixedStartY - (row * totalButtonHeight))


        button:SetScript("OnClick", function()
            
            for classRole, inputBox in pairs(inputBoxes) do
                if inputBox then
                    inputBox:SetNumber(0)
                    local onTextChanged = inputBox:GetScript("OnTextChanged")
                    if onTextChanged then
                        onTextChanged(inputBox) 
                    end
                end
            end

            
            if preset.values then
                for classRole, value in pairs(preset.values) do
                    local inputBox = inputBoxes[classRole]
                    if inputBox then
                        inputBox:SetNumber(value)
                        local onTextChanged = inputBox:GetScript("OnTextChanged")
                        if onTextChanged then
                            onTextChanged(inputBox) 
                        end
                    end
                end
            end
        end)


        button:SetScript("OnEnter", function()
            GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
            GameTooltip:SetText(preset.tooltip or "No tooltip available")
            GameTooltip:Show()
        end)


        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)
    end

    
    for index, preset in ipairs(presets) do
        CreatePresetButton(preset, index)
    end
	
------------------ add bots with a slash command --------------------------
local allPresets = {
    naxxramasPresets,
    bwlPresets,
    mcPresets,
    onyxiaPresets,
    aq40Presets,
    aq20Presets,
    ZGPresets,
    otherPresets
}

SLASH_FILLRAID1 = "/fillraid"
SlashCmdList["FILLRAID"] = function(msg)
    -- Ensure msg is a valid string
    if not msg or type(msg) ~= "string" or strtrim(msg) == "" then
        QueueDebugMessage("No preset specified. Listing available presets:", "debuginfo")

        -- Loop through presets and display available options
        for _, presetTable in pairs(allPresets) do
            if type(presetTable) == "table" then
                for _, preset in ipairs(presetTable) do
                    QueueDebugMessage("- " .. (preset.label or "Unknown Preset"), "debuginfo")
                end
            end
        end
        return
    end

    -- Convert msg to lowercase for case-insensitive comparison
    msg = string.lower(msg)
    local foundPreset = false

    for _, presetTable in pairs(allPresets) do
        if type(presetTable) == "table" then
            for _, preset in ipairs(presetTable) do
                -- Convert preset.label to lowercase before comparison
                if preset.label and string.find(string.lower(preset.label), msg, 1, true) then  
                    QueueDebugMessage("Applying preset: " .. preset.label, "debugfilling")

                    -- Ensure inputBoxes table exists
                    if not inputBoxes or type(inputBoxes) ~= "table" then
                        QueueDebugMessage("Error: inputBoxes is nil or not a table!", "debugerror")
                        return
                    end

                    -- Reset input boxes
                    for classRole, inputBox in pairs(inputBoxes) do
                        if inputBox then
                            inputBox:SetNumber(0)
                            local onTextChanged = inputBox:GetScript("OnTextChanged")
                            if onTextChanged then
                                onTextChanged(inputBox)
                            end
                        end
                    end

                    -- Apply preset values
                    if preset.values then
                        for classRole, value in pairs(preset.values) do
                            local inputBox = inputBoxes[classRole]
                            if inputBox then
                                inputBox:SetNumber(value)
                                local onTextChanged = inputBox:GetScript("OnTextChanged")
                                if onTextChanged then
                                    onTextChanged(inputBox)
                                end
                            end
                        end
                    end
                    
                    FillRaid()
                    QueueDebugMessage("Preset applied and FillRaid triggered: " .. preset.label, "debugfilling")
                    foundPreset = true
                    return
                end
            end
        end
    end

    if not foundPreset then
        QueueDebugMessage("Preset not found: " .. msg, "debugerror")
    end
end


    return frame
end

local detectBossFrame = CreateFrame("Frame")
detectBossFrame:Hide()  -- Start hidden

local function DetectBossAndFillRaid()
    if IsControlKeyDown() then  -- Check if CTRL is held
        local bossName = UnitName("target") or UnitName("mouseover")
        if bossName then
            SlashCmdList["FILLRAID"](bossName)
            detectBossFrame:Hide()  -- Stop further detection
        end
    end
end

detectBossFrame:SetScript("OnUpdate", DetectBossAndFillRaid)

-- Event frame to enable/disable OnUpdate based on target/mouseover changes
local detectBossEventFrame = CreateFrame("Frame")
detectBossEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
detectBossEventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
detectBossEventFrame:SetScript("OnEvent", function()
    if IsControlKeyDown() then
        detectBossFrame:Show()  -- Start detecting
    else
        detectBossFrame:Hide()  -- Stop when CTRL is released
    end
end)
