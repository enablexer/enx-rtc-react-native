import React, { Component, Children, cloneElement } from "react";
import { View, ViewPropTypes } from "react-native";
import PropTypes from "prop-types";
import {
  setNativeEvents,
  removeNativeEvents,
  Enx
} from "./Enx";
import {
  sanitizeRoomEvents,
  sanitizeLocalInfoData,
  sanitizeRoomData
} from "./helpers/EnxRoomHelper";
import { pick } from "underscore";

export default class EnxRoom extends Component {
  constructor(props) {
    super(props);
  }
  componentWillMount() {
    try {
    const token = pick(this.props, ['token']);
       const roomEvents = sanitizeRoomEvents(this.props.eventHandlers);
       setNativeEvents(roomEvents);
       const info = sanitizeLocalInfoData(this.props.localInfo);
       const roomData=sanitizeRoomData(this.props.roomInfo)
       if(token == undefined){
           console.log('Error: Provide a valid token.')
       }
       else{
        Enx.joinRoom(token.token,info,roomData)
       }
    } catch (error) {
      console.log("EnxRoom.js componentWillMount", error);
    }
  }

  componentDidUpdate(previousProps) {
    
  }

componentWillUnmount() {
        const events = sanitizeRoomEvents(this.props.eventHandlers);
        removeNativeEvents(events);
     }

  render() {
    const { style } = this.props;

    if (this.props.children) {
      const childrenWithProps = Children.map(this.props.children, child =>
        child
          ? cloneElement(child, {
              token: this.props.token
            })
          : child
      );
      return <View style={style}>{childrenWithProps}</View>;
    }
    return <View />;
  }
}

EnxRoom.propTypes = {
  token: PropTypes.string.isRequired,
  children: PropTypes.oneOfType([
    PropTypes.element,
    PropTypes.arrayOf(PropTypes.element)
  ]),
  style: ViewPropTypes.style,
  eventHandlers: PropTypes.object,
  localInfo: PropTypes.object,
  roomInfo:PropTypes.object
};

EnxRoom.defaultProps = {
  eventHandlers: {},
  style: {
    flex: 1
  }
};
