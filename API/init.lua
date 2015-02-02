os.loadAPI("API/api")
api.initisalisation("log","ecran","comm")

function perierique()
    log.entreMethode("perierique()")
    local periList = peripheral.getNames()
    for i = 1, #periList do
        local typePer = peripheral.getType(periList[i])
        if typePer == "monitor" then
            ecran.connecter(periList[i])
        end
        if typePer == "modem" then
            comm.connecter(periList[i])
        end
    end
    log.sortieMethode()
end