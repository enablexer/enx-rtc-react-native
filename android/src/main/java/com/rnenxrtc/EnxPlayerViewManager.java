package com.rnenxrtc;

import android.util.Log;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;


public class EnxPlayerViewManager extends ViewGroupManager<EnxPlayerLayout> {

    ReactContext mReactContext;

    @Override
    public String getName() {
        return this.getClass().getSimpleName();
    }

    @Override
    protected EnxPlayerLayout createViewInstance(ThemedReactContext reactContext) {
//        mReactContext=reactContext;
        return new EnxPlayerLayout(reactContext);
    }

    @ReactProp(name = "streamId")
    public void setStreamId(EnxPlayerLayout view, String streamId) {
        Log.e("setStreamId", streamId);
        view.createPublisherView(streamId);
    }
}

