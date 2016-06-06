-- BIRD CLASS
-- All the implementation for the Bird NPC

snake = {}
sheart = {}
stext = {}
bashable = {}

function snake.load()
    -- load giraffe sprite images
    snakeSprites = love.graphics.newImage('images/characters/SnakeSitTransparent.png')
    snakeText = love.graphics.newImage('images/misc/SnakeText.png')
    snakeHeart = love.graphics.newImage('images/misc/Heart.png')
    bashSprite = love.graphics.newImage('images/misc/TermiteTransparent.png')

    -- create animation grids for giraffe, text, and heart
    local bs = anim8.newGrid(100, 90, snakeSprites:getWidth(), snakeSprites:getHeight(), 0, 0, 0)
--    local bps = anim8.newGrid(55, 55, snakeSprites:getWidth(), snakeSprites:getHeight(), 0, 0, 0)
    local r = anim8.newGrid(70, 70, snakeText:getWidth(), snakeText:getHeight(), 0, 0, 0)
    local h = anim8.newGrid(65, 70, snakeHeart:getWidth(), snakeHeart:getHeight(), 0, 0, 0)
    local t = anim8.newGrid(190, 175, bashSprite:getWidth(), bashSprite:getHeight(), 0, 0, 0)

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
    stext.spritesheet = snakeText
    stext.animations = {
      visible = anim8.newAnimation(r(1,1), 1),
      invisible = anim8.newAnimation(r(2,1), 1)
    }
    stext.x = 1900
    stext.y = 50
    stext.animation = stext.animations.invisible

    -- create heart data model
    sheart.spritesheet = snakeHeart
    sheart.animations = {
      visible = anim8.newAnimation(h(2,1, 1,1), .5),
      invisible = anim8.newAnimation(h(3,1), 1)
    }
    sheart.x = 2025
    sheart.y = 50
    sheart.animation = sheart.animations.invisible

    -- create bashable data model
    bashable.spritesheet = bashSprite
    bashable.animations = {
      standing = anim8.newAnimation(t(1,1), 1),
      breaking = anim8.newAnimation(t(2,1, 3,1, 4,1, 5,1, 6,1), {.1, .2, .2, .2, .2}, 'pauseAtEnd')
    }
    bashable.x = 2300
    bashable.y = 200
    bashable.width = 190
    bashable.height = 175
    bashable.animation = bashable.animations.standing

end
