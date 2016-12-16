os.loadAPI("API/api")
api.initisalisation("log")

log.setNomFichierLog("filleur.csv")
log.supFichier()

local slotNum = 2

-- select(1)
-- turtle.refuel()

-- select(slotNum)

function placerBloc() 
	log.entreMethode("placerBloc()")
	if turtle.placeDown() then
		if turtle.getItemCount() == 0 then
			slotNum = slotNum + 1
			select(slotNum)
		end
	end
	log.sortieMethode()
end

 while slotNum < 17 do
 	if not turtle.detectDown() then
-- 		if turtle.forward() then
 		placerBloc()
-- 		else
-- 			turnLeft()
-- 		end
 	else
 		if not turtle.forward() then
 			turtle.turnRight()
 		end
 	end
 end