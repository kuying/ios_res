//
//  LocationManagerViewController.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationManagerViewController.h"
#import "LocationViewController.h"
#import "SettingDAL.h"
#import "CityModel.h"
#import "CommonHelper.h"

@interface LocationManagerViewController () {
@private
}

-(void)addNewCity:(id)sender;
-(void)autoLocationAction:(id)sender;

@end

@implementation LocationManagerViewController

@synthesize savedCity;
@synthesize hud;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

-(void)addNewCity:(id)sender
{
    if([savedCity count]>=kMaxCityCount)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您最多可以添加%d个城市",kMaxCityCount] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    LocationViewController *locationController=[[LocationViewController alloc] init];
    locationController.navigationItem.title=@"新增城市";
    
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:locationController];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    [self presentModalViewController:navController animated:YES];
    [navController release];
    
    [locationController release];
}

-(void)reloadSavedCitylist
{
     self.savedCity=[[SettingDAL sharedInstance] getSaveCitylist];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

#pragma mark - View lifecycle

-(void)loadView
{
    [super loadView];
    
    self.navigationItem.title=@"地区管理";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCity:)] autorelease];
    
//    CALayer *overlayer=[CALayer layer];
//    [overlayer setFrame:CGRectMake(0, 0, 320, 416)];
//    [overlayer setCornerRadius:8];
//    
//    [self.tableView.layer addSublayer:overlayer];
//    [self.tableView.layer setCornerRadius:8.0];
//    [self.tableView.layer setMasksToBounds:YES];
    
    [self.tableView setEditing:YES];
    
    self.hud=[[CommonHelper sharedInstance] showHud:self title:@"请稍后..." selector:@selector(reloadSavedCitylist) arg:nil targetView:self.view];
}

-(void)releaseCacheData
{
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.savedCity=[[SettingDAL sharedInstance] getSaveCitylist];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)autoLocationAction:(id)sender
{
    UISwitch *switcher=(UISwitch *)sender;
    [[SettingDAL sharedInstance] updateAutoLocation:switcher.isOn];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else
    {
        return [savedCity count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        static NSString *CellIdentifier = @"AutoCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            
            CGRect rect=CGRectMake(200, 8, 75, 35);
            if([[[UIDevice currentDevice] systemVersion] intValue]>=5)
            {
                rect=CGRectMake(220, 8, 75, 35);
            }
            UISwitch *autoSwitch=[[UISwitch alloc] initWithFrame:rect];
            [autoSwitch setTag:500];
            [autoSwitch addTarget:self action:@selector(autoLocationAction:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:autoSwitch];
        }
        
       cell.textLabel.text=@"自动";
        cell.detailTextLabel.text=@"使用当前地区天气";
        UISwitch *switcher=(UISwitch *)[cell viewWithTag:500];
        [switcher setOn:[[SettingDAL sharedInstance] isAutoLocation]];
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        CityModel *city=[savedCity objectAtIndex:indexPath.row];
        cell.textLabel.text=city.cityName;
        
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return @"启动该功能后，您当前位置的天气会显示在首页的最左侧";
    }
    if(section==1)
    {
        return @"显示在首页的其它地区天气";
    }
    return nil;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CityModel *city=[savedCity objectAtIndex:indexPath.row];
        [[SettingDAL sharedInstance] deleteCityByCityID:city.cityID];
        [savedCity removeObject:city];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if(sourceIndexPath.section != proposedDestinationIndexPath.section){
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    CityModel *city=[[savedCity objectAtIndex:fromIndexPath.row] retain];
    [savedCity removeObjectAtIndex:fromIndexPath.row];
    [savedCity insertObject:city atIndex:toIndexPath.row];
    [city release];
    
    [[SettingDAL sharedInstance] updateSavedCitylist:savedCity];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
