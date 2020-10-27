local ADDON_NAME, ADDON = ...

-- TODO fix left Bg
-- TODO save size

local function updateLists()
    HybridScrollFrame_CreateButtons(CommunitiesFrame.MemberList.ListScrollFrame, "CommunitiesMemberListEntryTemplate", 0, 0)
    CommunitiesFrame.MemberList.ListScrollFrame.update()

    HybridScrollFrame_CreateButtons(CommunitiesFrame.GuildDetailsFrame.News.Container, "CommunitiesGuildNewsButtonTemplate", 0, 0)
    CommunitiesFrame.GuildDetailsFrame.News.Container.update()

    HybridScrollFrame_CreateButtons(CommunitiesFrame.GuildBenefitsFrame.Rewards.RewardsContainer, "CommunitiesGuildRewardsButtonTemplate", 1, 0)
    CommunitiesFrame.GuildBenefitsFrame.Rewards.RewardsContainer.update()
end

local function fixUIPoints()
    local CF = CommunitiesFrame
    CF.CommunitiesList.FilligreeOverlay.LeftBar:SetPoint("BOTTOMLEFT", CF.CommunitiesList.FilligreeOverlay.BLCorner, "TOPLEFT")

    CF.GuildDetailsFrame.News.Container:SetPoint("BOTTOM", CF.GuildDetailsFrame.News)
    CF.GuildBenefitsFrame.Rewards.RewardsContainer.ScrollChild:SetPoint("BOTTOM", CF.GuildBenefitsFrame.Rewards.RewardsContainer)

    local bg = CommunitiesFrame.CommunitiesList.Bg
    --CommunitiesFrame.CommunitiesList.Bg:SetHorizTile(true)
    --CommunitiesFrame.CommunitiesList.Bg:SetVertTile(true)
end

local function buildDrag()
    local drag = CreateFrame("Button", nil, CommunitiesFrame)

    drag:SetSize(50, 25)
    drag:SetFrameLevel(500)
    drag:Raise()
    drag:SetPoint("TOP", CommunitiesFrame, "BOTTOM", 0, 10)

    drag:SetNormalTexture(443272) -- Interface/RaidFrame/Raid-Move-Down
    drag:HookScript("OnEnter", function(self)
        self:GetNormalTexture():SetVertexColor(0.8, 0.8, 0.8)
    end)
    drag:HookScript("OnLeave", function(self)
        self:GetNormalTexture():SetVertexColor(1, 1, 1)
    end)

    drag:SetMovable(true)
    drag:EnableMouse(true)
    drag:RegisterForDrag("LeftButton")
    drag:SetDontSavePosition()

    local CF = CommunitiesFrame
    CF:SetResizable(true)
    CF:SetMinResize(CF:GetWidth(), CF:GetHeight())
    drag:SetScript("OnDragStart", function()
        CF:StartSizing("bottom")
    end)
    drag:SetScript("OnDragStop", function()
        CF:StopMovingOrSizing()
        updateLists()
    end)

    drag:Show()

    fixUIPoints()
end

ADDON:OnLoad(buildDrag)