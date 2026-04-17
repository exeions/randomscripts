-- Gui to Lua
-- Version: 3.2 (Modified - private GUI command input, no chat)

-- Instances:

local cmdgui = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local cmdinput = Instance.new("TextBox")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local UICorner_2 = Instance.new("UICorner")
local Arrow = Instance.new("ImageLabel")
local UIGradient = Instance.new("UIGradient")
local mainShadow = Instance.new("ImageLabel")

--Properties:

cmdgui.Name = "cmdgui"
cmdgui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
cmdgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

main.Name = "main"
main.Parent = cmdgui
main.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
main.BorderColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.28174603, 0, 0.843631804, 0)
main.Size = UDim2.new(0.435714275, 0, 0.0983606577, 0)
main.Visible = false -- hidden by default

cmdinput.Name = "cmdinput"
cmdinput.Parent = main
cmdinput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
cmdinput.BorderColor3 = Color3.fromRGB(0, 0, 0)
cmdinput.BorderSizePixel = 0
cmdinput.Position = UDim2.new(0.209471762, 0, 0.269230783, 0)
cmdinput.Size = UDim2.new(0.579234958, 0, 0.551282048, 0)
cmdinput.Font = Enum.Font.SourceSans
cmdinput.Text = ""
cmdinput.TextColor3 = Color3.fromRGB(255, 255, 255)
cmdinput.TextSize = 25.000
cmdinput.TextWrapped = true
cmdinput.TextXAlignment = Enum.TextXAlignment.Left
cmdinput.PlaceholderText = "type command..."
cmdinput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
cmdinput.ClearTextOnFocus = false

UICorner.Parent = cmdinput

Title.Name = "Title"
Title.Parent = main
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0.269230783, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "CMD PROMPT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextSize = 14.000
Title.TextWrapped = true

UICorner_2.Parent = main

Arrow.Name = "Arrow"
Arrow.Parent = main
Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Arrow.BackgroundTransparency = 1.000
Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
Arrow.BorderSizePixel = 0
Arrow.Position = UDim2.new(0.131147534, 0, 0.269230783, 0)
Arrow.Size = UDim2.new(0.0783242285, 0, 0.551282048, 0)
Arrow.Image = "rbxassetid://4726772330"

UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(189, 195, 199)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(44, 62, 80))
}
UIGradient.Parent = main

mainShadow.Name = "mainShadow"
mainShadow.Parent = main
mainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
mainShadow.BackgroundTransparency = 1.000
mainShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
mainShadow.Size = UDim2.new(1, 142, 1, 142)
mainShadow.ZIndex = 0
mainShadow.Image = "rbxassetid://12817494724"
mainShadow.ImageTransparency = 0.500
mainShadow.ScaleType = Enum.ScaleType.Slice
mainShadow.SliceCenter = Rect.new(85, 85, 427, 427)

-- Scripts:

local function JLNCIR_fake_script()
    local script = Instance.new('LocalScript', cmdgui)

    local UserInputService = game:GetService("UserInputService")
    local player = game.Players.LocalPlayer
    local prefix = getgenv().prefix or "."

    local frame = cmdgui:WaitForChild("main")
    local textBox = frame:WaitForChild("cmdinput")

    local TOGGLE_KEY = Enum.KeyCode.Quote

    -- Sends the command privately by calling the bot controller's exposed
    -- global function directly. No chat message is ever sent.
    local function sendCommand(rawInput)
        rawInput = rawInput:match("^%s*(.-)%s*$")
        print("[CmdGui] sendCommand called with: '" .. rawInput .. "'")  -- ADD THIS
        if rawInput == "" then return end
    
        local message = rawInput
        if message:sub(1, #prefix) == prefix then
            message = message:sub(#prefix + 1)
        end
        
        print("[CmdGui] message after strip: '" .. message .. "'")  -- ADD THIS
        print("[CmdGui] HandleCommand exists: " .. tostring(getgenv().BotController_HandleCommand ~= nil))  -- ADD THIS
    
        local attempts = 0
        while not getgenv().BotController_HandleCommand and attempts < 20 do
            task.wait(0.5)
            attempts += 1
        end
    
        if getgenv().BotController_HandleCommand then
            print("[CmdGui] Calling HandleCommand...")  -- ADD THIS
            coroutine.wrap(function()
                getgenv().BotController_HandleCommand(message)
            end)()
        else
            warn("[CmdGui] BotController_HandleCommand not found.")
        end
    end

    -- Submit on Enter
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local input = textBox.Text
            sendCommand(input)
            textBox.Text = ""
            frame.Visible = false
        end
    end)

    -- Toggle with apostrophe key
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == TOGGLE_KEY then
            frame.Visible = not frame.Visible

            if frame.Visible then
                task.wait(0.05)
                textBox.Text = ""
                textBox:CaptureFocus()
            else
                textBox:ReleaseFocus()
            end
        end
    end

    UserInputService.InputBegan:Connect(onInputBegan)
end

coroutine.wrap(JLNCIR_fake_script)()
