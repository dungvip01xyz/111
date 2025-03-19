wait(5)
local args = {
    [1] = "SetTeam",
    [2] = "Pirates"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
_G.AutoCollectChest = true -- Mặc định  true

-- Hàm di chuyển đến rương
function TweenTo(targetPosition)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local distance = (targetPosition - humanoidRootPart.Position).Magnitude
        local speed = 350
        local time = distance / speed
        
        local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
        local tween = game:GetService("TweenService"):Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
        
        tween:Play()
        wait(time)
    end
end

-- Tự động nhặt rương
spawn(function()
    while wait(1) do
        if _G.AutoCollectChest then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then return end
            
            local collectionService = game:GetService("CollectionService")
            local chests = collectionService:GetTagged("_ChestTagged")
            local closestChest = nil
            local closestDistance = math.huge
            for _, chest in pairs(chests) do
                if not chest:GetAttribute("IsDisabled") then
                    local chestPosition = chest:GetPivot().Position
                    local distance = (chestPosition - humanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestChest = chest
                    end
                end
            end

            if closestChest then
                TweenTo(closestChest:GetPivot().Position)
            end
        end
    end
end)
ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoCollectChest = not _G.AutoCollectChest
    if _G.AutoCollectChest then
        ToggleButton.Text = "Tắt Auto Nhặt Rương"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ khi bật
    else
        ToggleButton.Text = "Bật Auto Nhặt Rương"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Màu xanh khi tắt
    end
end)
