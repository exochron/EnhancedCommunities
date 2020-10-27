local _, ADDON = ...

ADDON:OnLoad(function ()
    hooksecurefunc(CommunitiesFrame, "SelectClub", function (self, clubId)
        local title = COMMUNITIES_FRAME_TITLE
        if clubId then
            local info = C_Club.GetClubInfo(clubId)
            title = info.name
        end

        self:SetTitle(title)
    end)
end)