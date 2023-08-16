{ a, button, div, h1, h2, h3, input, label, p } = React.DOM
el = React.createElement

row = (optsOrContent, maybeContent) ->
  if maybeContent
    content = maybeContent
    opts = optsOrContent
  else
    content = optsOrContent
    opts = {}
  div key: opts.key, className: 'row', style: {marginTop: 20, marginBottom: opts.marginBottom}, content

fullRow = (optsOrContent, maybeContent) ->
  if maybeContent
    content = maybeContent
    opts = optsOrContent
  else
    content = optsOrContent
    opts = {}
  row(opts,
    div(className: "col-xs-12 #{opts.additionalClass}", content))

Panel = React.createClass
  getDefaultProps: ->
    panelClass: 'panel-default'

  render: ->
    panelClass = 'panel ' + if _.isUndefined(@props.primaryPanel)
      @props.panelClass
    else
      if @props.primaryPanel then 'panel-primary' else 'panel-default'
    div className: panelClass,
      if @props.heading
        div className: 'panel-heading',
          h3 className: 'panel-title', @props.heading
      div className: 'panel-body', @props.body

TimerButton = React.createClass
  getInitialState: ->
    countdown: undefined
    timer: undefined
    done: false

  startTimer: ->
    @setState(countdown: 3)
    @interval = setInterval @timerCallback, 1000

  timerCallback: ->
    if @state.countdown > 0
      @props.speak(if 3 == @state.countdown then "Ready in #{@state.countdown}" else ""+@state.countdown)
      @setState(countdown: @state.countdown - 1, timer: @props.seconds)
    else if @state.timer > 0
      @props.speak('Hold it!') if @state.timer == @props.seconds
      @setState(timer: @state.timer - 1, done: 1 == @state.timer)
    else if @state.timer == 0
      @props.speak('Done.')
      clearInterval @interval
      @interval = 0

  componentWillUnmount: ->
    clearInterval @interval if @interval

  render: ->
    if @state.countdown
      p className: 'lead', "Ready in #{@state.countdown}..."
    else if @state.timer
      p className: 'lead', "Hold it! #{@state.timer}..."
    else if @state.done
      p className: 'lead', "Done. If you couldn't make it, try again and hold it as long as you can this time."
    else
      button className: "btn btn-warning btn-lg", onClick: @startTimer, style: {marginRight: 20}, 'Start timer'

Spit = [ 'Take all that spit and grease it on your dick and balls',
         'Sit down, drool the spit and try to take it back to your mouth without using your hands. A little tip: Image you are drinking with your straw',
         'Get on your back with your neck on the border of your bed, drool the spit and try to take it back to your mouth without using your hands. A little tip: Image you are drinking with your straw',
         'Get on your back with your neck on the border of your bed and spit it all over your face',
         'Get on your back with your neck on the border of your bed and spit it all over your face, make sure you get some spit into your eyes',
         'Take some spit and drool it on your open eyes with your hand', ]

Fuck = [ 'Fuck your mouth with your dildo, let it touch the back of your throat 10 times, fast, after that swallow your dildo and hold it for 3 seconds. Do this 3 times in a row without a break',
         'Fuck your mouth with your dildo, let it touch the back of your throat 10 times, fast, after that swallow your dildo and hold it for 5 seconds. Do this 3 times in a row without a break',
         'Fuck your mouth with your dildo, let it touch the back of your throat 15 times, fast, after that swallow your dildo and hold it for 8 seconds. Do this 5 times in a row without a break',
         'Fuck your mouth with your dildo, let it touch the back of your throat 15 times, fast, after that swallow your dildo and hold it for 10 seconds. Do this 7 times in a row without a break',
         'Fuck your mouth with your dildo, let it touch the back of your throat 20 times, fast, after that swallow your dildo and hold it for 10 seconds. Do this 10 times in a row without a break',
         'Ouch, get ready to get throated like a bitch. Fuck your mouth with your dildo, let it touch the back of your throat 5 times, fast, after that swallow your dildo and hold it for 15 seconds. Do this 20 times in a row without a break',]


