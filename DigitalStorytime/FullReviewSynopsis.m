//
//  FullReviewSynopsis.m
//  DigitalStorytime
//
//  Created by Chea Yeam on 8/18/11.
//  Copyright 2011 City Orb. All rights reserved.
//

#import "FullReviewSynopsis.h"
#import "ReviewData.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@implementation FullReviewSynopsis
@synthesize price;
@synthesize synop;
@synthesize coverPageImageUrl;
@synthesize synopAuthor;
@synthesize lengthLabel;
@synthesize lengthViewContainer;
@synthesize synopTextContainer;
@synthesize topTabImage;
@synthesize currentReview;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [price release];
    [synop release];
    [coverPageImageUrl release];
    [synopAuthor release];
    
    [lengthLabel release];
    [lengthViewContainer release];
    [synopTextContainer release];
    [topTabImage release];
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
    
    //Set price
    curencyFormatter = [[NSNumberFormatter alloc] init];
    [curencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    synopAuthor.text = [reviewData author];
    
    self.synop.text = [reviewData.synopsis stringByStrippingHTML]; 
    [self.synop sizeToFit];
     
     
    self.synopTextContainer.layer.borderWidth = 1;
    self.synopTextContainer.layer.borderColor = UIColorFromRGB(0xDDDDDDDD).CGColor;

    
    price.text =  [curencyFormatter stringFromNumber:[NSNumber numberWithFloat:reviewData.price]];
    
    
    [coverPageImageUrl setImageWithURL:[NSURL URLWithString:reviewData.icon]];
    coverPageImageUrl.layer.cornerRadius = 10.0f;
    coverPageImageUrl.layer.masksToBounds = YES;
    
}

- (void)viewDidUnload
{
    [self setPrice:nil];
    [synop release];
    synop = nil;
    [coverPageImageUrl release];
    coverPageImageUrl = nil;
    [synopAuthor release];
    synopAuthor = nil;
    
  
    
    [self setLengthLabel:nil];
    [self setLengthViewContainer:nil];
    [self setSynopTextContainer:nil];
    [self setTopTabImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)orientationChange:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight 
        ||toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) 
    {
        topTabImage.frame = CGRectMake(40, 0, 945, 146);
//        coverPageImageUrl.frame = CGRectMake(53, 2, 190, 132);
//        glossEffect.frame = CGRectMake(57, 0, 182, 136);
        self.synopTextContainer.frame = CGRectMake(40, 164, 945, 804); 
    }
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait 
        ||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) 
    {
        topTabImage.frame = CGRectMake(40, 0, 685, 186);
//        coverPageImageUrl.frame = CGRectMake(53, 2, 220, 172);
//        glossEffect.frame = CGRectMake(53, 2, 220, 172);
        self.synopTextContainer.frame = CGRectMake(40, 194, 685, 804);
    }
    [self.synop sizeToFit];
}



@end
