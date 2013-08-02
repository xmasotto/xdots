import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Loggers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.Directory
import System.IO

-- Following This Guide:
-- http://thinkingeek.com/2011/11/21/simple-guide-configure-xmonad-dzen2-conky/

main = do
  homeDir <- getHomeDirectory
  xmproc <- spawnPipe ("/usr/bin/xmobar " ++ homeDir ++ "/.xmonad/xmobar.hs")
  xmonad $ defaultConfig {
    terminal = myTerminal,
--    workspaces = myWorkspaces,
    modMask = mod4Mask,
    layoutHook = myLayoutHook,
    manageHook = myManageHook,
    logHook = myLogHook xmproc,
    normalBorderColor = colorNormalBorder,
    focusedBorderColor = colorFocusedBorder,
    borderWidth = 1
    } `additionalKeys` myAdditionalKeys
    
myTerminal = "xterm"

-- Name yo workspaces
--myWorkspaces = ["1:main", "2:web", "3:emacs", "4:chat", "5:music", "6:gimp"]

-- Used to manage the layouts of the workspace
-- Can change the layouts specific to each workspace
myLayoutHook = avoidStruts $ layoutHook defaultConfig

-- Manages how new windows are positioned by default (own windows in their own 
-- workspace or mode) such as all firefox windows going in the "web:2" workspace
myManageHook = manageDocks <+> manageHook defaultConfig

-- What you pipe to xmobar
myLogHook xmproc = dynamicLogWithPP xmobarPP {
      ppOutput = hPutStrLn xmproc,
      ppTitle = xmobarColor "green" "" . shorten 50
      }

--colorNormalBorder = "#ccccc6"
colorNormalBorder = "#000000"
colorFocusedBorder = "#fd971f"

myAdditionalKeys = [
  ((mod4Mask .|. shiftMask, xK_z), spawn "lock_screen")
  ]
