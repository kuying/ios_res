//
//  CityModel.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityModel.h"

#define kCityID @"cityID"
#define kCityName @"cityName"

@implementation CityModel

@synthesize effectImg;
@synthesize vedioName;
@synthesize weatherType;
@synthesize cityID;
@synthesize cityName;
@synthesize date_y;
@synthesize week;
@synthesize temp;
@synthesize tempF;
@synthesize weather;
@synthesize wind;
@synthesize fl;
@synthesize weatherImage;


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:cityID forKey:kCityID];
    [aCoder encodeObject:cityName forKey:kCityName];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if(self)
    {
        self.cityID=[aDecoder decodeObjectForKey:kCityID];
        self.cityName=[aDecoder decodeObjectForKey:kCityName];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    CityModel *city=[[[self class] copyWithZone:zone] init];
    city.cityID=self.cityID;
    city.cityName=self.cityName;
    return city;
}

-(void)dealloc
{
    self.effectImg=nil;
    self.vedioName=nil;
    self.weatherImage=nil;
    self.cityName=nil;
    self.cityID=nil;
    self.date_y=nil;
    self.weather=nil;
    self.week=nil;
    self.tempF=nil;
    self.temp=nil;
    self.wind=nil;
    self.fl=nil;
    [super dealloc];
}

@end
