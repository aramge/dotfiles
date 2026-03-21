import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeysP)

main = xmonad =<< xmobar (def
    { modMask           = mod4Mask  -- Command/Windows als Mod-Key
    , terminal          = "ghostty"
    , focusFollowsMouse = False
    }
    `additionalKeysP`
    [ ("M-S-ü", spawn "maim -s | xclip -selection clipboard -t image/png")
    , ("M-p",   spawn "rofi -show drun")
    ])
