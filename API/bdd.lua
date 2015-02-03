os.loadAPI("API/api")
api.initisalisation("log","file")

local repBdd = "stockage"

function sauver(donnees, groupe)
    log.entreMethode("sauver(",donnees,", ",groupe,")")
    if groupe == nil then
        groupe = ""
    end
    for k,v in pairs(donnees) do
        file.ecrire(repBdd.."/"..groupe.."/"..k, v)
    end
    log.sortieMethode()
end

function charger(donnees, groupe)
    log.entreMethode("charger(",donnees,", ",groupe,")")
    if groupe == nil then
        groupe = ""
    end
    local res = {}
    for _,donnee in pairs(donnees) do
        local contenu = file.lire(repBdd.."/"..groupe.."/"..donnee)
        if contenu ~= "" then
            res[donnee] = contenu
        end
    end
    log.sortieMethode(res)
    return res
end