os.loadAPI("API/api")
api.initisalisation("log","move","build","constante")

log.setNomFichierLog("poseur.csv")
log.supFichier()

function main(pointD,pointF)
    log.entreMethode("main(",pointD,",",pointF,")")
    --print("nb bloc nécessaire : ", build.nbCube(pointD, pointF))
    read()

    build.construire("TubeZ", pointD, pointF)

    move.aller({0,0,0})
    log.sortieMethode()
end