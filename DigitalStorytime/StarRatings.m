//
//  StarRatings.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/26/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import "StarRatings.h"
//#import "BookReviewList.h"
#import "StarBar.h"
#import "AppDelegate.h"
#import "AFImageRequestOperation.h"
#import <QuartzCore/QuartzCore.h>

@implementation StarRatings
@synthesize thumbnail1;
@synthesize thumbnail2;
@synthesize thumbnail3;
@synthesize thumbnail4;

@synthesize overallRating;
@synthesize animationRating;
@synthesize originalityStars;
@synthesize interactivityStars;
@synthesize rereadabilityStars;
@synthesize extrasStars;
@synthesize bedtimeStars;
@synthesize educationalStars;
@synthesize audioStars;
@synthesize overallNumeric;

@synthesize animationlNumeric;
@synthesize originalitylNumeric;
@synthesize interactivitylNumeric;
@synthesize rereadabilitylNumeric;
@synthesize extraslNumeric;
@synthesize bedtimelNumeric;
@synthesize audioNumeric;


@synthesize screenShot;
@synthesize reflection;
@synthesize screenShotUIImages;
@synthesize screenShotThumbnailImageViews;


// image reflection
static const CGFloat kDefaultReflectionFraction = 0.60;
static const CGFloat kDefaultReflectionOpacity = 0.15;
static const NSInteger kSliderTag = 1337;


@synthesize educationallNumeric;

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

-(NSString*) formatStarNumber:(float)num {
    if (num==-1){
        return @"";
    } else {
        return [NSString stringWithFormat:@"%3.2.f/5",num];
    }
}

#pragma mark - Image Reflection

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
    CGImageRef theCGImage = NULL;
    
    // gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // create the bitmap context
    CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
                                                               8, 0, colorSpace, kCGImageAlphaNone);
    
    // define the start and end grayscale values (with the alpha, even though
    // our bitmap context doesn't support alpha the gradient requires it)
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
    
    // create the CGGradient and then release the gray color space
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGColorSpaceRelease(colorSpace);
    
    // create the start and end points for the gradient vector (straight down)
    CGPoint gradientStartPoint = CGPointZero;
    CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
    
    // draw the gradient into the gray bitmap context
    CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
                                gradientEndPoint, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(grayScaleGradient);
    
    // convert the context into a CGImageRef and release the context
    theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
    CGContextRelease(gradientBitmapContext);
    
    // return the imageref containing the gradient
    return theCGImage;
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create the bitmap context
    CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
                                                        0, colorSpace,
                                                        // this will give us an optimal BGRA format for the device:
                                                        (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGColorSpaceRelease(colorSpace);
    
    return bitmapContext;
}

- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height
{
    if(height == 0)
        return nil;
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
    
    // create a 2 bit CGImage containing a gradient that will be used for masking the 
    // main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
    // function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
    CGImageRef gradientMaskImage = CreateGradientImage(1, height);
    
    // create an image by masking the bitmap of the mainView content with the gradient view
    // then release the  pre-masked content bitmap and the gradient bitmap
    CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
    CGImageRelease(gradientMaskImage);
    
    // In order to grab the part of the image that we want to render, we move the context origin to the
    // height of the image that we want to capture, then we flip the context so that the image draws upside down.
    CGContextTranslateCTM(mainViewContentContext, 0.0, height);
    CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
    
    // draw the image into the bitmap context
    CGContextDrawImage(mainViewContentContext, fromImage.bounds, fromImage.image.CGImage);
    
    // create CGImageRef of the main view bitmap content, and then release that bitmap context
    CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    // convert the finished reflection image to a UIImage 
    UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
    
    // image is retained by the property setting above, so we can release the original
    CGImageRelease(reflectionImage);
    
    return theImage;
}

