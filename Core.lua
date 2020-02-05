OnyBagMate = LibStub('AceAddon-3.0'):NewAddon('OnyBagMate', 'AceConsole-3.0', 'AceEvent-3.0', 'AceComm-3.0');

local AceConfig = LibStub('AceConfig-3.0');
local AceConfigDialog = LibStub('AceConfigDialog-3.0');
local AceDB = LibStub('AceDB-3.0');
local AceGUI = LibStub('AceGUI-3.0');
local LSM = LibStub('LibSharedMedia-3.0');
local L = LibStub('AceLocale-3.0'):GetLocale('OnyBagMate');

local function get(info)
    return OnyBagMate.settings.char[info[#info]];
end

local function set(info, value)
    OnyBagMate.settings.char[info[#info]] = value;
end

OnyBagMate.messages = {
    prefix = 'OnyBagMate',
    demandScan = 'scan bags',
    raid = 'RAID',
    whisper = 'WHISPER',
};

OnyBagMate.UI = {
    frame = nil,
    list = nil,
};

OnyBagMate.state = {
    pass = nil,
    list = {},
};

OnyBagMate.defaults = {
    char = {
        rank = '',
        bonus = '',
    },
};

OnyBagMate.options = {
    name = 'Onyxia Bag Mate',
    handler = OnyBagMate,
    type = 'group',
    args = {
        rank = {
            type = 'input',
            order = 1,
            name = 'Rank # and above',
            get = function(info) return get(info); end,
            set = function(info, value) set(info, value); end,
        },
        header1 = {
            type = 'header',
            order = 10,
        },
        bonus = {
            type = 'input',
            order = 20,
            name = 'Roll bonus per Onyxia kill',
            get = function(info) return get(info); end,
            set = function(info, value) set(info, value); end,
        },
    },
};

OnyBagMate.settings = {};

function OnyBagMate:HandleChatCommand(input)
    if (input == nil) then
        return;
    end

    local arg = strlower(input);

    if arg == 'opts' then
        AceConfigDialog:Open('Options');
    elseif arg == 'open' then
        self:Render();
    end
end

function OnyBagMate:OnInitialize()
    self:RegisterChatCommand('onybm', 'HandleChatCommand');

    AceConfig:RegisterOptionsTable('Options', self.options);
    self.settings = AceDB:New('OnyBagMateSettings', self.defaults, true);

    self:RegisterComm(self.messages.prefix);

    self:ClearList();
end

function OnyBagMate:Render()
    self:RegisterEvent('CHAT_MSG_SYSTEM');

    self.UI.frame = AceGUI:Create('Frame');
    self.UI.frame:SetTitle('Onixia Bag Mate');
    self.UI.frame:SetLayout('List');
    self.UI.frame:SetCallback('OnClose', function(widget) self:UnregisterEvent('CHAT_MSG_SYSTEM'); AceGUI:Release(widget); end)

    local clear = AceGUI:Create('Button');
    clear:SetText('Clear');
    clear:SetFullWidth(true);
    clear:SetCallback('OnClick', function() self:ClearList(); self:RenderList(); end);

    self.UI.frame:AddChild(clear);

    local group = AceGUI:Create('SimpleGroup');
    group:SetFullWidth(true);
    group:SetFullHeight(true);
    group:SetLayout('Fill');

    self.UI.list = AceGUI:Create('ScrollFrame');
    self.UI.list:SetFullWidth(true);
    self.UI.list:SetFullHeight(true);
    self.UI.list:SetLayout('List');

    group:AddChild(self.UI.list);

    self.UI.frame:AddChild(group);
    group:SetPoint('BOTTOM', 0, 5);

    self:DemandScan();

    self.UI.frame:SetStatusText(L['Frame status'](self.state.pass));
end

function OnyBagMate:RenderList()
    self.UI.list:ReleaseChildren();

    local renderItem = function(item)
        local row = AceGUI:Create('SimpleGroup');
        row:SetFullWidth(true);
        row:SetLayout('Flow');

        local name = AceGUI:Create('Label');
        name:SetText(item.name);
        row:AddChild(name);

        local roll = AceGUI:Create('Label');
        roll:SetText(item.roll);
        row:AddChild(roll);

        self.UI.list:AddChild(row);
    end

    local result = {};

    for _, v in ipairs(self.state.list) do
        if (v.bags <= self.state.pass) then
            tinsert(result, { name = v.name, roll = v.roll });
        end
    end

    sort(result, function(a, b) return (a.roll or 0) > (b.roll or 0) end);

    for _, v in ipairs(result) do
        renderItem(v);
    end
end

function OnyBagMate:ScanPlayer()
    local bags = 0;

    for i = 0, NUM_BAG_SLOTS do
        local bagName = GetBagName(i);
--        print('bag name: ' .. bagName);

        if bagName == L['Onyxia Hide Backpack'] then
            bags = bags + 1;
        end
    end

    return bags;
end

function OnyBagMate:DemandScan()
--    print('send demand');
    self:SendCommMessage(self.messages.prefix, self.messages.demandScan, self.messages.raid);
end

function OnyBagMate:OnCommReceived(_, message, _, sender)
    if message == self.messages.demandScan then
--        print('received demand from: ' .. sender);
        local bags = self.ScanPlayer();

        self:SendCommMessage(self.messages.prefix, tostring(bags), self.messages.whisper, sender);
    elseif tonumber(message) then
        local item = { name = sender, bags = tonumber(message) };
--        print('received answer from: ' .. item.name .. ' - ' .. item.bags);
        self:UpdateList(item);
        self:UpdatePass(item);
    end
end

function OnyBagMate:ClearList()
    for _, v in ipairs(self.state.list) do
        v.roll = 0;
    end
end

function OnyBagMate:UpdateList(item)
    local result = self.state.list or {};
    local found = false;

    for _, v in ipairs(result) do
        if v.name == item.name then
            v.bags = item.bags;
            found = true;
        end
    end

    if not found then
        tinsert(result, item);
    end

    sort(result, function(a, b) return a.name < b.name end);

    self.state.list = result;
--    print(#self.state.list);
end

function OnyBagMate:UpdatePass(item)
    local pass = self.state.pass;

    if (pass == nil) then
        pass = item.bags;
    else
        pass = math.min(pass, item.bags);
    end

    self.state.pass = pass;

    self.UI.frame:SetStatusText(L['Frame status'](self.state.pass));
    --    print(self.state.pass);
end

function OnyBagMate:RollList(item)
    local result = self.state.list or {};

    for _, v in ipairs(result) do
        if (v.name == item.name and (v.roll == nil or v.roll == 0)) then
            v.roll = item.roll;
        end
    end

    sort(result, function(a, b) return (a.roll or 0) > (b.roll or 0) end);

    self.state.list = result;
end

function OnyBagMate:CHAT_MSG_SYSTEM(_, message)
    local name, roll, min, max = string.match(message, L['Roll regexp']);

    roll = tonumber(roll);
    min = tonumber(min);
    max = tonumber(max);

    if (name and roll and min == 1 and max == 100) then
--        print('roll!');
        self:RollList({ name = name, roll = roll });

        self:RenderList();
    end
end
