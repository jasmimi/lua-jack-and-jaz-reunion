function love.load()
  love.window.setMode(800, 600)
  love.window.setTitle("Jack and Jaz Reunion")

  love.graphics.setNewFont(48)
  love.graphics.setBackgroundColor(0, 0, 0)
  love.graphics.setDefaultFilter("nearest", "nearest")

  backgroundImage = love.graphics.newImage("gfx/background.png")
  bgScaleX = 800 / backgroundImage:getWidth()
  bgScaleY = 600 / backgroundImage:getHeight()

  sound = love.audio.newSource("sfx/music.mp3", "stream")
  love.audio.play(sound)

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

  transitionState = "play"
  transitionTimer = 0
  transitionDuration = 2.4
  messageFade = 0
  messageFadeDuration = 2.2

  finalBg = { 1, 0.58, 0.74, 1 }

  titleFont = love.graphics.getFont()
  messageFont = love.graphics.newFont(60)
  moveSpeed = 220
end

local function getCharacterIndex(x, y, sprite)
  local cellSize = 32
  local centerX = x + (sprite:getWidth() * 0.5)
  local centerY = y + (sprite:getHeight() * 0.5)
  local ix = math.floor(centerX / cellSize)
  local iy = math.floor(centerY / cellSize)
  return ix, iy
end

local function didCharactersMeetByIndex()
  local jackIX, jackIY = getCharacterIndex(jackX, jackY, jack)
  local jazIX, jazIY = getCharacterIndex(jazX, jazY, jaz)
  return jackIX == jazIX and jackIY == jazIY
end

function love.update(dt)
  if transitionState == "transition" then
    transitionTimer = math.min(transitionDuration, transitionTimer + dt)
    if transitionTimer >= transitionDuration then
      transitionState = "message"
    end
    return
  end

  if transitionState == "message" then
    messageFade = math.min(1, messageFade + (dt / messageFadeDuration))
    return
  end

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

  if didCharactersMeetByIndex() then
    transitionState = "transition"
    transitionTimer = 0
  end
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

local function drawHeart(cx, cy, size, r, g, b, a, pixelStep)
  local points = {}
  local samples = 34
  pixelStep = pixelStep or 1

  for i = 0, samples do
    local t = (i / samples) * (math.pi * 2)
    local x = 16 * math.sin(t) ^ 3
    local y = 13 * math.cos(t) - 5 * math.cos(2 * t) - 2 * math.cos(3 * t) - math.cos(4 * t)
    local px = cx + x * size
    local py = cy - y * size
    points[#points + 1] = math.floor((px / pixelStep) + 0.5) * pixelStep
    points[#points + 1] = math.floor((py / pixelStep) + 0.5) * pixelStep
  end

  love.graphics.setColor(r, g, b, a)
  love.graphics.polygon("fill", points)
end

local function drawGameScene()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(backgroundImage, 0, 0)
  love.graphics.setFont(titleFont)
  drawOutlinedText("Make Jack and Jaz meet again", 40, 40, { 0, 0, 0, 1 }, { 1, 1, 1, 1 }, 3)
  love.graphics.draw(jack, jackX, jackY)
  love.graphics.draw(jaz, jazX, jazY)
end

local function drawHeartTransition()
  local width, height = love.graphics.getWidth(), love.graphics.getHeight()
  local t = transitionTimer / transitionDuration
  local eased = 1 - (1 - t) ^ 3

  drawGameScene()

  love.graphics.setColor(finalBg[1], finalBg[2], finalBg[3], 0.25 + (0.75 * eased))
  love.graphics.rectangle("fill", 0, 0, width, height)

  local maxSize = math.max(width, height) * 0.08
  local steppedEased = math.floor(eased * 12) / 12
  local heartSize = 0.01 + (maxSize * steppedEased)
  local cx, cy = width * 0.5, height * 0.5

  drawHeart(cx, cy, heartSize, 0.94, 0.08, 0.34, 1, 6)
  drawHeart(cx, cy, heartSize * 0.72, 1, 0.66, 0.77, 0.92, 6)
end

local function drawMessageScreen()
  local width, height = love.graphics.getWidth(), love.graphics.getHeight()

  love.graphics.setColor(finalBg)
  love.graphics.rectangle("fill", 0, 0, width, height)

  drawHeart(width * 0.5, height * 0.38, 7.8, 0.94, 0.08, 0.34, 0.95, 4)
  drawHeart(width * 0.5, height * 0.38, 5.9, 1, 0.58, 0.74, 0.86, 4)

  love.graphics.setFont(messageFont)
  local text = "I've missed you too!"
  local textWidth = messageFont:getWidth(text)
  local x = (width - textWidth) * 0.5
  local y = height * 0.72

  drawOutlinedText(text, x, y, { 0, 0, 0, messageFade }, { 1, 0.94, 0.97, messageFade }, 3)
end

function love.draw()
  if transitionState == "transition" then
    drawHeartTransition()
    return
  end

  if transitionState == "message" then
    drawMessageScreen()
    return
  end

  drawGameScene()
end
