local L = LibStub('AceLocale-3.0'):NewLocale('OnyBagMate', 'ruRU');

-- Core.lua
L['Onyxia Bag Mate'] = true;
L['Clear'] = 'Очистить';
L['Onyxia'] = 'Ониксия';
L['Onyxia Hide Backpack'] = 'Заплечный мешок из шкуры Ониксии';
L['Roll regexp'] = '(.+) выбрасывает (%d+) %((%d+)-(%d+)%)';
L['Frame status'] = function(count) return 'Минимальное кол-во сумок: ' .. (count or 0) end;
L['Rank # and above'] = 'Ранг # и выше';
L['Bonuses'] = 'Бонусы';
L['Enable bonuses'] = 'Использовать бонусы';
L['Roll bonus per Onyxia kill'] = 'Бонус к роллу за убийство Ониксии';
L['Import csv'] = 'Импорт csv';
L['CSV data'] = 'CSV данные';
