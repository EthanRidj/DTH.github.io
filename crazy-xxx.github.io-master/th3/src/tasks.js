import {compact, isNumber, max, random} from 'lodash'

const headers = [
  'Challenge 01. Starting it easy',
  'Challenge 02. Getting into action',
  'Challenge 03. Short but sweet',
  'Challenge 04. Dripping mess',
  'Challenge 05. Breath control',
  'Challenge 06. First endurance test',
  'Challenge 07. Break time',
  'Challenge 08. Pure throatfuck',
  'Challenge 09. Punishment without reason',
  'Challenge 10. A little twist',
  'Challenge 11. Improving yourself',
  'Challenge 12. Nasty whore',
  'Challenge 13. Mixed technique',
  'Challenge 14. Repeat',
  'Challenge 15. Close to end',
]

const intros = [
  "So you decided to be a throat whore today, you will get more than you expect, but you should start slowly, enjoy it.",
  "Bored from licking and not getting full candy? Don't worry bitch, things are getting more interesting.",
  "This challenge will provide you more spit, don't swallow it, leave it in your mouth, all dripped spit must end in the bowl from now on. " +
    "Obedient girls swallow only cum, but keep spit for the show.",
  "Put that mess on your face slut, you are about get nasty and degraded!",
  "When out of air, you will know what it truly means to submit like a slave.",
  "You will be throated like a whore.",
  "Right now you are willing to do anything else than having a dildo rape your throat.",
  "Show me how good are you at the very basic discipline of blowjob. I will make a spit factory out of you.",
  "Serious throat whore must get used to getting an occasional smack.",
  "Thought you have the hard stuff finally done? Then prepare your throat for a surprise, slut!",
  "Be a good girl and take one minute rest, breathe slowly.",
  "I will let you play with the spit once more, because I like how nasty throat whore you are. However, get 5 or 6 on dice and you will have to " +
    "prove that you are as nasty as I expect you to be.",
  "Get ready to do anything and everything! You'll get 5 tasks (or more, if unlucky!) Put your head on side of bed.",
  "Let's go back and repeat one of the challenges.",
  "How can whore get nasty and messy, if she is not clean in the first place?",
]

