//
//  StarBar.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/9/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import "StarBar.h"

@implementation StarBar

- (id)initWithCoder:(NSCoder *)frame
{
    self = [super initWithCoder:frame];
    if (self) {
      
    }
    return self;
}

-(void) draw:(float)numberOfStars StarsOfSize:(int)size {
    float spacing = 1.125;
    
    //Remove any pre-existing stars in case this function is called 2 or more times
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    if (numberOfStars<0){
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, size*5, size)] autorelease];
        label.text = @"Not Applicable";
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        return;
    }
    if (numberOfStars>5){
        numberOfStars=5;
    }
    
    
    //Insert full stars 
    int i=0;
    for (i = 0; i < floor(numberOfStars); i++){
        UIImageView *thisStar = [[[UIImageView alloc] initWithImage:
                                 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star_4" ofType:@"png"]]] autorelease];
        thisStar.frame = CGRectMake((size*i)*spacing,0,size,size);
        [self addSubview:thisStar];        
    }
    
    //Insert 1/4,1/2, or 3/4 star
    float fraction = numberOfStars-((int)numberOfStars);
    NSString *partialStar;
    if (fraction > 0.70){
        partialStar = @"star_3";
        UIImageView *thisStar = [[[UIImageView alloc] initWithImage:
                                 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:partialStar ofType:@"png"]]] autorelease];  
        thisStar.frame = CGRectMake((size*i)*spacing,0,size,size);
        [self addSubview:thisStar];        
    } else 
    if (fraction > 0.45){
        partialStar = @"star_2";
        UIImageView *thisStar = [[[UIImageView alloc] initWithImage:
                                 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:partialStar ofType:@"png"]]] autorelease];  
        thisStar.frame = CGRectMake((size*i)*spacing,0,size,size);
        [self addSubview:thisStar];        
    } else 
    if (fraction > 0.20){
        partialStar = @"star_1";
        UIImageView *thisStar = [[[UIImageView alloc] initWithImage:
                                 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:partialStar ofType:@"png"]]] autorelease];  
        thisStar.frame = CGRectMake((size*i)*spacing,0,size,size);
        [self addSubview:thisStar];        
    }
    
    //Insert empty stars
    for (i=floor(numberOfStars+0.99); i < 5;i++){
        UIImageView *thisStar = [[[UIImageView alloc] initWithImage:
                                 [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star_0" ofType:@"png"]]] autorelease];       
        thisStar.frame = CGRectMake((size*i)*spacing,0,size,size);
        [self addSubview:thisStar];       
    }
    
}


@end
