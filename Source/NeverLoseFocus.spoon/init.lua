--- === NeverLoseFocus ===
---
--- Whenever you close or minimize the last visible window of a macOS
--- application, that application is still active, even though some
--- other application's window might now be the frontmost window.
---
--- - This Spoon tracks window focus and unfocus events to ensure
---   that you're never without focus!
---
--- - When the last visible window of an application is closed or
---   minimized, this Spoon will focus the next most recently used
---   and still-visible application's window.
---
--- - This Spoon's behavior emulates the window-centric behaviour of
---   Linux and Windows, and eschews the app-centric macOS paradigm.
---
---   - The Apple approach, in this author's opinion, is a remnant of
---     System 6 and before's single-tasking model. That is, early
---     macOS won't switch apps unless you quit one app and start another;
---     and with System 7 onwards, macOS won't switch apps even when
---     you close the last application window — indeed, you'll still
---     see the application's menu bar, sans application windows
---     (though some other app's window might now be the frontmost
---     window, albeit without focus... which I still find strange!).
---
---     Which I sorta get, because macOS attaches the menu bar to the
---     top of the display, disconnected from any application window.
---
---     This is in contrast to Linux or Windows, where each application
---     window has its own menu bar.
---
---   - But if you like to hide the macOS menu bar (I do!), it can be
---     confusing when you close the last app window, some other app's
---     window is now topmost, yet you cannot interact with it! (FYI,
---     I use a GeekTool geeklet to display the time on my Desktop, in
---     the exact position where the macOS menu bar clock would appear;
---     and otherwise I almost exclusively use keyboard shortcuts to
---     interact with my apps, so that I rarely use the menu bar.) (Also
---     I hide the Dock and mostly use Hammerspoon bindings and the
---     occassional Spotlight Search to switch between apps and windows.)
---
---   - So here you have it, just one culty Linux dev's Spoon to help
---     make their macOS host basically just another Linux distro.
---
---     - See also my other Hammerspoon and Karabiner Elements config,
---       and `defaults write ... NSUserKeyEquivalents` project,
---       in furtherance of the same goal:
---
---         https://github.com/DepoXy/macOS-onboarder#🏂
---         https://github.com/DepoXy/macOS-Hammyspoony#🥄
---         https://github.com/DepoXy/Karabiner-Elephants#🐘
---
--- - ALTLY: Without this Spoon, another approach is to <Cmd-H> hide
---   the app after closing/minimizing last visible window, thereby
---   focusing whatever window is topmost (but that doesn't have focus).
---
--- Download: [https://github.com/DepoXy/macOS-Hammyspoony/raw/release/Spoons/NeverLoseFocus.spoon.zip](https://github.com/DepoXy/macOS-Hammyspoony/raw/release/Spoons/NeverLoseFocus.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "NeverLoseFocus"
obj.version = "1.0.0"
obj.author = "Landon Bouma <https://tallybark.com/>"
obj.homepage = "https://github.com/DepoXy/macOS-Hammyspoony#🥄"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- NeverLoseFocus.logger
--- Variable
--- Logger object used within the Spoon. Can be accessed to set the default
---   log level for the messages coming from the Spoon.
obj.logger = hs.logger.new('NeverLoseFocus')

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

obj.trace = false
-- USAGE: Enable obj.trace for popup messaging.
--
--  obj.trace = true

-- Shows a brief popup, and logs to the Hammerspoon Console.
-- - Callers can use hs.inspect() to convert tables and more complex
--   objects to text.
-- - Uses print and not the logger b/c logger adds a lot of indentation:
--     obj.logger.setLogLevel("debug")
--     obj.logger.d(msg)
obj.debug = function(msg, force)
  if (obj.trace or force) then
    hs.alert.show(msg)
    print(msg)
  end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Ensure user is never (when possible) without focus!
--
-- - This window filter ensures (or at least tries to ensure) that
--   you're never left trying to interact with a window that's not
--   actually focused after closing or minimizing the last window
--   for an application.

-- This table is an ordered list of most recently used applications, so
-- we can find the most appropriate window to focus after user closes
-- or minimizes the last visible window for a particular application.
-- - WORDS: "MRU": Most Recently Used (pretty obvi., but I'm pedantic).
obj.mru_apps = {}

-- Window filter that tracks all apps' windows (via the "true" arg).
--   https://www.hammerspoon.org/docs/hs.window.filter.html#new
obj.all_windows_filter = hs.window.filter.new(true)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- SAVVY: Lua uses 1-based counters, not 0-based.
-- - From what I've read, this is because Lua was developed (as a
--   successor to Sol) as a language for non-CSCI engineers (for
--   the Brazilian oil co., PETROBRAS), to be easier to learn...
--   so I'll comment this as such, because I'll probably
--   forget this in the future (at least the "why" part).
--   - REFER: https://www.lua.org/history.html
--     - Sol: https://en.wikipedia.org/wiki/Secure_Operations_Language
-- - Some other langs index similarly from 1, including COBOL, Fortran,
--   Julia, MATLAB, Sass, etc.
--   - REFER:
-- https://en.wikipedia.org/wiki/Comparison_of_programming_languages_%28array%29#Array_system_cross-reference_list
obj.lua_array_first_element = 1

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Whenever an app's window is focused, make that app the MRU app.
-- - Args:
--   _win is unimportant
--   _app_name we'll track
--   _event is a string: "windowFocused"
obj.mru_apps_track_focused = function(_win, app_name, _event)
  obj.debug("INFOCUS: " .. app_name)

  -- - Remove app from previous position, if previously recorded.
  local idx = obj.index_of(obj.mru_apps, app_name)
  if idx then
    table.remove(obj.mru_apps, idx)
  end

  -- User focused this app, so make it the most-recently-used app.
  -- - Except ignore Hammerspoon, it's... different (it reports multiple
  --   (unnamed) visibleWindows(), even when its Console window is closed).
  if not obj.is_app_excluded(app_name) then
    -- - Insert app at the first position.
    table.insert(obj.mru_apps, obj.lua_array_first_element, app_name)
  end
end

obj.all_windows_filter:subscribe(
  hs.window.filter.windowFocused,
  obj.mru_apps_track_focused
)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Whenever an app's window is unfocused, focus another app's window
-- if that was the last "visible" window for the active app.
--
-- - BWARE: Note that `hs.application.get(<App name>):visibleWindows()`
--   is non-empty when called immediately, even when <App name> has no
--   truly visible windows.
--
--   - So we'll delay before probing... though even with 200ms sleep,
--     I still sometimes see visibleWindows() report windows that
--     were recently closed. E.g., open 5 Chrome windows, then close
--     them all, and #viz_wins is still 5....

obj.mru_apps_track_unfocused = function(win, app_name, event)
  obj.debug_report_app("UNFOCUS", app_name, event, "")

  -- Not so fast! (See comment above.)
  hs.timer.usleep(200000)

  obj.debug_report_app("UNFOCUS", app_name, "200ms later", "")

  local viz_wins = hs.application.get(app_name):visibleWindows()

  -- IDGIT: Hammerspoon reports different numbers of #viz_wins after you
  -- close the Conole window. 10. 29. 25. 35. All over the place.
  -- - So ignore the visibleWindows() count for Hammerspoon.
  if ((#viz_wins > 0) and not (obj.is_app_excluded(app_name))) then
    obj.debug("- App still has visible windows")
  else
    -- The app has no more visible windows, so it's no longer
    -- a most-recently-used-and-still-visible application.
    local idx = obj.index_of(obj.mru_apps, app_name)
    if idx then
      table.remove(obj.mru_apps, idx)
    end

    -- Now look for another application's window to promote to focus.
    local mru_app = obj.mru_apps[obj.lua_array_first_element]

    while mru_app do
      obj.debug_report_app("PROBING", mru_app, "", "  ")

      local focused_win = hs.application.get(mru_app):focusedWindow()

      -- TRACK: Just curious if visibleWindows XOR focusedWindow.
      obj.debug_compare_visibleWindows_and_focusedWindow(mru_app)

      if ((focused_win == nil) or obj.is_app_excluded(mru_app)) then
        table.remove(obj.mru_apps, obj.lua_array_first_element)
        mru_app = obj.mru_apps[obj.lua_array_first_element]
      else
        break
      end
    end

    if mru_app then
      obj.debug("- Focusing: " .. mru_app)
      hs.application.get(mru_app):setFrontmost()
    else
      obj.debug("- Nothing to focus")
      local quotes = {
        "You have no focus!",
        "Clarity affords focus",  -- Thomas Leonard [who?]
        "Never lose focus",
        "If you're going through hell, keep going.",  -- Winston Churchill
      }
      local rand = math.random(#quotes)

      hs.alert.show(quotes[rand])
    end
  end
end

obj.all_windows_filter:subscribe(
  hs.window.filter.windowUnfocused,
  obj.mru_apps_track_unfocused
)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

obj.is_app_excluded = function(app_name)
  local is_excluded = (false
    or (app_name == "Hammerspoon")
    -- What Hammerspoon sometimes reports for the Console window,
    -- but not always... hrmm.
    or (app_name == "Notification Center")
  )

  return is_excluded
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- NTRST: When you close the Hammerspoon Console window, isFrontmost()
--        is still true, but for other apps (Google Chrome and MacVim,
--        at least), it's false when you close their last visible window.
--        - Also Hammerspoon reports lots (tens) of unnamed windows,
--          even after closing the "Hammerspoon Console" window.

obj.debug_report_app = function(context, app_name, event, spacing)
  local viz_wins = hs.application.get(app_name):visibleWindows()

  local event_parenthetical = ""
  -- A Lua'ism: ~= is not equals (and not '!=', nor '<>').
  if event ~= "" then
    event_parenthetical = " (" .. event .. ")"
  end

  obj.debug(spacing .. context .. ": " .. app_name .. event_parenthetical)
  obj.debug(spacing .. "- #viz_wins:     " .. #viz_wins)
  obj.debug(spacing .. "- isFrontmost:   " .. hs.inspect(hs.application.get(app_name):isFrontmost()))
  obj.debug(spacing .. "- isHidden:      " .. hs.inspect(hs.application.get(app_name):isHidden()))
  local focusedWindow = hs.application.get(app_name):focusedWindow()
  obj.debug(spacing .. "- focusedWindow: " .. (focusedWindow and focusedWindow:title() or "nil"))
end

-- TRACK: I had issues with visibleWindows() early in development, but I
-- think that was before I added the 200ms sleep to mru_apps_track_unfocused.
-- - But I'm still curious if these 2 fcns. ever disagree.
obj.debug_compare_visibleWindows_and_focusedWindow = function(app_name)
  local viz_wins = hs.application.get(app_name):visibleWindows()
  local focused_win = hs.application.get(app_name):focusedWindow()

  if (
    ((#viz_wins == 0) and (focused_win ~= nil))
    or ((#viz_wins > 0) and (focused_win == nil))
  ) then
    local always_print = true

    obj.debug("GAFFE: focusedWindow and visibleWindows mismatch:", always_print)
    obj.debug(" - focusedWindow: " .. (focusedWindow and focusedWindow:title() or "nil"), always_print)
    obj.debug(" - visibleWindows: " .. hs.inspect(viz_wins), always_print)
  end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Return the first index with the given value, or nil if not found.
obj.index_of = function(array, value)
  for i, v in ipairs(array) do
    if v == value then

      return i
    end
  end

  return nil
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return obj

