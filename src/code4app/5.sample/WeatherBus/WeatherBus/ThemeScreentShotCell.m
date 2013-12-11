//
//  ThemeScreentShotCell.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThemeScreentShotCell.h"

@implementation ThemeScreentShotCell

@synthesize screenShotImgView;
@synthesize lblthemeName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        screenShotImgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 180)];
        [self addSubview:screenShotImgView];
        
        lblthemeName=[[UILabel alloc] initWithFrame:CGRectMake(140, 70, 170, 40)];
        [lblthemeName setBackgroundColor:[UIColor clearColor]];
        [lblthemeName setFont:[UIFont fontWithName:@"Hevtical" size:25]];
        [lblthemeName setFont:[UIFont boldSystemFontOfSize:20]];
        [self addSubview:lblthemeName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.screenShotImgView=nil;
    self.lblthemeName=nil;
    [super dealloc];
}
@end
