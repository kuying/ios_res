//
//  SingleWeatherView.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingleWeatherView.h"
#import "CityModel.h"
#import "WeatherDAL.h"
#import "SBJson.h"

@interface SingleWeatherView () {
@private
}

-(NSDateComponents *)getCurrentNSDateComponent;
-(void)updateWeatherInThread;
-(void)updateTime:(NSTimer *)timer;
-(void)updateMainInThread:(CityModel *)city;

@end

@implementation SingleWeatherView

@synthesize bgImageView,clockbgBgImgView,effectBgImgView;
@synthesize hourLeftImgView,hourRightImgView,minuteLeftImgView,minuteRightImgView;
@synthesize lblWind;
@synthesize lblWindLevel;
@synthesize lblWeather;
@synthesize lblPlace;
@synthesize lblTemp;
@synthesize todayImgView;
@synthesize lblHourTime,lblMinute,lblDate;
@synthesize currentCityName;
@synthesize currentCity;
@synthesize firstImgView,secondImgView,thirdImgView,fourthImgView;
@synthesize lblSubTempFirst,lblSubTempSecond,lblSubTempThird,lblSubTempFourth;
@synthesize lblSubDayFirst,lblSubDaySecond,lblSubDayThird,lblSubDayFourth;
@synthesize locationManager;
@synthesize currentLocation;
@synthesize citylist;