Game = React.createClass
  getInitialState: ->
    position: @randomPosition()
    nextTask: 0
    tasks: []

  randomPosition: ->
    _.sample(['On the floor, kneeling', 'On the floor, ass on the ground between your legs', 'Neck on border of your bed', 'Sitting in the bathtub', 'Standing'])

  Tasks: [
    #th1
    [
      #0
      [ 'Lick on it',
        'Gag on it 5 times',
        'Gag on it 10 times',
        'Swallow it down your throat 5 times',
        'Swallow it down your throat 10 times',
        'Gag on it 15 times, then swallow it down your throat 15 times'],
      #1
      [ 'Very slowly, go deeper and deeper',
        'Push it down your throat and leave it there for 3 seconds.',
        'Push it down your throat and leave it there for 6 seconds.',
        'Push it in as fast as you can and leave it there for 10 seconds',
        'Push it in as fast as you can and leave it there for 15 seconds',
        'Push it into your throat and out as fast you can 3 times, repeat it 5 times',],
      #2
      [],
      #3
      [ 'Play with your spit with both hands',
        'I want to see your face full of spit',
        'Take all that spit and grease it on your belly, tits and face',
        'Get all that spit back into your dirty mouth, after that back into the bowl, slowly',
        'Gather all the spit in your hands, then suck it back into your mouth',
        'Get all that spit back into your dirty mouth and swallow it',],],
    #th2
    [
      #0
      [ 'Lick on it',
        'Gag on it 5 times',
        'Gag on it 10 times',
        'Swallow it down your throat 5 times',
        'Swallow it down your throat 10 times',
        'Gag on it 15 times, then swallow it down your throat 15 times'],
      #1
      [ 'Very slowly, go deeper and deeper',
        'Push it down your throat and leave it there for 3 seconds.',
        'Push it down your throat and leave it there for 6 seconds.',
        'Push it in as fast as you can and leave it there for 10 seconds',
        'Push it in as fast as you can and leave it there for 15 seconds',
        'Push it into your throat and out as fast you can 3 times, repeat it 5 times',],
      #2
      Spit,
      #3
      [],
      #4
      Fuck,
      #5
      Spit,
      #6
      Fuck,
      #7
      Spit,
    ]

  ]

  tasks: ->
    @Tasks[@props.mode - 1]

  randomTask: (num) ->
    tasks = @tasks()[num]
    l = tasks.length - 1
    tasks[@withDifficulty -> _.random(l)]

  withDifficulty: (fun) ->
    switch @props.difficulty
      when 'light'
        _.min([fun(), fun()])
      when 'hardcore'
        _.max([fun(), fun()])
      else
        fun()

  d16: ->
    @withDifficulty -> _.random(1, 6)

  timerTask: ->
    d3 = @d16()
    secs = 0
    secs += @d16() while d3--
    secs

  speak: (task) ->
    # msg = new SpeechSynthesisUtterance(task);
    # msg.rate = 0.8
    # msg.voice = window.speechSynthesis.getVoices()[2]
    # window.speechSynthesis.speak(msg);
    responsiveVoice.speak(task, "UK English Female", rate: 1) if @props.speechEnabled

  deepthroatingTaskNum: ->
    if @props.mode == 1 then 2 else 3

  getNextTask: ->
    timerTask = @state.nextTask == @deepthroatingTaskNum()
    task = if timerTask
      "Hold your dildo in your throat for #{@timerTask()} seconds."
    else
      @randomTask(@state.nextTask)
    secs = +m[1] if @state.nextTask < 4 and m = task.match(/(\d+) seconds/)
    @speak(task)
    @setState(
      nextTask: 1 + @state.nextTask,
      tasks: [task].concat(@state.tasks),
      timerSecs: secs)

  render: ->
    if 0 == @state.nextTask
      _.defer -> $("html, body").animate(scrollTop: $(document).height())
    div {},
      @renderButton()
      @renderTasks()
      @renderPosition()

  renderPosition: ->
    el Panel, primaryPanel: 0 == @state.nextTask, heading: 'Position', body: @state.position

  Headings: [
    #th1
    ['Just a bit of warm up...', "Horny, aren't you? Now insert the dildo into your throat:", "Deepthroating time!", "Let's play with your spit now..."],
    #th2
    [ 'Just a bit of warm up...',
      "Horny, aren't you? Now insert the dildo into your throat:",
      "Let's play with your spit now...",
      "Deepthroating time!",
      "Let's fuck that troat now...",
      "Let's play with your spit again!",
      "Let's fuck that troat again!",
      "Let's play with your spit one last time!",
      ],
  ]

  headingFor: (n) ->
    "Task #{n} — #{@Headings[@props.mode - 1][n - 1]}"

  renderTasks: ->
    _.map(@state.tasks, (task, i) =>
      n = @state.nextTask - i
      el Panel, key: "task" + n, primaryPanel: 0 == i, heading: @headingFor(n), body: task)

  renderButton: ->
    fullRow(marginBottom: 20,
      if @state.nextTask < @tasks().length
        div className: 'text-center center-block',
          if @state.timerSecs
            el TimerButton, key: 'timer' + @state.nextTask, seconds: @state.timerSecs, speak: @speak
          button className: "btn btn-primary btn-lg", onClick: @getNextTask, 'Get next task'
      else
        button className: "btn btn-success btn-lg center-block", onClick: @props.startAnother, 'Start another game')


