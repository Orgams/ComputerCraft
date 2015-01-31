os.loadAPI("API/api")
api.initisalisation("log")

local modem

function envoie(message)
    log.entreMethode("envoie(",message,")")
    modem.transmit(os.getComputerID(), os.getComputerID(), message) 
    log.sortieMethode()
end

function connecter(direction)
    log.entreMethode("connection(",direction,")")
    modem = peripheral.wrap(direction)
    log.sortieMethode()
end

function ouvrir(debutPlage, finPlage)
    log.entreMethode("ouvrir(",debutPlage,", ",finPlage,")")
    if finPlage == nil then
        modem.open(debutPlage)
    else
        for i= debutPlage ,finPlage do
            modem.open(i)
        end
    end
    log.sortieMethode()
end

function fermer(debutPlage, finPlage)
    log.entreMethode("fermer(",debutPlage,", ",finPlage,")")
    if debutPlage == nil then
        modem.closeAll()
    elseif finPlage == nil then
        modem.close(debutPlage)
    else
        for i= debutPlage ,finPlage do
            modem.close(i)
        end
    end
    log.sortieMethode()
end

function ecouter()
    log.entreMethode("ecouter()")
    local res = {}
    res["event"], res["modemSide"], res["senderChannel"], res["replyChannel"], res["message"], res["senderDistance"] = os.pullEvent("modem_message")
    log.sortieMethode(res)
    return res
end