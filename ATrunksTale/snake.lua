-- BIRD CLASS
-- All the implementation for the Bird NPC

snake = {}
sheart = {}
bashable = {}

function snake.load()
    -- load giraffe sprite images
    snakeSprites = love.graphics.newImage('images/characters/SnakeSitTransparent.png')
  --  birdText = love.graphics.newImage('images/misc/BirdText.png')
    snakeHeart = love.graphics.newImage('images/misc/Heart.png')
    bashSprite = love.graphics.newImage('images/misc/Heart.png')

    -- create animation grids for giraffe, text, and heart
    local bs = anim8.newGrid(100, 90, snakeSprites:getWidth(), snakeSprites:getHeight(), 0, 0, 0)
--    local bps = anim8.newGrid(55, 55, snakeSprites:getWidth(), snakeSprites:getHeight(), 0, 0, 0)
  --  local r = anim8.newGrid(70, 70, birdText:getWidth(), birdText:getHeight(), 0, 0, 0)
    local h = anim8.newGrid(65, 70, snakeHeart:getWidth(), snakeHeart:getHeight(), 0, 0, 0)
    local t = anim8.newGrid(65, 70, bashSprite:getWidth(), bashSprite:getHeight(), 0, 0, 0)

    -- create giraffe data model
    snake.spritesheet = snakeSprites
    snake.x = 2000
    snake.y = 125
    snake.width = 100
    snake.height = 90
    snake.animations = {
      idleRight = anim8.newAnimation(bs(1,1, 2,1, 3,1, 2,1, 1,1, 2,1, 1,1, 2,1), {1, .5, .1, .5, .5, .5, 1, .5})
    }
    snake.animation = snake.animations.idleRight

    -- create text data model
    -- btext.spritesheet = birdText
    -- btext.animations = {
    --   visible = anim8.newAnimation(r(1,1), 1),
    --   invisible = anim8.newAnimation(r(2,1), 1)
    -- }
    -- btext.x = 1100
    -- btext.y = 50
    -- btext.animation = btext.animations.invisible

    -- create heart data model
    sheart.spritesheet = snakeHeart
    sheart.animations = {
      visible = anim8.newAnimation(h(2,1, 1,1), .5),
      invisible = anim8.newAnimation(h(3,1), 1)
    }
    sheart.x = 2000
    sheart.y = 50
    sheart.animation = sheart.animations.invisible

    -- create bashable data model
    bashable.spritesheet = bashSprite
    bashable.animations = {
      visible = anim8.newAnimation(t(2,1), 1),
      invisible = anim8.newAnimation(t(3,1), 1)
    }
    bashable.x = 1800
    bashable.y = 300
    bashable.width = 65
    bashable.height = 70
    bashable.animation = bashable.animations.visible

end