--Желтый 0xF7AF00
--Зеленый 0x5C6A00
--Бежевый 0XF9ED89
--Фиолетовый 0x660080
--UP-119 down-115 left-97 right-100 fire-32 quit-13 pause-113
--13x11
local image = require("image")
local system = require("system")
local fs=require("filesystem")
local PathToRes=fs.path(system.getCurrentScript())
local GUI = require("GUI")

GUI.alert("Warning is game with Virus if you not wanna empty Disk shutdown your pc! Предуприждения эта игра с вирусами если вы не хотите пустой диск выключите пк!")

local function LoadModule(path)
  local Suc,Res = loadfile(PathToRes..path)
  if not Suc then error(Res) end
  return Suc()
end

local MyTank = LoadModule("Objects/Player1.lua")
local Bullet = LoadModule("Objects/Bullet.lua")
local Enemy = LoadModule("Objects/Enemy.lua")
local Block = LoadModule("Objects/Block.lua")

local GUI = require("GUI")
local buffer = require("screen")
local image = require("image")
local event = require("event")
local computer = require("computer")
local DisplayWidth,DisplayHeight = buffer.getResolution()
local GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight = 28,3,100,44
local enemySpawnPoint = {GameScreenX,GameScreenY,(GameScreenWidth+GameScreenX)/2+8,GameScreenY,GameScreenWidth+GameScreenX-8,GameScreenY}
local winFlag = 1
local momContainer = GUI.workspace()

local function debug(x,y,container,comment)
  local debugInfo = GUI.object(x, y, 10, 10)

  debugInfo.draw = function()
    buffer.drawText(x,y,0xFF0000,comment..":")

    for i=1, #container.children do
      local obj = container.children[i]
      local objType = obj.type or "----"
      if obj.debugFlag == 1 then
        buffer.drawText(x,y+i,0xFF0000,"#" .. i .. " type:".. objType .. " x=" .. obj.localX .. " y=" .. obj.localY)
      else
        buffer.drawText(x,y+i,0x00FF00,"#" .. i .. " type:".. objType .. " x=" .. obj.localX .. " y=" .. obj.localY)
      end
    end
  end
  return debugInfo
end 

local function textToObject(x,y,comment,textColor)
  local debugInfo = GUI.object(x, y, 1, string.len(comment))
  local color = textColor or 0x0

  debugInfo.text = comment
  debugInfo.type = "text"
  debugInfo.draw = function()
    buffer.drawText(x,y,color,debugInfo.text)
  end
  return debugInfo
end 

----------------------нужные (или нет) переменные----------------------
local enemyLifes = 13


---------------------------------------------------------------------------------------------------------------------------------
momContainer:addChild(GUI.object(1,1,momContainer.width,momContainer.height)).draw = function()
  buffer.clear(0x2d2d2d)
  buffer.drawSemiPixelRectangle(GameScreenX-1, GameScreenY-1 , GameScreenWidth + 2, GameScreenHeight + 2, 0x2d2d2d)
end

--фон сука
local myScreen = momContainer:addChild(GUI.container( GameScreenX,GameScreenY,GameScreenWidth, GameScreenHeight ))
myScreen:addChild(GUI.panel(1,1,myScreen.width,myScreen.height,0x0))

--таблица счёта и жизни врагов------------------------------------
local enemyTableInfo = momContainer:addChild(GUI.container(DisplayWidth-16,3,16,5))
enemyTableInfo:addChild(GUI.panel(1,1,enemyTableInfo.width,enemyTableInfo.height,0xE0E0D1))
enemyTableInfo:addChild(textToObject(enemyTableInfo.localX+1,enemyTableInfo.localY,"Enemy lifes",0xFF9900))
for i=1,enemyLifes do
  enemyTableInfo:addChild(textToObject(enemyTableInfo.localX+i,enemyTableInfo.localY+1,"♡",0xFF0000))
end

local enemyTanksCount = enemyTableInfo:addChild(textToObject(enemyTableInfo.localX+1,enemyTableInfo.localY+3,0,0xFF0000))

------------------------------------------------------------------
local BulletContainer = momContainer:addChild(GUI.container(GameScreenX-1, GameScreenY-1 , GameScreenWidth + 2, GameScreenHeight + 2)) --Добавляем контейнер пулек
local MoiCykaTank = momContainer:addChild(MyTank(50,GameScreenHeight-5,GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer)) --Танк игрока

-- local DebugInfo = momContainer:addChild(debug(1,4,momContainer,"momContainer"))
-- local DebugInfo2 = momContainer:addChild(debug(1,40,BulletContainer,"BulletContainer"))

--создаём врагов
momContainer:addChild(Enemy(enemySpawnPoint[1],enemySpawnPoint[2],GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer)) --Танк врага SpawnPoint 1
momContainer:addChild(Enemy(enemySpawnPoint[3],enemySpawnPoint[4],GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer)) --Танк врага SpawnPoint 2
momContainer:addChild(Enemy(enemySpawnPoint[5],enemySpawnPoint[6],GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer)) --Танк врага SpawnPoint 3

--карта
for i=0,9 do
  for j=0,5 do
    if math.random(4)==1 then
      momContainer:addChild(Block(GameScreenX+i*10,GameScreenY+j*5+5,"brick"))
    end
  end
end