const tasks = [
  [ // 1
    'lick the dildo 10 times',
    'lick the dildo 15 times',
    'put the head of your dildo in your mouth for 10 seconds',
    'put the head of your dildo in your mouth for 15 seconds',
    'lick the dildo 10 times and put the head of your dildo in your mouth for 10 seconds',
    'lick the dildo 15 times and put the head of your dildo in your mouth for 15 seconds',
  ],
  [ // 2
    'swallow it until you get tears in eyes',
    'slowly swallow it down your throat once',
    'slowly swallow it down your throat twice',
    'slowly swallow it down your throat 3 times',
    'quickly swallow it down your throat 3 times',
    'slowly swallow it down your throat 3 times then quickly swallow it down your throat 3 times',
  ],
  [ // 3
    'push it down your throat and leave it there for 3 seconds',
    'push it down your throat and rotate it 360°. ',
    'push it in as fast as you can and leave it there for 10 seconds',
    'push it in as fast as you can and rotate it 360° two times',
    'push it into you throat and out as fast you can 3 times, repeat it 3 times',
    'All of it, with short breaks: {ALL}',
  ],
  [ // 4
    "Sit down, drool the spit and try to take it back to your mouth without using your hands. A little tip: imagine you're drinking with a straw",
    "Get on your back with your neck on the border of your bed, drool the spit and try to take it back to your mouth without using your hands. " +
      "A little tip: imagine you're drinking with a straw",
    "Put all that spit onto your genitals and over the tits",
    "Get on your back with your neck on the border of your bed, swallow dildo then look how it drips on your face, 15 times, don't blink",
    "Get on your back with your neck on the border of your bed, and spit it all over your face, with closed eyes",
    "Drink the spit",
  ],
  [ // 5
    "you have to hold it in your throat for 8 seconds {TIMER: 8}",
    "you have to hold it in your throat for 10 seconds, smack your face once during this {TIMER: 10}",
    "you have to hold it in your throat for 12 seconds, smack your face once during this {TIMER: 12}",
    "you have to hold it in your throat for 18 seconds, smack your face twice during this {TIMER: 18}",
    "you have to hold it in your throat for 24 seconds, smack your face twice during this {TIMER: 24}",
    "you have to hold it in your throat for 30 seconds, smack your face 3 times during this {TIMER: 30}",
  ],
  [ // 6
    "Fuck your throat with your dildo 10 times, then hold it in for 5 seconds. Do this 3 times in a row. Take a break only to spit into the bowl",
    "Fuck your throat with your dildo 12 times, then hold it in for 6 seconds. Do this 3 times in a row. Take a break only to spit into the bowl",
    "Fuck your throat with your dildo 16 times, then hold it in for 8 seconds. Do this 3 times in a row. Take a break only to spit into the bowl",
    "Fuck your throat with your dildo 18 times, then hold it in for 9 seconds. Do this 3 times in a row. Take a break only to spit into the bowl",
    "Fuck your throat with your dildo 10 times, then hold it in for 10 seconds. Do this 3 times in a row, must keep spit in your mouth, no break",
    "Fuck your throat with your dildo 10 times, then hold it in for 20 seconds. Do this 5 times in a row, must keep spit in your mouth, no break",
  ],
  [ // 7
    "Get on your back with your neck on the border of your bed, drool the spit and try to take it back to your mouth without using your hands. " +
      "A little tip: imagine you're drinking with a straw",
    "Get on your back with your neck on the border of your bed and spit it all over your face, with closed eyes",
    "Take some spit and drool it on your open eyes with your hand",
    "Take all that spit play with it for more than 2 minutes, get in anywhere on face, except hair",
    "Take some spit and drool it on your open eyes with your hand, play with it 3 minutes",
    "Take all that spit play with it for more than 5 minutes, get in anywhere on face, except hair",
  ],
  [ // 8
    "Push the dildo as deep as you can and out of the mouth fast 30 times. Only pause to spit into the bowl, then resume immediately.",
    "Push the dildo as deep as you can and out of the mouth fast 60 times. Only pause to spit into the bowl, then resume immediately.",
    "Push the dildo as deep as you can and out of the mouth fast 90 times. Only pause to spit into the bowl, then resume immediately.",
    "Push the dildo as deep as you can and out of the mouth fast 120 times. Only pause to spit into the bowl, then resume immediately.",
    "Push the dildo as deep as you can and out of the mouth fast 100 times. Take a break to catch your breath, then do it again.",
    "Push the dildo as deep as you can and out of the mouth fast 100 times. Take a break to catch your breath, then do it again TWICE.",
  ],
  [ // 9
    "Smack your face with wet dildo hard enough to feel punished 3 times",
    "Smack your face with wet dildo hard enough to feel punished 4 times",
    "Smack your face with wet dildo hard enough to feel punished 5 times",
    "Smack your face with wet dildo hard enough to feel punished 6 times",
    "Smack your face with wet dildo hard enough to feel punished 7 times + each time once in next challenge",
    "Smack your face with wet dildo hard enough to feel punished 10 times + smack yourself 3 times each time in next challenge",
  ],
  [ // 10
    "push the dildo as far as you can, and rotate it 360° once then fuck your throat 6 times.",
    "push the dildo as far as you can, and rotate it 360° twice then fuck your throat 6 times. Do this twice in a row, pause only for spitting into the bowl ",
    "push the dildo as far as you can, and rotate it 360° 3 times then fuck your throat 6 times. Do this 3 times in a row, pause only for spitting into the bowl ",
    "push the dildo as far as you can, and rotate it 360° 3 times then fuck your throat 6 times. Do this 4 times in a row, pause only for spitting into the bowl ",
    "push the dildo as far as you can, and rotate it 360° 3 times then fuck your throat 6 times. Do this 5 times in a row, pause only for spitting into the bowl ",
    "push the dildo as far as you can, and rotate it 360° 3 times then fuck your throat 6 times. Do this 6 times in a row, pause only for spitting into the bowl ",
  ],
  [ // 11
    "push dildo as far as you can, leave it there for {INTROTIMER: 18} seconds",
    "push dildo as far as you can, leave it there for {INTROTIMER: 15} seconds",
    "push dildo as far as you can, leave it there for {INTROTIMER: 12} seconds",
    "push dildo as far as you can, leave it there for {INTROTIMER: 9} seconds",
    "push dildo as far as you can, leave it there for {INTROTIMER: 6} seconds",
    "push dildo as far as you can, leave it there for {INTROTIMER: 3} seconds",
  ],
  [ // 12
    "Sit down, drool the spit and try to take it back to your mouth without using your hands. A little tip: imagine you're drinking with a straw",
    "Get on your back with your neck on the border of your bed, drool the spit and try to take it back to your mouth without using your hands. " +
      "A little tip: imagine you're drinking with a straw",
    "Get on your back with your neck on the border of your bed, and spit it all over your face, with closed eyes",
    "Get on your back with your neck on the border of your bed, and spit it all over your face, with wide open eyes. " +
      "Make sure to get some spit into your eyes, play with it 2 minutes",
    "Snore all the spit from bowl, half with one nostril, other half with other nostril",
    "Get on your back with your neck on the border of your bed, get all the spit deep in your mouth and push it out through your nose on your face " +
      "(exhale through nose, air will push it out through nostrils)",
  ],
  [ // 13
    "Hold dildo in throat for 20 seconds, keep spit in mouth.",
    "Deepthroat dildo 20 times, keep spit in mouth.",
    "Rotate dildo 2 times then hold 10 seconds in, keep spit in mouth.",
    "Spit on your face",
    "Rotate dildo 3 times",
  ],
  [ // 14
  ],
  [ // 15
    "Clean yourself PERFECTLY! (eyes especially) from all the mess, and tidy it up! Only then you are allowed to cum.",
    "Clean yourself PERFECTLY! (eyes especially) from all the mess, and tidy it up! Only then you are allowed to cum.",
    "Clean yourself PERFECTLY! (eyes especially) from all the mess, and tidy it up! Only then you are allowed to cum.",
    "Nastiest whore, spread all the mess all over your face and body while dildo in your mouth! Then pour all spit from mouth into " +
      "your pussy/on your dick, put on your panties and CLEAN YOUR EYES PERFECTLY AND FOREHEAD, leave all spit bellow your nose. Feel how " +
      "nasty you are for 3 hours. Only then clean yourself perfectly from all the mess, and tidy it up! Only then you are allowed to cum.",

  ],
  [ // 16
  ],
]

