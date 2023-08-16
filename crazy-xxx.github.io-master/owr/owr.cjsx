# TODO:
# √ mobile responsive
# √ start new game
# √ ga
# √ a from param
# √ save defaults
# - quick (gags instead of long sucking?)
# - restore original tasks

d = -> _.random(9)
d19 = -> _.random(1, 9)

Duties = [
  '[Choose 2 but only charge for cheaper one]',
  'Suck for 5min',
  'Suck for 10min',
  'Suck for 5min, deepthroat every 30s',
  'Deepthroat 20x',
  'Deepthroat 40x',
  'Deepthroat 10x in 1min',
  'Deepthroat 20x in 90s, or deepthroat 100x',
  'Suck for 5min, then deepthroat 20x',
  'Suck for 10min, then deepthroat 40x',
]

Kinks = [
  '[Pick three]',
  'Wear nippleclamps',
  'Wear blindfold',
  'Wear collar',
  'Smear everything that comes out of your mouth on your face',
  'After doing your duty, slap your face with the dildo 30 times',
  'Spank your ass 50 times',
  'Moan and beg for more',
  'Wear nippleclamps & blindfold',
  'Wear nippleclamps & collar',
]

Twists = [
  'Gangbang: X roll is cumulative',
  null, null, null, null, null,
  'Cheap escape: do not collect money for this roll', #6
  'He brings his friend: do double amount of work', #7
  'His favorite bitch: do triple amount of work, get paid double', #8
  'Your pimp comes around: give him half of your money', #9
  'Trips: your roll is now (0,0,0). After that, your pimp collects all your money (restart with $0)!', #10
]

Xmoney = [1000, 20, 20, 30, 20, 35, 40, 70, 40, 55]
Ymoney = [0, 10, 10, 20, 40, 40, 10, 10, 20, 30]

rollCounter = 0

class Roll
  constructor: () ->
    @x = d()
    @y = d()
    @z = d()
    @x = @y = @z = 0 if @x == @y and @y == @z
    @x0 = [d19(), d19()]
    @y0 = _.first(_.shuffle([1..9]), 3)
    @key = rollCounter++

  numDuty: ->
    res = [@x]
    res.push(@y) if @y == @z
    res = res.concat(@x0) if _.contains(res, 0)
    res = [1.._.max(res)] if @z == 0
    res

  duty: ->
    duties = _.map(@numDuty(), (x) -> Duties[x])
    duties = _.map(duties, (duty) -> duty.replace(/(\d+)(min|x)/g, (_, p1, p2) -> "#{+p1 * 2}#{p2}")) if @z == 7
    duties = _.map(duties, (duty) -> duty.replace(/(\d+)(min|x)/g, (_, p1, p2) -> "#{+p1 * 3}#{p2}")) if @z == 8
    duties

  numKink: ->
    res = [@y]
    res.push(@x) if @x == @z
    res = res.concat(@y0) if _.contains(res, 0)
    _.uniq(res)

  kink: ->
    _.map(@numKink(), (y) -> Kinks[y])

  twist: ->
    res = [@z]
    res.push(@x) if @x == @y
    res.push(10) if @takesAll()
    _.compact(_.map(_.uniq(res), (z) -> Twists[z]))

  money: ->
    return 0 if 6 == @z
    moneys = _.map(@numDuty(), (x) -> Xmoney[x])
    moneys = [_.min(moneys)] if _.contains(@numDuty(), 0)
    moneys = moneys.concat(_.map(@numKink(), (y) -> Ymoney[y]))
    moneys = _.map(moneys, (n) -> n * 2) if 8 == @z
    _.reduce(moneys, ((memo, num) -> memo + num), 0)

  takesAll: ->
    0 == @x + @y + @z

  takesHalf: ->
    9 == @z

  debug: ->
    "x=#{@x} y=#{@y} z=#{@z} x0=#{@x0} y0=#{@y0}"

  hasClamps: ->
    _.any @numKink(), (y) -> y == 1 or y == 8 or y == 9

  hasCollar: ->
    _.any @numKink(), (y) -> y == 3 or y == 9

{ button, div, form, img, h1, h3, h4, input, label, li, option, p, select, span, strong, ul } = React.DOM

StartSelector = React.createClass
  getInitialState: ->
    value: @props.A || 0
    permanentClamps: window.localStorage?.permanentClamps == 'true'
    permanentCollar: window.localStorage?.permanentCollar == 'true'

  handleSubmit: (e) ->
    e.preventDefault()
    @props.started(@state.value, @state.permanentClamps, @state.permanentCollar)

  handleChange: (e) ->
    @setState value: e.target.value

  storeState: (obj) ->
    for k, v of obj
      window.localStorage?[k] = v
    @setState obj

  render: ->
    div {},
      p className: "lead",
        'The game is not started yet. Select a value for A (target amount of money) and press Start.'
      form className: "form", onSubmit: @handleSubmit,
        div(className: "form-group",
          label({}, 'A ='),
          select className: "form-control", defaultValue: @props.A, onChange: @handleChange, style: {display: 'inline-block', width: 'auto'},
            option(value: 0, 'Random'),
            option(key: x, value: x, "#{x} ($#{x}00)") for x in [1..10]), ' '

        div className: "form-group",
          label {},
            (input type: 'checkbox', checked: @state.permanentClamps, onChange: => @storeState permanentClamps: not @state.permanentClamps),
            ' Permanent nippleclamps [once you get them, keep them on until the end of the game, +$5 to every roll] '

        div className: "form-group",
          label {},
            (input type: 'checkbox', checked: @state.permanentCollar, onChange: => @storeState permanentCollar: not @state.permanentCollar),
            ' Permanent collar [once you get it, keep it on until the end of the game, +$5 to every roll] '

        button type: "submit", className: "btn btn-primary", 'Start'

