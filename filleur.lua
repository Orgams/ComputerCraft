local slotNum = 2

select(1)
turtle.refuel()

select(slotNum)

function placerBloc() 
	if turtle.placeDown() then
		if getItemCount() == 0 then
			slotNum = slotNum + 1
			select(slotNum)
		end
	end
end

while slotNum < 17 do
	if detectDown()
		if forward() then
			placerBloc()
		else
			turnLeft()
		end
	else
	end
end