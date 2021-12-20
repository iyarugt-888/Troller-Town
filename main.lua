local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reuploaded"))()
local Window = Library.new("Troller Town", 5013109572)
local Theme = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(10, 10, 10),
	LightContrast = Color3.fromRGB(20, 20, 20),
	DarkContrast = Color3.fromRGB(14, 14, 14),  
	TextColor = Color3.fromRGB(255, 255, 255)
}
local MainPage = Window:addPage("Main", 5012544693)
local Assistance = MainPage:addSection("Assistance")
local Movement = MainPage:addSection("Movement")
local MiscPage = Window:addPage("Miscellaneous", 5012544692)
local Music = MiscPage:addSection("Music")
local Props = MiscPage:addSection("Props")
local Menu = MiscPage:addSection("Menu")
local Player = game:GetService("Players").LocalPlayer
local Client = Player.PlayerGui.Client
local Env = getsenv(Client)
local OEnv = {setRecoil = Env.setRecoil, updateWalkSpeed = Env.updateWalkSpeed, rayWithDamage = Env.rayWithDamage}
local Freekill = {}
local Blank = Instance.new("RemoteEvent")
local Metatable = getrawmetatable(game)
local __index = Metatable.__index
local Banner = Player.PlayerGui.Game.Screenspace.StatsAlive.BannerRoundOver
local Key = tonumber(tostring(Env.remote):sub(-18, -1)) % 999999999
local ServerEvents = workspace:WaitForChild("ServerEvents")
local newcclosure = (newcclosure and newcclosure or protect_function and protect_function or function(...) return ... end)
local hookfunction = (hookfunction and hookfunction or detour_function and detour_function)
local setreadonly = (setreadonly and setreadonly or make_writeable and function(a, b)
	if a then
		make_writeable(b)
	else
		make_readonly(b)
	end
end)
local Settings = {
	NoSpread = false,
	TraitorDetector = false,
	ExposeTraitors = false,
	ESP = false,
	NoFall = false,
	PropMesser = false,
	DetectiveCall = false,
	AutoRespawn = false,
	WalkSpeed = 16,
	JumpPower = 21
}
local Freekill = {}
local takeNotification = function(Text)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "",
		Text = Text
	})
end
local MakeT = function(P, R)
	Freekill[P] = R
	takeNotification(P .. " is " .. R)
	if Settings.ExposeTraitors == true then
		ServerEvents.SendChat:FireServer(Key, P .. " is " .. R .. ". KOS")
	end
end
local DoP = function(P)
	if P.Character then
		local Stock = P.Character:WaitForChild("Stock"):WaitForChild("Traitor")
		for a, s in next, Stock:GetChildren() do
			s.Changed:Connect(function()
				if Settings.TraitorDetector then
					MakeT(P.Name, "Traitor")
				end
			end)
		end
	end
	P.CharacterAdded:Connect(function()
		local Stock = P.Character:WaitForChild("Stock"):WaitForChild("Traitor")
		for a, s in next, Stock:GetChildren() do
			s.Changed:Connect(function()
				if Settings.TraitorDetector then
					MakeT(P.Name, "Traitor")
				end
			end)
		end
	end)
