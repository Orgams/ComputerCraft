os.loadAPI("API/api")
api.initisalisation("log","tableau")

function toString(tbl)
    local res = "{"
    local sep = ""
    for k,v in pairs(tbl) do
        local val = v
        if tableau.isTable(v) then
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
        if tableau.isTable(value) then
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

function join(chaines, milieux, debut, fin)
    milieux = chaine.nilVersVide(milieux)
    debut = chaine.nilVersVide(debut)
    fin = chaine.nilVersVide(fin)
    local sep = ""
    local res = debut
    for k,chaine in pairs(chaines) do
        res = res..sep..chaine
        sep = milieux
    end
    res = res..fin
    return res
end

function nilVersVide(var)
    if var == nil then
        var = ""
    end
    return var
end