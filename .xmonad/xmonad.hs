-- IMPORTS

import XMonad
import Data.Monoid
import Data.Tree
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import System.IO (hPutStrLn)
import XMonad.Actions.SpawnOn
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import qualified XMonad.Hooks.EwmhDesktops as E
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.WorkspaceHistory
import XMonad.Layout.BoringWindows (boringWindows,focusDown,focusUp,focusMaster)
import XMonad.Layout.Fullscreen
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import qualified XMonad.StackSet as W
import XMonad.Util.Dmenu
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.Themes

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Preferences
--
myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "firefox"

myFont :: String
myFont = "xft:Hack:bold:size=13:antialias=true:hinting=true"

myLocker :: String
myLocker = "sxlock -f \"-misc-hack-medium-r-normal--50-0-*-*-m-0-ascii-0\""

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--

myWorkspaces :: [String]
--myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
myWorkspaces = ["一","二","三","四","五","六","七","八","九"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0055ff"


------------------------------------------------------------------------
-- Tree Select. Add, modify or remove actions here.

tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig {
    TS.ts_hidechildren = True
  , TS.ts_background   = 0xdd282a36
  , TS.ts_font         = myFont
  , TS.ts_node         = (0xffdddddd, 0xff202331)
  , TS.ts_nodealt      = (0xffdddddd, 0xff282a36)
  , TS.ts_highlight    = (0xffffffff, 0xff1a8fff)
  , TS.ts_extra        = 0xffdddddd
  , TS.ts_node_width   = 300
  , TS.ts_node_height  = 26
  , TS.ts_originX      = 0
  , TS.ts_originY      = 0
  , TS.ts_indent       = 80
  , TS.ts_navigate     = myTreeNavigation
}

myTreeNavigation = M.fromList
    [ ((0, xK_Escape),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_Up),       TS.movePrev)
    , ((0, xK_Down),     TS.moveNext)
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_q),        TS.cancel)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_h),        TS.moveParent)
    , ((0, xK_l),        TS.moveChild)
    , ((0, xK_o),        TS.moveHistBack)
    , ((0, xK_i),        TS.moveHistForward)
    ]

treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
  [ Node (TS.TSNode "+ Accessories" "Accessory applications" (return ()))
    [ Node (TS.TSNode "Ncmpcpp" "NCurses Music Player Client (Plus Plus)" (spawn (myTerminal ++ " -e ncmpcpp"))) []
    , Node (TS.TSNode "Qalculate" "GUI frontend for qalc" (spawn "qalculate-gtk")) []
    , Node (TS.TSNode "Virt-Manager" "Virtual machine manager" (spawn "virt-manager")) []
    , Node (TS.TSNode "Zathura" "A minimalistic document viewer" (spawn "zathura")) []
    ]
  , Node (TS.TSNode "+ Games" "Fun and games" (return ()))
    [ Node (TS.TSNode "Aisleriot" "A collection of patience games" (spawn "sol")) []
    , Node (TS.TSNode "Dungeon Crawl Stone Soup" "Open-source, role-playing roguelike game" (spawn "crawl-tiles")) []
    , Node (TS.TSNode "Infra Arcana" "Roguelike game inspired by H.P. Lovecraft" (spawn "infra-arcana")) []
    , Node (TS.TSNode "SuperTux" "A classic 2D jump'n'run sidescroller game" (spawn "supertux2")) []
    , Node (TS.TSNode "They Bleed Pixels" "Cult classic platforming slash-em up" (spawn "TheyBleedPixels")) []
    ]
  , Node (TS.TSNode "+ Internet" "Internet and web programs" (return ()))
    [ Node (TS.TSNode "+ Reddit" "Reddit viewer and common subreddits" (return ()))
      [ Node (TS.TSNode "RTV" "Reddit terminal viewer" (spawn (myTerminal ++ " -e rtv"))) []
      , Node (TS.TSNode "r/adventofcode" "Advent of Code subreddit" (spawn (myTerminal ++ " -e rtv -s adventofcode"))) []
      , Node (TS.TSNode "r/archlinux" "Arch Linux subreddit" (spawn (myTerminal ++ " -e rtv -s archlinux"))) []
      , Node (TS.TSNode "r/freetube" "FreeTube subreddit" (spawn (myTerminal ++ " -e rtv -s freetube"))) []
      , Node (TS.TSNode "r/linux" "Linux subreddit" (spawn (myTerminal ++ " -e rtv -s linux"))) []
      , Node (TS.TSNode "r/unixporn" "Unix porn subreddit" (spawn (myTerminal ++ " -e rtv -s unixporn"))) []
      , Node (TS.TSNode "r/xmonad" "XMonad subreddit" (spawn (myTerminal ++ " -e rtv -s xmonad"))) []
      ]
    , Node (TS.TSNode "Badwolf" "Minimalist and privacy-oriented web browser" (spawn "badwolf")) []
    , Node (TS.TSNode "Firefox" "Open source web browser" (spawn "firefox")) []
    , Node (TS.TSNode "FreeTube" "Open source desktop YouTube player built with privacy in mind" (spawn "freetube")) []
    , Node (TS.TSNode "Neomutt" "Text-based mail client" (spawn (myTerminal ++ " -e neomutt"))) []
    , Node (TS.TSNode "Newsboat" "RSS reader" (spawn (myTerminal ++ " -e newsboat"))) []
    , Node (TS.TSNode "Search" "Internet search utility" (spawn "search -c -l 20")) []
    , Node (TS.TSNode "Transmission" "Bittorrent client" (spawn "transmission-gtk")) []
    ]
  , Node (TS.TSNode "+ System" "System tools and utilities" (return ()))
    [ Node (TS.TSNode "Alacritty" "GPU accelerated terminal" (spawn "alacritty")) []
    , Node (TS.TSNode "Glances" "Terminal system monitor" (spawn (myTerminal ++ " -e glances"))) []
    , Node (TS.TSNode "Gotop" "Terminal-based graphical activity monitor" (spawn (myTerminal ++ " -e gotop"))) []
    , Node (TS.TSNode "Htop" "Terminal process viewer" (spawn (myTerminal ++ " -e htop"))) []
    , Node (TS.TSNode "Ranger" "Simple, vim-like file manager" (spawn (myTerminal ++ " -e ranger"))) []
    , Node (TS.TSNode "XTerm" "X terminal emulator" (spawn "xterm")) []
    ]
  , Node (TS.TSNode "+ XMonad" "Working with XMonad" (return ()))
    [ Node (TS.TSNode "Edit XMonad" "Edit xmonad.hs" (spawn (myTerminal ++ " -e nvim ~/.xmonad/xmonad.hs"))) []
    , Node (TS.TSNode "Edit XMobar" "Edit .xmobarrc" (spawn (myTerminal ++ " -e nvim ~/.xmobarrc"))) []
    , Node (TS.TSNode "Recompile XMonad" "Recompile xmonad" (spawn "xmonad --recompile")) []
    , Node (TS.TSNode "Restart XMonad" "Restart xmonad" (spawn "xmonad --restart")) []
    ]
  , Node (TS.TSNode "Lock" "Lock current session" (spawn myLocker)) []
  , Node (TS.TSNode "Logout" "Logout of account" (io (exitWith ExitSuccess))) []
  , Node (TS.TSNode "Shutdown" "Poweroff the system" (spawn "sdprompt")) []
  ]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask,   xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,                 xK_p     ), spawn "dmenu_run")

    -- launch browser
    , ((modm .|. shiftMask,   xK_w     ), spawn myBrowser)
    
    -- launch search utility
    , ((modm              ,   xK_f     ), spawn "search")

    -- launch search utility
    , ((modm              ,   xK_c     ), spawn "calc")
    
    -- launch freetube
    , ((modm .|. shiftMask,   xK_y     ), spawn "freetube")

    -- treeselect action
    , ((modm,                 xK_s     ), treeselectAction tsDefaultConfig)

    -- toggle screensaver
    , ((modm,                 xK_x     ), spawn "toggleScreensaver")

    -- take screenshot
    , ((0   ,                 xK_Print ), spawn "printscreen")

    -- change screen brightness
    , ((0, xF86XK_MonBrightnessUp      ), spawn "changeBrightness -inc 5")
    , ((0, xF86XK_MonBrightnessDown    ), spawn "changeBrightness -dec 5")

    -- change volume level
    , ((0, xF86XK_AudioRaiseVolume     ), spawn "changeVolume 2%+")
    , ((0, xF86XK_AudioLowerVolume     ), spawn "changeVolume 2%-")
    , ((0, xF86XK_AudioMute            ), spawn "changeVolume toggle")

    -- mpd commands
    , ((0, xF86XK_AudioPlay               ), spawn "mpc toggle")
    , ((0, xF86XK_AudioPrev               ), spawn "mpc prev")
    , ((0, xF86XK_AudioNext               ), spawn "mpc next")
    , ((shiftMask, xF86XK_AudioRaiseVolume), spawn "mpc volume +2")
    , ((shiftMask, xF86XK_AudioLowerVolume), spawn "mpc volume -2")

    -- close focused window
    , ((modm .|. shiftMask,   xK_c     ), kill)

    -- Resize viewed windows to the correct size
    , ((modm,                 xK_n     ), refresh)

    -- Move focus to the next group
    , ((modm,                 xK_j     ), focusDown)

    -- Move focus to the previous group
    , ((modm,                 xK_k     ), focusUp  )

    -- Move focus to the master window
    , ((modm,                 xK_m     ), focusMaster  )

    -- Move focus to the previous window in group
    , ((modm,                 xK_i     ), onGroup W.focusUp')

    -- Move focus to the next window in group
    , ((modm,                 xK_o     ), onGroup W.focusDown')

    -- Swap the focused window and the master window
    , ((modm,                 xK_Return), windows W.swapMaster)
    -- TODO: boringwindows

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask,   xK_j     ), windows W.swapDown  )
    -- TODO: boringwindows

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask,   xK_k     ), windows W.swapUp    )
    -- TODO: boringwindows

    -- Shrink the master area
    , ((modm,                 xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,                 xK_l     ), sendMessage Expand)

    -- Shrink window vertically
    , ((modm,                 xK_minus ), sendMessage MirrorShrink)

    -- Expand the master area
    , ((modm .|. shiftMask,   xK_equal ), sendMessage MirrorExpand)
    -- FIXME: xK_plus is apparenlty a different key

    -- Pull windows into tabs
    , ((modm .|. controlMask, xK_h                   ), sendMessage $ pullGroup L)
    , ((modm .|. controlMask, xK_l                   ), sendMessage $ pullGroup R)
    , ((modm .|. controlMask, xK_j                   ), sendMessage $ pullGroup D)
    , ((modm .|. controlMask, xK_k                   ), sendMessage $ pullGroup U)
    , ((modm .|. controlMask, xK_m                   ), withFocused $ (sendMessage . MergeAll))
    , ((modm .|. controlMask, xK_u                   ), withFocused $ (sendMessage . UnMerge))
    , ((modm .|. shiftMask .|. controlMask, xK_u     ), withFocused $ (sendMessage . UnMergeAll))

    -- Push window back into tiling
    , ((modm,                 xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Quit xmonad
    , ((modm .|. shiftMask,   xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              ,   xK_q     ), spawn "xmonad --recompile; pkill xmobar; xmonad --restart")

    -- Shutdown prompt
    , ((modm .|. shiftMask,   xK_s     ), spawn "sdprompt")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    -- ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    -- [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --     | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --     , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]


------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--

-- myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)

mySpacing i = spacingRaw False (Border i 0 i 0) True (Border 0 i 0 i) True
tall = renamed [Replace "tall"]
       $ windowNavigation
       $ addTabs shrinkText myTabTheme
       $ subLayout [] (Simplest)
       $ mySpacing 10
       $ ResizableTall 1 (3/100) (1/2) []

myLayout = avoidStruts $ fullscreenFull $ boringWindows $ tall

myTabTheme = def {
    fontName            = myFont
  , activeColor         = "#1a8fff"
  , inactiveColor       = "#767676"
  , activeBorderColor   = "#0055ff"
  , inactiveBorderColor = "#0055ff"
  , activeTextColor     = "#000000"
  , inactiveTextColor   = "#000000"
}

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

myManageHook = manageSpawn <+> fullscreenManageHook <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = E.ewmhDesktopsEventHook <+> fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = updatePointer(0.5, 0.5) (0, 0)

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
    -- Change X settings
      spawnOnce "xbacklight -set 20"
      spawnOnce "xset r rate 300 50"
      spawnOnce "xset +dpms"
      spawnOnce "xset s 300 15"
      spawnOnce "xsetroot -cursor_name left_ptr"
      spawnOnce ("xss-lock -- " ++ myLocker)
    -- Polkit authentication agent
      spawnOnce "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"
    -- Desktop wallpaper, compositor, and notification server
      spawnOnce "feh --no-fehbg --bg-fill /usr/local/share/backgrounds/forest-1.jpg"
      spawnOnce "picom -f"
      spawnOnce "dunst"
    -- Night light, hide mouse
      spawnOnce "unclutter --timeout 1"
      spawnOnce "redshift"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify.
--
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ docks $ E.ewmh $ fullscreenSupport def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP 
          {
              ppOutput  = \x -> hPutStrLn xmproc x
            , ppCurrent = xmobarColor "#19cb00" "" . wrap "[" "]" -- Current workspace in xmobar
            , ppHidden  = xmobarColor "#0dcdcd" "" . wrap "*" ""  -- Hidden workspaces in xmobar
            , ppHiddenNoWindows = xmobarColor "#0d73cc" ""        -- Hidden workspaces (no windows)
            , ppUrgent  = xmobarColor "#f2201f" "" . wrap "!" "!" -- Urgent workspaces in xmobar
            , ppTitle   = xmobarColor "#19cb00" "" . shorten 40   -- Active window title
            , ppOrder  = \(ws:_:t:_) -> ["<fn=1>" ++ ws ++ "</fn>",t]
          },
        startupHook        = myStartupHook
    }

