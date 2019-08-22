package com.rnenxrtc;

import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

import com.facebook.react.uimanager.ThemedReactContext;

import java.util.concurrent.ConcurrentHashMap;

import enx_rtc_android.Controller.EnxPlayerView;
import enx_rtc_android.Controller.EnxStream;

public class EnxPlayerLayout extends FrameLayout {

    EnxRN sharedState;
    ThemedReactContext mReactContext;
    String mStreamId;
    public EnxPlayerLayout(ThemedReactContext reactContext) {
        super(reactContext);
        sharedState = EnxRN.getSharedState();
        mReactContext = reactContext;
    }

    public void createPublisherView(String streamId) {
        mStreamId=streamId;
        mReactContext.getCurrentActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                //put playerview in hashmap
                ConcurrentHashMap<String, EnxPlayerView> mPlayers = sharedState.getPlayerView();
                EnxPlayerView enxPlayerView = new EnxPlayerView(getContext(), EnxPlayerView.ScalingType.SCALE_ASPECT_FIT
                        , false);
                mPlayers.put(mStreamId, enxPlayerView);

                FrameLayout mContainer = new FrameLayout(getContext());
                mContainer.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.MATCH_PARENT));
//                mContainer.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT));
//                mContainer.setFitsSystemWindows(true);
                ConcurrentHashMap<String, FrameLayout> mLocalStreamViewContainers = sharedState.getStreamViewContainers();
                mLocalStreamViewContainers.put(mStreamId, mContainer);
                addView(mLocalStreamViewContainers.get(mStreamId), 0);
                if (mLocalStreamViewContainers.get(mStreamId).getChildCount() > 0) {
                    View temp1 = mLocalStreamViewContainers.get(mStreamId).getChildAt(0);
                    mLocalStreamViewContainers.get(mStreamId).removeView(temp1);
                }
                ConcurrentHashMap<String, EnxPlayerView> playerViews = sharedState.getPlayerView();
                mLocalStreamViewContainers.get(mStreamId).addView( playerViews.get(mStreamId));


                //get playerview from hashmap
                ConcurrentHashMap<String, EnxPlayerView> mPlayersView = sharedState.getPlayerView();
                EnxPlayerView enxPlayerView1 = mPlayersView.get(mStreamId);
                if (mStreamId.length() > 2) {
                    ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getLocalStream();
                    EnxStream localStream = mEnxStream.get(mStreamId);
                    if (localStream != null) {
                        enxPlayerView1.setZOrderMediaOverlay(true);
                        localStream.attachRenderer(enxPlayerView1);
                    }
                } else {
                    ConcurrentHashMap<String, EnxStream> mEnxStream = sharedState.getRemoteStream();
                    EnxStream remoteStream = mEnxStream.get(mStreamId);
                    remoteStream.attachRenderer(enxPlayerView1);
                }
                requestLayout();
            }
        });
    }
}

