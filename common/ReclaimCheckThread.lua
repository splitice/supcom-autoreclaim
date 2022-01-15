ReclaimCheckThread = function(self)
    local ourArmy = self:GetArmy()
    local aiBrain = GetArmyBrain(ourArmy)
    local bp = self:GetBlueprint().Economy.MaxBuildDistance
    local reclaimMass = false
    local reclaimEng = false
    local actioned = 0

    local EndOfLoop = function()
        if actioned == 0 then
            WaitSeconds(30)
        else
            WaitSeconds(3)
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

    while not self.Dead do
        -- Find all targets in range
        local pos = self:GetPosition()
        local reclaimTargets = GetReclaimablesInRect(pos[1] - bp, pos[3] - bp, pos[1] + bp, pos[3] + bp)
        local reclaimQueue = {}
        local ourUnitArray = {self}
        for k,v in reclaimTargets do
            -- Check v is properly defined
            if v then
                -- Check range to target
                targetpos = v:GetPosition()
                if VDist2(pos[1], pos[3], targetpos[1], targetpos[3]) <= bp then
                    if IsUnit(v) then
                        if IsEnemy(ourArmy, v:GetArmy()) then
                            if v:IsCapturable() then
                                --LOG('AutoReclaim: Capturing enemy '.. tostring(maxQueue))
                                IssueCapture(ourUnitArray, v)
                                actioned = actioned + 1
                                if actioned == 10 then
                                    EndOfLoop()
                                end
                            else
                                --LOG('AutoReclaim: Reclaiming uncapturable enemy '.. tostring(maxQueue))
                                IssueReclaim(ourUnitArray, v)
                                actioned = actioned + 1
                                if actioned == 10 then
                                    EndOfLoop()
                                end
                            end
                        end
                    elseif (reclaimMass and v.MaxMassReclaim > 0) or (reclaimEng and v.MaxEnergyReclaim > 0) then
                        --LOG('AutoReclaim: Reclaiming '.. tostring(maxQueue))
                        IssueReclaim(ourUnitArray, v)
                        actioned = actioned + 1
                        if actioned == 10 then
                            EndOfLoop()
                        end
                    end
                end
            end
        end

        EndOfLoop()
    end
end