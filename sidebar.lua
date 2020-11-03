local _, ADDON = ...

-- todo fix frames (MemberLists)

local autohide

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
    button:SetSize(25, 25)
    button:SetPoint("TOP", CommunitiesFrame.CommunitiesList.ListScrollFrame.scrollDown, "BOTTOM", 0, 1)
    button:SetHighlightTexture(130757) -- Interface\BUTTONS\UI-Common-MouseHilight
    button:SetPushedTexture(autohide and 130865 or 130868) -- Interface\BUTTONS\UI-SpellbookIcon-NextPage-Down
    button:SetNormalTexture(autohide and 130866 or 130869) -- Interface\BUTTONS\UI-SpellbookIcon-NextPage-Up
    button:SetScript("OnMouseUp", function(self)
        autohide = not autohide
        button:SetPushedTexture(autohide and 130865 or 130868)
        button:SetNormalTexture(autohide and 130866 or 130869)
        EnhancedCommunitiesSettings.autohideCommunitiesList = autohide
        if autohide then
            hide()
        else
            show()
        end
    end)

    return button
end
local function fixPoints()
    local list = CommunitiesFrame.CommunitiesList
    list.BottomFiligree:ClearAllPoints()
    list.BottomFiligree:SetPoint("BOTTOM", 0, 1)

    list.FilligreeOverlay.LeftBar:SetPoint("BOTTOMLEFT", list.FilligreeOverlay.BLCorner, "TOPLEFT")
end

ADDON:OnLoad(function()
    autohide = EnhancedCommunitiesSettings.autohideCommunitiesList or false

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