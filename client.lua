-- 체력 및 방탄복 표시를 위한 변수
local showHealthArmor = false

RegisterNetEvent("vRP:ToggleHealthArmorMenu")
AddEventHandler("vRP:ToggleHealthArmorMenu", function()
    showHealthArmor = not showHealthArmor
    if showHealthArmor then
        TriggerEvent("chatMessage", "", {255, 0, 0}, "체력 및 방탄복 표시가 활성화되었습니다.")
    else
        TriggerEvent("chatMessage", "", {255, 0, 0}, "체력 및 방탄복 표시가 비활성화되었습니다.")
    end
end)

-- 체력 및 방탄복 표시 함수
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showHealthArmor then
            local players = GetActivePlayers()
            local myPlayerId = PlayerId()
            for _, playerId in ipairs(players) do
                if playerId ~= myPlayerId then  -- 자신의 캐릭터를 제외
                    local ped = GetPlayerPed(playerId)
                    local playerCoords = GetEntityCoords(ped)
                    local distance = #(GetEntityCoords(PlayerPedId()) - playerCoords)

                    if distance < 20.0 and NetworkIsPlayerActive(playerId) then
                        local health = (GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100
                        local armor = GetPedArmour(ped)
                        local name = GetPlayerName(playerId)

                        -- 닉네임 표시
                        DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 1.5, name)
                        -- 체력 및 방탄복 바 표시
                        DrawHealthArmorBars(playerCoords.x, playerCoords.y, playerCoords.z + 1.2, health, armor)
                    end
                end
            end
        end
    end
end)

local customFont = RegisterFontId('acfont')

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local scale = 0.35
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(customFont) 
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- 체력 및 방탄복 바 그리기 함수
function DrawHealthArmorBars(x, y, z, health, armor)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local width = 0.04  -- 막대의 너비
    local height = 0.005 -- 막대의 높이
    local padding = 0.001 -- 막대 간의 간격

    if onScreen then
        -- 방탄복 바
        DrawRect(_x, _y - padding, width, height, 0, 0, 0, 200) -- 방탄복 바 배경 (검은색 배경)
        DrawRect(_x, _y - padding, width * (armor / 100), height, 0, 0, 255, 255) -- 현재 방탄복 수치 (파란색)

        -- 체력 바
        DrawRect(_x, _y - height - (padding * 2), width, height, 0, 0, 0, 200) -- 체력 바 배경 (검은색 배경)
        DrawRect(_x, _y - height - (padding * 2), width * (health / 100), height, 255, 0, 0, 255) -- 현재 체력 수치 (빨간색)
    end
end
