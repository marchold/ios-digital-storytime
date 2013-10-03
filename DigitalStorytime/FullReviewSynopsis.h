//
//  FullReviewSynopsis.h
//  DigitalStorytime
//
//  Created by Chea Yeam on 8/18/11.
//  Copyright 2011 City Orb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import "ChildPageViewControler.h"

@interface FullReviewSynopsis : UIViewController {
    int currentReview;
    DataFetcher *dataFetcher;
    NSNumberFormatter *curencyFormatter;
    
    IBOutlet UILabel *synop;

    ReviewData *reviewData;
    IBOutlet UIImageView *coverPageImageUrl;
    IBOutlet UILabel *synopAuthor;
    IBOutlet UIView *synopTextContainer;
    IBOutlet UIImageView *topTabImage;
}

@property int currentReview;

@property (retain, nonatomic) IBOutlet UILabel *price;

@property (retain, nonatomic) IBOutlet UILabel *synop;

@property (retain, nonatomic) IBOutlet UIImageView *coverPageImageUrl;

@property (retain, nonatomic) IBOutlet UILabel *synopAuthor;


@property (retain, nonatomic) IBOutlet UILabel *lengthLabel;

@property (retain, nonatomic) IBOutlet UIView *lengthViewContainer;

@property (retain, nonatomic) IBOutlet UIView *synopTextContainer;

@property (retain, nonatomic) IBOutlet UIImageView *topTabImage;


@end

