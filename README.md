AutoHotKey scripts. My favorite shitty programming languages, it's awfully convenient to make context sensitive macros and remappings in general, as well as a not completely awful scripting language that lets you do a lot with COM objects and DLL calls.

Mostly, however, it just has some good primitives for creating hotkeys with multiple binding methods with keyboard, mouse hooks and registry mappings.

Some of these scripts use [Interception](https://github.com/oblitum/Interception) and [AHI](https://github.com/evilC/AutoHotInterception) for its key pickup needs. This in turn requires a companion driver, but usually it's for a good reason. At the moment, it's only used in Tabbing.ahk, to be able to pick up keypress events from frozen windows in hotkeys that would otherwise require the keyboard hook to be used.
