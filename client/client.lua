local uiloaded = false
local opened = false
local DisablePlayerFiring = DisablePlayerFiring
local HudWeaponWheelIgnoreSelection = HudWeaponWheelIgnoreSelection
local DisableControlAction = DisableControlAction
local function windowOpened()
    while opened do
        Wait(0)
		DisablePlayerFiring(cache.playerId, true)
		HudWeaponWheelIgnoreSelection()
		DisableControlAction(0, 1, true)
		DisableControlAction(0, 2, true)
		DisableControlAction(0, 140, true)
		DisableControlAction(0, 177, true)
		DisableControlAction(0, 199, true)
		DisableControlAction(0, 200, true)
		DisableControlAction(0, 202, true)
		DisableControlAction(2, 19, true)
    end
end

RegisterNUICallback('uiloaded', function(_, cb)
    uiloaded = true
    cb('ok')
end)

RegisterNUICallback('hideFrame', function(data, cb)
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    opened = false
    cb('ok')
end)


-- 2 on
-- 1 off
-- 0 disabled
RegisterNUICallback('controlClicked', function(data, cb)
    local response = 0
    local vehicle = cache.vehicle
    if vehicle then
        if data.index == 'ignition' then
            local engineOn = GetIsVehicleEngineRunning(cache.vehicle)
            SetVehicleEngineOn(cache.vehicle, not engineOn, false, true)
            response = engineOn and 1 or 2
        elseif data.index == 'hazard' then
            local lights = GetVehicleIndicatorLights(vehicle)
            SetVehicleIndicatorLights(vehicle, 0, lights ~= 3 and true or false)
            SetVehicleIndicatorLights(vehicle, 1, lights ~= 3 and true or false)
            response = lights ~= 3 and 2 or 1
        elseif data.index == 'parkbrake' then
            local handbrakeEngaged = GetVehicleHandbrake(vehicle)
            SetVehicleHandbrake(vehicle, not handbrakeEngaged)
            response = handbrakeEngaged and 1 or 2
        elseif data.index == 'fronthood' then
            local doorsOpen = GetVehicleDoorAngleRatio(cache.vehicle, 4) > 0
            response = doorsOpen and 1 or 2
            if doorsOpen then
                SetVehicleDoorShut(cache.vehicle, 4, false)
            else
                SetVehicleDoorOpen(cache.vehicle, 4, false, false)
            end
        elseif data.index == 'rearHood' then
            if GetIsDoorValid(cache.vehicle, 5) then
                local doorsOpen = GetVehicleDoorAngleRatio(cache.vehicle, 5) > 0
                response = doorsOpen and 1 or 2
                if doorsOpen then
                    SetVehicleDoorShut(cache.vehicle, 5, false)
                else
                    SetVehicleDoorOpen(cache.vehicle, 5, false, false)
                end
            else
                response = 0
            end
        elseif data.index == 'interiorLight' then
            local lightOn = IsVehicleInteriorLightOn(vehicle)
            SetVehicleInteriorlight(vehicle, not lightOn)
            response = lightOn and 1 or 2
        elseif data.index == 7 then
        elseif data.index == 'windowFrontRight' then
            if data.state > 0 then
                if data.state == 1 then RollDownWindow(vehicle, 1)
                else  RollUpWindow(vehicle, 1)
                end
                
                response = data.state == 2 and 1 or 2
            end
        elseif data.index == 'doorFrontRight' then
            if GetIsDoorValid(cache.vehicle, 1) then
                local doorsOpen = GetVehicleDoorAngleRatio(cache.vehicle, 1) > 0
                response = doorsOpen and 1 or 2
                if doorsOpen then
                    SetVehicleDoorShut(cache.vehicle, 1, false)
                else
                    SetVehicleDoorOpen(cache.vehicle, 1, false, false)
                end
            else
                response = 0
            end
        elseif data.index == 'seatFrontLeft' then
            if IsVehicleSeatFree(vehicle, -1) then
                SetPedIntoVehicle(cache.ped, vehicle, -1)
            end
        elseif data.index == 'seatFrontRight' then
            if IsVehicleSeatFree(vehicle, 0) then
                SetPedIntoVehicle(cache.ped, vehicle, 0)
            end
        elseif data.index == 'doorFrontLeft' then
            if GetIsDoorValid(cache.vehicle, 0) then
                local doorsOpen = GetVehicleDoorAngleRatio(cache.vehicle, 0) > 0
                response = doorsOpen and 1 or 2
                if doorsOpen then
                    SetVehicleDoorShut(cache.vehicle, 0, false)
                else
                    SetVehicleDoorOpen(cache.vehicle, 0, false, false)
                end
            else
                response = 0
            end
        elseif data.index == 'windowFrontLeft' then
            if data.state > 0 then
                if data.state == 1 then RollDownWindow(vehicle, 0)
                else  RollUpWindow(vehicle, 0)
                end
                
                response = data.state == 2 and 1 or 2
            end
        elseif data.index == 'windowRearRight' then
            if data.state > 0 then
                if data.state == 1 then RollDownWindow(vehicle, 3)
                else  RollUpWindow(vehicle, 3)
                end
                
                response = data.state == 2 and 1 or 2
            end
        elseif data.index == 'doorRearRight' then
            if GetIsDoorValid(cache.vehicle, 3) then
                local doorsOpen = GetVehicleDoorAngleRatio(cache.vehicle, 3) > 0
                response = doorsOpen and 1 or 2
                if doorsOpen then
                    SetVehicleDoorShut(cache.vehicle, 3, false)
                else
                    SetVehicleDoorOpen(cache.vehicle, 3, false, false)
                end
            else
                response = 0
            end
        elseif data.index == 'seatRearLeft' then
            if IsVehicleSeatFree(vehicle, 1) then
                SetPedIntoVehicle(cache.ped, vehicle, 1)
            end
        elseif data.index == 'seatRearRight' then
            if IsVehicleSeatFree(vehicle, 2) then
                SetPedIntoVehicle(cache.ped, vehicle, 2)
            end
        elseif data.index == 'doorRearLeft' then
            if GetIsDoorValid(cache.vehicle, 2) then
                local doorsOpen = GetVehicleDoorAngleRatio(cache.vehicle, 2) > 0
                response = doorsOpen and 1 or 2
                if doorsOpen then
                    SetVehicleDoorShut(cache.vehicle, 2, false)
                else
                    SetVehicleDoorOpen(cache.vehicle, 2, false, false)
                end
            else
                response = 0
            end
        elseif data.index == 'windowRearLeft' then
            if data.state > 0 then
                if data.state == 1 then RollDownWindow(vehicle, 2)
                else  RollUpWindow(vehicle, 2)
                end
                
                response = data.state == 2 and 1 or 2
            end
        end
        PlaySoundFrontend(-1, 'Toggle_Lights', 'PI_Menu_Sounds', false)
    end

    cb(response)
end)


RegisterCommand('controls', function()
    if not uiloaded or not cache.vehicle then
        return
    end


    SendNUIMessage({ action = 'visibility', data = {
        display = true
    }})
    
    SetNuiFocusKeepInput(true)
    SetNuiFocus(true, true)
    opened = true
    CreateThread(windowOpened)
end)


lib.onCache('vehicle', function(value)
    if value then
        SendNUIMessage({ action = 'restart'})
        return
    end

    if opened then
        SendNUIMessage({ action = 'visibility', data = {
            display = false
        }})
    end
end)