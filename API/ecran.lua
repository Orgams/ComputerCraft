local monitor 

function connecter(direction)
    log.entreMethode("connection(",direction,")")
    monitor = peripheral.wrap("top")
    log.sortieMethode()
end

function afficher( message,ligne )
    log.entreMethode("afficher( ",message,",",ligne," )")
    monitor.setCursorPos(1, ligne)
    monitor.write(message)
    log.sortieMethode()
end

function nettoyer()
    monitor.clear()
end