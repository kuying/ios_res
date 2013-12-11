//
//  LocationViewController.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationViewController.h"
#import "WeatherDAL.h"
#import "CityModel.h"
#import "SettingDAL.h"
#import "CommonHelper.h"
#import "AppDelegate.h"

@interface LocationViewController () {
@private
}

-(void)goTopAction:(id)sender;          //回到顶部
-(void)dismissSelf:(id)sender;          //消失当前是视图
-(BOOL)isSaved:(NSString *)cityID;      //判断是否已经存储了

@end
@implementation LocationViewController

@synthesize citylist,savedCitylist;
@synthesize resultCitylist;
@synthesize searchDC;
@synthesize searchBar;
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

-(void)goTopAction:(id)sender
{
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)dismissSelf:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)reloadSavedCitylist
{
    self.citylist=[[WeatherDAL sharedInstaced] getLocalCities];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

#pragma mark - View lifecycle

-(void)loadView
{
    [super loadView];
    
    self.searchBar=[[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [searchBar setTintColor:[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0]];
    searchBar.placeholder=@"请在此输入您要查找的城市名称";
    [self.tableView setTableHeaderView:self.searchBar];
    
    self.searchDC=[[[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self] autorelease];
    [self.searchDC setDelegate:self];
    [self.searchDC setSearchResultsDelegate:self];
    [self.searchDC setSearchResultsDataSource:self];
    
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"回到顶部" style:UIBarButtonItemStyleBordered target:self action:@selector(goTopAction:)] autorelease];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSelf:)] autorelease];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.hud=[[CommonHelper sharedInstance] showHud:self title:@"请稍后..." selector:@selector(reloadSavedCitylist) arg:nil targetView:appDelegate.window];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:searchDC.searchResultsTableView])
    {
        return [self.resultCitylist count];
    }
    return [self.citylist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    CityModel *city=nil;
    if([tableView isEqual:searchDC.searchResultsTableView])
    {
        city=[self.resultCitylist objectAtIndex:indexPath.row];
    }
    else
    {
        city=[citylist objectAtIndex:indexPath.row];
    }
    cell.textLabel.text=city.cityName;
    if([self isSaved:city.cityID])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

-(BOOL)isSaved:(NSString *)cityID
{
    BOOL flag=NO;
    if(self.savedCitylist==nil)
    {
        self.savedCitylist=[[SettingDAL sharedInstance] getSaveCitylist];
    }
    for(CityModel *city in savedCitylist)
    {
        if([city.cityID isEqualToString:cityID])
        {
            flag=YES;
            break;
        }
    }
    return flag;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityModel *city=nil;
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if([tableView isEqual:searchDC.searchResultsTableView])
    {
        city=[self.resultCitylist objectAtIndex:indexPath.row];
    }
    else
    {
        city=[citylist objectAtIndex:indexPath.row];
    }

    if(cell.accessoryType==UITableViewCellAccessoryCheckmark)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[SettingDAL sharedInstance] deleteCityByCityID:city.cityID];
    }
    else
    {
        if([[[SettingDAL sharedInstance] getSaveCitylist] count]>=kMaxCityCount)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您最多可以添加%d个城市",kMaxCityCount] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }

        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[SettingDAL sharedInstance]insertNewCity:city];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:searchDC.searchResultsTableView])
    {
        return 44;
    }
    else
    {
        return 40;
    }
}
#pragma market - SearchDisplayBar的委托

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.cityName CONTAINS %@",searchString];
    self.resultCitylist=[self.citylist filteredArrayUsingPredicate:predicate];
    return YES;
}

@end
