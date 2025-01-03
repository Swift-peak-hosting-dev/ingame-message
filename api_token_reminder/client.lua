-- FiveM Script: API Token Reminder (Professional Version)

-- Configuration
local reminderInterval = 60000 -- Time in milliseconds (e.g., 60000 = 1 minute)
local reminderMessage = "[Reminder] Please set your API token for SnailyCAD. Go to the CAD URL, log in, click your profile logo, select 'Account','User API Token', save, copy the token, then return to FiveM and use /sn-auth in text chat to paste the token from the CAD enter."

-- Function to send a reminder message
local function sendApiTokenReminder()
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(reminderMessage)
    DrawNotification(false, true)
end

-- Periodically send the reminder
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(reminderInterval)
        sendApiTokenReminder()
    end
end)

-- Register notification event for ESX or other frameworks
RegisterNetEvent('showNotification')
AddEventHandler('showNotification', function(message, messageType)
    if messageType == 1 then
        SetNotificationTextEntry("STRING")
        AddTextComponentSubstringPlayerName(message)
        DrawNotification(false, true)
    else
        print("[Notification] " .. message)
    end
end)

-- Command to manually trigger the reminder
RegisterCommand("apiReminder", function()
    sendApiTokenReminder()
end, false)

-- Logging function for debugging
local function logDebugInfo(info)
    print("[DEBUG] " .. info)
end

logDebugInfo("API Token Reminder Script Loaded Successfully")
