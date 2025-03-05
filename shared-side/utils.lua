if not IsDuplicityVersion() then -- IsDuplicityVersion = faz função do Server // Se for falso faz funcao do client 		
    function DrawText3D(X, Y, Z, Text)
        local Visible, DisplayX, DisplayY = GetScreenCoordFromWorldCoord(X, Y, Z)
    
        if Visible then
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringKeyboardDisplay(Text)
            SetTextColour(255,255,255,150)
            SetTextScale(0.35,0.35)
            SetTextFont(4)
            SetTextCentre(1)
            EndTextCommandDisplayText(DisplayX, DisplayY)
        end
    end
    
    function DrawTextScreen(Message)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextScale(0.5, 0.5) 
        SetTextColour(255, 255, 255, 255)
        SetTextDropShadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextOutline()

        SetTextEntry("STRING")
        AddTextComponentString(Message)
        DrawText(0.02, 0.95) 
    end
end