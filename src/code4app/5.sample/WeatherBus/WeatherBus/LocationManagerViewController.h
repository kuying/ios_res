//
//  LocationManagerViewController.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface LocationManagerViewController : UITableViewController<MBProgressHUDDelegate>

@property(nonatomic,retain)NSMutableArray *savedCity;
@property(nonatomic,assign) MBProgressHUD *hud;
@end
