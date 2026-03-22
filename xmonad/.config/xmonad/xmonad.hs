import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)

import XMonad.Layout.MultiToggle (mkToggle, single, Toggle(..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL))
import XMonad.Hooks.ManageDocks (ToggleStruts(..))

main :: IO ()
main = xmonad . ewmhFullscreen . ewmh =<< xmobar (def
    { modMask           = mod4Mask
    , terminal          = "ghostty"
    , focusFollowsMouse = False

    -- Das optische Tuning: Tahoe-Style
    , borderWidth       = 5                    -- Dreimal so dick wie vorher
    , focusedBorderColor= "#E58C7A"            -- Tahoe-Rot (Sanftes Koralle/Ziegelrot)
    , normalBorderColor = "#2B3A42"            -- Tahoe-Dunkelblau/Tiefseegrau

    , layoutHook        = mkToggle (single NBFULL) (layoutHook def)
    }
    `additionalKeysP`
    [ ("M-S-ü", spawn "maim -s | xclip -selection clipboard -t image/png")
    , ("M-p",   spawn "rofi -show drun")
    , ("M-z",   sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts)
    ])
