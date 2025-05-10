-- Dav Aimbot com GUI para controle de ESP e Aimbot | Feito por ChatGPT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP_ENABLED = true
local AIMBOT_ENABLED = true
local AIM_KEY = Enum.KeyCode.E

-- Criar GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DavAimbotGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 200, 0, 50)
espButton.Position = UDim2.new(0, 10, 0, 10)
espButton.Text = "Toggle ESP"
espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
espButton.Parent = screenGui

local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0, 200, 0, 50)
aimbotButton.Position = UDim2.new(0, 10, 0, 70)
aimbotButton.Text = "Toggle Aimbot"
aimbotButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
aimbotButton.Parent = screenGui

-- Função para criar ESP
function createESP(player)
    if player.Character and not player.Character:FindFirstChild("DavESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "DavESP"
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(1)
            createESP(player)
        end)
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        createESP(player)
    end)
end)

-- Função Aimbot
function getClosestToMouse()
    local closest = nil
    local shortest = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AIMBOT_ENABLED and UserInputService:IsKeyDown(AIM_KEY) then
        local target = getClosestToMouse()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)

-- Funções de Toggle para a GUI
espButton.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
