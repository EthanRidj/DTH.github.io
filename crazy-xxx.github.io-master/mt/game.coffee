gameInitialState =
  started: false

game = (state = gameInitialState, action) ->
  switch action.type
    when 'startGame'
      dup(state, startingGameState())
    when 'newGame'
      dup(gameInitialState)
    when 'nextLearning'
      if state.currentLearning + 1 < state.pairs.length
        dup(state, currentLearning: state.currentLearning + 1)
      else
        dup(state, prepareTesting(state.pairs))
    when 'nextTest'
      if state.currentTest + 1 < state.pairs.length
        dup(state, currentTest: state.currentTest + 1)
      else
        dup(state, finished: true)
    when 'wrongAnswer'
      dup(state, wrongAnswer: true, wrongAnswerState())
    when 'clearWrongAnswer'
      dup(state, wrongAnswer: false)
    else
      state

startingGameState = ->
  started: true
  phase: 'learning'
  currentLearning: -1
  pairs: combinePairs()

gxs = [ #http://gentlemanboners.tumblr.com/archive
  'http://66.media.tumblr.com/2f89f3f34d68ea4bca8611d1d49d24d3/tumblr_oc4k5qIUMD1unmtsfo1_1280.jpg',
  'http://68.media.tumblr.com/b3b07eacdc76bead27531a18d84598c4/tumblr_oc4mp6XlYh1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/e12077b854342e61f521a98aa718ba56/tumblr_oc3asbyFir1unmtsfo1_1280.jpg',
  'http://68.media.tumblr.com/1c417d987228a81dcb55970443237a3b/tumblr_obzgzuNH5z1unmtsfo1_1280.jpg',
  'http://68.media.tumblr.com/a8f30d98a664ef1c68c3e10dc67a3d72/tumblr_occ7alwcQP1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/c4230e32674d2bba5c02abff19b8ced9/tumblr_occdb8EUge1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/b38b8066f845bc6a031180cf1c3cfbf1/tumblr_ocbm84EJ9d1unmtsfo1_1280.jpg',
  'http://68.media.tumblr.com/46ef10a36c533c33fc01bbcc0ea8c0b9/tumblr_oc9y9wtBCp1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/0bfb44b030e97aafc995af332e90311d/tumblr_oc7xghbuvn1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/22b193f8c6baadd66140e0983b9ba984/tumblr_oc6ya90GJO1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/b3176f056eb03b440b00fb4155a2963f/tumblr_oc2bqg7mRw1unmtsfo1_1280.jpg',
  'http://68.media.tumblr.com/d3184d8b7f4be22867bb396925aa8c90/tumblr_obyic54ka61unmtsfo1_1280.jpg',
  'http://68.media.tumblr.com/0ccc0a4ecadcb8590bd69db129f15f6e/tumblr_occln1DZ2l1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/1e3da67e6b12bcec565dd66a118a3821/tumblr_ocbzn7lZAk1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/b142b37fc8da9babfd443735e558a8fe/tumblr_ocbvhesW0v1unmtsfo1_1280.jpg',
  'http://66.media.tumblr.com/19706c3603e0fca45d59f5e038a22148/tumblr_ocbci4l6PA1unmtsfo1_1280.jpg',
  # 'http://68.media.tumblr.com/2a364e7c86e3236c1ac8e2cb6b32f833/tumblr_njpduz9LOX1rodxovo6_1280.jpg',
  # 'http://68.media.tumblr.com/70adc6a801dd9e8cd8c66c5e70458a61/tumblr_njnha11WIq1rodxovo2_1280.jpg',
  # 'http://66.media.tumblr.com/921a7e8b72362699c5f372cd5f243cec/tumblr_nlcobhjaFf1rodxovo7_1280.png',
  # 'http://66.media.tumblr.com/d8efdf8a71cb33ef9a39bf8210c84e59/tumblr_njlmes8g0g1rodxovo3_1280.jpg'
]
cxs = [
  'http://68.media.tumblr.com/bf3fb8b3ff7ef7359cf692770f423db1/tumblr_oagmq610es1smjd03o1_1280.jpg',
  'http://66.media.tumblr.com/a2625616a8080f4d33e9d0d9cec3c42f/tumblr_o901637P6S1qdueojo1_1280.jpg',
  'http://66.media.tumblr.com/d100fd6fbee8188c2ea4fd1763e95d81/tumblr_o1nm920xfU1qfbh7io1_1280.jpg',
  'http://68.media.tumblr.com/de4ec3bf28ced31cbad5f4225e14c472/tumblr_o93nijX2vc1uynf4mo1_1280.jpg',
  'http://66.media.tumblr.com/46cec95fc9d764b563117028fa70f337/tumblr_oas3j4gQyc1s3l69so1_1280.jpg',
  'http://68.media.tumblr.com/4b7f9e2c7cf1212b841238b917e23928/tumblr_o8r5e6ihiq1u1hkmao1_1280.jpg',
  'http://66.media.tumblr.com/4481cde801fdcfcc3b7b7bc565f06bb4/tumblr_o6vo1tWwAl1s3l69so1_1280.jpg',
  'http://68.media.tumblr.com/07f0accbaf1c54e1c4a3e807050333a4/tumblr_obeu1r4aDL1uynf4mo1_1280.jpg',
  'http://68.media.tumblr.com/9f4ab43f2fe30fbaf59233d60beb4d8e/tumblr_o0k6owMYvD1u7o2a0o1_1280.jpg',
  'http://68.media.tumblr.com/ea23f92d7d037eb43edf24311e416332/tumblr_oaoeg1pWjG1s22t8fo1_1280.jpg',
  'http://68.media.tumblr.com/bff62ffc14cc2c71fbf8678db64dbda6/tumblr_o91rkmT65q1uynf4mo1_1280.jpg',
  'http://68.media.tumblr.com/56ee2cf203427c1cc7ccbf612f6b14f5/tumblr_oaaxg1uXAU1ukekago1_1280.jpg',
  'http://66.media.tumblr.com/c477611a5c5c089e3d10d362d949c264/tumblr_o0zye0y5151tfrxy1o1_1280.jpg',
  'http://68.media.tumblr.com/681537b666cb07148f5381be9092d9a6/tumblr_oamiq4DkEf1r68jvoo1_1280.png',
  'http://66.media.tumblr.com/563615feefca381df4233fceb48942cb/tumblr_ob3n27HBWS1rdcdxpo1_1280.jpg',
  'http://68.media.tumblr.com/b7e5c3c543b31203fb96ecfffc21a281/tumblr_nnut8mrm8m1uq0201o1_1280.jpg',

  # 'http://68.media.tumblr.com/acdc00fba1174c0400bf167534241b4a/tumblr_o74ou7Gc6p1qcv09ro3_1280.jpg',
  # 'http://66.media.tumblr.com/044dcc65c6b60dd40098f435530cd911/tumblr_nxn8ix0wSH1ro1zebo1_1280.jpg',
  # 'http://68.media.tumblr.com/ac00120ad8c7de3b1472a7c1adbb10d1/tumblr_nw2ih9zsjI1qkxrtro1_1280.png',
  # 'http://66.media.tumblr.com/328c3523d732d026f66f57a4a6eb64b9/tumblr_nw2ih9zsjI1qkxrtro4_1280.png',
]

