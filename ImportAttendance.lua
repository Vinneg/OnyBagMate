local OnyBagMate = LibStub('AceAddon-3.0'):GetAddon('OnyBagMate');

local AceGUI = LibStub('AceGUI-3.0');
local L = LibStub('AceLocale-3.0'):GetLocale('OnyBagMate');

OnyBagMate.AttendanceFrame = {
    frame = nil,
    text = nil,
    bonuses = {},
    lastBonus = '',
    lastRaid = 3,
    firstRaid = 3,
};

function OnyBagMate.AttendanceFrame:Render()
    self.frame = AceGUI:Create('Frame');
    self.frame:SetTitle(L['CSV data']);
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
    self.bonuses = {};
    self.lastBonus = '';

    string.gsub(self.text:GetText(), '[^\r\n]+', function(item) self:ParseLine(item) end);
end

function OnyBagMate.AttendanceFrame:ParseLine(line)
    local items = {};

    string.gsub(line, '[^,]+', function(item) local res = string.gsub(item, '"', ''); tinsert(items, res); end);

    print(#items);

    if items[1] == 'Name' then
        self:HandleHeader(items);
    else
        self:HandleLine(items);
    end
end

function OnyBagMate.AttendanceFrame:HandleHeader(header)
    print(header);

    self.lastBonus = header[self.firstRaid];

    for i = self.firstRaid, #header do
        if header[i] == OnyBagMate.store.char.lastBonus then
            self.lastRaid = i - 1;
        end
    end
end

function OnyBagMate.AttendanceFrame:HandleLine(line)
    if self.lastRaid <  self.firstRaid then
        return;
    end

    print(line);

    local result = {name = line[1], bonus = 0};

    for i = self.firstRaid, self.lastRaid do
        result.bonus = result.bonus + (tonumber(line[i]) or 0);
    end
end
