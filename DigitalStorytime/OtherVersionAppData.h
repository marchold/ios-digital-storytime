//
//  OtherVersionAppData.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/30/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OtherVersionAppData : NSObject{
    
    NSMutableArray *iphoneScreenShots;
    NSMutableArray *ipadScreenShots;
    NSString *genre;
    NSString *icon;
    NSString *format;
    int price;
    NSString *SizeInMB;
    NSString *Developer;
    NSString *developerWebSite;
    NSString *appleID;
    NSString *title;
    NSString *itunes_description;
    NSString *kindOfVersion;
}
@property int price;
@property (nonatomic,retain) NSString *SizeInMB;
@property (nonatomic,retain) NSMutableArray *iphoneScreenShots;
@property (nonatomic,retain) NSMutableArray *ipadScreenShots;
@property (nonatomic,retain) NSString *genre;
@property (nonatomic,retain) NSString *icon;
@property (nonatomic,retain) NSString *format;
@property (nonatomic,retain) NSString *Developer;
@property (nonatomic,retain) NSString *developerWebSite;
@property (nonatomic,retain) NSString *appleID;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *itunes_description;
@property (nonatomic,retain) NSString *kindOfVersion;


@end
