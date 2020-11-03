local _, ADDON = ...

local hybridScrollHooks = {}
local function registerScrollFrame(template, initialFrame, point)
    for _, button in ipairs(initialFrame.buttons) do
        button:SetPoint(unpack(point))
    end
    hybridScrollHooks[template] = point
end

local function guildBenefits()
    local perks = CommunitiesFrame.GuildBenefitsFrame.Perks
    -- find background texture of guild perks
    for _, region in ipairs({ perks:GetRegions() }) do
        if region.GetTexture and region:GetTexture() == "Interface\\GuildFrame\\GuildFrame" then
            region:SetPoint("TOPLEFT", 1, -1)
            region:SetPoint("BOTTOMRIGHT", 14, -1)
        end
    end

    local rewards = CommunitiesFrame.GuildBenefitsFrame.Rewards
    rewards:SetPoint("LEFT", perks, "RIGHT", 22, 0)
    rewards.RewardsContainer.ScrollChild:SetPoint("BOTTOM")
    rewards.RewardsContainer.ScrollChild:SetAllPoints()
    rewards.Bg:SetAllPoints()

    registerScrollFrame("CommunitiesGuildRewardsButtonTemplate", rewards.RewardsContainer, {"RIGHT", -2, 0})
end

local function guildInfo()
    local info = CommunitiesFrame.GuildDetailsFrame.Info
    info.DetailsFrame:SetPoint("BOTTOMRIGHT", -11, 0)
    CommunitiesFrameGuildDetailsFrameInfoBar2Left:SetPoint("TOP", info.MOTDScrollFrame, "BOTTOM", 0, 0)

    local news = CommunitiesFrame.GuildDetailsFrame.News
    news:SetPoint("LEFT", info, "RIGHT", 18, 0)
    news.Container:SetPoint("RIGHT", -14, 0)
    news.Container:SetPoint("BOTTOM")
    news.Container.ScrollChild:SetAllPoints()
    news.Header:SetPoint("RIGHT", -14, 0)

    registerScrollFrame("CommunitiesGuildNewsButtonTemplate", news.Container, {"RIGHT", -2, 0})
end

ADDON:OnLoad(function()
    guildBenefits()
    guildInfo()

    hooksecurefunc("HybridScrollFrame_CreateButtons", function(frame, template)
        if hybridScrollHooks[template] then
            for _, button in ipairs(frame.buttons) do
                button:SetPoint(unpack(hybridScrollHooks[template]))
            end
        end
    end)
end)