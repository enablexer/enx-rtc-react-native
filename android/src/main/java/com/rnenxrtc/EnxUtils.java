package com.rnenxrtc;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import enx_rtc_android.Controller.EnxStream;

public final class EnxUtils {

    protected static JSONObject customJSONObject(String message, String result, String streamId) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("result", result);
            jsonObject.put("message", message);
            jsonObject.put("streamId", streamId);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject;
    }

    protected static WritableMap prepareJSStreamMap(EnxStream stream) {
        WritableMap streamInfo = Arguments.createMap();
        if (stream != null) {
            streamInfo.putString("streamId", stream.getId());
            streamInfo.putBoolean("hasScreen", stream.hasScreen());
            streamInfo.putBoolean("hasData", stream.hasData());
        }
        return streamInfo;
    }

    protected static WritableMap prepareJSActiveListMap(JSONArray object) {
        WritableMap streamInfo = Arguments.createMap();
        for (int i = 0; i >= object.length(); i++) {
            streamInfo.putString("mediatype", object.optJSONObject(i).optString("mediatype"));
            streamInfo.putString("streamId", object.optJSONObject(i).optString("streamId"));
            streamInfo.putString("name", object.optJSONObject(i).optString("name"));
            streamInfo.putString("clientId", object.optJSONObject(i).optString("clientId"));
        }
        return streamInfo;
    }

    protected static WritableMap prepareJSShareStreamMap(JSONObject object) {
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", object.optString("result"));
        streamInfo.putString("streamId", object.optString("streamId"));
        streamInfo.putString("name", object.optString("name"));
        streamInfo.putString("clientId", object.optString("clientId"));
        return streamInfo;
    }

    protected static WritableMap prepareJSUserMap(JSONObject object) {
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("name", object.optString("name"));
        streamInfo.putString("user_ref", object.optString("user_ref"));
        streamInfo.putString("role", object.optString("role"));
        streamInfo.putString("clientId", object.optString("clientId"));
        streamInfo.putMap("permissions", prepareJSPermissionMap(object.optJSONObject("permissions")));
        return streamInfo;
    }

    protected static WritableMap prepareJSPermissionMap(JSONObject object) {
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("publish", object.optString("publish"));
        streamInfo.putString("subscribe", object.optString("subscribe"));
        streamInfo.putString("record", object.optString("record"));
        streamInfo.putString("stats", object.optString("stats"));
        streamInfo.putString("controlhandlers", object.optString("controlhandlers"));
        return streamInfo;
    }

    protected static WritableMap prepareJSTalkerMap(JSONObject object) {
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", object.optString("result"));
        streamInfo.putString("msg", object.optString("msg"));
        if (object.has("numTalkers")) {
            streamInfo.putString("numTalkers", object.optString("numTalkers"));
        } else {
            streamInfo.putString("maxTalkers", object.optString("maxTalkers"));
        }
        return streamInfo;
    }

    protected static WritableMap prepareJSResultMap(JSONObject object) {
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", object.optString("result"));
        streamInfo.putString("msg", object.optString("msg"));
        return streamInfo;
    }

    protected static WritableMap prepareJSCCResultMap(JSONObject object) {
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", object.optString("result"));
        streamInfo.putString("msg", object.optString("msg"));
        streamInfo.putString("clientId", object.optString("clientId"));
        return streamInfo;
    }

    protected static WritableMap prepareJSErrorMap(JSONObject jsonObject) {
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putInt("errorCode", jsonObject.optInt("errorCode"));
        streamInfo.putString("msg", jsonObject.optString("msg"));
        return streamInfo;
    }

}
