//
//  StarRatings.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/26/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarBar.h"
#import "ReviewData.h"
#import "ChildPageViewControler.h"

@interface StarRatings : UIViewController {
    ReviewData *reviewData;
    
    IBOutlet StarBar *overallRating;
    IBOutlet StarBar *animationRating;
    IBOutlet StarBar *originalityStars;
    
    IBOutlet UILabel *overallNumeric;
    IBOutlet UILabel *animationlNumeric;
    IBOutlet UILabel *originalitylNumeric;
    IBOutlet UILabel *interactivitylNumeric;
    IBOutlet UILabel *rereadabilitylNumeric;
    IBOutlet UILabel *extraslNumeric;
    IBOutlet UILabel *educationallNumeric;
    IBOutlet UILabel *bedtimelNumeric;
    IBOutlet UILabel *audioNumeric;

    IBOutlet UIImageView *screenShot;
    int currentScreenShotIndex;
    int currentThumbNailIndex;
    IBOutlet UIImageView *thumbnail1;
    IBOutlet UIImageView *thumbnail2;
    IBOutlet UIImageView *thumbnail3;
    IBOutlet UIImageView *thumbnail4;
    IBOutlet UIImageView *reflection;
    
    NSMutableArray *screenShotUIImages;
    NSMutableArray *screenShotThumbnailImageViews;
    
}


@property (retain, nonatomic) IBOutlet StarBar *overallRating;
@property (retain, nonatomic) IBOutlet StarBar *animationRating;
@property (retain, nonatomic) IBOutlet StarBar *originalityStars;
@property (retain, nonatomic) IBOutlet StarBar *interactivityStars;
@property (retain, nonatomic) IBOutlet StarBar *rereadabilityStars;
@property (retain, nonatomic) IBOutlet StarBar *extrasStars;
@property (retain, nonatomic) IBOutlet StarBar *bedtimeStars;
@property (retain, nonatomic) IBOutlet StarBar *educationalStars;
@property (retain, nonatomic) IBOutlet StarBar *audioStars;

@property (retain, nonatomic)  NSMutableArray *screenShotUIImages;
@property (retain, nonatomic)  NSMutableArray *screenShotThumbnailImageViews;


@property (retain, nonatomic) IBOutlet UILabel *overallNumeric;
@property (retain, nonatomic) IBOutlet UILabel *animationlNumeric;
@property (retain, nonatomic) IBOutlet UILabel *originalitylNumeric;
@property (retain, nonatomic) IBOutlet UILabel *interactivitylNumeric;
@property (retain, nonatomic) IBOutlet UILabel *rereadabilitylNumeric;
@property (retain, nonatomic) IBOutlet UILabel *extraslNumeric;
@property (retain, nonatomic) IBOutlet UILabel *educationallNumeric;
@property (retain, nonatomic) IBOutlet UILabel *bedtimelNumeric;
@property (retain, nonatomic) IBOutlet UILabel *audioNumeric;




@property (retain, nonatomic) IBOutlet UIImageView *screenShot;
@property (retain, nonatomic) IBOutlet UIImageView *reflection;

- (IBAction)previousScreenShot:(id)sender;
- (IBAction)nextScreenShot:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *thumbnail1;
@property (retain, nonatomic) IBOutlet UIImageView *thumbnail2;
@property (retain, nonatomic) IBOutlet UIImageView *thumbnail3;
@property (retain, nonatomic) IBOutlet UIImageView *thumbnail4;
@end
