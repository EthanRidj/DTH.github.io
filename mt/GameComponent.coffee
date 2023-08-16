GameComponent = React.createClass
  getInitialState: ->
    disabledContinue: true

  componentDidMount: ->
    @interval = setInterval =>
      allLoaded = true
      $('.observedImage').each (_, img) ->
        allLoaded &&= img.complete && img.naturalWidth > 0
      if allLoaded == @state.disabledContinue
        @setState(disabledContinue: !allLoaded)
    , 100

  componentWillUnmount: ->
    clearInterval @interval if @interval

  render: ->
    div {},
      if @props.wrongAnswer
        @renderWrongAnswer()
      else if @props.finished
        @renderFinished()
      else if @learningPhase()
        @renderLearning()
      else
        @renderTesting()
      @renderPreloader()

  renderWrongAnswer: ->
    div className: "jumbotron",
      h3 {}, "Oops! Wrong answer! You need to #{@wrongAnswerReaction()}."
      div className: 'row', style: {marginTop: 25},
        button type: "submit", className: "btn btn-primary btn-lg center-block", onClick: @clearWrongAnswer, 'Continue'

  clearWrongAnswer: ->
    store.dispatch(type: 'clearWrongAnswer')

  renderFinished: ->
    div className: "jumbotron",
      h1 {}, 'Congratulations! You passed!'
      div className: 'row', style: {marginTop: 25},
        button type: "submit", className: "btn btn-success btn-lg center-block", onClick: @newGame, 'Start another game'

  newGame: ->
    store.dispatch(type: 'newGame')

  renderLearning: ->
    div {},
      if @currentPair()
        @renderLearningPair()
      else
        @renderLearningIntro()
      div className: 'row', style: {marginTop: 25},
        button
          type: "submit",
          className: "btn btn-primary btn-lg center-block",
          onClick: @nextLearning,
          disabled: @state.disabledContinue,
          if @state.disabledContinue
            span {},
              (img src: '../vendor/gears.gif')
              ' Caching images...'
          else
            'Continue'

  renderLearningIntro: ->
    div className: "jumbotron",
      h1 {}, 'Learning phase'
      p {}, "You're going to see #{@props.pairs.length} pairs of images. Try to remember which image goes with which."

  renderLearningPair: ->
    div className: 'row',
      div className: 'col-xs-6',
        @gxImage()
      div className: 'col-xs-6',
        @cxImage()

  renderTesting: ->
    if @currentPair()
      @renderTestingPair()
    else
      @renderTestingIntro()

  renderTestingPair: ->
    div className: 'row',
      div className: 'col-xs-6',
        @gxImage()
      div className: 'col-xs-6',
        @renderCxs()

  renderTestingIntro: ->
    div className: "jumbotron",
      h1 {}, 'Testing phase'
      p {}, "Now it's time for your test. You must match image pairs that you saw earlier. Click on the correct image to proceed."
      div className: 'row', style: {marginTop: 25},
        button type: "submit", className: "btn btn-primary btn-lg center-block", onClick: @nextTest, 'Continue'

  wrongAnswerReaction: ->
    switch store.getState().gameParams.onWrongAnswer
      when 'retry'
        'retry this picture'
      when 'restart'
        'restart the test'
      when 'learning'
        'repeat the learning of the same pairs'
      when 'randomize'
        'learn a new set of pairs'

  renderCxs: ->
    cxs = _.shuffle @currentPair()[1..-1]
    div {},
      _.map cxs, (cx) =>
        div className: 'row', key: cx,
          @smallCxImage(cx)

  currentPair: ->
    if @learningPhase()
      @props.pairs[@props.currentLearning]
    else
      @props.pairs[@props.currentTest]

  learningPhase: ->
    'learning' == @props.phase

  gxImage: ->
    @halfSizeImage(@currentPair()[0], 'right')

  cxImage: ->
    @halfSizeImage(@currentPair()[1], 'left')

  halfSizeImage: (url, align) ->
    img src: url, className: 'observedImage', style: {maxHeight: '80vh', maxWidth: '100%', float: align}

  smallCxImage: (url, align = 'left') ->
    img
      src: url,
      className: 'observedImage',
      style: {maxHeight: '25vh', maxWidth: '100%', float: align, marginBottom: 10, cursor: 'pointer'}
      onClick: @checkAnswer

  checkAnswer: (e) ->
    if e.target.src == @currentPair()[1]
      store.dispatch(type: 'nextTest')
    else
      store.dispatch(type: 'wrongAnswer')

  nextLearning: ->
    @setState disabledContinue: true
    store.dispatch(type: 'nextLearning')

  nextTest: ->
    store.dispatch(type: 'nextTest')

  nextPair: ->
    if @learningPhase()
      @props.pairs[@props.currentLearning + 1]
    else
      @props.pairs[@props.currentTest + 1]

  renderPreloader: ->
    if pair = @nextPair()
      div style: {display: 'none'},
        _.map pair, (url) ->
          img src: url, key: url, className: 'observedImage'#, style: {width: 100, height: 100}
