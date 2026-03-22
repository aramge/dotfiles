import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)

-- Neu für die stabile Platzierung
import XMonad.Actions.SpawnOn (spawnOn, manageSpawn)
import XMonad.Util.SpawnOnce (spawnOnce, spawnOnOnce)

import XMonad.Layout.MultiToggle (mkToggle, single, Toggle(..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL))
import XMonad.Hooks.ManageDocks (ToggleStruts(..))

myManageHook :: ManageHook
myManageHook = composeAll
    [ manageSpawn -- WICHTIG: Erlaubt spawnOn/spawnOnOnce seine Arbeit zu tun
    , className =? "keepassxc"        --> doShift "1"
    , className =? "chromium-browser" --> doShift "1"
    ]

myStartupHook :: X ()
myStartupHook = do
    -- DPI fixen
    spawnOnce "fix-dpi"
    -- Programme direkt auf Workspaces zwingen
    spawnOnOnce "1" "keepassxc"
    spawnOnOnce "1" "ghostty --title=ghostty-1"
    spawnOnOnce "1" "chromium"
    spawnOnOnce "2" "ghostty --title=ghostty-2"
    spawnOnOnce "3" "ghostty --title=ghostty-3"

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh =<< xmobar (def
    { modMask           = mod4Mask
    , terminal          = "ghostty"
    , focusFollowsMouse = False

    , borderWidth       = 5
    , focusedBorderColor= "#E58C7A"
    , normalBorderColor = "#2B3A42"

    , layoutHook        = mkToggle (single NBFULL) (layoutHook def)
    , manageHook        = myManageHook <+> manageHook def
    , startupHook       = myStartupHook
    }
    `additionalKeysP`
    [ ("M-S-ü", spawn "maim -s | xclip -selection clipboard -t image/png")
    , ("M-p",   spawn "rofi -show drun")
    , ("M-z",   sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts)
    , ("M-f",   spawn "fix-dpi") -- Falls du manuell nachfeuern willst
    ])
