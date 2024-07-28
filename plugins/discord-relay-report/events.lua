AddEventHandler("OnClientChat", function(event --[[ Event ]], playerid --[[ number ]], text --[[ string ]], teamonly --[[ boolean ]])
    if config:Fetch("discord-relay-report.config.enableChatsync") then
        local player = GetPlayer(playerid)
        local playerName = player:CBasePlayerController().PlayerName
        local filePath = "addons/swiftly/configs/plugins/discord-relay-report/chatsync.json"
        local content = files:Read(filePath)
        local data = json.decode(content)

        data.content = playerName .. ": " .. "<" .. player:GetSteamID() .. ">: " .. text
        local newContent = json.encode(data, { indent = 2 })
        local headers = { ["Content-Type"] = "application/json" }
        local files = {}

        local webhook = config:Fetch("discord-relay-report.config.webhookChatync")

        if webhook == nil or webhook == "" then
            print(FetchTranslation("discord-relay-report.error"):gsub("{CONFIG}", "<webhookChatync>"))
        else
            PerformHTTPRequest(webhook, callback, "POST", newContent, headers, files)
        end

    end
    return EventResult.Continue
end)
