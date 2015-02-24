os.loadAPI("API/api")
api.initisalisation("log","constante","parametre")

local materielCourant = nil

function construire(forme, cube, ...)
    log.entreMethode("construire(", forme, ", ", cube, ", ", arg, ")")

    parametre.prepareParamCube(cube)

    if forme == "Cube" then
        construireCube(cube)
    end
    if forme == "FaceCube" then
        construireCube(getFaceCube(cube, arg[1]))
    end
    if forme == "CubeVide" then
        construireCubeVide(cube)
    end
    log.sortieMethode()
end

function construireCubeVide(cube)
    log.entreMethode("construireCubeVide(",cube,")")
    local listeConstruction = {}
    table.insert(listeConstruction, getFaceCube(cube,constante.side["down"]))
    table.insert(listeConstruction, reduireCube(getFaceCube(cube,constante.side["left"]), "y"))
    table.insert(listeConstruction, reduireCube(getFaceCube(cube,constante.side["right"]), "y"))
    table.insert(listeConstruction, reduireCube(reduireCube(getFaceCube(cube,constante.side["front"]), "y"),"z"))
    table.insert(listeConstruction, reduireCube(reduireCube(getFaceCube(cube,constante.side["back"]), "y"),"z"))
    table.insert(listeConstruction, getFaceCube(cube,constante.side["up"]))
    log.display(listeConstruction)
    for k,v in pairs(listeConstruction) do
        construireCube(v)
    end
    log.sortieMethode()
end

function reduireCube (cube, direction)
    log.entreMethode("reduireCube (",cube,", ",direction,")")
    
    log.display(cube["point1"][direction]," > ",cube["point2"][direction])

    if cube["point1"][direction] > cube["point2"][direction] then
        cube["point1"][direction] = cube["point1"][direction] - 1
        cube["point2"][direction] = cube["point2"][direction] + 1
    end
    if cube["point1"][direction] < cube["point2"][direction] then
        cube["point1"][direction] = cube["point1"][direction] + 1
        cube["point2"][direction] = cube["point2"][direction] - 1
    end

    log.sortieMethode(cube)
    return cube
end

function getFaceCube(cube, face)
    log.entreMethode("getFaceCube(", cube, ", ", face, ")")

    cubeTmp = tableau.clone(cube)
    
    cubeTmp["point1"] = tableau.clone(cubeTmp["point1"])
    cubeTmp["point2"] = tableau.clone(cubeTmp["point2"])
    if face == constante.side["up"] then
        cubeTmp["point1"]["y"] = math.max(cubeTmp["point1"]["y"],cubeTmp["point2"]["y"])
        cubeTmp["point2"]["y"] = math.max(cubeTmp["point1"]["y"],cubeTmp["point2"]["y"])
    end
    if face == constante.side["down"] then
        cubeTmp["point1"]["y"] = math.min(cubeTmp["point1"]["y"],cubeTmp["point2"]["y"])
        cubeTmp["point2"]["y"] = math.min(cubeTmp["point1"]["y"],cubeTmp["point2"]["y"])
    end
    if face == constante.side["front"] then
        cubeTmp["point1"]["x"] = math.max(cubeTmp["point1"]["x"],cubeTmp["point2"]["x"])
        cubeTmp["point2"]["x"] = math.max(cubeTmp["point1"]["x"],cubeTmp["point2"]["x"])
    end
    if face == constante.side["back"] then
        cubeTmp["point1"]["x"] = math.min(cubeTmp["point1"]["x"],cubeTmp["point2"]["x"])
        cubeTmp["point2"]["x"] = math.min(cubeTmp["point1"]["x"],cubeTmp["point2"]["x"])
    end
    if face == constante.side["right"] then
        cubeTmp["point1"]["z"] = math.max(cubeTmp["point1"]["z"],cubeTmp["point2"]["z"])
        cubeTmp["point2"]["z"] = math.max(cubeTmp["point1"]["z"],cubeTmp["point2"]["z"])
    end
    if face == constante.side["left"] then
        cubeTmp["point1"]["z"] = math.min(cubeTmp["point1"]["z"],cubeTmp["point2"]["z"])
        cubeTmp["point2"]["z"] = math.min(cubeTmp["point1"]["z"],cubeTmp["point2"]["z"])
    end

    log.sortieMethode(cubeTmp)
    return cubeTmp
end

function construireCube(cube)
    log.entreMethode("construireCube(", cube, ")")

    for k=cube["point1"]["y"], cube["point2"]["y"] do
        --creer la liste de valeur à parcourir croissante sur paire, décroissant sur impaire
        local listeI = tableau.liste(cube["point1"]["x"], cube["point2"]["x"], k%2 == 0)
        for _,i in pairs(listeI) do

            --creer la liste de valeur à parcourir croissante sur paire, décroissant sur impaire
            local listeJ = tableau.liste(cube["point1"]["z"], cube["point2"]["z"], i%2 == 0)
            for _,j in pairs(listeJ) do
                move.aller({i,j,k})
                turtle.placeDown()
            end
        end
    end
    log.sortieMethode()
end

function poserEnBas ()

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