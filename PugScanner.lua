SLASH_PUGSCANNER1 = '/ps'
COPY_DIALOG = "COPY_DIALOG"

local function ShowGroupInfoDialog (text)
    StaticPopupDialogs[COPY_DIALOG] = {
        text = "Copy/Paste this into PugScanner web app",
        button1 = "Close",
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
        OnShow = function (self, data)
            self.editBox:SetText(text)
        end,
        hasEditBox = true
    }

    StaticPopup_Show (COPY_DIALOG)
end


local function PugScannerHandler()
    outputString = ""

    if IsInGroup() then
        groupType = ""
        if IsInRaid() then
            groupType = "raid"
        else
            groupType = "party"
        end
    
        for groupindex = 1,MAX_PARTY_MEMBERS do
            if (GetUnitName(groupType .. groupindex)) then
                DEFAULT_CHAT_FRAME:AddMessage ("PugScanner: Scanned your " .. groupType .. ", copy and paste results into Pug Scanner web app!");

                unitName = GetUnitName(groupType .. groupindex, true)
                if(not string.find(unitName, "-")) then
                    unitName = unitName .. "-" .. GetRealmName();
                end

                outputString = outputString .. unitName .. ";"
            end
        end

        outputString = outputString .. GetUnitName("player") .. "-" .. GetRealmName();
    else 
        unitName = GetUnitName("player") .. "-" .. GetRealmName();
        outputString = unitName;
    end
    
    ShowGroupInfoDialog(outputString)
end



SlashCmdList["PUGSCANNER"] = PugScannerHandler;
-- Primehunt-Stormrage;FancyMoose-Stormrage