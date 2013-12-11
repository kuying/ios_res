//
//  SettingViewController.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "ThemeViewController.h"
#import "LocationManagerViewController.h"

@interface SettingViewController () {
@private
    
}

-(void)dismissViewAction:(id)sender;            //点击完成按钮，显示当前视图

@end

@implementation SettingViewController

@synthesize datalist;

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

-(void)dismissViewAction:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

-(void)loadView
{
    [super loadView];
    
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissViewAction:)]autorelease];
    
    datalist=[[NSMutableArray alloc] init];
    
    //第一个Section
    NSMutableArray *section1list=[[[NSMutableArray alloc] init] autorelease];
    [section1list addObject:@"更换主题"];
    [datalist addObject:section1list];
    
    
    //第2个Section
    NSMutableArray *section2list=[[[NSMutableArray alloc] init] autorelease];
    [section2list addObject:@"地区管理"];
    [datalist addObject:section2list];
    
    //第3个section ，相关链接
    NSMutableArray *section3list=[[[NSMutableArray alloc] init] autorelease];
    [section3list addObject:@"iPhone中文网"];
    [section3list addObject:@"电玩巴士"];
    [datalist addObject:section3list];
}

-(void)releaseCache
{
    self.datalist=nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseCache];
}

-(void)dealloc
{
    [self releaseCache];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
    return [datalist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[datalist objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    NSString *cellText=[[datalist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text=cellText;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellString=[[datalist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([cellString isEqualToString:@"更换主题"])
    {
        ThemeViewController *detailViewController = [[ThemeViewController alloc] init];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    if([cellString isEqualToString:@"地区管理"])
    {
        LocationManagerViewController*detailViewController = [[LocationManagerViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    if([cellString isEqualToString:@"电玩巴士"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tgbus.com"]];
    }
    if([cellString isEqualToString:@"iPhone中文网"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://i.tgbus.com"]];
    }
    if(indexPath.section==2)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
