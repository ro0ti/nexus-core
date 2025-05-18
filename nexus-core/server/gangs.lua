local Gangs = {
    _gangs = {},
    _gangGrades = {}
}

-- Load gangs from database
function Gangs.LoadGangs()
    local gangData = MySQL.query.await('SELECT * FROM gangs')
    local gradeData = MySQL.query.await('SELECT * FROM gang_grades')
    
    for _, gang in ipairs(gangData) do
        Gangs._gangs[gang.name] = gang
        Gangs._gangs[gang.name].grades = {}
    end
    
    for _, grade in ipairs(gradeData) do
        if Gangs._gangs[grade.gang_name] then
            Gangs._gangs[grade.gang_name].grades[grade.grade] = grade
        end
    end
end

-- Set player gang
function Gangs.SetGang(playerId, gangName, grade)
    grade = grade or 0
    
    if Gangs._gangs[gangName] and Gangs._gangs[gangName].grades[grade] then
        MySQL.update.await('UPDATE players SET gang = ?, gang_grade = ? WHERE id = ?', {gangName, grade, playerId})
        
        local player = NexusCore.Players.Get(playerId)
        if player then
            player.gang = gangName
            player.gang_grade = grade
            TriggerClientEvent('nexus:client:gangUpdated', playerId, gangName, grade)
        end
        return true
    end
    return false
end

-- Get player gang
function Gangs.GetGang(playerId)
    local player = NexusCore.Players.Get(playerId)
    if player then
        return player.gang, player.gang_grade
    end
    return nil, 0
end

return Gangs