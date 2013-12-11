//
//  ThemeModel.m
//  WeatherBus
//
//  Created by TGBUS on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThemeModel.h"

@implementation ThemeModel

@synthesize themeName;
@synthesize themeImage;
@synthesize themeStyle;

-(void)dealloc
{
    self.themeName=nil;
    self.themeImage=nil;
    [super dealloc];
}

@end
