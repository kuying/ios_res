//
//  WeatherViewController.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeatherViewController.h"
#import "CityModel.h"
#import "SettingViewController.h"
#import "SettingDAL.h"
#import "SingleWeatherView.h"
#import "CommonHelper.h"

#define kWeatherAPI @"http://m.weather.com.cn/data/"
#define kGooglePlaceAPI @"http://ditu.google.cn/maps/geo?output=xml&q=%f,%f"

@interface WeatherViewController () {
@private
}

-(void)infoAction:(id)sender;                       //Info按钮事件
-(void)reloadStyle;                                 //重新加载每个视图的风格
-(void)pageControllerClick:(id)sender;              //点击pageControler后触发的事件

@end
@implementation WeatherViewController

@synthesize viewlist,savedCitylist;
@synthesize currentCityName;
@synthesize movieController;
@synthesize pageController;
@synthesize movedScoll;
@synthesize hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void)infoAction:(id)sender
{
    SettingViewController *detailViewController=[[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.navigationItem.title=@"天气设置";

    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:detailViewController];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    [self presentModalViewController:navController animated:YES];
    [navController release];
    
    [detailViewController release];
}

-(void)reloadStyle
{
    for(SingleWeatherView *view in viewlist)
    {
        [view.bgImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/bgWidget.png",currentStle]]];
        [view.clockbgBgImgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"skin0%d/bgWidgetClock.png",currentStle]]];
    }
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    currentStle=[[SettingDAL sharedInstance] getCurrentTheme];
    
    //播放Video背景
    NSURL *vedioUrl=[[NSBundle mainBundle] URLForResource:@"clear" withExtension:@"mp4"];
    movieController=[[MPMoviePlayerController alloc] initWithContentURL:vedioUrl];
    [movieController setMovieControlMode:MPMovieControlModeHidden];
    [movieController setRepeatMode:MPMovieRepeatModeOne];
    [movieController setScalingMode:MPMovieScalingModeAspectFill];
    [movieController.view setFrame:self.view.bounds];
    [self.view addSubview:movieController.view];
    [movieController performSelectorInBackground:@selector(play) withObject:nil];
    
    //根据存储的城市个数进行控件动态添加
    self.savedCitylist=[[SettingDAL sharedInstance] getSaveCitylist];
    movedScoll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [movedScoll setContentSize:CGSizeMake([savedCitylist count]*320, 480)];
    [movedScoll setDelegate:self];
    [movedScoll setPagingEnabled:YES];
    [movedScoll setShowsHorizontalScrollIndicator:NO];
    [movieController.view addSubview:movedScoll];
    
    pageController=[[UIPageControl alloc]initWithFrame:CGRectMake(0, 445, 320, 35)];
    [pageController addTarget:self action:@selector(pageControllerClick:) forControlEvents:UIControlEventValueChanged];
    [pageController setNumberOfPages:[savedCitylist count]];
    [self.view addSubview:pageController];
    
    
    //右下角的info按钮
    UIButton *btnInfo=[UIButton buttonWithType:UIButtonTypeInfoLight];
    [btnInfo setFrame:CGRectMake(270, 415, 35, 35)];
    [btnInfo addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnInfo];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

-(void)releaseCacheData
{
    self.movieController=nil;
    self.viewlist=nil;
    self.pageController=nil;
    self.movedScoll=nil;
    self.hud=nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseCacheData];
}

-(void)dealloc
{
    [self releaseCacheData];
    [super dealloc];
}

-(void)updateMainUI
{
    int showCount=[savedCitylist count];//要显示的个数
    //判断是否有自动根据地理位置显示天气，如果开启了则显示在第1个，否则不显示
    if([[SettingDAL sharedInstance] isAutoLocation])
    {
        showCount+=1;
    }
    
    [movedScoll setContentSize:CGSizeMake(320*showCount, movedScoll.frame.size.height)];
    
    if(viewlist==nil)
    {
        self.viewlist=[[[NSMutableArray alloc] init] autorelease];
    }
    
    for(UIView *view in [movedScoll subviews])
    {
        [view removeFromSuperview];
    }
    for(int i=0;i<showCount;i++)
    {
        if([[SettingDAL sharedInstance] isAutoLocation]&&i==0)
        {
            SingleWeatherView *tmpView=[[SingleWeatherView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 480)];
            [tmpView updateWeatherInThread];
            [movedScoll addSubview:tmpView];
            [self.viewlist addObject:tmpView];
            [tmpView release];
            
            continue;
        }
        int index=i;
        if([[SettingDAL sharedInstance] isAutoLocation])
        {
            index--;
        }
        SingleWeatherView *tmpView=[[SingleWeatherView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 480) withCity:[savedCitylist objectAtIndex:index]];
        [movedScoll addSubview:tmpView];
        [self.viewlist addObject:tmpView];
        [tmpView release];
    }
    
    if([[SettingDAL sharedInstance] isAutoLocation])
    {
        [pageController setNumberOfPages:[savedCitylist count]+1];
    }
    else
    {
        [pageController setNumberOfPages:[savedCitylist count]];
    }
}

-(void)reloadMainUIInThread
{
    @autoreleasepool {
        //是否重新加载风格
        if([[SettingDAL sharedInstance]getCurrentTheme]!=currentStle)
        {
            currentStle=[[SettingDAL sharedInstance]getCurrentTheme];
            [self performSelectorOnMainThread:@selector(reloadStyle) withObject:nil waitUntilDone:YES];
        }
        
        //根据本地存储的城市重新加载数据
        //得到本地存储的城市列表
        self.savedCitylist=[[SettingDAL sharedInstance] getSaveCitylist];
        
        [self performSelectorOnMainThread:@selector(updateMainUI) withObject:self waitUntilDone:YES];
    }
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self reloadMainUIInThread];
//    [NSThread detachNewThreadSelector:@selector(reloadMainUIInThread) toTarget:self withObject:nil];
    self.hud=[[CommonHelper sharedInstance] showHud:self title:@"请稍后..." selector:@selector(reloadMainUIInThread) arg:nil targetView:self.view];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)pageControllerClick:(id)sender
{
    UIPageControl *pageCl=(UIPageControl *)sender;
    [movedScoll setContentOffset:CGPointMake(pageCl.currentPage*320, movedScoll.frame.origin.y) animated:YES];
}

#pragma UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageIndex=(scrollView.contentOffset.x+160)/320;
    [pageController setCurrentPage:pageIndex];
}

@end