-(void) updateMirror:(int) widthMinusHeight {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // determine the size of the reflection to create
        NSUInteger reflectionHeight = screenShot.bounds.size.height * kDefaultReflectionFraction;
        
        if (widthMinusHeight<0){ //portrait
            // create the reflection image and assign it to the UIImageView
            reflection.frame = CGRectMake(106+102, reflection.frame.origin.y, 255, reflection.frame.size.height);
            reflection.image = [self reflectedImage:screenShot withHeight:reflectionHeight];
            reflection.alpha = kDefaultReflectionOpacity;

        } else {
            // create the reflection image and assign it to the UIImageView
            reflection.frame = CGRectMake(109, reflection.frame.origin.y, 453, reflection.frame.size.height);
            reflection.image = [self reflectedImage:screenShot withHeight:reflectionHeight];
            reflection.alpha = kDefaultReflectionOpacity;
        }
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    reviewData = app.currentReview;

    [overallRating draw:reviewData.overallRating StarsOfSize:30];
    overallNumeric.text = [self formatStarNumber:reviewData.overallRating];

    [animationRating draw:reviewData.animationRating StarsOfSize:30];
    animationlNumeric.text = [self formatStarNumber:reviewData.animationRating];

    [originalityStars draw:reviewData.originalityRating StarsOfSize:30];
    originalitylNumeric.text = [self formatStarNumber:reviewData.originalityRating];
    
    [interactivityStars draw:reviewData.interactivityRating StarsOfSize:30];
    interactivitylNumeric.text = [self formatStarNumber:reviewData.interactivityRating];

    [rereadabilityStars draw:reviewData.rereadabilityRating StarsOfSize:30];
    rereadabilitylNumeric.text = [self formatStarNumber:reviewData.rereadabilityRating];
    
    [extrasStars draw:reviewData.gamePuzzleExtraRating StarsOfSize:30];
    extraslNumeric.text = [self formatStarNumber:reviewData.gamePuzzleExtraRating];
    
    [bedtimeStars draw:reviewData.bedtimeRating StarsOfSize:30];
    bedtimelNumeric.text = [self formatStarNumber:reviewData.bedtimeRating];

    [educationalStars draw:reviewData.educationalRating StarsOfSize:30];
    educationallNumeric.text = [self formatStarNumber:reviewData.educationalRating];

    [audioStars draw:reviewData.audioQualityRating StarsOfSize:30];
    audioNumeric.text = [self formatStarNumber:reviewData.audioQualityRating];

    self.screenShotUIImages = [NSMutableArray arrayWithCapacity:5];
    self.screenShotThumbnailImageViews = [NSMutableArray arrayWithCapacity:4];
       
    currentThumbNailIndex = 0;
    currentScreenShotIndex = 0;
    
    if ([reviewData.screenShots count] > 0){
        
        for (int i = 0; i < [reviewData.screenShots count]; i++){
           
            NSURL *url = [NSURL URLWithString:[reviewData.screenShots objectAtIndex:i]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            [[AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) 
             {
                 [screenShotUIImages addObject:image];
                 switch (i) {
                     case 0:
                         [screenShot setImage:image];
                         [self updateMirror:screenShot.image.size.width-screenShot.image.size.height];
                         break;
                     case 1:
                         [screenShotThumbnailImageViews addObject:thumbnail1];
                         [thumbnail1  setImage:image];
                         break;
                     case 2:
                         [screenShotThumbnailImageViews addObject:thumbnail2];
                         [thumbnail2  setImage:image];
                         break;
                     case 3:
                         [screenShotThumbnailImageViews addObject:thumbnail3];
                         [thumbnail3  setImage:image];
                         break;
                     case 4:
                         [thumbnail4  setImage:image];
                         [screenShotThumbnailImageViews addObject:thumbnail4];
                         break;
                 }
             }] start];
        }
    } 
    
    currentScreenShotIndex=0;
}

