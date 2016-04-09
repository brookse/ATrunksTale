debug = true
anim8 = require('anim8')
require 'player'
require 'giraffe'
require 'camera'

function love.load(arg)
  love.graphics.setBackgroundColor(255,255,255)

  -- load background images
  GroundTiles = {}  -- all ground tiles
  GroundTiles[1] = love.graphics.newImage('images/backdrops/Ground.png')      -- 1 = ground
  GroundTiles[2] = love.graphics.newImage('images/backdrops/GroundPool.png')  -- 2 = ground with pool
  GroundTiles[3] = love.graphics.newImage('images/backdrops/GroundRepeatTransparent.png')

  BackgroundTiles = {}  -- all background tiles
  BackgroundTiles[1] = love.graphics.newImage('images/backdrops/CloudBackground.png') -- 1 = daytime background
  BackgroundTiles[2] = love.graphics.newImage('images/backdrops/CloudBackgroundRepeat.png')

  backGrass = love.graphics.newImage('images/backdrops/BackGrass.png')
  backGrassTree = love.graphics.newImage('images/backdrops/BackGrassTree.png')
  backGrassRepeat = love.graphics.newImage('images/backdrops/BackGrassRepeatTransparent.png')

  grass = love.graphics.newImage('images/misc/Grass.png')
  grassTuft = love.graphics.newImage('images/misc/GrassTuft.png')

  -- create ground table
  GroundMap = { 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2 }

  -- create background table
  BackgroundMap = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }

  local t = anim8.newGrid(30, 40, grassTuft:getWidth(), grassTuft:getHeight(), 0, 0, 0)

  player.load()
  giraffe.load()

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

  -- Camera stuff
  -- camera:newLayer(-5, function()
  --             love.graphics.setColor(255, 255, 255)
  --             love.graphics.draw(BackgroundTiles[1], 0, 0)
  --           end)
  -- camera:newLayer(-2, function()
  --             love.graphics.setColor(255, 255, 255)
  --             love.graphics.draw(backGrass, 0, 200)
  --           end)
  -- camera:newLayer(0, function()
  --             love.graphics.setColor(255, 255, 255)
  --             player.animation:draw(player.spritesheet, player.x, player.y)
  --           end)
  -- camera:newLayer(1, function()
  --             love.graphics.setColor(255, 255, 255)
  --             giraffe.animation:draw(giraffe.spritesheet, giraffe.x, giraffe.y)
  --             tuft.animation:draw(tuft.spritesheet, tuft.x, tuft.y)
  --             text.animation:draw(text.spritesheet, text.x, text.y)
  --             heart.animation:draw(heart.spritesheet, heart.x, heart.y)
  --           end)
  -- camera:newLayer(1, function()
  --             love.graphics.setColor(255, 255, 255)
  --             love.graphics.draw(GroundTiles[1], 0, 340)
  --           end)

  -- Water spraying data
  waterMeter = 0

end

function love.update(dt)
  player.update(dt)
  giraffe.animation:update(dt)
  heart.animation:update(dt)
  if player.x < 0 then
    camera.x = -200
  elseif player.x > GroundTiles[3]:getWidth() - 800 then
    camera.x = GroundTiles[3]:getWidth() - 1000
  else
    camera.x = player.x-200
  end

--  myCamera1:update(dt, player.x)
end

function love.draw(dt)
  camera:set()
  -- start painting the background
--  if player.x < GroundTiles[3]:getWidth() - 800 and player.x > 0 then
    love.graphics.draw(BackgroundTiles[2], -200, 0)
    love.graphics.print({{0, 0, 0, 255}, "A and D to move, RMB to sprint, LMB to interact"}, 80, 450, 0, 2, 2)
    love.graphics.draw(backGrassRepeat, -200, 200)
--    love.graphics.draw(backGrass, backGrass:getWidth(), 200)
--  end

  -- paint players and npcs
  player.animation:draw(player.spritesheet, player.x, player.y)
  if player.carrying == 'nothing' then else
    love.graphics.draw(grass, player.x, player.y)
  end
  giraffe.animation:draw(giraffe.spritesheet, giraffe.x, giraffe.y)

--  if player.x < GroundTiles[3]:getWidth() - 800 and player.x > 99 then
  -- paint foreground
  -- love.graphics.draw(GroundTiles[1], 0, 340)
  -- love.graphics.draw(GroundTiles[2], GroundTiles[1]:getWidth(), 340)
  -- love.graphics.draw(GroundTiles[1], GroundTiles[1]:getWidth() + GroundTiles[2]:getWidth(), 340)
    love.graphics.draw(GroundTiles[3], -200, 340)

    -- paint random interactables
    tuft.animation:draw(tuft.spritesheet, tuft.x, tuft.y)
    text.animation:draw(text.spritesheet, text.x, text.y)
    heart.animation:draw(heart.spritesheet, heart.x, heart.y)

    --love.graphics.push()
    love.graphics.translate(-player.x, 0)
    --love.graphics.pop()
--  end

  camera:unset()

  --camera:draw()

end
