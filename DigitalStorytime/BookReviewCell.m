//
//  BookReviewCell.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 8/14/11.
//  Copyright 2011 City Orb. All rights reserved.
//

#import "BookReviewCell.h"


@implementation BookReviewCell
@synthesize bookTitle;
@synthesize reviewBody;
@synthesize icon;
@synthesize stars;
@synthesize price;
@synthesize starBar;


- (void)dealloc
{
    [bookTitle release];
    [reviewBody release];
    [icon release];
    [stars release];
    [price release];
    [super dealloc];
}

@end
