-- Tiger Boxing Bot - Triggerbot
-- Solo funciona en ronda (arma o cuchillo)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

print("Loaded! | Tiger Boxing Triggerbot")

-- Verifica si tienes arma o cuchillo equipado
local function hasWeapon()
    local character = LocalPlayer.Character
    if not character then return false end
    return character:FindFirstChildOfClass("Tool") ~= nil
end

while true do
    task.wait(0.01)

    -- Solo activa si tienes arma o cuchillo (estás en ronda)
    if not hasWeapon() then
        continue
    end

    local target = Mouse.Target
    if target then
        local character = target.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if not humanoid and character.Parent then
            humanoid = character.Parent:FindFirstChildOfClass("Humanoid")
            character = character.Parent
        end

        if humanoid and humanoid.Health > 0 and character ~= LocalPlayer.Character then
            mouse1click()
        end
    end
end
