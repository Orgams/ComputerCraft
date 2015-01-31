local nbPuit = 0
local nbPuitsTotal = 0
local profondeur = 0
local idChannel = 123
local message = "attente"
 
function split(str,pat)
 
        local t = {}
        local fpat = "(.-)" .. pat
        local last_end = 1
        local s, e, cap = str:find(fpat, 1)
        while s do
                if s ~= 1 or cap ~= "" then
                        table.insert(t,cap)
                end
                last_end = e+1
                s, e, cap = str:find(fpat, last_end)
        end
        if last_end <= #str then
                cap = str:sub(last_end)
                table.insert(t, cap)
        end
        return t
end
 
 
function affiche_etat()
 
        term.clear()
        term.setCursorPos(4,4)
        if message == "attente" then
                print("En attente de la tortue...")
        elseif message == "encours" then
                print("Avancement du minage : "..nbPuit.."/"..nbPuitsTotal)
                term.setCursorPos(4,6)
               
                if profondeur == 0 then
                        print("Profondeur : "..profondeur)
                else
                        print("Profondeur : -"..profondeur)
                end
        elseif message == "vidage" then
                term.setCursorPos(4,8)
                print("La tortue revient vider son inventaire")
        elseif message == "charbon" then
                term.setCursorPos(4,8)
                print("La tortue revient prendre du charbon")
        elseif message == "retour" then
                print("Minage fini, retour au point de depart...")
        elseif message == "fin" then
                print("Minage fini !")
        end
       
end
 
 
 
--rednet.open("right")
modem = peripheral.wrap("left")
affiche_etat()
 
while true do
        modem.open(idChannel)
        event, modemSide, senderChannel, replyChannel, text, senderDistance = os.pullEvent("modem_message")
        local tab = split(text,":")
        if tab[1] == "etat" then message = tab[2] end
        if tab[1] == "nbPuitsTotal" then nbPuitsTotal = tab[2] end
        if tab[1] == "nbPuits" then nbPuit = tab[2] end
        if tab[1] == "profondeur" then profondeur = tab[2] end
        affiche_etat()
        modem.close(idChannel)
end