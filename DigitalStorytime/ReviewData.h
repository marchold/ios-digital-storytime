//
//  ReviewData.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/19/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Html.h"


@interface ReviewData : NSObject<NSURLConnectionDelegate> {   
    
    NSString *bookTitle;
    NSString *reviewBody;
    float price;
    int reviewId;
    NSString *icon;      //todo: should these be NSUrl or something?
    NSString *itunesUrl;
    
    NSString *dateOfReview;
    NSString *developer;
 
    
    BOOL isInEnglish;
    BOOL isInFrench;
    BOOL isInGerman;
    BOOL isInItalian;
    BOOL isInJapanese;
    BOOL isInDutch;
    BOOL isInSpanish;
    BOOL isInKorean;
    BOOL isInChinese;
    
    int reviewerID;
    float sizeInMB;
    float version;
    
    NSString *YouTubeLink;

    float ageLowerLimit;
    float ageUpperLimit;
    BOOL  agePlus;
    
    float overallRating;
    float animationRating;
    float audioQualityRating;
    float educationalRating;
    float gamePuzzleExtraRating;
    float originalityRating;
    float interactivityRating;
    
    NSString *appReleaseDate;
    NSString *appleId;
    NSString *author;
    float bedtimeRating;
    
    NSString *developerWebSite;
    NSString *iTunesCategory;
    
    float historicalHighPrice;
    float historicalLowPrice;
    
    int minutesMax;
    int minutesMin;
    BOOL minutesPlus;
    
    BOOL basedOnPrintBook;
    BOOL liteVersionAvailable;
    BOOL usesMotionSensors;
    BOOL supportsOrientationLandscape;
    BOOL supportsOrientationPortrait;
    BOOL alowsRecordOwnNarration;
    int pages;
    
    float rereadabilityRating;
    NSString *shortQuote;
    NSString *options;
    NSString *synopsis;
    NSString *coverPageImageUrl;
    
    NSMutableArray *ipadScreenShots;
    NSMutableArray *iphoneScreenShots;
    NSMutableArray *screenShots;
    NSURL *affileateBuyUrl;
}
@property (nonatomic,retain) NSString *dateOfReview;
@property int dealPageExpireDays;
@property (nonatomic,retain) NSString *developer;
@property BOOL excludeFromDealPage;
@property (nonatomic,retain) NSString *bookTitle;
@property (nonatomic,retain)  NSString *reviewBody;

@property float price;
@property int reviewId;
@property (nonatomic,retain) NSString *icon;
@property (nonatomic,retain) NSString *itunesUrl;

@property (nonatomic,retain) NSURL *affileateBuyUrl;

@property BOOL isInEnglish;
@property BOOL isInFrench;
@property BOOL isInGerman;
@property BOOL isInItalian;
@property BOOL isInJapanese;
@property BOOL isInDutch;
@property BOOL isInSpanish;
@property BOOL isInKorean;
@property BOOL isInChinese;

@property int reviewerID;
@property float sizeInMB;
@property float version;

@property (nonatomic,retain) NSString *YouTubeLink;

@property float ageLowerLimit;
@property float ageUpperLimit;
@property BOOL  agePlus;

@property float overallRating;
@property float animationRating;
@property float audioQualityRating;
@property float educationalRating;
@property float gamePuzzleExtraRating;
@property float originalityRating;
@property float interactivityRating;

@property (nonatomic,retain) NSString *appReleaseDate;
@property (nonatomic,retain) NSString *appleId;
@property (nonatomic,retain) NSString *author;
@property float bedtimeRating;

@property (nonatomic,retain) NSString *developerWebSite;
@property (nonatomic,retain) NSString *iTunesCategory;

@property float historicalHighPrice;
@property float historicalLowPrice;

@property int minutesMax;
@property int minutesMin;
@property BOOL minutesPlus;

@property BOOL basedOnPrintBook;
@property BOOL liteVersionAvailable;
@property BOOL usesMotionSensors;
@property BOOL supportsOrientationLandscape;
@property BOOL supportsOrientationPortrait;
@property BOOL alowsRecordOwnNarration;
@property int pages;

@property float rereadabilityRating;
@property (nonatomic,retain) NSString *shortQuote;
@property (nonatomic,retain) NSString *options;
@property (nonatomic,retain) NSString *synopsis;
@property (nonatomic,retain) NSString *coverPageImageUrl;

@property (nonatomic,retain) NSMutableArray *ipadScreenShots;
@property (nonatomic,retain) NSMutableArray *iphoneScreenShots;
@property (nonatomic,retain) NSMutableArray *screenShots;

-(NSString*)reviewBodyForSummaryList;

-(NSString*)affileateLink;
- (void)openReferralURL;

@end
