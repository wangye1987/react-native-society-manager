
#import "SocietyManager.h"
#import <React/RCTEventDispatcher.h>
#import <React/RCTBridge.h>
#import "SocietyCallbackManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SocietyMacros.h"

@interface SocietyManager ()<CallbackManagerDelegate>

@property (nonatomic , copy) NSString *appId;

@end


@implementation SocietyManager

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE()

- (instancetype)init
{
    self = [super init];
    if (self) {
        [SocietyCallbackManager sharedManager].delegate = self;
    }
    return self;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

/**
 * 是否安装
 */
RCT_EXPORT_METHOD(isAppInstalled:(NSInteger)platform
                  :(RCTPromiseResolveBlock)resolve
                  :(RCTPromiseRejectBlock)reject){
    BOOL isInstall = false;
    switch (platform) {
        case MTDWeixinPlatform:
            isInstall = [WXApi isWXAppInstalled];
            break;
        default:
            break;
    }
    if (isInstall) {
        resolve(@(true));
    }else{
        reject(@"error",@"0",[NSError errorWithDomain:NSURLErrorKey code:0 userInfo:nil]);
    }
}

/**
 * 注册APPID
 */
RCT_EXPORT_METHOD(registerApp:(NSString *)appid
                  :(NSInteger)platform
                  :(RCTPromiseResolveBlock)resolve
                  :(RCTPromiseRejectBlock)reject)
{
    self.appId = appid;
    BOOL success = false;
    switch (platform) {
        case MTDWeixinPlatform:
            success = [WXApi registerApp:appid];
            break;
        default:
            break;
    }
    if (success) {
        resolve(@(true));
    }else{
        reject(@"error",@"0",[NSError errorWithDomain:NSURLErrorKey code:0 userInfo:nil]);
    }
}

/**
 * 发送认证请求
 */
RCT_EXPORT_METHOD(sendAuthRequest:(NSInteger)platform
                  :(RCTPromiseResolveBlock)resolve
                  :(RCTPromiseRejectBlock)reject)
{
    BOOL success = false;
    
    switch (platform) {
        case MTDWeixinPlatform:{
            SendAuthReq* req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"MTD";
            success = [WXApi sendReq:req];
        }
            break;
        default:
            break;
    }
    
    if (success) {
        resolve(@(true));
    }else{
        reject(@"error",@"0",[NSError errorWithDomain:NSURLErrorKey code:0 userInfo:nil]);
    }
    
}

#pragma mark - CallbackManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response body:(NSMutableDictionary *)body{
    
    if (response.errCode == WXSuccess) {
        if (self.appId && response) {
            [body addEntriesFromDictionary:@{@"appid":self.appId, @"code":response.code}];
            [self.bridge.eventDispatcher sendDeviceEventWithName:RCTWXEventName body:body];
        }
    }
    else {
        [self.bridge.eventDispatcher sendDeviceEventWithName:RCTWXEventName body:body];
    }
}

@end
  
