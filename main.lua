function love.load()
  love.window.setMode(800, 600)
  love.window.setTitle("Jack and Jaz Reunion")

  love.graphics.setNewFont(48)
  love.graphics.setBackgroundColor(0, 0, 0)

  -- backgroundImage = love.graphics.newImage("background.png")

  -- sound = love.audio.newSource("music.ogg", "stream")
  -- love.audio.play(sound)

  -- image = love.graphics.newImage("gfx/jack.png")
  -- imgx = 100
  -- imgy = 100
  -- isDragging = false
  -- offsetX = 0
  -- offsetY = 0
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 then
    -- Check if click is on the image
    if x >= imgx and x <= imgx + image:getWidth() and
        y >= imgy and y <= imgy + image:getHeight() then
      isDragging = true
      offsetX = x - imgx
      offsetY = y - imgy
    end
  end
end

function love.mousereleased(x, y, button, istouch)
  if button == 1 then
    isDragging = false
  end
end

function love.mousemoved(x, y, dx, dy)
  if isDragging then
    imgx = x - offsetX
    imgy = y - offsetY
  end
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1) -- Set color to white (full opacity)
  -- love.graphics.draw(backgroundImage, 0, 0)

  love.graphics.print("Make Jack and Jaz meet again", 40, 40)
  -- love.graphics.draw(image, imgx, imgy)
end
