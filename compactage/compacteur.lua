-- From @Eyolfur
-- Cobble auto compressor V1

--warning ! changing wrap params implies changing calls to .drop and .suck fonctions
local coffreInput = peripheral.wrap("front")
local coffreCobble = peripheral.wrap("top")
local cobbleCode = "Cobblestone"
local coffreSize = coffreCobble.getSizeInventory()

local function FillTurtle(numItems, listeSlots)
    local count = 0
    numItems = math.min(numItems, 64*9)
    local split = math.floor(numItems/9)
    local iTurtleSlot = 1
    print("Process "..numItems.." items")
    for _,j in pairs(listeSlots) do
        coffreCobble.swapStacks(j, 0)
        turtle.select(iTurtleSlot)
        turtle.suckUp()
        if split ==64 then
            iTurtleSlot=iTurtleSlot+1
        else
            while turtle.getItemCount(iTurtleSlot) > split and iTurtleSlot<=9 do
                turtle.select(iTurtleSlot)
                turtle.transferTo(iTurtleSlot+1, turtle.getItemCount(iTurtleSlot) - split)
                iTurtleSlot=iTurtleSlot+1           
            end
        end
        if (iTurtleSlot > 9) then
            turtle.select(iTurtleSlot)
            turtle.dropUp()
            break
        end
    end
    --switch positions 4,8 to 10,11
    turtle.select(4) turtle.transferTo(10)
    turtle.select(8) turtle.transferTo(11)
end

local function computeNumItems(coffre, itemType)
    local liste = {}
    local counter = 0
    for iSlot= 0, coffreSize-1 do
        local tableInfo = coffre.getStackInSlot(iSlot)
        if tableInfo ~= nil and tableInfo.name==itemType then
            table.insert(liste,iSlot)
            counter=counter+tableInfo.qty
        end
    end
    return counter, liste
end

local function craftBlock()
    turtle.select(16)
    turtle.craft()
    
    --make room in the chest
    coffreCobble.condense()
    coffreCobble.swapStacks(0,coffreSize-1)--coffre should not be full
    turtle.dropUp()--will push in slot 0
    local tableInfo = coffreCobble.getStackInSlot(0)
    return tableInfo.name
end

local function processBatch(itemType)
    print(itemType.." :")
    local nextType
    coffreCobble.condense()
    listSlots = {}
    local icount,listSlots = computeNumItems(coffreCobble,itemType)
    if icount < 9 then print((9-icount).." items missing") return end
    while (icount >= 9) do
        FillTurtle(icount,listSlots)
        nextType = craftBlock()
        icount,listSlots = computeNumItems(coffreCobble,itemType)
    end
    processBatch(nextType)
end

while true do
    coffreInput.condense()
    local inumcob,iSlotSel = computeNumItems(coffreInput,cobbleCode)
    if inumcob > 0 then
        for _,j in pairs(iSlotSel) do           
            coffreInput.swapStacks(0,j)
            turtle.select(1)
            turtle.suck()
            turtle.dropUp()
        end
        processBatch(cobbleCode)
    end
    sleep(10)
end