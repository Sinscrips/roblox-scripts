-- YESYES DOGE AND SIN SCRIPT!!!!!!!!!!!!!!!!

--[[
[TO DO LIST]
- Trigger teleporter
- Anti bl/wl
- timeplayed bypass
- tag bypass
- trigger trigger
- change freecam speed
- name spoofer
- become mod
- set restart time
- break timer flag
--]]

local t = tick()

local ids = {
	[5315046213] = true, -- bhop_main
	[5315066937] = true, -- surf_main
	[252877716]= true,-- bhop_main_old
	[272689493]= true,-- surf_main_old
	[262118991]= true,-- bhop_dev
	[272689543]= true,-- surf_dev
	[517201717]= true,-- bhop_maptest
	[517206177]= true,-- surf_maptest
	[272689653]= true,-- test
	[5721760322] = true,-- dev
}

if ids[game.PlaceId] then -- go to surfhaxxAUTO
    local call
    local movement
    local add
    local mod
    local mapdata
    local mapdata2
    local mov
    local touch
    local try
    local pdata
    local styles
    local rp
    local jump
    local jp
    local fc
    local mult
    local ws
    local touch
    local ls
    local step
    local pause
    local mt
    local sens
    local fov
    local nw
    local ang
    --local dist

    for i,v in pairs(getgc(true)) do
        if type(v) == 'table' then
            if rawget(v, 'Call') and #getupvalues(rawget(v, 'Call')) then
                call = rawget(v, 'Call')
            end
            if rawget(v, 'GetVelocity') then
                movement = v
                if type(rawget(v, 'MovementTick')) == 'function' then
                    mt = rawget(v, 'MovementTick')
                end
            end
            if rawget(v, 'GetAngles') then
                ang = rawget(v, 'GetAngles')
            end
            if rawget(v, 'Add') and getinfo(v.Add).source:find('Command') then
                add = rawget(v, 'Add')
            end
            if rawget(v, 'SetGravity') then
                mod = v
            end
            if rawget(v, 'Sensitivity') then
                sens = v
            end
            if rawget(v, 'Trigger') then
                mapdata = v
            end
            if rawget(v, 'MapAnticheat') then
                mapdata2 = v
            end
            if rawget(v, 'UpdateMovement') and type(rawget(v, 'UpdateMovement')) == 'table' then
                mov = v
            end
            if rawget(v, 'TryParts') then
                try = rawget(v, 'TryParts')
            end
            if rawget(v, 'PartData') and type(rawget(v, 'PartData')) == 'function' then
                pdata = rawget(v, 'PartData')
            end
            if rawget(v, 'ActivateLoadingScreen') then
                ls = rawget(v, 'ActivateLoadingScreen')
            end
            if rawget(v, 7) then
                if type(v[1]) == 'table' and rawget(v[1], 'keys')then
                    styles = v
                end
            end
        elseif type(v) == 'function' and islclosure(v) and not is_synapse_function(v) then
            if getinfo(v).source:find('Movement') then
                if getinfo(v).name == 'ReplacePart' then
                    rp = v
                elseif getinfo(v).name == 'Jump' then
                    jump = v
                    jp = getupvalue(jump, 12)
                elseif getinfo(v).name == 'Step' then
                    step = v
                    --setconstant(step, 12, 'sinsane just fucked you xD')
                    --setconstant(step, 11, 'PartName') make parts with PartName == Surf
                    --setconstant(step, 16, 'PartName') ladder
                    --setconstant(step, 17, 'PartName') accelerator
                    --setconstant(step, 24, 'PartName') water
                elseif getinfo(v).name == 'Pause' then
                    pause = v
                else
                    if #getconstants(v) ~= 0 then
                        for i2,v2 in pairs(getconstants(v)) do  
                            if v2 == 'FreeCamGetMode' then
                                fc = v
                            elseif v2 == 2.7 then
                                mult = {[1] = v,[2] = i2,[3] = v2}
                            elseif v2 == 18 then
                                ws = {[1] = v,[2] = i2,[3] = v2}
                            elseif v2 == 1.4009999999999998 then
                                touch = v
                            end
                        end
                    end
                end
            elseif getinfo(v).source:find('LoadingScreen') then
                if #getconstants(v) ~= 0 then
                    for i2,v2 in pairs(getconstants(v)) do  
                        if v2 == '[LoadingScreen] PartData' then
                            ls2 = v
                        end
                    end
                end
            else
                if getinfo(v).name == 'GetNWFloat' then
                    nw = v
                end
            end
        end
    end

    warn('stole game funcs in '..tick() - t..' seconds')

    --setupvalue(mt, 19, val) [TIMESCALE WITH TIMER FLAGGED BYPASS]

    -- MAIN SCRIPT STARTS HERE
    local plr = game.Players.LocalPlayer
    local char
    if not game.Workspace:FindFirstChild('Characters') then
        char = plr.Character
    else
        char = game.Workspace.Characters:WaitForChild(plr.Name)
    end
    local fov = game.Workspace.Camera.FieldOfView

    local rs = game:GetService('RunService')
    local isclick = false
    local deb = false

    local trg = mapdata['Trigger']
    local jmp = mapdata['Jump']
    local infjump = false
    local isjumping = false

    

    local uis = game:GetService('UserInputService')
    local mouse = plr:GetMouse()
    local sqrt = math.sqrt
    local atan2 = math.atan2

    local a = 0x41
    local d = 0x44
    local w = 0x57
    local nulls = false
    local putbacka = false
    local putbackd = false
    local scale = 1

    local noclipWL = {
        'wall';
        'roof';
        'floor';
        'part';
        'mappart';
        'window';
        'invisiblepart';
        'union'
    }

    local isrightclick = false
    local isleftclick = false
    mouse.Button2Down:Connect(function()
        isrightclick = true
    end)
    mouse.Button2Up:Connect(function()
        isrightclick = false
    end)
    mouse.Button1Down:Connect(function()
        isleftclick = true
    end)
    mouse.Button1Up:Connect(function()
        isleftclick = false
    end)

    local main = plr.PlayerGui:FindFirstChild('QBox')
    local noticeFolder = Instance.new('Folder', main)
    noticeFolder.Name = 'Examples'
    local gui = Instance.new('Folder', main)
    gui.Name = 'Esp'
    
    -- FUNCTIONS

    -- MATH STUFF
    function getAngle(s)
        return atan2(2.7, s)
    end
    function getVel()
        return sqrt(movement.GetVelocity(plr).x ^ 2 + movement.GetVelocity(plr).z ^ 2)
    end

    -- -- FIND TIME
    -- function getTime()
    --     return getupvalue(pause, 3)
    -- end

    

    -- CHECK IF TABLE CONTAINS VALUE
    function checkTable(tab, val)
        for i,v in pairs(tab) do
            if v == val then
                return true
            end
        end
        return false
    end

    -- GET POSITIONS
    function plrpos()
        local curplr = string.split(tostring(char.HumanoidRootPart.CFrame), ', ')
    
        return Vector3.new(curplr[1], curplr[2], curplr[3])
    end
    function camerapos()
        local curcam = string.split(tostring(game.Workspace.Camera.CFrame), ', ')

        return Vector3.new(curcam[1], curcam[2], curcam[3])
    end

    function findDistance(pos1, pos2)
        return (pos1 - pos2).magnitude
    end

    -- GET PARTS TABLE
    data = getupvalue(touch, 1)
    spawn(function()
        repeat wait()
            parts = data['data']
        until parts
    end)

    -- TELEPORT PLR
    local restart = rawget(movement, 'SpawnCharacter')
    function teleport(pos) -- [PROBABLY A BETTER WAY TO DO THIS]
        local mstart = getupvalue(restart, 3)
        
        setupvalue(restart, 3, pos)
        restart()
        setupvalue(restart, 3, mstart)
    end

    -- FIND MAP
    local currentMap
    function findMap()
        for i,v in pairs(game.Workspace:GetChildren()) do
            if v.Name:find('surf_') or v.Name:find('bhop_') then
                return v
            end
        end
    end
    currentMap = tostring(findMap())
    spawn(function()
        while wait() do
            if currentMap ~= tostring(findMap()) then -- MAP WAS CHANGED
                notice('map changed lol')
                
                currentMap = tostring(findMap())
            end
        end
    end)

    -- NOTICE FUNC
    function notice(txt)
        call('Chatted', '/notice '..txt)
    end

    local BaseCameraDistance = findDistance(plrpos(), camerapos())

    for i,v in pairs(main.Frame:GetChildren()) do
        for i2, v2 in pairs(v:GetChildren()) do
            if v2.ClassName == 'TextLabel' then
                if v2.Text == 'Menu (Press M)' then
                    timer = v2
                elseif v2.Text == 'Chat' then
                    chat = v2
                elseif v2.Text:find('Player List') then
                    plist = v2
                elseif v2.Text == 'Change View(C)' then
                    spec = v2
                end
            end
        end
    end

    -- KEY BINDS
    local upd = rawget(movement, 'UpdatePart')
            
    --setupvalue(pdata, 26, nil)
    
    uis.InputBegan:Connect(function(input, gpi)
        if not gpi then

            -- RESTART
            if input.KeyCode == Enum.KeyCode.LeftShift then
                restart()

            -- MAPFINISH ESP
            elseif input.KeyCode == Enum.KeyCode.B then
                local mapstart = game.Workspace:FindFirstChild('MapStart', true)
                local mapend = game.Workspace:FindFirstChild('MapFinish', true)

                gui:ClearAllChildren()

                if not mapend:FindFirstChild('Distance') then

                    local start = Instance.new('BoxHandleAdornment', gui)
                    start.Name = 'Start'
                    start.Adornee = mapstart
                    start.Size = mapstart.Size
                    start.Transparency = .3
                    start.Color3 = Color3.fromRGB(0, 255, 0)
                    start.AlwaysOnTop = true
                    start.ZIndex = 0

                    local enddistance = Instance.new('BillboardGui', mapend)
                    enddistance.Name = 'Distance'
                    enddistance.AlwaysOnTop = true
                    enddistance.LightInfluence = 0
                    enddistance.Size = UDim2.new(0, 200, 0, 50)
                    local endlabel = Instance.new('TextLabel', enddistance)
                    endlabel.BackgroundTransparency = 1
                    endlabel.Font = 'SourceSansBold'
                    endlabel.TextStrokeTransparency = 0
                    endlabel.TextScaled = true
                    endlabel.TextColor3 = Color3.new(1, 1, 1)
                    endlabel.Size = UDim2.new(0, 200, 0, 50)
                    endlabel.Text = 'calculating...'
                    
                    spawn(function()
                        rs.RenderStepped:Connect(function()
                            local distanceplayerend = math.round(findDistance(char.HumanoidRootPart.Position, mapend.Position) * 10^2) * 10^-2
                            endlabel.Text = 'Distance: '..distanceplayerend
                        end)
                    end)

                    local finish = Instance.new('BoxHandleAdornment', gui)
                    finish.Name = 'Finish'
                    finish.Adornee = mapend
                    finish.Size = mapend.Size
                    finish.Transparency = .3
                    finish.Color3 = Color3.fromRGB(255, 0, 0)
                    finish.AlwaysOnTop = true
                    finish.ZIndex = 0

                else

                    mapend.Distance:Destroy()

                end

            -- TRANSPARENCY/DELETE
            elseif input.KeyCode == Enum.KeyCode.X then
                function check()
                    for i,v in pairs(main.Frame:GetChildren()) do
                        if v:FindFirstChild('ImageLabel') then
                            if v.Visible then
                                return false
                            end
                            return true
                        end
                    end
                    return true
                end
                if check() then
                    local target = mouse.Target
                    --target.Transparency = .5
                    if target.Parent.Name ~= plr.Name then
                        target:Destroy()
                    end
                    --[[for i,v in pairs(target:GetChildren()) do
                        if v:IsA('Decal') then
                            v:Destroy()
                        end
                    end--]]
                end

            -- FREECAM
            elseif input.KeyCode == Enum.KeyCode.F then
                if findDistance(plrpos(), camerapos()) ~= BaseCameraDistance then
                    cur = string.split(tostring(game.Workspace.Camera.CFrame), ', ')
        
                    teleport(camerapos())
                end
                fc()

            -- SPAWN PART
            elseif input.KeyCode == Enum.KeyCode.V then
                target = mouse.target
                
                local cp
                if not findMap():FindFirstChild('CustomParts') then
                    local cp = Instance.new('Folder', findMap())
                    cp.Name = 'CustomParts'
                end
                local part = Instance.new('Part', findMap():FindFirstChild('CustomParts')) --target:Clone()
                part.Parent = findMap():FindFirstChild('CustomParts')

                --parts[part] = parts[target]

                part.Position = mouse.Hit.p
                part.Transparency = 0
                part.CanCollide = true
                part.Anchored = true

                call('TryParts')

            -- INF JUMP
            elseif input.KeyCode == Enum.KeyCode.Space and infjump and getupvalue(jump, 6) == false then
                setupvalue(jump, 6, game.Workspace:FindFirstChild('Part', true))
                jump()
                if not isjumping then
                    isjumping = true
                    spawn(function()
                        repeat
                            if uis:IsKeyDown(Enum.KeyCode.Space) then
                                wait(0.7095)
                                if uis:IsKeyDown(Enum.KeyCode.Space) and infjump == true then
                                    setupvalue(jump, 6, game.Workspace:FindFirstChild('Part', true))
                                    jump()
                                end
                            end
                        until not uis:IsKeyDown(Enum.KeyCode.Space)
                        isjumping = false
                    end)
                end

            -- BOOSTER
            elseif input.KeyCode == Enum.KeyCode.K then
                call('Chatted', '/infjump')

            -- NOCLIP
            elseif input.KeyCode == Enum.KeyCode.N then
                call('Chatted', '/noclip')

             -- RESTART TIMER
            elseif input.KeyCode == Enum.KeyCode.R then
                call('Chatted', '/re')
            end
        end
    end)
    -- NULLS
    uis.InputBegan:Connect(function(i, gpi)
        if not gpi and nulls then
            if i.KeyCode == Enum.KeyCode.A then
                if uis:IsKeyDown(Enum.KeyCode.D) then
                    keyrelease(d)
                    if mode == 'Autohop' then
                        keyrelease(w)
                    end
                    putbackd = true
                end
            elseif i.KeyCode == Enum.KeyCode.D then
                if uis:IsKeyDown(Enum.KeyCode.A) then
                    keyrelease(a)
                    if mode == 'Autohop' then
                        keyrelease(w)
                    end
                    putbacka = true
                end
            end
        end
    end)
    uis.InputEnded:Connect(function(i, gpi)
        if not gpi and nulls then
            if i.KeyCode == Enum.KeyCode.A and putbackd then
                keypress(d)
                putbackd = false
            elseif i.KeyCode == Enum.KeyCode.D and putbacka then
                keypress(a)
                putbacka = false
            end
            if i.KeyCode == Enum.KeyCode.Space then
                keyrelease(a)
                keyrelease(d)
            end
        end
    end)

    -- SPAM
    getgenv().spam = function(msg, amt, delay)
        for i = 0, amt-1 do
            if string.sub(msg, 1, 1) == '/' then
                call('Chatted', msg)
            else
                call('Chatted', msg..string.rep(' ', i))
            end
            wait(delay or .05)
        end
    end

    -- [EXAMPLE:] add('COMMAND', {empty/'Integer'/'Boolean'/'Number'}, function)
    add('test', {'Integer'}, function(v1)
        print('test, '..tostring(v1))
    end)

    -- TP TO STAGE
    add('stage', {'Number'}, function(v1)
        print('Stage'..tostring(v1))
        if game.Workspace:FindFirstChild('Spawn'..tostring(v1), true) then
            teleport(game.Workspace:FindFirstChild('Spawn'..tostring(v1), true).Position + Vector3.new(0,1,0))
            return '[Stage]: Set to '..tostring(v1)
        else
            return '[Stage]: ERROR - Stage not found'
        end
    end)

    -- PART SPOOFER
    add('set', {'String', 'String'}, function(v1, v2)
        v3 = v1:lower()
        if v3 == 'surf' or v3 == 'surfs' then
            setconstant(step, 11, v2)
            return '[Part Data]: Set surfs to '..v2
        elseif v3 == 'ladder' or v3 == 'ladders' then
            setconstant(step, 16, v2)
            return '[Part Data]: Set ladders to '..v2
        else
            return '[Part Data]: Could not find data type '..v1
        end
    end)

    -- START TIME
    local StartTime = 0
    add('starttime', {'Number'}, function(v1)
        StartTime = v1
        return '[Timer]: Set starting time to '..tostring(v1)
    end)

    -- GRAVITY COMMAND
    local grav = rawget(mod, 'SetGravity')
    add('grav', {'Number'}, function(v1)
        grav(v1)
        return '[Gravity] '..tostring(v1)
    end)

    -- TIMER BREAKER
    local tmr = false
    add('timer', {}, function()
        tmr = not tmr
        return '[Timer]: Breaking set to '..tostring(tmr)
    end)

    -- -- RESET TIMER
    -- add('re', {}, function()
    --     --[[local start = game.Workspace:FindFirstChild('MapStart', true)
    --     local notstart = game.Workspace:FindFirstChild('MapFinish', true)
    --     call('LeaveZone', notstart, tick())
    --     call('EnterZone', start, tick())
    --     call('LeaveZone', start, getTime()-StartTime)--]]
    --     if not tmr then
    --         call('SetStartTime', getTime(), getTime()-StartTime)
    --     end
    --     return '[Timer]: Reset'
    -- end)

    -- FREECAM COMMAND
    add('fc', {}, function()
        if findDistance(plrpos(), camerapos()) ~= BaseCameraDistance then
            cur = string.split(tostring(game.Workspace.Camera.CFrame), ', ')

            teleport(camerapos())
        end
        fc()
    end)

    -- REJOIN
    local tp
    add('rejoin', {}, function()
        tp = game:GetService('TeleportService')
        tp:Teleport(game.PlaceId, plr)
    end)

    -- TIMER SPEED COMMAND
    add('ts', {'Number'}, function(v1)
        call('SetTimeScale', getTime(), v1)
        return '[Timer]: Speed set to '..tostring(v1)
        --scale = v1
    end)

    -- -- TIMESCALE TEST
    -- local cTimescale
    -- add('timesc', {'Number'}, function(v1)
    --     cTimescale = v1
    --     setupvalue(pause, 3, getTime()*v1)

    --     return '[Timescale]: Set to '..tostring(v1)
    -- end)

    -- TELEPORT PARTNAME
    add('tp', {'String'}, function(v1)
        if game.Workspace:FindFirstChild(v1, true) then
            teleport(game.Workspace:FindFirstChild(v1, true).Position)
        else
            return '[Teleport] Part does not exist'
        end 
    end)

    local clicktp
    add('clicltp', {}, function()
        clicktp = not clicktp
        return '[Teleport] Right click to teleport set to '..tostring(clicktp)
    end)
    mouse.Button1Down:Connect(function()
        if clicktp then
            teleport(mouse.Hit.p)
        end
    end)

    -- MAPFINDER
    add('m', {}, function()
        warn(findMap().Name)
    end)

    -- SPAM
    add('spam', {'String', 'Integer'}, function(v1, v2)
        spam(v1, v2)
    end)

    -- TRIGGER BREAKER
    add('triggers', {}, function()
        if mapdata['Trigger'] == 'fuck u' then
            mapdata['Trigger'] = trg
            return '[Trigger Breaker]: Off'
        else
            mapdata['Trigger'] = 'fuck u'
            return '[Trigger Breaker]: On'
        end
    end)

    -- JUMP LIMIT BREAKER
    add('jumps', {}, function()
        if mapdata['Jump'] == 'fuck u' then
            mapdata['Jump'] = jmp
            return '[Jump Platform Breaker]: Off'
        else
            mapdata['Jump'] = 'fuck u'
            return '[Jump Platform Breaker]: On'
        end
    end)

    -- SPEEDGAINS
    add('gains', {'Number'}, function(v1)
        setconstant(mult[1], mult[2], mult[3]*(v1 or 1))
        return '[Gains]: Set multiplier to '..v1 or 1
    end)

    -- WALKSPEED
    add('ws', {'Number'}, function(v1)
        setconstant(ws[1], ws[2], v1 or ws[3])
        return '[Walkspeed]: Set to '..v1
    end)

    -- JUMP
    add('jump', {'Number'}, function(v1)
        setupvalue(jump, 12, jp*v1 or jp)
        return '[Jump]: Set multiplier to '..v1
    end)
    
    -- ANTI-ANTICHEAT
    local ac
    add('anticheat', {}, function()
        mapdata2['MapAnticheat'] = ac
        ac = not ac
        return '[Anti-Anticheat]: '..tostring(ac)
    end)

    -- INF JUMP
    add('infjump', {}, function()
        infjump = not infjump
        return '[Infinite Jump]: '..tostring(infjump)
    end)

    -- CLEAR CUSTOM PARTS
    add('clear', {}, function()
        local cp = findMap():FindFirstChild('CustomParts')

        if cp then
            local num = #cp:GetChildren()
            cp:Destroy()
            return '[Clear]: Cleared '..tostring(num)..' parts'
        else
            return '[Clear] No parts to clear'
        end
    end)

    -- PROPERTY CHANGE
    add('part', {'String', 'String'}, function(v1, v2)
        if mouse.Target and not game.Players:FindFirstChild(mouse.Target.Parent.Name) then
            local v3 = v1:lower()

            if v3 == 'vel' or v3 == 'velocity' then
                local sep = string.split(v2, ',')
                val1 = tonumber(sep[1])
                val2 = tonumber(sep[2])    
                val3 = tonumber(sep[3])
                if val1 and val2 and val3 then
                    upd(mouse.Target, {Velocity = Vector3.new(val1, val2, val3)})
                    return '[Part Editor]: Set '..mouse.Target.Name..' velocity to '..val1..', '..val2..', '..val3
                else
                    return '[Part Editor]: ERROR - Values entered incorrectly'
                end

            elseif v3 == 'name' then
                local currentName = mouse.Target.Name
                upd(mouse.Target, {Name = v2})
                return '[Part Editor]: Set '..currentName..' name to '..v2

            elseif v3 == 'cc' or v3 == 'cancollide' then
                local val
                if v2:lower() == 'false' then
                    val = false
                elseif v2:lower() == 'true' then
                    val = true
                else
                    return '[Part Editor]: ERROR - Values entered incorrectly'
                end
                upd(mouse.Target, {CanCollide = val})
                return '[Part Editor]: Set '..mouse.Target.Name..' cancollide to '..v2

            elseif v3 == 'anchored' then
                local val
                if v2:lower() == 'false' then
                    val = false
                elseif v2:lower() == 'true' then
                    val = true
                else
                    return '[Part Editor]: ERROR - Values entered incorrectly'
                end
                upd(mouse.Target, {Anchored = val})
                return '[Part Editor]: Set '..mouse.Target.Name..' anchored to '..v2

            elseif v3 == 'size' then
                local sep = string.split(v2, ',')
                local val1 = tonumber(sep[1])
                local val2 = tonumber(sep[2])    
                local val3 = tonumber(sep[3])
                if val1 and val2 and val3 then
                    upd(mouse.Target, {Size = Vector3.new(val1, val2, val3)})
                    return '[Part Editor]: Set '..mouse.Target.Name..' size to '..val1..', '..val2..', '..val3
                else
                    return '[Part Editor]: ERROR - Values entered incorrectly'
                end

            elseif v3 == 'pos' or v3 == 'position' then
                local sep = string.split(v2, ',')
                local val1 = tonumber(sep[1])
                local val2 = tonumber(sep[2])    
                local val3 = tonumber(sep[3])
                if val1 and val2 and val3 then
                    upd(mouse.Target, {Position = Vector3.new(val1, val2, val3)})
                    return '[Part Editor]: Set '..tostring(mouse.Target)..' position to '..val1..', '..val2..', '..val3
                else
                    return '[Part Editor]: ERROR - Values entered incorrectly'
                end

            elseif v3 == 'color' then
                local sep = string.split(v2, ',')
                local val1 = tonumber(sep[1])
                local val2 = tonumber(sep[2])    
                local val3 = tonumber(sep[3])
                if val1 and val2 and val3 then
                    upd(mouse.Target, {Color = Color3.fromRGB(val1, val2, val3)})
                    return '[Part Editor]: Set '..mouse.Target.Name..' color to '..val1..', '..val2..', '..val3
                else
                    return '[Part Editor]: ERROR - Values entered incorrectly'
                end

            elseif v3 == 'shape' then
                local pshape = string.sub(v2:lower(), 1, 1):upper()..string.sub(v2, 2)
                upd(mouse.Target, {Shape = pshape})
                return '[Part Editor]: Set '..mouse.Target.Name..' shape to '..v2
            elseif v3 == 'trans' or v3 == 'transp' or v3 == 'transparency' then
                upd(mouse.Target, {Transparency = tonumber(v2)})
                return '[Part Editor]: Set '..mouse.Target.Name..' transparency to '..tostring(v2)

            elseif v3 == 'orientation' or v3 == 'rotation' then
                local sep = string.split(v2, ',')
                local val1 = tonumber(sep[1])
                local val2 = tonumber(sep[2])    
                local val3 = tonumber(sep[3])
                if val1 and val2 and val3 then
                    upd(mouse.Target, {Orientation = Vector3.new(val1, val2, val3)})
                    return '[Part Editor]: Set '..mouse.Target.Name..' orientation to '..val1..', '..val2..', '..val3
                else
                    return '[Part Editor]: ERROR - Values entered incorrectly'
                end

            end

        else
            return '[Part Editor]: ERROR - Attempt to edit character ('..mouse.Target.Parent.Name..')'
        end
    end)

    

    -- MOVING PART BREAKER
    local oldmov = mov['UpdateMovement']
    local movp
    add('mov', {}, function()
        movp = not movp
        if movp then
            mov['UpdateMovement'] = {}
        else
            mov['UpdateMovement'] = oldmov
        end
        return '[Moving Parts]: '..tostring(not movp)
    end)

    -- KEYS BREAKER
    keys = false
    sty = {
        { -- AUTOHOP
            w = 1, 
            a = 1, 
            s = 1, 
            d = 1
        };
        { -- SCROLL
			w = 1, 
			a = 1, 
			s = 1, 
			d = 1
		};
        { -- SIDEWAYS
            w = 1, 
            a = 0, 
            s = 1, 
            d = 0
        };
        { -- HALF SIDEWAYS
			w = 2, 
			a = 1, 
			s = 0, 
			d = 1
        };
        { -- W ONLY
			w = 1, 
			a = 0, 
			s = 0, 
			d = 0
        };
        { -- A ONLY
			w = 0, 
			a = 2, 
			s = 0, 
			d = 0
        };
        { -- BACKWARDS
			w = 0, 
			a = 1, 
			s = 0, 
			d = 1
		}
    }
    add('keys', {}, function()
        if not keys then
            for i,v in pairs(styles) do
                v['keys'] = {
                    w = 1, 
                    a = 1, 
                    s = 1, 
                    d = 1
                }
            end
        else
            for i,v in pairs(styles) do
                v['keys'] = sty[i]
            end
        end
        keys = not keys
        return '[Keys]: '..tostring(keys)
    end)

    -- (testing)
    add('test', {'String', 'Number'}, function(v1, v2)
        test()
        return '[Test]: '..v1, v2
    end)
    add('print', {'String'}, function(v1)
        print(v1)
    end)

    -- NOTICE
    add('notice', {'String'}, function(v1)
        return v1
    end)
    
    -- NULLS
    local var
    add('nulls', {'String'}, function(v1)
        local v2 = v1:lower()
        
        if v2 == 'false' or v2 == 'off' then
            var = false
        elseif v2 == 'true' or v2 == 'on' then
            var = true
        else
            var = not var
        end
        nulls = var
        return '[Nulls]: Set to '..tostring(var)
    end)
    add('nulls', {}, function()
        var = not var
        nulls = var
        return '[Nulls]: Set to '..tostring(var)
    end)

    -- CAMERA INVERT
    local cameraMode = 'Autohop'
    add('cam', {'String'}, function(v1)
        v2 = v1:lower()
        if v2 == 'a' or v2 == 'autohop' then
            cameraMode = 'Autohop'
        elseif v2 == 'bw' or v2 == 'backwards' then
            cameraMode = 'Backwards'
        elseif v2 == 'sw' or v2 == 'sideways' then
            cameraMode = 'Sideways'
        end
        return '[Camera]: Set mode to '..cameraMode
    end)

    -- NOCLIP
    add('noclip', {}, function()
        noclip = not noclip
        return '[Noclip] Set to '..tostring(noclip)
    end)

    -- LIGHTING
    add('shadows', {}, function()
        game.Lighting.GlobalShadows = not game.Lighting.GlobalShadows
        return '[Shadows]: '..tostring(game.Lighting.GlobalShadows)
    end)

