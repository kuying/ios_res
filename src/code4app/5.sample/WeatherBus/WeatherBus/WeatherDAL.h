//
//  WeatherDAL.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CityModel;

@interface WeatherDAL : NSObject

+(WeatherDAL *)sharedInstaced;

-(NSString *)getCityUrlByLatitude:(double)latibute andLongitude:(double)longitude;
-(NSString *)urlWeatherByCityID:(NSString *)cityID;

-(NSMutableArray *)getCitylist:(NSDictionary *)paramDict;

-(NSMutableArray *)getLocalCities;

-(NSArray *)getCitylsitLikeName:(NSString *)cityName;
-(NSMutableArray *)getWeatherInfo:(NSDictionary *)paramDict;
@end