end
workspace.Ragdolls.ChildAdded:Connect(function(Child)
	if Child:FindFirstChild("CorpseData") and Settings.TraitorDetector and Banner.Visible == false then
		local CorpseData = Child:FindFirstChild("CorpseData")
		if CorpseData.IsSelfDefense.Value == false and CorpseData.Team.Value == "Innocent" and game:GetService("Players"):FindFirstChild(CorpseData.KilledBy.Value) and not Freekill[Child.Name] then
			MakeT(CorpseData.KilledBy.Value, "Freekill / Traitor")
		end
	end
end)
workspace.RoundEvents.ChildAdded:Connect(function(Child)
	if Child.Name == "The round started" then
		Freekill = {}
		if Settings.PropMesser then
			wait(3)
			for i, v in next, workspace.Items:GetChildren() do
				ServerEvents.MagnetMove:FireServer(Key, "Connect", v, Vector3.new(9999, 9999, 9999))
				ServerEvents.MagnetMove:FireServer(Key, "Update", v, Vector3.new(9999, 9999, 9999))
				ServerEvents.ManagePOM:FireServer(Key, "Connect", v)
				ServerEvents.ManagePOM:FireServer(Key, "Space", v, Vector3.new(9999, 9999, 9999))
			end
			takeNotification("Messed up props")
		end
	end
end)
coroutine.wrap(function()
	while wait(1) do
		if Settings.DetectiveCall then  
			for i, v in next, game:GetService("Players"):GetPlayers() do
				ServerEvents.ConfirmDeath:FireServer(Key, v.Name)
				ServerEvents.SendDetectiveCall:FireServer(Key, v.Name)
			end
		end
		if Settings.AutoRespawn then
			ServerEvents.ReadyToSpawn:FireServer(Key)
		end
	end
end)()
Movement:addTextbox("WalkSpeed", "16", function(value, focusLost)
	if focusLost then
		local ws = tonumber(value)
		print(ws)
		Settings.WalkSpeed = ws
	end
end)
Movement:addTextbox("JumpPower", "21", function(value, focusLost)
	if focusLost then
		local jp = tonumber(value)
		Settings.JumpPower = jp
	end
end)
Music:addTextbox("Play Music", "314311828", function(value, focusLost)
	if focusLost then
		local Id = tonumber(value)
		local Remote = ServerEvents:WaitForChild("SendSound")
		Remote:FireServer(Key, Id, 1, 5, Player.Character.HumanoidRootPart, true)
		local Sound = Instance.new("Sound")
		Sound.SoundId = "rbxassetid://" .. Id
		Sound.Volume = 5
		Sound.Parent = Player.Character.HumanoidRootPart
		Sound:Play()
	end
end)
Assistance:addToggle("No Recoil", nil, function(value)
	Env.setRecoil = value and function() end or OEnv.setRecoil
end)
Assistance:addToggle("No Spread", nil, function(value)
	Settings.NoSpread = value
end)
Assistance:addToggle("Detective Call", nil, function(value)
	Settings.DetectiveCall = value
end)
Assistance:addToggle("No Fall", nil, function(value)
	Settings.NoFall = value
end)
Assistance:addToggle("Traitor Detector", nil, function(value)
	Settings.TraitorDetector = value
end)
Assistance:addToggle("Expose Traitors", nil, function(value)
	Settings.ExposeTraitors = value
end)
Assistance:addToggle("ESP", nil, function(value)
	Settings.ESP = value
end)
Assistance:addToggle("Auto Respawn", nil, function(value)
	Settings.AutoRespawn = value
end)
Props:addToggle("Prop Messer", nil, function(value)
	Settings.PropMesser = value
	if value == true then
		takeNotification("Messed up props", 2)
		for i, v in next, workspace.Items:GetChildren() do
			ServerEvents.MagnetMove:FireServer(Key, "Connect", v, Vector3.new(9999, 9999, 9999))
			ServerEvents.MagnetMove:FireServer(Key, "Update", v, Vector3.new(9999, 9999, 9999))
			ServerEvents.ManagePOM:FireServer(Key, "Connect", v)
			ServerEvents.ManagePOM:FireServer(Key, "Space", v, Vector3.new(9999, 9999, 9999))
		end
	else
		takeNotification("Disconnected Messed up props", 2)
		for i, v in next, workspace.Items:GetChildren() do
			ServerEvents.MagnetMove:FireServer(Key, "Disconnect", v, Vector3.new(9999, 9999, 9999))
			ServerEvents.ManagePOM:FireServer(Key, "Disconnect", v)
		end
	end
end)
Props:addButton("Get Weapons", function()
	for i, v in next, workspace.Items:GetChildren() do
		if string.find(v.Name, "Item") then
			ServerEvents.MagnetMove:FireServer(Key, "Connect", v, Player.Character.HumanoidRootPart.Position)
			ServerEvents.MagnetMove:FireServer(Key, "Update", v, Player.Character.HumanoidRootPart.Position)
			ServerEvents.ManagePOM:FireServer(Key, "Connect", v)
			ServerEvents.ManagePOM:FireServer(Key, "Space", v, Player.Character.HumanoidRootPart.Position)
		end
	end
end)
Menu:addKeybind("Toggle Menu", Enum.KeyCode.RightControl, function() Window:toggle()end, function() end)
Env.rayWithDamage = function(len, spread, dmg, headshots, weapon, removeAmmo)
	return OEnv.rayWithDamage(500, Settings.NoSpread and 0.01 or spread, dmg, true, weapon, true)
end
setreadonly(Metatable, false)
Metatable.__index = newcclosure(function(Tab, Ind)
	if Ind == "Fall" and Settings.NoFall then
		return Instance.new("RemoteEvent")
	elseif Ind == "ErrorReport" then
		return Instance.new("RemoteEvent")
	elseif Ind == "Crush" and Settings.NoFall then
		return Instance.new("RemoteEvent")
	elseif Ind == "WalkSpeed" then
		return 16
	elseif Ind == "JumpPower" then
		return 21
	else
		return __index(Tab, Ind)
	end
end)
setreadonly(Metatable, true)
game:GetService("Players").PlayerAdded:Connect(DoP)
for i, v in next, game:GetService("Players"):GetPlayers() do
	DoP(v)
end
game:GetService("RunService").RenderStepped:Connect(function()
	if Player.Character then
		if Player.Character.Humanoid then
			Player.Character.Humanoid.WalkSpeed = Settings.WalkSpeed
			Player.Character.Humanoid.JumpPower = Settings.JumpPower
		end
	end
	if Settings.ESP then
		for i, v in next, game:GetService("Players"):GetChildren() do 
			if v.Character and v ~= Player then
				local PhoneticName = v.Data.PhoneticName
				if v.Character.HumanoidRootPart then
					local NameLabel = v.Character.HumanoidRootPart:FindFirstChild("NameLabel")
					if NameLabel then
						local Shadow = NameLabel:FindFirstChild("LabelShadow")
							if Shadow and Shadow:FindFirstChild("Label") then
							if Freekill[v.Name] then
								PhoneticName.Value = v.Name .. " " .. Freekill[v.Name]
								Shadow.Text = v.Name .. " " .. Freekill[v.Name]
								Shadow.Label.Text = v.Name .. " " .. Freekill[v.Name]
							else
								PhoneticName.Value = v.Name
								Shadow.Text = v.Name
								Shadow.Label.Text = v.Name
							end
							NameLabel.Enabled = true
						end
					end
				end
			end
		end
	end
end)
