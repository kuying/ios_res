//
//  LocationViewController.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LocationViewController : UITableViewController<UISearchDisplayDelegate,MBProgressHUDDelegate>

@property(nonatomic,retain)NSMutableArray *citylist;
@property(nonatomic,retain)NSMutableArray *savedCitylist;
@property(nonatomic,retain)NSArray *resultCitylist;
@property(nonatomic,retain)UISearchBar *searchBar;
@property(nonatomic,retain)UISearchDisplayController *searchDC;
@property(nonatomic,assign) MBProgressHUD *hud;

@end
