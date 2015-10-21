//
//  MainService.h
//  FirstDemo
//
//  Created by jov jov on 6/6/15.
//  Copyright (c) 2015 jov jov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IGHTMLQuery.h"
#import "BlogBean.h"
#import "ShareData.h"
#import "TFHpple.h"
@interface MainService : NSObject


typedef void (^CallBack)(NSArray *result);
typedef void (^CallBackMutable)(NSMutableArray *result);
typedef void (^CallBackString)(NSString *result);
typedef void (^ErrorCallBack)(NSInteger code);
typedef void (^CallBackMutAndPage)(NSMutableArray *result,NSInteger total);
+(void) getBlogs:(NSInteger )pageno andType:(NSInteger)type andSuccess:(CallBackMutable)callback andError:(ErrorCallBack)err;
+(NSMutableArray *)analyzeArticle:(NSInteger)type andNode:(IGHTMLDocument* )node;
+(NSString *)analyzeBlog:(NSInteger)type andNode:(IGHTMLDocument* )node;
+(NSString *)getURL:(NSInteger)type andPageno:(NSInteger )pageno;
+(void)getBlogContent:(NSString *)url andType:(NSInteger)type andSuccess:(CallBackString)callback andError:(ErrorCallBack)err;

@end
