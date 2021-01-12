SLASH_PUGSCANNER1 = '/ps'
COPY_DIALOG = "COPY_DIALOG"

-- local function ShowGroupInfoDialog (text)
--     StaticPopupDialogs[COPY_DIALOG] = {
--         text = "Copy/Paste this into PugScanner web app",
--         button1 = "Close",
--         timeout = 0,
--         whileDead = true,
--         hideOnEscape = true,
--         preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
--         OnShow = function (self, data)
--             self.editBox:SetText(text)
--         end,
--         hasEditBox = true
--     }

--     StaticPopup_Show (COPY_DIALOG)
-- end

function KethoEditBox_Show(text)
    if not KethoEditBox then
        local f = CreateFrame("Frame", "KethoEditBox", UIParent, "DialogBoxFrame")
        f:SetPoint("CENTER")
        f:SetSize(300, 200)
        
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
            edgeSize = 16,
            insets = { left = 8, right = 6, top = 8, bottom = 8 },
        })
        f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
        
        -- Movable
        f:SetMovable(true)
        f:SetClampedToScreen(true)
        f:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self:StartMoving()
            end
        end)
        f:SetScript("OnMouseUp", f.StopMovingOrSizing)
        
        -- ScrollFrame
        local sf = CreateFrame("ScrollFrame", "KethoEditBoxScrollFrame", KethoEditBox, "UIPanelScrollFrameTemplate")
        sf:SetPoint("LEFT", 16, 0)
        sf:SetPoint("RIGHT", -32, 0)
        sf:SetPoint("TOP", 0, -16)
        sf:SetPoint("BOTTOM", KethoEditBoxButton, "TOP", 0, 0)
        
        -- EditBox
        local eb = CreateFrame("EditBox", "KethoEditBoxEditBox", KethoEditBoxScrollFrame)
        eb:SetSize(sf:GetSize())
        eb:SetMultiLine(true)
        eb:SetAutoFocus(true) -- dont automatically focus
        eb:SetFontObject("ChatFontNormal")
        eb:SetScript("OnEscapePressed", function() f:Hide() end)
        sf:SetScrollChild(eb)
        
        -- Resizable
        f:SetResizable(true)
        f:SetMinResize(150, 100)
        
        local rb = CreateFrame("Button", "KethoEditBoxResizeButton", KethoEditBox)
        rb:SetPoint("BOTTOMRIGHT", -6, 7)
        rb:SetSize(16, 16)
        
        rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        
        rb:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                f:StartSizing("BOTTOMRIGHT")
                self:GetHighlightTexture():Hide() -- more noticeable
            end
        end)
        rb:SetScript("OnMouseUp", function(self, button)
            f:StopMovingOrSizing()
            self:GetHighlightTexture():Show()
            eb:SetWidth(sf:GetWidth())
        end)
        f:Show()
    end
    
    if text then
        KethoEditBoxEditBox:SetText(text)
        KethoEditBoxEditBox:HighlightText(0)
    end
    KethoEditBox:Show()
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

        if (groupType == "party") then
            outputString = outputString .. GetUnitName("player") .. "-" .. GetRealmName();
        end
    else 
        unitName = GetUnitName("player") .. "-" .. GetRealmName();
        outputString = unitName;
    end
    
    KethoEditBox_Show(outputString)
end



SlashCmdList["PUGSCANNER"] = PugScannerHandler;
-- Primehunt-Stormrage;FancyMoose-Stormrage