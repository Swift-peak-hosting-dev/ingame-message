-- client.lua

--------------------------------------------------------------------------------
-- 1) Helpers to store/retrieve the "has closed" flag in local KVP
--------------------------------------------------------------------------------

local POPUP_CLOSED_KEY = "API_REMINDER_CLOSED" -- The key we'll store in local FiveM KVP

local function getHasClosedPopup()
    -- Checks FiveM local storage for a string value "true"
    local value = GetResourceKvpString(POPUP_CLOSED_KEY)
    return (value == "true")
end

local function setHasClosedPopup()
    -- Stores "true" so next session the user won't see the popup
    SetResourceKvp(POPUP_CLOSED_KEY, "true")
end

--------------------------------------------------------------------------------
-- 2) Our popup logic
--------------------------------------------------------------------------------

local reminderInterval = 1000-- 60 seconds
local popupVisible = false

local function showPopup()
    if not popupVisible then
        popupVisible = true
        SetNuiFocus(true, true) -- Capture mouse/keyboard
        SendNUIMessage({ action = "openPopup" })
    end
end

-- NUI callback when user clicks "Close"
RegisterNUICallback("closePopup", function(data, cb)
    popupVisible = false
    SetNuiFocus(false, false)

    -- Mark in local storage that they've closed it
    setHasClosedPopup()

    cb("ok")
end)

--------------------------------------------------------------------------------
-- 3) Automatic showing on resource start or after interval
--------------------------------------------------------------------------------

-- Only show the popup if user hasn't closed it before
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(reminderInterval)

        if not getHasClosedPopup() then
            showPopup()
        end
    end
end)

-- Optional command to test the popup
RegisterCommand("apiReminder", function()
    showPopup()
end, false)

print("[DEBUG] API Reminder Script Loaded Successfully!")
