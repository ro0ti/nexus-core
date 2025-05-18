local Voice = {}

function Voice.SetVoiceMode(mode)
    local modes = {
        ['normal'] = { range = 5.0, key = 'n' },
        ['shout'] = { range = 12.0, key = 'h' },
        ['whisper'] = { range = 2.0, key = 'b' }
    }
    
    if modes[mode] then
        exports['pma-voice']:setVoiceProperty('voiceMode', mode)
        NexusCore.UI.ShowNotification(('Voice mode set to %s (Range: %sm)'):format(
            mode, modes[mode].range
        ))
    end
end

-- Voice proximity toggle
RegisterCommand('voiceproximity', function()
    local currentMode = exports['pma-voice']:getVoiceProperty('voiceMode')
    local nextMode = currentMode == 'normal' and 'shout' or currentMode == 'shout' and 'whisper' or 'normal'
    Voice.SetVoiceMode(nextMode)
end, false)

exports('SetVoiceMode', Voice.SetVoiceMode)