local Job = {
    _currentJob = nil,
    _onDuty = false
}

-- Set job
function Job.SetJob(jobName, grade)
    Job._currentJob = jobName
    Job._grade = grade
    NexusCore.TriggerServerCallback('nexus:server:setJob', jobName, grade)
end

-- Toggle duty
function Job.ToggleDuty()
    Job._onDuty = not Job._onDuty
    NexusCore.TriggerServerCallback('nexus:server:toggleDuty', Job._onDuty)
    
    if Job._onDuty then
        NexusCore.UI.ShowNotification('You are now on duty')
    else
        NexusCore.UI.ShowNotification('You are now off duty')
    end
end

-- Job specific functions
function Job.StartWork()
    if not Job._currentJob or not Job._onDuty then return end
    
    -- Job specific logic
    if Job._currentJob == 'police' then
        -- Police job actions
    elseif Job._currentJob == 'mechanic' then
        -- Mechanic job actions
    end
end

-- Export
exports('Job', function()
    return Job
end)