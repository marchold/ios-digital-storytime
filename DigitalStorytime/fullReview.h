//
//  fullReview.h
//  DigitalStorytime
//
//  Created by Chea Yeam on 8/18/11.
//  Copyright 2011 City Orb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import "StarBar.h"
#import "ChildPageViewControler.h"

@interface fullReview : UIViewController {
    int currentReview;
    DataFetcher *dataFetcher;
    ReviewData *reviewData;

    

    IBOutlet UILabel *dateOfReview;


    IBOutlet StarBar *ratingsBar;
    IBOutlet UIImageView *coverPageImageUrl;
    IBOutlet UILabel *overallNumeric;

    IBOutlet UIView *textBorderView;
    IBOutlet UILabel *author;
    IBOutlet UILabel *textBody;
    
    IBOutlet UIImageView *topTabBackground;
}

@property int currentReview;

@property (retain, nonatomic) IBOutlet UILabel *dateOfReview;
@property (retain, nonatomic) IBOutlet UIImageView *coverPageImageUrl;
@property (retain, nonatomic) IBOutlet UILabel *overallNumeric;


@property (retain, nonatomic) IBOutlet StarBar *ratingsBar;


@property (retain, nonatomic) IBOutlet UILabel *author;
@property (retain, nonatomic) IBOutlet UILabel *textBody;
@property (retain, nonatomic) IBOutlet UIView *textBorderView;

@property (retain, nonatomic) IBOutlet UIImageView *topTabBackground;

@property (retain, nonatomic) IBOutlet UIImageView *glossEffect;


@end
