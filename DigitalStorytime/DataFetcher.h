//
//  DataFetcher.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/19/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDURLCache.h"
#import "ReviewData.h"
#import "AFNetworking.h"
#import "AFJSONUtilities.h"
#import "OtherVersionAppData.h"
 
@protocol ReviewListReciever
@required
- (void)didRecieveReviews:(NSMutableArray *)listOfReviews;
- (void)didRecieveUpdatedReviews:(NSMutableArray *)listOfReviews;
- (void)didRecieveAppendedReviews:(NSMutableArray *)listOfReviews;
@end


@protocol SimilarAppsListReciever
@required
- (void)didRecieveVersions:(NSMutableArray *)listOfVersions andSimilarByRating:(NSMutableArray *)similarRatedAps andByDeveloper:(NSMutableArray *)sameDeveloper;
@end

@protocol ArrayListReciever
@required
- (void)didRecieveArray:(NSMutableArray *)array;
@end

@protocol QueryListReciever
@required
- (void)didRecieveQueries:(NSMutableArray *)results;
@end

@protocol DoneListener
@required
- (void)lookupDone;
@end

@interface DataFetcher : NSObject {
    NSMutableDictionary *reviewFileCacheTimestamps;
    SDURLCache *urlCache;
    
    id<DoneListener> doneListener;
    NSString *lastReviewQuery;
    NSNumberFormatter *curencyFormatter;
    NSMutableDictionary *pendingQueries;
}

@property (atomic,retain) NSMutableDictionary *pendingQueries;

-(NSString *)filenameFromUrl:(NSString *)requestString;

-(id) init;
-(void)dealloc;
-(void) sendReviewListTo:(id <ReviewListReciever>)reciever;
-(void) sendReviewListTo:(id <ReviewListReciever>)reciever withQueryString:(NSString*)queryString;
-(void) sendAppendReviewListTo:(id <ReviewListReciever>)reciever skip:(int)skip;
-(void) setDoneListener:(id <DoneListener>) listener;

-(void) sendSimilarAppsListTo:(id <SimilarAppsListReciever>)reciever forReviewId:(int) reviewId;
-(void) sendInfoPageHtmlTo:(id <ArrayListReciever>)reciever;

-(void) sendMyFavesTo:(id <ReviewListReciever>)reciever;

-(void) sendQueryListTo:(id <QueryListReciever>)reciever;
-(NSMutableArray*) parseJsonQueryResponceData:(NSArray *) JSON;


+(DataFetcher*) getSingltonInstance;

-(NSString *)getFormatedCurrency:(float)value;

-(void)checkForMessages:(void (^)(NSString *message, NSString *button1Label,NSString *button1Url, NSString *button2label, NSString *button2url))messageHandler;

@end



