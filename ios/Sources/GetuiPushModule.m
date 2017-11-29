//
//  GetuiPushModule.m
//  WeexPluginTemp
//
//  Created by  on 17/3/14.
//  Copyright © 2017年 . All rights reserved.
//

#import "GetuiPushModule.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import <GTSDK/GeTuiSdk.h>

@interface GetuiPushModule()

@property(nonatomic,copy)WXModuleKeepAliveCallback onRegisterClientCallBack;
@property(nonatomic,copy)WXModuleKeepAliveCallback onReceivePayloadDataCallBack;

@end

@implementation GetuiPushModule

WX_PlUGIN_EXPORT_MODULE(getuiPush, GetuiPushModule)
WX_EXPORT_METHOD(@selector(initPush:))
WX_EXPORT_METHOD(@selector(onRegisterClient:))
WX_EXPORT_METHOD(@selector(onReceivePayloadData:))
WX_EXPORT_METHOD(@selector(showNotification:))
WX_EXPORT_METHOD(@selector(cancelNotification:))
WX_EXPORT_METHOD(@selector(cancelAllNotification))

/**
 create actionsheet
 
 @param options items
 @param callback
 */
-(void)show
{
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"title" message:@"module getuiPush is created sucessfully" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alertview show];
    
}
//js 初始化个推
- (void)initPush:(NSDictionary *)options
{
    [self startSdkWith:options[@"appId"] appKey:options[@"appKey"] appSecret:options[@"appSecret"]];
    
    //[2]:注册APNS
    [self registerRemoteNotification];
    
    //打开app时候,消除掉badge
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        
        // iOS8以后 本地通知必须注册(获取权限)
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    //［2-EXT]: 获取启动时收到的APN数据
}
- (void)onRegisterClient:(WXModuleKeepAliveCallback)callback
{
    self.onRegisterClientCallBack = callback;
}
- (void)onReceivePayloadData:(WXModuleKeepAliveCallback)callback
{
    self.onReceivePayloadDataCallBack = callback;
}
// 发送本地推送
- (void)showNotification:(NSDictionary *)msgDict
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置通知的提醒时间
    notification.timeZone = [NSTimeZone localTimeZone]; // 使用本地时区
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:20];
    
    notification.fireDate = [NSDate date];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:msgDict];
    
    [userInfo setValue:@"weex-push-key" forKey:[NSString stringWithFormat:@"%d",arc4random()]];
    
    notification.userInfo = userInfo;
    // 设置提醒的文字内容
    notification.alertBody   = msgDict[@"alertBody"];
    if (!notification.alertBody) {
        notification.alertBody = @"您有新的消息";
    }
    // 8.2以后才有alertTitle
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.2f) {
        notification.alertTitle = msgDict[@"alertTitle"] ? msgDict[@"alertTitle"] : @"weex-push-title";
    }
    notification.soundName= UILocalNotificationDefaultSoundName;
    // 将通知添加到系统中
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
// 取消某一个本地推送
- (void)cancelNotification:(NSString *)pushKey
{
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //获取当前所有的本地通知
    if (!notificaitons || notificaitons.count <= 0) {
        return;
    }
    for (UILocalNotification *notify in notificaitons) {
        if ([[notify.userInfo objectForKey:@"weex-push-key"] isEqualToString:pushKey]) {
            //取消一个特定的通知
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
            break;
        }
    }
}
//取消所有的本地通知
- (void)cancelAllNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


/** 注册远程通知 */
- (void)registerRemoteNotification {
    
#ifdef __IPHONE_8_0
    
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}
#pragma mark 个推注册
/// 注册推送失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    [self geTuiApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}
/// 唤醒
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //[5] Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}
/// SDK启动成功返回clientId
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    self.onRegisterClientCallBack(clientId,true);
    NSLog(@"clientId:%@",clientId);
}
/// 如果APNS注册失败通知个推服务器
- (void)geTuiApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    //[3-EXT]:如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]];
}
#pragma mark 启动GeTui
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    // [1-1]:通过 AppId、 appKey 、appSecret 启动SDK
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self];
    // [1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];
    // [1-3]:设置电子围栏功能，开启LBS定位服务 和 是否允许SDK 弹出用户定位请求
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}

/// ios的话 可以把要跳转的信息写到setpushinfo的payload里面 客户端收到payload之后去解析跳转 也可以把跳转信息放到透传消息里面 客户端收到透传之后解析跳转
-(void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    NSDictionary *msgDict = [NSJSONSerialization JSONObjectWithData:payloadData options:NSJSONReadingAllowFragments error:nil];
    self.onReceivePayloadDataCallBack(msgDict,true);
}

/// SDK收到sendMessage消息回调
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    // NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
}
/// SDK遇到错误回调
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"个推错误返回%ld %@",(long)error.code,error.localizedDescription);
}
/// SDK运行状态通知
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)status {
    NSLog(@"%d status 1 启动 2 停止",status);
}

@end
