//
//  ReviewDetailsPages.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/17/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "ReviewDetailsPages.h"
#import "fullReview.h"
#import "FullReviewSynopsis.h"
#import "FullReviewVideos.h"
#import "StarRatings.h"
#import "SimilarApps.h"
#import "FullReviewDetails.h"
#import "ChildPageViewControler.h"
#import "ReviewData.h"
#import "AppDelegate.h"


@implementation ReviewDetailsPages
@synthesize titleOfBookLabel;
@synthesize reviewSectionLabel;
@synthesize bredcrumMarkerIcon;
@synthesize dotsBackground;
@synthesize breadcrumBarContainer;
@synthesize iconBarImage;
@synthesize downloadItunes;
@synthesize back;
@synthesize nextButton;
@synthesize previousButton;
@synthesize pageFlipper;
@synthesize pageControlDots;
@synthesize viewControllers;
@synthesize pageTitleList;
@synthesize breadcrumImage;

@synthesize pageList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) updatePageDimentions:(UIViewController *)controler forPage:(int) page{
    controler.view.frame = CGRectMake(pageFlipper.frame.size.width * page,
                                      0,
                                      controler.view.frame.size.width,
                                      controler.view.frame.size.height); 
}

-(void) setView:(UIViewController *)controler forPage:(int) page{
    [self updatePageDimentions:controler forPage:page];
    [pageFlipper addSubview:controler.view];
    [pageList insertObject:controler atIndex:page];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ReviewData *reviewData = app.currentReview;

    pageList = [[NSMutableArray alloc] initWithCapacity:5];
    [self setView:[[[fullReview alloc]         initWithNibName:@"fullReview" bundle:nil] autorelease]         forPage:0];
    [self setView:[[[FullReviewSynopsis alloc] initWithNibName:@"FullReviewSynopsis" bundle:nil] autorelease] forPage:1];
    [self setView:[[[StarRatings alloc]        initWithNibName:@"StarRatings" bundle:nil] autorelease]        forPage:2];
    [self setView:[[[FullReviewVideos alloc]   initWithNibName:@"FullReviewVideos" bundle:nil] autorelease]   forPage:3];
    [self setView:[[[SimilarApps alloc]        initWithNibName:@"SimilarApps" bundle:nil] autorelease]        forPage:4];
    
    pageControlDots.numberOfPages = [pageList count];
    pageFlipper.contentSize = CGSizeMake(pageFlipper.frame.size.width * [pageList count], pageFlipper.frame.size.height+500);
    
    titleOfBookLabel.text = reviewData.bookTitle;
    self.pageTitleList = [NSArray arrayWithObjects:@"Review",@"Synopsys",@"Ratings & Screens",@"Videos",@"Related Apps",nil];
    reviewSectionLabel.text = [pageTitleList objectAtIndex:0];
    
    self.breadcrumImage = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"Breadcrumb-review.png"],
                            [UIImage imageNamed:@"Breadcrumb-synop.png"],
                            [UIImage imageNamed:@"Breadcrumb-ratings.png"],
                            [UIImage imageNamed:@"Breadcrumb-video.png"],
                            [UIImage imageNamed:@"Breadcrumb-similar.png"],
                            nil];
    
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    [self.previousButton setEnabled:NO];
}

