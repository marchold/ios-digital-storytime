//
//  ChildPageViewControler.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/17/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "ChildPageViewControler.h"


@implementation ChildPageViewControler
@synthesize owner;
@synthesize portrait;
@synthesize landscape;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc {
    [super dealloc];
    [portrait release];
    [landscape release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}



- (void)orientationChange:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight 
        ||toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) 
    {
        self.view = landscape;
    }
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait 
        ||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) 
    {
        self.view = portrait;
    }
}


@end
