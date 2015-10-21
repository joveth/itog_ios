//
//  DBHelper.h
//  Isaac
//
//  Created by Shuwei on 15/7/2.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "BlogBean.h"

typedef void (^BOOLCallBack)(BOOL ret);

@interface DBHelper : NSObject
+(id)sharedInstance;
-(BOOL)openDB;
-(BOOL)saveOrUpdateKeyValue:(NSString *)key andValue:(NSString *)value;
-(NSString *)getValueByKey:(NSString *)key ;
-(BOOL)saveBlog:(BlogBean *)bean;
-(NSMutableArray *)getBlogsByType:(NSInteger)type;
-(NSMutableArray *)getAllBlogs;
-(void)deleteBlogs:(NSInteger)type;
-(void)deleteAllBlogs;
-(BlogBean *)getBlogByLink:(NSString *)link;
@end
