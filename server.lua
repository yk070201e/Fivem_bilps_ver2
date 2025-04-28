local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP")

local playerHealthArmorStatus = {}

RegisterCommand("togglearmor", function(source, args, rawCommand)
    local user_id = vRP.getUserId({source})
    if user_id and vRP.hasPermission({user_id, "admin.basic"}) then
        -- 상태 변경
        playerHealthArmorStatus[user_id] = not (playerHealthArmorStatus[user_id] or false)
        TriggerClientEvent("vRP:ToggleHealthArmorMenu", source, playerHealthArmorStatus[user_id])
        vRPclient.notify(source, {playerHealthArmorStatus[user_id] and "체력 및 방탄복 표시가 활성화되었습니다." or "체력 및 방탄복 표시가 비활성화되었습니다."})
    else
        vRPclient.notify(source, {"~r~권한이 없습니다."})
    end
end)

AddEventHandler("playerConnecting", function()
    local user_id = vRP.getUserId({source})
    if user_id and playerHealthArmorStatus[user_id] ~= nil then
        TriggerClientEvent("vRP:ToggleHealthArmorMenu", source, playerHealthArmorStatus[user_id])
    end
end)