-- HOOKS/METATABLES

    local m = getrawmetatable(game)
    setreadonly(m, false)

    local oldIndex = m.__index
    local oldNewIndex = m.__newindex

    -- TIMESCALE LEGIT
    --[[tshook = hookfunc(tick, function()
        return tick()/scale
    end)--]]

    -- -- TIMER BREAKER
    -- spawn(function()
    --     thook = hookfunc(call, function(...)
    --         local args = {...}
    --         if tmr then 
    --             if args[1] == 'LeaveZone' and tostring(args[2]) == 'MapStart' then
    --                 args[2] = 'EnterZone'
    --             elseif args[1] == 'VState' and args[3] == true then
    --                 args[3] = false
    --             end
    --         end
    --         return thook(unpack(args)) 
    --     end)
    -- end)
    -- spawn(function()
    --     thook2 = hookfunc(call, function(...)
    --         local args = {...}
    --         if args[1] == 'VState' and args[3] == true then
    --             args[2] = getTime() - StartTime
    --         end
    --         return thook2(unpack(args)) 
    --     end)
    -- end)


    -- NOCLIP (hook version)
    touchHook = hookfunc(touch, function(...)
        local args = {...}
        local part = args[1]
        local cp = findMap():FindFirstChild('CustomParts')

        if noclip then
            if (part:IsA('BasePart') or part.ClassName:find('Union')) and (part.Velocity == Vector3.new(0,0,0)) and (checkTable(noclipWL, part.Name:lower())) or part.Name:find('solid') or (part.Transparency ~= 0 and not (part.Name:lower():find('mapstart') or part.ClassName == 'WedgePart' or part.Name:lower():find('mapfinish') or part.Name:lower():find('jump') or part.Name:lower():find('spawn') or part.Name:lower():find('teleport'))) then
                return
            end
        end
        --[[if cp then
            for i,v in pairs(cp:GetChildren()) do
                if part == v then
                    v1, v2, v3 = dist(part, char.HumanoidRootPart.Position)
                    args[2] = {[part] = { v1, v2, v3 }}
                end
            end
        end--]]
        return touchHook(unpack(args))
    end)

    -- REPLACE PART BREAKER
    spawn(function()
        rphook = hookfunc(rp, function(...)
            return
        end)
    end)

    -- SPAWN PART
    parthook = hookfunc(try, function(...)
        local args = {...}
        if findMap():FindFirstChild('CustomParts') then
            for i,v in pairs(findMap():FindFirstChild('CustomParts'):GetChildren()) do
                table.insert(args[1], #args[1]+1, v)
            end
        end
        return parthook(unpack(args))
    end)
    parthook2 = hookfunc(pdata, function(...)
        local args = {...}
        customparts = findMap():FindFirstChild('CustomParts') 

        if customparts then
            for i,v in pairs(args) do
                local customparts = findMap():FindFirstChild('CustomParts')

                if i == 1 then -- part

                    for x,z in pairs(customparts:GetChildren()) do
                        table.insert(args[i], #args[i]+1, z.Name)
                    end

                elseif i == 2 then -- size

                    for x,z in pairs(customparts:GetChildren()) do
                        table.insert(args[i], #args[i]+1, z.Size)
                    end

                elseif i == 3 then -- shape

                    for x,z in pairs(customparts:GetChildren()) do
                        table.insert(args[i], #args[i]+1, z.Shape)
                    end

                elseif i == 4 then -- CFrame

                    for x,z in pairs(customparts:GetChildren()) do
                        table.insert(args[i], #args[i]+1, z.CFrame)
                    end

                elseif i == 5 then -- velocity

                    for x,z in pairs(customparts:GetChildren()) do
                        table.insert(args[i], #args[i]+1, z.Velocity)
                    end

                elseif i == 6 then -- idk

                    for x,z in pairs(customparts:GetChildren()) do
                        table.insert(args[i], #args[i]+1, true)
                    end

                elseif i == 7 then -- rotvelocity?

                    for x,z in pairs(customparts:GetChildren()) do
                        table.insert(args[i], #args[i]+1, z.Velocity)
                    end
                    
                end
            end
        end
        return parthook2(unpack(args))
    end)
    loadingScreenHook = hookfunc(ls2, function(...)
        local args = {...}

        args[2] = 2

        return loadingScreenHook(unpack(args))
    end)

    -- CAMERA BREAKER
    m.__newindex = function(t, k, v)
        if k == 'CoordinateFrame' then
            if cameraMode == 'Backwards' then
                v = v * CFrame.fromEulerAnglesXYZ(0, math.rad(-180), 0)
            elseif cameraMode == 'Sideways' then           
                v = v * CFrame.fromEulerAnglesXYZ(0, math.rad(-90), 0)
            end
        end
        return oldNewIndex(t, k, v)
    end

-- MAIN SCRIPT ENDS HERE

    keybindcommands = {
        '[KEYBIND COMMANDS]:';
        'shift - restart';
        'f - freecam teleport';
        'b - show map finish';
        'x - delete part';
        'k - inf jump';
        'n - noclip';
        'v - spawn part (may take a few seconds to process)';
        'r - reset timer'
    }
    customcommandlist = {
        '[CUSTOM COMMANDS]';
        '/notice <string> (output a notice message to the chat)';
        '/grav <number> (change gravity)';
        '/spam <string> <int> (spam a message a number of times)';
        '/ts <number> (set timer speed)';
        '/timer (break timer)';
        '/tp <string> (teleport to part with specific name)';
        '/clicktp (right click tp mode)';
        '/triggers (switch all triggers)';
        '/gains <int> (set gains)';
        '/ws <int> (set walkspeed)';
        '/shadows (switch shadows for visibility)';
        '/jump <int> (set jump multiplier)';
        '/jumps (breaks jump limiter)';
        '/infjump (jump infinitely)';
        '/rejoin (rejoin game)';
        '/re (reset timer)';
        '/clear (clear all custom parts)';
        '/keys (allows use of all keys in any style)';
        '/part <property> <value> (set part property value)';
        '/nulls <state [on|off]> (switch nulls)';
        '/noclip (switch noclipping)';
        '/anticheat (breaks anticheat)';
        '/mov (disable moving parts)';
        '/cam <string [auto|bw|sw]> (flip camera for dif styles)';
        '/stage <number> (set current stage)';
        '/set <string> <string> (edit part data)';
        '/starttime <number> (set start time)';
    }                                                                                                                             
    local str = ''
    local str2 = ''
    for i,v in pairs(keybindcommands) do
        str = str..v..'\n'
    end
    for i,v in pairs(customcommandlist) do
        str2 = str2..v..'\n'
    end

    -- CUSTOM COMMAND LIST
    add('ccmds', {}, function()
        notice(str)
        notice(str2)
    end)

    notice(str)
    notice(str2)

    notice('All credits to Sinsane and veryunhappydoge!')

else
    warn('not bhop/surf')
end