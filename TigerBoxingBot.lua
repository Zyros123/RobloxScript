-- Tiger Boxing Bot - Auto Find & Attack
-- Creado para carga directa sin menú

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CheckTarget()
    -- Busca al jugador más cercano en el mapa
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                -- Busca el objeto Humanoid del enemigo para saber si está vivo
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local distance = (character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestPlayer = player
                    end
                end
            end
        end
    end
    
    -- Si encontró un enemigo y está cerca (menos de 50 studs)
    if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("Humanoid") then
        local targetHumanoid = nearestPlayer.Character:FindFirstChild("Humanoid")
        if targetHumanoid.Health > 0 and nearestDistance < 50 then
            return nearestPlayer
        end
    end
    
    return nil
end

local function AutoAttack(target)
    if target and target.Character then
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local targetHumanoid = target.Character:FindFirstChild("Humanoid")
        
        if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
            -- Lógica simple de "apuntar" (apunta el cursor hacia el enemigo)
            local camera = workspace.CurrentCamera
            local position = targetRoot.Position + Vector3.new(0, 1, 0) -- +1 arriba para apuntar a la cabeza
            
            -- Mueve el cursor automáticamente (funciona mejor si tienes un mouse virtual o auto-clicker)
            local playersService = game:GetService("Players")
            playersService.LocalPlayer:GetMouse().TargetFilter = targetRoot
            
            print("Apuntando a: " .. target.Name)
        end
    end
end

-- Bucle principal
while true do
    wait(0.1)
    local target = CheckTarget()
    if target then
        AutoAttack(target)
    end
end
