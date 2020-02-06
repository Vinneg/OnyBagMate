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
    self.frame:SetTitle('Onixia Bag Mate');
--    self.frame:SetLayout('List');
    self.frame:SetLayout(nil);
    self.frame:SetCallback('OnClose', function(widget) OnyBagMate:UnregisterEvent('CHAT_MSG_SYSTEM'); AceGUI:Release(widget); end)

    local clear = AceGUI:Create('Button');
    clear:SetText('Clear');
    clear:SetFullWidth(true);
    clear:SetCallback('OnClick', function() self:ClearList(); self:RenderList(); end);

    self.frame:AddChild(clear);
    clear:SetPoint('TOPLEFT', 0, 5);
    clear:SetPoint('TOPRIGHT', 0, 5);

    local group = AceGUI:Create('SimpleGroup');
    group:SetFullWidth(true);
    group:SetFullHeight(true);
    group:SetLayout('Fill');

    self.frame:AddChild(group);
    group:SetPoint('TOP', clear.frame, 'BOTTOM', 0, -5);
    group:SetPoint('LEFT', clear.frame, 'LEFT', 0, 5);
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

    local renderItem = function(item)
        local df = LSM:GetDefault('font');

        local row = AceGUI:Create('SimpleGroup');
        row:SetFullWidth(true);
        row:SetLayout('Flow');

        local name = AceGUI:Create('Label');
        name:SetFont(df, 22, nil);
        name:SetText(item.name);
        row:AddChild(name);

        local roll = AceGUI:Create('Label');
        roll:SetFont(df, 22, nil);
        roll:SetText(item.roll);
        row:AddChild(roll);

        self.list:AddChild(row);
    end

    local result = {};

    for _, v in ipairs(self.state.list) do
        if (v.bags <= self.state.pass) then
            tinsert(result, { name = v.name, roll = v.roll });
        end
    end

    sort(result, function(a, b) return (a.roll or 0) > (b.roll or 0) end);

    for _, v in ipairs(result) do
        renderItem(v);
    end
end

function OnyBagMate.RollFrame:UpdateStatus(count)
    self.frame:SetStatusText(L['Frame status'](count));
end
