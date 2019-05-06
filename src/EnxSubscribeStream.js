import React, { Component } from 'react';
import { View, Platform } from 'react-native';
import PropTypes from 'prop-types';
import EnxPlayerView from './views/EnxPlayerView';
import { Enx, nativeEvents,setNativeEvents,removeNativeEvents } from './Enx';
import { isNull, isUndefined, each, isEqual, isEmpty } from 'underscore';

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
    console.log("componenetArrayValues: ",this.componentEventsArray)
    this.streamCreated = nativeEvents.addListener(this.componentEvents.streamCreated, stream => this.streamCreatedHandler(stream));

    this.activeTalkerstreamCreated = nativeEvents.addListener(this.componentEvents.activeTalkerstreamCreated, activeTalkerStream => this.activeTalkerstreamCreatedHandler(activeTalkerStream));
    Enx.setJSComponentEvents(this.componentEventsArray);
  }
  
  componentDidUpdate() {
    
  }

  streamCreatedHandler = (stream) => {
    console.log("EnxSubscribeStream.js",stream);
    this.state.streams = [...this.state.streams, stream.streamId]
    }

activeTalkerstreamCreatedHandler = (activeTalkerStream) => {
        console.log("activeTalkerstreamCreatedHandler.js", activeTalkerStream);
        var tempArray = []
        this.state.activeTalkerStreams = []
        tempArray = activeTalkerStream
        console.log("activeTalkerstreamArrayTemp: ", tempArray);

        if(tempArray.length == 0){
          this.setState({
            activeTalkerStreams: tempArray,
          });
        }

        for (let i = 0; i < tempArray.length; i++)  
      {
        //inner loop to create columns
        console.log("In loop")
        const temp = tempArray[i]
        console.log("streamsssIdTemp: ",temp)
        console.log("streamsssId: ",String(temp.streamId))
        this.setState({
          activeTalkerStreams: [...this.state.activeTalkerStreams, String(temp.streamId)],
        });
      }
         
} 
      
//  Enx.subscribeToStream(stream.streamId, (error) => {
//         this.setState({
//           streams: [...this.state.streams, stream.streamId],
//         });      
    // });
  
 
  render() {
    console.log("rrrrrrrrr: ",this.state.activeTalkerStreams)
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