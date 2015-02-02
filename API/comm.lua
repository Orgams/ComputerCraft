os.loadAPI("API/api")
api.initisalisation("log","constante")

local modem

function connecter()
    log.entreMethode("connection()")
    for k,side in pairs(constante.side) do
        if peripheral.isPresent(side) then
            local typePeriph = peripheral.getType(side)
            if typePeriph == "modem" then
                modem = peripheral.wrap(side)
                ouvrir(os.getComputerID())
            end
        end
    end
    log.sortieMethode(isConnecter())
    return isConnecter()
end

function isConnecter()
    return modem ~= nil
end

function envoie(message,channel)
    log.entreMethode("envoie(",message,",",channel,")")
    if not isConnecter() then log.sortieMethode() return end

    if channel == nil then
        channel = os.getComputerID()
    end

    modem.transmit(channel, os.getComputerID(), message) 
    log.sortieMethode()
end

function ouvrir(debutPlage, finPlage)
    log.entreMethode("ouvrir(",debutPlage,", ",finPlage,")")
    if not isConnecter() then log.sortieMethode() return end

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
    if not isConnecter() then log.sortieMethode() return end

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
    if not isConnecter() then log.sortieMethode() return end

    local res = {}
    res["event"], res["modemSide"], res["senderChannel"], res["replyChannel"], res["message"], res["senderDistance"] = os.pullEvent("modem_message")
    log.sortieMethode(res)
    return res
end