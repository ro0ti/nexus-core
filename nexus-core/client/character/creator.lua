local CharacterCreator = {
    CurrentCharacter = {},
    IsCreating = false,
    Cam = nil,
    ResourceName = GetCurrentResourceName()
}

function CharacterCreator.StartCreation()
    if CharacterCreator.IsCreating then return end
    
    CharacterCreator.IsCreating = true
    SetNuiFocus(true, true)
    
    -- Setup camera
    CharacterCreator.Cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamActive(CharacterCreator.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    
    -- Send data to NUI
    SendNUIMessage({
        action = 'openCreator',
        components = Config.CharacterComponents
    })
end

function CharacterCreator.Finalize(data)
    if not data or type(data) ~= 'table' then
        return false
    end
    
    -- Validate required fields
    local required = {'firstname', 'lastname', 'gender', 'dob'}
    for _, field in ipairs(required) do
        if not data[field] then
            return false
        end
    end
    
    -- Save character
    TriggerServerEvent('nexus:character:create', data)
    return true
end

-- NUI Callbacks
RegisterNUICallback('createCharacter', function(data, cb)
    local success = CharacterCreator.Finalize(data)
    cb({success = success})
end)

RegisterNUICallback('closeCreator', function(_, cb)
    CharacterCreator.Cleanup()
    cb({})
end)

function CharacterCreator.Cleanup()
    if CharacterCreator.Cam then
        DestroyCam(CharacterCreator.Cam)
        RenderScriptCams(false, false, 0, true, true)
    end
    
    SetNuiFocus(false, false)
    CharacterCreator.IsCreating = false
end

-- Command
RegisterCommand('createcharacter', function()
    CharacterCreator.StartCreation()
end, false)

-- Event Handlers
AddEventHandler('onResourceStop', function(resource)
    if resource == CharacterCreator.ResourceName then
        CharacterCreator.Cleanup()
    end
end)