os.loadAPI("API/api")
api.initisalisation("log","comm","ecran","chaine","mineur/mineur")

log.setNomFichierLog("central.csv")
log.supFichier()

comm.connecter()
comm.ouvrir(0,3)

ecran.connecter("up")
ecran.nettoyer()

function actionViaMessage(info)
    local chainesSplit = chaine.split(info["message"], ":")

    if chainesSplit[1] == "message" then
        ecran.afficher(info["senderChannel"].." : "..chainesSplit[2],info["senderChannel"]+1)
    end

    if chainesSplit[1] == "nextPuit" then
        comm.envoie(mineur.nextPuit(), info["replyChannel"])           
    end
end

print ("Central pret")
function main()
    log.entreMethode("main()")
    while true do
        actionViaMessage(comm.ecouter())
    end
    log.sortieMethode()
end