//
//  SimilarAppsTableCell.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/3/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import "SimilarAppsTableCell.h"

@implementation SimilarAppsTableCell
@synthesize title;
@synthesize iconImage;
@synthesize iconImageBacking;
@synthesize subText;
@synthesize priceButton;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [title release];
    [iconImage release];
    [iconImageBacking release];
    [subText release];
    [priceButton release];
    [super dealloc];
}
@end
