os.loadAPI("API/api")
api.initisalisation("file","tableau","move")

local _chemin = "log.log"
local _niveauAff = {
    [0]="display",
    [1]=" info  ",
    [2]=" warn  ",
    [3]=" debug "
}

_niveau = { 
    [0]="display",["display"]=0,
    [1]="info",["info"]=1,
    [2]="warn",["warn"]=2,
    [3]="debug",["debug"]=3
}

local _niveauUtilise = {["fichier"]=_niveau["debug"],
                        ["console"]=_niveau["info"]}

profondeur = 0
function concat(tab)
    if tab == nil then
        return nil
    end
    local res = ""
    for key,value in ipairs(tab) do
        local val = value
        if tableau.isTable(value) then
            val = tableau.toString(value)
        end
        res = res..tostring(val)
    end
    return res
end

function logger(message,niveau)
    --TODO textutils.formatTime( os.time(), false )
    local decalage = ""
    for i=1,profondeur do
        decalage = decalage..".   "
    end
    messageFormater = textutils.formatTime( os.time(), false ).."; [".._niveauAff[niveau].."]; "..decalage..tostring(message)
    if niveau <= _niveauUtilise["console"] then
        print(messageFormater)
    end
    if niveau <= _niveauUtilise["fichier"] then
        file.ajouter(_chemin, messageFormater)
    end
end

function display(...)
    logger(concat(arg),_niveau["display"])
end

function info(...)
    logger(concat(arg),_niveau["info"])
end

function warn(...)
    logger(concat(arg),_niveau["warn"])
end

function descrTortue()
    if turtle == nil then
        return ""
    end
    return move.descrPosition()..";"..turtle.getFuelLevel()..";"..profondeur
end

function debug(...)
    logger(concat(arg)..";"..descrTortue(),_niveau["debug"])
end

local function setNiveauLog(niveau, type)
    _niveauUtilise[type] = niveau
end

function setNiveauLogConsole(niveau)
    setNiveauLog(niveau, "console")
end

function setNiveauLogFichier(niveau)
    setNiveauLog(niveau, "fichier")
end

function entreMethode(...)
    profondeur = profondeur + 1
    debug(concat(arg))
end

function sortieMethode(...)
    debug("return : ",concat(arg))
    profondeur = profondeur - 1
end

function modifParam(...)
    debug(concat(arg))
end
function setNomFichierLog (chemin)
    _chemin = chemin
end

function supFichier()
    file.supFichier(_chemin)
end