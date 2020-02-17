local OnyBagMate = LibStub('AceAddon-3.0'):GetAddon('OnyBagMate');

local AceGUI = LibStub('AceGUI-3.0');
local LSM = LibStub('LibSharedMedia-3.0');
local L = LibStub('AceLocale-3.0'):GetLocale('OnyBagMate');

OnyBagMate.RollFrame = {
    frame = nil,
    list = nil,
};

function OnyBagMate.RollFrame:Render()
    OnyBagMate:RegisterEvent('CHAT_MSG_SYSTEM');

    self.frame = AceGUI:Create('Frame');
    self.frame:SetTitle(L['Onyxia Bag Mate']);
    self.frame:SetLayout(nil);
    self.frame:SetCallback('OnClose', function(widget) OnyBagMate:UnregisterEvent('CHAT_MSG_SYSTEM'); OnyBagMate:ClearList(); AceGUI:Release(widget); end)

    local roll = AceGUI:Create('Button');
    roll:SetText(L['Roll']);
    roll:SetFullWidth(true);
    roll:SetCallback('OnClick', function() RandomRoll(1, 100); end);

    self.frame:AddChild(roll);

    local clear = AceGUI:Create('Button');
    clear:SetText(L['Clear']);
    clear:SetFullWidth(true);
    clear:SetCallback('OnClick', function() OnyBagMate:ClearList(); self:RenderList(); end);

    self.frame:AddChild(clear);

    roll:SetPoint('TOPLEFT', 0, 5);
    clear:SetPoint('TOPRIGHT', 0, 5);

    local group = AceGUI:Create('SimpleGroup');
    group:SetFullWidth(true);
    group:SetFullHeight(true);
    group:SetLayout('Fill');

    self.frame:AddChild(group);
    group:SetPoint('TOPLEFT', roll.frame, 'BOTTOMLEFT', 0, -5);
    group:SetPoint('TOPRIGHT', clear.frame, 'BOTTOMRIGHT', 0, 5);
    group:SetPoint('RIGHT', clear.frame, 'RIGHT', 0, 5);
    group:SetPoint('BOTTOM', self.frame.frame, 'BOTTOM', 0, 50);

    self.list = AceGUI:Create('ScrollFrame');
    self.list:SetFullWidth(true);
    self.list:SetFullHeight(true);
    self.list:SetLayout('List');

    group:AddChild(self.list);

    OnyBagMate:DemandScan();

    self:UpdateStatus(OnyBagMate.state.pass);
end

function OnyBagMate.RollFrame:RenderList()
    self.list:ReleaseChildren();

    local classColor = function(class)
        if class == 'DEATHKNIGHT' then
            return 0.77, 0.12, 0.23;
        elseif class == 'DEMONHUNTER' then
            return 0.64, 0.19, 0.79;
        elseif class == 'DRUID' then
            return 1.00, 0.49, 0.04;
        elseif class == 'HUNTER' then
            return 0.67, 0.83, 0.45;
        elseif class == 'MAGE' then
            return 0.25, 0.78, 0.92;
        elseif class == 'MONK' then
            return 0.00, 1.00, 0.59;
        elseif class == 'PALADIN' then
            return 0.96, 0.55, 0.73;
        elseif class == 'PRIEST' then
            return 1.00, 1.00, 1.00;
        elseif class == 'ROGUE' then
            return 1.00, 0.96, 0.41;
        elseif class == 'SHAMAN' then
            return 0.00, 0.44, 0.87;
        elseif class == 'WARLOCK' then
            return 0.53, 0.53, 0.93;
        elseif class == 'WARRIOR' then
            return 0.78, 0.61, 0.43;
        end
    end

    local renderItem = function(item)
        local df = LSM.MediaTable.font[LSM:GetDefault('font')];

        local row = AceGUI:Create('SimpleGroup');
        row:SetFullWidth(true);
        row:SetLayout('Flow');

        self.list:AddChild(row);

        local name = AceGUI:Create('Label');
        name:SetFont(df, 18, 'OUTLINE');
        name:SetColor(classColor(item.class));
        name:SetText(item.name);
        name:SetRelativeWidth(0.4);
        name:SetFullHeight(true);
        row:AddChild(name);

        local rollTotal = (item.roll or 0);
        if OnyBagMate.store.char.bonusEnable or false then
            rollTotal = '' .. (item.total or 0) .. ' (' .. (item.roll or 0) .. 'roll + ' .. (item.bonus or 0) .. 'bonus)';
        end

        local roll = AceGUI:Create('Label');
        roll:SetFont(df, 18, 'OUTLINE');
        roll:SetText(rollTotal);
        roll:SetRelativeWidth(0.6);
        roll:SetFullHeight(true);
        row:AddChild(roll);
    end

    local result = {};

    for _, v in ipairs(OnyBagMate.state.list) do
        if (v.bags <= OnyBagMate.state.pass) then
            local tmp = { name = v.name, class = v.class, roll = v.roll or 0, bonus = OnyBagMate.store.char.bonuses[v.name] or 0 };
            if OnyBagMate.store.char.bonusEnable or false then
                tmp.total = tmp.roll + tmp.bonus;
            else
                tmp.total = tmp.roll;
            end

            tinsert(result, tmp);
        end
    end

    sort(result, function(a, b) return (a.total or 0) > (b.total or 0) end);

    for _, v in ipairs(result) do
        renderItem(v);
    end
end

function OnyBagMate.RollFrame:UpdateStatus(count)
    self.frame:SetStatusText(L['Frame status'](count));
end
