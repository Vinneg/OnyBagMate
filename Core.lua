OnyBagMate = LibStub('AceAddon-3.0'):NewAddon('OnyBagMate', 'AceConsole-3.0', 'AceEvent-3.0', 'AceComm-3.0');

local AceConfig = LibStub('AceConfig-3.0');
local AceDB = LibStub('AceDB-3.0');
local AceConfigDialog = LibStub('AceConfigDialog-3.0');
local AceGUI = LibStub('AceGUI-3.0');
local L = LibStub('AceLocale-3.0'):GetLocale('OnyBagMate');

local function get(info)
    return OnyBagMate.db.char[info[#info]];
end

local function set(info, value)
    OnyBagMate.db.char[info[#info]] = value;
end

OnyBagMate.messages = {
    prefix = 'OnyBagMate',
    demandScan = 'scan bags',
    raid = 'RAID',
    whisper = 'WHISPER',
};

OnyBagMate.defaults = {
    char = {
        rank = '',
        pass = nil,
        list = {},
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
    },
};

OnyBagMate.db = {};

function OnyBagMate:HandleChatCommand(input)
    if (input == nil) then
        return;
    end

    local arg = strlower(input);

    if arg == 'test' then
        self:ScanPlayer();
    elseif arg == 'opts' then
        AceConfigDialog:Open('Options');
    elseif arg == 'open' then
        self:Render();
    end
end

function OnyBagMate:OnInitialize()
    self:RegisterChatCommand('onybm', 'HandleChatCommand');

    AceConfig:RegisterOptionsTable('Options', self.options);
    self.db = AceDB:New('OnyBagMateSettings', self.defaults, true);

    self:RegisterComm(self.messages.prefix);

    self:ClearList();
end

local frame;
local list;

function OnyBagMate:Render()
    self:RegisterEvent('CHAT_MSG_SYSTEM');

    frame = AceGUI:Create('Frame');
    frame:SetTitle('Onixia Bag Mate');
    frame:SetLayout('List');
    frame:SetCallback('OnClose', function(widget) self:UnregisterEvent('CHAT_MSG_SYSTEM'); AceGUI:Release(widget); end)

    local group = AceGUI:Create('SimpleGroup');
    group:SetFullWidth(true);
    group:SetLayout('Flow');

    local scan = AceGUI:Create('Button');
    scan:SetText('Scan raid');
    scan:SetCallback('OnClick', function() self:DemandScan(); end);

    group:AddChild(scan);

    local clear = AceGUI:Create('Button');
    clear:SetText('Clear');
    clear:SetCallback('OnClick', function() self:ClearList(); self:RenderList(); end);

    group:AddChild(clear);

    frame:AddChild(group);

    group:SetHeight(100);

    local group = AceGUI:Create('SimpleGroup');
    group:SetFullWidth(true);
    group:SetFullHeight(true);
    group:SetLayout('Fill');

    list = AceGUI:Create('ScrollFrame');
    list:SetFullWidth(true);
    list:SetFullHeight(true);
    list:SetLayout('List');

    group:AddChild(list);

    frame:AddChild(group);
    group:SetPoint('BOTTOM', 0, 5);
end

function OnyBagMate:RenderList()
    list:ReleaseChildren();

    local renderItem = function(item)
        local row = AceGUI:Create('SimpleGroup');
        row:SetFullWidth(true);
        row:SetLayout('Flow');

        local name = AceGUI:Create('Label');
        name:SetText(item['name']);
        row:AddChild(name);

        local roll = AceGUI:Create('Label');
        roll:SetText(item['roll']);
        row:AddChild(roll);

        list:AddChild(row);
    end

    local result = {};

    for _, v in ipairs(self.db.char.list) do
        if (v.bags <= self.db.char.pass) then
            tinsert(result, { name = v.name, roll = v.roll });
        end
    end

    sort(result, function(a, b) return a.roll > b.roll end);

    for _, v in ipairs(result) do
        renderItem(v);
    end
end

function OnyBagMate:ScanPlayer()
    local bags = 0;

    for i = 1, NUM_BAG_SLOTS do
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
--        print('received answer from: ' .. sender .. ' - ' .. tonumber(message));
        self:UpdateList({ name = sender, bags = tonumber(message) });
    end
end

function OnyBagMate:ClearList()
    for _, v in ipairs(self.db.char.list) do
        v['roll'] = 0;
    end
end

function OnyBagMate:UpdateList(item)
    local result = self.db.char.list or {};
    local found = false;

    for _, v in ipairs(result) do
        if v.name == item.name then
            found = true;
        end
    end

    if not found then
        tinsert(result, item);
    end

    sort(result, function(a, b) return a.name < b.name end);

    self.db.char.list = result;
--    print(#self.db.char.list);

    local pass = self.db.char.pass;

    if (pass == nil) then
        pass = item.bags;
    else
        pass = math.min(pass, item.bags);
    end

    self.db.char.pass = pass;
--    print(self.db.char.pass);
end

function OnyBagMate:RollList(item)
    local result = self.db.char.list or {};

    for _, v in ipairs(result) do
        if (v.name == item.name) then
            v['roll'] = item.roll;
        end
    end

    sort(result, function(a, b) return a.roll > b.roll end);

    self.db.char.list = result;
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
