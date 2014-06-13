SndGen =
  t0: 0
  t1: 0
  t2: 0
  dt: 1#8000 / pico.samplerate

  f0: () -> 0

  mainTheme3: (t) ->(t>>5)*(((t>>8*Math.tan(t>>7))/Math.sin(t>>8))*(t>>7/Math.sin(t>>9)))/t*t>>8
  mainTheme: (t) ->  16*(Math.sin(t>>3)*((156&t>>8)%11)&(t&(t>>8)%255))&64
  mainTheme5: (t) ->  (((43&t>>7)%14)*16)^(((3&t>>10)&Math.random()*12)<<3)
  landDefault: (t) -> (Math.sin(t * (Math.sin((t>>7)))&63)*13)&64
  dangerMassive: (t) -> ((((t<<2)%255.5)&(t<<2))^((t<<1)%255.5)&(t<<1))^((((t%8000)>>10)*(t%8000)>>9))^((3399999/ ((t%16000)-4000))^(439999/((t%8000))))&255
  musikDeath: (t) -> ( (t|t%255)^t&((t%8000)-((t>>1)&t>>1)) )&255

  fx1: (t) -> ((1999/t*Math.sin(t))&t>>2)*0.2
  fx2: (t) -> (((9999/t*Math.sin(t>>1)*Math.cos(t<<1)))&t>>3)&127
  fx3: (t) -> ((t<<5^t<<2^t>>1)&(59999/t))*0.4
  fx4: (t) -> (129999/t)&128
  fx5: (t) -> (t<<1)&(129999/t)&128

  functCh0: "f0"
  functCh1: "f0"
  functCh2: "f0"

  fadeTo: (ch, functEnd, timeSec, timeEndTarget) ->
    if !timeSec? then timeSec = 1
    functStart = @['functCh'+ch]
    tt = 0
    timeT = timeSec * pico.samplerate
    @['mix'+ch]= (t)->
      tt += @dt
      if tt>=timeT then @play(ch, functEnd, timeEndTarget)
      ( (@[functStart](t)*((timeT-tt)/ timeT)) + (@[functEnd](t)*(tt/ timeT)) )
    @['functCh'+ch] = "mix"+ch

  play: (ch, functName, time, resetT) ->
    if resetT is true then @["t"+ch] = 0
    if typeof time is "number"
      tt = 0
      timeT = time * pico.samplerate
      @['timePlay'+ch]= (t)->
        tt += @dt
        if tt>=timeT
          @["functCh"+ch]="f0"
        else
          @[functName](t)
      @["functCh"+ch] = 'timePlay'+ch
    else @["functCh"+ch] = functName

  process: (L, R) ->
    i = 0
    while i < L.length
      smpl = (@[@functCh0](@t0)+(@[@functCh1](@t1))+(@[@functCh2](@t2)))/3
      L[i] = R[i] = (smpl&255) / 512 
      @t0 += @dt
      @t1 += @dt
      @t2 += @dt
      i++

pico.setup(
  samplerate: 8000
  cellsize: 64
)

window.c = console; c.l = c.log

pico.play SndGen
window.snd = SndGen