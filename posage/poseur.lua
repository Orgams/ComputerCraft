s=1
while true do
    while turtle.getItemCount() == 0 do
        s=s+1
        if s>16 then
            s=1
        end
        turtle.select(s)
    end
    turtle.place()
end
