local L = LibStub('AceLocale-3.0'):NewLocale('OnyBagMate', 'ruRU');

-- Core.lua
L['Onyxia Bag Mate'] = true;
L['Clear'] = 'Очистить';
L['Roll'] = true;
L['Onyxia'] = 'Ониксия';
L['Roll regexp'] = '(.+) выбрасывает (%d+) %((%d+)-(%d+)%)';
L['Frame status'] = function(count) return 'Минимальное кол-во сумок: ' .. (count or 0) end;
L['Rank # and above'] = 'Ранг # и выше';
L['Bonuses'] = 'Бонусы';
L['Enable bonuses'] = 'Использовать бонусы';
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
