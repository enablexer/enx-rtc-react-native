package com.rnenxrtc;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

import enx_rtc_android.Controller.EnxStream;

public final class EnxUtils {

    protected static WritableMap customJSONObject(String message, String result, String streamId) {
        WritableMap streamInfo = Arguments.createMap();
        streamInfo.putString("result", result);
        streamInfo.putString("msg", message);
        streamInfo.putString("streamId", streamId);
        return streamInfo;
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

    public static WritableArray convertJsonToArray(JSONArray jsonArray) throws JSONException {
        WritableArray writableArray = Arguments.createArray();
        for (int i = 0; i < jsonArray.length(); i++) {
            Object value = jsonArray.get(i);
            if (value instanceof Float || value instanceof Double) {
                writableArray.pushDouble(jsonArray.getDouble(i));
            } else if (value instanceof Number) {
                writableArray.pushInt(jsonArray.getInt(i));
            }else if(value instanceof Boolean){
                writableArray.pushBoolean(jsonArray.getBoolean(i));
            } else if (value instanceof String) {
                writableArray.pushString(jsonArray.getString(i));
            } else if (value instanceof JSONObject) {
                writableArray.pushMap(jsonToReact(jsonArray.getJSONObject(i)));
            } else if (value instanceof JSONArray) {
                writableArray.pushArray(convertJsonToArray(jsonArray.getJSONArray(i)));
            } else if (value == JSONObject.NULL) {
                writableArray.pushNull();
            }
        }
        return writableArray;
    }

    public static WritableMap jsonToReact(JSONObject jsonObject) throws JSONException {
        WritableMap writableMap = Arguments.createMap();
        Iterator iterator = jsonObject.keys();
        while (iterator.hasNext()) {
            String key = (String) iterator.next();
            Object value = jsonObject.get(key);
            if (value instanceof Float || value instanceof Double) {
                writableMap.putDouble(key, jsonObject.getDouble(key));
            } else if (value instanceof Number) {
                writableMap.putInt(key, jsonObject.getInt(key));
            }else if(value instanceof Boolean){
                writableMap.putBoolean(key, jsonObject.getBoolean(key));
            } else if (value instanceof String) {
                writableMap.putString(key, jsonObject.getString(key));
            } else if (value instanceof JSONObject) {
                writableMap.putMap(key, jsonToReact(jsonObject.getJSONObject(key)));
            } else if (value instanceof JSONArray) {
                writableMap.putArray(key, convertJsonToArray(jsonObject.getJSONArray(key)));
            } else if (value == JSONObject.NULL) {
                writableMap.putNull(key);
            }
        }
        return writableMap;
    }

    public static JSONArray convertArrayToJson(ReadableArray readableArray) throws JSONException {
        JSONArray array = new JSONArray();
        for (int i = 0; i < readableArray.size(); i++) {
            switch (readableArray.getType(i)) {
                case Null:
                    break;
                case Boolean:
                    array.put(readableArray.getBoolean(i));
                    break;
                case Number:
                    array.put(readableArray.getDouble(i));
                    break;
                case String:
                    array.put(readableArray.getString(i));
                    break;
                case Map:
                    array.put(convertMapToJson(readableArray.getMap(i)));
                    break;
                case Array:
                    array.put(convertArrayToJson(readableArray.getArray(i)));
                    break;
            }
        }
        return array;
    }

    public static JSONObject convertMapToJson(ReadableMap readableMap) throws JSONException {
        JSONObject object = new JSONObject();
        ReadableMapKeySetIterator iterator = readableMap.keySetIterator();
        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            switch (readableMap.getType(key)) {
                case Null:
                    object.put(key, JSONObject.NULL);
                    break;
                case Boolean:
                    object.put(key, readableMap.getBoolean(key));
                    break;
                case Number:
                    object.put(key, readableMap.getDouble(key));
                    break;
                case String:
                    object.put(key, readableMap.getString(key));
                    break;
                case Map:
                    object.put(key, convertMapToJson(readableMap.getMap(key)));
                    break;
                case Array:
                    object.put(key, convertArrayToJson(readableMap.getArray(key)));
                    break;
            }
        }
        return object;
    }

}
