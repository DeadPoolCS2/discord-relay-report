AddEventHandler("OnClientChat", function(event, playerid, text, teamonly)
    local enableChatsync = config:Fetch("discord-relay-report.config.enableChatsync")
    if not enableChatsync then
        return EventResult.Continue
    end

    local player = GetPlayer(playerid)
    local playerName = player:CBasePlayerController().PlayerName
    local filePath = "addons/swiftly/configs/plugins/discord-relay-report/chatsync.json"
    local content = files:Read(filePath)
    local data = json.decode(content)

    local function sendChatMessage(message)
        data.content = message
        local newContent = json.encode(data, { indent = 2 })
        local headers = { ["Content-Type"] = "application/json" }
        local webhook = config:Fetch("discord-relay-report.config.webhookChatync")

        if not webhook or webhook == "" then
            print(FetchTranslation("discord-relay-report.error"):gsub("{CONFIG}", "<webhookChatync>"))
            return
        end

        PerformHTTPRequest(webhook, callback, "POST", newContent, headers)
    end

    local enableCountryDetect = config:Fetch("discord-relay-report.config.enableCountryDetect")
    if enableCountryDetect then
        getCountryByIP(player:GetIPAddress(), function(country, err)
            if err then
                print("Error:", err)
            else
                local message = ":flag_" .. string.lower(country) .. ": " .. playerName .. ": " .. "<**" .. player:GetSteamID() .. "**>: " .. text
                sendChatMessage(message)
            end
        end)
    else
        local message = playerName .. ": " .. "<**" .. player:GetSteamID() .. "**>: " .. text
        sendChatMessage(message)
    end

    return EventResult.Continue
end)
