local _, ADDON = ...

local callbacks = {}
function ADDON:OnLoad(func)
    table.insert(callbacks, func)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if CommunitiesFrame then
        frame:UnregisterEvent("PLAYER_LOGIN")
        frame:UnregisterEvent("ADDON_LOADED")

        for _, func in pairs(callbacks) do
            func()
        end
    end
end)