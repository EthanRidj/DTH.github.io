NumberSelector = React.createClass
  label: ->
    @props.label || 'Value'

  unit: ->
    if @props.type == 'seconds' then 's' else 'min'

  render: ->
    div(className: "form-group #{'has-error' if @props.hasError}",
      label({}, @label() + ': '),
      div className: 'input-group',
        input type: 'number', className: "form-control", value: @props.value, onChange: @props.onChange, step: 'any', min: 0
        div className: 'input-group-addon', @unit())


MinMaxSelector = React.createClass
  handleChange: (fld, e) ->
    store.dispatch(type: 'changeVal', prop: fld, val: e.target.value)

  render: ->
    span {},
      el(NumberSelector, label: 'Min', value: @props.min, onChange: @handleChange.bind(@, 'min'), hasError: @props.error)
      el(NumberSelector, label: 'Max', value: @props.max, onChange: @handleChange.bind(@, 'max'), hasError: @props.error)


StartSelector = React.createClass
  changeType: (e) ->
    store.dispatch(type: 'changeType', selected: e.target.value)

  handleChange: (e) ->
    store.dispatch(type: 'changeVal', prop: @props.type, val: e.target.value)

  handleCustomize: (e) ->
    e.preventDefault()
    store.dispatch(type: 'customize')

  startGame: (e) ->
    e.preventDefault()
    store.dispatch(type: 'startGame') unless @props.error

  render: ->
    div {},
      p className: "lead",
        'The game is not started yet. Select training time and press Start.'
      form className: "form-inline", onSubmit: @startGame,
        div(className: "form-group",
          label({}, 'Time: '),
          select className: "form-control", defaultValue: @props.type, onChange: @changeType, style: {width: 'auto'},
            option(value: 'random',  'Random time'),
            option(value: 'minutes', 'Minutes'),
            option(value: 'seconds', 'Seconds'))

        if 'random' == @props.type
          el(MinMaxSelector, @props)
        else
          el(NumberSelector, type: @props.type, value: @props[@props.type], onChange: @handleChange, hasError: @props.error)

        br {}
        div className: "form-group",
          label {},
            (input type: 'checkbox', checked: @props.speechEnabled, onChange: -> store.dispatch(type: 'toggleSpeech')),
            ' Enable speech  '

        if @props.speechEnabled
          div className: "form-group",
            label {},
              (input type: 'checkbox', checked: @props.tellTime, onChange: -> store.dispatch(type: 'toggleTellTime')),
              ' Include task duration  '

        # br {}
        # div className: "form-group",
        #   label({}, 'Custom tasks: '),
        #   input type: 'url', className: "form-control"

        br {}
        button type: "submit", className: "btn btn-primary btn-lg", disabled: @props.error, 'Start training'