const punishments = [
  null,
  null,
  {intro: "If you swallowed any spit, or it fell on the floor...", task: 5},
  {intro: "If you didn't create enough spit...", text: "swallow the dildo 30 times and repeat the challenge"},
  {intro: "If you couldn't hold it in long enough...", easier: 1},
  {intro: "Smack your face for every break longer than 6 seconds."},
  {intro: "Didn't get enough time to rest? Not your fault, life is not fair. Start next challenge immediately!", ifTask: 0},
  {intro: "Gag yourself for every break longer than 4 seconds."},
  {intro: "If you don't feel punished enough...", task: 5},
  {
    intro: "For every single break longer than 4 seconds...",
    text: "repeat this: push the dildo as far as you can, and rotate it 360° once then fuck your throat 6 times",
  },
  {
    intro: "If you stop too soon, for every second missing...",
    text: "repeat this: push the dildo as far as you can, and rotate it 360° once then fuck your throat 6 times",
  },
  {
    intro: "Couldn't do it?",
    text: "Get on your back with your neck on the border of your bed then gag yourself until you puke on your face! " +
            "(close your eyes, vomit might be dangerous to them!)",
    ifTaskGtE: 4,
  },
  {},
  {},
]

const randIndex = (difficulty) => {
  switch (difficulty) {
    case 'lite': return random(4)
    case '123': return random(2)
    case '45': return random(3, 4)
    default:
  }
  const r = random(5) + difficulty
  return r < 0 ? 0 : r > 5 ? 5 : r
}

const withAllAppended = (task, curTasks) =>
  task.replace("{ALL}", "\n" + curTasks.slice(0, 5).join("\n"))

