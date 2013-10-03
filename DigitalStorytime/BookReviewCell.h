//
//  BookReviewCell.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 8/14/11.
//  Copyright 2011 City Orb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarBar.h"


@interface BookReviewCell : UITableViewCell {
    IBOutlet UILabel *bookTitle;
    IBOutlet UILabel *reviewBody;

    IBOutlet UIImageView *stars;
    IBOutlet UILabel *price;

    IBOutlet StarBar *starBar;
    IBOutlet UIImageView *icon;
}
@property (retain, nonatomic) IBOutlet UILabel *bookTitle;
@property (retain, nonatomic) IBOutlet UILabel *reviewBody;

@property (retain, nonatomic) IBOutlet UIImageView *stars;
@property (retain, nonatomic) IBOutlet UILabel *price;

@property (retain, nonatomic) IBOutlet StarBar *starBar;
@property (retain, nonatomic) IBOutlet UIImageView *icon;
@end
