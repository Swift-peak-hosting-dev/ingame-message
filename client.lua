local reminderInterval = 60000 -- 60 seconds
local popupVisible = false

-- Show Popup
local function showPopup()
    if not popupVisible then
        popupVisible = true
        SetNuiFocus(true, true) -- Enable mouse/keyboard input to NUI
        SendNUIMessage({ action = "openPopup" })
    end
end

-- Close Popup
RegisterNUICallback("closePopup", function(data, cb)
    popupVisible = false
    SetNuiFocus(false, false) -- Disable input focus
    cb("ok")
end)

-- Periodic Reminder Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(reminderInterval)
        showPopup()
    end
end)

-- Manual Command to Test Popup
RegisterCommand("apiReminder", function()
    showPopup()
end, false)

print("[DEBUG] API Reminder Script Loaded Successfully!")
