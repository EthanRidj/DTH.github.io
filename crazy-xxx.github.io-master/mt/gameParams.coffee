local = !top.location.hostname

gameParamsDefaults =
  error: false
  numberOfPairs: gxs.length
  onWrongAnswer: 'restart'

parseQueryParams = ->
  _.object(
    _.map(
      top.location.search.substr(1).split(/&/),
      (kv) -> kv.split(/=/)))

gameParamsInitialState = ->
  _.assign(
    {},
    gameParamsDefaults,
    JSON.parse(window.localStorage?.gameParamsMT || "{}"),
    parseQueryParams())

isGtZero = (val) ->
  _.isFinite(val) and +val > 0

gameParamValid = (prop, val, state) ->
  if prop == 'random'
    return false unless isGtZero(state.min) and isGtZero(state.max)
  else
    return false unless isGtZero(val)
  if prop == 'min'
    +val <= +state.max
  else if prop == 'max'
    +val >= +state.min
  else if prop == 'random'
    +state.min <= +state.max
  else
    true

saveDup = (objs...) ->
  newState = dup(objs...)
  window.localStorage?.gameParamsMT = JSON.stringify(newState)
  newState

gameParams = (state = gameParamsInitialState(), action) ->
  switch action.type
    when 'numberOfPairsChanged'
      saveDup(state, numberOfPairs: action.value)
    when 'onWrongAnswerChanged'
      saveDup(state, onWrongAnswer: action.value)
    else
      state
