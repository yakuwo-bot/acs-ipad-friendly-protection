-- Amazing Cultivation Simulator Mobile (iPad/iOS)
-- Player-faction-only HEALTH PROTECTION prototype.
-- No CS.GameMain.Instance.AllGod: that flag also makes enemies invincible.
-- Engine callbacks and healing methods are used by existing ACS Lua mods.
-- This is NOT damage interception. Fatal one-hit attacks can still kill units.

local FriendlyProtection = GameMain:NewMod("IOSFriendlyProtection")
local REFRESH_SECONDS = 0.05

function FriendlyProtection:ProtectFriendlies()
    local ok, count = pcall(function()
        -- Combat camps are engine enums; do not assume numeric IDs.
        local camp = CS.XiaWorld.Fight.g_emFightCamp.Player
        if camp == nil then return 0 end

        -- GameMain mod callbacks generally expose Map. Use World.map if not.
        local map = Map
        if map == nil and CS.XiaWorld.World.Instance ~= nil then
            map = CS.XiaWorld.World.Instance.map
        end
        if map == nil or map.Things == nil then return 0 end

        local npcs = map.Things:GetActiveNpcs()
        if npcs == nil or npcs.Count == nil then return 0 end
        local changed = 0
        for i = 0, npcs.Count - 1 do
            -- Each NPC is isolated: an unusual NPC should not abort the loop.
            local worked = pcall(function()
                local npc = npcs[i]
                if npc == nil or npc.Camp ~= camp or npc.IsDeath then return end
                local props = npc.PropertyMgr
                if props == nil or props.BodyData == nil then return end
                -- Exact spelling from an existing ACS Lua mod API call.
                props.BodyData:RemoveAllDamange()
                npc:RestHp()
                changed = changed + 1
            end)
            if not worked then
                self._npcErrors = (self._npcErrors or 0) + 1
            end
        end
        return changed
    end)
    if not ok then
        self._loopErrors = (self._loopErrors or 0) + 1
        return 0
    end
    return count
end

function FriendlyProtection:OnInit()
    self._elapsed = 0
end

function FriendlyProtection:OnEnter()
    self._elapsed = 0
    self:ProtectFriendlies()
end

function FriendlyProtection:OnAfterLoad()
    self._elapsed = 0
    self:ProtectFriendlies()
end

function FriendlyProtection:OnStep(dt)
    local elapsed = tonumber(dt) or 0
    if elapsed < 0 then elapsed = 0 end
    self._elapsed = (self._elapsed or 0) + elapsed
    if self._elapsed >= REFRESH_SECONDS then
        self._elapsed = 0
        self:ProtectFriendlies()
    end
end

function FriendlyProtection:OnLeave()
    self._elapsed = 0
end
