-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Time = GetGameTimer()
local Ped = PlayerPedId()
local InService = false
RegisterKeyMapping('Start:Farms', 'Iniciar farm', 'keyboard', 'E')
RegisterKeyMapping('Collect:Farms', 'Coletar', 'keyboard', 'E')
RegisterKeyMapping('Exit:Farms', 'Sair', 'keyboard', 'F7')
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD:MARKERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    local Sleep = 1
    while true do
        local PedCoords = GetEntityCoords(Ped)
        for Name, Config in pairs(Farms) do
            for _, Coord in ipairs(Config['Start']) do
                if #(PedCoords - vec3(Coord[1], Coord[2], Coord[3])) < Distance then 
                    Sleep = 0 
                    DrawMarker(1, Coord[1], Coord[2], Coord[3] - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 100, 0, 0, 0, 0)
                end
            end
        end
        Wait(Sleep * 1000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND:STARTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('Start:Farms', function()
    if GetEntityHealth(Ped) <= 101 then return end
    if IsPedInAnyVehicle(Ped, false) then return end
    if GetGameTimer() < Time then return end

    local PedCoords = GetEntityCoords(Ped)

    for Name, Config in pairs(Farms) do
        for _, Coord in ipairs(Config['Start']) do
            if #(PedCoords - vec3(Coord[1], Coord[2], Coord[3])) < 2.0 then
                if Server.hasPermission(Config['Permission']) then 
                    if InService then TriggerEvent("Notify","negado","Você já esta em serviço", 5000)  return end
                    Time = GetGameTimer() + 1000
                    Core.StartService(Name)
                else
                    TriggerEvent('Notify', 'negado', 'Não possui permissão.', 5000)
                end
            end
        end
    end
end, false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION:STARTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.StartService(Name)
    InService = true
    Core.NextRoute()

    print('[DEBUG] Você entrou em serviço -> ', Name)

    CreateThread(function()
        Core.MessageScreen()
    end)

    CreateThread(function()
        Core.RouteThread(Name)
    end)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION:NEXTROUTE
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.NextRoute()
    Route = Routes[math.random(1, #Routes)]
    SetNewWaypoint(Route[1], Route[2])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD:COLLECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.RouteThread(Name)
    while InService do
        local Sleep = 1
        local Distance = #(GetEntityCoords(Ped) - vec3(Route[1], Route[2], Route[3]))

        if Distance <= 20 then 
            Sleep = 0
            DrawText3D(Route[1], Route[2], Route[3], "[~g~E~w~] COLETAR")

            if Distance <= 1.5 then
                if IsControlJustPressed(1, 38) then
            
                    RequestAnimDict("amb@prop_human_bum_bin@idle_b")
                    while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
                        Wait(100)
                    end
                
                    TaskPlayAnim(Ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, -8.0, 15000, 1, 0, false, false, false)
                    FreezeEntityPosition(Ped, true) 
                
                    Wait(TimeWait)
                
                    ClearPedTasks(Ped)
                    FreezeEntityPosition(Ped, false)

                    if Server.Payment(Name) then
                        print('[DEBUG] Você coletou um item da rota -> ', Name)
                        Core.NextRoute()
                    end
                end 
            end
        end

        Wait(Sleep * 1000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD:MESSAGESCREEN
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.MessageScreen()
    while InService do 
        DrawTextScreen("PRESSIONE ~g~[F7] ~w~PARA CANCELAR A COLETA")
        Wait(1)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND:STOPSERVICESTARTSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('Exit:Farms', function()
    if GetEntityHealth(Ped) <= 101 then return end

    if InService then
        InService = false
        Route = nil
    end
end, false)