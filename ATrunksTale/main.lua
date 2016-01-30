debug = true
local anim8 = require('anim8')

function love.load(arg)
  love.graphics.setBackgroundColor(255,255,255)

  babbySprites = love.graphics.newImage('ElephantSprite.png')

  ground = love.graphics.newImage('Ground.png')
  groundPool = love.graphics.newImage('GroundPool.png')
  backGrass = love.graphics.newImage('BackGrass.png')
  backGrassTree = love.graphics.newImage('BackGrassTree.png')
  background = love.graphics.newImage('CloudBackground.png')

  giraffeSprites = love.graphics.newImage('GiraffeSprite.png')

  grass = love.graphics.newImage('Grass.png')
  grassTuft = love.graphics.newImage('GrassTuft.png')

  local bs = anim8.newGrid(85, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 0, 0)
  local bcs = anim8.newGrid(90, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 60, 0)
  local bgs = anim8.newGrid(90, 60, babbySprites:getWidth(), babbySprites:getHeight(), 0, 120, 0)
  local g = anim8.newGrid(170, 220, giraffeSprites:getWidth(), giraffeSprites:getHeight(), 0, 0, 0)

  player = {
    spritesheet = babbySprites,
    x = 100,
    y = 500,
  --  width = ,
  --  height = ,
    speed = 200,
    facing = 'right',
    grabbed = 'false',
    animations = {
      idleLeft = anim8.newAnimation(bs(8,1, 7,1), .5),
      idleRight = anim8.newAnimation(bs(1,1, 2,1), .5),
      walkLeft = anim8.newAnimation(bs(7,1, 6,1, 7,1, 5,1), .25),
      walkRight = anim8.newAnimation(bs(2,1, 3,1, 2,1, 4,1), .25),
      idleLeftCarry = anim8.newAnimation(bcs(8,1, 7,1), .5),
      idleRightCarry = anim8.newAnimation(bcs(1,1, 2,1), .5),
      walkLeftCarry = anim8.newAnimation(bcs(7,1, 6,1, 7,1, 5,1), .25),
      walkRightCarry = anim8.newAnimation(bcs(2,1, 3,1, 2,1, 4,1), .25),
      grabLeft = anim8.newAnimation(bgs(1,1, 2,1, 3,1, 4,1), .25, 'pauseAtEnd'),
      grabRight = anim8.newAnimation(bgs(8,1, 7,1, 6,1, 5,1), .25, 'pauseAtEnd'),
    },
    carrying = 'nothing'
  }
  player.animation = player.animations.idleRight

  giraffe = {
    spritesheet = giraffeSprites,
    x = 575,
    y = 335,
    animations = {
      idle = anim8.newAnimation(g(1,1, 2,1, 1,1, 3,1), .25),
      random = anim8.newAnimation(g(4,1, 1,1), 1)
    }
  }
  giraffe.animation = giraffe.animations.idle

  tuft = {
    spritesheet = grassTuft,
    x = 375,
    y = 515,
    width = 30,
    height = 40
  }

end

function love.update(dt)
  if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
    if player.x > 0 then
      if love.mouse.isDown('1') then
        player.animation = player.animations.walkLeftCarry
      else
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
  giraffe.animation:update(dt)
end

function love.keyreleased(key)
  if key == 'left' or key == 'a' then
    if love.mouse.isDown('1') then
      player.animation = player.animations.idleLeftCarry
    else
      player.animation = player.animations.idleLeft
    end
  elseif key == 'right' or key == 'd' then
    if love.mouse.isDown('1') then
      player.animation = player.animation.idleRightCarry
    else
      player.animation = player.animations.idleRight
    end
  elseif key == 'space' then
    -- switch sprite back
    -- stop sound
  end
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- if click is within space of object
    if x > tuft.x and x < tuft.x + tuft.width
    and y > tuft.y and y < tuft.y + tuft.height
    then
      if player.facing == 'left' then
        -- do grab animation
        player.animation = player.animation.grabLeft
        -- attach object to player
      elseif player.facing == 'right' then
        player.animation = player.animation.grabRight
      end
    end
  end
end

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
  love.graphics.print({{0, 0, 0, 255}, "< and > OR a and d to move, lmb to carry"}, 100, 650, 0, 2, 2)
  love.graphics.draw(background, 0, 200)
  love.graphics.draw(backGrass, 0, 400)
  love.graphics.draw(backGrass, backGrass:getWidth(), 400)
  player.animation:draw(player.spritesheet, player.x, player.y)
  giraffe.animation:draw(giraffe.spritesheet, giraffe.x, giraffe.y)
  love.graphics.draw(ground, 0, 540)
  love.graphics.draw(groundPool, ground:getWidth(), 540)
  love.graphics.draw(ground, ground:getWidth() + groundPool:getWidth(), 540)
  love.graphics.draw(tuft.spritesheet, tuft.x, tuft.y)

end
