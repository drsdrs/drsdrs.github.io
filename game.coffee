
scoreEl = document.getElementById("inGameScore")
levelEl = document.getElementById("inGameLevel")

upgradeViewEl = $("#upgradePlayer")

particleOptions =
  maxParticles: 128
  size: 4
  sizeRandom: 8
  speed: 0
  speedRandom: 1
  #lifeSpan: 8
  #lifeSpanRandom: 8
  angle: 90
  angleRandom: 360
  #startColour: [ 0, 255, 0, 1 ]
  #startColourRandom: [255, 0, 0, 1]
  endColour: [ 255, 255, 255, 0 ]
  #endColourRandom: [ 32, 0, 0, 0 ]
  #spread: 8
  duration: -1
  fastMode: true
  gravity: x: -1, y: 0
  #jitter: 0

Crafty.makeParticle = (x, y, options)->
  newOptions = particleOptions
  if options? then for key, value of options then newOptions[key] = value
  livetime = newOptions.duration
  Crafty.e("2D, Canvas, Particles")
    .particles(newOptions)
    .attr x:x, y:y, t:0
    .bind("EnterFrame", ->
      if livetime>0
        @t++
        if @t>livetime+newOptions.lifeSpanRandom then @destroy())

Crafty.addScore = (score)->
  score = score+Crafty.Player.score
  Crafty.Player.score = score
  Crafty.scoreBoard.set(score)

  nxtLvl = Crafty.Player.nextLevel
  lvl = Crafty.Player.level
  if lvl>0
    lvlDiff= nxtLvl-nxtLvl*0.5
    scoreDiff = score-nxtLvl*0.5
  else
    lvlDiff= nxtLvl
    scoreDiff = score
  if score>nxtLvl
    Crafty.Player.level++
    snd.play(1, "fx1", 500, true)
    Crafty.levelBoard.set Crafty.Player.level
    Crafty.Player.xp += 1
    Crafty.Player.nextLevel *= 1.5
    #nextLevelBar.style.width = 0
  else
    #nextLevelBar.style.width = 100/(lvlDiff)*(scoreDiff)+"%"

Crafty.initEnemys= (lvl)->
  lvl = lvl
  levelEnemys= [
    [ "EnemyRock", "EnemyZ", "EnemyUpDown", "EnemyBackAttack" ]
    [ "EnemyUpDown", "EnemyBackAttack", "EnemyCircle", "EnemySquirlyS" ]
    [ "EnemyCircle", "EnemyRock", "EnemySquirlyS", "EnemyJumper" ]
  ]
  chanceEnemys= [
    [0, 0.5, 0.8, 0.9]
    [0, 0.5, 0.8, 0.9]
    [0, 0.5, 0.8, 0.9]
  ]
  WAVE= [
    "nop"
    [ 0 ], [ 1 ]
    "random"
    "nop"
    [ 0, 2 ], [ 1, 2 ]
    "random"
    "nop"
    [ 0, 1, 3 ], [ 1, 2, 3 ],
    "boss"
    "random"
    "nop"


  ]
  while WAVE.length>1
    wave = WAVE.shift()
    if wave is "boss" then @enemyStack.push "BOSS_"+lvl%3
    else if wave is "nop" then emptyOnes = 5; while emptyOnes-- then @enemyStack.push ""
    else if wave is "random"
      cnt = 10+lvl*3
      while cnt-- 
        rnd = Math.random()
        if rnd>chanceEnemys[lvl][3] then @enemyStack.push levelEnemys[lvl][3]
        else if rnd>chanceEnemys[lvl][2] then @enemyStack.push levelEnemys[lvl][2]
        else if rnd>chanceEnemys[lvl][1] then @enemyStack.push levelEnemys[lvl][1]
        else @enemyStack.push levelEnemys[lvl][0]
    else # straight wave
      for e in wave
        cnt = 10+lvl*3
        while cnt-- then @enemyStack.push levelEnemys[lvl][e]

# Game scene
# -------------
# Runs the core gameplay loop
Crafty.scene "Level1", ->
  @time = 0
  @enemyStack = []
  @Player = Crafty.e("Player")
    .attr(
      x: Crafty.viewport._width+100
      y: Crafty.viewport._height/2-(3*@p.h/2)
      w: 6.5*@p.w, h: 5*@p.h, z: 900
    )
  Crafty.e "statsBg"
  Crafty.e "LiveBarContainer"
  Crafty.e "BulletReloadBarContainer"
  Crafty.e "UpgradeField"

  @liveBar = Crafty.e "LiveBar"
  @bltRldBar = Crafty.e "BulletReloadBar"
  @scoreBoard = Crafty.e "ScoreBoard"
  @levelBoard = Crafty.e "LevelBoard"



  @Player.startSwarm= ()->
    Crafty.time += 1
    if Crafty.time%22==0 && Crafty.enemyStack?
      enemy = Crafty.enemyStack.shift()
      if enemy? && enemy isnt "" then Crafty.e( enemy )

Crafty.Game =
  start: ->
    Crafty.init()
    Crafty.canvas.init()
    Crafty.p = w: window.innerWidth/100, h: window.innerHeight/100
    Crafty.p.d = (Crafty.p.w+Crafty.p.h)/2
    Crafty.background "rgb(186, 190, 136)"
    Crafty.scene 'Level1'
    #snd.fadeTo(0, "landDefault", 10 )
    Crafty.initEnemys(0)

    #Crafty.e "BOSS_3"
    #snd.play(0, "landDefault", false, false)

    mousePos = {x: 0, y: 0}

    pl = Crafty.Player
    timerId = 0
    
    shipSpeed = 0
    shipMaxLive = 0
    shipSize = 0

    bullets = 0
    bulletSpeed = 0
    bulletInterval = 0
    bulletPower = 0

    mouseMove = (e)->
      mousePos = {x: e.pageX, y: e.pageY}
      pl.targetX = e.pageX
      pl.targetY = e.pageY

    upgradePlayer = ->
      pl = Crafty.Player
      Crafty.pause()

  
    Crafty.stage.elem.addEventListener "mousedown", -> Crafty.Player.shootEnable = true
    Crafty.stage.elem.addEventListener "mousemove", mouseMove
    Crafty.stage.elem.addEventListener "dragmove", mouseMove

    Crafty.stage.elem.addEventListener "mouseup", ->
      dragActive = false
      Crafty.Player.shootEnable = false

