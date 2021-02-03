-- Each team will have this
_TeamBase = {
      Players = {
            length = 0,
            add = function(self, team, playerID)
                  if type(self) ~= "table" then return false end
                  table.insert(self, playerID)
                  self.length = self.length + 1
                  TriggerClientEvent("koth:notification", playerID, "You ~g~joined ~s~team " .. team)
            end,
            remove = function(self, team, playerID)
                  if type(self) ~= "table" or self[playerID] ~= nil then return false end
                  local index = tablefind(self, playerID)
                  
                  TriggerClientEvent("koth:notification", playerID, "You ~r~left ~s~team " .. team)

                  if index == nil then return false end
                  table.remove(self, index)
                  self.length = self.length - 1
            end
      },
      Points = 0
}

-- place the _TeamBase to each team
for i, team in pairs(Config.Teams) do
      for j, e in pairs(_TeamBase) do
            if type(_TeamBase[j]) == "table" then
                  Config.Teams[i][j] = {}
                  for k, l in pairs(_TeamBase[j]) do 
                        if type(_TeamBase[j][k]) == "nil" then return end
                        Config.Teams[i][j][k] = l
                  end
            else
                  if Config.Teams[i][j] ~= nil then return end
                  Config.Teams[i][j] = e
            end
      end
end

RegisterCommand("team", function(source, args, raw)
      if(type(Config.Teams[args[1]]) == "nil") then return false end
      local player = KOTH.Cache.Players[tostring(source)]
      
      if(type(player.Team) ~= "nil") then Config.Teams[player.Team].Players:remove(player.Team, source) end

      KOTH.Cache.Players[tostring(source)].Team = args[1]

      Config.Teams[args[1]].Players:add(args[1], source)
end, false)