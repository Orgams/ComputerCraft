os.loadAPI("API/api")
api.initisalisation("log","tableau")

function prepareParamPosition (tab)
    log.entreMethode("prepareParamPosition (", tab, ")")
    tableau.nommerEntre(tab, {"x", "z", "y"})
    tableau.mettreA(tab, 0, {"x", "z", "y"})
    log.sortieMethode()
end

function prepareParamCube (cube)
    log.entreMethode("prepareParamCube (", cube, ")")
    tableau.nommerEntre(cube, {"point1", "point2"})
    tableau.mettreA(cube, {0,0,0}, {"point1", "point2"})
    prepareParamPosition(cube["point1"])
    prepareParamPosition(cube["point2"])
    log.sortieMethode()
end