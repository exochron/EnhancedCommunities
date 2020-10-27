local _, ADDON = ...

-- todo build button
-- todo save state
-- todo fix frames (GuildPerks, MemberLists)

local autohide = true

local function hide()
    local list = CommunitiesFrame.CommunitiesList

    list:SetPoint("BOTTOMRIGHT", CommunitiesFrame, "BOTTOMLEFT", 56, 29)
    list.FilligreeOverlay.TopBar:Hide()
    list.FilligreeOverlay.TRCorner:SetWidth(47)
    list.FilligreeOverlay.BottomBar:Hide()
    list.FilligreeOverlay.BRCorner:Hide()
    list.FilligreeOverlay.RightBar:SetPoint("BOTTOMRIGHT")

    list.TopFiligree:Hide()
    list.BottomFiligree:SetWidth(47)
    list.BottomFiligree:SetTexCoord(0.5134828629032258, 0.7326108870967742, 0.06542969, 0.11914063)
end
local function show()
    local list = CommunitiesFrame.CommunitiesList

    list:SetPoint("BOTTOMRIGHT", CommunitiesFrame, "BOTTOMLEFT", 170, 29)

    list.FilligreeOverlay.TopBar:Show()
    list.FilligreeOverlay.TRCorner:SetWidth(64)
    list.FilligreeOverlay.BottomBar:Show()
    list.FilligreeOverlay.BRCorner:Show()
    list.FilligreeOverlay.RightBar:SetPoint("BOTTOMRIGHT", list.FilligreeOverlay.BRCorner, "TOPRIGHT", 0, 0)

    list.TopFiligree:Show()
    list.BottomFiligree:SetWidth(155)
    list.BottomFiligree:SetTexCoord(0.26171875, 0.98437500, 0.06542969, 0.11914063)

end
local function buildButton()
    local button = CreateFrame("Button", nil, CommunitiesFrame)
    button:SetSize(20, 20)
    button:SetPoint("BOTTOMLEFT")

    return button
end
local function fixPoints()
    local list = CommunitiesFrame.CommunitiesList
    list.BottomFiligree:ClearAllPoints()
    list.BottomFiligree:SetPoint("BOTTOM", 0, 1)

    local GuildInfo = CommunitiesFrame.GuildDetailsFrame.Info
    GuildInfo:SetPoint("RIGHT", CommunitiesFrame.GuildDetailsFrame.News, "LEFT", -18, 0)
    GuildInfo.DetailsFrame:SetPoint("BOTTOMRIGHT", -11, 0)
    GuildInfo.MOTDScrollFrame:SetPoint("RIGHT", -11, 0)
    GuildInfo.Header1:SetPoint("RIGHT", 11, 0)
    CommunitiesFrameGuildDetailsFrameInfoHeader2:SetPoint("RIGHT", 11, 0)
    CommunitiesFrameGuildDetailsFrameInfoHeader3:SetPoint("RIGHT", 11, 0)
    CommunitiesFrameGuildDetailsFrameInfoBar2Left:SetPoint("TOP", GuildInfo.MOTDScrollFrame, "BOTTOM", 0, 0)

    -- find guild info challenges bg
    for _, v in ipairs({GuildInfo:GetRegions()}) do
        if v.GetTexture and v:GetTexture() == "Interface\\GuildFrame\\GuildChallenges" then
            v:SetPoint("RIGHT", 11, 0)
        end
    end
    for i, challenge in ipairs(GuildInfo.Challenges) do
        challenge:SetPoint("RIGHT", 11, 0)
        if i > 1 then
            challenge:SetPoint("LEFT", GuildInfo.Challenges[i-1], "LEFT")
        end
    end
end

ADDON:OnLoad(function()
    fixPoints()
    buildButton()

    if autohide then
        hide()
    end
    local overlay = CommunitiesFrame.CommunitiesList.FilligreeOverlay
    overlay:HookScript("OnEnter", show)
    overlay:HookScript("OnLeave", function()
        if autohide then
            hide()
        end
    end)
    overlay:SetMouseClickEnabled(false)
end)