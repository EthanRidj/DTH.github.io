import React, {Component} from 'react'
import PropTypes from 'prop-types'
import {Alert, Button, Glyphicon, Grid, Nav, Navbar, NavItem, Panel, ProgressBar} from 'react-bootstrap'
import {isNumber, max} from 'lodash'

import ConfigPanel from './ConfigPanel'
import nextTask from './tasks'

class Game extends Component {
  static propTypes = {
    difficulty: PropTypes.oneOfType([PropTypes.number, PropTypes.string]).isRequired,
    onRestartGame: PropTypes.func.isRequired,
  }

  state = {
    tasks: [{
      header: 'Introduction',
      intro: 'before we begin',
      task: 'Assume the postition. Prepare the dildo and the spit bowl. When ready, click "Next Challenge"'}],
  }

  timerCallback = () => {
    const {introTimerStarted, stopCallback, taskTimer, timer, timerCountdown, timerInterval} = this.state
    if (timerCountdown) {
      this.setState({timerCountdown: timerCountdown - 1})
    }
    else if (0 === timerCountdown) {
      this.setState({timerCountdown: null, timer: taskTimer})
    }
    else if (stopCallback) {
      clearInterval(timerInterval)
      this.setState({timerInterval: null, stopCallback: null})
    }
    else if (0 === timer) {
      clearInterval(timerInterval)
      this.setState({timer: null, taskTimer: null, timerInterval: null})
    }
    else if (isNumber(introTimerStarted)) {
      this.setState({introTimerStarted: introTimerStarted + 1})
    }
    else {
      this.setState({timer: timer - 1})
    }
  }

  handleNextTask = () => {
    if (this.state.tasks.length < 16) {
      const task = nextTask(this.state.tasks.length - 1, this.props.difficulty)
      // const task = nextTask(14, this.props.difficulty)
      this.setState({
        tasks: [task].concat(this.state.tasks),
        showPunishment: false,
        taskTimer: task.timer,
        introTimer: task.introTimer})
    }
    else {
      this.setState({finished: true})
    }
  }

  handleStartTimer = () => {
    const timerInterval = setInterval(this.timerCallback, 1000)
    this.setState({timerCountdown: 3, timerInterval})
  }

  handleShowPunishment = () => {
    const {punishment} = this.state.tasks[0]
    this.setState({showPunishment: true, taskTimer: punishment && punishment.timer})
  }

  handleStartIntroTimer = () => {
    const timerInterval = setInterval(this.timerCallback, 1000)
    this.setState({introTimerStarted: 0, timerInterval})
  }

  handleStopIntroTimer = () => {
    const minTime = ((+this.props.difficulty || 0) + 3) * 5
    const taskTimer = max([this.state.introTimerStarted - this.state.introTimer, minTime])
    const [first, ...rest] = this.state.tasks
    const replaced = first.task.replace('??', taskTimer)
    const tasks = [{...first, task: replaced}].concat(rest)
    this.setState({taskTimer, tasks, introTimerStarted: null, introTimer: null, stopCallback: true})
  }

  renderTask(task) {
    if (task.indexOf('\n') === -1) {
      return task
    }
    else {
      const tasks = task.split('\n')
      return (
        <div>
          {tasks[0]}
          <ul>
            {tasks.slice(1).map((t, i) => <li key={i}>{t}</li>)}
          </ul>
        </div>)
    }
  }

  renderPunishment(punishment) {
    if (punishment && punishment.intro) {
      return (
        <div>
          <Glyphicon glyph="alert" /> {punishment.intro}{' '}
          {this.state.showPunishment ?
            this.renderTask(punishment.text)
          :
            punishment.text &&
              <Button bsStyle="danger" bsSize="xsmall" onClick={this.handleShowPunishment}>
                Get punishment
              </Button>
          }
        </div>)
    }
  }

  renderTasks() {
    return this.state.tasks.map(({header, intro, task, punishment}, i) =>
      <Panel
        key={header}
        header={<h3>{header}<br /><small>{intro}</small></h3>}
        bsStyle={i === 0 ? "primary" : "default"}
        footer={i === 0 && this.renderPunishment(punishment)}
      >
        {this.renderTask(task)}
      </Panel>)
  }

