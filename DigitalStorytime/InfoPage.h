//
//  InfoPage.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/11/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"

@interface InfoPage : UIViewController <ArrayListReciever,UIWebViewDelegate>{
    NSMutableArray *webViews;
    NSMutableArray *htmlStrings;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControlDots;
    int width;
    int height;

}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControlDots;
@property (retain, nonatomic) NSMutableArray *webViews;

- (IBAction)backButton:(id)sender;
- (void)didRecieveArray:(NSMutableArray *)array;

@end
