local L = LibStub('AceLocale-3.0'):NewLocale('OnyBagMate', 'ruRU');

L['Onyxia Bag Mate'] = true;
L['Clear'] = 'Очистить';
L['Roll'] = true;
L['Onyxia'] = 'Ониксия';
L['Onyxia\'s Lair'] = 'Логово Ониксии';
L['Roll regexp'] = '(.+) выбрасывает (%d+) %((%d+)-(%d+)%)';
L['Frame status'] = function(count) return 'Минимальное кол-во сумок: ' .. (count or 0) end;
L['Rank # and above'] = 'Ранг # и выше';
L['Bonuses'] = 'Бонусы';
L['Loot'] = 'Добыча';
L['Enable bonuses'] = 'Использовать бонусы';
L['Auto open Roll Frame'] = 'Автооткрытие Окна Ролла';
L['Auto announce Onyxia Bag'] = 'Автоанонс Сумки Ониксии';
L['Onyxia Bag announce message'] = 'Сообщение анонса Сумки Ониксии';
L['Default Announce Message'] = 'Ролл %s!';
L['Roll bonus per Onyxia kill'] = 'Бонус к роллу за убийство Ониксии';
L['Import csv'] = 'Импорт csv';
L['Clear bonuses'] = 'Очистить бонусы';
L['CSV data'] = 'CSV данные';
L['Bonus Keeper'] = 'Хранитель бонусов';
L['Usage:'] = 'Использование:';
L['to open Options frame'] = 'открыть панель опций';
L['to open Roll frame'] = 'открыть окно роллов';
L['Bonuses to Raid'] = 'Бонусы Рейду';
L['Add bonuses to all raid members (even they are offline)'] = 'Добавление бонусов всем участникам рейда (даже если оффлайн)';
L['Bonuses to Guild'] = 'Бонусы Гильдии';
L['Add bonuses to online guild members and all raid members (even they are offline)'] = 'Добавление бонусов онлайн членам гильдии и всем участникам рейда (даже если оффлайн)';
L['OnyBagMate bonuses added to all raid members!'] = function(bonuses) return '' .. (tonumber(bonuses) or 0) .. ' OnyBagMate бонусов добавлено всем участникам рейда!' end;
L['OnyBagMate bonuses added to online guild members!'] = function(bonuses) return '' .. (tonumber(bonuses) or 0) .. ' OnyBagMate бонусов добавлено всем онлайн членам гильдии!' end;
L['Classic mode'] = "Классический режим";
L['Greed mode'] = 'Жадный режим';
L['Players with a minimum number of bags rolls for new one'] = 'На новую сумку роллят только игроки с минимальным количеством сумок';
L['All players rolls for new bag, bonuses decreases per bag owned'] = 'Все роллят на новую сумку, бонус уменьшается за каждую сумку у игрока';
L['Roll fine'] = 'Налог на бонусы';
L['Roll fine per Onyxia bag owned'] = 'Налог на бонусы за каждую сумку у игрока';
L['OnyBagMate roll item'] = function(item, store)
    if (store.char.modeClassic) then
        if store.char.bonusEnable or false then
            return '' .. (item.total or 0) .. ' (' .. (item.roll or 0) .. ' ролл + ' .. (item.bonus or 0) .. ' бонус)';
        else
            return '' .. (item.total or 0)
        end
    elseif (store.char.modeGreed) then
        return '' .. (item.total or 0) .. ' (' .. (item.roll or 0) .. ' ролл + ' .. (item.bonus or 0) .. ' бонус - ' .. (item.fine or 0) .. ' налог)';
    end
end;
