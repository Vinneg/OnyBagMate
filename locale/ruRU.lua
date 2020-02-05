local L = LibStub('AceLocale-3.0'):NewLocale('OnyBagMate', 'ruRU');

-- Core.lua
L['Onyxia Bag Mate'] = true;
L['Onyxia'] = 'Ониксия';
L['Onyxia Hide Backpack'] = 'Заплечный мешок из шкуры Ониксии';
L['Roll regexp'] = '(.+) выбрасывает (%d+) %((%d+)-(%d+)%)';
L['Frame status'] = function(count) return 'Минимальное кол-во сумок: ' .. (count or 0) end;
