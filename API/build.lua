os.loadAPI("API/api")
api.initisalisation("log","constante","parametre")

function construire(forme,posDepart, posFin, face)
    log.entreMethode("construireFaceCube(", forme, ", ", posDepart, ", ", posFin, ", ", face, ")")

    parametre.prepareParamPosition(posDepart)
    parametre.prepareParamPosition(posFin)

    log.entreMethode("construire(", posDepart, ", ", posFin, ")")
    if forme == "Cube" then
        construireCube(posDepart, posFin)
    end
    if forme == "FaceCube" then
        construireFaceCube(posDepart, posFin, face)
    end
    if forme == "CubeVide" then
        construireCubeVide(posDepart, posFin)
    end
    if forme == "TubeZ" then
        construireTubeZ(posDepart, posFin)
    end
    log.sortieMethode()
end

function construireCubeVide(posDepart, posFin)
    --construire bas devant derriere
    for i=1,3 do
        construireFaceCube(posDepart, posFin, i)
    end
    construireFaceCube(posDepart, posFin, constante.side["up"])
end

function construireTubeZ(posDepart, posFin)
    --construire bas devant derriere
    for _,i in pairs({1,2,3,6}) do
        construireFaceCube(posDepart, posFin, i)
    end
end

function construireFaceCube(posDepart, posFin, face)
    log.entreMethode("construireFaceCube(", posDepart, ", ", posFin, ", ", face, ")")

    posDepartTmp = tableau.clone(posDepart)
    posFinTmp = tableau.clone(posFin)
    if face == constante.side["up"] then
        posDepartTmp["y"] = math.max(posDepartTmp["y"],posFinTmp["y"])
        posFinTmp["y"] = math.max(posDepartTmp["y"],posFinTmp["y"])
    end
    if face == constante.side["down"] then
        posDepartTmp["y"] = math.min(posDepartTmp["y"],posFinTmp["y"])
        posFinTmp["y"] = math.min(posDepartTmp["y"],posFinTmp["y"])
    end
    if face == constante.side["front"] then
        posDepartTmp["x"] = math.max(posDepartTmp["x"],posFinTmp["x"])
        posFinTmp["x"] = math.max(posDepartTmp["x"],posFinTmp["x"])
    end
    if face == constante.side["back"] then
        posDepartTmp["x"] = math.min(posDepartTmp["x"],posFinTmp["x"])
        posFinTmp["x"] = math.min(posDepartTmp["x"],posFinTmp["x"])
    end
    if face == constante.side["righ"] then
        posDepartTmp["z"] = math.max(posDepartTmp["z"],posFinTmp["z"])
        posFinTmp["z"] = math.max(posDepartTmp["z"],posFinTmp["z"])
    end
    if face == constante.side["left"] then
        posDepartTmp["z"] = math.min(posDepartTmp["z"],posFinTmp["z"])
        posFinTmp["z"] = math.min(posDepartTmp["z"],posFinTmp["z"])
    end
    construireCube(posDepartTmp,posFinTmp)
    log.sortieMethode()
end

function construireCube(posDepart, posFin)
    log.entreMethode("construireCube(", posDepart, ", ", posFin, ")")

    for k=posDepart["y"], posFin["y"] do
        --creer la liste de valeur à parcourir croissante sur paire, décroissant sur impaire
        local listeI = tableau.liste(posDepart["x"], posFin["x"], k%2 == 0)
        for _,i in pairs(listeI) do

            --creer la liste de valeur à parcourir croissante sur paire, décroissant sur impaire
            local listeJ = tableau.liste(posDepart["z"], posFin["z"], i%2 == 0)
            for _,j in pairs(listeJ) do
                move.aller({i,j,k})
                turtle.placeDown()
            end
        end
    end
    log.sortieMethode()
end



function nbCube(posDepart, posFin)
    log.entreMethode("nbCube(", posDepart, ", ", posFin, ")")
    
    parametre.prepareParamPosition(posDepart)
    parametre.prepareParamPosition(posFin)

    nbBlocY = math.abs(posDepart["y"]-posFin["y"]) + 1
    nbBlocX = math.abs(posDepart["x"]-posFin["x"]) + 1
    nbBlocZ = math.abs(posDepart["z"]-posFin["z"]) + 1
    nbBloc = nbBlocY * nbBlocX * nbBlocZ
    log.sortieMethode(nbBloc)
    return nbBloc
end