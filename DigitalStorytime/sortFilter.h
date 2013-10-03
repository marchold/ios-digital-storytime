//
//  sortFilter.h
//  DigitalStorytime
//
//  Created by Chea Yeam on 8/14/11.
//  Copyright 2011 City Orb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterListener <NSObject>
-(void) filterByLanguage:(NSString*)language andAge:(int)ageGroup;
@end

@interface sortFilter : UIViewController {
    NSArray *filterList2;
    NSArray *filterList3;
    NSString *queryString;
    UIPopoverController* popoverController;
    id<FilterListener> filterListener;
    id delegate;

}
@property (nonatomic,retain) NSString *queryString;
@property (assign, nonatomic) UIPopoverController* popoverController;
@property (nonatomic,retain) id delegate;

-(void) setFilterListener:(id <FilterListener>)listener;
@end
