//
//  AppDelegate.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/9/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewData.h"
#import "DataFetcher.h"
#import "DetailViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ReviewListReciever>{
    ReviewData *currentReview;
    int thisUserId;
    NSUserDefaults *preferances;
    DetailViewController *detailViewController;
}
@property (nonatomic, retain) ReviewData *currentReview;

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) UISplitViewController *splitViewController;
@property (readonly) int thisUserId;

@end
