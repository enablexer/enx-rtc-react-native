import React, { Component } from 'react';
import { PropTypes } from 'prop-types';
import { requireNativeComponent, Platform, View } from 'react-native';

class EnxPlayerView extends Component {
  render() {
    return <ReactPlayer {...this.props} />;
  }
}
const viewPropTypes = View.propTypes;
EnxPlayerView.propTypes = {
   streamId: PropTypes.string.isRequired,  
  ...viewPropTypes,
};

const localStreamName = Platform.OS === 'ios' ? 'EnxPlayerViewSwift' : 'EnxPlayerViewManager';
const ReactPlayer = requireNativeComponent(localStreamName, EnxPlayerView);
export default EnxPlayerView;
