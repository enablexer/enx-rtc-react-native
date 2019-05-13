import React, { Component } from 'react';
import { View, Platform } from 'react-native';
import PropTypes from 'prop-types';
import EnxPlayerView from './views/EnxPlayerView';
import { Enx, nativeEvents } from './Enx';

export default class EnxSubscribeStream extends Component {
  constructor(props) {
    super(props);
    this.state = {
      streams: [],
      activeTalkerStreams: []
      
    };
    this.componentEvents = {
      streamCreated: Platform.OS === 'android' ? 'room:onStreamAdded' : 'room:didStreamAdded',
      activeTalkerstreamCreated: Platform.OS === 'android' ? 'room:onActiveTalkerList' : 'room:didActiveTalkerList',
    };
    this.componentEventsArray = Object.values(this.componentEvents);
  }
  componentWillMount() {
    console.log("EnxSubscribeStream.js","componentWillMount");
    this.streamCreated = nativeEvents.addListener(this.componentEvents.streamCreated, stream => this.streamCreatedHandler(stream));
    this.activeTalkerstreamCreated = nativeEvents.addListener(this.componentEvents.activeTalkerstreamCreated, activeTalkerStream => this.activeTalkerstreamCreatedHandler(activeTalkerStream));
    Enx.setJSComponentEvents(this.componentEventsArray);
  }
  
  componentDidUpdate() {
    
  }

  streamCreatedHandler = (stream) => {
    this.state.streams = [...this.state.streams, stream.streamId]
    }

activeTalkerstreamCreatedHandler = (activeTalkerStream) => {
        var tempArray = []
        this.state.activeTalkerStreams = []
        tempArray = activeTalkerStream
        if(tempArray.length == 0){
          this.setState({
            activeTalkerStreams: tempArray,
          });
        }

        for (let i = 0; i < tempArray.length; i++)  
      {
        const temp = tempArray[i]
        this.setState({
          activeTalkerStreams: [...this.state.activeTalkerStreams, String(temp.streamId)],
        });
      }
         
} 
      
  render() {
    const childrenWithStreams = this.state.activeTalkerStreams.map((streamId) => {
      return <EnxPlayerView  key={streamId} streamId={streamId} {...this.props}/>
    });
    return <View>{ childrenWithStreams }</View>;
  }
}

const viewPropTypes = View.propTypes;
EnxSubscribeStream.propTypes = {
  ...viewPropTypes,
  eventHandlers: PropTypes.object, 
};

EnxSubscribeStream.defaultProps = {
  eventHandlers: {},
};