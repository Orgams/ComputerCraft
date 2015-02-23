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
    log.entreMethode("clone(", tab, ")")
    local res = {}
    for k,v in pairs(tab) do
        val = v
        if isTable(v) then
            val = clone(v)
        end
        res[k] = val;
    end
    log.sortieMethode(res)
    return res
end

function nommerEntre(tab, keys)
    log.entreMethode("nommerEntre(", tab, ", ", keys, ")")
    local i = 1
    for numKey, key in pairs(keys) do
        if tab[key] == nil and tab[i] ~= nil then
            tab[key] = tab[i]
            tab[numKey] = nil
        end
        i = i + 1
    end
    log.sortieMethode(tab)
    return tab
end

function mettreA(tab, valeur, keys)
    log.entreMethode("mettreA(", tab, ", ", valeur, ", ", keys, ")")
    for _, key in pairs(keys) do
        if tab[key] == nil then
            tab[key] = valeur
        end
    end
    log.sortieMethode(tab)
    return tab
end

function liste(debut, fin, croissant)
    log.entreMethode("liste(",debut,", ",fin,", ",croissant,")")
    local res = {}
    if croissant then
        for i=debut, fin do
            table.insert(res,i)
        end
    else
        for i=fin, debut, -1 do
            table.insert(res,i)
        end
    end
    log.sortieMethode(res)
    return res
end