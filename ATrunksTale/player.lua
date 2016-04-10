-- PLAYER CLASS
-- All the implementation for the player, the baby elephant
require 'giraffe'
player = {}

function player.load()
  -- load elephant sprite image
  babbySprites = love.graphics.newImage('images/characters/ElephantSpritesheet.png')

  -- create animation grids for idle and walk, carry, and grabbing
  local bs = anim8.newGrid(85, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 0, 0)
  local bcs = anim8.newGrid(90, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 60, 0)
  local bgs = anim8.newGrid(90, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 120, 0)
  local bssright = anim8.newGrid(140, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 180, 0)
  local bssleft = anim8.newGrid(140, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 240, 0)

  -- create player data model
  player.spritesheet = babbySprites
  player.x = 0
  player.y = 300
  player.speed = 200
  player.facing = 'right'
  player.grabbed = 'false'
  player.animations = {
    idleLeft = anim8.newAnimation(bs(8,1, 7,1), .5),
    idleRight = anim8.newAnimation(bs(1,1, 2,1), .5),
    walkLeft = anim8.newAnimation(bs(7,1, 6,1, 7,1, 5,1), .25),
    walkRight = anim8.newAnimation(bs(2,1, 3,1, 2,1, 4,1), .25),
    idleLeftCarry = anim8.newAnimation(bcs(8,1, 7,1), .5),
    idleRightCarry = anim8.newAnimation(bcs(1,1, 2,1), .5),
    walkLeftCarry = anim8.newAnimation(bcs(7,1, 6,1, 7,1, 5,1), .25),
    walkRightCarry = anim8.newAnimation(bcs(2,1, 3,1, 2,1, 4,1), .25),
    grabRight = anim8.newAnimation(bgs(1,1, 2,1, 3,1, 4,1), .25, 'pauseAtEnd'),
    grabLeft = anim8.newAnimation(bgs(8,1, 7,1, 6,1, 5,1), .25, 'pauseAtEnd'),
    drinkLeft = anim8.newAnimation(bssleft(6,1, 5,1, 4,1), .25, 'pauseAtEnd'),
    drinkRight = anim8.newAnimation(bssright(1,1, 2,1, 3,1), .25, 'pauseAtEnd'),
    sprayLeft = anim8.newAnimation(bssleft(6,1, 5,1, 4,1, 3,1, 2,1, 1,1, 4,1, 5,1, 6,1), .1, 'pauseAtEnd'),
    sprayRight = anim8.newAnimation(bssright(1,1, 2,1, 3,1, 4,1, 5,1, 6,1, 3,1, 2,1, 1,1), .1, 'pauseAtEnd')
  }
  player.carrying = 'nothing'

  player.animation = player.animations.idleRight

end

function player.update(dt)
  player.move(dt)
end

--[[
function player.draw()
  player.animation:draw(player.spritesheet, player.x, player.y)
end
]]

function player.move(dt)
  -- player is moving left
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    if player.x > -200 then
      if love.mouse.isDown('2') then
        -- player is running left
        player.animation = player.animations.walkLeftCarry
        player.speed = 300
      else
        -- player is walking left
        player.animation = player.animations.walkLeft
        player.speed = 200
      end
      player.x = player.x - (player.speed*dt)
      player.facing = 'left'
    end
  -- player is moving right
  elseif love.keyboard.isDown('right') or love.keyboard.isDown('d') then
    if player.x < (GroundTiles[3]:getWidth() - 300) then
      if love.mouse.isDown('2') then
        -- player is running right
        player.animation = player.animations.walkRightCarry
        player.speed = 300
      else
        -- player is walking right
        player.animation = player.animations.walkRight
        player.speed = 200
      end
      player.x = player.x + (player.speed*dt)
      player.facing = 'right'
    end
--[=[  elseif love.keyboard.isDown('space') then
    -- play sound
    -- switch to sprite--]=]
  else
    -- player is not moving, but is carrying trunk
    if love.mouse.isDown('1') then
      if player.facing == 'left' then
        if not love.keyboard.isDown('left') or not love.keyboard.isDown('a') then
          -- idling left with trunk carried
          player.animation = player.animations.idleLeftCarry
          player.speed = 300
        end
      elseif player.facing == 'right' then
        if not love.keyboard.isDown('right') or not love.keyboard.isDown('d') then
          -- idling right with trunk carried
          player.animation = player.animations.idleRightCarry
          player.speed = 300
        end
      end
    end
  end
  player.animation:update(dt)
end

