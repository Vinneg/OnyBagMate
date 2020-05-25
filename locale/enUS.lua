local L = LibStub('AceLocale-3.0'):NewLocale('OnyBagMate', 'enUS', true);

L['Onyxia Bag Mate'] = true;
L['Clear'] = true;
L['Roll'] = true;
L['Onyxia'] = true;
L['Onyxia\'s Lair'] = true;
L['Roll regexp'] = '(.+) rolls (%d+) %((%d+)-(%d+)%)';
L['Frame status'] = function(count) return 'Minimal bag count is: ' .. (count or 0) end;
L['Rank # and above'] = true;
L['Bonuses'] = true;
L['Loot'] = true;
L['Enable bonuses'] = true;
L['Auto open Roll Frame'] = true;
L['Auto announce Onyxia Bag'] = true;
L['Onyxia Bag announce message'] = true;
L['Default Announce Message'] = 'Roll %s!';
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
L['Classic mode'] = true;
L['Greed mode'] = true;
L['Players with a minimum number of bags rolls for new one'] = true;
L['All players rolls for new bag, bonuses decreases per bag owned'] = true;
L['Roll fine'] = true;
L['Roll fine per Onyxia bag owned'] = true;
L['OnyBagMate roll item'] = function(item, store)
    if (store.char.modeClassic) then
        if store.char.bonusEnable or false then
            return '' .. (item.total or 0) .. ' (' .. (item.roll or 0) .. ' roll + ' .. (item.bonus or 0) .. ' bonus)';
        else
            return '' .. (item.total or 0)
        end
    elseif (store.char.modeGreed) then
        return '' .. (item.total or 0) .. ' (' .. (item.roll or 0) .. ' roll + ' .. (item.bonus or 0) .. ' bonus - ' .. (item.fine or 0) .. ' fine)';
    end
end;
