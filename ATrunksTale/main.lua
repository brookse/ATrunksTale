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
    },
    trunkLocations = {
      idleLeft = {
        x = 8,
        y = 32
      },
      idleRight = {
        x = 77,
        y = 32
      },
      walkLeft = {
        x = 6,
        y = 25
      },
      walkRight = {
        x = 79,
        y = 25
      }
    }
  }
  player.animation = player.animations.idleRight
  player.trunkLocation = player.trunkLocations.idleRight
end

function love.update(dt)
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    if player.x > 0 then
      player.x = player.x - (player.speed*dt)
      player.animation = player.animations.walkLeft
      player.trunkLocation = player.trunkLocations.walkLeft
    end
  elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
    if player.x < (love.graphics.getWidth() - 120) then
      player.x = player.x + (player.speed*dt)
      player.animation = player.animations.walkRight
      player.trunkLocation = player.trunkLocations.walkRight
    end
  end
  player.animation:update(dt)

end

function love.keyreleased(key)
  if key == 'left' or key == 'a' then
    player.animation = player.animations.idleLeft
    player.trunkLocation = player.trunkLocations.idleLeft
  elseif key == 'right' or key == 'd' then
    player.animation = player.animations.idleRight
    player.trunkLocation = player.trunkLocations.idleRight
  end
end

function love.draw(dt)
  player.animation:draw(player.spritesheet, player.x, player.y)

  love.graphics.print({{0, 0, 0, 255}, "< and > OR a and d to move"}, 100, 100, 0, 2, 2)

  local mx, my = love.mouse.getPosition()
  w = love.graphics.getWidth() / 2
  h = love.graphics.getHeight() / 2

  trunkX = player.x + player.trunkLocation.x
  trunkY = player.y + player.trunkLocation.y

  love.graphics.setColor(255, 0, 0)
  love.graphics.setLineWidth(5)
  love.graphics.setLineStyle("rough")
  love.graphics.line(trunkX, trunkY, mx, my)
  love.graphics.setColor(255,255,255)
end
