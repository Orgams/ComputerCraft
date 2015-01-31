os.loadAPI("API/api")
api.initisalisation("table","coffre","move")

blocAGarder = {}

function nextSlot(id,slotDepart)
    log.entreMethode("nextSlot(",id,",",slotDepart,")")
    for i=slotDepart+1,16 do
        local data = turtle.getItemDetail(i)
        if data ~= nil and data.name == id then
            log.sortieMethode(true, i)
            return true, i
        end
    end
    log.sortieMethode(false)
    return false
end

function firstSlot(id)
    log.entreMethode("firstSlot(",id,")")
    log.sortieMethode()
    return nextSlot(id,0)
end

function selectNextSlot(id,slotDepart)
    log.entreMethode("selectNextSlot(",id,",",slotDepart,")")
    ok, num = nextSlot(id,slotDepart)
    local res = false
    if ok then
        turtle.select(num)
        log.sortieMethode()
        res = num
    end
    log.sortieMethode(res)
    return res
end

function selectFirstSlot(id)
    log.entreMethode("selectFirstSlot(",id,")")
    ok, num = firstSlot(id)
    local res = false
    if ok then
        log.sortieMethode()
        turtle.select(num)
        res = num
    end
    log.sortieMethode(res)
    return res
end

function vide(num)
    log.entreMethode("vide(",num,")")
    local res = turtle.getItemCount(num) == 0
    log.sortieMethode(res)
    return res
end

function firstVide()
    log.entreMethode("firstVide()")
    for i=1,16 do
        if vide(i) then
            log.sortieMethode(true, i)
            return true, i
        end
    end
    log.sortieMethode(false)
    return false
end

function selectFirstVide()
    log.entreMethode("selectFirstVide()")
    ok, num = firstVide(id)
    local res = false
    if ok then
        log.sortieMethode()
        res = turtle.select(num)
    end
    log.sortieMethode(res)
    return res
end

function nb(id)
    log.entreMethode("nb(",id,")")
    local res = 0
    local num = selectNextSlot(id, 0)

    while num ~= false do
        num = selectNextSlot(id, num)
        res = res + turtle.getItemCount()
    end
    log.sortieMethode(res)
    return res
end
function ranger()
    log.entreMethode("ranger()")

    --parcourir tous les slots
    for i=1,16 do

        --si le slot n'est pas vide
        nbItem = turtle.getItemCount(i)
        if nbItem ~= 0 then
            --Depacer le stack si il y a un slot vide disponible
            existeSlotVide, SlotVide = firstVide()
            if existeSlotVide and SlotVide < i then
                turtle.select(i)
                turtle.transferTo(SlotVide)
                i=SlotVide
            end
            --Remplir le slot autant que l'on peut
            continue = true
            data = turtle.getItemDetail(i)
            while continue do
                continue = false
                if nbItem<64 then
                    num = selectNextSlot(data.name,i)
                    if num then
                        turtle.select(num)
                        turtle.transferTo(i , 64-nbItem)
                        nbItem = turtle.getItemCount(i)
                        continue = true
                    end
                end
            end
        end
    end
    log.sortieMethode()
end

function viderSurplus()
    itemPasse = {}
    for i=1,16 do
        data = turtle.getItemDetail(i)
        if data ~= nil then
            if table.contains(itemPasse, data.name) then
                turtle.select(i)
                turtle.drop ()
            else
                itemPasse[i] = data.name
            end
        end
    end
end

function viderInventaire()
    log.entreMethode("viderInventaire()")
    local positionTmp = move.getPosition()
    move.retoure({["x"]=0,["y"]=0,["y"]=0})
    move.directionDeriere()
    for i=1,16 do
        turtle.select(i)
        data = turtle.getItemDetail()
        if data ~= nil and not isAGarder(data.name) then
            turtle.drop()  
        end
    end
    inventaire.ranger()
    inventaire.viderSurplus()
    move.aller(positionTmp)
    log.sortieMethode()
end

function isAGarder(id)
    log.entreMethode("isAGarder()")
    local res = false
    for k,v in pairs(_blocAGarder) do
        if id == v then
            res = true
        end
    end

    log.sortieMethode(res)
    return res
end