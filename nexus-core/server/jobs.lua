local Jobs = {
    _jobs = {},
    _jobGrades = {}
}

-- Load jobs from database
function Jobs.LoadJobs()
    local jobData = MySQL.query.await('SELECT * FROM jobs')
    local gradeData = MySQL.query.await('SELECT * FROM job_grades')
    
    for _, job in ipairs(jobData) do
        Jobs._jobs[job.name] = job
        Jobs._jobs[job.name].grades = {}
    end
    
    for _, grade in ipairs(gradeData) do
        if Jobs._jobs[grade.job_name] then
            Jobs._jobs[grade.job_name].grades[grade.grade] = grade
        end
    end
end

-- Set player job
function Jobs.SetJob(playerId, jobName, grade)
    grade = grade or 0
    
    if Jobs._jobs[jobName] and Jobs._jobs[jobName].grades[grade] then
        MySQL.update.await('UPDATE players SET job = ?, job_grade = ? WHERE id = ?', {jobName, grade, playerId})
        
        local player = NexusCore.Players.Get(playerId)
        if player then
            player.job = jobName
            player.job_grade = grade
            TriggerClientEvent('nexus:client:jobUpdated', playerId, jobName, grade)
        end
        return true
    end
    return false
end

-- Get player job
function Jobs.GetJob(playerId)
    local player = NexusCore.Players.Get(playerId)
    if player then
        return player.job, player.job_grade
    end
    return nil, 0
end

-- Get job details
function Jobs.GetJobDetails(jobName)
    return Jobs._jobs[jobName]
end

return Jobs