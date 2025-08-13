# Cards
Collect cards to trade with your friends

# Edit ox_inventory/modules/utils/client.lua for add targeting function
```
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
		
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		
		local next = true
		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next
		
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

CreateThread(function()
    while true do
		local time = 2000
		if isSelectingActive then
			local plyPos = GetEntityCoords(cache.ped)
			local xClosestDistance = 5.0
			local yClosestDistance = 5.0

			for currentPed in EnumeratePeds() do
				if IsPedAPlayer(currentPed)  then
					local currentPedCoords = GetPedBoneCoords(currentPed, 24818, 0.0, 0.0, 0.0)

					local distance = #(currentPedCoords - plyPos)

					if distance <= 10.0 then
						local _, screenX, screenY = GetScreenCoordFromWorldCoord(currentPedCoords.x, currentPedCoords.y, currentPedCoords.z)

						if screenX > 0 and screenY > 0 then
							local mouseX, mouseY = GetNuiCursorPosition()

							local screenWidth, screenHeight = GetActiveScreenResolution()

							if mouseX <= screenWidth and mouseY <= screenHeight then
								mouseX = mouseX/screenWidth
								mouseY = mouseY/screenHeight

								local xScreenDistance = math.abs(mouseX-screenX)
								local yScreenDistance = math.abs(mouseY-screenY)

								if xScreenDistance < 0.03 and yScreenDistance < 0.1 then
									if xClosestDistance > xScreenDistance and yClosestDistance > yScreenDistance then
										xClosestDistance = xScreenDistance
										yClosestDistance = yScreenDistance
										closestPed = currentPed
									end
								else
									if currentPed == closestPed then
										closestPed = nil
									end
								end
							end
						end
					end
				end
			end
			time = 100
		end
		Wait(time)
	end
end)

local lastPlayer = nil
function Utils.SelectedPlayer()
   return lastPlayer
end

function Utils.PlayerSearch()
    lastPlayer = nil
    SetNuiFocus(false, true)
	isSelectingActive = true

	CreateThread(function()
		while true do
			local timer = 300
			if isSelectingActive then
				timer = 5
				if closestPed then
					local pedCoords = GetPedBoneCoords(closestPed, 24817, 0.0, 0.0, 0.0)
					DrawMarker(20, pedCoords.x, pedCoords.y, pedCoords.z+1.8 - 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.2, 0.2, 0.2, 18, 230, 166, 150, false, true, 2, false, false, false, false)
				end
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 263, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 143, true)
				DisableControlAction(0, 200, true)
	            DisablePlayerFiring(cache.ped, true)
				LocalPlayer.state.invHotkeys = false

				if(IsDisabledControlJustReleased(0, 24)) then
					DisablePlayerFiring(cache.ped, true)
					local targetPlayer = NetworkGetPlayerIndexFromPed(closestPed)
					local targetId = GetPlayerServerId(targetPlayer)

					isSelectingActive = false

					SetNuiFocus(false, false)
					lastPlayer = targetId
					break
				end
				if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
					isSelectingActive = false
					SetNuiFocus(false, false)
					lastPlayer = 'nil'
					LocalPlayer.state.invHotkeys = true
					break
				end
			end
			Wait(timer)
		end
	end)
end

exports("SelectedPlayer", Utils.SelectedPlayer)
exports("PlayerSearch", Utils.PlayerSearch)
```

# Add Item to ox_inventory/data/items.lua
```
['micard_legendary'] = {
		label = 'Legendary Card',
		weight = 0,
		stack = false,
		close = true,
		description = 'Wow!! Hai una carta leggendaria!!',
		buttons = {
            {
                label = "Mostra",
                action = function(slot)
                    TriggerEvent('bg_cardsclient:showCardsToTarget', slot)
                end
            }
        },
	},
	['micard_rare'] = {
		label = 'Rare Card',
		weight = 0,
		stack = false,
		close = true,
		description = 'Wow!! Hai una carta rara!!',
		buttons = {
            {
                label = "Mostra",
                action = function(slot)
                    TriggerEvent('bg_cardsclient:showCardsToTarget', slot)
                end
            }
        },
	},
	['micard_basic'] = {
		label = 'Basic Card',
		weight = 0,
		stack = false,
		close = true,
		description = 'Phewww, solo una carta comune',
		buttons = {
            {
                label = "Mostra",
                action = function(slot)
                    TriggerEvent('bg_cardsclient:showCardsToTarget', slot)
                end
            }
        },
	},
	['micard_booster_pack1'] = {
		label = 'Booster Pack',
		weight = 0,
		stack = true,
		close = true,
		description = 'Contains 5 cards',
	},
	['micard_booster_pack2'] = {
		label = 'Booster Pack',
		weight = 0,
		stack = true,
		close = true,
		description = 'Contains 10 cards',
	},
```
