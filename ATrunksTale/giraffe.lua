-- GIRAFFE CLASS
-- All the implementation for the Giraffe NPC

giraffe = {}
text = {}
heart = {}

function giraffe.load()
    -- load giraffe sprite images
    giraffeSprites = love.graphics.newImage('images/characters/GiraffeSprite.png')
    giraffeText = love.graphics.newImage('images/misc/GiraffeText.png')
    giraffeHeart = love.graphics.newImage('images/misc/Heart.png')

    -- create animation grids for giraffe, text, and heart
    local g = anim8.newGrid(170, 220, giraffeSprites:getWidth(), giraffeSprites:getHeight(), 0, 0, 0)
    local r = anim8.newGrid(70, 70, giraffeText:getWidth(), giraffeText:getHeight(), 0, 0, 0)
    local h = anim8.newGrid(65, 70, giraffeHeart:getWidth(), giraffeHeart:getHeight(), 0, 0, 0)

    -- create giraffe data model
    giraffe.spritesheet = giraffeSprites
    giraffe.x = 600
    giraffe.y = 135
    giraffe.width = 170
    giraffe.height = 220
    giraffe.animations = {
      idle = anim8.newAnimation(g(1,1, 2,1, 1,1, 3,1), .25),
      random = anim8.newAnimation(g(4,1, 1,1), 1)
    }
    giraffe.love = 0
    giraffe.animation = giraffe.animations.idle

    -- create text data model
    text.spritesheet = giraffeText
    text.animations = {
      visible = anim8.newAnimation(r(1,1), 1),
      invisible = anim8.newAnimation(r(2,1), 1)
    }
    text.x = 500
    text.y = 50
    text.animation = text.animations.invisible

    -- create heart data model
    heart.spritesheet = giraffeHeart
    heart.animations = {
      visible = anim8.newAnimation(h(2,1, 1,1), .5),
      invisible = anim8.newAnimation(h(3,1), 1)
    }
    heart.x = 575
    heart.y = 50
    heart.animation = heart.animations.invisible

end
