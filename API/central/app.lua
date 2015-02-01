os.loadAPI("API/api")
api.initisalisation("log","comm","ecran","chaine","mineur/mineur")

log.setNomFichierLog("central.csv")
log.supFichier()

comm.connecter("right")
comm.ouvrir(0,3)

ecran.connecter("up")
ecran.nettoyer()

print ("Central pret")
function main()
    log.entreMethode("main()")
    while true do
        local info = comm.ecouter()
        local chainesSplit = chaine.split(info["message"], ":")

        if chainesSplit[1] == "message" then
            ecran.afficher(info["senderChannel"].." : "..chainesSplit[2],info["senderChannel"]+1)
        end

        if chainesSplit[1] == "nextPuit" then
            comm.envoie(mineur.nextPuit(), info["replyChannel"])           
        end
    end
    log.sortieMethode()
end