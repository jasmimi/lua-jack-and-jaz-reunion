function love.load()
  love.window.setMode(800, 600)
  love.window.setTitle("Jack and Jaz Reunion")

  love.graphics.setNewFont(48)
  love.graphics.setBackgroundColor(0, 0, 0)

  backgroundImage = love.graphics.newImage("gfx/background.png")
  bgScaleX = 800 / backgroundImage:getWidth()
  bgScaleY = 600 / backgroundImage:getHeight()

  -- sound = love.audio.newSource("music.ogg", "stream")
  -- love.audio.play(sound)

  jack = love.graphics.newImage("gfx/jack.png")
  jaz = love.graphics.newImage("gfx/jaz.png")

  local windowWidth, windowHeight = love.graphics.getWidth(), love.graphics.getHeight()
  local margin = 16
  local floorY = math.floor(windowHeight * 0.88)

  -- Start low on the floor area: Jasmine bottom-left, Jack bottom-right.
  jazX = margin
  jazY = floorY - jaz:getHeight()
  jackX = windowWidth - jack:getWidth() - margin
  jackY = floorY - jack:getHeight()
  moveSpeed = 220
end

function love.update(dt)
  -- Jack: WASD
  if love.keyboard.isDown("w") then jackY = jackY - moveSpeed * dt end
  if love.keyboard.isDown("s") then jackY = jackY + moveSpeed * dt end
  if love.keyboard.isDown("a") then jackX = jackX - moveSpeed * dt end
  if love.keyboard.isDown("d") then jackX = jackX + moveSpeed * dt end

  -- Jaz: Arrow keys
  if love.keyboard.isDown("up") then jazY = jazY - moveSpeed * dt end
  if love.keyboard.isDown("down") then jazY = jazY + moveSpeed * dt end
  if love.keyboard.isDown("left") then jazX = jazX - moveSpeed * dt end
  if love.keyboard.isDown("right") then jazX = jazX + moveSpeed * dt end

  local windowWidth, windowHeight = love.graphics.getWidth(), love.graphics.getHeight()
  local minY = windowHeight * 0.5

  jackX = math.max(0, math.min(jackX, windowWidth - jack:getWidth()))
  jackY = math.max(minY, math.min(jackY, windowHeight - jack:getHeight()))

  jazX = math.max(0, math.min(jazX, windowWidth - jaz:getWidth()))
  jazY = math.max(minY, math.min(jazY, windowHeight - jaz:getHeight()))
end

local function drawOutlinedText(text, x, y, outlineColor, textColor, thickness)
  thickness = thickness or 2
  outlineColor = outlineColor or { 0, 0, 0, 1 }
  textColor = textColor or { 1, 1, 1, 1 }

  love.graphics.setColor(outlineColor)
  for ox = -thickness, thickness do
    for oy = -thickness, thickness do
      if not (ox == 0 and oy == 0) then
        love.graphics.print(text, x + ox, y + oy)
      end
    end
  end

  love.graphics.setColor(textColor)
  love.graphics.print(text, x, y)
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1) -- Set color to white (full opacity)
  love.graphics.draw(backgroundImage, 0, 0)

  drawOutlinedText("Make Jack and Jaz meet again", 40, 40, { 0, 0, 0, 1 }, { 1, 1, 1, 1 }, 3)
  love.graphics.draw(jack, jackX, jackY)
  love.graphics.draw(jaz, jazX, jazY)
end
