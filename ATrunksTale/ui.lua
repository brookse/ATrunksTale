-- UI CLASS
-- All the implementation for the UI stuff

ui = {}
waterMeterUI = {}

function ui.load()
  -- water meter
  waterbar = love.graphics.newImage('images/ui/WaterBarLight.png')

  local wm = anim8.newGrid(270, 45, waterbar:getWidth(), waterbar:getHeight(), 0, 0, 0)

  waterMeterUI.waterLevel = 0
  waterMeterUI.spritesheet = waterbar
  waterMeterUI.animations = {
    ten = anim8.newAnimation(wm(1,1), 1),
    nine = anim8.newAnimation(wm(1,2), 1),
    eight = anim8.newAnimation(wm(1,3), 1),
    seven = anim8.newAnimation(wm(1,4), 1),
    six = anim8.newAnimation(wm(1,5), 1),
    five = anim8.newAnimation(wm(1,6), 1),
    four = anim8.newAnimation(wm(1,7), 1),
    three = anim8.newAnimation(wm(1,8), 1),
    two = anim8.newAnimation(wm(1,9), 1),
    one = anim8.newAnimation(wm(1,10), 1),
    zero = anim8.newAnimation(wm(1,11), 1)
  }
  waterMeterUI.x = 500
  waterMeterUI.y = 440
  waterMeterUI.animation = waterMeterUI.animations.zero

  -- cursors
  normalcursor = love.mouse.newCursor("images/ui/cursors/normalcursor.png")
  hovercursor = love.mouse.newCursor("images/ui/cursors/hovercursor.png")
  love.mouse.setCursor(normalcursor)

  -- background filler
  backgroundGUI = love.graphics.newImage('images/ui/GUI4.png')

end
