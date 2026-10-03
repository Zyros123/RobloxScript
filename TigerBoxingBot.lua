-- Tiger Boxing Bot - Preciso sin hitbox extra

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

print("Loaded! | Tiger Boxing Triggerbot")

local lastFire = 0

while true do
    task.wait(0.06)

    local char = LocalPlayer.Character
    if char and tick() - lastFire > 0.1 then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            local target = Mouse.Target
            if target then
                local model = target.Parent
                local hum = model and model:FindFirstChildOfClass("Humanoid")

                if not hum and model and model.Parent then
                    hum = model.Parent:FindFirstChildOfClass("Humanoid")
                    model = model.Parent
                end

                if hum and hum.Health > 0 and model ~= char then
                    lastFire = tick()
                    pcall(mouse1click)
                end
            end
        end
    end
end

