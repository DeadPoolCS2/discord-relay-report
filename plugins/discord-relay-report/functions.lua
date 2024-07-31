function findSuspectByName(suspectName, reason, playerid)
    local webhook = config:Fetch("discord-relay-report.config.webhookReport")
    local author = GetPlayer(playerid)
    local suspectFound = false

    if webhook == nil or webhook == "" then
        print(FetchTranslation("discord-relay-report.error"):gsub("{CONFIG}", "<webhookReport>"))
        return author:SendMsg(3, FetchTranslation("discord-relay-report.prefix") .. FetchTranslation("discord-relay-report.plugin_notworking"))
    else
        for i = 1, playermanager:GetPlayerCap() do
            local suspect = GetPlayer(i - 1)
            if suspect then
                if suspect:CBasePlayerController().PlayerName == suspectName then
                    suspectFound = true
                    local filePath = "addons/swiftly/configs/plugins/discord-relay-report/reportwebhookdata.json"
                    local content = files:Read(filePath)
                    local data = json.decode(content)

                    data.content = config:Fetch("discord-relay-report.config.discordMessage") or FetchTranslation("discord-relay-report.discord_content")
                    data.embeds[1].author.name = author:CBasePlayerController().PlayerName .. " " .. FetchTranslation("discord-relay-report.authorSended")
                    data.embeds[1].author.url = "https://steamcommunity.com/profiles/" .. author:GetSteamID()
                    data.embeds[1].title = FetchTranslation("discord-relay-report.reportedPlayer") .. suspectName
                    data.embeds[1].description = FetchTranslation("discord-relay-report.reason") .. reason
                    data.embeds[1].url = "https://steamcommunity.com/profiles/" .. suspect:GetSteamID()
                    data.embeds[1].fields[1].name = FetchTranslation("discord-relay-report.suspect_steamid")
                    data.embeds[1].fields[1].value = suspect:GetSteamID()
                    data.embeds[1].fields[2].name = FetchTranslation("discord-relay-report.suspect_ip")
                    data.embeds[1].fields[2].value = suspect:GetIPAddress()
                    data.embeds[1].fields[3].name = FetchTranslation("discord-relay-report.author_steamid")
                    data.embeds[1].fields[3].value = author:GetSteamID()
                    data.embeds[1].fields[4].name = FetchTranslation("discord-relay-report.author_ip")
                    data.embeds[1].fields[4].value = author:GetIPAddress()
                    data.embeds[1].image.url = config:Fetch("discord-relay-report.config.imageReport") or ""

                    local newContent = json.encode(data, { indent = 2 })
                    local headers = { ["Content-Type"] = "application/json" }
                    local files = {}

                    local function callback()
                        author:SendMsg(3, FetchTranslation("discord-relay-report.prefix") .. FetchTranslation("discord-relay-report.reportSend"))
                    end
                    PerformHTTPRequest(webhook, callback, "POST", newContent, headers, files)
                end
            end
        end
    end

    if not suspectFound then
        author:SendMsg(3,FetchTranslation("discord-relay-report.prefix") .. FetchTranslation("discord-relay-report.suspect_notfound"))
    end
end

function getCountryByIP(ipaddress, callback)
    local function cb(status, body, headers, err)
        if err and status ~= 200 then
            callback(nil, err)
            return
        end

        local jsonBody = json.decode(body)
        if jsonBody and jsonBody.country then
            callback(jsonBody.country, nil)
        else
            callback(nil, "Failed to get country from response")
        end
    end

    local url = "https://api.country.is/" .. ipaddress
    local content = {}
    local headers = {}

    PerformHTTPRequest(url, cb, "GET", content, headers)
end

