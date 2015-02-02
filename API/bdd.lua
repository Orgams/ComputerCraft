os.loadAPI("API/api")
api.initisalisation("log","file")

local repBdd = "stockage"

function sauver(donnees, groupe)
    if groupe == nil then
        groupe = ""
    end
    for k,v in pairs(donnees) do
        file.ecrire(repBdd.."/"..groupe.."/"..k, v)
    end
end

function charger(donnees, groupe)
    if groupe == nil then
        groupe = ""
    end
    local res = {}
    for _,donnee in pairs(donnees) do
        local contenu = file.lire(repBdd.."/"..groupe.."/"..donnee)
        res[donnee] = contenu
    end
    return res
end