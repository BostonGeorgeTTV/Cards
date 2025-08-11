-- Use Booster Pack
ESX.RegisterUsableItem("micard_booster_pack1", function(source, item)
    exports.ox_inventory:RemoveItem(source, item.name, 1)
    TriggerClientEvent("mi-card:client:OpenBoosterPack1", source, item.name)
end)

ESX.RegisterUsableItem("micard_booster_pack2", function(source, item)
    exports.ox_inventory:RemoveItem(source, item.name, 1)
    TriggerClientEvent("mi-card:client:OpenBoosterPack2", source, item.name)
end)
-- Use Card
for _, name in ipairs({"micard_legendary", "micard_rare", "micard_basic"}) do
    ESX.RegisterUsableItem(name, function(source, item)
        local data = exports.ox_inventory:Search(source, 1, item)
        for k, v in pairs(data) do
            data = v
            break
        end
        TriggerClientEvent("mi-card:client:showCard", source, data)
    end)
end

RegisterNetEvent("inv_addItem")
AddEventHandler("inv_addItem", function(itemName, qnt, card)
	exports.ox_inventory:AddItem(source, itemName, qnt, card)
end)

-- mostra carte
RegisterNetEvent("mi-card:server:showCardToTarget")
AddEventHandler("mi-card:server:showCardToTarget", function(slot, cTarget)
    local data = exports.ox_inventory:GetSlot(source, slot)
    TriggerClientEvent("mi-card:client:showCard", source, data)
end)