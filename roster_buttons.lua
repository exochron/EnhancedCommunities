local ADDON_NAME, ADDON = ...

-- TODO: community icon for roster

local function loadGuildSetup()
    return {
        {
            mode = COMMUNITIES_FRAME_DISPLAY_MODES.ROSTER,
            index = 1,
            text = GUILD_ROSTER_DROPDOWN_ACHIEVEMENT_POINTS,
            texture = "Achievement",
        },
        {
            mode = COMMUNITIES_FRAME_DISPLAY_MODES.ROSTER,
            index = 2,
            text = COMMUNITIES_ROSTER_COLUMN_TITLE_PROFESSION,
            texture = "Spellbook",
        },
        {
            mode = COMMUNITIES_FRAME_DISPLAY_MODES.GUILD_APPLICANT_LIST,
            index = 3,
            text = CLUB_FINDER_APPLICANTS,
            texture = "LFG",
            isApplicant = true
        },
        {
            mode = COMMUNITIES_FRAME_DISPLAY_MODES.GUILD_APPLICANT_LIST,
            index = 4,
            text = CLUB_FINDER_APPLICANT_HISTORY,
            texture = "Socials",
            isApplicantHistory = true
        },
    }
end
local function loadCommunitySetup()
    return {
        {
            mode = COMMUNITIES_FRAME_DISPLAY_MODES.ROSTER,
            text = CLUB_FINDER_COMMUNITY_ROSTER_DROPDOWN,
            texture = "Achievement",
        },
        {
            mode = COMMUNITIES_FRAME_DISPLAY_MODES.COMMUNITY_APPLICANT_LIST,
            text = CLUB_FINDER_APPLICANTS,
            texture = "LFG",
            isApplicant = true
        },
        {
            mode = COMMUNITIES_FRAME_DISPLAY_MODES.COMMUNITY_APPLICANT_LIST,
            text = CLUB_FINDER_APPLICANT_HISTORY,
            texture = "Socials",
            isApplicantHistory = true
        },
    }
end

local function buildButton(config, buttons)

    local button = CreateFrame("Button", nil, CommunitiesFrame, config.template or "MainMenuBarMicroButton")
    button:SetSize(28, 30)
    button.Flash:SetPoint("BOTTOMRIGHT", 2, -2)

    button:HookScript("OnClick", function(self)
        CommunitiesFrame:SetDisplayMode(config.mode)
        if config.index ~= nil then
            CommunitiesFrame.MemberList:SetGuildColumnIndex(config.index)
        end

        for _, b in pairs(buttons) do
            b:SetButtonState("NORMAL")
        end
        self:SetButtonState("PUSHED", true)
    end)

    button.tooltipText = config.text
    LoadMicroButtonTextures(button, config.texture)
    button:Hide()

    if 0 < #buttons then
        button:SetPoint("LEFT", buttons[#buttons], "RIGHT", 1, 0)
    end

    table.insert(buttons, button)

    return button
end

local function replaceGuildDropdown(DropDownMenu, setup, allowApplicants)
    local buttons = {}

    hooksecurefunc(DropDownMenu, "SetShown", function(self, toggle)
        for _, button in pairs(buttons) do
            button:SetShown(toggle)
            button:SetButtonState("NORMAL")
        end

        buttons[1]:SetButtonState("PUSHED", true)

        self:Hide()
    end)

    for _, conf in pairs(setup) do
        if allowApplicants or (not conf.isApplicant and not conf.isApplicantHistory) then
            local button = buildButton(conf, buttons)

            if conf.isApplicant then
                button:HookScript("OnClick", function(self)
                    CommunitiesFrame.ApplicantList.isPendingList = false
                    CommunitiesFrame.ApplicantList:BuildList()
                    UIFrameFlashStop(self.Flash)
                end)
                button:HookScript("OnShow", function(self)
                    local hasApplicants = DropDownMenu.hasApplicants
                    self:SetEnabled(hasApplicants)

                    if hasApplicants then
                        UIFrameFlash(self.Flash, 1.0, 1.0, -1, false, 0, 0, "microbutton");
                    end
                end)
            elseif conf.isApplicantHistory then
                button:HookScript("OnClick", function()
                    CommunitiesFrame.ApplicantList.isPendingList = true
                    CommunitiesFrame.ApplicantList:BuildList()
                end)
                button:HookScript("OnShow", function(self)
                    self:SetEnabled(DropDownMenu.hasPendingApplicants)
                end)
            end
        end
    end

    buttons[1]:SetPoint("TOPRIGHT", -((#buttons - 1) * 29) - 8, -26)
end

ADDON:OnLoad(function()
    local allowApplicants = CanGuildInvite() and (C_GuildInfo.IsGuildOfficer() or IsGuildLeader()) and C_ClubFinder.IsEnabled()
    replaceGuildDropdown(CommunitiesFrame.GuildMemberListDropDownMenu, loadGuildSetup(), allowApplicants)

    replaceGuildDropdown(CommunitiesFrame.CommunityMemberListDropDownMenu, loadCommunitySetup(), true)
end)