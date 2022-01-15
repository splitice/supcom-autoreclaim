local AConstructionUnit = import('/lua/aeonunits.lua').AConstructionUnit
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local ReclaimCheckThread = import('/mods/AutoReclaim-splitice/common/ReclaimCheckThread.lua').ReclaimCheckThread

XAB0104 = Class(AConstructionUnit)  {

    OnCreate = function(self)
        local reclaimthread = ForkThread(ReclaimCheckThread, self)
        self.Trash:Add(reclaimthread)
        AConstructionUnit.OnCreate(self)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        AConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        self.Trash:Add(CreateRotator(self, 'Sphere', 'x', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere', 'y', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere', 'z', nil, 0, 15, 80 + Random(0, 20)))
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateAeonCommanderBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,
}

TypeClass = XAB0104