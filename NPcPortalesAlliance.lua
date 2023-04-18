--NPC id
local hcNPC = 0

--Primera pantalla de chismes para NPC
function OnFirstTalk(event, player, unit)
  if player:GetLevel() == 40 == 60 then
    player:PlayDistanceSound(20431)
    player:GossipMenuAddItem(4, "¿Seguro te preguntarás por qué esta sala está rodeada de tumbas cierto...? Oh quisas que demonios hace un Renegado lustrando como un miembro más de la Cruzada Escarlata en este lugar.", 0, 10)
    player:GossipMenuAddItem(4, "La verdad me gustaría contarte sobre ello, pero sería una larga y muy larga historia, así que mejor dejémoslo para otro día.", 0, 11)
    player:GossipMenuAddItem(7, "La verdad, si me he sorprendido, nunca creí que llegaría a ver a un Renegado eligiendo el camino de la luz... ¿Me han enviado a hablar contigo para regresar a Ventormenta, Podrías decirme como puedo regresar?", 0, 1)
    player:GossipSendMenu(1, unit)
  else
    player:SendBroadcastMessage("Eres débil, te falta limonada para interactuar conmigo, regresa cuando tengas nivel 40 o 60")
    player:PlayDistanceSound(20432)
    player:GossipComplete()
  end
end

--Selección para chismes de NPC
function OnSelect(event, player, unit, sender, intid, code)
  if intid == 1 then
    player:PlayDistanceSound(20433)
    player:GossipMenuAddItem(4, "Me has pillado con suerte, resulta ser que también me dirigía a Ventormenta en este momento, puedes tomar este portal para llegar más rápido.", 0, 2)
    player:GossipMenuAddItem(7, "Vale… muchas gracias", 0, 3)
    player:GossipSendMenu(2, unit)
  end
end


function OnHardCore(event, player, unit, sender, intid, code)
  if intid == 3 then
    unit:SendUnitSay("Mejor continuo con mi trabajo, aún me queda mucho por hacer",0, unit)
  else
    player:GossipComplete()
  end
end

RegisterCreatureGossipEvent(hcNPC, 1 , OnFirstTalk)
RegisterCreatureGossipEvent(hcNPC, 2, OnSelect)
RegisterCreatureGossipEvent(hcNPC, 2, OnHardCore)
RegisterPlayerEvent(8, PlayerDeath)