TH1Main = React.createClass
  getInitialState: ->
    started: false
    speechEnabled: @isSpeechEnabled()
    difficulty: @initialDifficulty()

  isSpeechEnabled: ->
    window.localStorage?.speechEnabled == 'true'

  initialDifficulty: ->
    if m = top.location.search.match(/[?&]difficulty=([012])/)
      ['light', 'normal', 'hardcore'][+m[1]]
    else if m = top.location.search.match(/[?&]hardcore=1/)
      'hardcore'
    else
      window.localStorage?.difficulty || 'normal'

  startAnother: ->
    @setState started: false

  startGame: (mode) ->
    @setState started: mode

  toggleSpeech: ->
    speechEnabled = not @state.speechEnabled
    window.localStorage?.speechEnabled = speechEnabled
    @setState speechEnabled: speechEnabled

  setDifficulty: (diff) ->
    window.localStorage?.difficulty = diff
    @setState difficulty: diff

  render: ->
    div className: "container",
      @renderHeadline()
      @renderIntroduction()
      if @state.started
        el(Game,
          startAnother: @startAnother,
          speechEnabled: @state.speechEnabled,
          difficulty: @state.difficulty,
          mode: @state.started)
      else
        @renderStartGameButton()
      @renderFooter()

  renderHeadline: ->
    if @state.started
      h1 {}, 'Throat Heaven ' + @state.started
    else
      h2 {}, 'Throat Heaven 1 & 2'

  renderFooter: ->
    div className: 'row', style: {marginTop: 20},
      div className: "col-xs-6",
        label {},
          (input type: 'checkbox', checked: @state.speechEnabled, onChange: @toggleSpeech),
          ' Enable speech  '
        div style: {display: 'inline-block'},
          ' Mode: '
          label {},
            (input type: 'radio', name: 'difficulty', checked: @state.difficulty == 'light', onChange: => @setDifficulty('light')),
            ' Light '
          label {},
            (input type: 'radio', name: 'difficulty', checked: @state.difficulty == 'normal', onChange: => @setDifficulty('normal')),
            ' Normal '
          label {},
            (input type: 'radio', name: 'difficulty', checked: @state.difficulty == 'hardcore', onChange: => @setDifficulty('hardcore')),
            ' Hardcore '
      div className: "col-xs-6",
        p className: 'pull-right text-right lead',
          'Based on '
          a href: 'http://www.getdare.com/bbs/showthread.php?t=176573', target: '_blank',
            'Throat Heaven 1 dare'
          ' and '
          a href: 'http://www.getdare.com/bbs/showthread.php?t=188674', target: '_blank',
            'Throat Heaven 2 dare'

  renderStartGameButton: ->
    fullRow div className: 'text-center center-block',
      button className: "btn btn-primary btn-lg", onClick: (=> @startGame(1)), style: {margin: '20px'}, 'Start Throat Heaven 1'
      button className: "btn btn-primary btn-lg", onClick: (=> @startGame(2)), 'Start Throat Heaven 2'

  renderIntroduction: ->
    el Panel,
      primaryPanel: not @state.started,
      heading: 'Introduction',
      body:
        div {},
          p {}, "Get naked. Grab your doubledildo or something that you can swallow."
          p {}, "Place a bowl under your face. You will create lots of spit, don't swallow it, the bowl has to be full of your spit."
          p {}, "Roll to determine how you must suck the dildo. "

ReactDOM.render(
  el(TH1Main, null),
  document.getElementById('content'))
