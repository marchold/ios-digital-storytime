//
//  FavoritesCell.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/30/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "FavoritesCell.h"

@implementation FavoritesCell
@synthesize iconImage;
@synthesize title;
@synthesize description;
@synthesize buyButton;
@synthesize removeButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [iconImage release];
    [title release];
    [description release];
    [buyButton release];
    [removeButton release];
    [super dealloc];
}
@end
