--get configs
local Use_Displayname = getgenv().Use_Displayname
local bots = getgenv().bots
local owner = getgenv().owner
local nbbot = getgenv().nbbot
local prefix = getgenv().prefix
local botrender = getgenv().botrender
local printcmd = getgenv().printcmd

-- cmd bools
local cmdstatus = true
local cmdindex = true
local cmdfollow = true
local cmdquit = true
local cmddance = true
local cmdundance = true
local cmdreset = true
local cmdjump = true
local cmdsay = true
local cmdunfollow = true
local cmdorbit = true
local cmdunorbit = true
local cmdgoto = true
local cmdalign = true
local cmdws = true
local cmdloopjump = true
local cmdunloopjump = true
local cmdcircle = true
local cmdchannel = true
local cmdworm = true
local cmdunworm = true
local cmdspin = true
local cmdunspin = true
local cmdadmin = true
local cmdarch = true
local cmdorbit2 = true
local cmdorbit3 = true
local cmdorbit4 = true
local cmdorbit5 = true
local cmdorbit6 = true
local cmdstalk = true
local cmdunstalk = true
local cmdhelp = true
local cmdtower = true
local cmduntower = true
local cmdfix = true

local towerbool = false
local followbool = false
local orbitbool = false
local orbitbool2 = false
local orbitbool3 = false
local orbitbool4 = false
local orbitbool5 = false
local orbitbool6 = false
local booljump = false
local indexcircle = nil
local channel = 1
local wormbool = false
local boolspin = false
local adminbool = false
local stalkbool = false
local Admins = {}

print("Asu's bot controller VERSION: 0.2.1 (getgenv edition)")

if printcmd then
    print("Asu's Bot Controller")
    print("-------------------------------------------------------------------")
    print("args:")
    print("[plr] = player (you don't need to put the full username or display name of someone to make it work)")
    print("<number> = need to be a number to make it work")
    print("(string) = word or a sentence")
    print("-------------------------------------------------------------------")
    print(";status                              |  check if bots are active")
    print(";index                               |  show bots' index")
    print(";follow [plr]                        |  follow someone")
    print(";quit                                |  disconnect admins and owner from the script")
    print(";dance <number>                      |  make bots dance")
    print(";undance                             |  make bots stop dancing")
    print(";reset                               |  make bots reset")
    print(";jump                                |  make bots jump")
    print(";say (sentence)                      |  make bots say something")
    print(";unfollow                            |  unfollow the player that the bots are following")
    print(";orbit [plr] <radius> <speed>        |  orbit around someone V1 (normal orbit)")
    print(";orbit2 [plr] <radius> <speed>       |  orbit around someone V2 (cooler)")
    print(";orbit3 [plr] <radius> <speed>       |  orbit around someone V3")
    print(";orbit4 [plr] <radius> <speed>       |  orbit around someone V4")
    print(";orbit5 [plr] <radius> <speed>       |  orbit around someone V5")
    print(";orbit6 [plr] <radius> <speed>       |  orbit around someone V6 (chaotic)")
    print(";unorbit                             |  stop bots from orbiting")
    print(";goto [plr]                          |  teleport bots to a player")
    print(";align [plr]                         |  make a line with the bots")
    print(";ws <number>                         |  change bots' walk speed")
    print(";loopjump                            |  make bots jump in a loop")
    print(";unloopjump                          |  stop the jump loop")
    print(";circle <number>                     |  make bots form a circle around you")
    print(";channel <number>                    |  change the bot that says the messages")
    print(";worm [plr]                          |  make a worm/train/snake formation with bots")
    print(";unworm                              |  stop the worm/train/snake formation")
    print(";spin <number>                       |  make bots spin")
    print(";unspin                              |  make bots stop spinning")
    print(";admin [plr]                         |  give admin to someone")
    print(";arch <number>                       |  make a half-circle with the bots")
    print(";stalk [plr]                         |  follow someone and walk around them")
    print(";unstalk                             |  stop stalking")
    print(";help                                |  show all commands")
    print(";tower [plr]                         |  makes a tower of bots")
    print(";untower                             |  undo the tower")
    print(";fix                                 |  try to fix the bot if glitched")
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")

local player = game.Players.LocalPlayer
local displayName = player.DisplayName
local user = player.Name

local ownerPlayer = game.Players:FindFirstChild(owner)
local adminNotConnected = {}

-- index bot
local index

