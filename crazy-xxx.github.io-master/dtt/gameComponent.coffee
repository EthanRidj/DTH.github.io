Game = React.createClass
  startCountdown: ->
    store.dispatch(type: 'startCountdown')

  startAnother: ->
    store.dispatch(type: 'startAnother')

  render: ->
    div {},
      @renderFinished() if @props.finished
      @renderProgress() if @props.tasks.length
      @renderTasks()
      unless @props.running or @props.countdown or @props.tasks.length
        button type: "submit", className: "btn btn-primary btn-lg center-block", onClick: @startCountdown, 'Click here when ready'

  countDownText: ->
    if @props.countdown or 0 == @props.countdown and not @props.tasks.length
      cntdown = 1 + @props.countdown
      speak(if 3 == cntdown then "Ready in #{cntdown}" else ""+cntdown)
      "Ready in #{cntdown}..."
    else
      speak('Get ready...')

  taskDesc: (task) ->
    "#{task.desc} (#{task.elapsed}s)" # #{task.diff}"

  renderTasks: ->
    [task, tasks...] = @props.tasks
    if task
      div className: 'panel panel-primary',
        @renderHeading('Remaining time: ' + task.time)
        div className: 'panel-body',
          p className: 'lead',
            strong {}, @taskDesc(task)
        ul className: 'list-group',
          _.map tasks, (task) =>
            li className: 'list-group-item text-muted', @taskDesc(task)
    else
      div className: 'panel panel-primary',
        @renderHeading(@countDownText())

  renderHeading: (heading) ->
    rightEl = if $('body').width() < 400 then small else span
    div className: 'panel-heading',
      h3 className: 'panel-title',
        heading
        rightEl className: 'pull-right',
          "Target: " + @props.target + ", Elapsed: " + @props.elapsed

  renderFinished: ->
    div className: 'jumbotron',
      p {},
        speak("Congratulations! You completed #{formatTime(@props.elapsed)} of training!")
      button className: "btn btn-success btn-lg ", style: {marginBottom: 20}, onClick: @startAnother, 'Start another training'

  renderProgress: ->
    tasks = @props.tasks.map (task) =>
      percent = task.elapsed / @props.target * 100
      type = ['success', 'info', 'warning', 'danger'][task.diff]
      div {
        className: "progress-bar progress-bar-#{type} progress-bar-striped active"
        role: "progressbar"
        style: {width: "#{percent}%"}}
    tasks.reverse()
    div className: 'progress', tasks

pluralize = (num, singular, plural = singular + 's') ->
  switch num
    when 0
      ""
    when 1
      "1 #{singular}"
    else
      "#{num} #{plural}"

formatTime = (seconds) ->
  minutes = Math.floor(seconds / 60)
  m$ = pluralize(minutes, "minute")
  seconds = seconds % 60
  s$ = pluralize(seconds, "second")
  "#{m$} #{s$}".trim()

assertEqual = (expected, actual) ->
  throw new Error("Expected: <#{expected}> but got: <#{actual}>") if expected != actual

testFormatTime = ->
  assertEqual("",                      formatTime(0))
  assertEqual("1 second",              formatTime(1))
  assertEqual("2 seconds",             formatTime(2))
  assertEqual("59 seconds",            formatTime(59))
  assertEqual("1 minute",              formatTime(60))
  assertEqual("1 minute 1 second",     formatTime(61))
  assertEqual("1 minute 2 seconds",    formatTime(62))
  assertEqual("1 minute 59 seconds",   formatTime(119))
  assertEqual("2 minutes",             formatTime(120))
  assertEqual("2 minutes 1 second",    formatTime(121))
  assertEqual("2 minutes 2 seconds",   formatTime(122))
  assertEqual("2 minutes 59 seconds",  formatTime(179))
  assertEqual("10 minutes",            formatTime(600))
  assertEqual("10 minutes 1 second",   formatTime(601))
  assertEqual("10 minutes 2 seconds",  formatTime(602))
  assertEqual("10 minutes 59 seconds", formatTime(659))
  console.log('All systems functional.')
