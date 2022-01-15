#****************************************************************************
#**
#**  File     :  /cdimage/units/XRB0204/XRB0204_script.lua
#**  Author(s):  Dru Staltman, Gordon Duclos
#**
#**  Summary  :  Cybran Engineering tower
#**
#**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CConstructionStructureUnit = import('/lua/cybranunits.lua').CConstructionStructureUnit
local ReclaimCheckThread = import('/mods/AutoReclaim-splitice/common/ReclaimCheckThread.lua').ReclaimCheckThread

XRB0204 = Class(CConstructionStructureUnit) 
{
    OnCreate = function(self)
        local reclaimthread = ForkThread(ReclaimCheckThread, self)
        self.Trash:Add(reclaimthread)
        CConstructionStructureUnit.OnCreate(self)
    end,

    
     
    OnStartBuild = function(self, unitBeingBuilt, order)
        CConstructionStructureUnit.OnStartBuild(self, unitBeingBuilt, order)
        
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(1)
    end,
    
    OnStopBuild = function(self, unitBeingBuilt)
        CConstructionStructureUnit.OnStopBuild(self, unitBeingBuilt)
        
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:SetRate(-1)
    end,
}
TypeClass = XRB0204