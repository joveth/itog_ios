//
//  DBHelper.m
//  Isaac
//
//  Created by Shuwei on 15/7/2.
//  Copyright (c) 2015年 Shuwei. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabase.h"
#import "Common.h"

@interface DBHelper(){
    FMDatabase *db;
}
@end

static const NSString *TB_SETTING = @"tb_setting";
static const NSString *TB_BLOG_NEWS = @"tb_blog_news";


@implementation DBHelper
+(id)sharedInstance{
    static DBHelper *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        sharedInstance = [[super alloc]init];
    });
    return sharedInstance;
}
-(BOOL)openDB{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:@"itog.sqlite"];
    
    // 1.获得数据库对象
    db = [FMDatabase databaseWithPath:fileName];
    // 2.打开数据库
    if ([db open]) {
        NSLog(@"打开成功");
        // 2.1创建表
        NSString *sql = @"CREATE TABLE IF NOT EXISTS %@ (tkey varchar(40) PRIMARY KEY NOT NULL,tvalue varchar(40))";
        BOOL success =  [db executeUpdate:[NSString stringWithFormat:sql,TB_SETTING]];
        
        sql = @"CREATE TABLE IF NOT EXISTS %@ (link varchar(200) PRIMARY KEY NOT NULL, title varchar(100),image varchar(30),desc varchar(500) ,content varchar(100),author varchar(40),reads varchar(40),comments varchar(40),cdate varchar(40),sorttype varchar(40),type char(1) )";
        
        success =  [db executeUpdate:[NSString stringWithFormat:sql,TB_BLOG_NEWS]];
        return success;
    }else{
        return NO;
    }
}

-(BOOL)saveOrUpdateKeyValue:(NSString *)key andValue:(NSString *)value{
    if(![db open])
    {
        return NO;
    }
    BOOL ret;
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@  where tkey=?",TB_SETTING],key];
    if ([rs next]) {
        ret = [db executeUpdate:[NSString stringWithFormat:@"update  %@  set tvalue=? where tkey=? ",TB_SETTING],value,key];
        
    }else{
        NSString *sql = [NSString stringWithFormat:@"insert into %@(tkey,tvalue) values(?,?)",TB_SETTING];
        ret = [db executeUpdate:sql,key,value];
    }
    [rs close];
    [db close];
    return ret;
}
-(NSString *)getValueByKey:(NSString *)key{
    if(![db open]){
        return nil;
    }
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@  where tkey=?",TB_SETTING],key];
    NSString *ret;
    if ([rs next]) {
        NSDictionary *dict = [rs resultDictionary];
        ret = dict[@"tvalue"];
    }
    [rs close];
    [db close];
    return ret;
}
-(BOOL)saveBlog:(BlogBean *)bean{
    if(![db open])
    {
        return NO;
    }
    BOOL ret;
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@  where link=?",TB_BLOG_NEWS],bean.link];
    if ([rs next]) {
        ret = [db executeUpdate:[NSString stringWithFormat:@"update  %@  set title=?,image=?,desc=?,content=?,author=?,reads=?,comments=?,cdate=?,sorttype=?, type=? where link=? ",TB_BLOG_NEWS],bean.title,bean.image,bean.desc,bean.content,bean.author,bean.reads,bean.comments,bean.cdate,bean.sortType,bean.type,bean.link];
    }else{
        NSString *sql = [NSString stringWithFormat:@"insert into %@(link,title,image,desc,content,author,reads,comments,cdate,sorttype,type)                  values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",TB_BLOG_NEWS,bean.link,bean.title,bean.image,bean.desc,bean.content,bean.author,bean.reads,bean.comments,bean.cdate,bean.sortType,[NSString stringWithFormat:@"%ld",bean.type]];
        @try {
            ret = [db executeUpdate:sql];
        }
        @catch (NSException *exception) {
            NSLog(@"exce:%@",exception);
        }
        @finally {
            
        }
    }
    [rs close];
    [db close];
    return ret;
}
-(NSMutableArray *)getBlogsByType:(NSInteger)type{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    if(![db open])
    {
        return ret;
    }
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@  where type=? ",TB_BLOG_NEWS],type];
    BlogBean *bean;
    while ([rs next]) {
        NSDictionary *dict = [rs resultDictionary];
        bean = [[BlogBean alloc] init];
        bean.link = dict[@"link"];
        bean.title = dict[@"title"];
        bean.image = dict[@"image"];
        bean.desc = dict[@"desc"];
        bean.content = dict[@"content"];
        bean.author = dict[@"author"];
        bean.reads = dict[@"reads"];
        bean.comments = dict[@"comments"];
        bean.cdate = dict[@"cdate"];
        bean.sortType = dict[@"sorttype"];
        NSString *type =dict[@"type"];
        if(type){
            bean.type = [type integerValue];
        }
        [ret addObject:bean];
    }
    [rs close];
    [db close];
    return ret;
}
-(NSMutableArray *)getAllBlogs{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    if(![db open])
    {
        return ret;
    }
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@  ",TB_BLOG_NEWS]];
    BlogBean *bean;
    while ([rs next]) {
        NSDictionary *dict = [rs resultDictionary];
        bean = [[BlogBean alloc] init];
        bean.link = dict[@"link"];
        bean.title = dict[@"title"];
        bean.image = dict[@"image"];
        bean.desc = dict[@"desc"];
        bean.content = dict[@"content"];
        bean.author = dict[@"author"];
        bean.reads = dict[@"reads"];
        bean.comments = dict[@"comments"];
        bean.cdate = dict[@"cdate"];
        bean.sortType = dict[@"sorttype"];
        NSString *type =dict[@"type"];
        if(type){
            bean.type = [type integerValue];
        }
        [ret addObject:bean];
    }
    [rs close];
    [db close];
    return ret;
}
-(void)deleteBlogs:(NSInteger)type{
    if(![db open])
    {
        return ;
    }
    [db executeUpdate:[NSString stringWithFormat:@"delete from %@  where type=? ",TB_BLOG_NEWS],type];
    [db close];
    return ;
}
-(void)deleteAllBlogs{
    if(![db open])
    {
        return ;
    }
    [db executeUpdate:[NSString stringWithFormat:@"delete from %@  ",TB_BLOG_NEWS]];
    [db close];
    return ;
}
-(BlogBean *)getBlogByLink:(NSString *)link{
    if(![db open])
    {
        return nil;
    }
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select * from %@  where link=? ",TB_BLOG_NEWS],link];
    BlogBean *bean;
    if ([rs next]) {
        NSDictionary *dict = [rs resultDictionary];
        bean = [[BlogBean alloc] init];
        bean.link = dict[@"link"];
        bean.title = dict[@"title"];
        bean.image = dict[@"image"];
        bean.desc = dict[@"desc"];
        bean.content = dict[@"content"];
        bean.author = dict[@"author"];
        bean.reads = dict[@"reads"];
        bean.comments = dict[@"comments"];
        bean.cdate = dict[@"cdate"];
        bean.sortType = dict[@"sorttype"];
        NSString *type =dict[@"type"];
        if(type){
            bean.type = [type integerValue];
        }
    }
    [rs close];
    [db close];
    return bean;
}
@end
