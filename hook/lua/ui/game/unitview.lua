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
   local MyIconPath = "/Mods/AutoReclaim-splitice/textures/ui/common" 
   
   local function IsMyUnit(bpid)
      for i, v in MyUnitIdTable do
         if v == bpid then
            return true
         end
      end
      return false
   end
   
   local oldUpdateWindow = UpdateWindow
   function UpdateWindow(info)
      oldUpdateWindow(info)
      if IsMyUnit(info.blueprintId) and DiskGetFileInfo(MyIconPath .. '/icons/units/' .. info.blueprintId.. '_icon.dds') then
         controls.icon:SetTexture(MyIconPath .. '/icons/units/' .. info.blueprintId .. '_icon.dds')
      end
   end
end