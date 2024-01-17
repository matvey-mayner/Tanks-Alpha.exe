local GUI = require("GUI")
local buffer = require("screen")
local image = require("image")
local system = require("system")
local fs=require("filesystem")
local PathToRes=fs.path(system.getCurrentScript())

return function (x, y, model)
  local Block = GUI.object(x, y, 8, 4)
  Block.type = model
  Block.localX = x
  Block.localY = y

  Brick = image.load(PathToRes.."../Textures/Map/Brick.pic")
  Base = image.load(PathToRes.."../Textures/Map/Base.pic")

 Block.model = Brick
 if model == "brick" then Block.model = Brick end
 if model == "base"  then Block.model = Base end

  Block.draw = function()
    buffer.drawImage(Block.x, Block.y, Block.model)
  end
  
   -- Block.eventHandler = function(mainContainer,object,eventData)

   -- end
  
  return Block
end
