local TConstructionUnit = import('/lua/terranunits.lua').TConstructionUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local ReclaimCheckThread = import('/mods/AutoReclaim-splitice/common/ReclaimCheckThread.lua').ReclaimCheckThread

XEB0204 = Class(TConstructionUnit) {

    OnCreate = function(self)
        local reclaimthread = ForkThread(ReclaimCheckThread, self)
        self.Trash:Add(reclaimthread)
        TConstructionUnit.OnCreate(self)
    end,
    
    OnStopBeingBuilt = function(self, builder, layer)
        TConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        self.Trash:Add(CreateRotator(self, 'Upper', 'y', nil, 35, 35, 35))
        self.Trash:Add(CreateRotator(self, 'Center', 'y', nil, -35, -35, -35))
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateUEFCommanderBuildSliceBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end, 
}

TypeClass = XEB0204