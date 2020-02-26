local L = LibStub('AceLocale-3.0'):NewLocale('OnyBagMate', 'enUS', true);

-- Core.lua
L['Onyxia Bag Mate'] = true;
L['Clear'] = true;
L['Roll'] = true;
L['Onyxia'] = true;
L['Roll regexp'] = '(.+) rolls (%d+) %((%d+)-(%d+)%)';
L['Frame status'] = function(count) return 'Minimal bag count is: ' .. (count or 0) end;
L['Rank # and above'] = true;
L['Bonuses'] = true;
L['Enable bonuses'] = true;
L['Roll bonus per Onyxia kill'] = true;
L['Import csv'] = true;
L['Clear bonuses'] = true;
L['CSV data'] = true;
L['Bonus Keeper'] = true;
L['Usage:'] = true;
L['to open Options frame'] = true;
L['to open Roll frame'] = true;
L['Bonuses to Raid'] = true;
L['Add bonuses to all raid members (even they are offline)'] = true;
L['Bonuses to Guild'] = true;
L['Add bonuses to online guild members and all raid members (even they are offline)'] = true;
L['OnyBagMate bonuses added to all raid members!'] = function(bonuses) return '' .. (tonumber(bonuses) or 0) .. ' OnyBagMate bonuses added to all raid members!' end;
L['OnyBagMate bonuses added to online guild members!'] = function(bonuses) return '' .. (tonumber(bonuses) or 0) .. ' OnyBagMate bonuses added to online guild members!' end;
