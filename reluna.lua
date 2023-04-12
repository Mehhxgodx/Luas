-- Name: 	Reload Scripts
-- Details:	Reloads lua scripts for faster development.
-- Usage:	Type "reload scripts" in the mangosd console or in-game.		
-- Website: https://github.com/RStijn

-- Functions
function reloadElunaEngine(event, player, command)
  if command == "reluna" or command == "reloadscripts" then 
	if player == nil or player:IsGM() then -- console or gm
		ReloadEluna()
	else
		player:SendBroadcastMessage("Activa GM para usar el comando")
	end
  end
end

RegisterPlayerEvent(42, reloadElunaEngine)