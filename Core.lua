local AceConfig = LibStub("AceConfig-3.0");
local AceDB = LibStub("AceDB-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");
local AceGUI = LibStub('AceGUI-3.0');
local L = LibStub('AceLocale-3.0'):GetLocale('Overseer');

OnyBagMate = LibStub("AceAddon-3.0"):NewAddon("OnyBagMate", "AceConsole-3.0");

local function get(info)
    return OnyBagMate.db.char[info[#info]];
end

local function set(info, value)
    OnyBagMate.db.char[info[#info]] = value;
end

OnyBagMate.defaults = {
    char = {
        rank = '',
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

    if arg == "opts" then
        AceConfigDialog:Open("Options");
    elseif arg == "open" then
        self:ShowRoster();
    end
end

function OnyBagMate:OnInitialize()
    self:RegisterChatCommand("onybm", "HandleChatCommand");

    AceConfig:RegisterOptionsTable("Options", OnyBagMate.options);
    self.db = AceDB:New("Settings", OnyBagMate.defaults, true);
end

local frame;
local list;

function OnyBagMate:ShowRoster()
    frame = AceGUI:Create('Frame');
    frame:SetTitle('Onixia Bag Mate');
    frame:SetLayout('List');
    frame:SetCallback('OnClose', function(widget) AceGUI:Release(widget) end)

    self:AddButtons();
end

function OnyBagMate:AddButtons()
    local group = AceGUI:Create('SimpleGroup');
    group:SetFullWidth(true);
    group:SetHeight(80);
    group:SetLayout('Flow');

    local scan = AceGUI:Create('Button');
    scan:SetText('Scan raid');
    scan:SetCallback("OnClick", function() self:ScanPlayer() end);

    group:AddChild(scan);

    local clear = AceGUI:Create('Button');
    clear:SetText('Clear');
    clear:SetCallback("OnClick", function() end);

    group:AddChild(clear);

    frame:AddChild(group);
end

function OnyBagMate:ScanPlayer()
    local count = 0;

    for i = 1, NUM_BAG_SLOTS do
        local bagName = GetBagName(i);

        print(i .. ": " .. bagName);

        if bagName == L['Onyxia Hide Backpack'] then
            count = count + 1;
        end
    end

    return count;
end