  renderTimerOrNextButton() {
    if (isNumber(this.state.timerCountdown)) {
      return (
        <Alert>
          <h3>
            Get ready...{' '}
            <strong>
              <Glyphicon glyph="time" /> Starting in {this.state.timerCountdown}s
            </strong>
          </h3>
        </Alert>)
    }
    else if (isNumber(this.state.timer)) {
      return (
        <Alert bsStyle={this.state.timer ? 'info' : 'success'}>
          <h3>
            <Glyphicon glyph="time" /> Hold it... <strong>{this.state.timer}s</strong>
          </h3>
          <ProgressBar min={this.state.taskTimer} max={0} now={this.state.timer} bsStyle={this.state.timer ? 'default' : 'success'} />
        </Alert>)
    }
    else if (isNumber(this.state.introTimer)) {
      return (
        <Alert bsStyle="warning">
          <h3>This task requires you to measure how long you can hold your breath.</h3>
          Start the timer, then hold your breath as long as you can. Afterwards, click the button again to stop the timer.
          {isNumber(this.state.introTimerStarted) ?
            <Button bsSize="large" bsStyle="danger" block onClick={this.handleStopIntroTimer}>
              <Glyphicon glyph="time" /> Holding it for <strong>{this.state.introTimerStarted}s</strong>... STOP!
            </Button>
            :
            <Button bsSize="large" bsStyle="warning" block onClick={this.handleStartIntroTimer}>Start timer when ready</Button>}
        </Alert>)
    }
    else if (this.state.taskTimer) {
      return <Button bsSize="large" bsStyle="warning" block onClick={this.handleStartTimer}>Start timer</Button>
    }
    else if (this.state.finished) {
      return (
        <Alert bsStyle="success">
          <h3>Finished! Congratulations!</h3>
          <Button bsSize="large" bsStyle="success" block onClick={this.props.onRestartGame}>Start another game</Button>
        </Alert>)
    }
    else {
      return <Button bsSize="large" block onClick={this.handleNextTask}>Next challenge</Button>
    }
  }

  render() {
    return (
      <div>
        {this.renderTimerOrNextButton()}
        <br />
        {this.renderTasks()}
      </div>)
  }
}

class App extends Component {
  state = {
    started: false,
    difficulty: 0,
  }

  render() {
    return (
      <div>
        <Navbar>
          <Navbar.Header>
            <Navbar.Brand>
              Throat Heaven 3
            </Navbar.Brand>
            {this.state.started && <Navbar.Toggle />}
          </Navbar.Header>
          {this.state.started &&
            <Navbar.Collapse>
              <Nav pullRight>
                <NavItem>
                  <Button bsSize="xsmall" bsStyle="danger" onClick={() => this.setState({started: false})}>
                    <Glyphicon glyph="refresh" /> Restart
                  </Button>
                </NavItem>
              </Nav>
            </Navbar.Collapse>}
        </Navbar>
        <Grid>
          {this.state.started ?
            <Game difficulty={this.state.difficulty} onRestartGame={() => this.setState({started: false})} /> :
            <ConfigPanel
              difficulty={this.state.difficulty}
              handleStart={() => this.setState({started: true})}
              handleSetDifficulty={(difficulty) => this.setState({difficulty})}
            />}
        </Grid>
        <Navbar fixedBottom>
          <Navbar.Text pullRight>
            Based on the original {' '}
            <a href="http://www.getdare.com/bbs/showthread.php?t=274819" target="_blank" rel="noopener noreferrer">Throat Heaven 3 dare</a>{' '}
            with small modifications.&nbsp;&nbsp;&nbsp;&nbsp;
          </Navbar.Text>
        </Navbar>
      </div>
    )
  }
}

export default App

// http://www.getdare.com/bbs/showthread.php?t=274819

// http://react-bootstrap.github.io/components.html

