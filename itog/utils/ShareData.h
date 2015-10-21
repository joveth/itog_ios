//
//  ShareData.h
//  Isaac
//
//  Created by Shuwei on 15/7/23.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlogBean.h"

@interface ShareData : NSObject

@property(atomic,retain) NSString *title;
@property(atomic,retain) NSString *url;
@property(atomic,retain) BlogBean *blog;
@property(atomic,assign) BOOL flag;
@property(atomic,retain) NSString *nexPageUrl;
+(ShareData *) shareInstance;
@end
