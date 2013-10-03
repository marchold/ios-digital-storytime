//
//  SimilarAppsTableCell.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/3/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimilarAppsTableCell : UITableViewCell {
    IBOutlet UILabel *title;
    IBOutlet UIImageView *iconImage;
    IBOutlet UILabel *subText;
    IBOutlet UIButton *priceButton;
}

@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UIImageView *iconImageBacking;
@property (retain, nonatomic) IBOutlet UILabel *subText;
@property (retain, nonatomic) IBOutlet UIButton *priceButton;

@end
