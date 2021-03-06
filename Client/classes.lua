local open = false
local menus = {}

Citizen.CreateThread(function()
    TriggerEvent("koth:_getWeapons")
    SetEveryoneIgnorePlayer(GetPlayerPed(-1), true) -- Police ignore player
    
    while true do
        Wait(0)

        -- Show class menu help text and trigger
        for k,v in pairs(menus) do
            local team = v
            local x = team.x + .0 or nil
            local y = team.y + .0 or nil
            local z = team.z + .0 or GetHeightmapBottomZForPosition(x, y) + 3 or nil

            if x ~= nil or y ~= nil or z ~= nil then
                if near(GetPlayerPed(-1), x, y, z) then
                    DisplayHelpText(Config.Lang.classes.helpMessage)

                    if IsControlJustPressed(1, keys[Config.Classes.openKey]) and not open then
                        TriggerEvent("koth:_getWeapons")
                        TriggerServerEvent("koth:renderClass", team.menu)
                        open = true
                    else
                        if IsControlJustPressed(1, keys[Config.Classes.closeKey]) then
                            FreezeEntityPosition(PlayerPedId(), false)
                        end
                    end
                else
                    open = false
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

    table.insert(menus, arr)
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
                table.insert(arr, weaponHash[k])
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