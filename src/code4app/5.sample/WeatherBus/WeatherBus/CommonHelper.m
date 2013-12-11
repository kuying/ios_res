//
//  CommonHelper.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonHelper.h"
#import "CityModel.h"

static CommonHelper *instance;

@implementation CommonHelper

+(CommonHelper *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[CommonHelper alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
}

-(MBProgressHUD *) showHud:(id<MBProgressHUDDelegate>) delegate title:(NSString *) title  selector:(SEL) selector arg:(id) arg  targetView:(UIView *)targetView
{
    MBProgressHUD *hud = [[[MBProgressHUD alloc] initWithView:targetView] autorelease];
    [targetView addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.delegate = delegate;
    hud.labelText = title;
    [hud showWhileExecuting:selector 
                   onTarget:delegate 
                 withObject:arg 
                   animated:YES];
    return hud;
}

-(void)archiverModel:(id)model filePath:(NSString *)filePath
{
    NSMutableData *archiverData=[[NSMutableData alloc] init];
    
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:archiverData];
    [archiver encodeObject:model forKey:@"Data"];
    [archiver finishEncoding];
    BOOL flag=[archiverData writeToFile:filePath atomically:NO];
    if(!flag)
    {
        NSLog(@"归档失败");
    }
    [archiver release];
    [archiverData release];
}

-(id)unArchiverModel:(NSString *)filePath
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"反归档的路径不存在:%@",filePath);
        return nil;
    }
    
    NSData *unArchiverData=[[NSData alloc] initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc] initForReadingWithData:unArchiverData];
    id model=[unarchiver decodeObjectForKey:@"Data"];
    [unarchiver finishDecoding];
    [unarchiver release];
    [unArchiverData release];
    return model;
}

@end
