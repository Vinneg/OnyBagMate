OnyBagMate = LibStub('AceAddon-3.0'):NewAddon('OnyBagMate', 'AceConsole-3.0', 'AceEvent-3.0', 'AceComm-3.0', 'AceTimer-3.0');

local AceConfig = LibStub('AceConfig-3.0');
local AceConfigDialog = LibStub('AceConfigDialog-3.0');
local AceDB = LibStub('AceDB-3.0');
local L = LibStub('AceLocale-3.0'):GetLocale('OnyBagMate');

local function get(info)
    return OnyBagMate.store.char[info[#info]];
end

local function set(info, value)
    OnyBagMate.store.char[info[#info]] = value;
end

local function getBanks()
    local res = { -1 };

    for i = 1, NUM_BANKBAGSLOTS do
        tinsert(res, i + NUM_BAG_SLOTS);
    end

    return res;
end

local function getGuildInfo(player)
    if not IsInGuild() then
        return nil;
    end

    --    C_GuildInfo.GuildRoster();

    local ttlMembers = GetNumGuildMembers();

    for i = 1, ttlMembers do
        local name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID = GetGuildRosterInfo(i);

        name = Ambiguate(name, 'all');

        if name == player then
            return i, name, rankName, rankIndex, level, classDisplayName, zone, publicNote, officerNote, isOnline, status, class, achievementPoints, achievementRank, isMobile, canSoR, repStanding, GUID;
        end
    end
end

OnyBagMate.messages = {
    scanEvent = 'OnyBagMateScan',
    prefix = 'OnyBagMate',
    demandScan = 'scan bags',
    raid = 'RAID',
    guild = 'GUILD',
    whisper = 'WHISPER',
    answer = '(.+)#(%d+)'
};

OnyBagMate.state = {
    version = 1.3,
    name = '',
    class = '',
    pass = nil,
    list = {},
    bagId = 17966,
    bankBagIds = getBanks(),
};

OnyBagMate.defaults = {
    char = {
        rank = '',
        bonusEnable = true,
        bonusPoints = '5',
        lastBonus = '',
        bankBags = 0,
        guild = {},
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
        clearBonuses = {
            hidden = function() return not (OnyBagMate.store.char.bonusEnable or false); end,
            type = 'execute',
            order = 50,
            name = L['Clear bonuses'],
            func = function() OnyBagMate:ClearBonuses(); end,
        },
    },
};

OnyBagMate.store = {};

function OnyBagMate:HandleChatCommand(input)
    if (input == nil) then
        return;
    end

    local arg = strlower(input);

    if arg == 'test' then
        OnyBagMate:ScanPlayer();
    elseif arg == 'opts' then
        AceConfigDialog:Open('OnyBagMateOptions');
    elseif arg == 'open' then
        self.RollFrame:Render();
    end
end

function OnyBagMate:OnInitialize()
    self:RegisterChatCommand('onybm', 'HandleChatCommand');

    AceConfig:RegisterOptionsTable('OnyBagMateOptions', self.options);
    self.store = AceDB:New('OnyBagMateStore', self.defaults, true);

    self:RegisterComm(self.messages.scanEvent, 'handleScanEvent');

    self.state.name = GetUnitName('player', false);
    self.state.class = select(2, UnitClass("player"));

    self:ClearList();

    self:RegisterEvent('BANKFRAME_CLOSED');
    self:RegisterEvent('ENCOUNTER_START');
    self:RegisterEvent('ENCOUNTER_END');

    self:ScheduleTimer('PrintVersion', 5);
end

function OnyBagMate:PrintVersion()
    print('|cFF00FAF6OnyBagMate loaded! Version: ' .. self.state.version .. '|r');
end

function OnyBagMate:ScanPlayer()
    local bags = 0;

    for i = 0, NUM_BAG_SLOTS do
        if i ~= 0 then
            local invID = ContainerIDToInventoryID(i);
            local itemId = GetInventoryItemID("player", invID);

            if itemId == self.state.bagId then
                bags = bags + 1;
            end
        end

        local slots = GetContainerNumSlots(i);

        if slots ~= 0 then
            for j = 1, slots do
                local itemId = GetContainerItemID(i, j);

                if itemId == self.state.bagId then
                    bags = bags + 1;
                end
            end
        end
    end

    return bags;
end

function OnyBagMate:ScanBank()
    local bags = 0;

    for _, i in ipairs(self.state.bankBagIds) do
        local invID;

        if i == -1 then
            invID = BankButtonIDToInvSlotID(i, 1);
        else
            invID = ContainerIDToInventoryID(i);
        end

        local itemId = GetInventoryItemID("player", invID);

        if itemId == self.state.bagId then
            bags = bags + 1;
        end

        local slots = GetContainerNumSlots(i);

        if slots ~= 0 then
            for j = 1, slots do
                local itemId = GetContainerItemID(i, j);

                if itemId == self.state.bagId then
                    bags = bags + 1;
                end
            end
        end
    end

    return bags;
end

function OnyBagMate:DemandScan()
    self:SendCommMessage(self.messages.scanEvent, self.messages.demandScan, self.messages.raid);
end

function OnyBagMate:handleScanEvent(_, message, _, sender)
    if message == self.messages.demandScan then
        local bags = self:ScanPlayer() + (self.store.char.bankBags or 0);

        self:SendCommMessage(self.messages.scanEvent, self.state.class .. '#' .. tostring(bags), self.messages.whisper, sender);
    else
        local class, bags = string.match(message, self.messages.answer);

        if class and bags then
            local item = { name = sender, class = class, bags = tonumber(bags) };

            self:UpdateList(item);
            self:UpdatePass(item);

            self.RollFrame:RenderList();
        end
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

function OnyBagMate:GetBonusBase(player)
    local offNote = select(9, getGuildInfo(player));

    if offNote == nil then
        return 0;
    end

    local bonus = string.match(offNote, 'obm{(-?%d+%.?%d*)}');

    return tonumber(bonus) or 0;
end

function OnyBagMate:SetBonusBase(player, bonus)
    local i, _, _, _, _, _, _, _, offNote = getGuildInfo(player);

    if offNote == nil then
        return 0;
    end

    local newBonus = 'obm{' .. (tonumber(bonus) or 0) .. '}';

    local newOffNote, subs = string.gsub(offNote, 'obm{[^}]*}', newBonus);

    if subs == 0 then
        newOffNote = (offNote .. newBonus);
    end

    GuildRosterSetOfficerNote(i, newOffNote);
end

function OnyBagMate:ClearBonuses()
    if not IsInGuild() then
        return nil;
    end

    local ttlMembers = GetNumGuildMembers();

    for i = 1, ttlMembers do
        local offNote = select(8, GetGuildRosterInfo(i));

        local newOffNote, subs = string.gsub(offNote, 'obm{[^}]*}', '');

        if subs ~= 0 then
            GuildRosterSetOfficerNote(i, newOffNote);
        end
    end

    OnyBagMate.store.char.lastBonus = '';
end

function OnyBagMate:CHAT_MSG_SYSTEM(_, message)
    local name, roll, min, max = string.match(message, L['Roll regexp']);

    roll = tonumber(roll);
    min = tonumber(min);
    max = tonumber(max);

    if (name and roll and min == 1 and max == 100) then
        self:RollList({ name = name, roll = roll });

        self.RollFrame:RenderList();
    end
end

function OnyBagMate:BANKFRAME_CLOSED()
    self.store.char.bankBags = self:ScanBank();
end

function OnyBagMate:ENCOUNTER_START(_, id, name, difficulty, groupSize)
    print('ENCOUNTER_END: id = ', id, ', name = ', name, ', difficulty = ', difficulty, ', groupSize = ', groupSize);
end

function OnyBagMate:ENCOUNTER_END(_, id, name, difficulty, groupSize, success)
    print('ENCOUNTER_END: id = ', id, ', name = ', name, ', difficulty = ', difficulty, ', groupSize = ', groupSize, ', success = ', success);
end
