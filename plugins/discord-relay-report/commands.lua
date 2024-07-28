commands:Register("report", function(playerid, args, argsCount, silent)
    if not config:Exists("discord-relay-report.config.enableReport") then
        return print("Cannot find config Parameter")
    end
    local player = GetPlayer(playerid)
    if not player or player:IsFakeClient() then
        return
    end
    if config:Fetch("discord-relay-report.config.enableReport") then
        if argsCount < 2 then
            return player:SendMsg(3, "Syntax: !report <name> <reason>")
        end
        local suspectName = args[1]
        local reason = table.concat(args, " ", 2)
        findSuspectByName(suspectName, reason, playerid)
    else
        player:SendMsg(3, "Report is currently deactivated")
    end

end)
