local Dressrosa = workspace:WaitForChild("Map"):WaitForChild("Dressrosa")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
local count = 0  

if not PlayerGui then
    warn("❌ Không tìm thấy PlayerGui!")
    return
end

local Trade = PlayerGui:FindFirstChild("Main") and PlayerGui.Main:FindFirstChild("Trade")
if not Trade then
    warn("❌ Không tìm thấy giao diện Trade!")
    return
end
function Tween2(v204)
    local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if human then
        human:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    local v205 = (v204.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude;
    local v206 = 350;
    if (v205 >= 350) then
        v206 = 350;
    end
    local v207 = TweenInfo.new(v205 / v206, Enum.EasingStyle.Linear);
    local v208 = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, v207, {
        CFrame = v204
    });
    v208:Play();
    if _G.CancelTween2 then
        v208:Cancel();
    end
    _G.Clip2 = true;
    wait(v205 / v206);
    _G.Clip2 = false
end
local function FruitAdd(fruitName)
    ReplicatedStorage.Remotes.TradeFunction:InvokeServer("addItem", fruitName)
end
local function FruitCheck(fruitName)
    local fruit = Trade:FindFirstChild("Container") and Trade.Container["2"] and Trade.Container["2"].Frame:FindFirstChild(fruitName)
    if fruit then
        print("✅ Fruit tồn tại:", fruit.Name)
        ReplicatedStorage.Remotes.TradeFunction:InvokeServer("accept")
        wait(15)
        local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if human then
            human:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    else
        warn("❌ Không tìm thấy Fruit!")
        local human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if human then
            human:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

local function GetPlayerByName(targetName)
    for _, player in pairs(Players:GetPlayers()) do
        if player.DisplayName == targetName then
            print("✅ Tìm thấy người chơi:", player.Name, "(DisplayName:", player.DisplayName .. ")")
            return player
        end
    end
    print("❌ Không tìm thấy người chơi có DisplayName:", targetName)
    return nil
end

local function CheckReady(nameplayer2)
    local character = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(nameplayer2)
    if not character then
        warn("❌ Không tìm thấy nhân vật của người chơi:", nameplayer2)
        return
    end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        warn("❌ Không tìm thấy HumanoidRootPart!")
        return
    end

    local lastPosition = rootPart.Position
    local Ready2 = Trade:FindFirstChild("Info") and Trade.Info:FindFirstChild("Ready2")

    local startTime = tick() -- Lưu thời gian bắt đầu
    local warned15s = false  -- Biến kiểm tra đã thông báo hay chưa

    while Ready2 and Ready2:IsA("TextLabel") do
        wait(0.5)
        local character = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild(nameplayer2)
        if not character then
            warn("❌ Không tìm thấy nhân vật của người chơi:", nameplayer2)
            break
        end
        local elapsedTime = tick() - startTime -- Thời gian đã trôi qua

        -- Cảnh báo khi còn 15 giây
        if elapsedTime >= 75 and not warned15s then
            print("⏳ Còn 15 giây trước khi hết thời gian!")
            local args = {
                [1] = "No accept Jump jump in 15 seconds",
                [2] = "All"
            }
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))        
            warned15s = true -- Đánh dấu đã thông báo
        end

        -- Thoát vòng lặp sau 120 giây
        if elapsedTime >= 90 then
            warn("⏳ Đã hết 120 giây! Thoát vòng lặp.")
            break
        end

        local currentPosition = rootPart.Position
        if (currentPosition - lastPosition).Magnitude > 0 then
            print("🔄 Người chơi đang di chuyển! Thoát vòng lặp.")
            break
        elseif Ready2.Text == "Ready!" then
            print("✅ Người chơi đã sẵn sàng! Bắt đầu giao dịch.")
            break
        else
            print("✅ Người chơi đứng yên, tiếp tục chờ...")
        end

        lastPosition = currentPosition
    end
end

local function Main()
    local fruitList = getgenv().fruitList
    local checkFruitList = getgenv().checkFruitList
    local player2Label = Trade:FindFirstChild("Container") and Trade.Container["2"]:FindFirstChild("TextLabel")
    if not player2Label then
        warn("❌ Không tìm thấy TextLabel của người chơi 2!")
        return
    end
    for _, fruit in ipairs(fruitList) do
        FruitAdd(fruit)
        print("📦 Thêm trái:", fruit)
    end
    print("🎯 Đối tác giao dịch:", player2Label.Text)
    local function getFirstPart(fruit)
        return fruit:match("([^%-]+)") -- Lấy chuỗi trước dấu "-"
    end    
    local shortFruitList = {}
    for _, fruit in ipairs(fruitList) do
        table.insert(shortFruitList, getFirstPart(fruit))
    end
    local shortCheckList = {}
    for _, fruit in ipairs(checkFruitList) do
        table.insert(shortCheckList, getFirstPart(fruit))
    end
    local fruitString = table.concat(shortFruitList, ", ")
    local checkString = table.concat(shortCheckList, ", ")
    local message = fruitString .. " trade " .. checkString .. "  No trade jump F kid"
    local args = {
        [1] = message,
        [2] = "All"
    }
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
    local foundPlayer = GetPlayerByName(player2Label.Text)
    if foundPlayer then
        CheckReady(foundPlayer.Name)
    else
        print("❌ Không tìm thấy người chơi, không thể kiểm tra trạng thái Ready.")
    end   
    for _, fruit in ipairs(checkFruitList) do
        FruitCheck(fruit)
        print("🔍 Kiểm tra trái:", fruit)
    end
end
while true do
    for _, obj in pairs(Dressrosa:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "TradeTable" then
            local P1 = obj:FindFirstChild("P1") and obj.P1.CFrame
            local P2 = obj:FindFirstChild("P2") and obj.P2.CFrame
            local SeatWeldP1 = obj:FindFirstChild("P1") and obj.P1:FindFirstChild("SeatWeld")
            local SeatWeldP2 = obj:FindFirstChild("P2") and obj.P2:FindFirstChild("SeatWeld")
            count = count + 1
            print("📌 TradeTable #" .. count .. " - Path:", obj:GetFullName())
            if SeatWeldP1 and SeatWeldP2 then
                print("✅ Cả hai ghế đều có SeatWeld!")
            elseif SeatWeldP1 then
                print("✅ SeatWeld1 tồn tại | ❌ SeatWeld2 không tồn tại")
                Tween2(P2)
                wait(2)
                Main()
            elseif SeatWeldP2 then
                print("✅ SeatWeld2 tồn tại | ❌ SeatWeld1 không tồn tại")
                Tween2(P1)
                wait(2)
                Main()
            else
                print("❌ Cả hai SeatWeld đều không tồn tại!")
            end
            print("-------------------------")
        end
    end
    wait(1)
    print("📊 Tổng số TradeTable được tìm thấy:", count)
    count = 0
    
end
