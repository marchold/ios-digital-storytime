//
//  FullReviewVideos.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/26/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewData.h"
#import "ChildPageViewControler.h"

@interface FullReviewVideos : ChildPageViewControler{
    IBOutlet UIWebView *videoWebView;
    ReviewData *reviewData;
    IBOutlet UIView *portraitWebContainer;
    IBOutlet UIView *landscapeWebContainer;
}
@property (retain, nonatomic) IBOutlet UIWebView *videoWebView;
@property (retain, nonatomic) IBOutlet UIView *portraitWebContainer;
@property (retain, nonatomic) IBOutlet UIView *landscapeWebContainer;

@end
