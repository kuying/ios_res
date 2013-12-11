//
//  AppDelegate.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)WeatherViewController *weatherViewController;

@end
