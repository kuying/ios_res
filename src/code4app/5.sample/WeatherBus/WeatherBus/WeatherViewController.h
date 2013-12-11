//
//  WeatherViewController.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SettingDAL.h"
#import "MBProgressHUD.h"

@class CityModel;

@interface WeatherViewController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate>
{
    ThemeStyle currentStle;
}

@property(nonatomic,retain)NSMutableArray *viewlist;        //滑动的视图管理队列
@property(nonatomic,retain)NSMutableArray *savedCitylist;//保存的需要展示的city
@property(nonatomic,retain)NSString *currentCityName;
@property(nonatomic,retain)MPMoviePlayerController *movieController;
@property(nonatomic,retain)UIScrollView *movedScoll;        
@property(nonatomic,retain)UIPageControl *pageController;
@property(nonatomic,assign) MBProgressHUD *hud;

@end
