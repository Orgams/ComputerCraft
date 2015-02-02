os.loadAPI("API/api")
api.initisalisation("log")

function contains(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then 
            return true 
        end
    end
    return false
end

function toString(tbl)
    local res = "{"
    local sep = ""
    for k,v in pairs(tbl) do
        local val = v
        if isTable(v) then
            val = toString(v)
        end
        val = "["..k.."]="..val
        res = res..sep..val
        sep = ","
    end
    res = res.."}"
    return res
end

function isTable(tab)
    return type(tab) == "table"
end

function clone(tab)
    local res = {}
    for k,v in pairs(tab) do
        val = v
        if isTable(v) then
            val = clone(v)
        end
        res[k] = val;
    end
    return res
end