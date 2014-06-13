p = Crafty.p

Crafty.c "Enemy",
  init: ->
    #@colors = ["#1F8FFF","#211FFF","#FF2A1F","#FF6B1F","#E0FF1F","#41FF1F"]
    @live= 1
    @t= 0
    @speedX = 3*Math.random()+1.25
    @y = @Y =  Math.random()*(Crafty.viewport.height-50) + 50
    @W = Crafty.p.d*10
    @COLOR= "#1F8FFF"
    @requires("2D, Collision, Canvas, Color")
      .origin("center")
      .color(@COLOR)
      .bind "EnterFrame", -> 
        @moveIt()
    @moveIt= ->
      @t+=@speedX
      @w=@h = @W+Math.sin((@t)/96)*48
      @x -= @speedX+Math.sin((@t)/80)
      @y = @Y-@w/2
      if @x < -@w then @destroy()
      #@y += 10
    @Y= @y= Crafty.viewport.height*Math.random()
    @x= Crafty.viewport.width + 50
  bulletHit: -> @.onHit "Bullet", (e)->
    if @live>0
      snd.play(1, "fx4", 200, true)
      for i, trg of e
        damage = trg.obj.damage
        @live -= damage
        Crafty.addScore ~~(damage*3.3)
        trg.obj.destroy() if @lvl>4
    else
      opts =
        duration: 10
        speed: 2
        liveSpan: 8
        startColour: @colorArr
        spread: @w
      Crafty.makeParticle @_x, @_y, opts
      @destroy()
      snd.play(1, "fx3", 200, true)
    @
  getColArr: ->
    col= @color().split("#").pop()
    @colorArr= [
        parseInt(col.slice(0,2), 16)
        parseInt(col.slice(2,4), 16)
        parseInt(col.slice(4,6), 16)
        0.9
      ]
    @

Crafty.c "EnemyRock",
  init: ->
    @requires("Enemy")
    @size = Math.round(Math.random()*2)+1
    colcode = (12-@size*2).toString(16)
    @live = 100
    @color("#"+colcode+colcode+colcode).getColArr()
    @speed = 4/@size
    @w = @h = 20*@size
    @Y= @y = Crafty.viewport.height*Math.random()
    @x = Crafty.viewport.width + 50
    @moveIt= -> @x -= @speed
    @onHit "Bullet", (e)->
      snd.play(1, "fx4", 200, true)
      for i, trg of e
        e[0].obj.destroy()

Crafty.c "EnemyZ",
  init: ->
    @requires("Enemy").getColArr().bulletHit()
    @w = @h = Crafty.p.d*10
    @live = 4


Crafty.c "EnemyUpDown",
  init: ->
    @requires("Enemy")
    @color("#E0FF1F").getColArr().bulletHit()
    @swingY = 100
    @Y= @y = Crafty.viewport.height*Math.random()
    @x = Crafty.viewport.width + 50
    @moveIt= ->
      @t+=@speedX
      @x -= @speedX
      add= (Math.sin(@t/60)*(@swingY))
      @y = @Y+add
      if @x < -@w then @destroy()

Crafty.c "EnemyCircle",
  init: ->
    @requires("Enemy")
    @live = 3
    @color("#211FFF").getColArr().bulletHit()
    @Y= @y = Crafty.viewport.height*Math.random()
    @x = Crafty.viewport.width + 50
    @w=@h = Crafty.p.d*5.5
    @moveIt= ->
      @t+=@speedX
      @x -= @speedX-Math.sin(180+(@t)/60)*5
      @y += Math.sin((@t)/60)*5
      if @x < -@w then @destroy()   

Crafty.c "EnemyBackAttack",
  init: ->
    @requires("Enemy")
    @color("#FF2A1F").getColArr().bulletHit()
    @Y= @y = Crafty.viewport.height*Math.random()
    @x = Crafty.viewport.width + 50
    @w=@h = Crafty.p.d*4
    @moveIt= ->
      @t+=@speedX
      @x = @x-@speedX-((1-(@t&1023)/400)*7)
      #@y = @y+((1-(@t&1023)/512)*4)
      if @x < -@w then @destroy()

Crafty.c "EnemySquirlyS",
  init: ->
    @requires("Enemy")
    @color("#41FF1F").getColArr().bulletHit()
    @Y= @y = Crafty.viewport.height*Math.random()
    @x = Crafty.viewport.width + 50
    @mH = 100
    @w=@h = Crafty.p.d*6
    @moveIt= ->
      @t+=@speedX
      @x -= 2-Math.sin(180+(@t)/60)*5
      @y += Math.sin((@t)/30)*10
      if @x < -@w then @destroy() 

Crafty.c "EnemyJumper",
  init: ->
    @requires("Enemy")
    @color("#FF6B1F")
    @getColArr().bulletHit()
    @x= Crafty.viewport.width + 50
    @w=@h = Crafty.p.d*5
    @Y= @y= Crafty.viewport.height-@w
    @jh = ((@Y/1.5)*Math.random()+(@Y/3))/66
    @moveIt= ->
      @t+=@speedX
      @x -= @speedX
      @y -= @speedX*((127-(@t)%255)/127)*@jh
      if @x < -@w then @destroy()

