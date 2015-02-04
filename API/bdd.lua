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

function charger(groupe, donnees)
    log.entreMethode("charger(",groupe,", ",donnees,")")
    if groupe == nil then
        groupe = ""
    end
    local res = {}
    if donnees == nil then
        donnees = file.listeFichier(repBdd.."/"..groupe)
    end
    for _,donnee in pairs(donnees) do
        local contenu = file.lire(repBdd.."/"..groupe.."/"..donnee)
        if contenu ~= "" then
            res[donnee] = contenu
        end
    end
    log.sortieMethode(res)
    return res
end