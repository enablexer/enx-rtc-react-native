import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { View, Platform } from 'react-native';
import { Enx, removeNativeEvents, nativeEvents, setNativeEvents } from './Enx';
import EnxPlayerView from './views/EnxPlayerView';
import {sanitizePlayerViewEvents} from './helpers/EnxStreamHelper';

import { isNull } from 'underscore';
const uuid = require('uuid/v4');

class EnxStream extends Component {
  constructor(props) {
    super(props);
        this.state = {
      streamId:uuid(),
    }; 
  }

  componentWillMount() {
      const publisherEvents = sanitizePlayerViewEvents(this.props.eventHandlers);
    setNativeEvents(publisherEvents);
    console.log("EnxStream.js","componentWillMount"); 
    Enx.initStream(this.state.streamId);
  }

  componentDidMount() { 
    // Enx.initStream(this.state.streamId);
    console.log("EnxStream.js","componentDidMount")
  }
    
  render() {
    if (true) {
       const { streamId } = this.state;
      return <EnxPlayerView streamId={streamId} {...this.props} />;
    }
    return <View />;
  }
}
const viewPropTypes = View.propTypes;
EnxStream.propTypes = {
  ...viewPropTypes,
  eventHandlers: PropTypes.object, // eslint-disable-line react/forbid-prop-types
};
EnxStream.defaultProps = {
  eventHandlers: {},
};
export default EnxStream;

