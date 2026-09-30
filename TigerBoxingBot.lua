-- Tiger Boxing Bot - Triggerbot / Autoshoot
-- Cuando apuntas a un enemigo, dispara automáticamente

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

print("Loaded! | Tiger Boxing Triggerbot")

while true do
    task.wait(0.01)

    local target = Mouse.Target
    if target then
        local character = target.Parent
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        -- A veces el Humanoid está un nivel más arriba
        if not humanoid and character.Parent then
            humanoid = character.Parent:FindFirstChildOfClass("Humanoid")
            character = character.Parent
        end

        if humanoid and humanoid.Health > 0 and character ~= LocalPlayer.Character then
            -- Dispara automáticamente
            mouse1click()
        end
    end
end
