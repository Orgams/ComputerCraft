os.loadAPI("API/api")
api.initisalisation("log","move","inventaire","constante","coffre","bloc")

log.setNomFichierLog("bucheron.csv")
log.supFichier()

move.setBlocPasCasse({
    constante.bloc["chest"], 
    constante.bloc["bois"], 
    constante.bloc["sapling"]
})
move.init()

local _directionCoffreEntre = "Left"

local _blocUtilise = {
    ["Sapling"] = constante.bloc["sapling"],
    ["Wood"] = constante.bloc["bois"],
    ["Fuel"] = constante.bloc["coal"],
    ["Fertilisant"] = constante.bloc["bonemeal"]
}

inventaire.setBlocAGarder({_blocUtilise["Sapling"],_blocUtilise["Fertilisant"],_blocUtilise["Fuel"]})

local autostat = false

local champs = {
    ["L"]=6,
    ["l"]=6,
    ["ecart"]=4
}

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
function traiterArbre()
    local success, data = turtle.inspect()
    if presanceSapling() then
        fertilise()
    end
    if presanceWood() then
        couperArbre()
    end
    if not turtle.detect() then
        plante()
    end
end
function main()
    log.entreMethode("main()")
    print("J'ai besoin de sapling et de fuel.")
    print("En plus je peux prendre du fertilisant.")
    if not autostat then
        read()
    end

    while true do
        remplirInventaire()
        move.remplirFuel()
        for i=0,champs["L"]-1 do
            for j=0,champs["l"]-1 do
                local tmpJ = j
                if i%2 == 1 then
                    tmpJ = (champs["l"]-1)-j
                end
                local nextArbre = {["x"]=i*champs["ecart"], ["z"]=tmpJ*champs["ecart"]}
                move.aller(nextArbre)
                move.directionDevant() 
                traiterArbre()
            end
        end
        move.allerDepart()  
        inventaire.viderInventaire()
    end
    log.sortieMethode()
end