OnyBagMate = LibStub('AceAddon-3.0'):NewAddon('OnyBagMate', 'AceConsole-3.0', 'AceEvent-3.0', 'AceComm-3.0');

local AceConfig = LibStub('AceConfig-3.0');
local AceConfigDialog = LibStub('AceConfigDialog-3.0');
local AceDB = LibStub('AceDB-3.0');
local AceSerializer = LibStub('AceSerializer-3.0');
local L = LibStub('AceLocale-3.0'):GetLocale('OnyBagMate');

local function get(info)
    return OnyBagMate.store.char[info[#info]];
end

local function set(info, value)
    OnyBagMate.store.char[info[#info]] = value;
end

OnyBagMate.messages = {
    scanEvent = 'OnyBagMateScan',
    bonusEvent = 'OnyBagMateBonus',
    prefix = 'OnyBagMate',
    demandScan = 'scan bags',
    raid = 'RAID',
    guild = 'GUILD',
    whisper = 'WHISPER',
    answer = '(.+)#(%d+)'
};

OnyBagMate.state = {
    name = '',
    class = '',
    pass = nil,
    list = {},
};

OnyBagMate.defaults = {
    char = {
        rank = '',
        bonusEnable = true,
        bonusPoints = '5',
        bonuses = {},
        lastBonus = '',
        bonusKeeper = '',
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
            name = L['Rank # and above'],
            get = function(info) return get(info); end,
            set = function(info, value) set(info, value); end,
        },
        bonusHeader = {
            type = 'header',
            order = 10,
            name = L['Bonuses'],
        },
        bonusEnable = {
            type = 'toggle',
            order = 20,
            name = L['Enable bonuses'],
            get = function(info) return get(info); end,
            set = function(info, value) set(info, value); end,
        },
        bonusPoints = {
            hidden = function() return not (OnyBagMate.store.char.bonusEnable or false); end,
            type = 'input',
            order = 30,
            name = L['Roll bonus per Onyxia kill'],
            get = function(info) return get(info); end,
            set = function(info, value) set(info, value); end,
        },
        importBonuses = {
            hidden = function() return not (OnyBagMate.store.char.bonusEnable or false); end,
            type = 'execute',
            order = 40,
            name = L['Import csv'],
            func = function() OnyBagMate.AttendanceFrame:Render(); end,
        },
        bonusKeeper = {
            hidden = function() return not (OnyBagMate.store.char.bonusEnable or false); end,
            type = 'input',
            order = 50,
            name = L['Bonus Keeper'],
            get = function(info) return get(info); end,
            set = function(info, value) set(info, value); end,
        },
    },
};

OnyBagMate.store = {};

function OnyBagMate:HandleChatCommand(input)
    if (input == nil) then
        return;
    end

    local arg = strlower(input);

    if arg == 'opts' then
        AceConfigDialog:Open('Options');
    elseif arg == 'open' then
        self.RollFrame:Render();
    end
end

function OnyBagMate:OnInitialize()
    self:RegisterChatCommand('onybm', 'HandleChatCommand');

    AceConfig:RegisterOptionsTable('Options', self.options);
    self.store = AceDB:New('OnyBagMateStore', self.defaults, true);

    self:RegisterComm(self.messages.scanEvent, 'handleScanEvent');
    self:RegisterComm(self.messages.bonusEvent, 'handleBonusEvent');

    self.state.name = GetUnitName('player', false);
    self.state.class = select(2, UnitClass("player"));

    self:ClearList();
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
    self:SendCommMessage(self.messages.scanEvent, self.messages.demandScan, self.messages.raid);
end

function OnyBagMate:handleScanEvent(_, message, _, sender)
    if message == self.messages.demandScan then
        --        print('received demand from: ' .. sender);
        local bags = self.ScanPlayer();

        self:SendCommMessage(self.messages.scanEvent, self.state.class .. '#' .. tostring(bags), self.messages.whisper, sender);
    else
        local class, bags = string.match(message, self.messages.answer);
        --        print('class = ' .. class .. ' bags = ' .. bags .. ' name = ' .. sender);

        if class and bags then
            local item = { name = sender, class = class, bags = tonumber(bags) };
            --        print('received answer from: ' .. item.name .. ' - ' .. item.bags);
            self:UpdateList(item);
            self:UpdatePass(item);

            self.RollFrame:RenderList();
        end
    end
end

function OnyBagMate:SyncBonuses()
    if self.state.name ~= self.store.char.bonusKeeper then
        return;
    end

    local data = AceSerializer:Serialize(self.store.char.bonuses, self.store.char.lastBonus);

    self:SendCommMessage(self.messages.bonusEvent, data, self.messages.guild);
end

function OnyBagMate:handleBonusEvent(_, message, _, sender)
    if sender == self.state.name then
        return;
    end

    if sender ~= self.store.char.bonusKeeper then
        return;
    end

    local success, bonuses, lastBonus = AceSerializer:Deserialize(message);

    if not success then
        return;
    end

    self.store.char.bonuses = bonuses;
    self.store.char.lastBonus = lastBonus;
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
            v.class = item.class;
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

    self.RollFrame:UpdateStatus(self.state.pass);
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

        self.RollFrame:RenderList();
    end
end
