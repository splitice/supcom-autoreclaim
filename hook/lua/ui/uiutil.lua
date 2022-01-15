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
   local oldUIFile = UIFile
   function UIFile(filespec)
      for i, v in MyUnitIdTable do
         if string.find(filespec, v .. '_icon') then
            local curfile =  MyIconPath .. filespec
            if DiskGetFileInfo(curfile) then
               return curfile
            else
               WARN('Blueprint icon for unit '.. control.Data.id ..' could not be found, check your file path and icon names!')
            end
         end
      end
      return oldUIFile(filespec)
   end
end 