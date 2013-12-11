//
//  ThemeViewController.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeModel.h"
#import "SettingDAL.h"
#import "ThemeScreentShotCell.h"

@interface ThemeViewController () {
@private
}

-(ThemeModel *)getThemeFromStyle:(ThemeStyle)themeStyle;

@end

@implementation ThemeViewController

@synthesize themelist;

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

-(ThemeModel *)getThemeFromStyle:(ThemeStyle)themeStyle
{
    ThemeModel *themeModel=[[[ThemeModel alloc] init]autorelease];
    NSString *themeName=nil;
    NSString *themeImageName=[NSString stringWithFormat:@"skin0%d/screenShot.PNG",(int)themeStyle];
    themeModel.themeStyle=themeStyle;
    switch (themeStyle) {
        case ThemeClearStyle:
            themeName=@"玻璃风格";
            break;
        case ThemeGrayStyle:
            themeName=@"灰色风格";
            break;
        case ThemeBlueStyle:
            themeName=@"蓝色风格";
            break;
        case ThemeOrangeStyle:
            themeName=@"橙黄风格";
            break;
        case ThemeBlackEdgeStyle:
            themeName=@"棱角黑色风格";
            break;
        case ThemeBlackRoundStyle:
            themeName=@"圆角黑色风格";
            break;
        default:
            themeName=@"玻璃风格";
            break;
    }
    themeModel.themeName=themeName;
    themeModel.themeImage=[UIImage imageNamed:themeImageName];
    return themeModel;
}

#pragma mark - View lifecycle

-(void)loadView
{
    [super loadView];
    self.navigationItem.title=@"皮肤设置";
    
    themelist=[[NSMutableArray alloc] init];
    
    [themelist addObject:[self getThemeFromStyle:ThemeClearStyle]];
    [themelist addObject:[self getThemeFromStyle:ThemeBlueStyle]];
    [themelist addObject:[self getThemeFromStyle:ThemeBlackEdgeStyle]];
    [themelist addObject:[self getThemeFromStyle:ThemeBlackRoundStyle]];
    [themelist addObject:[self getThemeFromStyle:ThemeOrangeStyle]];
    [themelist addObject:[self getThemeFromStyle:ThemeGrayStyle]];
}

-(void)releaseCache
{
    self.themelist=nil;
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
    return [themelist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ThemeScreentShotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ThemeScreentShotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    ThemeModel *theme=[themelist objectAtIndex:indexPath.row];
    
    if(theme.themeStyle==[[SettingDAL sharedInstance] getCurrentTheme])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.lblthemeName.text=theme.themeName;
    cell.screenShotImgView.image=theme.themeImage;
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

-(int)getRowByStyle:(ThemeStyle)themeStyle
{
    int row=0;
    for(ThemeModel *theme in themelist)
    {
        if(theme.themeStyle==themeStyle)
        {
            break;
        }
        row++;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    //取消上一个cell的选中状态
    UITableViewCell *preCell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self getRowByStyle:[[SettingDAL sharedInstance]getCurrentTheme]] inSection:0]];
    [preCell setAccessoryType:UITableViewCellAccessoryNone];
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    ThemeModel *theme=[themelist objectAtIndex:indexPath.row];
    [[SettingDAL sharedInstance] updateCurrentTheme:theme.themeStyle];
}

@end