function love.keyreleased(key)
  if key == 'left' or key == 'a' then
    if love.mouse.isDown('2') then
      player.animation = player.animations.idleLeftCarry
      player.speed = 200
    else
      player.animation = player.animations.idleLeft
      player.speed = 200
    end
  elseif key == 'right' or key == 'd' then
    if love.mouse.isDown('2') then
      player.animation = player.animation.idleRightCarry
      player.speed = 200
    else
      player.animation = player.animations.idleRight
      player.speed = 200
    end
  elseif key == 'space' then
    -- spray water trigger
    -- find orientation
    if player.facing == 'left' then
      -- make sure you can spray
      if waterMeter > 0 then
        -- play left spray animation
        player.animation = player.animations.sprayLeft
        player.animation:gotoFrame(1)
        player.animation:resume()

        if player.x > birds.x then
          birds.animation = birds.animations.flying
          bheart.animation = bheart.animations.visible
        end

        -- decrement water meter data
        waterMeter = waterMeter - 1
        -- return to left idle

        -- update UI
        checkWater()
      end
    elseif player.facing == 'right' then
      -- make sure you can spray
      if waterMeter > 0 then
        -- play right spray animation
        player.animation = player.animations.sprayRight
        player.animation:gotoFrame(1)
        player.animation:resume()

        if player.x < birds.x then
          birds.animation = birds.animations.flying
          bheart.animation = bheart.animations.visible
        end

        -- decrement water meter data
        waterMeter = waterMeter - 1
        -- return to right idle

        -- update UI
        checkWater()
      end
    end

  end
end

function love.mousereleased(x, y, button, istouch)
  -- stopped sprinting
  if button == 2 then
    if player.facing == 'left' then
      if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        -- walking, show left walk
        player.animation = player.animations.walkLeft
        player.speed = 200
      else
        -- idling left
        player.animation = player.animations.idleLeft
        player.speed = 200
      end
    elseif player.facing == 'right' then
      if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        -- walking, show right walk
        player.animation = player.animations.walkRight
        player.speed = 200
      else
        -- idling right
        player.animation = player.animations.idleRight
        player.speed = 200
      end
    end
  end
end

function love.mousepressed(x, y, button, istouch)
  x, y = camera:mousePosition()
  if button == 1 then
    -- if click is within space of tuft
    if x > tuft.x and x < tuft.x + tuft.width
    and y > tuft.y and y < tuft.y + tuft.height
    and math.abs(tuft.x - (player.x + 80)) < 100
    then
      if player.facing == 'left' then
        -- do grab animation
        player.animation = player.animations.grabLeft
    --    player.animation:gotoFrame(1)
    --    player.animation:resume()

        -- attach object to player
    --    player.carrying = grass                       -- TODO fix this
        -- delete tuft
        tuft.animation = tuft.animations.invisible
        text.animation = text.animations.invisible
        heart.animation = heart.animations.visible
      elseif player.facing == 'right' then
        player.animation = player.animations.grabRight
    --    player.animation:gotoFrame(1)
    --    player.animation:resume()

        tuft.animation = tuft.animations.invisible
        text.animation = text.animations.invisible
        heart.animation = heart.animations.visible
      end
    end

    -- quest checking for giraffe
    if x > giraffe.x and x < giraffe.x + giraffe.width
    and y > giraffe.y and y < giraffe.y + giraffe.height
    and math.abs(giraffe.x - (player.x)) < 100
    then
      text.animation = text.animations.visible
    end

    -- quest checking for bird
    if x > bird.x and x < bird.x + bird.width
    and y > bird.y and y < bird.y + bird.height
    then
      bird.animation = bird.animations.pointLeft
    end

    -- check for water drink
    if x > 1050 and x < 1300
    and y > 300
    then
      if waterMeter < 10 then
        waterMeter = waterMeter + 1

        checkWater()

        if player.facing == 'left' then
          player.animation = player.animations.drinkLeft
        elseif player.facing == 'right' then
          player.animation = player.animations.drinkRight
        end

      end
    end

  end
end

function checkWater()
  if waterMeter == 0 then
    waterMeterUI.animation = waterMeterUI.animations.zero
  elseif waterMeter == 1 then
    waterMeterUI.animation = waterMeterUI.animations.one
  elseif waterMeter == 2 then
    waterMeterUI.animation = waterMeterUI.animations.two
  elseif waterMeter == 3 then
    waterMeterUI.animation = waterMeterUI.animations.three
  elseif waterMeter == 4 then
    waterMeterUI.animation = waterMeterUI.animations.four
  elseif waterMeter == 5 then
    waterMeterUI.animation = waterMeterUI.animations.five
  elseif waterMeter == 6 then
    waterMeterUI.animation = waterMeterUI.animations.six
  elseif waterMeter == 7 then
    waterMeterUI.animation = waterMeterUI.animations.seven
  elseif waterMeter == 8 then
    waterMeterUI.animation = waterMeterUI.animations.eight
  elseif waterMeter == 9 then
      waterMeterUI.animation = waterMeterUI.animations.nine
  elseif waterMeter == 10 then
    waterMeterUI.animation = waterMeterUI.animations.ten
  end
end
