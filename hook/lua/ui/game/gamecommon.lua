do 
   local MyUnitIdTable = { 
      'xab0104',
      'xab0204',
      'xab0304',
      'xab0404',
      'xeb0104',
      'xeb0204',
      'xeb0304',
      'xeb0404',
      'xrb0104',
      'xrb0204',
      'xrb0304',
      'xrb0404',
      'xsbx104',
      'xsbx204',
      'xsbx304',
      'xsbx404'
   } 
   --unit icon must be in /icons/units/. Put the full path to the /icons/ folder in here - note no / on the end! 
   local MyIconPath = "/mods/AutoReclaim-splitice/textures/ui/common" 

   local oldFileNameFn = GetUnitIconFileNames
   
   local function IsMyUnit(bpid)
      for i, v in MyUnitIdTable do
         if v == bpid then
            return true
         end
      end
      return false
   end
   
   function GetUnitIconFileNames(blueprint)
      if IsMyUnit(blueprint.Display.IconName) then
         local iconName = MyIconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
         local upIconName = MyIconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
         local downIconName = MyIconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
         local overIconName = MyIconPath .. "/icons/units/" .. blueprint.Display.IconName .. "_icon.dds"
         
         if DiskGetFileInfo(iconName) == false then
            WARN('Blueprint icon for unit '.. blueprint.Display.IconName ..' could not be found, check your file path and icon names!')
            iconName = '/textures/ui/common/icons/units/default_icon.dds'
            upIconName = '/textures/ui/common/icons/units/default_icon.dds'
            downIconName = '/textures/ui/common/icons/units/default_icon.dds'
            overIconName = '/textures/ui/common/icons/units/default_icon.dds'
         end
         return iconName, upIconName, downIconName, overIconName
      else
         return oldFileNameFn(blueprint)
      end
   end
end