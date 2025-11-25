-- qb-adminped/client.lua

local QBCore = exports['qb-core']:GetCoreObject()

local originalAppearance = nil

local function SaveCurrentAppearance()
    local ped = PlayerPedId()
    originalAppearance = {
        model = GetEntityModel(ped),
        components = {},
        props = {}
    }

    -- Componentes de ropa
    for i = 0, 11 do
        originalAppearance.components[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture  = GetPedTextureVariation(ped, i),
            palette  = GetPedPaletteVariation(ped, i)
        }
    end

    -- Props (gafas, gorra, etc.)
    for i = 0, 7 do
        originalAppearance.props[i] = {
            index   = GetPedPropIndex(ped, i),
            texture = GetPedPropTextureIndex(ped, i)
        }
    end
end

local function ApplyAppearance(app)
    if not app then return end

    local player = PlayerId()
    local ped    = PlayerPedId()

    -- Volver al modelo original si hace falta
    if GetEntityModel(ped) ~= app.model then
        RequestModel(app.model)
        while not HasModelLoaded(app.model) do
            Wait(10)
        end

        SetPlayerModel(player, app.model)
        ped = PlayerPedId()
        SetModelAsNoLongerNeeded(app.model)
    end

    -- Ropa
    for compId, comp in pairs(app.components or {}) do
        SetPedComponentVariation(
            ped,
            compId,
            comp.drawable or 0,
            comp.texture or 0,
            comp.palette or 0
        )
    end

    -- Props
    for propId, prop in pairs(app.props or {}) do
        if prop.index and prop.index ~= -1 then
            SetPedPropIndex(ped, propId, prop.index, prop.texture or 0, true)
        else
            ClearPedProp(ped, propId)
        end
    end
end

-- Cambiar a PED admin
RegisterNetEvent('qb-adminped:client:setPed', function(modelName)
    local pedHash = GetHashKey(modelName)

    if not IsModelInCdimage(pedHash) or not IsModelValid(pedHash) then
        QBCore.Functions.Notify('Modelo de PED no válido: ' .. modelName, 'error')
        return
    end

    -- Solo guardamos la apariencia original la primera vez
    if not originalAppearance then
        SaveCurrentAppearance()
    end

    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do
        Wait(10)
    end

    SetPlayerModel(PlayerId(), pedHash)
    local ped = PlayerPedId()
    SetPedDefaultComponentVariation(ped)
    SetModelAsNoLongerNeeded(pedHash)

    QBCore.Functions.Notify('PED cambiado a ' .. modelName .. '. Usa /revertped para volver al original.', 'success')
end)

-- Volver al PED original
RegisterNetEvent('qb-adminped:client:revertPed', function()
    if not originalAppearance then
        QBCore.Functions.Notify('No hay ninguna apariencia guardada para restaurar.', 'error')
        return
    end

    ApplyAppearance(originalAppearance)
    originalAppearance = nil

    QBCore.Functions.Notify('Se ha restaurado tu PED y vestimenta original.', 'success')
end)
