local open = false
local menus = {}


Citizen.CreateThread(function()
    TriggerEvent("koth:_getWeapons")
    SetEveryoneIgnorePlayer(GetPlayerPed(-1), true) -- Police ignore player
    FreezeEntityPosition(PlayerPedId(), false) -- Unfreeze if player was ever in menu (error preventing)
    
    -- ! Menu opener ! --
    while true do
        Wait(0)

        for k,v in pairs(menus) do
            local team = v
            local menuInfo = v.open
            local x = team.x + .0 or nil
            local y = team.y + .0 or nil
            local z = team.z + .0 or GetHeightmapBottomZForPosition(x, y) + 2 or nil

            if x ~= nil or y ~= nil or z ~= nil then
                if near(GetPlayerPed(-1), x, y, z) then
                    -- DisplayHelpText(menuInfo.helpMessage)
                    --print('asd')
                    -- if IsControlJustPressed(0, 38) then
                    --     if(menuInfo.ClientTrigger) then TriggerEvent(menuInfo.ClientTrigger) end
                    --     if menuInfo.teamLimit then limit = menuInfo.team  else limit = nil end
                    --     TriggerServerEvent(menuInfo.serverTrigger, limit)
                    --     if(menuInfo.freezePlayer) then FreezeEntityPosition(PlayerPedId(), true) end

                    --     open = true
                    -- elseif IsControlJustPressed(1, keys[menuInfo.keys.close]) then
                    --     if(menuInfo.freezePlayer) then FreezeEntityPosition(PlayerPedId(), false) end
                    --     open = false
                    --     DisplayHelpText(menuInfo.helpMessage)
                    -- end
                    --DisplayHelpText(menuInfo.helpMessage)
                    lib.showTextUI(menuInfo.helpMessage, {
                        position = "right-center",
                        style = {
                            borderRadius = 0,
                            backgroundColor = '#48BB78',
                            color = 'white'
                        }
                    })
                    if IsControlJustPressed(0, 38) then
                        --print('asdasdasdasdasd')
                        if(menuInfo.ClientTrigger) then TriggerEvent(menuInfo.ClientTrigger) end
                        print('1')
                        if menuInfo.teamLimit then limit = menuInfo.team  else limit = nil end
                        print('2')
                        TriggerServerEvent(menuInfo.serverTrigger, limit)
                        print('3')
                        lib.hideTextUI()
                        --if(menuInfo.freezePlayer) then FreezeEntityPosition(PlayerPedId(), false) end
                        --print('4')
                    end
                else
                    lib.hideTextUI()
                end
            end
        end
    end
end)

AddEventHandler("koth:ToggleWeapon", function(type, ammo, equip)
    local hash = GetHashKey(type)
    local ped = GetPlayerPed(GetPlayerFromServerId(source))

    if hash == nil then return false end
    
    if HasPedGotWeapon(ped, hash, false) then
        RemoveWeaponFromPed(ped, hash)
    else
        local remainingAmmo = GetAmmoInPedWeapon(ped, hash)

        if ammo == nil then
            ammo = 200 - tonumber(remainingAmmo)
        else
            ammo = ammo - tonumber(remainingAmmo)
        end

        GiveWeaponToPed(ped, hash, ammo or 200, false, equip or true)
    end
end)

AddEventHandler("koth:addAmmo", function(type, amount)
    local ped = GetPlayerPed(GetPlayerFromServerId(source))
    local remainingAmmo = GetAmmoInPedWeapon(ped, GetHashKey(type))
    amount = amount + remainingAmmo

    SetPedAmmo(ped, GetHashKey(type), amount)
end)

