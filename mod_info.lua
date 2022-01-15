name = "AutoReclaim (splitice)"
uid = "080b115f-7682-4868-bad7-3a2273386a9f"
version = 3
copyright = "Mavr390, dwm, splitice"
description = "Adds T1-3 engineering stations to all factions that auto-reclaim, performs less reclaim than dwm's variant but with less CPU cost."
author = "Mavr390, dwm, splitice"
icon = "/mods/AutoReclaim-splitice/reclaim.png"
selectable = true
enabled = true
exclusive = false
ui_only = false
conflicts = {
    "755F8830-FD79-11E0-8691-CBAF4724019B", -- AutoReclaim by Mavr390
    "080b115f-7682-4868-bad7-2a2273386a8d" -- AutoReclaim by dwm
}

---------------------------------
-- Changelog:
---------------------------------
-- v1: 
--  - Avoid slowdown in the late game by restructuring logic to not leak threads.
--  - Attempt to automatically capture units that wander into range.
--  - Attempt to automatically eat live enemy units that aren't capturable.
--  - Fix regression where operation/upgrade of Aeon, UEF, and Seraphim towers breaks.
--  - Add more comments.
--  - Known issues:
--    - Aeon, UEF, and Seraphim construction towers present some minor cosmetic issues.