//
//  fullReview.m
//  DigitalStorytime
//
//  Created by Chea Yeam on 8/18/11.
//  Copyright 2011 City Orb. All rights reserved.
//

#import "fullReview.h"
#import "ReviewData.h"
#import "AppDelegate.h"
#import "DataFetcher.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Html.h"

@implementation fullReview
@synthesize ratingsBar;
@synthesize author;
@synthesize textBody;
@synthesize textBorderView;
@synthesize topTabBackground;
@synthesize glossEffect;

@synthesize dateOfReview;

@synthesize currentReview;
@synthesize coverPageImageUrl;

@synthesize overallNumeric;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [dateOfReview release];
    [overallNumeric release];
    [ratingsBar release];
    [coverPageImageUrl release];

    [author release];
    [textBody release];
    [textBorderView release];
    [topTabBackground release];
    [glossEffect release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get the current review
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    reviewData = app.currentReview;

    coverPageImageUrl.layer.cornerRadius = 10.0f;
    coverPageImageUrl.layer.masksToBounds = YES;
    coverPageImageUrl.backgroundColor = [UIColor clearColor];
    [coverPageImageUrl setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://digital-storytime.com/images/scaled_%@",reviewData.coverPageImageUrl]]];
    
    dateOfReview.text   = [reviewData dateOfReview];
       
    overallNumeric.text   = [NSString stringWithFormat:@"%3.2f",reviewData.overallRating];
    
        
    self.textBody.text = [reviewData.reviewBody stringByStrippingHTML]; 
   
    self.textBorderView.layer.borderWidth = 1;
    self.textBorderView.layer.borderColor = UIColorFromRGB(0xDDDDDDDD).CGColor;
    
    [self.textBody sizeToFit];
    // dataFetcher = [DataFetcher getSingltonInstance];
    
    self.glossEffect.layer.cornerRadius = 10.0f;
    self.glossEffect.layer.masksToBounds = YES;
      
 //   NSString* temp = [NSString stringWithFormat:
  //                    @"<img src='http://digital-storytime.com/images/scaled_%@' width='310px' height='223px'>",reviewData.coverPageImageUrl];
   // [coverPageImageUrl loadHTMLString:temp baseURL:nil ];// resized to aspect ratio (356x267) - cy
    
   // [coverPageImageUrl loadHTMLString:[NSString stringWithFormat:
    //                                   @"<img src='http://digital-storytime.com/images/scaled_%@' width='310px' height='223px'>",reviewData.coverPageImageUrl] baseURL:nil];// resized to aspect ratio (356x267) - cy
    //[contentReview loadHTMLString:reviewData.reviewBody baseURL:nil];
    
    //Set ratings stars
    [ratingsBar draw:reviewData.overallRating StarsOfSize:27];
    
    
}

- (void)viewDidUnload
{

    [self setDateOfReview:nil];
    [self setRatingsBar:nil];
    [coverPageImageUrl release];
    
    [self setAuthor:nil];
    [self setTextBody:nil];
    [self setTextBorderView:nil];
    [self setTopTabBackground:nil];
    [self setGlossEffect:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)orientationChange:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight 
        ||toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) 
    {
        topTabBackground.frame = CGRectMake(40, 0, 945, 146);
        coverPageImageUrl.frame = CGRectMake(53, 2, 190, 132);
        glossEffect.frame = CGRectMake(57, 0, 182, 136);
        self.textBorderView.frame = CGRectMake(40, 164, 945, 804); 
    }
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait 
        ||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) 
    {
        topTabBackground.frame = CGRectMake(40, 0, 685, 186);
        coverPageImageUrl.frame = CGRectMake(53, 2, 220, 172);
        glossEffect.frame = CGRectMake(53, 2, 220, 172);
        self.textBorderView.frame = CGRectMake(40, 194, 685, 804);
    }
    [self.textBody sizeToFit];
}



@end
