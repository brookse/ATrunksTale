-- BIRD CLASS
-- All the implementation for the Bird NPC

bird = {}
btext = {}
bheart = {}
birds = {}

function bird.load()
    -- load giraffe sprite images
    birdSprites = love.graphics.newImage('images/characters/BirdSpriteTransparent.png')
    birdText = love.graphics.newImage('images/misc/BirdText.png')
    birdHeart = love.graphics.newImage('images/misc/Heart.png')
    birdsFlight = love.graphics.newImage('images/misc/BirdFlight.png')

    -- create animation grids for giraffe, text, and heart
    local bs = anim8.newGrid(55, 55, birdSprites:getWidth(), birdSprites:getHeight(), 0, 55, 0)
    local bps = anim8.newGrid(55, 55, birdSprites:getWidth(), birdSprites:getHeight(), 0, 0, 0)
    local r = anim8.newGrid(70, 70, birdText:getWidth(), birdText:getHeight(), 0, 0, 0)
    local h = anim8.newGrid(65, 70, birdHeart:getWidth(), birdHeart:getHeight(), 0, 0, 0)
    local bf = anim8.newGrid(115, 70, birdsFlight:getWidth(), birdsFlight:getHeight(), 0, 0, 0)

    -- create giraffe data model
    bird.spritesheet = birdSprites
    bird.x = 1200
    bird.y = 180
    bird.width = 55
    bird.height = 55
    bird.animations = {
      idleLeft = anim8.newAnimation(bs(1,1, 2,1), .5),
      idleRight = anim8.newAnimation(bs(7,1, 8,1), .5),
      pointLeft = anim8.newAnimation(bps(4,1, 3,1, 2,1, 1,1), .25, 'pauseAtEnd'),
      pointRight = anim8.newAnimation(bps(5,1, 6,1, 7,1, 8,1), .25, 'pauseAtEnd'),
    }
    bird.animation = bird.animations.idleLeft

    -- create text data model
    btext.spritesheet = birdText
    btext.animations = {
      visible = anim8.newAnimation(r(1,1), 1),
      invisible = anim8.newAnimation(r(2,1), 1)
    }
    btext.x = 1100
    btext.y = 50
    btext.animation = btext.animations.invisible

    -- create heart data model
    bheart.spritesheet = birdHeart
    bheart.animations = {
      visible = anim8.newAnimation(h(2,1, 1,1), .5),
      invisible = anim8.newAnimation(h(3,1), 1)
    }
    bheart.x = 1200
    bheart.y = 50
    bheart.animation = bheart.animations.invisible

    -- create text data model
    birds.spritesheet = birdsFlight
    birds.animations = {
      sitting = anim8.newAnimation(bf(1,1), 1),
      flying = anim8.newAnimation(bf(1,1, 2,1, 3,1, 4,1, 5,1, 6,1, 7,1, 8,1, 9,1, 10,1), .15, 'pauseAtEnd')
    }
    birds.x = 1000
    birds.y = 285
    birds.width = 115
    birds.height = 70
    birds.animation = birds.animations.sitting

end

function bird.update(dt)
  bird.animation:update(dt)
  birds.animation:update(dt)
  bheart.animation:update(dt)
  btext.animation:update(dt)
end
