local GUI = require("GUI")
local buffer = require("screen")
local image = require("image")
local fs=require("filesystem")
local system = require("system")
local PathToRes=fs.path(system.getCurrentScript())
local keyCodeCyka=""

local function LoadModule(path)
  local Suc,Res = loadfile(PathToRes..path)
  if not Suc then error(Res) end
  return Suc()
end

local Bullet = LoadModule("Bullet.lua")

return function (x,y,GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer)
	
  local MyFuckingTank = GUI.object(x,y,8,4)
  
  MyFuckingTank.Speed = 1
  MyFuckingTank.MoveSide = "UP"
  MyFuckingTank.Huy = "none"
  MyFuckingTank.type = "friend"
  MyFuckingTank.debugFlag = 0
  
  MyFuckingTank.test = "none"
  MyFuckingTank.ModelMoveUp = image.load(PathToRes.."../Textures/Player1Tank/Player1NewTankUP.pic")
  MyFuckingTank.ModelMoveDown = image.load(PathToRes.."../Textures/Player1Tank/Player1NewTankDOWN.pic")
  MyFuckingTank.ModelMoveLeft = image.load(PathToRes.."../Textures/Player1Tank/Player1NewTankLEFT.pic")
  MyFuckingTank.ModelMoveRight = image.load(PathToRes.."../Textures/Player1Tank/Player1NewTankRIGHT.pic")
  
  MyFuckingTank.Model = MyFuckingTank.ModelMoveUp

  MyFuckingTank.eventHandler = function(momContainer, object, e1,e2,e3,EvD)
	 
      if e1 == "key_down" then
        keyCodeCyka=EvD
        if EvD == 200 or EvD == 17 then
          MyFuckingTank.Huy = "UP"
        elseif EvD == 208 or EvD == 31 then
          MyFuckingTank.Huy = "DOWN"
        elseif EvD == 203 or EvD == 30 then
          MyFuckingTank.Huy = "LEFT"
        elseif EvD == 205 or EvD == 32 then
          MyFuckingTank.Huy = "RIGHT"
        elseif EvD == 57 then
          BulletContainer:addChild(Bullet(MyFuckingTank.localX-GameScreenX+6,MyFuckingTank.localY+1,"bullet","me",MyFuckingTank.MoveSide,GameScreenX-26, GameScreenY-1 , GameScreenWidth + 2, GameScreenHeight + 2))
  	  end
  	 elseif e1 == "key_up" then
        MyFuckingTank.Huy="none"
  	 end
	
	 ---28,3,104,44
  	 if MyFuckingTank.Huy == "UP" then
          MyFuckingTank.MoveSide = "UP"
          if MyFuckingTank.localY > GameScreenY then MyFuckingTank.localY = MyFuckingTank.localY - MyFuckingTank.Speed end
          
        elseif MyFuckingTank.Huy == "DOWN" then
          MyFuckingTank.MoveSide = "DOWN"
          if MyFuckingTank.localY < GameScreenHeight-1 then MyFuckingTank.localY = MyFuckingTank.localY + MyFuckingTank.Speed end
          
        elseif MyFuckingTank.Huy == "LEFT" then
          MyFuckingTank.MoveSide = "LEFT"
          if MyFuckingTank.localX > GameScreenX then MyFuckingTank.localX = MyFuckingTank.localX - MyFuckingTank.Speed*2 end
          
        elseif MyFuckingTank.Huy == "RIGHT" then
          MyFuckingTank.MoveSide = "RIGHT"
          if MyFuckingTank.localX < GameScreenWidth+GameScreenX-MyFuckingTank.width then MyFuckingTank.localX = MyFuckingTank.localX + MyFuckingTank.Speed*2 end
        end
	    
    end
  
    MyFuckingTank.draw = function(MyFuckingTank)
    if MyFuckingTank.MoveSide == "UP" then 
      MyFuckingTank.Model = MyFuckingTank.ModelMoveUp
    elseif MyFuckingTank.MoveSide == "DOWN" then 
      MyFuckingTank.Model = MyFuckingTank.ModelMoveDown
    elseif MyFuckingTank.MoveSide == "RIGHT" then 
      MyFuckingTank.Model = MyFuckingTank.ModelMoveRight
    elseif MyFuckingTank.MoveSide == "LEFT" then 
      MyFuckingTank.Model = MyFuckingTank.ModelMoveLeft
    end
    
	buffer.drawText(1,1,0x00FF00,"X="..MyFuckingTank.localX.." Y="..MyFuckingTank.localY.." keyCode="..keyCodeCyka)
	buffer.drawText(1,2,0x00FF00,"Move:WASD. Piu-piy:SPACE. Regenerage MAP: R")
	buffer.drawText(1,3,0x00FF00," Exit: q.")

    --buffer.frame(MyFuckingTank.x-1, MyFuckingTank.y-1 , MyFuckingTank.width + 2, MyFuckingTank.height + 2, 0xFFFFFF)
    buffer.drawImage(MyFuckingTank.x, MyFuckingTank.y, MyFuckingTank.Model)
  end
  
  return MyFuckingTank
end


