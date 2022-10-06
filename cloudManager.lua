local dir = toRad(math.random(360))

local CloudManager = {
    clouds = {},
    wx = lengthDirX(1, dir),
    wy = lengthDirY(1, dir),
    maxSize = 5000,

    createCloud = function(self, x, y)
        local image = CLOUD_2_IMAGE
        local angle = toRad(0)
        local alpha = 0.11
        local scale = 2.6

        if math.random() > 0.5 then
           angle = toRad(180)
        end

        local rand = math.random()

        if rand > 0.6 then
            image = CLOUD_3_IMAGE
            alpha = alpha * 0.5
            scale = scale * 1.1
--        elseif rand > 0.6 then
--            image = CLOUD_1_IMAGE
--            alpha = alpha * 1.1
--            scale = scale * 1.2
        end

        table.insert(self.clouds, {
            x = x,
            y = y,
            image = image,
            originX = image:getWidth() / 2,
            originY = image:getHeight() / 2,
            height = 14 + math.random() * 24,
            angle = angle,
            scale = scale,
            alpha = alpha,
        })
    end,

    init = function(self)
        for i = 1, 20 do
            self:createCloud(2 * self.maxSize * (math.random() - 0.5), 2 * self.maxSize * (math.random() - 0.5))
        end
    end,

    update = function(self, dt)
        local cloudSpeed = dt * 10

        if TimeManager.isTransitioning then
            cloudSpeed = cloudSpeed * 120
        end

        for i = 1, #self.clouds do
            local cloud = self.clouds[i]
            cloud.x = cloud.x + self.wx * cloudSpeed * (cloud.height - 3) / 10
            cloud.y = cloud.y + self.wy * cloudSpeed * (cloud.height - 3) / 10

            if cloud.x > self.maxSize then
                cloud.x = cloud.x - self.maxSize * 2  + math.random() * self.maxSize / 5
            end
            if cloud.y > self.maxSize then
                cloud.y = cloud.y - self.maxSize * 2  + math.random() * self.maxSize / 5
            end
            if cloud.x < -self.maxSize then
                cloud.x = cloud.x + self.maxSize * 2  - math.random() * self.maxSize / 5
            end
            if cloud.y < -self.maxSize then
                cloud.y = cloud.y + self.maxSize * 2  - math.random() * self.maxSize / 5
            end
        end
    end,

    draw = function(self, camX, camY)
        for i = 1, #self.clouds do
            local cloud = self.clouds[i]
            local camFactor = 100 / cloud.height
            local visibleX = cloud.x + (cloud.x - camX) / camFactor
            local visibleY = cloud.y + (cloud.y - camY) / camFactor
            local distToCam = dist(camX, camY, visibleX, visibleY)
            local camAlpha = math.pow(distToCam + 1100, 2) / 2000000

            love.graphics.setColor(0, 0, 0, 0.06 * camAlpha)
            love.graphics.draw(cloud.image, cloud.x - TimeManager.shadowLength * 1500, cloud.y + TimeManager.shadowLength * 1500, cloud.angle, 14 / camFactor, 14 / camFactor, cloud.originX, cloud.originY)
            love.graphics.setColor(1, 1, 1, cloud.alpha * camAlpha)
            love.graphics.draw(cloud.image, visibleX, visibleY, cloud.angle,
                cloud.scale * 10 / camFactor,
                cloud.scale * 10 / camFactor,
                cloud.originX, cloud.originY)
            love.graphics.setColor(1, 1, 1)
        end
    end
}

return CloudManager