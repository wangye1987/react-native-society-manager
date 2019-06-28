//
//  SocietyMacros.h
//  MTDComponents
//
//  Created by 国家电网 on 2019/6/18.
//  Copyright © 2019 Facebook. All rights reserved.
//

#ifndef SocietyMacros_h
#define SocietyMacros_h

typedef NS_ENUM(NSInteger , MTDPlatform) {
  MTDWeixinPlatform = 0,
};

///wx @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
static NSString *kAuthScope  = @"snsapi_userinfo";
static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
static NSString *kAuthState  = @"MTD";

// error 
#define INVOKE_FAILED (@"API invoke returns false.")

// define type constants
#define RCTWXEventName @"SocietyLogin_Resp"


#endif /* SocietyMacros_h */
