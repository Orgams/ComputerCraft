os.loadAPI("API/api")
api.initisalisation("log","comm")

log.setNomFichierLog("central.csv")
log.supFichier()

comm.connection("right")
comm.ouvrir(0,3)

function main()
    while true do
        print(comm.ecouter()["message"])
    end
end