-- Сохрани этот код на pastebin.com и используй ссылку в loadstring
local a=game:GetService("Players")
local b=a.LocalPlayer 
local c=Instance.new("Folder",game.CoreGui)
c.Name="ESP"
_G.FriendColor=Color3.fromRGB(0,255,0)
_G.EnemyColor=Color3.fromRGB(255,0,0)
_G.MaxPlayers=10 
_G.MaxDistance=250 

local d={}
local function e(f)
    if not b.Character then return math.huge end
    if not f.Character then return math.huge end
    local g=b.Character:FindFirstChild("HumanoidRootPart")
    local h=f.Character:FindFirstChild("HumanoidRootPart")
    if not g or not h then return math.huge end
    return (g.Position-h.Position).Magnitude 
end

local function i()
    local j=a:GetPlayers()
    for k=#d,1,-1 do d[k]=nil end
    for l,f in pairs(j) do 
        if f~=b and f.Character then 
            local m=e(f)
            if m<=_G.MaxDistance then 
                table.insert(d,{player=f,distance=m})
            end 
        end 
    end
    table.sort(d,function(n,o)return n.distance<o.distance end)
end

local function p(f)
    for q=1,math.min(_G.MaxPlayers,#d) do 
        if d[q] and d[q].player==f then 
            return true 
        end 
    end
    return false 
end

local function r(f,s)
    if not p(f) then 
        if f.Character and f.Character:FindFirstChild("GetReal") then 
            f.Character.GetReal:Destroy()
        end
        return 
    end
    
    if f.Character then 
        if not f.Character:FindFirstChild("GetReal") then 
            local t=Instance.new("Highlight")
            t.Name="GetReal"
            t.Adornee=f.Character
            t.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
            if f.Team==nil then 
                t.FillTransparency=1
                t.OutlineColor=_G.FriendColor
            else 
                t.FillColor=s
                t.FillTransparency=0.5
                t.OutlineColor=s
            end
            t.Parent=f.Character
        else 
            if f.Team==nil then 
                f.Character.GetReal.FillTransparency=1
                f.Character.GetReal.OutlineColor=_G.FriendColor
            else 
                f.Character.GetReal.FillColor=s
                f.Character.GetReal.OutlineColor=s
            end
        end
    end
end

for l,f in pairs(a:GetPlayers()) do 
    if f~=b then 
        spawn(function()
            wait()
            pcall(function()
                local u=Instance.new("Folder",c)
                u.Name=f.Name
                f.CharacterAdded:Connect(function()
                    wait(0.5)
                    i()
                    if p(f) then 
                        r(f,_G.EnemyColor)
                    end
                end)
                f.CharacterRemoving:Connect(function()
                    if f.Character and f.Character:FindFirstChild("GetReal") then 
                        f.Character.GetReal:Destroy()
                    end
                end)
                if f.Character and p(f) then 
                    r(f,_G.EnemyColor)
                end
            end)
        end)
    end 
end

a.PlayerAdded:Connect(function(f)
    wait(0.5)
    pcall(function()
        local u=Instance.new("Folder",c)
        u.Name=f.Name
        f.CharacterAdded:Connect(function()
            wait(0.5)
            i()
            if p(f) then 
                r(f,_G.EnemyColor)
            end
        end)
    end)
end)

a.PlayerRemoving:Connect(function(f)
    if f.Character and f.Character:FindFirstChild("GetReal") then 
        f.Character.GetReal:Destroy()
    end
end)

local v=0
while task.wait(0.2) do 
    if tick()-v>=0.5 then 
        i()
        v=tick()
        for q=1,math.min(_G.MaxPlayers,#d) do 
            local w=d[q]
            if w and w.player then 
                r(w.player,_G.EnemyColor)
            end
        end
    end
end
