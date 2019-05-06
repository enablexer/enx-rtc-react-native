import React, { Component, Children, cloneElement } from 'react';
import { View, ViewPropTypes } from 'react-native';
import PropTypes from 'prop-types';
import { setNativeEvents, removeNativeEvents,  Enx } from './Enx';
import { sanitizeRoomEvents,sanitizeLocalInfoData} from './helpers/EnxRoomHelper';
import { pick, isNull } from 'underscore';

export default class EnxRoom extends Component {
  constructor(props) {
    super(props);
  }
  componentWillMount() {
    try {
    console.log("EnxRoom.js","componentWillMount");
    const token = pick(this.props, ['token']);
    console.log("EnxRoom.js",this.props.eventHandlers);
    console.log("EnxRoom.js",this.props.localInfo);
    const roomEvents = sanitizeRoomEvents(this.props.eventHandlers);
    setNativeEvents(roomEvents);
    
const info=sanitizeLocalInfoData(this.props.localInfo);
    Enx.joinRoom(token.token,info)
    // Enx.connect(token.token);
    //  this.createRoom(token);  
    } catch (error) {
       console.log("EnxRoom.js componentWillMount",error);
    } 
  }

   componentDidUpdate(previousProps) {
     console.log("componentDidUpdate");
     
    const useDefault = (value, defaultValue) => (value === undefined ? defaultValue : value);
    const shouldUpdate = (key, defaultValue) => {
      const previous = useDefault(previousProps[key], defaultValue);
      const current = useDefault(this.props[key], defaultValue);
      return previous !== current;
    };

    const updateRoomProperty = (key, defaultValue) => {
      if (shouldUpdate(key, defaultValue)) {
        const value = useDefault(this.props[key], defaultValue);
        console.log("updateRoomProperty");
      }
    };

    updateRoomProperty('room', {});
  }

  render() {
    const { style } = this.props;

    if (this.props.children) {
      const childrenWithProps = Children.map(
        this.props.children,
        child => (child ? cloneElement(
          child,
          {
            token: this.props.token,
          },
        ) : child),
      );
      return <View style={style}>{ childrenWithProps }</View>;
    }
    return <View />;
  }
}

EnxRoom.propTypes = {
  token: PropTypes.string.isRequired,
  children: PropTypes.oneOfType([
    PropTypes.element,
    PropTypes.arrayOf(PropTypes.element),
  ]),
  style: ViewPropTypes.style,
  eventHandlers: PropTypes.object, 
  localInfo:PropTypes.object,
};

EnxRoom.defaultProps = {
  eventHandlers: {},
  style: {
    flex: 1
  },
};
