local AddReportMenuSelectedPlayer = {}
local AddReportMenuSelectedReason = {}

commands:Register("calladmin", function (playerid, args, argc, silent, prefix)
    if not config:Exists("discord-relay-report.config.enableReport") then
        return print(FetchTranslation("discord-relay-report.error"):gsub("{CONFIG}", "<enableReport>"))
    end

    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    AddReportMenuSelectedPlayer[playerid] = nil
    AddReportMenuSelectedReason[playerid] = nil

    local players = {}

    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        local pl = GetPlayer(i)
        if pl then
            if not pl:IsFakeClient() then
                table.insert(players, { pl:CBasePlayerController().PlayerName, "sw_reportaddmenu_selectplayer " .. i })
            end
        end
    end

    if #players == 0 then
        table.insert(players, { FetchTranslation("suspect_notfound"), "" })
    end

    menus:RegisterTemporary("addreportmenutempplayer_" .. playerid, FetchTranslation("discord-relay-report.report_someone"),
        config:Fetch("discord-relay-report.config.menucolor"), players)

    player:HideMenu()
    player:ShowMenu("addreportmenutempplayer_" .. playerid)
end)

commands:Register("reportaddmenu_selectplayer", function (playerid, args, argc, silent, prefix)
    if not config:Exists("discord-relay-report.config.enableReport") then
        return print(FetchTranslation("discord-relay-report.error"):gsub("{CONFIG}", "<enableReport>"))
    end

    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    if argc == 0 then return end

    local pid = tonumber(args[1])
    if pid == nil then return end
    local pl = GetPlayer(pid)
    if not pl then return end

    AddReportMenuSelectedPlayer[playerid] = pid

    local reasons = {}

    for i = 0, config:FetchArraySize("discord-relay-report.config.reasons") - 1, 1 do
        table.insert(reasons,
            { config:Fetch("discord-relay-report.config.reasons[" .. i .. "]"), "sw_addreportmenu_selectreason \"" ..
            config:Fetch("discord-relay-report.config.reasons[" .. i .. "]") .. "\"" })
    end

    menus:RegisterTemporary("addreportmenuadmintempplayerreason_" .. playerid,
        FetchTranslation("discord-relay-report.select_reason"), config:Fetch("discord-relay-report.config.menucolor"), reasons)
    player:HideMenu()
    player:ShowMenu("addreportmenuadmintempplayerreason_" .. playerid)
end)

commands:Register("addreportmenu_selectreason", function (playerid, args, argc, silent, prefix)
    if not config:Exists("discord-relay-report.config.enableReport") then
        return print(FetchTranslation("discord-relay-report.error"):gsub("{CONFIG}", "<enableReport>"))
    end

    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end

    if argc == 0 then return end

    if not AddReportMenuSelectedPlayer[playerid] then return player:HideMenu() end

    local reason = args[1]
    AddReportMenuSelectedReason[playerid] = reason
    local name = GetPlayer(AddReportMenuSelectedPlayer[playerid]):CBasePlayerController().PlayerName


    findSuspectByName(name, AddReportMenuSelectedReason[playerid], playerid)
    player:HideMenu()
end)