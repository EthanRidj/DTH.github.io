gameInitialState =
  started: false
  tasks: []
  elapsed: 0

game = (state = gameInitialState, action) ->
  switch action.type
    when 'startGame'
      dup(state, started: true, target: calculateTargetTime())
    when 'startCountdown'
      dup(state, countdown: 2)
    when 'decreaseCountdown'
      dup(state, countdown: state.countdown - 1, running: state.countdown == 1)
    when 'nextTask'
      elapsed = _.reduce(state.tasks, ((sum, task) -> sum + task.elapsed), 0)
      if elapsed < state.target
        task = generateTask(state.tasks[0], state.target, elapsed)
        tellTask(task)
        dup(state, tasks: [task].concat(state.tasks), elapsed: elapsed)
      else
        dup(state, finished: true, running: false, elapsed: elapsed)
    when 'decreaseTask'
      [task, rest...] = state.tasks
      task = dup(task, time: task.time - 1)
      dup(state, tasks: [task].concat(rest))
    when 'startAnother'
      gameInitialState
    else
      state

tellTask = (task) ->
  speak(
    if store.getState().gameParams.tellTime
      "#{task.desc} for #{task.time} seconds"
    else
      task.desc)

wait = 0
timer = ->
  game = store.getState().game
  return unless game.started
  if game.countdown and (not responsiveVoice.isPlaying() or wait++ > 1) # kludge to avoid missing countdown
    wait = 0
    store.dispatch(type: 'decreaseCountdown')
  else if game.running
    if 0 == game.tasks.length or 0 == game.tasks[0].time
      store.dispatch(type: 'nextTask')
    else
      store.dispatch(type: 'decreaseTask')

setInterval(timer, 1000)
