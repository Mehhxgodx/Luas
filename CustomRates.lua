local charactersSQL = [[ CREATE TABLE IF NOT EXISTS `character_rate_xp` (`guid` int(11) unsigned NOT NULL, `rate` int(11) NOT NULL DEFAULT 0, PRIMARY KEY (`guid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
CharDBQuery(charactersSQL)

local npc = 190004

local rates = {
    --     rate,     gold,   token,     amount
    [1] = { 1,         0,        0,       0},
    [2] = { 2,         0,        0,       0},
    [3] = { 3,         0,        0,       0},
    [4] = { 4,        50,    29736,      10},
    [5] = { 5,       100,    29736,      20},
    [6] = { 6,       150,    29736,      30},
    [7] = { 7,       200,    29736,      40},
    [8] = { 8,       250,    29736,      50},
    [9] = { 9,       350,    29736,      60},
    [10] = { 10,     450,    29736,      70},
}

local Cache = {}
local function LoadCache()
    local result = CharDBQuery("SELECT guid, rate FROM character_rate_xp")
    if result then
        repeat
            Cache[result:GetUInt32(0)] = result:GetUInt8(1)
        until not result:NextRow()
    end
end LoadCache()

local function OnGossipHello(event, player, object)
    player:GossipClearMenu()
    if Cache[player:GetGUIDLow()] then
        object:SendUnitWhisper( "Tu rate de experiencia está x"..Cache[player:GetGUIDLow()], 0, player )
    else
        object:SendUnitWhisper( "Tu rate de experiencia está x1", 0, player )
    end
    for k, v in ipairs(rates) do
        player:GossipMenuAddItem( 1, "|TINTERFACE/ICONS/Achievement_Quests_Completed_08:28:28:-15:0|tRates x"..v[1].." : Gold: "..v[2].." : Token: "..v[4], 0, v[1], false, "Estás seguro que quieres cambiar tu rate de experiencia a x"..v[1], v[2]*10000 )
    end
    player:GossipSendMenu( 1, object )
end RegisterCreatureGossipEvent( npc, 1, OnGossipHello )

local function OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if rates[intid][4] > 0 then
        if not player:HasItem(rates[intid][3], rates[intid][4]) then
            player:GossipComplete()
            object:SendUnitWhisper( "No tienes tokens suficientes!", 0, player )
            return
        end
        player:RemoveItem(rates[intid][3], rates[intid][4])
    end
    player:ModifyMoney( -rates[intid][2]*10000)
    Cache[player:GetGUIDLow()] = intid
    CharDBExecute("REPLACE INTO character_rate_xp (guid, rate) VALUES ('"..player:GetGUIDLow().."', '"..intid.."')")
    object:SendUnitWhisper( "Felicidades cambiaste tu rate de experiencia a x"..intid, 0, player )
    player:CastSpell(player, 47292, true)
    player:GossipComplete()
end RegisterCreatureGossipEvent( npc, 2, OnGossipSelect )

local function OnGiveXP(event, player, amount, victim)
    if Cache[player:GetGUIDLow()] then
        amount = amount * Cache[player:GetGUIDLow()]
        return amount
    end
end RegisterPlayerEvent( 12, OnGiveXP )