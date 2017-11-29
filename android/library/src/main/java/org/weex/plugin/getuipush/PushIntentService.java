package org.weex.plugin.getuipush;

import android.app.IntentService;
import android.content.Intent;
import android.content.Context;
import android.util.Log;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.igexin.sdk.GTIntentService;
import com.igexin.sdk.PushManager;
import com.igexin.sdk.message.GTCmdMessage;
import com.igexin.sdk.message.GTTransmitMessage;
import com.taobao.weex.bridge.JSCallback;

import java.lang.reflect.Array;
import java.util.Map;

/**
 * An {@link IntentService} subclass for handling asynchronous task requests in
 * a service on a separate handler thread.
 * <p>
 * TODO: Customize class - update intent actions, extra parameters and static
 * helper methods.
 */
public class PushIntentService extends GTIntentService {

    public PushIntentService() {

    }

    @Override
    public void onReceiveServicePid(Context context, int pid) {

        Log.e("onReceiveOnlineState", pid+"");

    }

    @Override
    public void onReceiveMessageData(Context context, GTTransmitMessage msg) {

        Log.e("onReceiveMessageData", "onReceiveMessageData");

        byte[] payload = msg.getPayload();

        Map json = (Map) JSON.parse(new String(payload));

        GetuiPushModule.onReceivePayloadDataCallBack.invokeAndKeepAlive(json);
    }

    @Override
    public void onReceiveClientId(Context context, String clientid) {

        GetuiPushModule.onRegisterClientCallBack.invoke(clientid);

        Log.e(TAG, "onReceiveClientId -> " + "clientid = " + clientid);
    }

    @Override
    public void onReceiveOnlineState(Context context, boolean online) {
        Log.e("onReceiveOnlineState", String.valueOf(online));

    }

    @Override
    public void onReceiveCommandResult(Context context, GTCmdMessage cmdMessage) {

        Log.e("onReceiveOnlineState", "onReceiveCommandResult");

    }
}
