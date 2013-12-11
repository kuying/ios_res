//
//  SettingDAL.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//枚举从1开始
typedef enum{
    ThemeClearStyle=1,
    ThemeBlackRoundStyle=2,
    ThemeBlueStyle=3,
    ThemeGrayStyle=4,
    ThemeOrangeStyle=5,
    ThemeBlackEdgeStyle=6
} ThemeStyle;

#define kMaxCityCount 10            //可以支持的最大城市数量

#import <Foundation/Foundation.h>

@class CityModel;

@interface SettingDAL : NSObject
{}
+(SettingDAL *)sharedInstance;

-(ThemeStyle)getCurrentTheme;                           //获取当前的主题设置
-(void)updateCurrentTheme:(ThemeStyle)themeStyle;       //重新设置当前的主题

-(BOOL)isAutoLocation;                                  //是否启动自动适应地区
-(void)updateAutoLocation:(BOOL)flag;                   //修改是否自动适应地区功能

-(NSMutableArray *)getSaveCitylist;                     //获取本地存储的城市，如果没有则默认北京101010100，最多10
-(void)updateSavedCitylist:(NSMutableArray *)newCitylist;                             //排序后重新更新本地的顺序
-(void)insertNewCity:(CityModel *)city;                  //新增城市,0-失败,1-成功
-(void)deleteCityByCityID:(NSString *)cityID;            //通过cityID删除本地支持的城市天气

@end
