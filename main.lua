-- Galaxy Ellipse Tool. A tool for exploring the density wave theory for distribution of stars in a galaxy.

settings = {
	innerRadius = 10,    --major radius of the innermost ellipse
	count      = 72,     --number of ellipses
	spacing     = 3.4,   --spacing between each successive major axis in pixels
	rotation    = 0.048, --rotational offset of each successive ellipse in radians
	squash      = 0.72,  --size of minor axis relative to major
}

scales = { --adjust how much x-dragging affects each setting
	count   = 0.1,
	spacing  = 0.1,
	rotation = 0.0005,
	squash   = 0.01,
}

modes = {"count", "spacing", "rotation", "squash"}
modeIndex = 1
mousePressed = nil

function love.load()
	love.window.setTitle("Galaxy Ellipse Tool")
	love.graphics.setBackgroundColor(0, 0, 0, 1)
	love.window.setMode(800, 600, {resizable = true})
end

function getCurrent(setting)
	if mousePressed and modes[modeIndex] == setting then
		local x, y = love.mouse.getPosition()
		return settings[setting] + (x - mousePressed.x) * scales[setting]
	else
		return settings[setting]
	end
end

function love.mousepressed(x, y, button)
	if button == 1 then
		mousePressed = {x = x, y = y}
	end
end

function love.mousereleased(x, y, button)
	if button == 1 then
		settings[modes[modeIndex]] = getCurrent(modes[modeIndex])
		mousePressed = nil
	end
end

function love.keyreleased(key, scancode)
	if scancode == "m" then
		modeIndex = (modeIndex % #modes) + 1 --would be easier with 0-based indexing...
		print("Mode index changed to " .. modeIndex .. " (" .. modes[modeIndex] .. ")")
	elseif scancode == "p" then
		for k, v in pairs(settings) do
			print(k .. " = " .. v)
		end
	end
end

function love.draw()
	local w, h = love.graphics.getDimensions()
	local x, y = w/2, h/2
	local radius   = settings.innerRadius
	local spacing  = getCurrent("spacing")
	local rotation = getCurrent("rotation")
	local squash   = getCurrent("squash")

	love.graphics.setColor(100, 150, 200)
	love.graphics.setBlendMode("add")

	for i = 1, getCurrent("count") do
		love.graphics.translate(w/2, h/2)
		love.graphics.rotate(i * rotation)
		love.graphics.translate(-w/2, -h/2)
		love.graphics.ellipse("line", x, y, radius, radius * squash)
		love.graphics.origin()
		radius = radius + spacing
	end

	love.graphics.setBlendMode("alpha")

	drawUI()
end

function drawUI()
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 16)
	love.graphics.setColor(200, 250, 200)
	local mode = modes[modeIndex]
	love.graphics.print("Drag left and right to change ellipse " .. mode .. ". Press 'm' to change mode and 'p' to print values to terminal.")
end