if Use_Displayname then
    for i, bot in ipairs(bots) do
        if displayName == bot then
            index = i
            break
        end
    end
else
    for i, bot in ipairs(bots) do
        if user == bot then
            index = i
            break
        end
    end
end

if index then
    indexcircle = (360 / nbbot * index)
end

if index and botrender then
    RunService:Set3dRenderingEnabled(false)
else
    RunService:Set3dRenderingEnabled(true)
end

if not index then
    if player.Name ~= owner then
        warn("No bot or owner corresponding with: " .. table.concat(bots, ", ") .. " or " .. owner .. " for this instance.")
        return
    end
end

-- Chat message (used by ;say, ;status etc)
local function chatMessage(str)
    str = tostring(str)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

-- find player by partial name
local function findPlayerByName(partialName)
    if partialName:lower() == "me" then
        return game.Players:FindFirstChild(owner)
    end
    if partialName:lower() == "random" then
        local players = game.Players:GetPlayers()
        if #players > 0 then
            return players[math.random(1, #players)]
        end
    end
    local bestMatch = nil
    local bestMatchScore = 0
    for _, plr in pairs(game.Players:GetPlayers()) do
        local nameMatch = plr.Name:lower():find(partialName:lower())
        local displayNameMatch = plr.DisplayName:lower():find(partialName:lower())
        if nameMatch or displayNameMatch then
            local score = (nameMatch and #plr.Name or 0) + (displayNameMatch and #plr.DisplayName or 0)
            if score > bestMatchScore then
                bestMatchScore = score
                bestMatch = plr
            end
        end
    end
    return bestMatch
end

-- split string helper (replaces broken :split())
local function splitString(str, sep)
    local result = {}
    for part in str:gmatch("[^" .. sep .. "]+") do
        table.insert(result, part)
    end
    return result
end

local function removeVelocity()
    for _, v in pairs(player.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Velocity = Vector3.new(0, 0, 0)
            v.RotVelocity = Vector3.new(0, 0, 0)
        elseif v:IsA("BodyVelocity") then
            v.Velocity = Vector3.new(0, 0, 0)
        elseif v:IsA("BodyAngularVelocity") then
            v.AngularVelocity = Vector3.new(0, 0, 0)
        elseif v:IsA("BodyPosition") then
            v.Position = v.Position
        elseif v:IsA("BodyGyro") then
            v.CFrame = v.CFrame
        end
    end
end

local function disablebool()
    towerbool = false
    followbool = false
    orbitbool = false
    orbitbool2 = false
    orbitbool3 = false
    orbitbool4 = false
    orbitbool5 = false
    orbitbool6 = false
    booljump = false
    wormbool = false
    boolspin = false
    stalkbool = false
end

local function fix()
    disablebool()
    removeVelocity()
    game.Workspace.Gravity = 196.2
    player.Character:BreakJoints()
end

local function tpcircle(distance)
    if distance == 0 then distance = 0.0001 end
    local targetPlayer = Players:FindFirstChild(owner)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local playerHRP = player.Character:FindFirstChild("HumanoidRootPart")
    if not playerHRP then return end
    removeVelocity()
    local angle = math.rad(indexcircle)
    local newPosition = targetHRP.Position + Vector3.new(distance * math.cos(angle), 0, distance * math.sin(angle))
    playerHRP.CFrame = CFrame.new(newPosition, targetHRP.Position)
end

local function tparch(distance)
    if distance == 0 then distance = 0.0001 end
    local targetPlayer = Players:FindFirstChild(owner)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local playerHRP = player.Character:FindFirstChild("HumanoidRootPart")
    if not playerHRP then return end
    removeVelocity()
    local angle = math.rad(indexcircle / 2)
    local newPosition = targetHRP.Position + Vector3.new(distance * math.cos(angle), 0, distance * math.sin(angle))
    playerHRP.CFrame = CFrame.new(newPosition, targetHRP.Position)
end

local function align(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local localHRP = player.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end
    removeVelocity()
    localHRP.CFrame = targetHRP.CFrame + targetHRP.CFrame.RightVector * -5 * index
end

local function gotoPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local localHRP = player.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end
    removeVelocity()
    localHRP.CFrame = targetHRP.CFrame
end

local function tower(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    towerbool = true
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not towerbool or not targetPlayer.Character then
            conn:Disconnect()
            return
        end
        local localHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if localHRP then
            localHRP.CFrame = targetHRP.CFrame + targetHRP.CFrame.UpVector * 5 * index
            removeVelocity()
        end
    end)
end

local function followPlayer(targetPlayer)
    while followbool and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") do
        player.Character.Humanoid:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
        task.wait(0.1)
    end
end

local function spin(spinSpeed)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local existing = root:FindFirstChild("Spinning")
    if existing then existing:Destroy() end
    local s = Instance.new("BodyAngularVelocity")
    s.Name = "Spinning"
    s.Parent = root
    s.MaxTorque = Vector3.new(0, math.huge, 0)
    s.AngularVelocity = Vector3.new(0, spinSpeed, 0)
    while boolspin do task.wait(0.1) end
    s:Destroy()
end

local function worm(msgtarget2)
    local indexworm = table.find(bots, Use_Displayname and displayName or user)
    if not indexworm then return end
    if indexworm > 1 then
        local targetPlayer = findPlayerByName(bots[indexworm - 1])
        if targetPlayer then
            wormbool = true
            while wormbool and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") do
                player.Character.Humanoid:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
                task.wait(0.1)
            end
        end
    else
        if msgtarget2 and msgtarget2.Character and msgtarget2.Character:FindFirstChild("HumanoidRootPart") then
            followbool = true
            while followbool and msgtarget2 and msgtarget2.Character and msgtarget2.Character:FindFirstChild("HumanoidRootPart") do
                player.Character.Humanoid:MoveTo(msgtarget2.Character.HumanoidRootPart.Position)
                task.wait(0.1)
            end
        end
    end
end

local function orbitPlayer(targetPlayer, speed, r)
    game.Workspace.Gravity = 0
    if r == 0 then r = 0.0001 end
    local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerHRP then return end
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local rotation = indexcircle
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not orbitbool or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            conn:Disconnect() return
        end
        removeVelocity()
        playerHRP.CFrame = CFrame.new(targetHRP.Position) * CFrame.Angles(0, math.rad(rotation), 0) * CFrame.new(r, 0, 0)
        playerHRP.CFrame = CFrame.new(playerHRP.Position, targetHRP.Position)
        rotation = (rotation + speed) % 360
    end)
end

local function orbitPlayer2(targetPlayer, speed, r)
    game.Workspace.Gravity = 0
    if r == 0 then r = 0.0001 end
    local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerHRP then return end
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local rotation = indexcircle
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not orbitbool2 or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            conn:Disconnect() return
        end
        removeVelocity()
        playerHRP.CFrame = CFrame.new(targetHRP.Position) * CFrame.Angles(math.rad(rotation), math.rad(rotation), 0) * CFrame.new(r, 0, 0)
        playerHRP.CFrame = CFrame.new(playerHRP.Position, targetHRP.Position)
        rotation = (rotation + speed) % 360
    end)
end

local function orbitPlayer3(targetPlayer, speed, r)
    game.Workspace.Gravity = 0
    if r == 0 then r = 0.0001 end
    local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerHRP then return end
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local rotation = indexcircle
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not orbitbool3 or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            conn:Disconnect() return
        end
        removeVelocity()
        playerHRP.CFrame = CFrame.new(targetHRP.Position) * CFrame.Angles(math.rad(rotation), math.rad(rotation), math.rad(rotation)) * CFrame.new(r, 0, 0)
        playerHRP.CFrame = CFrame.new(playerHRP.Position, targetHRP.Position)
        rotation = (rotation + speed) % 360
    end)
end

local function orbitPlayer4(targetPlayer, speed, r)
    game.Workspace.Gravity = 0
    if r == 0 then r = 0.0001 end
    local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerHRP then return end
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local rotation = indexcircle
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not orbitbool4 or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            conn:Disconnect() return
        end
        removeVelocity()
        playerHRP.CFrame = CFrame.new(targetHRP.Position) * CFrame.Angles(math.rad(rotation), 0, math.rad(rotation)) * CFrame.new(r, 0, 0)
        playerHRP.CFrame = CFrame.new(playerHRP.Position, targetHRP.Position)
        rotation = (rotation + speed) % 360
    end)
end

local function orbitPlayer5(targetPlayer, speed, r)
    game.Workspace.Gravity = 0
    if r == 0 then r = 0.0001 end
    local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerHRP then return end
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local rotation = indexcircle
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not orbitbool5 or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            conn:Disconnect() return
        end
        removeVelocity()
        playerHRP.CFrame = CFrame.new(targetHRP.Position) * CFrame.Angles(math.rad(math.random(0,360)), math.rad(math.random(0,360)), math.rad(math.random(0,360))) * CFrame.new(r, 0, 0)
        playerHRP.CFrame = CFrame.new(playerHRP.Position, targetHRP.Position)
        rotation = (rotation + speed) % 360
    end)
