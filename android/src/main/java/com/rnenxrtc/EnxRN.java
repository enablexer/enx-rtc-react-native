package com.rnenxrtc;

import android.widget.FrameLayout;

import java.util.concurrent.ConcurrentHashMap;

import enx_rtc_android.Controller.EnxPlayerView;
import enx_rtc_android.Controller.EnxStream;

public class EnxRN {
    public static EnxRN sharedState;


    private ConcurrentHashMap<String, FrameLayout> mPlayerViewContainers = new ConcurrentHashMap<>();
    private ConcurrentHashMap<String, EnxPlayerView> mLocalPlayerView = new ConcurrentHashMap<>();
    private ConcurrentHashMap<String, EnxStream> mLocalStream = new ConcurrentHashMap<>();
    private ConcurrentHashMap<String, EnxStream> mRemoteStream = new ConcurrentHashMap<>();


    public static synchronized EnxRN getSharedState() {

        if (sharedState == null) {
            sharedState = new EnxRN();
        }
        return sharedState;
    }

    public ConcurrentHashMap<String, FrameLayout> getStreamViewContainers() {

        return this.mPlayerViewContainers;
    }

    public ConcurrentHashMap<String, EnxPlayerView> getPlayerView() {

        return this.mLocalPlayerView;
    }

    public ConcurrentHashMap<String, EnxStream> getLocalStream() {

        return this.mLocalStream;
    }

    public ConcurrentHashMap<String, EnxStream> getRemoteStream() {

        return this.mRemoteStream;
    }

    private EnxRN() {
    }

}
