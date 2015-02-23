os.loadAPI("API/api")
api.initisalisation("log","move","build","constante")

log.setNomFichierLog("poseur.csv")
log.supFichier()

function main(cube)
    log.entreMethode("main(",cube,")")
    read()

    build.construire("CubeVide", cube)

    move.aller({0,0,0})
    log.sortieMethode()
end