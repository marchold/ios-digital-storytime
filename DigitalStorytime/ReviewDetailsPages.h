//
//  ReviewDetailsPages.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/17/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildPageViewControler.h"

@interface ReviewDetailsPages : ChildPageViewControler <UIScrollViewDelegate> {
    IBOutlet UIScrollView *pageFlipper;
    IBOutlet UIPageControl *pageControlDots;
    NSMutableArray *viewControllers;
    int pageNumber;
    NSMutableArray *pageList;

    
    IBOutlet UIImageView *iconBarImage;
    IBOutlet UIButton *downloadItunes;
    IBOutlet UIButton *back;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *previousButton;
    IBOutlet UIImageView *bredcrumMarkerIcon;
    IBOutlet UIImageView *dotsBackground;
    
    IBOutlet UILabel *titleOfBookLabel;
    IBOutlet UILabel *reviewSectionLabel;
    NSArray *pageTitleList;
    NSArray *breadcrumImage;
}
@property (retain, nonatomic) IBOutlet UIScrollView *pageFlipper;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControlDots;
@property (retain, nonatomic) NSMutableArray *pageList;
@property (retain, nonatomic) NSArray *pageTitleList;
@property (retain, nonatomic) NSArray *breadcrumImage;

@property (nonatomic, retain) NSMutableArray *viewControllers;



- (IBAction)changePage;

@property (retain, nonatomic) IBOutlet UIImageView *iconBarImage;
@property (retain, nonatomic) IBOutlet UIButton *downloadItunes;
@property (retain, nonatomic) IBOutlet UIButton *back;
@property (retain, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UIButton *previousButton;

- (IBAction)previousClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;
- (IBAction)exitButtonClicked:(id)sender;
- (IBAction)wishListButtonSelector:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *bredcrumMarkerIcon;
@property (retain, nonatomic) IBOutlet UIImageView *dotsBackground;
@property (retain, nonatomic) IBOutlet UIView *breadcrumBarContainer;
- (IBAction)buyButtonClicked:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *titleOfBookLabel;
@property (retain, nonatomic) IBOutlet UILabel *reviewSectionLabel;

@end
