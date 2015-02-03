os.loadAPI("API/api")
api.initisalisation("log","move","inventaire","constante","coffre","bloc")

log.setNomFichierLog("bucheron.csv")
log.supFichier()

move.setBlocPasCasse({constante.bloc["chest"], constante.bloc["bois"]})
move.init()

local _directionCoffreEntre = "Left"

local _blocUtilise = {
    ["Sapling"] = constante.bloc["sapling"],
    ["Wood"] = constante.bloc["bois"],
    ["Fuel"] = constante.bloc["coal"],
    ["Fertilisant"] = constante.bloc["bonemeal"]
}
inventaire.setBlocAGarder({_blocUtilise["Sapling"],_blocUtilise["Fertilisant"],_blocUtilise["Fuel"]})

function presanceWood()
    log.entreMethode("presanceWood()")
    local res = bloc.presance({_blocUtilise["Wood"]})
    log.sortieMethode()
    return res
end

function presanceSapling()
    log.entreMethode("presanceSapling()")
    local res = bloc.presance({_blocUtilise["Sapling"]})
    log.sortieMethode()
    return res
end

function couperArbre()
    log.entreMethode("couperArbre()")
    while presanceWood() do
        turtle.dig()
        move.monter()
    end
    move.allerSurface()
    log.sortieMethode()
end

function fertilise()
    log.entreMethode("fertilise()")
    if inventaire.selectFirstSlot(_blocUtilise["Fertilisant"]) then
        turtle.place()
    end
    log.sortieMethode()
end

function plante()
    log.entreMethode("plante()")
    if inventaire.selectFirstSlot(_blocUtilise["Sapling"]) then
        turtle.place()
    end
    log.sortieMethode()
end

function complete(id)
    log.entreMethode("complete()")

    local nb = inventaire.nb(id)
    if nb < 64 then
        if inventaire.selectFirstSlot(id) then
            coffre.complete()
        else
            coffre.getItem()
        end
    end
    log.sortieMethode()
end

function remplirInventaire()
    if _directionCoffreEntre == nil then
        return
    end
    log.entreMethode("remplirInventaire()")
    move.aller({["x"]=0,["y"]=0,["y"]=0})
    move.directionGauche()
    inventaire.ranger()
    complete(_blocUtilise["Sapling"])
    complete(_blocUtilise["Fuel"])
    complete(_blocUtilise["Fertilisant"])
    inventaire.ranger()
    inventaire.viderSurplus()
    log.sortieMethode()
end

function main()
    log.entreMethode("main()")
    print("J'ai besoin de sapling et de fuel.")
    print("En plus je peux prendre du fertilisant.")
    read()
    remplirInventaire()
    move.remplirFuel()
    while true do
        move.directionDevant()
        local success, data = turtle.inspect()
        if presanceSapling() then
            log.info("il y a une pousse d'arbre")
            fertilise()
        end
        if presanceWood() then
            log.info("il y a un tronc d'arbre")
            couperArbre()
            inventaire.viderInventaire()
            remplirInventaire()
            move.directionDevant()
        end
        if not turtle.detect() then
            log.info("il n'y a rien")
            plante()
        end
        sleep(10)
    end
    log.sortieMethode()
end