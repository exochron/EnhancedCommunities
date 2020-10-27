local _, ADDON = ...

ADDON:OnLoad(function()
    if nil == CHAT_TIMESTAMP_FORMAT then
        local useMilitary = GetCVarBool("timeMgrUseMilitaryTime")
        local original = CommunitiesFrame.Chat.FormatMessage
        CommunitiesFrame.Chat.FormatMessage = function(a, b, c, d)
            CHAT_TIMESTAMP_FORMAT = useMilitary and "%H:%M " or "%I:%M %p "
            local result = original(a, b, c, d)
            CHAT_TIMESTAMP_FORMAT = nil
            return result
        end
    end
end)