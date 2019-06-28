//
//  SocietyCallbackManager.m
//  MTDComponents
//
//  Created by 国家电网 on 2019/6/17.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "SocietyCallbackManager.h"
#import "SocietyMacros.h"

@implementation SocietyCallbackManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
  static dispatch_once_t onceToken;
  static SocietyCallbackManager *instance;
  dispatch_once(&onceToken, ^{
    instance = [[SocietyCallbackManager alloc] init];
  });
  return instance;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:@"RCTOpenURLNotification" object:nil];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notify 回调处理
- (BOOL)handleOpenURL:(NSNotification *)aNotification
{
  NSString * aURLString =  [aNotification userInfo][@"url"];
  NSURL * aURL = [NSURL URLWithString:aURLString];
  
  if ([WXApi handleOpenURL:aURL delegate:self])
  {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req{
  
}

- (void)onResp:(BaseResp *)resp{
  if ([resp isKindOfClass:[SendAuthResp class]]) {
    if (_delegate
        && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:body:)]) {
      SendAuthResp *authResp = (SendAuthResp *)resp;
      NSMutableDictionary *body = @{@"errCode":@(authResp.errCode)}.mutableCopy;
      body[@"errStr"] = authResp.errStr;
      body[@"state"] = authResp.state;
      body[@"lang"] = authResp.lang;
      body[@"country"] =authResp.country;
      body[@"platform"]= @(MTDWeixinPlatform);
      body[@"type"] = @"SendAuth.Resp";
      
      [_delegate managerDidRecvAuthResponse:authResp body:body];
    }
  }
}

@end
