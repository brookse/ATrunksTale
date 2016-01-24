debug = true
local anim8 = require('anim8')

function love.load(arg)
  love.graphics.setBackgroundColor(255,255,255)

  local spritesheet = love.graphics.newImage('IdleandWalkTransparent.png')
  local g = anim8.newGrid(85, 60, spritesheet:getWidth(), spritesheet:getHeight())

  player = {
    spritesheet = spritesheet,
    x = 100,
    y = 500,
    speed = 200,
    animations = {
      idleLeft = anim8.newAnimation(g(8,1, 7,1), .5),
      idleRight = anim8.newAnimation(g(1,1, 2,1), .5),
      walkLeft = anim8.newAnimation(g(7,1, 6,1, 7,1, 5,1), .25),
      walkRight = anim8.newAnimation(g(2,1, 3,1, 2,1, 4,1), .25)
    }
  }
  player.animation = player.animations.idleRight
end

function love.update(dt)
  if love.keyboard.isDown('left') then
    if player.x > 0 then
      player.x = player.x - (player.speed*dt)
      player.animation = player.animations.walkLeft
    end
  elseif love.keyboard.isDown('right') then
    if player.x < (love.graphics.getWidth() - 120) then
      player.x = player.x + (player.speed*dt)
      player.animation = player.animations.walkRight
    end
  end
  player.animation:update(dt)
end

function love.keyreleased(key)
  if key == 'left' then
    player.animation = player.animations.idleLeft
  elseif key == 'right' then
    player.animation = player.animations.idleRight
  end
end

function love.draw(dt)
  player.animation:draw(player.spritesheet, player.x, player.y)

  love.graphics.print({{0, 0, 0, 255}, "< and > to move"}, 100, 100, 0, 2, 2)
end
