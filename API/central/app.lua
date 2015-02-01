os.loadAPI("API/api")
api.initisalisation("log","comm","ecran","chaine")

log.setNomFichierLog("central.csv")
log.supFichier()

comm.connecter("right")
comm.ouvrir(0,3)

ecran.connecter("up")
ecran.nettoyer()

function main()
    while true do
        local info = comm.ecouter()
        local chainesSplit = chaine.split(info["message"], ":")

        if chainesSplit[1] == "message" then
            ecran.afficher(info["senderChannel"].." : "..chainesSplit[2],info["senderChannel"]+1)
            print(chainesSplit[2])
        end
    end
end