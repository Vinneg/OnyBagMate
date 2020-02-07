local OnyBagMate = LibStub('AceAddon-3.0'):GetAddon('OnyBagMate');

local AceGUI = LibStub('AceGUI-3.0');
local LSM = LibStub('LibSharedMedia-3.0');
local L = LibStub('AceLocale-3.0'):GetLocale('OnyBagMate');

OnyBagMate.AttendanceFrame = {
    frame = nil,
    text = nil,
};

function OnyBagMate.AttendanceFrame:Render()
    self.frame = AceGUI:Create('Frame');
    self.frame:SetTitle('Onixia Bag Mate');
    self.frame:SetLayout(nil);
    self.frame:SetCallback('OnClose', function(widget) AceGUI:Release(widget); end)

    local import = AceGUI:Create('Button');
    import:SetText('Import');
    import:SetFullWidth(true);
    import:SetCallback('OnClick', function() self:Import() end);

    self.frame:AddChild(import);
    import:SetPoint('TOPLEFT', 0, 5);
    import:SetPoint('TOPRIGHT', 0, 5);

    self.text = AceGUI:Create('MultiLineEditBox');
    self.text:SetFullWidth(true);
    self.text:SetFullHeight(true);
    self.text:SetMaxLetters(0);
    self.text:DisableButton(true);

    self.frame:AddChild(self.text);
    self.text:SetPoint('TOP', import.frame, 'BOTTOM', 0, -5);
    self.text:SetPoint('LEFT', import.frame, 'LEFT', 0, 5);
    self.text:SetPoint('RIGHT', import.frame, 'RIGHT', 0, 5);
    self.text:SetPoint('BOTTOM', self.frame.frame, 'BOTTOM', 0, 50);
end

function OnyBagMate.AttendanceFrame:Import()
    local lines = {};

    string.gsub(self.text:GetText(), '[^\r\n]+', function(item) tinsert(lines, item); end);

    for _, v in ipairs(lines) do
        self:ParseLine(v);
    end
end

function OnyBagMate.AttendanceFrame:ParseLine(line)
    local items = {};

    string.gsub(line, '[^,]+', function(item) tinsert(items, item); end);

    print(#items);
--    self:HandleHeader(items[2]);

--    for _, v in ipairs(items) do
--        if v == '"Name"' then
--            print(v);
--        else
--        end
--    end
end

function OnyBagMate.AttendanceFrame:HandleHeader(header)
    print(header);
--    local items = {};
--
--    string.gsub(header, '[^,]+', function(item) tinsert(items, item); end);
--
--    for _, v in ipairs(items) do
--        if v == '"Name"' then
--            print(v);
--        else
--        end
--    end
end
