//
//  SettingDAL.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingDAL.h"
#import "CityModel.h"
#import "CommonHelper.h"

#define kCityArchiverPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"savedcity"]

static SettingDAL *instance;

@implementation SettingDAL

+(SettingDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[SettingDAL alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(ThemeStyle)getCurrentTheme
{
    NSNumber *number=[[NSUserDefaults standardUserDefaults] objectForKey:@"ThemeSetting"];
    int theme=[number intValue];
    if(theme<1||theme>6)
    {
        [self updateCurrentTheme:ThemeClearStyle];
        return ThemeClearStyle;
    }
    return (ThemeStyle)theme;
}

-(void)updateCurrentTheme:(ThemeStyle)themeStyle
{
    if((int)themeStyle<1||(int)themeStyle>6)
    {
        themeStyle=ThemeClearStyle;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:themeStyle] forKey:@"ThemeSetting"];
}

-(BOOL)isAutoLocation
{
    NSNumber *number=[[NSUserDefaults standardUserDefaults] objectForKey:@"AutoLocation"];
    return [number boolValue];
}

-(void)updateAutoLocation:(BOOL)flag
{
    NSNumber *number=[NSNumber numberWithBool:flag];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"AutoLocation"];
}

-(void)updateSavedCitylist:(NSMutableArray *)newCitylist
{
    [[CommonHelper sharedInstance] archiverModel:newCitylist filePath:kCityArchiverPath];
}

-(NSMutableArray *)getSaveCitylist
{
    NSMutableArray *citylist=[[CommonHelper sharedInstance] unArchiverModel:kCityArchiverPath];
    if(!citylist)
    {
        citylist=[[[NSMutableArray alloc] init] autorelease];
        CityModel *city=[[CityModel alloc] init];
        city.cityID=@"101010100";
        city.cityName=@"北京";
        [citylist addObject:city];
        [city release];
    }
    return citylist;
}

-(void)insertNewCity:(CityModel *)city
{
    if(!city)
    {
        NSLog(@"传入的city为nil");
        return;
    }
    NSMutableArray *citylist=[[CommonHelper sharedInstance] unArchiverModel:kCityArchiverPath];
    if(citylist==nil)
    {
        citylist=[[[NSMutableArray alloc] init] autorelease];
    }
    [citylist addObject:city];
    [[CommonHelper sharedInstance] archiverModel:citylist filePath:kCityArchiverPath];
}

-(void)deleteCityByCityID:(NSString *)_cityID
{
    NSString *cityID=[NSString stringWithString:_cityID];
    if(cityID==nil)
    {
        NSLog(@"传入的cityID为nil");
        return;
    }
    NSMutableArray *citylist=[[CommonHelper sharedInstance] unArchiverModel:kCityArchiverPath];
    for(CityModel *city in citylist)
    {
        if([city.cityID isEqualToString:cityID])
        {
            [citylist removeObject:city];
            break;
        }
    }
    [[CommonHelper sharedInstance] archiverModel:citylist filePath:kCityArchiverPath];

}
@end
