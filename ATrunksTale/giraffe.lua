-- GIRAFFE CLASS
-- All the implementation for the Giraffe NPC

giraffe = {}
text = {}
heart = {}
tuft = {}

function giraffe.load()
    -- load giraffe sprite images
    giraffeSprites = love.graphics.newImage('images/characters/GiraffeSprite.png')
    giraffeText = love.graphics.newImage('images/misc/GiraffeText.png')
    giraffeHeart = love.graphics.newImage('images/misc/Heart.png')
    grassTuft = love.graphics.newImage('images/misc/GrassTuft.png')

    -- create animation grids for giraffe, text, heart, and tuft
    local g = anim8.newGrid(170, 220, giraffeSprites:getWidth(), giraffeSprites:getHeight(), 0, 0, 0)
    local r = anim8.newGrid(70, 70, giraffeText:getWidth(), giraffeText:getHeight(), 0, 0, 0)
    local h = anim8.newGrid(65, 70, giraffeHeart:getWidth(), giraffeHeart:getHeight(), 0, 0, 0)
    local t = anim8.newGrid(30, 40, grassTuft:getWidth(), grassTuft:getHeight(), 0, 0, 0)

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
    heart.x = 600
    heart.y = 50
    heart.animation = heart.animations.invisible

    tuft.spritesheet = grassTuft
    tuft.animations = {
      visible = anim8.newAnimation(t(1,1), 1),
      invisible = anim8.newAnimation(t(2,1), 1)
    }
    tuft.x = 375
    tuft.y = 315
    tuft.width = 30
    tuft.height = 40
    tuft.animation = tuft.animations.visible

end

function giraffe.update(dt)
  giraffe.animation:update(dt)
  heart.animation:update(dt)
  text.animation:update(dt)
  tuft.animation:update(dt)
end
