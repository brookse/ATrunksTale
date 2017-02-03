-- PLAYER CLASS
-- All the implementation for the player, the baby elephant
require 'giraffe'
require 'snake'
require 'ui'

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
    runLeft = anim8.newAnimation(bcs(7,1, 6,1, 7,1, 5,1), .25),
    runRight = anim8.newAnimation(bcs(2,1, 3,1, 2,1, 4,1), .25),
    grabRight = anim8.newAnimation(bgs(1,1, 2,1, 3,1, 4,1), .25, 'pauseAtEnd'),
    grabLeft = anim8.newAnimation(bgs(8,1, 7,1, 6,1, 5,1), .25, 'pauseAtEnd'),
    drinkLeft = anim8.newAnimation(bssleft(6,1, 5,1, 4,1), .25, 'pauseAtEnd'),
    drinkRight = anim8.newAnimation(bssright(1,1, 2,1, 3,1), .25, 'pauseAtEnd'),
    sprayLeft = anim8.newAnimation(bssleft(6,1, 5,1, 4,1, 3,1, 2,1, 1,1, 4,1, 5,1, 6,1), .1, 'pauseAtEnd'),
    sprayRight = anim8.newAnimation(bssright(1,1, 2,1, 3,1, 4,1, 5,1, 6,1, 3,1, 2,1, 1,1), .1, 'pauseAtEnd')
  }
  player.carrying = 'nothing'

  player.animation = player.animations.idleRight
  player.width = 85
  player.height = 60

end

function player.update(dt)
  -- adjust the width depending on the animation
  if player.animation == player.animations.idleRight or
    player.animation == player.animations.idleLeft or
    player.animation == player.animations.walkLeft or
    player.animation == player.animations.walkRight then
      player.width = 85
  elseif player.animation == player.animations.idleLeftCarry or
    player.animation == player.animations.idleRightCarry or
    player.animation == player.animations.runLeft or
    player.animation == player.animations.runRight or
    player.animation == player.animations.grabRight or
    player.animation == player.animations.grabLeft then
      player.width = 90
  elseif player.animation == player.animations.drinkLeft or
    player.animation == player.animations.drinkRight or
    player.animation == player.animations.sprayLeft or
    player.animation == player.animations.sprayRight then
      player.width = 140
  end
  player.move(dt)
end

function player.move(dt)
  -- player is moving left
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    if player.x > -200 then
      if love.mouse.isDown('2') then
        -- player is running left
        player.animation = player.animations.runLeft
        player.speed = 300
        -- check for bashing
        if player.x+player.width >= bashable.x and player.x+player.width <= bashable.x+bashable.width then
          bashable.animation = bashable.animations.breaking
          stext.animation = stext.animations.invisible
          sheart.animation = sheart.animations.visible
          tutorialQuests.Qthree = true
        end
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
        player.animation = player.animations.runRight
        player.speed = 300
        -- check for bashing
        if player.x+player.width >= bashable.x and player.x+player.width <= bashable.x+bashable.width then
          bashable.animation = bashable.animations.breaking
          stext.animation = stext.animations.invisible
          sheart.animation = sheart.animations.visible
          tutorialQuests.Qthree = true
        end
      else
        -- player is walking right
        player.animation = player.animations.walkRight
        player.speed = 200
      end
      player.x = player.x + (player.speed*dt)
      player.facing = 'right'
    end
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
    if love.mouse.isDown('2') or love.mouse.isDown('1') then
      player.animation = player.animations.idleLeftCarry
      player.speed = 200
    else
      player.animation = player.animations.idleLeft
      player.speed = 200
    end
  elseif key == 'right' or key == 'd' then
    if love.mouse.isDown('2') or love.mouse.isDown('1') then
      player.animation = player.animations.idleRightCarry
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
      if waterMeterUI.waterLevel > 0 then
        -- play left spray animation
        player.animation = player.animations.sprayLeft
        player.animation:gotoFrame(1)
        player.animation:resume()

        if player.x > birds.x then
          birds.animation = birds.animations.flying
          bheart.animation = bheart.animations.visible
          tutorialQuests.Qtwo = true
        end

        -- decrement water meter data
        waterMeterUI.waterLevel = waterMeterUI.waterLevel - 1
        -- return to left idle

        -- update UI
        checkWater()
      end
    elseif player.facing == 'right' then
      -- make sure you can spray
      if waterMeterUI.waterLevel > 0 then
        -- play right spray animation
        player.animation = player.animations.sprayRight
        player.animation:gotoFrame(1)
        player.animation:resume()

        if player.x < birds.x and tutorialQuests.Qtwo == false then
          birds.animation = birds.animations.flying
          bheart.animation = bheart.animations.visible
          tutorialQuests.Qtwo = true
        end

        -- decrement water meter data
        waterMeterUI.waterLevel = waterMeterUI.waterLevel - 1
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
  elseif button == 1 then
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
    and tutorialQuests.Qone == false
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
        tutorialQuests.Qone = true
      elseif player.facing == 'right' then
        player.animation = player.animations.grabRight
    --    player.animation:gotoFrame(1)
    --    player.animation:resume()

        tuft.animation = tuft.animations.invisible
        text.animation = text.animations.invisible
        heart.animation = heart.animations.visible
        tutorialQuests.Qone = true
      end
    end

    -- quest checking for giraffe
    if x > giraffe.x and x < giraffe.x + giraffe.width
    and y > giraffe.y and y < giraffe.y + giraffe.height
    then
      text.animation = text.animations.visible
    end

    -- quest checking for bird
    if x > bird.x and x < bird.x + bird.width
    and y > bird.y and y < bird.y + bird.height
    then
      bird.animation = bird.animations.pointLeft
    end

    if x > snake.x and x < snake.x + snake.width
    and y > snake.y and y < snake.y + snake.height
    then
      stext.animation = stext.animations.visible
    end

    -- check for water drink
    if x > 1050 and x < 1300
    and y > 300
    then
      if waterMeterUI.waterLevel < 10 then
        waterMeterUI.waterLevel = waterMeterUI.waterLevel + 1

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
  if waterMeterUI.waterLevel == 0 then
    waterMeterUI.animation = waterMeterUI.animations.zero
  elseif waterMeterUI.waterLevel == 1 then
    waterMeterUI.animation = waterMeterUI.animations.one
  elseif waterMeterUI.waterLevel == 2 then
    waterMeterUI.animation = waterMeterUI.animations.two
  elseif waterMeterUI.waterLevel == 3 then
    waterMeterUI.animation = waterMeterUI.animations.three
  elseif waterMeterUI.waterLevel == 4 then
    waterMeterUI.animation = waterMeterUI.animations.four
  elseif waterMeterUI.waterLevel == 5 then
    waterMeterUI.animation = waterMeterUI.animations.five
  elseif waterMeterUI.waterLevel == 6 then
    waterMeterUI.animation = waterMeterUI.animations.six
  elseif waterMeterUI.waterLevel == 7 then
    waterMeterUI.animation = waterMeterUI.animations.seven
  elseif waterMeterUI.waterLevel == 8 then
    waterMeterUI.animation = waterMeterUI.animations.eight
  elseif waterMeterUI.waterLevel == 9 then
      waterMeterUI.animation = waterMeterUI.animations.nine
  elseif waterMeterUI.waterLevel == 10 then
    waterMeterUI.animation = waterMeterUI.animations.ten
  end
end
