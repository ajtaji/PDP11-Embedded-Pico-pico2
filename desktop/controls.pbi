; desktop/controls.pbi - every key the window takes, in ONE table. The keyboard code
; (PDP11Desktop.pb, the event loop) looks each key up here, and the Controls tab draws
; this same table, so the two cannot disagree. desktop/README.md's "Controls" lists it too.
;
; A row: group (console or window), when (always, windowed only, full screen only), the
; Ctrl key (needed or not), a key range (PureBasic #PB_Shortcut_ codes, low and high),
; the value (console: the character the first key of the range sends, the next key the
; next character; window: an action), the keys as shown, and what it does.

#CTL_CONSOLE = 0                          ; to the console terminal (DL11 177560)
#CTL_WINDOW = 1                           ; the window's own action

#CTL_ALWAYS = 0
#CTL_WINDOWED = 1
#CTL_FULL = 2

#CTL_FULLSCREEN = 1                       ; the window's actions
#CTL_LEAVEFULL = 2

Structure CtlRow
  group.l
  when.l
  ctrl.l
  keyLo.l
  keyHi.l
  value.l
  keys$
  what$
EndStructure

Global NewList CtlRows.CtlRow()

Procedure CtlLoad()
  Protected n.l, i.l
  ClearList(CtlRows())
  Restore CtlTable
  Read.l n
  For i = 1 To n
    AddElement(CtlRows())
    Read.l CtlRows()\group : Read.l CtlRows()\when : Read.l CtlRows()\ctrl
    Read.l CtlRows()\keyLo : Read.l CtlRows()\keyHi : Read.l CtlRows()\value
    Read.s CtlRows()\keys$ : Read.s CtlRows()\what$
  Next
EndProcedure

; The row for a key: group, Ctrl held, full screen or not. Returns the row's value for
; that key (console: the character; window: the action) and sets CtlHitGroup, or -1.
Global CtlHitGroup.l
Procedure.l CtlFind(key.l, ctrl.l, full.l)
  ForEach CtlRows()
    If key >= CtlRows()\keyLo And key <= CtlRows()\keyHi And Bool(ctrl) = CtlRows()\ctrl
      If CtlRows()\when = #CTL_ALWAYS Or (CtlRows()\when = #CTL_WINDOWED And full = 0) Or (CtlRows()\when = #CTL_FULL And full)
        CtlHitGroup = CtlRows()\group
        ProcedureReturn CtlRows()\value + key - CtlRows()\keyLo
      EndIf
    EndIf
  Next
  ProcedureReturn -1
EndProcedure

DataSection
  CtlTable:
  Data.l 12
  ; the console: what the PC's keys send to the PDP-11 (printable characters go as they are)
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 0, #PB_Shortcut_Return, #PB_Shortcut_Return, 13
  Data.s "Return", "CR (015)"
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 0, #PB_Shortcut_Back, #PB_Shortcut_Back, 8
  Data.s "Backspace", "^H (010), V6/V7's erase is # unless stty says otherwise"
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 0, #PB_Shortcut_Tab, #PB_Shortcut_Tab, 9
  Data.s "Tab", "TAB (011)"
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 0, #PB_Shortcut_Delete, #PB_Shortcut_Delete, 127
  Data.s "Delete", "DEL (177), Unix's interrupt"
  Data.l #CTL_CONSOLE, #CTL_WINDOWED, 0, #PB_Shortcut_Escape, #PB_Shortcut_Escape, 27
  Data.s "Esc", "ESC (033), in the window (in full screen Esc leaves it: use Ctrl+[)"
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 1, 219, 219, 27
  Data.s "Ctrl+[", "ESC (033), in the window and in full screen"
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 1, #PB_Shortcut_A, #PB_Shortcut_Z, 1
  Data.s "Ctrl+A ... Ctrl+Z", "the control characters 001-032 (Ctrl+D end of file, Ctrl+S / Ctrl+Q stop and start output)"
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 1, 220, 220, 28
  Data.s "Ctrl+\", "FS (034), Unix's quit"
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 1, 221, 221, 29
  Data.s "Ctrl+]", "GS (035)"
  Data.l #CTL_CONSOLE, #CTL_ALWAYS, 0, -1, -1, -1
  Data.s "Mouse wheel", "scrolls the console back through its history (any key goes back to the bottom)"
  ; the window
  Data.l #CTL_WINDOW, #CTL_ALWAYS, 0, #PB_Shortcut_F11, #PB_Shortcut_F11, #CTL_FULLSCREEN
  Data.s "F11", "full screen on and off (also the Full screen button)"
  Data.l #CTL_WINDOW, #CTL_FULL, 0, #PB_Shortcut_Escape, #PB_Shortcut_Escape, #CTL_LEAVEFULL
  Data.s "Esc", "leaves full screen"
EndDataSection