- (id)initWithFrame:(CGRect)frame withCity:(CityModel *)city
{
    self=[self initWithFrame:frame];
    if(self)
    {
        self.currentCity=city;
        NSString *weatherUrl=[[WeatherDAL sharedInstaced] urlWeatherByCityID:currentCity.cityID];
        [[DownloadHelper sharedInstance] startRequest:weatherUrl delegate:self tag:1 userInfo:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        currentStle=[[SettingDAL sharedInstance] getCurrentTheme];
        
        //整个的背景图片
        bgImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/bgWidget.png",currentStle]]];
        [bgImageView setFrame:CGRectMake(0, 0, 320, 480)];
        [self addSubview:bgImageView];
        
        //时间背景图片
        clockbgBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/bgWidgetClock.png",currentStle]]];
        [clockbgBgImgView setFrame:CGRectMake(0, 0, 320, 480)];
        [self addSubview:clockbgBgImgView];
        
        effectBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"effect_clear.png"]];
        [effectBgImgView setFrame:CGRectMake(0, 0, 320, 480)];
        [self addSubview:effectBgImgView];

        //4张图片组成的时间
        CGFloat offsetY=60;
        CGFloat height=60;
        CGFloat width=40;
        hourLeftImgView=[[UIImageView alloc] init];
        [hourLeftImgView setFrame:CGRectMake(53, offsetY, width, height)];
        [self addSubview:hourLeftImgView];
        
        hourRightImgView=[[UIImageView alloc] init];
        [hourRightImgView setFrame:CGRectMake(hourLeftImgView.frame.origin.x+40, offsetY, width, height)];
        [self addSubview:hourRightImgView];
        
        minuteLeftImgView=[[UIImageView alloc] init];
        [minuteLeftImgView setFrame:CGRectMake(171, offsetY, width, height)];
        [self addSubview:minuteLeftImgView];
        
        minuteRightImgView=[[UIImageView alloc] init];
        [minuteRightImgView setFrame:CGRectMake(minuteLeftImgView.frame.origin.x+45, offsetY, width, height)];
        [self addSubview:minuteRightImgView];
        
        lblHourTime=[[UILabel alloc] init];
        [lblHourTime setBackgroundColor:[UIColor clearColor]];
        [lblHourTime setFont:[UIFont fontWithName:@"Helvetica" size:100]];
        [lblHourTime setFont:[UIFont boldSystemFontOfSize:80]];
        [lblHourTime setTextAlignment:UITextAlignmentCenter];
        [lblHourTime setFrame:CGRectMake(35, 35, 120, 100)];
        [self addSubview:lblHourTime];
        
        lblMinute=[[UILabel alloc] init];
        [lblMinute setBackgroundColor:[UIColor clearColor]];
        [lblMinute setFont:[UIFont fontWithName:@"Helvetica" size:100]];
        [lblMinute setFont:[UIFont boldSystemFontOfSize:80]];
        [lblMinute setTextAlignment:UITextAlignmentCenter];
        [lblMinute setFrame:CGRectMake(150, 35, 120, 100)];
        [self addSubview:lblMinute];
        
        //顶部的日期标签
        lblDate=[[UILabel alloc] init];
        [lblDate setBackgroundColor:[UIColor clearColor]];
        [lblDate setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [lblDate setTextAlignment:UITextAlignmentCenter];
        [lblDate setFrame:CGRectMake(110, 15, 100, 15)];
        [self addSubview:lblDate];
        
        //正中间的天气图像
        todayImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clear.png"]];
        [todayImgView setFrame:CGRectMake(70, 80, 180, 180)];
        [self addSubview:todayImgView];
        
        //地点标签
        lblPlace=[[UILabel alloc] init];
        [lblPlace setBackgroundColor:[UIColor clearColor]];
        [lblPlace setTextColor:[UIColor whiteColor]];
        [lblPlace setFont:[UIFont fontWithName:@"Helvetica" size:22]];
        [lblPlace setFrame:CGRectMake(20, 225, 150, 22)];
        [lblPlace setText:@"北京"];
        [self addSubview:lblPlace];
        
        //温度标签
        lblTemp=[[UILabel alloc] init];
        [lblTemp setBackgroundColor:[UIColor clearColor]];
        [lblTemp setTextColor:[UIColor whiteColor]];
        [lblTemp setFont:[UIFont fontWithName:@"Helvetica" size:19]];
        [lblTemp setTextAlignment:UITextAlignmentRight];
        [lblTemp setFrame:CGRectMake(200, 220, 100, 19)];
        [lblTemp setText:@"30℃~84℃"];
        [self addSubview:lblTemp];
        
        //添加天气信息标签
        lblWeather=[[UILabel alloc] init];
        [lblWeather setBackgroundColor:[UIColor clearColor]];
        [lblWeather setTextColor:[UIColor whiteColor]];
        [lblWeather setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [lblWeather setFrame:CGRectMake(lblPlace.frame.origin.x, lblPlace.frame.origin.y+lblPlace.frame.size.height+10, 100, 16)];
        [lblWeather setText:@"小雨转中雨"];
        [self addSubview:lblWeather];
        
        //风类标签
        lblWind=[[UILabel alloc] init];
        [lblWind setBackgroundColor:[UIColor clearColor]];
        [lblWind setTextColor:[UIColor whiteColor]];
        [lblWind setTextAlignment:UITextAlignmentRight];
        [lblWind setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [lblWind setFrame:CGRectMake(160, lblTemp.frame.origin.y+lblTemp.frame.size.height+5, 135, 13)];
        [lblWind setText:@"微风"];
        [self addSubview:lblWind];
        
        //风类级别标签
        lblWindLevel=[[UILabel alloc] init];
        [lblWindLevel setBackgroundColor:[UIColor clearColor]];
        [lblWindLevel setTextColor:[UIColor whiteColor]];
        [lblWindLevel setTextAlignment:UITextAlignmentRight];
        [lblWindLevel setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [lblWindLevel setFrame:CGRectMake(160, lblWind.frame.origin.y+lblWind.frame.size.height+5, lblWind.frame.size.width, 13)];
        [lblWindLevel setText:@"小于3级"];
        [self addSubview:lblWindLevel];
        
        //--------------从明天开始往后4天的天气、图片、温度标签---------------
        CGFloat imgWidth=45;
        CGFloat imgHeight=imgWidth;
        CGFloat offsetGap=5;
        
        lblSubDayFirst=[[UILabel alloc] init];
        [lblSubDayFirst setBackgroundColor:[UIColor clearColor]];
        [lblSubDayFirst setTextColor:[UIColor whiteColor]];
        [lblSubDayFirst setTextAlignment:UITextAlignmentCenter];
        [lblSubDayFirst setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [lblSubDayFirst setFrame:CGRectMake(20, 290, 70, 11)];
        [lblSubDayFirst setText:@"星期六"];
        [self addSubview:lblSubDayFirst];
        
        //图片
        firstImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scatteredsnow.png"]];
        [firstImgView setFrame:CGRectMake(lblSubDayFirst.frame.origin.x+15, lblSubDayFirst.frame.origin.y+lblSubDayFirst.frame.size.height+offsetGap, imgWidth, imgHeight)];
        [self addSubview:firstImgView];
        
        //温度
        lblSubTempFirst=[[UILabel alloc] init];
        [lblSubTempFirst setBackgroundColor:[UIColor clearColor]];
        [lblSubTempFirst setTextColor:[UIColor whiteColor]];
        [lblSubTempFirst setTextAlignment:UITextAlignmentCenter];
        [lblSubTempFirst setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [lblSubTempFirst setFrame:CGRectMake(20, firstImgView.frame.origin.y+firstImgView.frame.size.height, 70, 12)];
        [lblSubTempFirst setText:@"23℃"];
        [self addSubview:lblSubTempFirst];
        
        
        //第2个天气信息
        lblSubDaySecond=[[UILabel alloc] init];
        [lblSubDaySecond setBackgroundColor:[UIColor clearColor]];
        [lblSubDaySecond setTextColor:[UIColor whiteColor]];
        [lblSubDaySecond setTextAlignment:UITextAlignmentCenter];
        [lblSubDaySecond setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [lblSubDaySecond setFrame:CGRectMake(90, lblSubDayFirst.frame.origin.y, lblSubDayFirst.frame.size.width, lblSubDayFirst.frame.size.height)];
        [lblSubDaySecond setText:@"星期日"];
        [self addSubview:lblSubDaySecond];
        
        //图片
        secondImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rainandsnow.png"]];
        [secondImgView setFrame:CGRectMake(lblSubDaySecond.frame.origin.x+10, lblSubDaySecond.frame.origin.y+lblSubDaySecond.frame.size.height+offsetGap, imgWidth, imgHeight)];
        [self addSubview:secondImgView];
        
        //温度
        lblSubTempSecond=[[UILabel alloc] init];
        [lblSubTempSecond setBackgroundColor:[UIColor clearColor]];
        [lblSubTempSecond setTextColor:[UIColor whiteColor]];
        [lblSubTempSecond setTextAlignment:UITextAlignmentCenter];
        [lblSubTempSecond setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [lblSubTempSecond setFrame:CGRectMake(20+lblSubTempFirst.frame.size.width, secondImgView.frame.origin.y+secondImgView.frame.size.height, 70, 12)];
        [lblSubTempSecond setText:@"18℃"];
        [self addSubview:lblSubTempSecond];
        
        
        //第3个天气信息
        lblSubDayThird=[[UILabel alloc] init];
        [lblSubDayThird setBackgroundColor:[UIColor clearColor]];
        [lblSubDayThird setTextColor:[UIColor whiteColor]];
        [lblSubDayThird setTextAlignment:UITextAlignmentCenter];
        [lblSubDayThird setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [lblSubDayThird setFrame:CGRectMake(160, lblSubDayFirst.frame.origin.y, lblSubDayFirst.frame.size.width, lblSubDayFirst.frame.size.height)];
        [lblSubDayThird setText:@"星期一"];
        [self addSubview:lblSubDayThird];
        
        //图片
        thirdImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wind.png"]];
        [thirdImgView setFrame:CGRectMake(lblSubDayThird.frame.origin.x+10, lblSubDayThird.frame.origin.y+lblSubDayThird.frame.size.height+offsetGap, imgWidth, imgHeight)];
        [self addSubview:thirdImgView];
        
        //温度
        lblSubTempThird=[[UILabel alloc] init];
        [lblSubTempThird setBackgroundColor:[UIColor clearColor]];
        [lblSubTempThird setTextColor:[UIColor whiteColor]];
        [lblSubTempThird setTextAlignment:UITextAlignmentCenter];
        [lblSubTempThird setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [lblSubTempThird setFrame:CGRectMake(20+lblSubTempFirst.frame.size.width+lblSubTempSecond.frame.size.width, secondImgView.frame.origin.y+secondImgView.frame.size.height, 70, 12)];
        [lblSubTempThird setText:@"25℃"];
        [self addSubview:lblSubTempThird];
        
        
        //第4个天气信息
        lblSubDayFourth=[[UILabel alloc] init];
        [lblSubDayFourth setBackgroundColor:[UIColor clearColor]];
        [lblSubDayFourth setTextColor:[UIColor whiteColor]];
        [lblSubDayFourth setTextAlignment:UITextAlignmentCenter];
        [lblSubDayFourth setFont:[UIFont fontWithName:@"Helvetica" size:11]];
        [lblSubDayFourth setFrame:CGRectMake(230, lblSubDayFirst.frame.origin.y, lblSubDayFirst.frame.size.width, lblSubDayFirst.frame.size.height)];
        [lblSubDayFourth setText:@"星期二"];
        [self addSubview:lblSubDayFourth];
        
        //图片
        fourthImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"storm.png"]];
        [fourthImgView setFrame:CGRectMake(lblSubDayFourth.frame.origin.x+10, lblSubDayFourth.frame.origin.y+lblSubDayFourth.frame.size.height+offsetGap,imgWidth, imgHeight)];
        [self addSubview:fourthImgView];
        
        //温度
        lblSubTempFourth=[[UILabel alloc] init];
        [lblSubTempFourth setBackgroundColor:[UIColor clearColor]];
        [lblSubTempFourth setTextColor:[UIColor whiteColor]];
        [lblSubTempFourth setTextAlignment:UITextAlignmentCenter];
        [lblSubTempFourth setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [lblSubTempFourth setFrame:CGRectMake(20+lblSubTempFirst.frame.size.width+lblSubTempSecond.frame.size.width+lblSubTempThird.frame.size.width, secondImgView.frame.origin.y+secondImgView.frame.size.height, 70, 12)];
        [lblSubTempFourth setText:@"25℃"];
        [self addSubview:lblSubTempFourth];

        [self updateTime:nil];
        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    self.effectBgImgView=nil;
    self.citylist=nil;
    self.lblDate=nil;
    self.currentCity=nil;
    self.lblMinute=nil;
    self.lblHourTime=nil;
    self.todayImgView=nil;
    self.lblTemp=nil;
    self.lblWeather=nil;
    self.lblPlace=nil;
    self.lblWindLevel=nil;
    self.lblWind=nil;
    self.lblSubDayThird=nil;
    self.lblSubDaySecond=nil;
    self.lblSubDayFirst=nil;
    self.lblSubDayFourth=nil;
    self.firstImgView=nil;
    self.secondImgView=nil;
    self.thirdImgView=nil;
    self.fourthImgView=nil;
    self.lblSubTempThird=nil;
    self.lblSubTempSecond=nil;
    self.lblSubTempFirst=nil;
    self.lblSubTempFourth=nil;
    self.clockbgBgImgView=nil;
    self.bgImageView=nil;
    [super dealloc];
}

-(void)updateWeatherInThread
{
    currentCityName=@"北京";
    //    if([locationManager locationServicesEnabled])
    //    {
    locationManager=[[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:200];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    [locationManager startUpdatingLocation];
    [locationManager performSelectorInBackground:@selector(startUpdatingLocation) withObject:nil];
    //    }
    //    else
    //    {
    //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的地理位置没有开启" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好", nil];
    //        [alert show];
    //        [alert release];
    //    }
}

#pragma Location委托
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    currentLocation=newLocation;
    NSString *targetUrl=[[WeatherDAL sharedInstaced] getCityUrlByLatitude:currentLocation.coordinate.latitude andLongitude:currentLocation.coordinate.longitude];
    [[DownloadHelper sharedInstance] startRequest:targetUrl delegate:self tag:0 userInfo:nil];
}

-(void)updateMainInThread:(CityModel *)city
{
    lblDate.text=city.date_y;
    todayImgView.image=city.weatherImage;
    lblPlace.text=city.cityName;
    lblWeather.text=city.weather;
    lblWind.text=city.wind;
    lblWindLevel.text=city.fl;
    lblTemp.text=city.temp;
    NSLog(@"%@",[NSString stringWithFormat:@"effect_%@.png",city.effectImg]);
    [effectBgImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"effect_%@.png",city.effectImg]]];
}

-(void)updateSubInfoInThread:(NSDictionary *)params
{
    NSNumber *number=[params objectForKey:@"ID"];
    CityModel *city=[params objectForKey:@"City"];
    switch ([number intValue]) {
        case 1:
            firstImgView.image=city.weatherImage;
            lblSubTempFirst.text=city.temp;
            lblSubDayFirst.text=city.week;
            break;
        case 2:
            secondImgView.image=city.weatherImage;
            lblSubTempSecond.text=city.temp;
            lblSubDaySecond.text=city.week;
            break;
        case 3:
            thirdImgView.image=city.weatherImage;
            lblSubTempThird.text=city.temp;
            lblSubDayThird.text=city.week;
            break;
        case 4:
            fourthImgView.image=city.weatherImage;
            lblSubTempFourth.text=city.temp;
            lblSubDayFourth.text=city.week;
            break;
        default:
            break;
    }
}

#pragma DownloadHelper下载委托
-(void)DownloadFailed:(NSNumber *)errorCode downloadType:(NSNumber *)downloadType url:(NSString *)url
{}

-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    switch ([downloadType intValue]) {
        case 0://根据经纬度获取的城市名字等信息,谷歌的API
        {
            NSMutableArray *currentCitylist=[[WeatherDAL sharedInstaced] getCitylist:[[data objectForKey:@"Data"] JSONValue]];
            if([currentCitylist count]!=0)
            {
                CityModel *cityModel=[currentCitylist objectAtIndex:0];
                NSArray *resultCities=[[WeatherDAL sharedInstaced] getCitylsitLikeName: cityModel.cityName];
                if([resultCities count]!=0)
                {
                    currentCity=[resultCities objectAtIndex:0];
                    
                    NSString *weatherUrl=[[WeatherDAL sharedInstaced] urlWeatherByCityID:currentCity.cityID];
                    [[DownloadHelper sharedInstance] startRequest:weatherUrl delegate:self tag:1 userInfo:nil];
                }
                else
                {
                    NSLog(@"您的所在地点未能搜索到");
                }
            }
        }
            break;
        case 1://根据中国天气网的城市代码获取的城市天气信息
        {
            self.citylist=[[WeatherDAL sharedInstaced] getWeatherInfo:[[data objectForKey:@"Data"] JSONValue]];
            if(citylist)
            {   
                for(int i=0;i<[citylist count];i++)
                {
                    CityModel *city=[citylist objectAtIndex:i];
                    if(city)
                    {
                        if(i==0)//更新最大的地方
                        {
                            [self performSelectorOnMainThread:@selector(updateMainInThread:) withObject:city waitUntilDone:YES];
                        }
                        else
                        {
                            NSDictionary *params=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:city,[NSNumber numberWithInt:i], nil] forKeys:[NSArray arrayWithObjects:@"City",@"ID", nil]];
                            [self performSelectorOnMainThread:@selector(updateSubInfoInThread:) withObject:params waitUntilDone:YES];
                        }
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

//得到时间
-(NSDateComponents *)getCurrentNSDateComponent
{
    NSDate *startDate=[[[NSDate alloc] init] autorelease];
    NSCalendar *chineseCalender=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlag=NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    return [chineseCalender components:unitFlag fromDate:startDate];
}

-(void)updateTime:(NSTimer *)timer
{
    ThemeStyle style=[[SettingDAL sharedInstance]getCurrentTheme];
    
    NSDateComponents *dateComponents=[self getCurrentNSDateComponent];
    //得到小时
    int hour=[dateComponents hour];
    int hourRight=hour%10;
    if(hour<10)
    {
        [hourLeftImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/digits/%d.png",style,0]]];
    }
    else
    {
        int hourLeft=hour/10;
        
        [hourLeftImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/digits/%d.png",style,hourLeft]]];
    }
    [hourRightImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/digits/%d.png",style,hourRight]]];
    
    //得到分钟
    int minute=[dateComponents minute];
    int minuteRight=minute%10;
    if(minute<10)
    {
        [minuteLeftImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/digits/%d.png",style,0]]];
    }
    else
    {
        int minuteLeft=minute/10;
        
        [minuteLeftImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/digits/%d.png",style,minuteLeft]]];
    }
    [minuteRightImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/digits/%d.png",style,minuteRight]]];
}



@end
