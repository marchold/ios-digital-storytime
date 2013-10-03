//
//  ChildPageViewControler.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/17/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildPageViewControler : UIViewController {
    UIViewController *owner;  
    IBOutlet UIView *portrait;
    IBOutlet UIView *landscape;
}
@property (retain, nonatomic) IBOutlet UIView *portrait;
@property (retain, nonatomic) IBOutlet UIView *landscape;

@property (assign, nonatomic) UIViewController *owner;


- (void)orientationChange:(UIInterfaceOrientation)toInterfaceOrientation;

@end
