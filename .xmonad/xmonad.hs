-- IMPORTS

import XMonad
import Data.Monoid
import Data.Tree
import Graphics.X11.ExtraTypes.XF86
import System.Exit
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Layout.Spacing
import qualified XMonad.StackSet as W
import XMonad.Util.Dmenu
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Preferences
--
myTerminal :: String
myTerminal = "alacritty" -- Preferred terminal

myBrowser :: String
myBrowser = "firefox" -- Preferred browser

myFont :: String
myFont = "xft:Hack:bold:size=13:antialias=true:hinting=true" -- Preferred font

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
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#0055ff"


------------------------------------------------------------------------
-- Tree Select. Add, modify or remove actions here.

tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xdd292d3e
                              , TS.ts_font         = myFont
                              , TS.ts_node         = (0xffdddddd, 0xff202331)
                              , TS.ts_nodealt      = (0xffdddddd, 0xff292d3e)
                              , TS.ts_highlight    = (0xffffffff, 0xff755999)
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
    [ Node (TS.TSNode "Qalculate" "GUI frontend for qalc" (spawn "qalculate-gtk")) []
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
    , Node (TS.TSNode "FreeTube" "Open source desktop YouTube player built with privacy in mind" (spawn "freetube-vue-git")) []
    , Node (TS.TSNode "Neomutt" "Text-based mail client" (spawn (myTerminal ++ " -e neomutt"))) []
    , Node (TS.TSNode "Newsboat" "RSS reader" (spawn (myTerminal ++ " -e newsboat"))) []
    , Node (TS.TSNode "Search" "Internet search utility" (spawn "search -c -l 20")) []
    , Node (TS.TSNode "Transmission" "Bittorrent client" (spawn "transmission-gtk")) []
    ]
  , Node (TS.TSNode "+ System" "System tools and utilities" (return ()))
    [ Node (TS.TSNode "Alacritty" "GPU accelerated terminal" (spawn "alacritty")) []
    , Node (TS.TSNode "Glances" "Terminal system monitor" (spawn (myTerminal ++ " -e glances"))) []
    , Node (TS.TSNode "Gotop" "Terminal-based graphical activity monitor" (spawn (myTerminal ++ " -e htop"))) []
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
  , Node (TS.TSNode "Lock" "Lock current session" (spawn "physlock -d")) []
  , Node (TS.TSNode "Logout" "Logout of account" (io (exitWith ExitSuccess))) []
  , Node (TS.TSNode "Shutdown" "Poweroff the system" (spawn "sdprompt")) []
  ]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch browser
    , ((modm .|. shiftMask, xK_w     ), spawn myBrowser)
    
    -- launch search utility
    , ((modm              , xK_f     ), spawn "search")
    
    -- launch freetube
    , ((modm .|. shiftMask, xK_y     ), spawn "freetube-vue-git")

    -- treeselect action
    , ((modm,               xK_s     ), treeselectAction tsDefaultConfig)

    -- toggle screensaver
    , ((modm,               xK_x     ), spawn "toggleScreensaver")

    -- change screen brightness
    , ((0, xF86XK_MonBrightnessUp     ), spawn "changeBrightness -inc 5")
    , ((0, xF86XK_MonBrightnessDown   ), spawn "changeBrightness -dec 5")

    -- change volume level
    , ((0, xF86XK_AudioRaiseVolume       ), spawn "changeVolume 2%+")
    , ((0, xF86XK_AudioLowerVolume       ), spawn "changeVolume 2%-")
    , ((0, xF86XK_AudioMute              ), spawn "changeVolume toggle")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; pkill xmobar; xmonad --restart")

    -- Shutdown prompt
    , ((modm .|. shiftMask, xK_s     ), spawn "sdprompt")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
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
myLayout = avoidStruts $ spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True (tiled ||| Mirror tiled |||  Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

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
myManageHook = composeAll
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
myEventHook = ewmhDesktopsEventHook

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
      spawnOnce "xset s 300 15"
      spawnOnce "xsetroot -cursor_name left_ptr"
      spawnOnce "xss-lock -- physlock"
    -- Polkit authentication agent
      spawnOnce "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"
    -- Desktop wallpaper, compositor, and notification server
      spawnOnce "feh --no-fehbg --bg-fill /usr/local/share/backgrounds/forest-1.jpg"
      spawnOnce "picom -f"
      spawnOnce "dunst"
    -- Night light, hide mouse
      spawnOnce "unclutter"
      spawnOnce "redshift"
    -- Set WM name so Java applications respect XMonad
      setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify.
--
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ docks $ ewmh defaults { handleEventHook = handleEventHook defaults <+> fullscreenEventHook }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
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
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The modifier key is 'super'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch alacritty",
    "mod-p            Launch dmenu",
    "mod-Shift-w      Launch firefox",
    "mod-Shift-y      Launch freetube",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
