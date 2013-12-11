//
//  CommonHelper.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface CommonHelper : NSObject

+(CommonHelper *)sharedInstance;

-(MBProgressHUD *) showHud:(id<MBProgressHUDDelegate>) delegate title:(NSString *) title  selector:(SEL) selector arg:(id) arg  targetView:(UIView *)targetView;

//传入路径和列表进行归档和反归档
-(void)archiverModel:(id)model filePath:(NSString *)filePath;   
-(id)unArchiverModel:(NSString *)filePath;
@end
