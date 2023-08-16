import React, { Component } from 'react';
import { Button, ListGroup, ListGroupItem, Panel } from 'react-bootstrap';

class ConfigPanel extends Component {
  render() {
    return (
      <div>
        <Panel header={<h3>Difficulty</h3>} bsStyle="primary">
          <ListGroup fill>
            <ListGroupItem onClick={() => this.props.handleSetDifficulty(-2)} active={this.props.difficulty === -2}>
              <strong>Very Easy:</strong> -2 to every dice roll
            </ListGroupItem>
            <ListGroupItem onClick={() => this.props.handleSetDifficulty(-1)} active={this.props.difficulty === -1}>
              <strong>Easy:</strong> -1 to every dice roll
            </ListGroupItem>
            <ListGroupItem onClick={() => this.props.handleSetDifficulty('lite')} active={this.props.difficulty === 'lite'}>
              <strong>Lite:</strong> You won't get a 6, rolls are 1-5 only.
            </ListGroupItem>
            <ListGroupItem onClick={() => this.props.handleSetDifficulty(0)} active={this.props.difficulty === 0}>
              <strong>Standard:</strong> Standard 1-6 dice rolls.
            </ListGroupItem>
            <ListGroupItem onClick={() => this.props.handleSetDifficulty(+1)} active={this.props.difficulty === 1}>
              <strong>Hard:</strong> +1 to every dice roll
            </ListGroupItem>
            <ListGroupItem onClick={() => this.props.handleSetDifficulty(+2)} active={this.props.difficulty === 2}>
              <strong>Very hard:</strong> +2 to every dice roll
            </ListGroupItem>
            <ListGroupItem onClick={() => this.props.handleSetDifficulty(+6)} bsStyle="danger" active={this.props.difficulty === 6}>
              <strong>Throat Queen:</strong> Every roll is 6. Extreme difficulty!
            </ListGroupItem>
          </ListGroup>
        </Panel>
        <Button
          bsStyle="primary"
          bsSize="large"
          block
          onClick={this.props.handleStart}>
          Start game
        </Button>
      </div>)
  }
}

export default ConfigPanel
