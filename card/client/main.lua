local randomCards = {}

RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false, false)
    EnableGUI("ON_CLOSE", false, "cards")
    cb('ok')
end)


RegisterNUICallback('openInventory', function(data, cb)
    SetNuiFocus(false, false)
    EnableGUI("ON_CLOSE", false, "cards")
    exports.ox_inventory:openInventory('player')
    cb('ok')
end)

RegisterNUICallback('openAnother', function(data, cb)
    TriggerEvent("mi-card:client:randomCards", data.remain)
    cb('ok')
end)

function EnableGUI(type, enable, menu)
    enabled = enable
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        type = type,
        enable = enable,
        menu = menu,
        cards = randomCards,
        isService = isService,
    })
end

function generateRandomCards(n)
    randomCards = {}
    for i=1, n do
        randomCards[i] = Config.Cards[math.random(#Config.Cards)]
        color = Config.CardColors[randomCards[i].color]
        randomCards[i].colors = color
        randomCards[i].isFliped = false
    end
end

-- Create NPC Seller
RegisterNetEvent("mi-card:client:randomCards", function(n)
    if n > 5 then
        generateRandomCards(5)
        SendNUIMessage({ type = "ON_ADD_CARDS", cards = randomCards, remain = n - 5 })
    else
        generateRandomCards(n)
        SendNUIMessage({ type = "ON_ADD_CARDS", cards = randomCards, remain = 0 })
    end

    for _, card in pairs(randomCards) do
        if card.rank == "legendary" then
            TriggerServerEvent("inv_addItem", "micard_legendary", 1, card)
        elseif card.rank == "rare" then
            TriggerServerEvent("inv_addItem", "micard_rare", 1, card)
        else
            TriggerServerEvent("inv_addItem", "micard_basic", 1, card)
        end
    end
end)

RegisterNetEvent("mi-card:client:showCard")
AddEventHandler("mi-card:client:showCard", function(data)
    local card = data.metadata or {}
    
    card.isFliped = true
    SetNuiFocus(true, true)
    EnableGUI("ON_OPEN", true, "cards-container")
    SendNUIMessage({
        type = "ON_SHOW_CARD",
        card = card,
    })
end)

-- Open Booster Pack
RegisterNetEvent("mi-card:client:OpenBoosterPack1")
AddEventHandler("mi-card:client:OpenBoosterPack1", function(itemName)
    if lib.progressBar({
        duration = Config.OpeningTime,
        label = 'Spacchetta . . .',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, combat = true },
        anim = {
            dict = 'missheist_agency3aig_23',
            clip = 'urinal_sink_loop'
        },
    }) then
        TriggerServerEvent("ox_inventory:removeItem", "micard_booster_pack1", 1)
        ExecuteCommand("e c")
        SetNuiFocus(true, true)
        EnableGUI("ON_OPEN", true, "cards-container")
        TriggerEvent("mi-card:client:randomCards", 5)
    end
end)

RegisterNetEvent("mi-card:client:OpenBoosterPack2")
AddEventHandler("mi-card:client:OpenBoosterPack2", function(itemName)
    if lib.progressBar({
        duration = Config.OpeningTime,
        label = 'Spacchetta . . .',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, combat = true },
        anim = {
            dict = 'missheist_agency3aig_23',
            clip = 'urinal_sink_loop'
        },
    }) then
        TriggerServerEvent("ox_inventory:removeItem", "micard_booster_pack2", 1)
        ExecuteCommand("e c")
        SetNuiFocus(true, true)
        EnableGUI("ON_OPEN", true, "cards-container")
        TriggerEvent("mi-card:client:randomCards", 10)
    end
end)

-- mostra cards
RegisterNetEvent("mi-card:client:showCardsToTarget")
AddEventHandler("mi-card:client:showCardsToTarget", function(slot)
    exports.ox_inventory:closeInventory()
	Wait(500)
	local cTarget = exports.ox_inventory.PlayerSearch()
	CreateThread(function()
		while true do
			if exports.ox_inventory.SelectedPlayer() == nil then
				Wait(500)
			else
				cTarget = exports.ox_inventory.SelectedPlayer()
				if cTarget == 'nil' or cTarget == 0 then
					LocalPlayer.state.invHotkeys = true
					break
				end
				cTarget = GetPlayerPed(GetPlayerFromServerId(cTarget))
				if cTarget and IsPedAPlayer(cTarget) and #(GetEntityCoords(cache.ped, true) - GetEntityCoords(cTarget, true)) <= 4.0 then
					cTarget = GetPlayerServerId(NetworkGetPlayerIndexFromPed(cTarget))
                    
                    lib.requestAnimDict("mp_common")
					TaskPlayAnim(cache.ped, 'mp_common', 'givetake1_a', 1.0, 1.0, 2000, 50, 0.0, 0, 0, 0)
                    Wait(2000)
                    TriggerServerEvent("mi-card:server:showCardToTarget", slot, cTarget)
					LocalPlayer.state.invHotkeys = true
					break
				else
					break
				end
				Wait(2000)
			end
			Wait(5)
		end
	end)
end)