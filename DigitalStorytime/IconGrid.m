//
//  IconGrid.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/12/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "IconGrid.h"
#import "AppDelegate.h"
#import "InfoPage.h"
#import "FavoritesPage.h"

@implementation IconGrid
@synthesize icon1;
@synthesize icon2;
@synthesize icon3;
@synthesize icon4;
@synthesize icon5;
@synthesize webView;
@synthesize backButton;
@synthesize facebook;
@synthesize twitter;


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

-(void) landscapeLayout{
    icon1.frame = CGRectMake(80, 120 , icon4.frame.size.width , icon4.frame.size.height );
    icon2.frame = CGRectMake(285, 120 , icon4.frame.size.width , icon4.frame.size.height );
    icon3.frame = CGRectMake(475, 120 , icon4.frame.size.width , icon4.frame.size.height );
    icon4.frame = CGRectMake(660, 120 , icon4.frame.size.width , icon4.frame.size.height );
    icon5.frame = CGRectMake(820, 120 , icon4.frame.size.width , icon4.frame.size.height );
    
}

-(void) portraitLayout{
    icon1.frame = CGRectMake(100,  150 , icon4.frame.size.width , icon4.frame.size.height );
    icon2.frame = CGRectMake(285, 150 , icon4.frame.size.width , icon4.frame.size.height );
    icon3.frame = CGRectMake(490, 150 , icon4.frame.size.width , icon4.frame.size.height );
    icon4.frame = CGRectMake(100 , 352 , icon4.frame.size.width , icon4.frame.size.height );
    icon5.frame = CGRectMake(285, 354 , icon4.frame.size.width , icon4.frame.size.height );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://digital-storytime.com/WebService/getJsonReview.php?icon_page=1&key=helloWorld123"]]];
    BOOL isPortrait = UIDeviceOrientationIsPortrait(self.interfaceOrientation);
    if (isPortrait)
    {
        [self portraitLayout];
    } else {
        [self landscapeLayout];
    }    
}


- (void)viewDidUnload
{
    [self setIcon1:nil];
    [self setIcon2:nil];
    [self setIcon3:nil];
    [self setIcon4:nil];
    [self setIcon5:nil];
    [self setWebView:nil];
    [self setBackButton:nil];
    [self setFacebook:nil];
    [self setTwitter:nil];
    [super viewDidUnload];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft 
        || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self landscapeLayout];
    } else {
        [self portraitLayout];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [icon1 release];
    [icon2 release];
    [icon3 release];
    [icon4 release];
    [icon5 release];
    [webView release];
    [backButton release];
    [facebook release];
    [twitter release];
    [super dealloc];
}

- (IBAction)ourWebSite:(id)sender {
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://digital-storytime.com"]];
}

- (IBAction)dailyDealPage:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://digital-storytime.com/sale.php"]];
}

- (IBAction)blog:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://digital-storytime.com/wp"]];
}

- (IBAction)about:(id)sender {
    InfoPage *infoPage = [[[InfoPage alloc] initWithNibName:@"InfoPage" bundle:nil] autorelease];
    [self presentModalViewController:infoPage animated:NO];
}

- (IBAction)booksWant:(id)sender {
    FavoritesPage *favesPage = [[[FavoritesPage alloc] initWithNibName:@"FavoritesPage" bundle:nil] autorelease];
    [self presentModalViewController:favesPage animated:NO];
}

- (IBAction)facebook:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/digital.storytime"]];
}

- (IBAction)twitter:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/#!/iPad_storytime"]];
}

- (IBAction)backButtonOnClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


@end
