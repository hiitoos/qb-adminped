local QBCore = exports['qb-core']:GetCoreObject()

-- Usa ACE + QBCore: será admin si:
--  - Tiene permiso ACE "command" (group.admin en tu server.cfg)
--  - O tiene permiso QBCore 'god' o 'admin'
local function IsAdmin(src)
    if QBCore and QBCore.Functions and QBCore.Functions.HasPermission then
        if QBCore.Functions.HasPermission(src, 'god')
        or QBCore.Functions.HasPermission(src, 'admin') then
            return true
        end
    end

    -- Esto encaja EXACTO con tu cfg:
    -- add_ace group.admin command allow
    -- add_principal identifier.license:... group.admin
    if IsPlayerAceAllowed(src, 'command') then
        return true
    end

    return false
end

-- /setped <modelo>
QBCore.Commands.Add('setped', 'Cambia tu PED temporalmente (solo admins)', {
    { name = 'model', help = 'Nombre del modelo de PED (ej: s_m_y_cop01)' }
}, false, function(source, args)
    local src = source

    if not IsAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, 'No tienes permisos para usar este comando.', 'error')
        return
    end

    local model = args[1]
    if not model or model == '' then
        TriggerClientEvent('QBCore:Notify', src, 'Debes indicar el nombre del modelo de PED.', 'error')
        return
    end

    -- Pide al cliente que guarde su outfit y cambie de modelo
    TriggerClientEvent('qb-adminped:client:setPed', src, model)
end, 'user')   -- IMPORTANTE: 'user' para que QBCore no bloquee el comando

-- /revertped
QBCore.Commands.Add('revertped', 'Restaura tu PED y ropa original (solo admins)', {}, false, function(source )
    local src = source

    if not IsAdmin(src) then
        TriggerClientEvent('QBCore:Notify', src, 'No tienes permisos para usar este comando.', 'error')
        return
    end

    TriggerClientEvent('qb-adminped:client:revertPed', src)
end, 'user')   -- También 'user', controlamos permisos nosotros
