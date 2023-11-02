local db = {}
db.select = function(query, params)
    return MySQL.query.await(query, params)
end

return db