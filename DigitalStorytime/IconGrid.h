//
//  IconGrid.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/12/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconGrid : UIViewController{
    IBOutlet UIButton *icon1;
    IBOutlet UIButton *icon2;
    IBOutlet UIButton *icon3;
    IBOutlet UIButton *icon4;
    IBOutlet UIButton *icon5;
    IBOutlet UIWebView *webView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *facebook;
    IBOutlet UIButton *twitter;
}
@property (retain, nonatomic) IBOutlet UIButton *icon1;
@property (retain, nonatomic) IBOutlet UIButton *icon2;
@property (retain, nonatomic) IBOutlet UIButton *icon3;
@property (retain, nonatomic) IBOutlet UIButton *icon4;
@property (retain, nonatomic) IBOutlet UIButton *icon5;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIButton *facebook;
@property (retain, nonatomic) IBOutlet UIButton *twitter;


- (IBAction)ourWebSite:(id)sender;
- (IBAction)dailyDealPage:(id)sender;
- (IBAction)blog:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)booksWant:(id)sender;
- (IBAction)facebook:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)backButtonOnClick:(id)sender;

@end
