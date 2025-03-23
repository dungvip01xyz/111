local Dressrosa = workspace:WaitForChild("Map"):WaitForChild("Dressrosa")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

if not PlayerGui then
    warn("❌ Không tìm thấy PlayerGui!")
    return
end

local Trade = PlayerGui:FindFirstChild("Main") and PlayerGui.Main:FindFirstChild("Trade")
if not Trade then
    warn("❌ Không tìm thấy giao diện Trade!")
    return
end

-- Tạo tween dịch chuyển nhân vật
local function Tween2(targetCFrame)
    local character = LocalPlayer.Character
    if not character then return end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end

    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(math.min(distance / 350, 1), Enum.EasingStyle.Linear)
    local tween = TweenService:Create(rootPart, tweenInfo, { CFrame = targetCFrame })

    tween:Play()
    if _G.CancelTween2 then tween:Cancel() end

    _G.Clip2 = true
    wait(distance / 350)
    _G.Clip2 = false
end

-- Kiểm tra trái bị thiếu trong trade
local function checkMissingFruits(fruitList)
    local tradeContainer = Trade.Container["1"].Frame
    local requiredFruits, actualFruits, missingFruits = {}, {}, {}

    for _, fruit in ipairs(fruitList) do
        requiredFruits[fruit] = (requiredFruits[fruit] or 0) + 1
    end
    for _, item in pairs(tradeContainer:GetChildren()) do
        actualFruits[item.Name] = (actualFruits[item.Name] or 0) + 1
    end
    for fruit, count in pairs(requiredFruits) do
        if (actualFruits[fruit] or 0) < count then
            table.insert(missingFruits, fruit)
        end
    end

    if #missingFruits > 0 then
        print("Thiếu các trái sau:", table.concat(missingFruits, ", "))
        return true
    end
    print("Đủ tất cả các trái trong danh sách!")
    return false
end

-- Thêm trái vào trade
local function FruitAdd(fruitName)
    ReplicatedStorage.Remotes.TradeFunction:InvokeServer("addItem", fruitName)
end

-- Kiểm tra xem trái có tồn tại không
local function FruitCheck(fruitName)
    local fruit = Trade.Container["2"].Frame:FindFirstChild(fruitName)
    if fruit then
        print("✅ Fruit tồn tại:", fruit.Name)
        ReplicatedStorage.Remotes.TradeFunction:InvokeServer("accept")
        wait(15)
    else
        warn("❌ Không tìm thấy Fruit!")
    end
end

-- Tìm người chơi theo DisplayName
local function GetPlayerByName(targetName)
    for _, player in pairs(Players:GetPlayers()) do
        if player.DisplayName == targetName then
            print("✅ Tìm thấy người chơi:", player.Name)
            return player
        end
    end
    print("❌ Không tìm thấy người chơi có DisplayName:", targetName)
    return nil
end

-- Kiểm tra trạng thái Ready
local function CheckReady(playerName)
    local character = workspace.Characters:FindFirstChild(playerName)
    if not character then
        warn("❌ Không tìm thấy nhân vật của người chơi:", playerName)
        return
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        warn("❌ Không tìm thấy HumanoidRootPart!")
        return
    end

    local lastPosition = rootPart.Position
    local Ready2 = Trade.Info:FindFirstChild("Ready2")
    local startTime, warned = tick(), false

    while Ready2 and Ready2:IsA("TextLabel") do
        wait(0.5)
        if not workspace.Characters:FindFirstChild(playerName) then
            warn("❌ Người chơi đã rời khỏi game!")
            break
        end

        local elapsed = tick() - startTime
        if elapsed >= 75 and not warned then
            print("⏳ Còn 15 giây trước khi hết thời gian!")
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("No accept Jump jump in 15 seconds", "All")
            warned = true
        end
        if elapsed >= 90 then
            warn("⏳ Đã hết 90 giây! Dừng kiểm tra.")
            break
        end

        local currentPosition = rootPart.Position
        if (currentPosition - lastPosition).Magnitude > 0 or Ready2.Text == "Ready!" then
            print("✅ Người chơi sẵn sàng hoặc đang di chuyển! Dừng kiểm tra.")
            break
        end

        lastPosition = currentPosition
    end
end

-- Hàm chính
local function Main()
    local fruitList = getgenv().fruitList
    local checkFruitList = getgenv().checkFruitList
    local player2Label = Trade.Container["2"]:FindFirstChild("TextLabel")
    if not player2Label then
        warn("❌ Không tìm thấy TextLabel của người chơi 2!")
        return
    end

    for _, fruit in ipairs(fruitList) do
        FruitAdd(fruit)
    end

    local missing = checkMissingFruits(fruitList)
    if missing then return end

    local foundPlayer = GetPlayerByName(player2Label.Text)
    if foundPlayer then CheckReady(foundPlayer.Name) end

    for _, fruit in ipairs(checkFruitList) do
        FruitCheck(fruit)
    end
end

-- Quét và xử lý TradeTable
while true do
    for _, obj in pairs(Dressrosa:GetChildren()) do
        if obj:IsA("Model") and obj.Name == "TradeTable" then
            local P1, P2 = obj.P1 and obj.P1.CFrame, obj.P2 and obj.P2.CFrame
            local SeatWeldP1 = obj.P1 and obj.P1:FindFirstChild("SeatWeld")
            local SeatWeldP2 = obj.P2 and obj.P2:FindFirstChild("SeatWeld")

            if SeatWeldP1 then
                Tween2(P2)
                wait(2)
                Main()
            elseif SeatWeldP2 then
                Tween2(P1)
                wait(2)
                Main()
            else
                print("❌ Cả hai ghế đều không có SeatWeld!")
            end
        end
    end
    wait(1)
end
