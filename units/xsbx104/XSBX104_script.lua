local SConstructionUnit = import('/lua/seraphimunits.lua').SConstructionUnit
local EffectUtil = import('/lua/EffectUtilities.lua')
local ReclaimCheckThread = import('/mods/AutoReclaim-splitice/common/ReclaimCheckThread.lua').ReclaimCheckThread

XSBX104 = Class(SConstructionUnit) {

    OnCreate = function(self)
        local reclaimthread = ForkThread(ReclaimCheckThread, self)
        self.Trash:Add(reclaimthread)
        SConstructionUnit.OnCreate(self)
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,

}

TypeClass = XSBX104

