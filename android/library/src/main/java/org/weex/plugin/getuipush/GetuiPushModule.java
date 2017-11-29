package org.weex.plugin.getuipush;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import com.alibaba.weex.plugin.annotation.WeexModule;
import com.igexin.sdk.PushManager;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import java.util.Map;

@WeexModule(name = "getuiPush")
public class GetuiPushModule extends WXModule {

    static JSCallback onRegisterClientCallBack;
    static JSCallback onReceivePayloadDataCallBack;

    //sync ret example
    //TODO: Auto-generated method example
    @JSMethod
    public String syncRet(String param) {
        return param;
    }

    //async ret example
    //TODO: Auto-generated method example
    @JSMethod
    public void asyncRet(String param, JSCallback callback) {
        callback.invoke(param);
    }

    @JSMethod
    public void initPush(Map param) {

        Log.d("param",param.toString());
        PushManager.getInstance().initialize(this.mWXSDKInstance.getContext(), DemoPushService.class);
        PushManager.getInstance().registerPushIntentService(this.mWXSDKInstance.getContext(), PushIntentService.class);
    }

    @JSMethod(uiThread = true)
    public void onRegisterClient(JSCallback callback){

        GetuiPushModule.onRegisterClientCallBack = callback;

    }

    @JSMethod(uiThread = true)
    public void onReceivePayloadData(JSCallback callback){

        GetuiPushModule.onReceivePayloadDataCallBack = callback;

    }

//    public void sendNotification(Map message) {
//
//        Context context = this.mWXSDKInstance.getContext();
//
//        long when = System.currentTimeMillis(); // 通知产生的时间，会在通知信息里显示
//        String content = message.getContent();
//        String title = message.getTitle();
//        String type = message.getType();
//        String text = "";
//        if (Tools.isNull(content)) {
//            text = "你有一条新的系统消息！";
//        } else {
//            text = content;
//        }
//
//        Intent resultIntent = new Intent();
//        Bundle bundle = new Bundle();
//        if (!isApplicationBroughtToBackground(context)) {
//            if (message.getType().equals("1")) {
//                // 系统消息
//                resultIntent.setClass(context, MessageActivity.class);
//            } else if (message.getType().equals("2")) {
//                // 订单消息
//                resultIntent.setClass(context, MessageActivity.class);
//            }
//        } else {
//            resultIntent.setClass(context, MainActivity.class);
//            bundle.putInt("type", Tools.formatInt(type));
//            resultIntent.putExtras(bundle);
//        }
//        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(
//                context).setSmallIcon(R.mipmap.ic_launcher).setWhen(when).setDefaults(Notification.DEFAULT_SOUND)
//                .setContentTitle(title)
//                .setContentText(text);
//        mBuilder.setTicker(text);//第一次提示消息的时候显示在通知栏上
//        mBuilder.setAutoCancel(true);//自己维护通知的消失
//
//        //封装一个Intent
//        PendingIntent resultPendingIntent = PendingIntent.getActivity(
//                context, 0, resultIntent,
//                PendingIntent.FLAG_UPDATE_CURRENT);
//        // 设置通知主题的意图
//        mBuilder.setContentIntent(resultPendingIntent);
//        //获取通知管理器对象
//        NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//        mNotificationManager.notify(0, mBuilder.build());
//    }


}