import XMonad
import XMonad.Util.EZConfig (additionalKeysP)

main = xmonad $ def
    { modMask = mod4Mask } -- Command/Windows als Mod-Key
    `additionalKeysP`
    [ ("M-S-p", spawn "maim ~/screenshot.png")
    , ("M-p",   spawn "rofi -show drun")
    ]

