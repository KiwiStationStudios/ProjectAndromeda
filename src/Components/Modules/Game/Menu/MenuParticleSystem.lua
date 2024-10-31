return function()
    local pimage = love.graphics.newImage("assets/images/menus/lightDot.png")
    pimage:setFilter("linear", "linear")

    local ps = love.graphics.newParticleSystem(pimage, 968)
    ps:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
    ps:setDirection(0)
    ps:setEmissionArea("none", 0, 0, 0, false)
    ps:setEmissionRate(130.46543884277)
    ps:setEmitterLifetime(-1)
    ps:setInsertMode("top")
    ps:setLinearAcceleration(0, 0, 0, 0)
    ps:setLinearDamping(0, 0)
    ps:setOffset(90, 90)
    ps:setParticleLifetime(4.8879137039185, 7.0657453536987)
    ps:setRadialAcceleration(0, 0)
    ps:setRelativeRotation(true)
    ps:setRotation(0, 0)
    ps:setSizes(0, 0.10911609232426, 0.59939259290695)
    ps:setSizeVariation(1)
    ps:setSpeed(-14.882258415222, -441.13955688477)
    ps:setSpin(0, 0)
    ps:setSpinVariation(0)
    ps:setSpread(6.2831854820251)
    ps:setTangentialAcceleration(0, 0)

    return ps
end