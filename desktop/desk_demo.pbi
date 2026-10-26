; desktop/desk_demo.pbi - the window's half of the demo devices (machine_demo.pbi):
; the Display tab (the framebuffer as a texture, at a whole-number scale) and
; the four voices through the PC's sound (waveOut, 22050 Hz, 16-bit mono).
; Included by PDP11Desktop.pb after the engine and the machine.

; ---- the display -------------------------------------------------------------
Global *DeskDdSprite.GLSprite
Global *DeskDdPixels

Procedure DeskDdInit()                     ; after the GL context exists
  *DeskDdPixels = AllocateMemory(#DEMO_W * #DEMO_H * 4)
  *DeskDdSprite = AllocateMemory(SizeOf(GLSprite))
  *DeskDdSprite\Width = #DEMO_W : *DeskDdSprite\Height = #DEMO_H
  glGenTextures_(1, @*DeskDdSprite\TextureID)
  glBindTexture_(#GL_TEXTURE_2D, *DeskDdSprite\TextureID)
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MIN_FILTER, #GL_NEAREST)
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_MAG_FILTER, #GL_NEAREST)
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_WRAP_S, #GL_CLAMP_TO_EDGE)
  glTexParameteri_(#GL_TEXTURE_2D, #GL_TEXTURE_WRAP_T, #GL_CLAMP_TO_EDGE)
  glTexImage2D_(#GL_TEXTURE_2D, 0, #GL_RGBA, #DEMO_W, #DEMO_H, 0, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, *DeskDdPixels)
EndProcedure

; The pane: the frame centred at the largest whole scale that fits. On Windows
; DrawGLSprite samples the texture bottom row first (it is made for
; DrawingBuffer's bottom-up images), so the rows go in bottom first.
Procedure DeskDisplayPane(x.f, y.f, w.f, h.f)
  Protected sc.l, dw.f, dh.f, info$
  Neon_Box(x, y, w, h, 0.03, 0.03, 0.04)
  If *DeskDdSprite = 0 : ProcedureReturn : EndIf
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    DdRender(*DeskDdPixels + (#DEMO_H - 1) * #DEMO_W * 4, -#DEMO_W * 4)
  CompilerElse
    DdRender(*DeskDdPixels, #DEMO_W * 4)
  CompilerEndIf
  glBindTexture_(#GL_TEXTURE_2D, *DeskDdSprite\TextureID)
  glTexSubImage2D_(#GL_TEXTURE_2D, 0, 0, 0, #DEMO_W, #DEMO_H, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, *DeskDdPixels)
  sc = (h - S(40)) / #DEMO_H
  If (w - S(20)) / #DEMO_W < sc : sc = (w - S(20)) / #DEMO_W : EndIf
  If sc < 1 : sc = 1 : EndIf
  dw = #DEMO_W * sc : dh = #DEMO_H * sc
  If DdCsr & 1
    DrawGLSprite(*DeskDdSprite, x + (w - dw) / 2, y + S(8), 0.0, sc, 1, 1, 1, 1, #True, -1, -1, -1, -1, #True)
  Else
    Neon_Box(x + (w - dw) / 2, y + S(8), dw, dh, 0, 0, 0)
    Neon_TextCentre(*Neon_FontUI, x, w, y + S(8) + dh / 2 - S(10), "display off (DCSR bit 0)", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  EndIf
  info$ = "320 x 200 x 4 bits at " + DeskOct((DdBase << 6) & $3FFFFF, 8) + "   DPCSR " + DeskOct(DdCsr & $C1, 6) + "   scroll " + Str(DdScroll) + "   frame " + Str(DdFrames) + "   x" + Str(sc)
  info$ + "     sound" + StringField(" (off): | on: ", (DdSndCsr & 1) + 1, "|")
  Protected i.l
  For i = 0 To 3
    If DdFreq(i) And DdVol(i)
      info$ + Str(DdFreq(i)) + " Hz/" + Str(DdVol(i)) + StringField(" sq| tri| saw| noise", DdWave(i) + 1, "|") + "  "
    EndIf
  Next
  Neon_Text(*Neon_FontSmall, x + S(12), y + h - S(24), info$, Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
EndProcedure

; Full screen: the frame in the rectangle given (its aspect already 320:200), or black
; with a note while the display is off.
Procedure DeskDisplayFull(x.f, y.f, w.f, h.f)
  If *DeskDdSprite = 0 : ProcedureReturn : EndIf
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    DdRender(*DeskDdPixels + (#DEMO_H - 1) * #DEMO_W * 4, -#DEMO_W * 4)
  CompilerElse
    DdRender(*DeskDdPixels, #DEMO_W * 4)
  CompilerEndIf
  glBindTexture_(#GL_TEXTURE_2D, *DeskDdSprite\TextureID)
  glTexSubImage2D_(#GL_TEXTURE_2D, 0, 0, 0, #DEMO_W, #DEMO_H, #GL_BGRA_EXT, #GL_UNSIGNED_BYTE, *DeskDdPixels)
  If DdCsr & 1
    DrawGLSprite(*DeskDdSprite, x, y, 0.0, w / #DEMO_W, 1, 1, 1, 1, #True, -1, -1, -1, -1, #True)
  Else
    Neon_TextCentre(*Neon_FontUI, x, w, y + h / 2 - S(10), "display off (DCSR bit 0)", Neon_C_DimR, Neon_C_DimG, Neon_C_DimB)
  EndIf
EndProcedure

; ---- the sound -----------------------------------------------------------------
#AU_RATE = 22050
#AU_BUFS = 4
#AU_LEN = 735                              ; samples a buffer: 1/30 s
Global AuWave.i                            ; the waveOut handle, 0 none
Global Dim AuHdr.WAVEHDR(#AU_BUFS)
Global Dim *AuBuf(#AU_BUFS)
Global Dim AuPhase.d(4)
Global AuNoise.l = $ACE1, AuStarted.l

Procedure DeskAudioOpen()
  Protected fmt.WAVEFORMATEX, i.l
  fmt\wFormatTag = #WAVE_FORMAT_PCM : fmt\nChannels = 1 : fmt\nSamplesPerSec = #AU_RATE
  fmt\wBitsPerSample = 16 : fmt\nBlockAlign = 2 : fmt\nAvgBytesPerSec = #AU_RATE * 2
  If waveOutOpen_(@AuWave, #WAVE_MAPPER, @fmt, 0, 0, #CALLBACK_NULL) <> #MMSYSERR_NOERROR
    AuWave = 0
    DeskSay("sound: the PC's sound output could not be opened; the demo plays silent")
    ProcedureReturn
  EndIf
  For i = 0 To #AU_BUFS - 1
    *AuBuf(i) = AllocateMemory(#AU_LEN * 2)
    AuHdr(i)\lpData = *AuBuf(i) : AuHdr(i)\dwBufferLength = #AU_LEN * 2
    waveOutPrepareHeader_(AuWave, @AuHdr(i), SizeOf(WAVEHDR))
    AuHdr(i)\dwFlags | #WHDR_DONE              ; free to fill
  Next
EndProcedure

; One buffer of the four voices, as the registers stand.
Procedure DeskAudioFill(*buf)
  Protected n.l, v.l, s.d, ph.d, out.l, amp.d
  For n = 0 To #AU_LEN - 1
    s = 0.0
    For v = 0 To 3
      If DdFreq(v) > 0 And DdVol(v) > 0
        ph = AuPhase(v) + DdFreq(v) / #AU_RATE
        If ph >= 1.0 : ph - Int(ph) : EndIf
        AuPhase(v) = ph
        amp = DdVol(v) / 15.0
        Select DdWave(v)
          Case 0 : If ph < 0.5 : s + amp : Else : s - amp : EndIf
          Case 1 : s + amp * (1.0 - 4.0 * Abs(ph - 0.5))
          Case 2 : s + amp * (2.0 * ph - 1.0)
          Case 3
            If ph < DdFreq(v) / #AU_RATE         ; a new noise value each period
              AuNoise = ((AuNoise >> 1) | (((AuNoise ! (AuNoise >> 2) ! (AuNoise >> 3) ! (AuNoise >> 5)) & 1) << 15)) & $FFFF
            EndIf
            If AuNoise & 1 : s + amp : Else : s - amp : EndIf
        EndSelect
      EndIf
    Next
    out = s * (DdMaster / 15.0) * 6000.0
    If DdSndCsr = 0 : out = 0 : EndIf
    If out > 32767 : out = 32767 : ElseIf out < -32768 : out = -32768 : EndIf
    PokeW(*buf + n * 2, out)
  Next
EndProcedure

; Each frame: every buffer the PC has played is filled again and queued. Only
; once a program has used the devices, so the window is silent otherwise.
Procedure DeskAudioPump()
  Protected i.l
  If AuWave = 0 Or DdUsed = 0 : ProcedureReturn : EndIf   ; (silence is played while SNDCSR is 0)
  For i = 0 To #AU_BUFS - 1
    If AuHdr(i)\dwFlags & #WHDR_DONE
      DeskAudioFill(*AuBuf(i))
      AuHdr(i)\dwFlags & ~#WHDR_DONE
      waveOutWrite_(AuWave, @AuHdr(i), SizeOf(WAVEHDR))
    EndIf
  Next
EndProcedure
