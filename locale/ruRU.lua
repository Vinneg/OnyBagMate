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
