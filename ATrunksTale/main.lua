debug = true
anim8 = require('anim8')
--require 'ui'
require 'player'
require 'giraffe'
require 'bird'
require 'snake'
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
  tree = love.graphics.newImage('images/misc/TreeTransparent.png')
  boulder = love.graphics.newImage('images/misc/BoulderTransboulder.png')

  grass = love.graphics.newImage('images/misc/Grass.png')
  grassTuft = love.graphics.newImage('images/misc/GrassTuft.png')

  -- create ground table
  GroundMap = { 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 2 }

  -- create background table
  BackgroundMap = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }

  local t = anim8.newGrid(30, 40, grassTuft:getWidth(), grassTuft:getHeight(), 0, 0, 0)

  player.load()
  giraffe.load()
  bird.load()
  snake.load()

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

  -- UI
  backgroundGUI = love.graphics.newImage('images/ui/GUI4.png')

  waterMeterUI = {}
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

  -- quest checks
  tutorialQuests = {
    Qone = false,
    Qtwo = false,
    Qthree = false
  }
  --
  mom = {}
  mummaSprites = love.graphics.newImage('images/characters/HappymomTrans.png')
  local bs = anim8.newGrid(185, 115, mummaSprites:getWidth(), mummaSprites:getHeight(), 0, 0, 0)
  mom.spritesheet = mummaSprites
  mom.x = 2800
  mom.y = 240
  mom.animation = anim8.newAnimation(bs(1,1, 2,1, 3,1, 4,1, 5,1, 6,1, 7,1, 8,1, 9,1, 10,1, 11,1, 12,1, 13,1, 14,1), .15)

end

function love.update(dt)
  player.update(dt)

  bird.animation:update(dt)
  birds.animation:update(dt)
  giraffe.animation:update(dt)
  heart.animation:update(dt)
  bheart.animation:update(dt)
  btext.animation:update(dt)
  snake.animation:update(dt)
  sheart.animation:update(dt)
  stext.animation:update(dt)
  bashable.animation:update(dt)
  mom.animation:update(dt)

  checkCursorPosition()

  -- player completed all quests and is beyond the bashable object
  if tutorialQuests.Qone == true
  and tutorialQuests.Qtwo == true
  and tutorialQuests.Qthree == true
  and player.x > bashable.x + bashable.width/2
  then
    if player.x < 0 then
      camera.x = -200
    elseif player.x > GroundTiles[3]:getWidth() then
    --  camera.x = player.x-200
      camera.x = GroundTiles[3]:getWidth() - 200
    else
      camera.x = player.x-200
    end
  -- otherwise continue normally
  else
    if player.x < 0 then
      camera.x = -200
    elseif player.x > GroundTiles[3]:getWidth() - 800 then
      camera.x = GroundTiles[3]:getWidth() - 1000
    else
      camera.x = player.x-200
    end
  end

--  myCamera1:update(dt, player.x)
end

function love.draw(dt)
  camera:set()

  -- start painting the background
  love.graphics.draw(BackgroundTiles[2], -200, 0)
  love.graphics.draw(BackgroundTiles[2], BackgroundTiles[2]:getWidth()-200, 0)
  love.graphics.print({{0, 0, 0, 255}, "A and D to move, RMB to sprint, LMB to interact"}, 80, 450, 0, 2, 2)
  love.graphics.draw(backGrassRepeat, -200, 200)
  love.graphics.draw(backGrassRepeat, backGrassRepeat:getWidth()-200, 200)
  love.graphics.draw(tree, 1200, 100)
  love.graphics.draw(boulder, 1900, 200)

  -- paint players and npcs
  birds.animation:draw(birds.spritesheet, birds.x, birds.y)
  player.animation:draw(player.spritesheet, player.x, player.y)
  if player.carrying == 'nothing' then else
    love.graphics.draw(grass, player.x, player.y)
  end
  giraffe.animation:draw(giraffe.spritesheet, giraffe.x, giraffe.y)
  bird.animation:draw(bird.spritesheet, bird.x, bird.y)
  snake.animation:draw(snake.spritesheet, snake.x, snake.y)

  -- paint foreground
  love.graphics.draw(GroundTiles[3], -200, 340)
  love.graphics.draw(GroundTiles[3], GroundTiles[3]:getWidth()-200, 340)

  -- paint random interactables
  tuft.animation:draw(tuft.spritesheet, tuft.x, tuft.y)
  text.animation:draw(text.spritesheet, text.x, text.y)
  heart.animation:draw(heart.spritesheet, heart.x, heart.y)
  bheart.animation:draw(bheart.spritesheet, bheart.x, bheart.y)
  btext.animation:draw(btext.spritesheet, btext.x, btext.y)
  sheart.animation:draw(sheart.spritesheet, sheart.x, sheart.y)
  bashable.animation:draw(bashable.spritesheet, bashable.x, bashable.y)
  stext.animation:draw(stext.spritesheet, stext.x, stext.y)
  mom.animation:draw(mom.spritesheet, mom.x, mom.y)

  love.graphics.translate(-player.x, 0)

  camera:unset()

  love.graphics.draw(backgroundGUI, 0, 424)
  waterMeterUI.animation:draw(waterMeterUI.spritesheet, waterMeterUI.x, waterMeterUI.y)
  --camera:draw()


end

function checkCursorPosition()

  x, y = camera:mousePosition()
  -- check hover on giraffe
  if x > giraffe.x and x < giraffe.x + giraffe.width
  and y > giraffe.y and y < giraffe.y + giraffe.height
  then
    love.mouse.setCursor(hovercursor)

  -- check hover on bird
  elseif x > bird.x and x < bird.x + bird.width
  and y > bird.y and y < bird.y + bird.height
  then
    love.mouse.setCursor(hovercursor)

  -- check hover on snake
  elseif x > snake.x and x < snake.x + snake.width
  and y > snake.y and y < snake.y + snake.height
  then
    love.mouse.setCursor(hovercursor)

  -- check hover on tuft
  elseif x > tuft.x and x < tuft.x + tuft.width
  and y > tuft.y and y < tuft.y + tuft.height
  then
    love.mouse.setCursor(hovercursor)

  -- check hover on pool
  elseif x > 1050 and x < 1300
  and y > 350
  then
    love.mouse.setCursor(hovercursor)
  else
    love.mouse.setCursor(normalcursor)
  end
end
