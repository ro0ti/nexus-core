local Keys = {}

function Keys.AddKey(citizenid, houseId)
    MySQL.insert('INSERT INTO house_keys (citizenid, house_id) VALUES (?, ?)', {
        citizenid, houseId
    })
end

function Keys.RemoveKey(citizenid, houseId)
    MySQL.update('DELETE FROM house_keys WHERE citizenid = ? AND house_id = ?', {
        citizenid, houseId
    })
end

function Keys.HasKey(citizenid, houseId)
    local result = MySQL.scalar.await('SELECT 1 FROM house_keys WHERE citizenid = ? AND house_id = ?', {
        citizenid, houseId
    })
    return result ~= nil
end

return Keys