//
//  ThemeModel.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingDAL.h"

@interface ThemeModel : NSObject

@property(nonatomic,retain)NSString *themeName;
@property(nonatomic,retain)UIImage *themeImage;
@property(nonatomic) ThemeStyle themeStyle;

@end
