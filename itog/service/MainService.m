//
//  MainService.m
//  FirstDemo
//
//  Created by jov jov on 6/6/15.
//  Copyright (c) 2015 jov jov. All rights reserved.
//

#import "MainService.h"
#import "ShareData.h"

@implementation MainService

+(void) getBlogs:(NSInteger )pageno andType:(NSInteger)type andSuccess:(CallBackMutable)callback andError:(ErrorCallBack)err{
    @try {
        NSString *URI_BLOG = [self getURL:type andPageno:pageno];
        NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:URI_BLOG] ];
        IGHTMLDocument* node = [[IGHTMLDocument alloc] initWithHTMLData:htmlData encoding:nil error:nil];
        if(callback){
            callback([self analyzeArticle:type andNode:node]);
        }
    }
    @catch (NSException *exception) {
        if(err){
            err(404);
        }
    }
    @finally {
        
    }
}
+(NSMutableArray *)analyzeArticle:(NSInteger)type andNode:(IGHTMLDocument* )node {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    switch (type) {
        case 1:{
            NSArray *arr =[[node queryWithXPath:@"//div[@class='blog_list']"]  allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *h1 = [[contentNode queryWithXPath:@"//h1"] firstObject];
                    
                    NSArray *as = [[h1 children ]allObjects];
                    if(as&&[as count]>0){
                        IGXMLNode *cag=[[contentNode queryWithXPath:@"//a[@class='category']"] firstObject];
                        if(cag){
                            bean.sortType=[cag text];
                        }else{
                            bean.sortType=@"";
                        }
                        if([as count]>2){
                            IGXMLNode *title_a = [as objectAtIndex:1];
                            bean.title=[title_a text];
                            bean.link = [title_a attribute:@"href"];
                        }else{
                            NSInteger index=0;
                            if(cag){
                                index=1;
                            }
                            IGXMLNode *title_a = [as objectAtIndex:index];
                            bean.title=[title_a text];
                            bean.link = [title_a attribute:@"href"];
                            
                        }
                    }
                    IGXMLNode *dd = [[contentNode queryWithXPath:@"//dd"] firstObject];
                    bean.desc = [dd text];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    IGXMLNode *span = [[contentNode queryWithXPath:@"//span[@class='fl']"] firstObject];
                    NSArray *spans = [[span children ]allObjects];
                    if(spans&&[spans count]>=4){
                        bean.author = [[spans objectAtIndex:0] text];
                        bean.cdate = [[spans objectAtIndex:1] text];
                        bean.reads =[[spans objectAtIndex:2] text];
                        bean.comments =[[spans objectAtIndex:3] text];
                    }
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 2:{
            NSArray *arr =[[node queryWithXPath:@"//div[@class='post_item_body']"]  allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *h3 = [[contentNode queryWithXPath:@"//h3"] firstObject];
                    NSArray *as = [[h3 children ]allObjects];
                    if(as&&[as count]>=1){
                        bean.sortType=@"";
                        IGXMLNode *title_a = [as objectAtIndex:0];
                        bean.title=[title_a text];
                        bean.link = [title_a attribute:@"href"];
                    }
                    IGXMLNode *p = [[contentNode queryWithXPath:@"//p[@class='post_item_summary']"] firstObject];
                    bean.desc = [p text];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    IGXMLNode *span = [[contentNode queryWithXPath:@"//div[@class='post_item_foot']"] firstObject];
                    bean.author=[span text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@" " withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 3:{
            //RecentBlogs
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@id='RecentBlogs']"]  firstObject];
            IGHTMLDocument* recDoc  = [[IGHTMLDocument alloc] initWithHTMLString:[rec html] error:nil];
            IGXMLNode *ul =[[recDoc queryWithXPath:@"//ul[@class='BlogList']"]  firstObject];
            IGHTMLDocument* contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[ul html] error:nil];
            NSArray *lis = [[contentNode queryWithXPath:@"//li" ]allObjects];
            if(lis&&[lis count]>0){
                for(int i=0;i<[lis count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *li = [lis objectAtIndex:i];
                    IGHTMLDocument* content  = [[IGHTMLDocument alloc] initWithHTMLString:[li html] error:nil];
                    IGXMLNode *h3 = [[content queryWithXPath:@"//h3"] firstObject];
                    NSArray *as = [[h3 children ]allObjects];
                    if(as&&[as count]>=1){
                        bean.sortType=@"";
                        IGXMLNode *title_a = [as objectAtIndex:0];
                        bean.title=[title_a text];
                        bean.link = [title_a attribute:@"href"];
                    }
                    IGXMLNode *p = [[content queryWithXPath:@"//p"] firstObject];
                    bean.desc = [p text];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    IGXMLNode *date = [[content queryWithXPath:@"//div[@class='date']"] firstObject];
                    bean.author=[date text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 4:{
            //class="r_li"
            NSArray *arr = [[node queryWithXPath:@"//div[@class='r_li']" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *h4 = [[contentNode queryWithXPath:@"//h4"] firstObject];
                    NSArray *as = [[h4 children ]allObjects];
                    if(as&&[as count]>=1){
                        bean.sortType=@"";
                        IGXMLNode *title_a = [as objectAtIndex:0];
                        bean.title=[title_a text];
                        bean.link = [title_a attribute:@"href"];
                    }
                    IGXMLNode *p = [[contentNode queryWithXPath:@"//p[@class='r_li_txt']"] firstObject];
                    bean.desc = [p text];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    IGXMLNode *span = [[contentNode queryWithXPath:@"//p[@class='r_li_from']"] firstObject];
                    bean.author=[span text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 5:{
            //index_main
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@id='index_main']"]  firstObject];
            NSLog(@"%@",[rec html]);
            IGHTMLDocument* recDoc  = [[IGHTMLDocument alloc] initWithHTMLString:[rec html] error:nil];
            NSArray *blogs = [[recDoc queryWithXPath:@"//div[@class='blog clearfix']" ] allObjects];
            if(blogs&&[blogs count]>0){
                for(int i=0;i<[blogs count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [blogs objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *h3 = [[contentNode queryWithXPath:@"//h3"] firstObject];
                    NSArray *ash3 = [[h3 children ]allObjects];
                    if(ash3&&[ash3 count]>=1){
                        bean.sortType=[[ash3 objectAtIndex:0] text];
                        IGXMLNode *title_a = [ash3 objectAtIndex:1];
                        bean.title=[title_a text];
                        bean.link = [title_a attribute:@"href"];
                    }
                    
                    IGXMLNode *con = [[contentNode queryWithXPath:@"//div[@class='content']"] firstObject];
                    NSArray *as = [[con children ] allObjects];
                    if(as&&[as count]>0){
                        bean.desc = [[as objectAtIndex:1] text];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                    IGXMLNode *infor = [[contentNode queryWithXPath:@"//div[@class='blog_info']"] firstObject];
                    bean.author=[infor text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 6:{
            //csdn news,cnblog news ....
            NSArray *arr = [[node queryWithXPath:@"//div[@class='unit']" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *h1 = [[contentNode queryWithXPath:@"//h1"] firstObject];
                    IGXMLNode *a = [[h1 children ] firstObject];
                    if(a){
                        bean.title=[a text];
                        bean.link = [a attribute:@"href"];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    IGXMLNode *dl = [[contentNode queryWithXPath:@"//dl"] firstObject];
                    IGHTMLDocument  *dlNode  = [[IGHTMLDocument alloc] initWithHTMLString:[dl html] error:nil];
                    IGXMLNode *img = [[dlNode queryWithXPath:@"//img"] firstObject];
                    if(img){
                        bean.image=[img attribute:@"src"];
                    }
                    IGXMLNode *dd = [[dlNode queryWithXPath:@"//dd"] firstObject];
                    bean.desc = [dd text];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    IGXMLNode *h4 = [[contentNode queryWithXPath:@"//h4"] firstObject];
                    bean.author=[h4 text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author = [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 7:{
            //
            NSArray *arr = [[node queryWithXPath:@"//div[@class='news_block']" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  conNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *con = [[conNode queryWithXPath:@"//div[@class='content']"] firstObject];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[con html] error:nil];
                    IGXMLNode *h2 = [[contentNode queryWithXPath:@"//h2"] firstObject];
                    
                    IGXMLNode *a = [[h2 children ] firstObject];
                    if(a){
                        bean.title=[a text];
                        bean.link = [NSString stringWithFormat:@"http://news.cnblogs.com%@",[a attribute:@"href"]];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    IGXMLNode *img = [[contentNode queryWithXPath:@"//img"] firstObject];
                    if(img){
                        bean.image=[img attribute:@"src"];
                    }
                    IGXMLNode *dd = [[contentNode queryWithXPath:@"//div[@class='entry_summary']"] firstObject];
                    if(dd){
                        bean.desc = [dd text];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                    IGXMLNode *h4 = [[contentNode queryWithXPath:@"//div[@class='entry_footer']"] firstObject];
                    bean.author=[h4 text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author = [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@" " withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 8:{
            IGXMLNode *resc = [[node queryWithXPath:@"//div[@id='RecentNewsList']"] firstObject];
            IGHTMLDocument*  ulNode  = [[IGHTMLDocument alloc] initWithHTMLString:[resc html] error:nil];
            IGXMLNode *ul = [[ulNode queryWithXPath:@"//ul[@class='List']"] firstObject];
            IGHTMLDocument*  liNode  = [[IGHTMLDocument alloc] initWithHTMLString:[ul html] error:nil];
            NSArray *arr = [[liNode queryWithXPath:@"//li" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *h2 = [[contentNode queryWithXPath:@"//h2"] firstObject];
                    IGXMLNode *a = [[h2 children ] firstObject];
                    if(a){
                        bean.title=[a text];
                        bean.link = [NSString stringWithFormat:@"http://www.oschina.net%@",[a attribute:@"href"]];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    IGXMLNode *img = [[contentNode queryWithXPath:@"//img"] firstObject];
                    if(img){
                        bean.image=[img attribute:@"src"];
                    }
                    IGXMLNode *dd = [[contentNode queryWithXPath:@"//p[@class='detail']"] firstObject];
                    if(dd){
                        bean.desc = [dd text];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                    IGXMLNode *h4 = [[contentNode queryWithXPath:@"//p[@class='date']"] firstObject];
                    bean.author=[h4 text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author = [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@" " withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 9:{
            NSArray *arr = [[node queryWithXPath:@"//div[@class='content']" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *h3 = [[contentNode queryWithXPath:@"//h3"] firstObject];
                    IGHTMLDocument*  h3Node  = [[IGHTMLDocument alloc] initWithHTMLString:[h3 html] error:nil];
                    IGXMLNode *a = [[h3Node queryWithXPath:@"//a"] firstObject];
                    if(a){
                        bean.title=[a text];
                        bean.link = [NSString stringWithFormat:@"http://www.iteye.com%@",[a attribute:@"href"]];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    NSArray *as = [[contentNode children ] allObjects];
                    if(as&&[as count]>0){
                        bean.desc = [[as objectAtIndex:1] text];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                    IGXMLNode *h4 = [[contentNode queryWithXPath:@"//div[@class='news_info']"] firstObject];
                    bean.author=[h4 text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author = [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@" " withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 10:{
            IGXMLNode *all = [[node queryWithXPath:@"//div[@id='allnews_all']" ] firstObject];
            IGHTMLDocument*  allNode  = [[IGHTMLDocument alloc] initWithHTMLString:[all html] error:nil];
            NSArray *arr = [[allNode queryWithXPath:@"//div[@class='item']" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *title = [[contentNode queryWithXPath:@"//div[@class='title']"] firstObject];
                    IGHTMLDocument*  titleNode  = [[IGHTMLDocument alloc] initWithHTMLString:[title html] error:nil];
                    IGXMLNode *a = [[titleNode queryWithXPath:@"//a"] firstObject];
                    if(a){
                        bean.title=[a text];
                        bean.link = [NSString stringWithFormat:@"http://www.cnbeta.com%@",[a attribute:@"href"]];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    
                    IGXMLNode *img = [[contentNode queryWithXPath:@"//img"] firstObject];
                    if(img){
                        bean.image=[img attribute:@"src"];
                    }
                    IGXMLNode *p = [[contentNode queryWithXPath:@"//p"] firstObject];
                    if(p){
                        bean.desc = [p text];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                    IGXMLNode *author = [[titleNode queryWithXPath:@"//div[@class='tj']"] firstObject];
                    bean.author=[author text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author = [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@" " withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 11:{
            NSArray *arr = [[node queryWithXPath:@"//article" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    IGXMLNode *a = [[contentNode queryWithXPath:@"//a[@class='title info_flow_news_title']"] firstObject];
                    if(a){
                        bean.title=[a text];
                        bean.link = [NSString stringWithFormat:@"http://www.36kr.com%@",[a attribute:@"href"]];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    
                    IGXMLNode *img = [[contentNode queryWithXPath:@"a[@class='pic info_flow_news_image badge-column']"] firstObject];
                    NSLog(@"%@",[img html]);
                    if(img){
                        bean.image=[img attribute:@"data-lazyload"];
                        if(bean.image){
                            NSRange end=[bean.image rangeOfString:@"!"];
                            bean.image = [bean.image substringToIndex:end.location];
                        }
                    }
                    IGXMLNode *p = [[contentNode queryWithXPath:@"//div[@class='brief']"] firstObject];
                    if(p){
                        bean.desc = [p text];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                    IGXMLNode *author = [[contentNode queryWithXPath:@"//div[@class='author']"] firstObject];
                    bean.author=[author text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author = [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@" " withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            //info_flows_next_link
            IGXMLNode *a = [[node queryWithXPath:@"//a[@id='info_flows_next_link']"] firstObject];
            [ShareData shareInstance].nexPageUrl=[NSString stringWithFormat:@"http://www.36kr.com%@",[a attribute:@"href"]];
            
            break;
        }
        case 12:{
            //
            IGXMLNode *all = [[node queryWithXPath:@"//div[@class='mod-info-flow']" ] firstObject];
            NSArray *arr = [[all children ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    NSLog(@"%@",[content html]);
                    IGXMLNode *h3 = [[contentNode queryWithXPath:@"//h3"] firstObject];
                    IGHTMLDocument*  h3Node  = [[IGHTMLDocument alloc] initWithHTMLString:[h3 html] error:nil];
                    NSLog(@"%@",[h3Node html]);
                    IGXMLNode *a = [[h3Node queryWithXPath:@"//a[@class='transition']"] firstObject];
                    if(a){
                        bean.title=[a text];
                        bean.link = [NSString stringWithFormat:@"http://www.huxiu.com%@",[a attribute:@"href"]];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    
                    IGXMLNode *img = [[contentNode queryWithXPath:@"//img[@class='lazy']"] firstObject];
                    if(img){
                        bean.image=[img attribute:@"src"];
                    }
                    IGXMLNode *p = [[contentNode queryWithXPath:@"//div[@class='mob-sub']"] firstObject];
                    if(p){
                        bean.desc = [p text];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                    IGXMLNode *author = [[contentNode queryWithXPath:@"//div[@class='mob-author']"] firstObject];
                    bean.author=[author text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author = [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@" " withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 13:{
            //
            IGXMLNode *all = [[node queryWithXPath:@"//div[@class='article-list']" ] firstObject];
            IGHTMLDocument*  allNode  = [[IGHTMLDocument alloc] initWithHTMLString:[all html] error:nil];
            NSArray *arr = [[allNode queryWithXPath:@"//div[@class='row']" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    IGHTMLDocument*  contentNode  = [[IGHTMLDocument alloc] initWithHTMLString:[content html] error:nil];
                    
                    IGXMLNode *a = [[contentNode queryWithXPath:@"//a[@class='subtitle']"] firstObject];
                    if(a){
                        bean.title=[a text];
                        bean.link = [a attribute:@"href"];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    
                    IGXMLNode *imgA = [[contentNode queryWithXPath:@"//a[@class='img-wrap']"] firstObject];
                    if(imgA){
                        IGHTMLDocument*  imgANode  = [[IGHTMLDocument alloc] initWithHTMLString:[imgA html] error:nil];
                        IGXMLNode *img = [[imgANode queryWithXPath:@"//img"] firstObject];
                        if(img){
                            bean.image=[img attribute:@"src"];
                        }
                    }
                    IGXMLNode *p = [[contentNode queryWithXPath:@"//div[@class='desc']"] firstObject];
                    if(p){
                        bean.desc = [p text];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        bean.desc =[bean.desc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                        bean.desc = [bean.desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    }
                    IGXMLNode *author = [[contentNode queryWithXPath:@"//div[@class='all']"] firstObject];
                    bean.author=[author text];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    bean.author =[bean.author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bean.author = [bean.author stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    bean.author = [bean.author stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                    bean.author= [bean.author stringByReplacingOccurrencesOfString:@" " withString:@""];
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        case 14:{
            IGXMLNode *all = [[node queryWithXPath:@"//ul[@id='all_article']" ] firstObject];
            IGHTMLDocument*  allNode  = [[IGHTMLDocument alloc] initWithHTMLString:[all html] error:nil];
            NSArray *arr = [[allNode queryWithXPath:@"//a" ] allObjects];
            if(arr&&[arr count]>0){
                for(int i=0;i<[arr count];i++){
                    BlogBean *bean = [BlogBean new];
                    IGXMLNode *content = [arr objectAtIndex:i];
                    if(content){
                        bean.title=[content text];
                        bean.link = [content attribute:@"href"];
                        bean.sortType=@"";
                    }else{
                        continue;
                    }
                    
                    bean.desc=@"";
                    bean.author=@"";
                    bean.cdate=@"";
                    bean.reads =@"";
                    bean.comments=@"";
                    [ret addObject:bean];
                }
            }
            break;
        }
        default:
            break;
    }
    return ret;
}
+(NSString *)getURL:(NSInteger)type andPageno:(NSInteger )pageno{
    switch (type) {
        case 1:
            //CSDN
            return [NSString stringWithFormat:@"http://blog.csdn.net/index.html?&page=%ld",pageno];
        case 2:
            //cnblogs
            return [NSString stringWithFormat:@"http://www.cnblogs.com/sitehome/p/%ld",pageno];
        case 3:
            //oschina
            return [NSString stringWithFormat:@"http://www.oschina.net/blog?type=0&p=%ld",pageno];
        case 4:
            //51cto
            return [NSString stringWithFormat:@"http://blog.51cto.com/original/0/%ld",pageno];
        case 5:
            //iteye
            return [NSString stringWithFormat:@"http://www.iteye.com/blogs?page=%ld",pageno];
        case 6:
            return [NSString stringWithFormat:@"http://news.csdn.net/news/%ld",pageno];
        case 7:{
            return [NSString stringWithFormat:@"http://news.cnblogs.com/n/page/%ld",pageno];
        }
        case 8:{
            return [NSString stringWithFormat:@"http://www.oschina.net/news/list?show=industry&p=%ld",pageno];
        }
        case 9:{
            return [NSString stringWithFormat:@"http://www.iteye.com/news?page=%ld",pageno];
        }
        case 10:{
            return @"http://www.cnbeta.com/";
        }
        case 11:{
            if([ShareData shareInstance].nexPageUrl){
                return [ShareData shareInstance].nexPageUrl;
            }else{
                return @"http://www.36kr.com/";
            }
        }
        case 12:{
            return @"http://www.huxiu.com/";
        }
        case 13:{
            return @"http://www.iheima.com/";
        }
        case 14:{
            return @"http://www.cocoachina.com/news/";
        }
        default:
            return @"http://blog.csdn.net/newest.html";
    }
}
+(NSString *)analyzeBlog:(NSInteger)type andNode:(IGHTMLDocument* )node{
    NSString *ret;
    switch (type) {
        case 1:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@id='article_content']"]  firstObject];
            if(rec){
                return [rec html];
            }
            break;
        }
        case 2:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@id='cnblogs_post_body']"]  firstObject];
            if(rec){
                return [rec html];
            }
             break;
        }
        case 3:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@class='BlogContent']"]  firstObject];
            if(rec){
                return [rec html];
            }
            break;
        }
        case 4:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@class='showContent']"]  firstObject];
            if(rec){
                return [rec html];
            }
            break;
        }
        case 5:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@id='blog_content']"]  firstObject];
            if(rec){
                return [rec html];
            }
            break;
        }
        case 6:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@class='detail']"]  firstObject];
            IGHTMLDocument *dlNode  = [[IGHTMLDocument alloc] initWithHTMLString:[rec html] error:nil];
            IGXMLNode *h1 =[[dlNode queryWithXPath:@"//h1"]  firstObject];
            IGXMLNode *h4 =[[dlNode queryWithXPath:@"//h4"]  firstObject];
            IGXMLNode *tag =[[dlNode queryWithXPath:@"//div[@class='tag']"]  firstObject];
            IGXMLNode *summary =[[dlNode queryWithXPath:@"//div[@class='summary']"]  firstObject];
            IGXMLNode *content =[[dlNode queryWithXPath:@"//div[@class='con news_content']"]  firstObject];
            //con news_content
            NSString *html =[h1 html];
            if(h4){
                html = [html stringByAppendingString:[h4 html]];
            }
            if(tag){
                html = [html stringByAppendingString:[tag html]];
            }
            if(summary){
                html = [html stringByAppendingString:[summary html]];
            }
            if(content){
                html = [html stringByAppendingString:[content html]];
            }
            return html;
        }
        case 7:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@id='news_main']"]  firstObject];
            IGHTMLDocument *dlNode  = [[IGHTMLDocument alloc] initWithHTMLString:[rec html] error:nil];
            IGXMLNode *h1 =[[dlNode queryWithXPath:@"//div[@id='news_title']"]  firstObject];
            IGXMLNode *h4 =[[dlNode queryWithXPath:@"//div[@id='news_info']"]  firstObject];
            IGXMLNode *body =[[dlNode queryWithXPath:@"//div[@id='news_body']"]  firstObject];
            //con news_content
            NSString *html =[h1 html];
            if(h4){
                html = [html stringByAppendingString:[h4 html]];
            }
            if(body){
                html = [html stringByAppendingString:[body html]];
            }
            return html;
        }
        case 8:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@class='NewsBody']"]  firstObject];
            IGHTMLDocument *dlNode  = [[IGHTMLDocument alloc] initWithHTMLString:[rec html] error:nil];
            IGXMLNode *h1 =[[dlNode queryWithXPath:@"//h1[@class='OSCTitle']"]  firstObject];
            IGXMLNode *h4 =[[dlNode queryWithXPath:@"//div[@class='PubDate']"]  firstObject];
            IGXMLNode *content =[[dlNode queryWithXPath:@"//div[@class='Body NewsContent TextContent']"]  firstObject];
            //con news_content
            NSString *html =[h1 html];
            if(h4){
                html = [html stringByAppendingString:[h4 html]];
            }
            if(content){
                html = [html stringByAppendingString:[content html]];
            }
            return html;
        }
        case 9:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@id='news_content']"]  firstObject];
            return [rec html];
        }
        case 10:{
            //
            IGXMLNode *rec =[[node queryWithXPath:@"//article"]  firstObject];
            return [rec html];
        }
        case 11:{
            IGXMLNode *rec =[[node queryWithXPath:@"//article"]  firstObject];
            return [rec html];
        }
        case 12:{
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@class='article-wrap']"]  firstObject];
            IGHTMLDocument *dlNode  = [[IGHTMLDocument alloc] initWithHTMLString:[rec html] error:nil];
            IGXMLNode *h1 =[[dlNode queryWithXPath:@"//h1"]  firstObject];
            IGXMLNode *h4 =[[dlNode queryWithXPath:@"//div[@class='article-author']"]  firstObject];
            IGXMLNode *tag =[[dlNode queryWithXPath:@"//div[@class='tag-box ']"]  firstObject];
            IGXMLNode *content =[[dlNode queryWithXPath:@"//div[@id='article_content']"]  firstObject];
            //con news_content
            NSString *html =[h1 html];
            if(h4){
                html = [html stringByAppendingString:[h4 html]];
            }
            if(content){
                html = [html stringByAppendingString:[content html]];
            }
            if(tag){
                html = [html stringByAppendingString:[tag html]];
            }
            return html;
        }
        case 13:{
            //
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@class='main-content col-md-12 col-sm-12 col-xs-12']"]  firstObject];
            return [rec html];
        }
        case 14:{
            //
            IGXMLNode *rec =[[node queryWithXPath:@"//div[@class='detail-main']"]  firstObject];
            return [rec html];
        }
        default:
            break;
    }
    return ret;
}
+(void)getBlogContent:(NSString *)url andType:(NSInteger)type andSuccess:(CallBackString)callback andError:(ErrorCallBack)err{
    @try {
        NSString *URI_BLOG = url;
        NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:URI_BLOG] ];
        IGHTMLDocument* node = [[IGHTMLDocument alloc] initWithHTMLData:htmlData encoding:nil error:nil];
        if(callback){
            callback([self analyzeBlog:type andNode:node]);
        }
    }
    @catch (NSException *exception) {
        if(err){
            err(404);
        }
    }
    @finally {
        
    }
}


@end
