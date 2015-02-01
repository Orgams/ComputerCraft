os.loadAPI("API/api")
api.initisalisation("log","table")

function toString(tbl)
    local res = "{"
    local sep = ""
    for k,v in pairs(tbl) do
        local val = v
        if table.isTable(v) then
            val = toString(v)
        end
        val = "["..k.."]="..val
        res = res..sep..val
        sep = ","
    end
    res = res.."}"
    return res
end

function concat(tab)
    local res = ""
    for key,value in ipairs(tab) do
        local val = value
        if table.isTable(value) then
            val = toString(value)
        end
        res = res..tostring(val)
    end
    return res
end

function split(chaine, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(chaine, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end