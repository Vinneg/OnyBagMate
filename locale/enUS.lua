local L = LibStub('AceLocale-3.0'):NewLocale('OnyBagMate', 'enUS', true);

-- Core.lua
L['Onyxia Bag Mate'] = true;
L['Clear'] = true;
L['Onyxia'] = true;
L['Onyxia Hide Backpack'] = true;
L['Roll regexp'] = '(.+) rolls (%d+) %((%d+)-(%d+)%)';
L['Frame status'] = function(count) return 'Minimal bag count is: ' .. (count or 0) end;
L['Rank # and above'] = true;
L['Enable bonuses'] = true;
L['Roll bonus per Onyxia kill'] = true;
L['Import csv'] = true;
L['CSV data'] = true;
