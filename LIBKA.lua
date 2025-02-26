-- NeverLua Library v1.0
local NeverLua = {}
local window = {}
local elements = {}

-- Utility Functions
local function create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

-- UI Elements
function NeverLua:CreateWindow(title)
    local ScreenGui = create("ScreenGui", {
        Name = "NeverLuaGui",
        Parent = game.CoreGui
    })
    
    local MainFrame = create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400)
    })
    
    local TitleBar = create("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    local TitleText = create("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local TabContainer = create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 150, 1, -30)
    })
    
    local ContentContainer = create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 150, 0, 30),
        Size = UDim2.new(1, -150, 1, -30)
    })
    
    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local window_funcs = {}
    
    function window_funcs:CreateTab(name)
        local TabButton = create("TextButton", {
            Name = name.."Tab",
            Parent = TabContainer,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 35),
            Font = Enum.Font.SourceSansBold,
            Text = name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14
        })
        
        local TabContent = create("ScrollingFrame", {
            Name = name.."Content",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 4,
            Visible = false
        })
        
        local UIListLayout = create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
        
        local tab_funcs = {}
        
        function tab_funcs:CreateToggle(name, callback)
            local Toggle = create("Frame", {
                Name = name.."Toggle",
                Parent = TabContent,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 35),
                Position = UDim2.new(0, 10, 0, 0)
            })
            
            local ToggleButton = create("TextButton", {
                Name = "ToggleButton",
                Parent = Toggle,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Position = UDim2.new(1, -45, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20),
                Text = "",
                AutoButtonColor = false
            })
            
            local ToggleInner = create("Frame", {
                Name = "ToggleInner",
                Parent = ToggleButton,
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            
            local ToggleText = create("TextLabel", {
                Name = "ToggleText",
                Parent = Toggle,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -65, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local toggled = false
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    game:GetService("TweenService"):Create(ToggleInner, TweenInfo.new(0.2), {
                        Position = UDim2.new(1, -18, 0.5, -8),
                        BackgroundColor3 = Color3.fromRGB(0, 255, 140)
                    }):Play()
                else
                    game:GetService("TweenService"):Create(ToggleInner, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, 2, 0.5, -8),
                        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    }):Play()
                end
                
                if callback then
                    callback(toggled)
                end
            end)
        end
        
        function tab_funcs:CreateSlider(name, min, max, default, callback)
            local Slider = create("Frame", {
                Name = name.."Slider",
                Parent = TabContent,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 50),
                Position = UDim2.new(0, 10, 0, 0)
            })
            
            local SliderText = create("TextLabel", {
                Name = "SliderText",
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 0, 25),
                Font = Enum.Font.SourceSans,
                Text = name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local SliderFrame = create("Frame", {
                Name = "SliderFrame",
                Parent = Slider,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 4)
            })
            
            local SliderFill = create("Frame", {
                Name = "SliderFill",
                Parent = SliderFrame,
                BackgroundColor3 = Color3.fromRGB(0, 255, 140),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 0, 1, 0)
            })
            
            local SliderValue = create("TextLabel", {
                Name = "SliderValue",
                Parent = Slider,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -50, 0, 0),
                Size = UDim2.new(0, 40, 0, 25),
                Font = Enum.Font.SourceSans,
                Text = tostring(default),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14
            })
            
            local function updateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                
                local value = math.floor(((pos.X.Scale * (max - min)) + min) * 100) / 100
                SliderValue.Text = tostring(value)
                
                if callback then
                    callback(value)
                end
            end
            
            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local connection
                    connection = game:GetService("RunService").RenderStepped:Connect(function()
                        updateSlider(input)
                    end)
                    
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            connection:Disconnect()
                        end
                    end)
                end
            end)
        end
        
        function tab_funcs:CreateButton(name, callback)
            local Button = create("TextButton", {
                Name = name.."Button",
                Parent = TabContent,
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 35),
                Position = UDim2.new(0, 10, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14
            })
            
            Button.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
        end
        
        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            TabContent.Visible = true
            
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    game:GetService("TweenService"):Create(v, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    }):Play()
                end
            end
            game:GetService("TweenService"):Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            }):Play()
        end)
        
        return tab_funcs
    end
    
    return window_funcs
end

return NeverLua
