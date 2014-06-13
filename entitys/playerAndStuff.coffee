Crafty.c "Player",
  init: ->
    #-----STATS-----#
    @score = 0
    @level = 0
    @nextLevel = 20
    @live = 40
    @maxLive = 40
    @xp = 15
    #---------------#
    @p = Crafty.p
    @t = 0
    @upgradeCnt = 0
    @bltReloadTime = 22
    @shootEnable = false
    @stiff = 25
    @movX = 0
    @movY = 0
    @targetX = Crafty.viewport._width/8
    @targetY = Crafty.viewport._height/2
    @requires("2D, Base, Collision, Mouse, Canvas, Color, Multiway")
    .origin("center")
    #.bind("Click", (e)-> alert e)
    .color("#f00")
    .multiway({W: -90, S: 90, D: 0, A: 180})
    .onHit("UpgradeField", (e) ->
      @upgradeCnt++
      if @upgradeCnt>50
        @upgradeCnt=0
        Crafty.pause()
        Crafty.e "ShipSpeedBtn"
        Crafty.e "BltRldBtn"
        Crafty.e "MaxLiveBtn"
        Crafty.e "AddLiveBtn"
        Crafty.e "ExitBtn"
    ).onHit("Enemy", (e)->
        len = e.length
        while len--
          trg = e[len].obj
          @live -= 10
          Crafty.liveBar.set @live, @maxLive
          trg.destroy()
          if @live<0
            @destroy()
            opts =
              duration: 1300
              liveSpan: 1300
              startColour: [255,0,0,0.6]
            Crafty.makeParticle @_x, @_y, opts
    ).bind("EnterFrame", ->
      if @t>@bltReloadTime
        if@shootEnable==true then @makeBullet()
      else
        Crafty.bltRldBar.set 100/@bltReloadTime*@t
        @t++
      @startSwarm()
      diffX= @targetX-@x-@w/2
      diffY= @targetY-@y-@w/2
      @x += diffX/@stiff
      @y += diffY/@stiff

    ).bind "Remove", ->
      snd.play(0, "musikDeath", "0noEndTIme", "noReset")
      snd.fadeTo(0, "f0", 20)
  makeBullet: ()->
    @t=0
    size = 1*((@p.h+@p.w)/2)#*(bullets+1)
    Crafty.e("Bullet").attr
      speed: 10
      w: size, h: size
      x: @.x+@.w-size/2
      y: @.y+@.h/2-size/2
      z: 999


Crafty.c "Bullet",
  init: ->
    @speed = 10
    @damage = 1
    #@vel = 1 # 1 is no speedUP 
    #@stiff = 1 # 1 is no speedDown
    @requires("2D, Canvas, Color")
      .color("black")
      .bind("EnterFrame", ->
        if @_x>Crafty.viewport.width+@w then @destroy()
        #@speed = @speed / @vel * @stiff
        @x += @speed
      )