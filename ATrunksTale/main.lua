debug = true
anim8 = require('anim8')
require 'player'

function love.load(arg)
  love.graphics.setBackgroundColor(255,255,255)

  ground = love.graphics.newImage('images/backdrops/Ground.png')
  groundPool = love.graphics.newImage('images/backdrops/GroundPool.png')
  backGrass = love.graphics.newImage('images/backdrops/BackGrass.png')
  backGrassTree = love.graphics.newImage('images/backdrops/BackGrassTree.png')
  background = love.graphics.newImage('images/backdrops/CloudBackground.png')

  giraffeSprites = love.graphics.newImage('images/characters/GiraffeSprite.png')
  giraffeText = love.graphics.newImage('images/misc/GiraffeText.png')
  giraffeHeart = love.graphics.newImage('images/misc/Heart.png')

  grass = love.graphics.newImage('images/misc/Grass.png')
  grassTuft = love.graphics.newImage('images/misc/GrassTuft.png')

  local g = anim8.newGrid(170, 220, giraffeSprites:getWidth(), giraffeSprites:getHeight(), 0, 0, 0)

  local r = anim8.newGrid(70, 70, giraffeText:getWidth(), giraffeText:getHeight(), 0, 0, 0)
  local h = anim8.newGrid(65, 70, giraffeHeart:getWidth(), giraffeHeart:getHeight(), 0, 0, 0)

  local t = anim8.newGrid(30, 40, grassTuft:getWidth(), grassTuft:getHeight(), 0, 0, 0)

  player.load()

  giraffe = {
    spritesheet = giraffeSprites,
    x = 575,
    y = 135,
    width = 170,
    height = 220,
    animations = {
      idle = anim8.newAnimation(g(1,1, 2,1, 1,1, 3,1), .25),
      random = anim8.newAnimation(g(4,1, 1,1), 1)
    },
    love = 0
  }
  giraffe.animation = giraffe.animations.idle

  tuft = {
    spritesheet = grassTuft,
    animations = {
      visible = anim8.newAnimation(t(1,1), 1),
      invisible = anim8.newAnimation(t(2,1), 1)
    },
    x = 375,
    y = 315,
    width = 30,
    height = 40
  }
  tuft.animation = tuft.animations.visible

  text = {
    spritesheet = giraffeText,
    animations = {
      visible = anim8.newAnimation(r(1,1), 1),
      invisible = anim8.newAnimation(r(2,1), 1)
    },
    x = 500,
    y = 50
  }
  text.animation = text.animations.invisible

  heart = {
    spritesheet = giraffeHeart,
    animations = {
      visible = anim8.newAnimation(h(2,1, 1,1), .5),
      invisible = anim8.newAnimation(h(3,1), 1)
    },
    x = 575,
    y = 50
  }
  heart.animation = heart.animations.invisible

end

function love.update(dt)
  player.update(dt)
  giraffe.animation:update(dt)
  heart.animation:update(dt)
end

function love.mousepressed(x, y, button, istouch)
  if button == 2 then
    -- if click is within space of tuft
    if x > tuft.x and x < tuft.x + tuft.width
    and y > tuft.y and y < tuft.y + tuft.height
    and math.abs(tuft.x - (player.x + 80)) < 30
    then
      if player.facing == 'left' then
        -- do grab animation
        player.animation = player.animations.grabLeft
        -- attach object to player
        player.carrying = grass                       -- TODO fix this
        -- delete tuft
        tuft.animation = tuft.animations.invisible
        text.animation = text.animations.invisible
        heart.animation = heart.animations.visible
      elseif player.facing == 'right' then
        player.animation = player.animations.grabRight

        tuft.animation = tuft.animations.invisible
        text.animation = text.animations.invisible
        heart.animation = heart.animations.visible
      end
    end

    -- quest checking for giraffe
    if x > giraffe.x and x < giraffe.x + giraffe.width
    and y > giraffe.y and y < giraffe.y + giraffe.height
    and math.abs(giraffe.x - (player.x)) < 30
    then
      text.animation = text.animations.visible
    end
  end
end

function love.mousereleased(x, y, button, istouch)
  -- stopped sprinting
  if button == 1 then
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

function love.draw(dt)
  love.graphics.draw(background, 0, 0)
  love.graphics.print({{0, 0, 0, 255}, "A and D to move, LMB to sprint, RMB to interact"}, 80, 450, 0, 2, 2)
  love.graphics.draw(backGrass, 0, 200)
  love.graphics.draw(backGrass, backGrass:getWidth(), 200)
  player.animation:draw(player.spritesheet, player.x, player.y)
  if player.carrying == 'nothing' then else
    love.graphics.draw(grass, player.x, player.y)
  end
  giraffe.animation:draw(giraffe.spritesheet, giraffe.x, giraffe.y)
  love.graphics.draw(ground, 0, 340)
  love.graphics.draw(groundPool, ground:getWidth(), 340)
  love.graphics.draw(ground, ground:getWidth() + groundPool:getWidth(), 340)
  tuft.animation:draw(tuft.spritesheet, tuft.x, tuft.y)
  text.animation:draw(text.spritesheet, text.x, text.y)
  heart.animation:draw(heart.spritesheet, heart.x, heart.y)

  love.graphics.push()
  love.graphics.translate(-player.x, 0)
  love.graphics.pop()

end
