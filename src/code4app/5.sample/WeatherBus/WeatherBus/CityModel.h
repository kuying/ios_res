//
//  CityModel.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum{
    WeatherClearType=0,                         //晴天
    WeatherPartlySunnyType=1,                   //多云
    WeatherOverCastType=2,                      //阴
    WeatherFogType=3,                           //雾
    WeatherRainAndSnowType=4,                   //雨夹雪
    WeatherWindType=5,                          //风
    WeatherScatterShowerType=6,                 //零星阵雨
    WeatherShowerType=7,                        //阵雨
    WeatherThunderStormType=8,                  //雷阵雨
    WeatherScatterThunderStormType=9,           //零星雷阵雨
    WeatherLightRainType=10,                    //小雨
    WeatherRainType=11,                         //中雨或者大雨
    WeatherStormType=12,                        //暴雨或者特大暴雨
    WeatherScatterSnowType=13,                  //阵雪
    WeatherFlurryType=14,                       //小雪
    WeatherIceSnowType=15,                      //中雪
    WeatherSnowType=16,                         //大雪
    WeatherIceType=17,                          //暴雪
    WeatherHailType=18,                         //冰雹类的天气
} WeatherType;

#import <Foundation/Foundation.h>

@interface CityModel : NSObject<NSCoding,NSCopying>

@property(nonatomic,retain)NSString *cityName;
@property(nonatomic,retain)NSString *cityID;

@property(nonatomic,retain)NSString *vedioName;
@property(nonatomic,retain)NSString *date_y;
@property(nonatomic,retain)NSString *week;
@property(nonatomic,retain)NSString *temp;
@property(nonatomic,retain)NSString *tempF;
@property(nonatomic,retain)NSString *weather;
@property(nonatomic,retain)NSString *wind;
@property(nonatomic,retain)NSString *fl;
@property WeatherType weatherType;//？？
@property(nonatomic,retain)NSString *effectImg;
@property(nonatomic,retain)UIImage *weatherImage;
@end