combinePairs = ->
  numberOfPairs = store.getState().gameParams.numberOfPairs
  sg = _.shuffle(gxs)[0...numberOfPairs]
  sc = _.shuffle(cxs)[0...numberOfPairs]
  _.map _.zip(sg, sc), (a) ->
    [a[0]].concat(getRandomsCxs(a[1]))

prepareTesting = (pairs) ->
  phase: 'testing'
  currentTest: -1
  pairs: _.shuffle(pairs)

wrongAnswerState = ->
  switch store.getState().gameParams.onWrongAnswer
    when 'retry'
      {}
    when 'restart'
      currentTest: -1
    when 'learning'
      currentLearning: -1
      phase: 'learning'
    when 'randomize'
      @startingGameState()


getRandomsCxs = (cx) ->
  res = [cx]
  while res.length < 3
    rc = _.sample(cxs)
    res.push(rc) unless _.contains(res, rc)
  res

# wait = 0
# timer = ->
#   game = store.getState().game
#   return unless game.started
#   if game.countdown and (not responsiveVoice.isPlaying() or wait++ > 1) # kludge to avoid missing countdown
#     wait = 0
#     store.dispatch(type: 'decreaseCountdown')
#   else if game.running
#     if 0 == game.tasks.length or 0 == game.tasks[0].time
#       store.dispatch(type: 'nextTask')
#     else
#       store.dispatch(type: 'decreaseTask')

# setInterval(timer, 1000)
