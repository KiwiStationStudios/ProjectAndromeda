local particles = {x=-195, y=-79}
local image1 = love.graphics.newImage("assets/images/menus/starBG.png")
image1:setFilter("linear", "linear")

local ps = love.graphics.newParticleSystem(image1, 443)
ps:setColors(1, 1, 1, 0, 1, 1, 1, 0.5, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
ps:setDirection(2.3996453285217)
ps:setEmissionArea("uniform", 36.597354888916, 857.63702392578, 2.4106860160828, false)
ps:setEmissionRate(26.344985961914)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(50, 50)
ps:setParticleLifetime(0, 16)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(2.5535900592804, -0.5404195189476)
ps:setSizes(0.0068197557702661, 0.083542011678219, 0.34620916843414, 0.82519048452377)
ps:setSizeVariation(1)
ps:setSpeed(17.168695449829, 361.11422729492)
ps:setSpin(2.7341787815094, -1.2318940162659)
ps:setSpinVariation(1)
ps:setSpread(0)
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=241, blendMode="add", shader=nil, texturePath="glowStar.png", texturePreset="", shaderPath="", shaderFilename="", x=0, y=0})
return particles