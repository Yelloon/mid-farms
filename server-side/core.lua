-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION:HASPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.hasPermission(Perm)
    local source = source
    local Passport = vRPS.getUserId(source)

    if not Passport then return false end
    return vRPS.hasPermission(Passport,Perm)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION:PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Core.Payment(Name)
    print('[DEBUG] Chamou com o nome -> ', Name)
    local Passport = vRPS.getUserId(source)
    if not Passport then return end
    if not Core.hasPermission(Farms[Name]['Permission']) then 
        DropPlayer(source,'Tentando bugar o sistema.')
        return
    end

    for _, Item in pairs(Farms[Name]['Itens']) do
        local Amount = math.random(Farms[Name]['Amount'][1], Farms[Name]['Amount'][2])
        TriggerClientEvent("Notify",source,"sucesso","Parabens! Você recebeu "..Amount.."x "..Item)
        vRPS.giveInventoryItem(Passport, Item, Amount)
    end


    return true 
end 