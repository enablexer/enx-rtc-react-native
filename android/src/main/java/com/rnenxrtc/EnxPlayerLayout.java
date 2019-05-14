package com.rnenxrtc;

import android.view.View;
import android.widget.FrameLayout;

import com.facebook.react.uimanager.ThemedReactContext;

import java.util.concurrent.ConcurrentHashMap;

import enx_rtc_android.Controller.EnxPlayerView;
import enx_rtc_android.Controller.EnxStream;

public class EnxPlayerLayout extends FrameLayout {

    EnxRN sharedState;

    public EnxPlayerLayout(ThemedReactContext reactContext) {
        super(reactContext);
        sharedState = EnxRN.getSharedState();
    }

    public void createPublisherView(String streamId) {
        //put playerview in hashmap
        ConcurrentHashMap<String, EnxPlayerView> mPlayers = sharedState.getPlayerView();
        EnxPlayerView enxPlayerView = new EnxPlayerView(getContext(), EnxPlayerView.ScalingType.SCALE_ASPECT_BALANCED, true);
        mPlayers.put(streamId, enxPlayerView);

        //get playerview from hashmap
        ConcurrentHashMap<String, EnxPlayerView> mPlayersView = sharedState.getPlayerView();
        EnxPlayerView enxPlayerView1 = mPlayersView.get(streamId);
        if (streamId.length() > 2) {
            ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getLocalStream();
            EnxStream localStream = mEnxStream.get(streamId);
            if (localStream != null) {
//                enxPlayerView1.setZOrderMediaOverlay(true);;
                localStream.attachRenderer(enxPlayerView1);
            }
        } else {
            ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getRemoteStream();
            EnxStream remoteStream = mEnxStream.get(streamId);
            enxPlayerView1.setZOrderMediaOverlay(false);
            remoteStream.attachRenderer(enxPlayerView1);
        }

        FrameLayout mContainer = new FrameLayout(getContext());
        ConcurrentHashMap<String, FrameLayout> mLocalStreamViewContainers = sharedState.getLocalStreamViewContainers();
        mLocalStreamViewContainers.put(streamId, mContainer);
        addView(mLocalStreamViewContainers.get(streamId), 0);
        if (mLocalStreamViewContainers.get(streamId).getChildCount() > 0) {
            View temp1 = mLocalStreamViewContainers.get(streamId).getChildAt(0);
            mLocalStreamViewContainers.get(streamId).removeView(temp1);
        }
        mLocalStreamViewContainers.get(streamId).addView(enxPlayerView);
        requestLayout();
    }
}