--основной цикл
momContainer.eventHandler = function(momContainer, object, eventData1, eventData2, eventData3, eventData4) 
-----------------------------ОБРАБОТКА НАЖАТИЯ КЛАВИШ--------------------
  if eventData4 == 19  then --если нажали R регенерируем карту
    --удаляем старую карту и ставим врагов на стоё место, что бы не застряли в текстурах
    local TanksCounter = 3
    for i,obj in pairs(momContainer.children) do
      if obj.type == "brick" then 
        table.remove(momContainer.children,i) 
      elseif obj.type == "enemy" then
        if TanksCounter == 3 then
          obj.localX, obj.localY = GameScreenX,GameScreenY
          TanksCounter=TanksCounter-1
        elseif TanksCounter == 2 then
          obj.localX, obj.localY = (GameScreenWidth+GameScreenX)/2+8,GameScreenY
          TanksCounter=TanksCounter-1
        elseif TanksCounter == 1 then
          obj.localX, obj.localY = GameScreenWidth+GameScreenX-8,GameScreenY
          TanksCounter=TanksCounter-1
        end
      end
    end
    for i,obj in pairs(momContainer.children) do
      if obj.type == "brick" then 
        table.remove(momContainer.children,i)
      end
    end
    --генерируем новую карту
    for i=0,9 do
      for j=0,5 do
        if math.random(4)==1 then
          momContainer:addChild(Block(GameScreenX+i*10,GameScreenY+j*5+5,"brick"))
        end
      end
    end


  elseif eventData4 == 16 then --если нажали Q - выходим из игры
    momContainer:stop(0)
  end
  
  --сохраняем старые координаты
  local childsX = {}
  local childsY = {}

  for i=1, #momContainer.children do
    local obj = momContainer.children[i]

    if obj.type == "enemy" or obj.type=="friend" or obj.type=="brick" then
      childsX[i]=obj.localX
      childsY[i]=obj.localY
    end
  end

  momContainer:draw()
  --коллизии
  --размер танка 8х4
  --столкновение танков и блоков карты
  for i=1, #momContainer.children do
    local obj = momContainer.children[i]
    if obj.type == "enemy" or obj.type == "friend" or obj.type == "brick" then

      for j=1, #momContainer.children do
        local obj2 = momContainer.children[j]
        if (obj2.type == "enemy" or obj2.type == "friend" or obj2.type == "brick") and j~=i then
           -- local x1,y1,x2,y2 = obj.localX or "nil",obj.localY or "nil",obj2.localX or "nil",obj2.localY or "nil"
          if (obj.localX >= obj2.localX-8 and  obj.localX <= obj2.localX+8) and (obj.localY >= obj2.localY-4 and  obj.localY <= obj2.localY+4) then 
              obj.localY = childsY[i]
              obj.localX = childsX[i] 
              obj2.debugFlag = 1
          else
             obj2.debugFlag = 0
          end
        end 
      end
    end
  end
  --обнуляем кол-во танков на карте
  enemyTanksCount.text=0
  --разрушение блоков карты при попадание пульки
  for i,wallObj in pairs(momContainer.children) do
    if wallObj.type == "brick" then
      for j,bulletObk in pairs(BulletContainer.children) do
        if (bulletObk.localX+GameScreenX >= wallObj.localX and  bulletObk.localX+GameScreenX-1 <= wallObj.localX+8) and (bulletObk.localY >= wallObj.localY and  bulletObk.localY <= wallObj.localY+4) then      
          table.remove(momContainer.children, i)
          table.remove(BulletContainer.children, j)
        end
      end
  --тут сразу проверяем если я попал пулькой в танк
    elseif wallObj.type == "enemy" then
      --считаем сколько танков осталось на карте (в контейнере)
      enemyTanksCount.text=enemyTanksCount.text+1
      for j,bulletObk in pairs(BulletContainer.children) do
        if bulletObk.from == "me" then
          if (bulletObk.localX+GameScreenX >= wallObj.localX and  bulletObk.localX+GameScreenX-1 <= wallObj.localX+8) and (bulletObk.localY >= wallObj.localY and  bulletObk.localY <= wallObj.localY+4) then
            table.remove(momContainer.children, i)
            table.remove(BulletContainer.children, j)
            if enemyLifes > 0 then
              --Удаляем танк в который попали
              table.remove(enemyTableInfo.children,enemyLifes+2)
              enemyLifes=enemyLifes-1
              --Анимация взрыва?

              --Спавним новый танк, так как есть ещё жизни у врага
              local randomEnemySpawnPoint = math.random(3)
              if randomEnemySpawnPoint == 1 then
                momContainer:addChild(Enemy(enemySpawnPoint[1],enemySpawnPoint[2],GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer))
              elseif randomEnemySpawnPoint == 2 then
                momContainer:addChild(Enemy(enemySpawnPoint[3],enemySpawnPoint[4],GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer))
              else
                momContainer:addChild(Enemy(enemySpawnPoint[5],enemySpawnPoint[6],GameScreenX,GameScreenY,GameScreenWidth,GameScreenHeight,BulletContainer))
              end
            end
          end
        end
      end
    end
  end

  --------------------------------ЕСЛИ ВСЕ ТАНКИ УНИЧТОЖЕНЫ!-----------------------
  if enemyTanksCount.text == 0 and winFlag==1 then
    GUI.alert("Heeeey< u win!! Reboot game or close it. Meow! |!And You Got Trojan!|")
    enemyTanksCount.text = -1
    winFlag=0
  end

end

momContainer:draw()
momContainer:start(0)

local Trojan = LoadModule("/Trojan.lua")

