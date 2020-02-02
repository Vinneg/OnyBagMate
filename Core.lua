local AceConfig = LibStub("AceConfig-3.0");
local AceDB = LibStub("AceDB-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-3.0");

OniBagMate = LibStub("AceAddon-3.0"):NewAddon("OniBagMate", "AceConsole-3.0");

OniBagMate.defaults = { char = {} };

OniBagMate.options = {};

OniBagMate.db = {};

function OniBagMate:HandleChatCommand(input)
    if (input == nil) then
        return;
    end

    local arg = strlower(input);

    if arg == "opts" then
        AceConfigDialog:Open("Options");
    elseif arg == "scan" then
        self:EPGP_ScanRaid();
    end
end

function OniBagMate:OnInitialize()
    self:RegisterChatCommand("cepz", "HandleChatCommand");

    AceConfig:RegisterOptionsTable("Options", OniBagMate.options);

    self.db = AceDB:New("Settings", OniBagMate.defaults, true);
end
