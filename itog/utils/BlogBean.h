//
//  BlogBean.h
//  itog
//
//  Created by Shuwei on 15/10/15.
//  Copyright © 2015年 jov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogBean : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *reads;
@property (nonatomic,copy) NSString *comments;
@property (nonatomic,copy) NSString *cdate;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *sortType;

@end