end

local function orbitPlayer6(targetPlayer, speed, r)
    game.Workspace.Gravity = 0
    if r == 0 then r = 0.0001 end
    local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not playerHRP then return end
    local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    local rotation = indexcircle
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not orbitbool6 or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            conn:Disconnect() return
        end
        removeVelocity()
        playerHRP.CFrame = CFrame.new(targetHRP.Position) * CFrame.Angles(math.rad(math.random(0,360)), math.rad(math.random(0,360)), 0) * CFrame.new(r, 0, 0)
        playerHRP.CFrame = CFrame.new(playerHRP.Position, targetHRP.Position)
        rotation = (rotation + speed) % 360
    end)
end

local function stalkPlayer(targetPlayer)
    while stalkbool and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") do
        local targetHRP = targetPlayer.Character.HumanoidRootPart
        local botHRP = player.Character:FindFirstChild("HumanoidRootPart")
        if botHRP then
            if (botHRP.Position - targetHRP.Position).Magnitude > 25 then
                botHRP.CFrame = targetHRP.CFrame + targetHRP.CFrame.LookVector * -2.065
            else
                player.Character.Humanoid:MoveTo(targetHRP.Position + Vector3.new(math.random(-8,8), 0, math.random(-8,8)))
            end
        end
        task.wait(0.28)
    end
