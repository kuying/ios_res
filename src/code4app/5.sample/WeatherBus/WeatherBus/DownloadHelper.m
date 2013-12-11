//
//  DownloadHelper.m
//  IphoneReader
//
//  Created by TGBUS on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownloadHelper.h"

static DownloadHelper *instance;

@implementation DownloadHelper

@synthesize delegatelist;
@synthesize downlist;

-(void)dealloc
{
    self.delegatelist=nil;
    self.downlist=nil;
    [instance release];
    [super dealloc];
}

+(DownloadHelper *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[DownloadHelper alloc] init];
    }
    return instance;
}

-(void)suspend:(BOOL)flag
{
    [downlist setSuspended:flag];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:flag];
}

-(NSString *)createUrlForRequest:(NSDictionary *)params
{
    NSString *baseUrl=@"http://app.tgbus.com/site/reader/action.ashx?";
    for(NSString *key in [params allKeys])
    {
        baseUrl=[baseUrl stringByAppendingFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    baseUrl=[baseUrl substringToIndex:[baseUrl length]-1];
    return baseUrl;
}

//开始请求种类下的列表数据
//1.传入请求的参数
//2.委托
//3.是某个数据层里区分方法的tag，或者自定义的枚举值
-(void)startRequest:(NSMutableDictionary *)params delegate:(id<DownloadHelperDelegate>)delegate downloadType:(int)downloadType userInfo:(NSMutableDictionary *)userInfo
{
    if(params==nil||delegate==nil)
    {
        NSLog(@"传递的参数为nil");
        return;
    }
    if(downlist==nil)
    {
        downlist=[[NSOperationQueue alloc] init];
        [downlist setMaxConcurrentOperationCount:2];
    }
    if(delegatelist==nil)
    {
        delegatelist=[[NSMutableArray alloc] init];
    }
    if([delegatelist indexOfObject:delegate]>1000)
    {
        [delegatelist addObject:delegate];
    }
    NSString *url=[self createUrlForRequest:params];
    [self startRequest:url delegate:delegate tag:downloadType userInfo:userInfo];
}

-(void)startRequest:(NSString *)url delegate:(id<DownloadHelperDelegate>)delegate tag:(int)tag userInfo:(NSMutableDictionary *)userInfo
{
    [self startRequest:url delegate:delegate tag:tag userInfo:userInfo cancelTagReqeust:NO];
}

-(void)startRequest:(NSString *)url delegate:(id<DownloadHelperDelegate>)delegate tag:(int)tag userInfo:(NSMutableDictionary *)userInfo cancelTagReqeust:(BOOL)cancelTagReqeust
{
    if(cancelTagReqeust)
    {
        [self cancelRequestForTag:tag];
    }
    if(downlist==nil)
    {
        downlist=[[NSOperationQueue alloc] init];
        [downlist setMaxConcurrentOperationCount:2];
    }
    if(delegatelist==nil)
    {
        delegatelist=[[NSMutableArray alloc] init];
    }
    if([delegatelist indexOfObject:delegate]>1000)
    {
        [delegatelist addObject:delegate];
    }
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setShouldRedirect:YES];
    [request setDelegate:self];
    [request setTimeOutSeconds:90.0f];
    NSLog(@"请求的数据请求=%@",request.url);
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    if(userInfo!=nil)
    {
        for(NSString *key in [userInfo allKeys])
        {
            [dict setObject:[userInfo objectForKey:key] forKey:key];
        }
    }
    [dict setObject:[NSNumber numberWithInt:tag] forKey:DownloadTag];
    [dict setObject:delegate forKey:DownloadDelegateKey];
    [request setUserInfo:dict];
    [downlist addOperation:request];
}
#pragma ASI请求委托

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
//    NSLog(@"responseHeaders=%@",responseHeaders);
}
//重定向
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"DownloadHelper下载错误:%@",request.error);
    NSDictionary *dict=[request userInfo];
    id<DownloadHelperDelegate> tmpDelegate=[dict objectForKey:DownloadDelegateKey];
    if([tmpDelegate respondsToSelector:@selector(DownloadFailed:downloadType:)])
    {
        [tmpDelegate DownloadFailed:[NSNumber numberWithInt:request.error.code] downloadType:[dict objectForKey:DownloadTag]];
    }
    if([tmpDelegate respondsToSelector:@selector(DownloadFailed:downloadType:url:)])
    {
        [tmpDelegate DownloadFailed:[NSNumber numberWithInt:request.error.code] downloadType:[dict objectForKey:DownloadTag] url:[request.url description]];
    }
    [request clearDelegatesAndCancel];
    [request release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    //返回数据为nil
    if(request.responseData==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"网络异常" message:@"请检查您的网络连接是否正常!" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSDictionary *dict=[request userInfo];
    id<DownloadHelperDelegate> tmpDelegate=[dict objectForKey:DownloadDelegateKey];
    if([tmpDelegate respondsToSelector:@selector(DownloadFinished:downloadType:)])
    {
        NSMutableDictionary *paramsDict=[[NSMutableDictionary alloc] init];
        [paramsDict setObject:request.responseData  forKey:@"Data"];
        
        for(NSString *key in [dict allKeys])
        {
            [paramsDict setObject:[dict objectForKey:key] forKey:key];
        }
        [tmpDelegate DownloadFinished:paramsDict downloadType:[dict objectForKey:DownloadTag]];
        [paramsDict release];
    }
//    [delegatelist removeObject:tmpDelegate];
    [request release];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)cancelReqeustForDelegate:(id<DownloadHelperDelegate>)delegate
{
    for(ASIHTTPRequest *request in downlist.operations)
    {
         id<DownloadHelperDelegate> tmpDelegate=[request.userInfo objectForKey:DownloadDelegateKey];
        if(tmpDelegate==delegate)
        {
            [request clearDelegatesAndCancel];
            [request release];
        }
    }
//    NSUInteger index=[delegatelist indexOfObject:delegate];
//    if(index<1000)
//    {
//        [delegatelist removeObject:delegate];
//        ASIHTTPRequest *request=[downlist.operations objectAtIndex:index];
//        [request clearDelegatesAndCancel];
//        [request release];
//    }
}

-(void)cancelRequestForTag:(int)_tag
{
    for(ASIHTTPRequest *request in [self.downlist operations])
    {
        NSNumber *tag=[request.userInfo objectForKey:DownloadTag];
        if([tag intValue]==_tag)
        {
            [request clearDelegatesAndCancel];
            [request release];
            break;
        }
    }
}

-(void)cancelRequestForTag:(int)_tag delegate:(id<DownloadHelperDelegate>)delegate
{
    for(ASIHTTPRequest *request in [self.downlist operations])
    {
        id<DownloadHelperDelegate> tmpDelegate=[request.userInfo objectForKey:DownloadDelegateKey];
        if(tmpDelegate==delegate)
        {
            NSNumber *tag=[request.userInfo objectForKey:DownloadTag];
            if([tag intValue]==_tag)
            {
                [request clearDelegatesAndCancel];
                [request release];
                break;
            }
        }
    }
}

-(void)cancelAllRequest
{
    for(ASIHTTPRequest *request in downlist.operations)
    {
        [request clearDelegatesAndCancel];
    }
    [downlist cancelAllOperations];
//    [delegatelist removeAllObjects];
}

@end