AddEventHandler("koth:spawnPed", function(ped, arr)
    local x = arr.x + .0 or nil
    local y = arr.y + .0 or nil
    local z = arr.z + .0 or GetHeightmapBottomZForPosition(x, y) + 3 or nil
    local r = arr.rotation or 30

    RequestModel(GetHashKey(ped))

    while not HasModelLoaded(GetHashKey(ped)) do
        Citizen.Wait(1)
    end

    local ped = CreatePed(4, GetHashKey(ped), x, y, z, r, true, true)

    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    -- exports.ox_target:addLocalEntity(ped, {
    --     {
    --         name = 'asdas',
    --         icon = 'fa-solid fa-hand-holding-medical',
    --         label = locale('revive_label'),
    --         distance = 1.5,
    --         onSelect = function(data)
    --             local ReviveChance = math.random(1, 100)
    --             TriggerServerEvent('lss-ambulance:server:PlayerAnimation',
    --                 GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)), GetEntityHeading(cache.ped),
    --                 GetEntityCoords(cache.ped), GetEntityForwardVector(cache.ped), ReviveChance)
    --             TriggerEvent('lss-ambulance:client:AmbulanceAnimation', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)),
    --                 ReviveChance)
    --         end
    --     },
    -- })
    if(arr.open ~= nil) then
        table.insert(menus, arr)
    end

    -- koth:renderClass
    -- koth:renderVehicles
print(json.encode(arr))

    -- function BasicStuffs()
    --     local NPC = { x = -31.243, y = -1097.88, z = 26.274, rotation = 63.79243, NetworkSync = true}
    --     function createNPC()
    --     created_ped = CreatePed(0, modelHash , NPC.x,NPC.y,NPC.z, NPC.rotation, true)
    --     FreezeEntityPosition(created_ped, true)
    --     SetEntityInvincible(created_ped, true)
    --     SetBlockingOfNonTemporaryEvents(created_ped, true)
    --     TaskStartScenarioInPlace(created_ped, "WORLD_HUMAN_GUARD_STAND_CASINO", 0, true)
    --     end
      
    --     Citizen.CreateThread(function()
    --       modelHash = GetHashKey("u_m_m_bankman")
    --       RequestModel(modelHash)
    --       while not HasModelLoaded(modelHash) do
    --            Wait(1)
    --       end
    --       createNPC() 
    --     end)
      
    --     exports.ox_target:addBoxZone({
    --       coords = vec3(NPC.x,NPC.y,NPC.z + 1),
    --       size = vec3(1, 1, 2),
    --       rotation = NPC.rotation,
    --       debug = false,
    --       options = {
    --         {
    --             name = 'carshop',
    --             icon = 'fas fa-car',
    --             label = 'Oepn classes',
    --             onSelect = function()
    --                 TriggerEvent('np-showrooms:enterExperience')
    --             end,
    --             distance = 1.9,
    --         },
    --         }
    --     })
    --   end
end)

AddEventHandler("koth:inMenu", function()
    FreezeEntityPosition(PlayerPedId(), true)
end)

AddEventHandler("koth:_getWeapons", function()
    local arr = {}
    local ped = GetPlayerPed(GetPlayerFromServerId(source))

    for k,v in ipairs(weaponHash) do
        local hash = GetHashKey(v)

        if hash ~= nil then
            local doesIt = GetWeaponClipSize(hash)
            if doesIt ~= 0 and HasPedGotWeapon(ped, hash, false) then
                table.insert(arr, {
                    weapon = weaponHash[k],
                    ammo = GetAmmoInPedWeapon(ped, hash)
                })
            end
        end
    end

    TriggerServerEvent("koth:_activeWeapons", arr)
end)

AddEventHandler("koth:removeWeapons", function()
    local ped = GetPlayerPed(GetPlayerFromServerId(source))
    
    for k,v in ipairs(weaponHash) do
        local hash = GetHashKey(v)

        if hash ~= nil then
            local doesIt = GetWeaponClipSize(hash)
            if doesIt ~= 0 and HasPedGotWeapon(ped, hash, false) then
                RemoveWeaponFromPed(ped, hash)
            end
        end
    end
end)