const extractTimer = (mightContainTimer) => {
  let timer
  const task = mightContainTimer.replace(/\s*{TIMER: (\d+)}\s*/, (_, num) => {
    timer = +num
    return ''
  })
  return {task, timer}
}

const extractIntroTimer = ({task: mightContainIntroTimer, timer}) => {
  let introTimer
  const task = mightContainIntroTimer.replace(/{INTROTIMER: (\d+)}/, (_, num) => {
    introTimer = +num
    return '??'
  })
  return {task, introTimer, timer}
}

const prependIndex = (task, index) => `[${index + 1}] ${task}`

const prepareTask = (curTasks, index) =>
  extractIntroTimer(
    extractTimer(
      prependIndex(
        withAllAppended(curTasks[index], curTasks), index)))

const preparePunishment = (punishment, curTasks, index) => {
  if (punishment) {
    if (punishment.task) {
      return {...punishment, text: prepareTask(curTasks, punishment.task).task}
    }
    if (punishment.easier) {
      const punishmentTask = prepareTask(curTasks, max([index - 1, 0]))
      return {...punishment, text: punishmentTask.task, timer: punishmentTask.timer}
    }
    if (isNumber(punishment.ifTask) && punishment.ifTask !== index) {
      return {}
    }
    if (isNumber(punishment.ifTaskGtE) && punishment.ifTaskGtE > index) {
      return {}
    }
    return punishment
  }
}

const prepareTask12 = (difficulty) => {
  const diff = difficulty === +6 ? 2 : difficulty
  let maxLen = difficulty === +6 ? 10 : 5
  const arr = ['']
  let spitCount = 0
  while (arr.length <= maxLen) {
    const index = randIndex(diff)
    if (index === 5) {
      if (maxLen < 10) {
        maxLen += 1
      }
    }
    else {
      arr.push(tasks[12][index])
      if (index === 3 && maxLen < 10) {
        spitCount += 1
        if (spitCount === 3) {
          maxLen += 5
          spitCount = 0
        }
      }
    }
  }
  return {task: arr.join("\n")}
}

const combineTasks = (taskList) => {
  if (taskList.length === 1) {
    return taskList[0]
  }
  else {
    return {
      task: "Do all:\n" + taskList.map(task => task.task).join("\n"),
      timer: compact(taskList.map(task => task.timer))[0],
    }
  }
}

const taskIndex = (index) =>
  (index === 1 || index === 3 ? 12 - random(1, 6) - random(1, 6) : 12 - random(1, 6))

const prepareTask13 = (difficulty, nextTask) => {
  const index = randIndex(difficulty)
  const indices = [taskIndex(index)]
  if (indices[0] === 3 || indices[0] === 11) {
    let newIndex
    do {
      newIndex = taskIndex(index)
    } while (newIndex === 3 || newIndex === 11)
    indices.unshift(newIndex)
  }
  if (index > 3) {
    indices.push(12 - random(1, 6) - random(1, 6))
  }
  return combineTasks(indices.map(i => nextTask(i, index % 2 === 0 ? '123' : '45')))
}

const prepareTask14 = (difficulty) => {
  const index = randIndex(difficulty)
  let task
  let index2
  switch (index) {
    case 5:
      task = `Do all:${prepareTask12(difficulty).task}\n${prepareTask12(difficulty).task}`
      index2 = randIndex(difficulty)
      if (index2 >= 4) index2 = 3
      task += "\n" + tasks[14][index2]
      break
    case 4:
      task = "Do all:" + prepareTask12(difficulty).task
      index2 = randIndex(difficulty)
      if (index2 >= 4) index2 = 0
      task += "\n" + tasks[14][index2]
      break
    default:
      task = tasks[14][index]
  }
  return {task}
}

const nextTask = (num, difficulty) => {
  const index = randIndex(difficulty)
  const task =
    num === 14 ? prepareTask14(difficulty) :
    num === 13 ? prepareTask13(difficulty, nextTask) :
    num === 12 ? prepareTask12(difficulty) :
                 prepareTask(tasks[num], index)
  return {
    ...task,
    header: headers[num],
    intro: intros[num],
    punishment: preparePunishment(punishments[num], tasks[num], index),
  }
}

export default nextTask
