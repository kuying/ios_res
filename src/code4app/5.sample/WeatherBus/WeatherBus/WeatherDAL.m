//
//  WeatherDAL.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeatherDAL.h"
#import "CityModel.h"
#import "TouchXML.h"

static WeatherDAL *instance;

@implementation WeatherDAL

+(WeatherDAL *)sharedInstaced
{
    if(instance==nil)
    {
        instance=[[WeatherDAL alloc] init];
    }
    return instance;
}

//通过谷歌的接口，传入维度和经度返回城市的信息
//http://ditu.google.cn/maps/geo?output=xml&q=1005,12
-(NSString *)getCityUrlByLatitude:(double)latibute andLongitude:(double)longitude
{
    return [NSString stringWithFormat:@"http://ditu.google.cn/maps/geo?output=json&key=abc&q=%f,%f",latibute,longitude];
}

//http://m.weather.com.cn/data/101010100.html
-(NSString *)urlWeatherByCityID:(NSString *)cityID
{
    return [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html",cityID];
}

-(NSString *)getWeekByWeek:(NSString *)week andIndex:(int)index
{
    NSArray *weeklist=[NSArray arrayWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日", nil];
    NSUInteger weekIndex=[weeklist indexOfObject:week];
    return [weeklist objectAtIndex:(weekIndex+index)%7];
}

//判断是否是黑夜时间
-(BOOL)isNight
{
    NSDate *startDate=[NSDate date];
    
    NSCalendar *chineseCalendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags=NSHourCalendarUnit;
    NSDateComponents *dateComponents=[chineseCalendar components:unitFlags fromDate:startDate];
    if(([dateComponents hour]>=0&&[dateComponents hour]<=5)||([dateComponents hour]>=20&&[dateComponents hour]<=24))
    {
        return YES;
    }
    return NO;
}

//根据获取天气的关键字返回相应的图片名称
-(NSString *)getImageNameFromString:(NSString *)weather
{
    if(weather==nil)
    {
        NSLog(@"传入的天气名称为nil");
        return nil;
    }
    NSString *weatherString=[NSString stringWithString:weather];
    NSUInteger location=[weatherString rangeOfString:@"转"].location;
    if(location<100)
    {
        weatherString=[weatherString substringFromIndex:location+1];
    }
    if([weatherString isEqualToString:@"晴"])
    {
        return @"clear";
    }
    
    if([weatherString isEqualToString:@"多云"])
    {
        return @"cloudy";
    }
    
    if([weatherString isEqualToString:@"阴"])
    {
        return @"overcast";
    }
    
    if([weatherString isEqualToString:@"雾"])
    {
        return @"fog";
    }
    
    //------------雨
    if([weatherString isEqualToString:@"阵雨"])
    {
        return @"showers";
    }
    
    if([weatherString isEqualToString:@"雷阵雨"])
    {
        return @"thunderstorm";
    }
    
    if([weatherString isEqualToString:@"雨夹雪"])
    {
        return @"rainandsnow";
    }
    
    if([weatherString isEqualToString:@"小雨"])
    {
        return @"lightrain";
    }
    
    if(([weatherString isEqualToString:@"中雨"])||([weatherString isEqualToString:@"大雨"]))
    {
        return @"rain";
    }
    
    if(([weatherString isEqualToString:@"暴雨"])||([weatherString isEqualToString:@"大暴雨"])||([weatherString isEqualToString:@"特大暴雨"]))
    {
        return @"storm";
    }
    
    //-------------雪
    if([weatherString isEqualToString:@"阵雪"])
    {
        return @"scatteredsnow";
    }
    
    if([weatherString isEqualToString:@"小雪"])
    {
        return @"flurries";
    }
    
    if([weatherString isEqualToString:@"中雪"])
    {
        return @"icesnow";
    }
    
    if([weatherString isEqualToString:@"大雪"])
    {
        return @"snow";
    }
    
    if([weatherString isEqualToString:@"暴雪"])
    {
        return @"icy";
    }
    return nil;
}

//依次可以获取6天的,只使用前5个,返回的可能只有几个，不到5个
-(NSMutableArray *)getWeatherInfo:(NSDictionary *)paramDict
{
    if(paramDict==nil)
    {
        NSLog(@"传入的天气信息Data为nil");
        return nil;
    }
    NSMutableArray *weatherlist=[[[NSMutableArray alloc] init] autorelease];
    id weatherInfo=[paramDict objectForKey:@"weatherinfo"];
    if([weatherInfo isKindOfClass:[NSDictionary class]])
    {
        for(int i=0;i<6;i++)
        {
            CityModel *city=[[CityModel alloc] init];
            
            id cityID=[weatherInfo objectForKey:@"cityid"];
            if([cityID isKindOfClass:[NSString class]])
            {
                city.cityID=[cityID description];
            }
            
            id cityName=[weatherInfo objectForKey:@"city"];
            if([cityName isKindOfClass:[NSString class]])
            {
                city.cityName=[cityName description];
            }
            
            id date_y=[weatherInfo objectForKey:@"date_y"];
            if([date_y isKindOfClass:[NSString class]])
            {
                city.date_y=date_y;
            }
            
            id week=[weatherInfo objectForKey:@"week"];
            if([week isKindOfClass:[NSString class]])
            {
                city.week=[self getWeekByWeek:week andIndex:i];
            }
            
            id temp=[weatherInfo objectForKey:[NSString stringWithFormat:@"temp%d",i+1]];
            if([temp isKindOfClass:[NSString class]])
            {
                city.temp=[temp description];
            }
            
            id tempF=[weatherInfo objectForKey:[NSString stringWithFormat:@"tempF%d",i+1]];
            if([tempF isKindOfClass:[NSString class]])
            {
                city.tempF=[tempF description];
            }
            
            id weather=[weatherInfo objectForKey:[NSString stringWithFormat:@"weather%d",i+1]];
            if([weather isKindOfClass:[NSString class]])
            {
                city.weather=[weather description];
            }
            if(city.weather!=nil)
            {
                NSString *weatherImgName=[self getImageNameFromString:city.weather];
                NSString *nWeatherImgName=nil;
                 NSFileManager *fileManager=[NSFileManager defaultManager];
                if([self isNight])
                {
                    nWeatherImgName=[NSString stringWithFormat:@"n_%@",weatherImgName];
                    NSString *imgPath=[[NSBundle mainBundle] pathForResource:nWeatherImgName ofType:@"png"];
                   
                    if([fileManager fileExistsAtPath:imgPath])
                    {
                        city.weatherImage=[UIImage imageNamed:nWeatherImgName];
                    }
                    else
                    {
                        city.weatherImage=[UIImage imageNamed:@"clear.png"];
                    }
                    NSString *vedioPath=[[NSBundle mainBundle] pathForResource:nWeatherImgName ofType:@"mp4"];
                    if([fileManager fileExistsAtPath:vedioPath])
                    {
                        city.vedioName=[NSString stringWithFormat:@"%@.mp4",nWeatherImgName];
                    }
                    else
                    {
                        city.vedioName=@"clear.mp4";
                    }
                    city.effectImg=nWeatherImgName;
                }
                else
                {
                    NSString *imgPath=[[NSBundle mainBundle] pathForResource:weatherImgName ofType:@"png"];
                    if([fileManager fileExistsAtPath:imgPath])
                    {
                        city.weatherImage=[UIImage imageNamed:weatherImgName];
                    }
                    else
                    {
                        city.weatherImage=[UIImage imageNamed:@"clear.png"];
                    }
                     NSString *vedioPath=[[NSBundle mainBundle] pathForResource:weatherImgName ofType:@"mp4"];
                    if([fileManager fileExistsAtPath:vedioPath])
                    {
                          city.vedioName=[NSString stringWithFormat:@"%@.mp4",weatherImgName];
                    }
                    else
                    {
                        city.vedioName=@"clear.mp4";
                    }
                    city.effectImg=weatherImgName;
                }
                
                
                id wind=[weatherInfo objectForKey:[NSString stringWithFormat:@"wind%d",i+1]];
                if([wind isKindOfClass:[NSString class]])
                {
                    city.wind=[wind description];
                }
                
                id fl=[weatherInfo objectForKey:[NSString stringWithFormat:@"fl%d",i+1]];
                if([fl isKindOfClass:[NSString class]])
                {
                    city.fl=[fl description];
                }
                [weatherlist addObject:city];
            }
            [city release];
        }
    }
    return weatherlist;
}

-(NSMutableArray *)getCitylist:(NSDictionary *)paramDict
{
    NSMutableArray *citylist=[[[NSMutableArray alloc] init] autorelease];
    
    NSArray *placelist=[paramDict objectForKey:@"Placemark"];
    for(id place in placelist)
    {
        if([place isKindOfClass:[NSDictionary class]])
        {
           id address=[place objectForKey:@"AddressDetails"];
            if([address isKindOfClass:[NSDictionary class]])
            {
                id countryDict=[address objectForKey:@"Country"];
                if([countryDict isKindOfClass:[NSDictionary class]])
                {
                    id areDict=[countryDict objectForKey:@"AdministrativeArea"];
                    if(areDict==nil||![areDict isKindOfClass:[NSDictionary class]])
                    {
                        areDict=[countryDict objectForKey:@"SubAdministrativeArea"];
                    }
                    id aresName=[areDict objectForKey:@"AdministrativeAreaName"];
                    CityModel *cityModel=[[CityModel alloc] init];
                    [cityModel setCityName:[aresName description]];
                    [citylist addObject:cityModel];
                    [cityModel release];
                }
            }
        }
    }
    return citylist;
}

//获取本地XML的城市名称
-(NSMutableArray *)getLocalCities
{
    NSMutableArray *localCitylist=[[[NSMutableArray alloc] init] autorelease];
    
    NSString *xmlPath=[[NSBundle mainBundle] pathForResource:@"city" ofType:@"xml"];
    NSData *xmlData=[NSData dataWithContentsOfFile:xmlPath];
    CXMLDocument *document=[[CXMLDocument alloc]initWithData:xmlData options:0 error:nil];
    
    CXMLElement *root=[document rootElement];
    NSArray *cityElement=[root children];
    for(id city in cityElement)
    {
        if([city isKindOfClass:[CXMLElement class]])
        {
            NSArray *subCity=[city children];
            if(subCity!=nil)
            {
                CityModel *city=[[CityModel alloc] init];
                for(id subCityElement in subCity)
                {
                    if([subCityElement isKindOfClass:[CXMLElement class]])
                    {
                        NSString *elementName=[subCityElement name];
                        if([elementName isEqualToString:@"cityid"])
                        {
                            city.cityID=[subCityElement stringValue];
                        }
                        if([elementName isEqualToString:@"cityname"])
                        {
                            city.cityName=[subCityElement stringValue];
                        }
                    }
                }
                if([city.cityName isEqualToString:@""])
                {
                    continue;
                }
                [localCitylist addObject:city];
                [city release];
            }
        }
    }
    return localCitylist;
}

-(NSArray *)getCitylsitLikeName:(NSString *)cityName
{
    if([cityName rangeOfString:@"市"].location<100)
    {
        cityName=[cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"cityName CONTAINS %@",cityName];
    NSMutableArray *localCitylist=[self getLocalCities];
    return [localCitylist filteredArrayUsingPredicate:predicate];
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}
@end
