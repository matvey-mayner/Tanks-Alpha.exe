local GUI = require("GUI")
local buffer = require("screen")

return function (x, y, type, from, MoveSide,GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight)
  local Pulya = GUI.object(x, y, 1, 1)
  
  Pulya.MoveSide = MoveSide
  Pulya.type = type
  Pulya.from = from
  Pulya.speed = 2
  Pulya.FriendModel = "."

  
  Pulya.draw = function()
    buffer.drawText(Pulya.x,Pulya.y,0xFF0000,Pulya.FriendModel)


    if Pulya.MoveSide == "UP" then 
      Pulya.localY = Pulya.localY - Pulya.speed
    elseif Pulya.MoveSide == "DOWN" then 
      Pulya.localY = Pulya.localY + Pulya.speed
    elseif Pulya.MoveSide == "RIGHT" then 
      Pulya.localX = Pulya.localX + Pulya.speed
    elseif Pulya.MoveSide == "LEFT" then 
      Pulya.localX = Pulya.localX - Pulya.speed
    end

   

  end
  
   Pulya.eventHandler = function(mainContainer,object,eventData)
   if not (Pulya.localX >= GameScreenX and Pulya.localX <= GameScreenWidth+GameScreenX-Pulya.width-1 and Pulya.localY >= GameScreenY and Pulya.localY <= GameScreenHeight-1) then 
      Pulya:remove()
     end
   end
  
  return Pulya
end