Game = React.createClass
  getInitialState: ->
    money: 0
    target: @props.A * 100
    rolls: []
    debug: false
    original: false
    keepClamps: false
    keepCollar: false

  createNextTask: (e) ->
    e.preventDefault()
    rolls = [roll = new Roll()].concat(@state.rolls)
    money = @calcMoney(rolls)
    @setState(
      rolls: rolls,
      money: money,
      keepClamps: @state.keepClamps or @props.permanentClamps and roll.hasClamps(),
      keepCollar: @state.keepCollar or @props.permanentCollar and roll.hasCollar())

  rollB: ->
    @setState b: d()

  listify: (a) ->
    if a.length > 1
      ul {}, _.map(a, (el, i) -> li key: i, el)
    else
      a[0]

  finalDecision: ->
    can = @state.b < @props.A
    div {},
      div className: "panel text-center #{if can then 'panel-success' else "panel-danger"}", style: {marginTop: 20},
        h1 {className: 'panel-heading panel-title'},
          "You #{if can then "can" else "can't"} cum!"
        "Your B is #{@state.b}"
      button className: "btn btn-primary btn-lg pull-right", onClick: @props.startAnother,
        'Start another game'

  toggleDebug: ->
    @setState debug: not @state.debug

  toggleOriginal: ->
    @setState original: not @state.original

  calcMoney: (rolls) ->
    money = 0
    hasClamps = false
    hasCollar = false
    for roll in rolls by -1
      if roll.takesAll()
        money = 0
      else
        money += roll.money()
        if @props.permanentClamps
          if roll.hasClamps()
            hasClamps = true
          else if hasClamps
            money += 5
        if @props.permanentCollar
          if roll.hasCollar()
            hasCollar = true
          else if hasCollar
            money += 5
        money = parseInt(money / 2) if roll.takesHalf()
    money

  moneyLabel: (type, text, additionalClass) ->
    div className: "col-xs-6 #{additionalClass}",
      h3 className: 'hidden-xs',
        span className: "label label-#{type}", text
      h4 className: 'visible-xs',
        span className: "label label-#{type}", text

  render: ->
    canGetNext = @state.money < @state.target
    beforeFinal = not canGetNext and @state.b == undefined
    finished = not canGetNext and not beforeFinal
    div {},
      div className: 'row',
        @moneyLabel("info", "Your money: $#{@state.money}")
        @moneyLabel("success", "Target money: $#{@state.target}", 'text-right')
      if @state.keepClamps or @state.keepCollar
        div className: 'row center-block text-center',
          if @state.keepClamps
            h4 {},
              span className: "label label-warning",
                "Keep your nippleclamps on"
          ' '
          if @state.keepCollar
            h4 {},
              span className: "label label-warning",
                "Keep your collar on"
      div className: 'row', style: {marginTop: 20},
        div className: 'col-xs-12',
          canGetNext and
            button className: "btn btn-primary btn-lg center-block", onClick: @createNextTask,
              'Get next task'
          beforeFinal and
            button className: "btn btn-success btn-lg center-block", onClick: @rollB,
              'Roll for B'
          finished and
            @finalDecision()
      div className: 'row hidden-xs', style: {marginTop: 20},
        div className: 'col-xs-4',
          strong {}, 'Duty'
        div className: 'col-xs-3',
          strong {}, 'Kink'
        div className: 'col-xs-3',
          strong {}, 'Twist'
        div className: 'col-xs-2',
          strong {}, 'Money'
      _.map(@state.rolls, (roll, i) =>
        div key: roll.key, className: "row #{if 0 == i then 'lead' else 'text-muted'}", style: {marginTop: 20},
          div className: 'col-sm-4',
            (strong className: 'visible-xs', 'Duty:'),
            @listify(roll.duty())
          div className: 'col-sm-3',
            (strong className: 'visible-xs', 'Kink:'),
            @listify(roll.kink())
          div className: 'col-sm-3',
            (strong className: 'visible-xs', 'Twist:'),
            @listify(roll.twist())
          div className: 'col-sm-2',
            (strong className: 'visible-xs', 'Money:'),
            "$#{roll.money()}"
          @state.debug and
            div className: 'col-xs-12', roll.debug())
      div className: 'row', style: {marginTop: 40},
        div className: 'col-xs-12 text-right',
          label {},
            (input type: 'checkbox', checked: @state.original, onChange: @toggleOriginal),
            ' Show original  '
          label {},
            (input type: 'checkbox', checked: @state.debug, onChange: @toggleDebug),
            ' Debug'
      @state.original and
        img className: 'img-responsive', src: 'http://40.media.tumblr.com/3d37deb13a8382de854e2c0ca1715877/tumblr_nuos2gddcs1rw2ehco1_1280.png'

OWRMain = React.createClass
  getInitialState: ->
    started: false
    A: @getAFromQuery()

  getAFromQuery: ->
    _.min([+m[1], 10]) if m = top.location.search.match(/[?&]a=(\d+)/)

  startGame: (a, permanentClamps, permanentCollar) ->
    a ||= parseInt(1 + Math.random() * 10)
    @setState started: true, A: a, permanentClamps: permanentClamps, permanentCollar: permanentCollar

  startAnother: ->
    @setState started: false, A: undefined

  render: ->
    div className: "container",
      h1({}, 'Oral Whore Roulette'),
      if @state.started
        <Game A={@state.A}
              permanentClamps={@state.permanentClamps}
              permanentCollar={@state.permanentCollar}
              startAnother={@startAnother} />
      else
        <StartSelector started={@startGame} A={@state.A} />

ReactDOM.render <OWRMain />, document.getElementById('content')
