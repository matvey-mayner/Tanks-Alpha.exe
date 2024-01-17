local GUI = require("GUI")
local buffer = require("screen")
local image = require("image")
local system = require("system")
local fs=require("filesystem")
local PathToRes=fs.path(system.getCurrentScript())

local function LoadModule(path)
  local Suc,Res = loadfile(PathToRes..path)
  if not Suc then error(Res) end
  return Suc()
end

local Bullet = LoadModule("Bullet.lua")
local TimeToSpawn = 50

return function (spawnX,spawnY,GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer)

    local FuckingEnemy = GUI.object(spawnX,spawnY,8,4)

    local function ChangeMoveSide()
        local ChangeSide = math.random(3)
        local Sides={
          "UP",
          "DOWN",
          "LEFT",
          "RIGHT"
        }
        for i=1,#Sides do
          if Sides[i] == FuckingEnemy.MoveSide then table.remove(Sides,i) break end
        end 
      FuckingEnemy.MoveSide = Sides[ChangeSide]
    end

    FuckingEnemy.Speed = 1
    FuckingEnemy.MoveSide = "DOWN"
    FuckingEnemy.MaxBullet = 2
    FuckingEnemy.debugFlag = 1
    FuckingEnemy.type = "enemy"
    FuckingEnemy.ticks = 0
    
    FuckingEnemy.ModelMoveUp = image.load(PathToRes.."../Textures/EnemyTank/YellowTank_UP.pic")
    FuckingEnemy.ModelMoveDown = image.load(PathToRes.."../Textures/EnemyTank/YellowTank_DOWN.pic")
    FuckingEnemy.ModelMoveLeft = image.load(PathToRes.."../Textures/EnemyTank/YellowTank_LEFT.pic")
    FuckingEnemy.ModelMoveRight = image.load(PathToRes.."../Textures/EnemyTank/YellowTank_RIGHT.pic")
    
    FuckingEnemy.Model = FuckingEnemy.ModelMoveDown

    FuckingEnemy.eventHandler = function(mainContainer,object,eventData) ---Мозги
      if TimeToSpawn < 1 then
        if math.random(100) <= 5 then
          BulletContainer:addChild(Bullet(FuckingEnemy.localX-GameScreenX+6,FuckingEnemy.localY+1,"bullet","enemy",FuckingEnemy.MoveSide,GameScreenX-26, GameScreenY-1 , GameScreenWidth + 2, GameScreenHeight + 2))
          FuckingEnemy.ticks = 10
        end
        
        if FuckingEnemy.ticks > 0 then FuckingEnemy.ticks=FuckingEnemy.ticks-1 end

        if math.random(100) <= 4 then
          ChangeMoveSide()
        end
      end
    end

    FuckingEnemy.draw = function()
      if TimeToSpawn < 1 then
        if FuckingEnemy.MoveSide == "UP" then
          
          FuckingEnemy.Model = FuckingEnemy.ModelMoveUp
          if FuckingEnemy.localY > GameScreenY then FuckingEnemy.localY = FuckingEnemy.localY - 1 else ChangeMoveSide() end --Двигаемся вверх если не упёрлись

        elseif FuckingEnemy.MoveSide == "DOWN" then

          FuckingEnemy.Model = FuckingEnemy.ModelMoveDown
          if FuckingEnemy.localY < GameScreenY+GameScreenHeight-FuckingEnemy.height then FuckingEnemy.localY = FuckingEnemy.localY + 1 else ChangeMoveSide() end --Двигаемся вниз если не упёрлись

        elseif FuckingEnemy.MoveSide == "RIGHT" then

          FuckingEnemy.Model = FuckingEnemy.ModelMoveRight
          if FuckingEnemy.localX < GameScreenX+GameScreenWidth-FuckingEnemy.width then FuckingEnemy.localX = FuckingEnemy.localX + 2 else ChangeMoveSide() end --Двигаемся направо если не упёрлись

        elseif FuckingEnemy.MoveSide == "LEFT" then

          FuckingEnemy.Model = FuckingEnemy.ModelMoveLeft
          if FuckingEnemy.localX > GameScreenX then FuckingEnemy.localX = FuckingEnemy.localX - 2 else ChangeMoveSide() end --Двигаемся налево если не упёрлись

        end

        buffer.drawImage(FuckingEnemy.x, FuckingEnemy.y, FuckingEnemy.Model)
        if FuckingEnemy.ticks > 0 then buffer.drawText(FuckingEnemy.x,FuckingEnemy.y-1,0xFF0000,"Piw-Piw") end
      else
        TimeToSpawn=TimeToSpawn-1
      end
    end
  

    return FuckingEnemy
end