end

local function admin(targetPlayer)
    if not table.find(Admins, targetPlayer.Name) then
        table.insert(Admins, targetPlayer.Name)
        table.insert(adminNotConnected, targetPlayer.Name)
    end
end

-- ============================================================
-- CORE COMMAND HANDLER
-- Called by both the getgenv poller (GUI) and chat listener
-- ============================================================
local function handleCommand(command)
    -- strip prefix if present
    if command:sub(1, #prefix) == prefix then
        command = command:sub(#prefix + 1)
    end
    command = command:match("^%s*(.-)%s*$") -- trim whitespace

    -- all commands require the player to be a bot
    if not table.find(bots, Use_Displayname and displayName or user) then return end

    if command == "status" and cmdstatus then
        chatMessage(displayName .. " (Bot " .. index .. ") is active!")

    elseif command:sub(1, 6) == "admin " and cmdadmin then
        local target = findPlayerByName(command:sub(7))
        if target then
            admin(target)
            if index == channel then chatMessage(target.Name .. " is now an admin.") end
        else
            if index == channel then chatMessage("Player not found.") end
        end

    elseif command == "quit" and cmdquit then
        cmdstatus=false; cmdindex=false; cmdfollow=false; cmdquit=false
        cmddance=false; cmdundance=false; cmdreset=false; cmdjump=false
        cmdsay=false; cmdunfollow=false; cmdorbit=false; cmdunorbit=false
        cmdgoto=false; cmdalign=false; cmdws=false; cmdloopjump=false
        cmdunloopjump=false; cmdcircle=false; cmdchannel=false
        cmdworm=false; cmdunworm=false; cmdspin=false; cmdunspin=false
        cmdadmin=false; cmdarch=false; cmdorbit2=false; cmdorbit3=false
        cmdorbit4=false; cmdorbit5=false; cmdorbit6=false; cmdstalk=false
        cmdunstalk=false; cmdhelp=false; cmdtower=false; cmduntower=false
        cmdfix=false; disablebool()
        Admins = {}; adminNotConnected = {}
        chatMessage("quit")

    elseif command == "index" and cmdindex then
        chatMessage(displayName .. " index is (" .. index .. ")")

    elseif command:sub(1, 8) == "channel " and cmdchannel then
        local chnl = tonumber(command:sub(9))
        if not chnl or chnl > nbbot or chnl < 1 then
            if index == channel then chatMessage("Error: channel must be between 1 and " .. nbbot) end
        else
            channel = chnl
            if index == channel then chatMessage("Channel is now: " .. channel) end
        end

    elseif command == "unloopjump" and cmdunloopjump then
        booljump = false

    elseif command == "untower" and cmduntower then
        towerbool = false

    elseif command == "loopjump" and cmdloopjump then
        booljump = true
        while booljump do
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.8)
        end

    elseif command:sub(1, 6) == "align " and cmdalign then
        disablebool()
        local target = findPlayerByName(command:sub(7))
        if target then
            align(target)
            if index == channel then chatMessage("yes sir!") end
        else
            if index == channel then chatMessage("Player not found.") end
        end

    elseif command:sub(1, 7) == "dance 1" and cmddance then
        chatMessage("/e dance1")
    elseif command:sub(1, 7) == "dance 2" and cmddance then
        chatMessage("/e dance2")
    elseif command:sub(1, 7) == "dance 3" and cmddance then
        chatMessage("/e dance3")
    elseif command:sub(1, 7) == "dance 4" and cmddance then
        chatMessage("/e dance4")
    elseif command == "dance" and cmddance then
        chatMessage("/e dance")

    elseif command == "help" and cmdhelp then
        if index == channel then
            chatMessage("available commands:")
            chatMessage(";status ;index ;follow [plr] ;quit ;dance <number> ;undance ;reset ;jump ;say <sentence> ;unfollow ;orbit [plr] <radius> <speed>")
            chatMessage(";orbit2-6 [plr] <radius> <speed> ;unorbit ;goto [plr] ;align [plr] ;ws <number> ;loopjump ;unloopjump ;circle <number> ;channel <number>")
            chatMessage(";worm [plr] ;unworm ;spin <number> ;unspin ;admin [plr] ;arch <number> ;stalk [plr] ;unstalk ;tower [plr] ;untower ;fix ;help")
        end

    elseif command:sub(1, 5) == "spin " and cmdspin then
        local spinarg = tonumber(command:sub(6))
        if spinarg then boolspin = true; spin(spinarg) end

    elseif command == "unspin" and cmdunspin then
        boolspin = false

    elseif command:sub(1, 3) == "ws " and cmdws then
        local ws = tonumber(command:sub(4))
        if ws then player.Character.Humanoid.WalkSpeed = ws end

    elseif command == "undance" and cmdundance then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    elseif command:sub(1, 7) == "circle " and cmdcircle then
        disablebool()
        tpcircle(tonumber(command:sub(8)) or 8)

    elseif command:sub(1, 5) == "arch " and cmdarch then
        disablebool()
        tparch(tonumber(command:sub(6)) or 8)

    elseif command:sub(1, 4) == "say " and cmdsay then
        chatMessage(command:sub(5))

    elseif command == "fix" and cmdfix then
        fix()

    elseif command == "jump" and cmdjump then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    elseif command == "unorbit" and cmdunorbit then
        orbitbool=false; orbitbool2=false; orbitbool3=false
        orbitbool4=false; orbitbool5=false; orbitbool6=false
        game.Workspace.Gravity = 196.2
        if index == channel then chatMessage("stopped orbiting") end

    elseif command:sub(1, 5) == "goto " and cmdgoto then
        disablebool()
        local target = findPlayerByName(command:sub(6))
        if target then gotoPlayer(target)
        else if index == channel then chatMessage("Player not found.") end end

    elseif command:sub(1, 6) == "tower " and cmdtower then
        disablebool()
        local target = findPlayerByName(command:sub(7))
        if target then tower(target)
        else if index == channel then chatMessage("Player not found.") end end

    elseif command == "unfollow" and cmdunfollow then
        followbool = false
        if index == channel then chatMessage("stopped following") end

    elseif command == "unworm" and cmdunworm then
        wormbool = false
        if index == channel then chatMessage("stopped worm") end

    elseif command:sub(1, 6) == "orbit " and cmdorbit then
        disablebool()
        local args = splitString(command, " ")
        local target = findPlayerByName(args[2])
        local r = tonumber(args[3])
        local speed = tonumber(args[4])
        if target then
            orbitbool = true
            if index == channel then chatMessage("Bots are now orbiting " .. target.Name) end
            orbitPlayer(target, speed, r)
        else if index == channel then chatMessage("Player not found.") end end

    elseif command:sub(1, 7) == "orbit2 " and cmdorbit2 then
        disablebool()
        local args = splitString(command, " ")
        local target = findPlayerByName(args[2])
        local r = tonumber(args[3])
        local speed = tonumber(args[4])
        if target then
            orbitbool2 = true
            if index == channel then chatMessage("Bots are now orbiting " .. target.Name) end
            orbitPlayer2(target, speed, r)
        else if index == channel then chatMessage("Player not found.") end end

    elseif command:sub(1, 7) == "orbit3 " and cmdorbit3 then
        disablebool()
        local args = splitString(command, " ")
        local target = findPlayerByName(args[2])
        local r = tonumber(args[3])
        local speed = tonumber(args[4])
        if target then
            orbitbool3 = true
            if index == channel then chatMessage("Bots are now orbiting " .. target.Name) end
            orbitPlayer3(target, speed, r)
        else if index == channel then chatMessage("Player not found.") end end

    elseif command:sub(1, 7) == "orbit4 " and cmdorbit4 then
        disablebool()
        local args = splitString(command, " ")
        local target = findPlayerByName(args[2])
        local r = tonumber(args[3])
        local speed = tonumber(args[4])
        if target then
            orbitbool4 = true
            if index == channel then chatMessage("Bots are now orbiting " .. target.Name) end
            orbitPlayer4(target, speed, r)
        else if index == channel then chatMessage("Player not found.") end end

    elseif command:sub(1, 7) == "orbit5 " and cmdorbit5 then
        disablebool()
        local args = splitString(command, " ")
        local target = findPlayerByName(args[2])
        local r = tonumber(args[3])
        local speed = tonumber(args[4])
        if target then
            orbitbool5 = true
            if index == channel then chatMessage("Bots are now orbiting " .. target.Name) end
            orbitPlayer5(target, speed, r)
        else if index == channel then chatMessage("Player not found.") end end

    elseif command:sub(1, 7) == "orbit6 " and cmdorbit6 then
        disablebool()
        local args = splitString(command, " ")
        local target = findPlayerByName(args[2])
        local r = tonumber(args[3])
        local speed = tonumber(args[4])
        if target then
            orbitbool6 = true
            if index == channel then chatMessage("Bots are now orbiting " .. target.Name) end
            orbitPlayer6(target, speed, r)
        else if index == channel then chatMessage("Player not found.") end end

    elseif command == "reset" and cmdreset then
        disablebool()
        game.Workspace.Gravity = 196.2
        player.Character:BreakJoints()

    elseif command:sub(1, 5) == "worm " and cmdworm then
        disablebool()
        local target = findPlayerByName(command:sub(6))
        worm(target)

    elseif command == "unstalk" and cmdunstalk then
        stalkbool = false
        if index == channel then chatMessage("Bots stopped stalking") end

    elseif command:sub(1, 6) == "stalk " and cmdstalk then
        disablebool()
        local target = findPlayerByName(command:sub(7))
        if target then
            stalkbool = true
            if index == channel then chatMessage("Bots are now stalking " .. target.Name .. ".") end
            stalkPlayer(target)
        else
            if index == channel then chatMessage("Player not found.") end
        end

    elseif command:sub(1, 7) == "follow " and cmdfollow then
        disablebool()
        local target = findPlayerByName(command:sub(8))
        if target then
            followbool = true
            if index == channel then chatMessage("Bots are now following " .. target.Name .. ".") end
            followPlayer(target)
        else
            if index == channel then chatMessage("Player not found.") end
        end
    end
end

-- ============================================================
-- GETGENV POLLER - the core of the silent GUI system
-- Every bot instance polls getgenv().pendingCommand
-- When the GUI sets it, all bots pick it up and execute locally
-- ============================================================
if index then
    -- initialise the shared command slot once (owner's client sets this)
    if not getgenv().pendingCommand then
        getgenv().pendingCommand = ""
        getgenv().pendingCommandId = 0
    end

    local lastCommandId = 0

    task.spawn(function()
        while true do
            local cmdId = getgenv().pendingCommandId
            if cmdId and cmdId ~= lastCommandId and getgenv().pendingCommand ~= "" then
                lastCommandId = cmdId
                local cmd = getgenv().pendingCommand
                local ok, err = xpcall(function()
                    handleCommand(cmd)
                end, function(e)
                    warn("[BotController] Error handling command '" .. tostring(cmd) .. "': " .. tostring(e))
                end)
            end
            task.wait(0.1)
        end
    end)
end

-- ============================================================
-- CHAT LISTENER - kept so typing in chat still works too
-- ============================================================
local function connectChatListener(playerpower)
    playerpower.Chatted:Connect(function(message)
        if message:sub(1, #prefix) == prefix then
            task.spawn(function()
                handleCommand(message)
            end)
        end
    end)
end

if ownerPlayer then
    connectChatListener(ownerPlayer)
end

game.Players.PlayerAdded:Connect(function(newPlayer)
    if table.find(Admins, newPlayer.Name) then
        connectChatListener(newPlayer)
    end
end)