int width=-1;
int height=-1;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   
    int oldWidth;
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight 
        ||toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) 
    {
        width=1024;
        height=748;
        oldWidth=768;
        dotsBackground.frame = CGRectMake(445, 671, 133, 33);
    }
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait 
        ||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) 
    {
        width=768;
        height=1004;
        oldWidth=1024;
        dotsBackground.frame = CGRectMake(318, 928, 133, 33);

    }
    self.view.frame = CGRectMake(0,0, width, height);
    
    int i =0;
    for (ChildPageViewControler *pageViewControler in pageList){
        pageViewControler.view.frame = CGRectMake(width * i++,
                                                  0,
                                                  width,
                                                  height+500);
    }
    
    for (int i = 0; i < [pageList count]; i++){
        [[pageList objectAtIndex:i] orientationChange:toInterfaceOrientation];
    }
    int page = floor((pageFlipper.contentOffset.x - oldWidth / 2) / oldWidth) + 1;
    [pageFlipper setContentOffset:CGPointMake(page*width, pageFlipper.contentOffset.y)];
    pageFlipper.contentSize = CGSizeMake(width * [pageList count], height+500);
    page = floor((pageFlipper.contentOffset.x - width / 2) / width) + 1;
    [pageFlipper setContentOffset:CGPointMake(page*width, pageFlipper.contentOffset.y)];
    
    [self scrollViewDidScroll:pageFlipper];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth;
    if (width==-1) {
        pageWidth = pageFlipper.frame.size.width;
    } else {
        pageWidth = width;
    }
    int page = floor((pageFlipper.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControlDots.currentPage = page;
    reviewSectionLabel.text = [pageTitleList objectAtIndex:page];
    bredcrumMarkerIcon.image = [breadcrumImage objectAtIndex:page];
    
    [sender setContentOffset: CGPointMake(sender.contentOffset.x, sender.contentOffset.y)];
    if (page==0){
        [self.previousButton setEnabled:NO];
    } else {
        [self.previousButton setEnabled:YES];
    }
    if (page>=[pageList count]-1){
        [self.nextButton setEnabled:NO];
    } else {
        [self.nextButton setEnabled:YES];
    }
}


- (IBAction)changePage {
    // update the scroll view to the appropriate page
    [pageFlipper setContentOffset: CGPointMake(pageFlipper.contentOffset.x, 0)];
    CGRect frame;
    frame.origin.x = pageFlipper.frame.size.width * pageControlDots.currentPage;
    frame.origin.y = 0;
    frame.size = pageFlipper.frame.size;
    [pageFlipper scrollRectToVisible:frame animated:YES];

}

- (void)viewDidUnload
{
    [self setPageFlipper:nil];
    [self setPageControlDots:nil];
    [self setIconBarImage:nil];
    [self setDownloadItunes:nil];
    [self setBack:nil];
    [self setNextButton:nil];
    [self setPreviousButton:nil];
    [self setBredcrumMarkerIcon:nil];
    [self setDotsBackground:nil];
    [self setBreadcrumBarContainer:nil];
    [self setTitleOfBookLabel:nil];
    [self setReviewSectionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [pageFlipper release];
    [pageControlDots release];

    [iconBarImage release];
    [downloadItunes release];
    [back release];
    [nextButton release];
    [previousButton release];
    [bredcrumMarkerIcon release];
    [dotsBackground release];
    [breadcrumBarContainer release];
    [titleOfBookLabel release];
    [reviewSectionLabel release];
    [pageTitleList release];
    [breadcrumImage release];
    [super dealloc];
}
- (IBAction)previousClicked:(id)sender {
    [pageFlipper setContentOffset:CGPointMake(pageFlipper.contentOffset.x-pageFlipper.frame.size.width, 0) animated:YES];
}

- (IBAction)nextClicked:(id)sender {
    [pageFlipper setContentOffset:CGPointMake(pageFlipper.contentOffset.x+pageFlipper.frame.size.width, 0) animated:YES];
}

- (IBAction)exitButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:NO];
}

- (IBAction)wishListButtonSelector:(id)sender {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ReviewData *rd = app.currentReview;
    NSString *requestString =  [NSString stringWithFormat:
                                @"http://digital-storytime.com/WebService/getJsonReview.php?wantit=%d&review=%d&key=helloWorld123",app.thisUserId,rd.reviewId];
    NSLog(@"%@",requestString);
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc]initWithRequest:request] autorelease];
    [operation  
     setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) 
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Added to wishlist" 
                                                         message:@"You will be notified of price drops for this app." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         [alert release];
     } 
     failure:^(AFHTTPRequestOperation *operation, NSError *error) 
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to add to wishlist" 
                                                         message:@"There was a problem saving your request, please check your internet connection." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         [alert release];
     }]; 
    [operation start];
}

- (IBAction)buyButtonClicked:(id)sender {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ReviewData *rd = app.currentReview;
    [rd openReferralURL];
}
@end
