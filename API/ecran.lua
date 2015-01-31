local monitor 


function connecter(direction)
    log.entreMethode("connection(",direction,")")
    monitor = peripheral.wrap("top")
    log.sortieMethode()
end

function afficher( message )
    term.setCursorPos(1, os.getComputerID())
    monitor.write(message)
end
