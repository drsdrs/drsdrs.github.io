Crafty.c "basicStat",
  init: ->
    @p= Crafty.p
    @requires("2D, DOM, Color, Text").textFont(size: 2.5*@p.h+'px')

Crafty.c "scoreContainer",
  init: ->
    @requires("basicStat").text("SCORE:")
    @w = 25*@p.w
    @h = 2.7*@p.h
    @x = 1*@p.w+2
    @y = 1*@p.h+2

Crafty.c "ScoreBoard",
  init: ->
    @requires("basicStat")
    .color("#0ff").css("border", "2px solid black").css("text-align", "right")
    .text("0")
    @w = 25*@p.w
    @h = 2.7*@p.h
    @x = 1*@p.w
    @y = 1*@p.h
    @attach Crafty.e "scoreContainer"
  set: (score)-> @text(score)

Crafty.c "LiveBarContainer",
  init: ->
    @p= Crafty.p
    @requires("2D, DOM").css("border", "2px solid black")
    @w = 25*@p.w
    @h = 2.7*@p.h
    @x = 26.5*@p.w
    @y = 1*@p.h

Crafty.c "LiveBar",
  init: ->
    @requires("basicStat")
    .color("#f00")
    .text("LIVE")
    @w = 25*@p.w
    @h = 2.7*@p.h
    @x = 26.5*@p.w+2
    @y = 1*@p.h+2
  set: (live, maxlive)-> @w= (25*@p.w)/maxlive*live

Crafty.c "BulletReloadBarContainer",
  init: ->
    @p= Crafty.p
    @requires("2D, DOM").css("border", "2px solid black")
    @w = 25*@p.w
    @h = 2.7*@p.h
    @x = 52*@p.w
    @y = 1*@p.h

Crafty.c "BulletReloadBar",
  init: ->
    @requires("basicStat")
    .color("#0f0")
    .text("RELOAD")
    @w = 25*@p.w-2
    @h = 2.7*@p.h
    @x = 52*@p.w+2
    @y = 1*@p.h+2
  set: (reloaded)-> @w= (25*@p.w)/100*reloaded

Crafty.c "LevelBoardContainer",
  init: ->
    @requires("basicStat").text("LEVEL: ")
    @w = 21*@p.w
    @h = 2.7*@p.h
    @x = 77.5*@p.w+2
    @y = 1*@p.h+2

Crafty.c "LevelBoard",
  init: ->
    @requires("basicStat")
    .color("#ff0").css("border", "2px solid black")
    .text("0").css("text-align", "right")
    @w = 21*@p.w
    @h = 2.7*@p.h
    @x = 77.5*@p.w
    @y = 1*@p.h
    @attach Crafty.e "LevelBoardContainer"

  set: (lvl)-> @text(lvl)

Crafty.c "UpgradeField",
  init: ->
    @p= Crafty.p
    @requires("2D, Canvas, Color, Text")
    .text("UPGRADE HERE").textFont(size: 2.5*@p.h+'px')
    .color("#ff0")
    @w = 11*@p.w
    @h = 5.5*@p.h
    @x = 2*@p.h
    @y = 5*@p.h
    @z = 0


Crafty.c "ShipSpeedBtn",
  init: ->
    @p= Crafty.p
    @requires("2D, DOM, Color, Text, Mouse, statBtn")
    .text("SPEED:  "+parseInt(600/Crafty.Player.stiff))
    .textFont(size: 3*@p.h+'px')
    .color("#eee")
    .css("text-align", "center")
    .bind "Click", ->
      xp = Crafty.Player.xp
      if xp<1 then return 
      xp = Crafty.Player.xp -= 1
      Crafty.Player.stiff *= 0.94
      @text("SPEED:  "+parseInt(600/Crafty.Player.stiff))
      Crafty.pause()
      Crafty.pause()
    @w = 100*@p.w
    @h = 3.5*@p.h
    @x = 0
    @y = 40*@p.h
    @z = 9999

Crafty.c "BltRldBtn",
  init: ->
    @p= Crafty.p
    @requires("2D, DOM, Color, Text, Mouse, statBtn")
    .text("RELOAD:  "+parseInt(600/Crafty.Player.bltReloadTime))
    .textFont(size: 3*@p.h+'px')
    .color("#eee")
    .css("text-align", "center")
    .bind "Click", ->
      xp = Crafty.Player.xp
      c.l xp
      if xp<1 then return 
      xp = Crafty.Player.xp -= 1
      Crafty.Player.bltReloadTime *= 0.96
      @text("RELOAD:  "+parseInt(600/Crafty.Player.bltReloadTime))
      Crafty.pause()
      Crafty.pause()
    @w = 100*@p.w
    @h = 3.5*@p.h
    @x = 0
    @y = 50*@p.h
    @z = 9999

Crafty.c "MaxLiveBtn",
  init: ->
    @p= Crafty.p
    @requires("2D, DOM, Color, Text, Mouse, statBtn")
    .text("MAXLIVE:  "+parseInt(Crafty.Player.maxLive))
    .textFont(size: 3*@p.h+'px')
    .color("#eee")
    .css("text-align", "center")
    .bind "Click", ->
      xp = Crafty.Player.xp
      if xp<1 then return 
      xp = Crafty.Player.xp -= 1
      Crafty.Player.maxLive += 20
      Crafty.liveBar.set(Crafty.Player.live, Crafty.Player.maxLive)
      @text("MAXLIVE:  "+parseInt(Crafty.Player.maxLive))
      Crafty.pause()
      Crafty.pause()
    @w = 100*@p.w
    @h = 3.5*@p.h
    @x = 0
    @y = 60*@p.h
    @z = 9999

Crafty.c "AddLiveBtn",
  init: ->
    @p= Crafty.p
    @requires("2D, DOM, Color, Text, Mouse, statBtn")
    .text("ADDLIVE:  "+(Crafty.Player.live))
    .textFont(size: 3*@p.h+'px')
    .color("#eee")
    .css("text-align", "center")
    .bind "Click", ->
      xp = Crafty.Player.xp
      if xp>0&&(Crafty.Player.live+40)<=Crafty.Player.maxLive
          xp = Crafty.Player.xp -= 1
          Crafty.Player.live += 40
          Crafty.liveBar.set(Crafty.Player.live, Crafty.Player.maxLive)
          @text("ADDLIVE:  "+(Crafty.Player.live))
          Crafty.pause()
          Crafty.pause()
    @w = 100*@p.w
    @h = 3.5*@p.h
    @x = 0
    @y = 70*@p.h
    @z = 9999

Crafty.c "ExitBtn",
  init: ->
    @p= Crafty.p
    @requires("2D, DOM, Color, Text, Mouse, statBtn")
    .text("EXIT")
    .textFont(size: 3*@p.h+'px')
    .color("#eee")
    .css("text-align", "center")
    .bind "Click", ->
      es = Crafty("statBtn").get()
      for e in es then e.destroy()
      Crafty.pause()
    @w = 100*@p.w
    @h = 3.5*@p.h
    @x = 0
    @y = 80*@p.h
    @z = 9999