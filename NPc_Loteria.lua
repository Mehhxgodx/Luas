--[[
Script Name: In-Game Gamble
Made By: PrivateDonut
Website: wowemulation.com
Based off JadaDevs Gambling Script
]] --

local npcid = 190001 -- Creature entry ID
local cost = 10000 -- Cost to gamble in copper(10000 = 1 gold, 100000 = 10 gold, 1000000 = 100 gold,)
local minamount = 10 -- Minimum amount of gold allowed
local maxamount = 10000 -- Maximum amount of gold allowed
local rng = 50 -- Lower number = lower chance of winning, higher number = higher chance of winning
local multiplier = 2 -- Multiple the amount bet by 2

-- DO NOT EDIT BELOW THIS LINE, UNLESS YOU KNOW WHAT YOU'RE DOING.
local function OnGossipHello(event, player, npc)
    player:GossipMenuAddItem(
        0,
        "|TInterface\\icons\\INV_Misc_Coin_01:30:30:-20|tApostar Oro|r",
        0,
        1,
        "",
        "|cffffffffNPc de Lotería \n Monto minimo :|cff00ff00 " .. minamount .. "|cffffff00  Oro\n |cffffffffMonto Máximo :|cffff0000 " .. maxamount .. "|cffffff00  Oro\n|cffffffffCantidad requerida de oro para apostar:|r",
        cost
    )
    player:GossipMenuAddItem(1, "|TInterface\\icons\\Mail_GMIcon:30:30:-20|tOportunidad de Ganar : |cff3e16fa".. rng .. "%|r", 0, 3)
    player:GossipMenuAddItem(2, "|TInterface\\icons\\Spell_Shadow_SacrificialShield:30:30:-20|tNo Importa|r", 0, 2)
    player:GossipSendMenu(1, npc)
end

local function OnGossipSelect(event, player, npc, sender, intid, code)
    if intid == 1 then
        if tonumber(code) then
        else
            player:GossipComplete()
            return;
        end
        local bet_amount = tonumber(code) * 10000
        local max = maxamount * 10000
        local low = minamount * 10000
        player:ModifyMoney(-cost)
        if bet_amount > player:GetCoinage() then
            player:SendBroadcastMessage("Lo sentimos, no tienes el dinero suficiente para hacer esa apuesta.")
            player:GossipComplete()
        elseif bet_amount < minamount then
            player:SendBroadcastMessage("Lo sentimos, ¡tu apuesta es demasiado baja! La cantidad mínima permitida es:" .. minamount .. "")
            player:GossipComplete()
        elseif bet_amount > max then
            player:SendBroadcastMessage("¡Lo siento, tu apuesta es demasiado alta! La cantidad máxima permitida es:" .. maxamount .. "")
            player:GossipComplete()
        else
            player:ModifyMoney(-bet_amount)
            local rngwonorlost = math.random(1, 100)
            if rngwonorlost <= rng then
                rngcolor = "|cff00ff00"
            else
                rngcolor = "|cffff0000"
            end  
            player:SendBroadcastMessage("Roleado :" .. rngcolor .. rngwonorlost)
            if rngwonorlost <= rng then
                local amountWon = bet_amount * multiplier
                local gold = amountWon / 10000
                local currentGold = player:GetCoinage()
                local goldCap = 2147483646
                local goldCapCheck = currentGold + amountWon
                local mailSubject = "¡Felicitaciones, aquí están sus ganancias!"
                local mailMessage = "Ha alcanzado el límite de oro, ¡así que he tenido que enviarle sus ganancias por correo!"
                local playerGUID = player:GetGUIDLow()

                if goldCapCheck > goldCap then
                     player:SendBroadcastMessage(
                        "|cffffff00Congratulations, You earned |cff00ff00" .. gold .. "|cffffff00 Gold, Please check your mailbox.|r")
                    SendMail(mailSubject, mailMessage, playerGUID, playerGUID, 61, 0, gold, 0, 0)

                elseif goldCapCheck < goldCap then
                    npc:SendUnitSay("Ou Noo...Esta vez eh perdido. Felicitaciones, ganaste la apuesta. Te comerciare la cantidad de oro que haz ganado |cffffff00"..player:GetName().."|r .Espero y regreses pronto a probar suerte.|r", 0, player )
                    player:ModifyMoney(amountWon)
                    player:SendBroadcastMessage(string.format("|cffffff00Recibido |cff00ff00%d|cffffff00 de Oro!|r", gold))
                    npc:EmoteState( 18 )
                    player:GossipComplete()

                end

            elseif rngwonorlost > rng then
                player:GossipComplete()
                local lost_amount = bet_amount / 10000
                npc:EmoteState( 7 )
                npc:SendUnitSay("Hahaha...Lo siento, perdiste la apuesta! |cffffff00"..player:GetName().."|r Gracias por esta pequeña cotización |cffff0000" .. lost_amount .. " de Oro |r.Espero y regreses pronto a probar suerte.", 0, player )
            end
        end
    elseif intid == 2 then
        player:GossipComplete()
    elseif intid == 3 then
        OnGossipHello(event, player, npc)
    end
end

RegisterCreatureGossipEvent(npcid, 1, OnGossipHello)
RegisterCreatureGossipEvent(npcid, 2, OnGossipSelect)