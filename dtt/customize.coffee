customizeInitialState =
  customize: false

customize = (state = customizeInitialState, action) ->
  console.log 'customize', state, action
  switch action.type
    when 'customize'
      dup(state, customize: true)
    else
      state
