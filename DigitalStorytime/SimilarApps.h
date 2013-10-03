//
//  SimilarApps.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/26/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewData.h"
#import "SimilarAppsTableCell.h"
#import "DataFetcher.h"
#import "ChildPageViewControler.h"

@interface SimilarApps : ChildPageViewControler <SimilarAppsListReciever> {
    ReviewData *reviewData;
    NSMutableArray *listOfVersions; 
    NSMutableArray *similarRatedAps; 
    NSMutableArray *sameDeveloper; 
    NSMutableArray *sections;
}

@property (retain, nonatomic) NSMutableArray *listOfVersions; 
@property (retain, nonatomic) NSMutableArray *similarRatedAps; 
@property (retain, nonatomic) NSMutableArray *sameDeveloper; 
@property (retain, nonatomic) NSMutableArray *sections; 



- (void)didRecieveVersions:(NSMutableArray *)listOfVersions andSimilarByRating:(NSMutableArray *)similarRatedAps andByDeveloper:(NSMutableArray *)sameDeveloper;

@property (retain, nonatomic) IBOutlet UIView *topSixPatch;
@property (retain, nonatomic) IBOutlet UIView *bottomSizPatch;
@property (retain, nonatomic) IBOutlet UIView *landscapeTopSixPatch;
@property (retain, nonatomic) IBOutlet UIView *landscapeBottomSixPatch;
@end
