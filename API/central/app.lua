os.loadAPI("API/api")
api.initisalisation("log","comm","ecran")

log.setNomFichierLog("central.csv")
log.supFichier()

comm.connecter("right")
comm.ouvrir(0,3)

ecran.connecter("up")
ecran.nettoyer()

function main()
    while true do
        local info = comm.ecouter()
        
        ecran.afficher(info["senderChannel"].." : "..info["message"],info["senderChannel"]+1)
        print(info["message"])
    end
end