Crafty.c "BOSS_1",
  init: ->
    @requires("Enemy")
    @color("#f00").getColArr()
    @live = 5
    @speedX = 5
    @Y= @y= (Crafty.viewport.height-100)/2
    @x= Crafty.viewport.width + 50
    @w=@h = Crafty.p.d*20
    @onHit "Bullet", (e)-> 
      @live-=e[0].obj.damage
      e[0].obj.destroy()
      if @live<0
        Crafty.addScore 1000
        Crafty.initEnemys(2)
        @destroy()
        opts =
          duration: 58
          speed: 6
          maxParticles: 528
          startColour: [255,0,0,1]
          spread: @w/2
          gravity: x: 0, y: 0
          lifeSpanRandom: 48
        Crafty.makeParticle @x+@w/2, @y+@w/2, opts
    @moveIt= ->
      @t+=1
      @y = @Y+(Math.sin(@t/20)*300)
      if @x>Crafty.viewport.width/2
        @x -= @speedX
        @speedX*=0.993
      else if @t%15 is 0
          Crafty.e("EnemyBackAttack")
            .attr x:@x, y:@y+@w/2, speed:4.2

Crafty.c "boss1Hand",
  init: ->
    @requires("Enemy").color("#ff0")
    @live = 6
    @bulletHit()
    @X = Crafty.viewport.width*0.666
    @Y = @y
    @speedY = 0
    @mW = Crafty.viewport.width*0.333
    @w = @h = 20
    @onHit "Bullet", (e)-> for i, trg of e then trg.obj.destroy()
    @moveIt= ->
      @t+=1
      @x = @X-(Math.cos(3+(@t/@speedX))*@mW)-@mW
      @y += (Math.sin(@t/@speedX)*3)*@speedY

Crafty.c "BOSS_0",
  init: ->
    @requires("Enemy")
    @color("#ff0")
    @getColArr()
    @live = 5
    @speedX = 5
    @Y= @y= (Crafty.viewport.height-100)/2
    @x= Crafty.viewport.width + 50
    @intro = false
    @w=@h = Crafty.p.d*20
    @onHit "Bullet", (e)-> for i, trg of e
      @live-=e[0].obj.damage
      e[0].obj.destroy()
      if @live<0
        Crafty.addScore 1000
        Crafty.initEnemys(1)
        @destroy()
        opts =
          duration: 58
          speed: 6
          maxParticles: 528
          startColour: [255,255,0,1]
          spread: @w/2
          gravity: x: 0, y: 0
          lifeSpanRandom: 48
        Crafty.makeParticle @x+@w/2, @y+@w/2, opts
    @moveIt= ->
      @t+=1
      @y = @Y+(Math.sin(@t/80)*150)
      if @x>Crafty.viewport.width*0.666
        @x -= @speedX
        @speedX*=0.993
      else if @intro==false
        @intro = true
        speed = 50
        @attach Crafty.e("boss1Hand").attr speedY:-0.5, speedX:speed, x:@x+@w, y:@y
        @attach Crafty.e("boss1Hand").attr speedY:-0.2, speedX:speed-1, x:@x+@w, y:@y+20
        @attach Crafty.e("boss1Hand").attr speedY:-0.1, speedX:speed-2, x:@x+@w, y:@y+40
        @attach Crafty.e("boss1Hand").attr speedY:-0.07, speedX:speed-3, x:@x+@w, y:@y+60
        @attach Crafty.e("boss1Hand").attr speedY: 0.0, speedX:speed-4, x:@x+@w, y:@y+80
        @attach Crafty.e("boss1Hand").attr speedY:0.07, speedX:speed-3, x:@x+@w, y:@y+100
        @attach Crafty.e("boss1Hand").attr speedY:0.1, speedX:speed-2, x:@x+@w, y:@y+120
        @attach Crafty.e("boss1Hand").attr speedY:0.2, speedX:speed-1, x:@x+@w, y:@y+140
        @attach Crafty.e("boss1Hand").attr speedY:0.5, speedX:speed, x:@x+@w, y:@y+160

Crafty.c "BOSS_2",
  init: ->
    @requires("Enemy")
    @color("#00f").getColArr()
    @live = 5
    @speedX = 5
    @Y= @y= (Crafty.viewport.height-100)/2
    @x= Crafty.viewport.width + 50
    @w=@h = Crafty.p.d*20
    @onHit "Bullet", (e)-> 
      @live-=e[0].obj.damage
      e[0].obj.destroy()
      if @live<0
        Crafty.addScore 1000
        Crafty.initEnemys(3)
        @destroy()
        opts =
          duration: 58
          speed: 6
          maxParticles: 528
          startColour: [0,0,255,1]
          spread: @w/2
          gravity: x: 0, y: 0
          lifeSpanRandom: 48
        Crafty.makeParticle @x+@w/2, @y+@w/2, opts
    @moveIt= ->
      @t+=1
      @y = @Y+(Math.sin(@t/20)*300)
      if @x>Crafty.viewport.width/2
        @x -= @speedX
        @speedX*=0.993
      else if @t%15 is 0
          Crafty.e("EnemyBackAttack")
            .attr x:@x, y:@y+@w/2, speed:4.2        