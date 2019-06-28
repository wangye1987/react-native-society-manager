//
//  SocietyCallbackManager.h
//  MTDComponents
//
//  Created by 国家电网 on 2019/6/17.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol CallbackManagerDelegate <NSObject>

@optional

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response body:(NSMutableDictionary*)body;

@end


@interface SocietyCallbackManager : NSObject<WXApiDelegate>

@property(nonatomic , weak) id<CallbackManagerDelegate>delegate;

+(instancetype)sharedManager ;

@end

