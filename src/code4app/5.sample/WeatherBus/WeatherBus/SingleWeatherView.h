//
//  SingleWeatherView.h
//  WeatherBus
//
//  Created by TGBUS on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SettingDAL.h"
#import <CoreLocation/CoreLocation.h>
#import "DownloadHelper.h"

@class CityModel;

@interface SingleWeatherView : UIView<CLLocationManagerDelegate,DownloadHelperDelegate>
{
    ThemeStyle currentStle;
}

@property(nonatomic,retain)UIImageView *bgImageView;
@property(nonatomic,retain)UIImageView *clockbgBgImgView;
@property(nonatomic,retain)UIImageView *effectBgImgView;
@property(nonatomic,retain)UIImageView *hourLeftImgView;
@property(nonatomic,retain)UIImageView *hourRightImgView;
@property(nonatomic,retain)UIImageView *minuteLeftImgView;
@property(nonatomic,retain)UIImageView *minuteRightImgView;
@property(nonatomic,retain)UILabel *lblHourTime;
@property(nonatomic,retain)UILabel *lblMinute;
@property(nonatomic,retain)UILabel *lblDate;
@property(nonatomic,retain)UILabel *lblPlace;
@property(nonatomic,retain)UILabel *lblTemp;
@property(nonatomic,retain)UILabel *lblWeather;
@property(nonatomic,retain)UILabel *lblWind;
@property(nonatomic,retain)UILabel *lblWindLevel;
@property(nonatomic,retain)UILabel *lblSubDayFirst;
@property(nonatomic,retain)UILabel *lblSubDaySecond;
@property(nonatomic,retain)UILabel *lblSubDayThird;
@property(nonatomic,retain)UILabel *lblSubDayFourth;
@property(nonatomic,retain)UILabel *lblSubTempFirst;
@property(nonatomic,retain)UILabel *lblSubTempSecond;
@property(nonatomic,retain)UILabel *lblSubTempThird;
@property(nonatomic,retain)UILabel *lblSubTempFourth;
@property(nonatomic,retain)UIImageView *firstImgView;
@property(nonatomic,retain)UIImageView *secondImgView;
@property(nonatomic,retain)UIImageView *thirdImgView;
@property(nonatomic,retain)UIImageView *fourthImgView;
@property(nonatomic,retain)UIImageView *todayImgView;
@property(nonatomic,retain)CityModel *currentCity;
@property(nonatomic,retain)NSString *currentCityName;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,retain)CLLocation *currentLocation;
@property(nonatomic,retain)NSMutableArray *citylist;//5天的天气

- (id)initWithFrame:(CGRect)frame withCity:(CityModel *)city;
-(void)updateWeatherInThread;

@end
