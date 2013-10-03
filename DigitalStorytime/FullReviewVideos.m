//
//  FullReviewVideos.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/26/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import "FullReviewVideos.h"
//#import "BookReviewList.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@implementation FullReviewVideos
@synthesize videoWebView;
@synthesize portraitWebContainer;
@synthesize landscapeWebContainer;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    reviewData = app.currentReview;
    NSString *htmlString = [NSString stringWithFormat:@"<iframe width=\"640\" height=\"360\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\" allowfullscreen></iframe>",reviewData.YouTubeLink];
       
       
    [videoWebView loadHTMLString:htmlString baseURL:nil];
    
    videoWebView.layer.cornerRadius = 30.0f;
    videoWebView.layer.masksToBounds = YES;
    
}

- (void)viewDidUnload
{
    [self setVideoWebView:nil];
    [self setPortraitWebContainer:nil];
    [self setLandscapeWebContainer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void)dealloc {
    [videoWebView release];
    [portraitWebContainer release];
    [landscapeWebContainer release];
    [super dealloc];
}

- (void)orientationChange:(UIInterfaceOrientation)toInterfaceOrientation {
    [super orientationChange:toInterfaceOrientation];
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight 
        ||toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) 
    {
        [self.landscapeWebContainer addSubview:videoWebView];
    }
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait 
        ||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) 
    {
        [self.portraitWebContainer addSubview:videoWebView];
    }


}

@end