- (void)viewDidUnload
{
    [self setOverallRating:nil];
    [self setAnimationRating:nil];
    [self setAnimationRating:nil];
    [self setOverallNumeric:nil];
    [self setOriginalityStars:nil];
    [self setInteractivityStars:nil];
    [self setRereadabilityStars:nil];
    [self setExtrasStars:nil];
    [self setBedtimeStars:nil];
    [self setEducationalStars:nil];
    [self setAudioStars:nil];
    [self setAudioNumeric:nil];

  
    [self setScreenShot:nil];
    [self setThumbnail1:nil];
    [self setThumbnail2:nil];
    [self setThumbnail3:nil];
    [self setThumbnail4:nil];
    [self setReflection:nil];
    self.screenShotUIImages = nil;
    self.screenShotThumbnailImageViews = nil;
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
    [overallRating release];
    [animationRating release];
    [animationRating release];
    [overallNumeric release];
    [originalityStars release];
    [interactivityStars release];
    [rereadabilityStars release];
    [extrasStars release];
    [bedtimeStars release];
    [educationalStars release];
    [audioStars release];
    [audioNumeric release];
    [screenShotUIImages release];
    [screenShot release];
    [thumbnail1 release];
    [thumbnail2 release];
    [thumbnail3 release];
    [thumbnail4 release];
    [reflection release];
    [screenShotThumbnailImageViews release];
    [super dealloc];
}

- (IBAction)previousScreenShot:(id)sender {
    if (currentScreenShotIndex == 0){
        currentScreenShotIndex = [screenShotUIImages count];
    }
    currentScreenShotIndex--;
    
    if (currentThumbNailIndex == 0){
        currentThumbNailIndex  = [screenShotThumbnailImageViews count];
    }
    currentThumbNailIndex--;
    
  //  UIImage *old = screenShot.image;
    screenShot.image = [screenShotUIImages objectAtIndex:currentScreenShotIndex];
  //  UIImageView *curThumb = [screenShotThumbnailImageViews objectAtIndex:currentThumbNailIndex];
  //  [curThumb setImage:old];
    [self updateMirror:screenShot.image.size.width-screenShot.image.size.height];
}

- (IBAction)nextScreenShot:(id)sender {
    currentScreenShotIndex++;
    if (currentScreenShotIndex == [screenShotUIImages count]){
        currentScreenShotIndex = 0;
    }
    currentThumbNailIndex++;
    if (currentThumbNailIndex == [screenShotThumbnailImageViews count]){
        currentThumbNailIndex = 0;
    }

  //  UIImage *old = screenShot.image;
    screenShot.image = [screenShotUIImages objectAtIndex:currentScreenShotIndex];
  //  UIImageView *curThumb = [screenShotThumbnailImageViews objectAtIndex:currentThumbNailIndex];
  //  [curThumb setImage:old];
    for (int i = 0; i < [screenShotThumbnailImageViews count]; i++){
        UIImageView *thumb = [screenShotThumbnailImageViews objectAtIndex:i];
        if (thumb.image == screenShot.image){
            
            thumb.layer.borderColor = [UIColor redColor].CGColor;
            thumb.layer.borderWidth = 2;
        } else {
            thumb.layer.borderColor = [UIColor clearColor].CGColor;
        }
        
    }
    
    [self updateMirror:screenShot.image.size.width-screenShot.image.size.height];
}

- (void)orientationChange:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight 
        ||toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) 
    {
     //   topTabBackground.frame = CGRectMake(40, 0, 945, 146);
     //   self.textBorderView.frame = CGRectMake(40, 164, 945, 804); 
    }
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait 
        ||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) 
    {
     //   topTabBackground.frame = CGRectMake(40, 0, 685, 186);
     //   coverPageImageUrl.frame = CGRectMake(53, 2, 220, 172);
     //   glossEffect.frame = CGRectMake(53, 2, 220, 172);
      //  self.textBorderView.frame = CGRectMake(40, 194, 685, 804);
    }
}


@end
