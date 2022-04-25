ReclaimCheckThread = function(self)
    local ourArmy = self:GetArmy()
    local aiBrain = GetArmyBrain(ourArmy)
    local bp = self:GetBlueprint().Economy.MaxBuildDistance
    local reclaimMass = false
    local reclaimEng = false
    local actioned = 0

    local EndOfLoop = function(v)
        if actioned == 0 then
            WaitSeconds(15)
        else
            WaitSeconds(1)
        end

        if v then
            while not IsDestroyed(v) do
                WaitSeconds(0.1)
                if actioned <= 0 then
                    break
                end
                actioned = actioned - 1
            end
        end
        actioned = 0

        ourArmy = self:GetArmy()

        -- Decide whether to start/stop reclaiming mass.
        local cur = aiBrain:GetEconomyStoredRatio('MASS')
        if (reclaimMass and cur > 0.85) then
            -- LOG('AutoReclaim: Halting automatic mass reclaim')
            reclaimMass = false
        elseif (not reclaimMass and cur < 0.5) then
            -- LOG('AutoReclaim: Enabling automatic mass reclaim')
            reclaimMass = true
        end

        -- Decide whether to start/stop reclaiming energy.
        cur = aiBrain:GetEconomyStoredRatio('ENERGY')
        if (reclaimEng and cur > 0.85) then
            -- LOG('AutoReclaim: Halting automatic energy reclaim')
            reclaimEng = false
        elseif (not reclaimEng and cur < 0.5) then
            -- LOG('AutoReclaim: Enabling automatic energy reclaim')
            reclaimEng = true
        end
    end

    local reclaimSize = 2000
    while not self.Dead do
        -- Find all targets in range
        local pos = self:GetPosition()
        local reclaimTargets = GetReclaimablesInRect(pos[1] - bp, pos[3] - bp, pos[1] + bp, pos[3] + bp)
        local reclaimQueue = {}
        local ourUnitArray = {self}
        local cmd
        local gts = GetGameTimeSeconds()
        local threshold = gts + 60
        local numRelcaim = table.getn(reclaimTargets)
        if numRelcaim > reclaimSize then    
            LOG('AutoReclaim: Doing wreck cleanup due to '..tostring(numRelcaim)..' wrecks in range')
            local reclaimRemaining = numRelcaim
            for i=1, numRelcaim do
                local v = reclaimTargets[i]
                if v and (v.IsWreckage or v.TimeReclaim) and not v.Dead and not IsDestroyed(v) then
                    i = i + 1
                    if i <= numRelcaim then
                        local previous = v
                        local v = reclaimTargets[i]
                        if v and (v.IsWreckage or v.TimeReclaim) and not v.Dead and not IsDestroyed(v) then
                            if previous and (previous.TimeReclaim or previous.IsWreckage) then
                                previous.MaxMassReclaim = previous.MaxMassReclaim + v.MaxMassReclaim
                                previous.MaxEnergyReclaim = previous.MaxEnergyReclaim + v.MaxEnergyReclaim
                                previous.ReclaimLeft = ((previous.ReclaimLeft or 1) + (v.ReclaimLeft or 1)) / 2
                                v:Destroy()
                                reclaimTargets[i] = nil
                                reclaimRemaining = reclaimRemaining - 1
                            end
                        end
                    end
                end
            end
            if reclaimRemaining > 2000 then
                reclaimSize = reclaimRemaining
            else
                reclaimSize = 2000
            end
            LOG('AutoReclaim: Wreck compact done ('..tostring(reclaimRemaining)..' wrecks left in range)')
        end

        for _, v in reclaimTargets do
            -- Check v is properly defined
            if v and (v.IsWreckage or v.TimeReclaim)  then
                -- Check range to target
                if (not v.Dead and not IsDestroyed(v) and not IsUnit(v)) then
                    targetpos = v:GetPosition()
                    if VDist2(pos[1], pos[3], targetpos[1], targetpos[3]) <= bp then
                        if (reclaimMass and v.MaxMassReclaim > 0) or (reclaimEng and v.MaxEnergyReclaim > 0) then
                            IssueReclaim(ourUnitArray, v)
                            actioned = actioned + 1
                            if actioned == 20 then
                                EndOfLoop(v)
                            end
                        elseif not v.expirationTime or v.expirationTime > threshold then
                            v.expirationTime = threshold
                        elseif v.expirationTime < gts then
                            v:Destroy()
                        end
                    end
                end
            end
        end

        EndOfLoop()
    end
end