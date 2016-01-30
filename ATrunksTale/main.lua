debug = true
local anim8 = require('anim8')

function love.load(arg)
  love.graphics.setBackgroundColor(255,255,255)

  babbySprites = love.graphics.newImage('ElephantSprite.png')
  local bs = anim8.newGrid(85, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 0, 0)
  local bcs = anim8.newGrid(90, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 60, 0)
  local bgs = anim8.newGrid(90, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 120, 0)

  player = {
    spritesheet = babbySprites,
    x = 100,
    y = 500,
  --  width = ,
  --  height = ,
    speed = 200,
    facing = 'right',
    animations = {
      idleLeft = anim8.newAnimation(bs(8,1, 7,1), .5),
      idleRight = anim8.newAnimation(bs(1,1, 2,1), .5),
      walkLeft = anim8.newAnimation(bs(7,1, 6,1, 7,1, 5,1), .25),
      walkRight = anim8.newAnimation(bs(2,1, 3,1, 2,1, 4,1), .25),
      idleLeftCarry = anim8.newAnimation(bcs(8,1, 7,1), .5),
      idleRightCarry = anim8.newAnimation(bcs(1,1, 2,1), .5),
      walkLeftCarry = anim8.newAnimation(bcs(7,1, 6,1, 7,1, 5,1), .25),
      walkRightCarry = anim8.newAnimation(bcs(2,1, 3,1, 2,1, 4,1), .25),
      grabLeft = anim8.newAnimation(bgs(1,1, 2,1, 3,1), .25),
      grabRight = anim8.newAnimation(bgs(8,1, 7,1, 6,1), .25),
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

--[==[   tuft = {
    spritesheet = tuftSprites,
    x = 300,
    y = 500,
    animations  = {
      tuft = anim8.newAnimation(g(), 1),
      bundle = anim8.newAnimation(g(), 1)
    }
  }
--]==]
end

function love.update(dt)
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    if player.x > 0 then
      if love.mouse.isDown('1') then
        player.animation = player.animations.walkLeftCarry
      else
        player.trunkLocation = player.trunkLocations.walkLeft
        player.animation = player.animations.walkLeft
      end
      player.x = player.x - (player.speed*dt)
      player.facing = 'left'
    end
  elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
    if player.x < (love.graphics.getWidth() - 120) then
      if love.mouse.isDown('1') then
        player.animation = player.animations.walkRightCarry
      else
        player.animation = player.animations.walkRight
        player.trunkLocation = player.trunkLocations.walkRight
      end
      player.x = player.x + (player.speed*dt)
      player.facing = 'right'
    end
--[=[  elseif love.keyboard.isDown('space') then
    -- play sound
    -- switch to sprite--]=]
  else
    if love.mouse.isDown('1') then
      if player.facing == 'left' then
        if not love.keyboard.isDown('left') or not love.keyboard.isDown('a') then
          -- idling left
          player.animation = player.animations.idleLeftCarry
        end
      elseif player.facing == 'right' then
        if not love.keyboard.isDown('right') or not love.keyboard.isDown('d') then
          -- idling right
          player.animation = player.animations.idleRightCarry
        end
      end
    end
  end
  player.animation:update(dt)
end

function love.keyreleased(key)
  if key == 'left' or key == 'a' then
    if love.mouse.isDown('1') then
      player.animation = player.animations.idleLeftCarry
    else
      player.animation = player.animations.idleLeft
      player.trunkLocation = player.trunkLocations.idleLeft
    end
  elseif key == 'right' or key == 'd' then
    if love.mouse.isDown('1') then
      player.animation = player.animation.idleRightCarry
    else
      player.animation = player.animations.idleRight
      player.trunkLocation = player.trunkLocations.idleRight
    end
  elseif key == 'space' then
    -- switch sprite back
    -- stop sound
  end
end

--[=[
function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    if player.facing == 'left' then
      if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        -- walking, show left walk grab
        player.animation = player.animations.walkLeftCarry
      else
        -- idling left
        player.animation = player.animations.idleLeftCarry
      end
    elseif player.facing == 'right' then
      if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        -- walking, show right walk grab
        player.animation = player.animations.walkRightCarry
      else
        -- idling right
        player.animation = player.animations.idleRightCarry
      end
    end
  end

--[==[  if button == '1'
    and x > tuft.x and x < tuft.x + tuft.width
    and y > tuft.y and y < tuft.y + tuft.height
    and math.abs(player.x - tuft.x) < 10        -- within grabbing distance
  then
    if player.facing == 'left' then
      -- switch to left holding
    elseif player.facing == 'right' then
      -- switch to right holding
    end
  end
--]==]
end
--]=]

function love.mousereleased(x, y, button, istouch)
  if button == 1 then
    if player.facing == 'left' then
      if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        -- walking, show left walk grab
        player.animation = player.animations.walkLeft
      else
        -- idling left
        player.animation = player.animations.idleLeft
      end
    elseif player.facing == 'right' then
      if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        -- walking, show left walk grab
        player.animation = player.animations.walkRight
      else
        -- idling left
        player.animation = player.animations.idleRight
      end
    end
  end
end

function love.draw(dt)
  player.animation:draw(player.spritesheet, player.x, player.y)

  love.graphics.print({{0, 0, 0, 255}, "< and > OR a and d to move, lmb to carry"}, 100, 100, 0, 2, 2)

--[==[  local mx, my = love.mouse.getPosition()
  w = love.graphics.getWidth() / 2
  h = love.graphics.getHeight() / 2

  trunkX = player.x + player.trunkLocation.x
  trunkY = player.y + player.trunkLocation.y

  love.graphics.setColor(255, 0, 0)
  love.graphics.setLineWidth(5)
  love.graphics.setLineStyle("rough")
  love.graphics.line(trunkX, trunkY, mx, my)
  love.graphics.setColor(255,255,255)
--]==]
end
