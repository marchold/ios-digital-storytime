//
//  DataFetcher.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/19/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import "DataFetcher.h"
#import "time.h"
#import "MasterViewController.h"
#import "AppDelegate.h"

@implementation DataFetcher

@synthesize pendingQueries;

-(NSString *)getFormatedCurrency:(float)value{
    if (value==0){
        return @"FREE";
    } else {
        return [curencyFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
    }     
}


#pragma mark - initalization
static DataFetcher *theDataFetcherInstance=nil;
-(id) init {
    if (theDataFetcherInstance != (DataFetcher*)1){
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"-init is not a valid initializer for the class DataFetcher"
                                     userInfo:nil];
    }
    self = [super init];
    if (self) {
        reviewFileCacheTimestamps = [[NSMutableDictionary dictionaryWithCapacity:50] retain];
        
        urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                                 diskCapacity:1024*1024*100 // 100MB disk cache
                                                     diskPath:[SDURLCache defaultCachePath]];
        [NSURLCache setSharedURLCache:urlCache];
        [urlCache release];
        
        curencyFormatter = [[NSNumberFormatter alloc] init];
        [curencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

        
        lastReviewQuery = nil;
    }
    return self;    
}


+(DataFetcher*) getSingltonInstance {
    @synchronized([DataFetcher class]) {
        if (theDataFetcherInstance==nil){
            theDataFetcherInstance=(DataFetcher*)1;
            theDataFetcherInstance = [[DataFetcher alloc] init];
        }
    }
    return theDataFetcherInstance;
}

- (void)dealloc
{
    //todo: itterate through array and release the objects it contains
    [theDataFetcherInstance release];
    [reviewFileCacheTimestamps release];
    [pendingQueries release];
    [super dealloc];
    theDataFetcherInstance=nil;
    [curencyFormatter release];
}

#pragma mark - generic json handdling
-(NSString *)filenameFromUrl:(NSString *)requestString{
    return [[[[[[[requestString 
                  stringByReplacingOccurrencesOfString:@"://" withString:@"_"]
                 stringByReplacingOccurrencesOfString:@"/"   withString:@"_"]
                stringByReplacingOccurrencesOfString:@"?"   withString:@"_"]
               stringByReplacingOccurrencesOfString:@"&"   withString:@"_"]
              stringByReplacingOccurrencesOfString:@"&"   withString:@"_"]
             stringByReplacingOccurrencesOfString:@"~"   withString:@"_"]
            stringByReplacingOccurrencesOfString:@"="   withString:@"_"];
    
}

-(void) genericTwoStageJsonRetrieverFor:(NSString*)requestString
                           cacheTimeout:(int)cacheTimeOutInMinutes
                        withDataHandler:(BOOL (^)(NSData *data, BOOL isUpdate))jsonDataHandler //json handler returns false if it could not handle the data
{
    @synchronized ([DataFetcher class]){
        NSLog(@"%@",requestString);
        cacheTimeOutInMinutes = cacheTimeOutInMinutes*60000; //convert to milliseconds
        [pendingQueries setObject:requestString forKey:requestString];
        
        NSString *cacheFileName = [self filenameFromUrl:requestString];
        
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cacheFileName];
        
        BOOL didHaveCachedCopy=NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            if ([data length]>50 && jsonDataHandler(data,NO)){
                didHaveCachedCopy=YES;
            }
        }
        
        NSNumber *cacheTime = [reviewFileCacheTimestamps objectForKey:cacheFileName];
        if (cacheTime != nil){
            long fileTime = [cacheTime longValue];
            long now = CFAbsoluteTimeGetCurrent();
            if (now-cacheTimeOutInMinutes < fileTime){
                [pendingQueries removeObjectForKey:requestString];
                return;
            }
        }
        
        NSURL *url = [NSURL URLWithString:requestString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        
        [operation  
         setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) 
         {
             NSLog(@"recieved data http");
             
             NSData* data=[(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
             [data writeToFile:filePath atomically:YES];
             jsonDataHandler(data,YES);   
             [operation autorelease];
             [pendingQueries removeObjectForKey:requestString];
         } 
         failure:^(AFHTTPRequestOperation *operation, NSError *error) 
         {
             NSLog(@"failed to recieve data!");
             [operation autorelease];
             [pendingQueries removeObjectForKey:requestString];
         }];
        [operation start];
    }
}


-(void) genericOneStageJsonRetrieverFor:(NSString*)requestString
                           cacheTimeout:(int)cacheTimeOutInMinutes
                        withDataHandler:(BOOL (^)(NSData *data))jsonDataHandler //json handler returns false if it could not handle the data
{
    @synchronized ([DataFetcher class]){
        NSLog(@"%@",requestString);
        cacheTimeOutInMinutes = cacheTimeOutInMinutes*60000; //convert to milliseconds
        [pendingQueries setObject:requestString forKey:requestString];
        
        NSString *cacheFileName = [self filenameFromUrl:requestString];
        
        NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cacheFileName];
        
        BOOL didHaveCachedCopy=NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            
            
            if ([data length]>50){
                didHaveCachedCopy=YES;
            }
            NSNumber *cacheTime = [reviewFileCacheTimestamps objectForKey:cacheFileName];
            if (cacheTime != nil){
                long fileTime = [cacheTime longValue];
                long now = CFAbsoluteTimeGetCurrent();
                if (now-cacheTimeOutInMinutes < fileTime){
                    jsonDataHandler(data);
                    [pendingQueries removeObjectForKey:requestString];
                    return;
                }
            } else {
                jsonDataHandler(data);
                [pendingQueries removeObjectForKey:requestString];
                return;
            }
        }
        
        
        
        NSURL *url = [NSURL URLWithString:requestString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
        
        [operation  
         setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) 
         {
             NSLog(@"recieved data http");
             
             NSData* data=[(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
             [data writeToFile:filePath atomically:YES];
             jsonDataHandler(data);   
             [operation autorelease];
             [pendingQueries removeObjectForKey:requestString];
         } 
         failure:^(AFHTTPRequestOperation *operation, NSError *error) 
         {
             NSLog(@"failed to recieve data!");
             [operation autorelease];
             [pendingQueries removeObjectForKey:requestString];
         }];
        [operation start];
    }
}


#pragma mark - json parsing and download

-(OtherVersionAppData*) parseSimilarAppDictionary:(NSDictionary*)dataMapFromJson {
    OtherVersionAppData *app = [[[OtherVersionAppData alloc] init] autorelease];
    app.icon = [dataMapFromJson objectForKey:@"icon"];
    app.genre = [dataMapFromJson objectForKey:@"genere"];
    app.Developer = [dataMapFromJson objectForKey:@"Developer"];
    app.price =  [[dataMapFromJson objectForKey:@"price"] intValue];
    app.itunes_description =  [dataMapFromJson objectForKey:@"itunes_description"];
    app.title =  [dataMapFromJson objectForKey:@"title"];
    app.iphoneScreenShots =  [dataMapFromJson objectForKey:@"iphoneScreenShots"];
    app.ipadScreenShots =  [dataMapFromJson objectForKey:@"ipadScreenShots"];
    app.kindOfVersion =  [dataMapFromJson objectForKey:@"KindOfVersion"];
    app.developerWebSite =  [dataMapFromJson objectForKey:@"developerWebSite"];
    app.SizeInMB =  [dataMapFromJson objectForKey:@"SizeInMB"];
    app.appleID =  [dataMapFromJson objectForKey:@"appleID"];
    app.format =  [dataMapFromJson objectForKey:@"format"];
    return app;
}

-(ReviewData*) parseReviewDictionary:(NSDictionary*)reviewDataMap {
    
    ReviewData *reviewData = [[[ReviewData alloc] init] autorelease];
    reviewData.screenShots = [[NSMutableArray arrayWithCapacity:10] retain];

    reviewData.bookTitle = [reviewDataMap objectForKey:@"title"];
    reviewData.icon = [reviewDataMap objectForKey:@"iconURL"];
    reviewData.reviewBody = [reviewDataMap objectForKey:@"review"];
    reviewData.shortQuote = [reviewDataMap objectForKey:@"short_quote"];
    reviewData.synopsis   = [reviewDataMap objectForKey:@"synopsis"];
    reviewData.itunesUrl = [reviewDataMap objectForKey:@"buyNowLink"];  //todo: this needs to become a linkshare or georiot link
    reviewData.reviewId = [(NSNumber*)[reviewDataMap objectForKey:@"id"] intValue];
    
    NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    reviewData.dateOfReview = [NSDateFormatter localizedStringFromDate:[dateFormater dateFromString:[reviewDataMap objectForKey:@"DateOfReview"]]
                                                             dateStyle:NSDateFormatterMediumStyle
                                                             timeStyle:NSDateFormatterShortStyle];
    reviewData.appReleaseDate = [NSDateFormatter localizedStringFromDate:[dateFormater dateFromString:[reviewDataMap objectForKey:@"app_release_date"]]
                                                               dateStyle:NSDateFormatterMediumStyle
                                                               timeStyle:NSDateFormatterShortStyle];
    reviewData.developer = [reviewDataMap objectForKey:@"Developer"];
    reviewData.developerWebSite = [reviewDataMap objectForKey:@"developerWebSite"];
    
    //Laungage Support
    reviewData.isInEnglish =  [[reviewDataMap objectForKey:@"English"]  isEqualToString:@"1"] ? YES:NO;
    reviewData.isInFrench  =  [[reviewDataMap objectForKey:@"French"]   isEqualToString:@"1"] ? YES:NO;
    reviewData.isInGerman  =  [[reviewDataMap objectForKey:@"German"]   isEqualToString:@"1"] ? YES:NO;
    reviewData.isInItalian =  [[reviewDataMap objectForKey:@"Italian"]  isEqualToString:@"1"] ? YES:NO;
    reviewData.isInJapanese=  [[reviewDataMap objectForKey:@"Japanese"] isEqualToString:@"1"] ? YES:NO;
    reviewData.isInSpanish =  [[reviewDataMap objectForKey:@"Spanish"]  isEqualToString:@"1"] ? YES:NO;
    reviewData.isInChinese =  [[reviewDataMap objectForKey:@"chinese"]  isEqualToString:@"1"] ? YES:NO;
    reviewData.isInKorean  =  [[reviewDataMap objectForKey:@"korean"]   isEqualToString:@"1"] ? YES:NO;
    reviewData.isInDutch   =  [[reviewDataMap objectForKey:@"dutch"]    isEqualToString:@"1"] ? YES:NO;

    //Motion Sensors
    reviewData.usesMotionSensors           =  [[reviewDataMap objectForKey:@"uses_motion"]  isEqualToString:@"1"] ? YES:NO;
    reviewData.supportsOrientationPortrait =  [[reviewDataMap objectForKey:@"orientation_portrait"]  isEqualToString:@"1"] ? YES:NO;
    reviewData.supportsOrientationLandscape=  [[reviewDataMap objectForKey:@"orientation_landscape"]  isEqualToString:@"1"] ? YES:NO;
    
    //Ratings Data
    reviewData.overallRating        = [(NSNumber*)[reviewDataMap objectForKey:@"recomended"] floatValue];
    reviewData.animationRating      = [(NSNumber*)[reviewDataMap objectForKey:@"animation"] floatValue];
    reviewData.audioQualityRating   = [(NSNumber*)[reviewDataMap objectForKey:@"audio_quality"] floatValue];
    reviewData.bedtimeRating        = [(NSNumber*)[reviewDataMap objectForKey:@"bedtime"] floatValue];
    reviewData.educationalRating    = [(NSNumber*)[reviewDataMap objectForKey:@"educational"] floatValue];
    reviewData.rereadabilityRating  = [(NSNumber*)[reviewDataMap objectForKey:@"rereadability"] floatValue];
    reviewData.interactivityRating  = [(NSNumber*)[reviewDataMap objectForKey:@"interactive"] floatValue];
    reviewData.gamePuzzleExtraRating= [(NSNumber*)[reviewDataMap objectForKey:@"game_puzzle_extra"] floatValue];
    reviewData.originalityRating    = [(NSNumber*)[reviewDataMap objectForKey:@"originality"] floatValue];
    
    //Age
    reviewData.ageLowerLimit =  [(NSNumber*)[reviewDataMap objectForKey:@"age"] floatValue];
    reviewData.ageUpperLimit =  [(NSNumber*)[reviewDataMap objectForKey:@"age_hi"] floatValue];
    reviewData.agePlus       =  [[reviewDataMap objectForKey:@"age_plus"]  isEqualToString:@"1"] ? YES:NO;
    
    //Length
    reviewData.minutesMax =  [(NSNumber*)[reviewDataMap objectForKey:@"minutesMax"] intValue];
    reviewData.minutesMin =  [(NSNumber*)[reviewDataMap objectForKey:@"minutesMin"] intValue];
    reviewData.minutesPlus=  [[reviewDataMap objectForKey:@"plus_minutes"]  isEqualToString:@"1"] ? YES:NO;
    reviewData.pages      =  [(NSNumber*)[reviewDataMap objectForKey:@"pages"] intValue];
    
    reviewData.version =  [(NSNumber*)[reviewDataMap objectForKey:@"Version"] floatValue];
    reviewData.sizeInMB =  [(NSNumber*)[reviewDataMap objectForKey:@"SizeInMB"] floatValue];
    
    reviewData.alowsRecordOwnNarration=  [[reviewDataMap objectForKey:@"own_narration"]    isEqualToString:@"1"] ? YES:NO;
    reviewData.options = [reviewDataMap objectForKey:@"options"];
    
    reviewData.price = [(NSNumber*)[reviewDataMap objectForKey:@"current_price"] floatValue];
    reviewData.historicalHighPrice = [(NSNumber*)[reviewDataMap objectForKey:@"high_price"] floatValue];
    reviewData.historicalLowPrice = [(NSNumber*)[reviewDataMap objectForKey:@"low_price"] floatValue];

    reviewData.coverPageImageUrl = [reviewDataMap objectForKey:@"image_name"]; //TODO: convert to real image url's
    [reviewData.screenShots addObject:[NSString stringWithFormat:@"http://digital-storytime.com/images/%@",reviewData.coverPageImageUrl]];
    reviewData.YouTubeLink   =  [reviewDataMap objectForKey:@"YouTubeLink"];

    reviewData.ipadScreenShots = [[NSMutableArray arrayWithCapacity:5] retain];
    reviewData.iphoneScreenShots = [[NSMutableArray arrayWithCapacity:5] retain];
    
    reviewData.appleId = [reviewDataMap objectForKey:@"appleID"];
     
    for (int i = 1; i < 6; i++)
    {
        NSString *screenShotUrl;
        screenShotUrl = [reviewDataMap objectForKey:[NSString stringWithFormat:@"iPad_screenShot%d",i]];
        if (screenShotUrl.length > 5){
            [reviewData.ipadScreenShots addObject:screenShotUrl];
            [reviewData.screenShots addObject:screenShotUrl];
        }
    }
    for (int i = 1; i < 6; i++)
    {
        NSString *screenShotUrl;
        screenShotUrl = [reviewDataMap objectForKey:[NSString stringWithFormat:@"iphone_screenShot%d",i]];
        if (screenShotUrl.length > 5){
            [reviewData.iphoneScreenShots addObject:screenShotUrl];
            [reviewData.screenShots addObject:screenShotUrl];
        }
    }
    return reviewData;
}


-(NSMutableArray*)getReviewsFromJsonArray:(NSData *)data {
    NSError *error;
    NSMutableArray *resultReviewList = [[[NSMutableArray alloc] init] autorelease];
    @try {
    if (data != nil && [data length]>7){
        NSArray *JSON = AFJSONDecode(data, &error);
        for(NSDictionary* reviewDataMap in JSON) 
        {  
            ReviewData *reviewData = [self parseReviewDictionary:reviewDataMap];
            [resultReviewList addObject:reviewData];
        }
    }
    }@catch (NSException *e) {
    }
    return resultReviewList;
}




-(void) sendReviewListTo:(id <ReviewListReciever>)reciever withQueryString:(NSString*)queryString skipFirst:(int)skip {
    
    NSString *requestString =  [NSString stringWithFormat:
                                @"http://digital-storytime.com/WebService/getJsonReview.php?%@&first=%d&key=helloWorld123",queryString,skip];    
    requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
     
    NSString *cacheFileName = [self filenameFromUrl:requestString];
    
    
    NSLog(@"Looking up %@",requestString);
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cacheFileName];
    
    BOOL didHaveCachedCopy=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if ([data length] > 5){
            NSMutableArray *resultReviewList = [self getReviewsFromJsonArray:data];
            if (skip==0){
                [reciever didRecieveReviews:resultReviewList];
            } else {
                [reciever didRecieveAppendedReviews:resultReviewList];
            }
            if ([resultReviewList count] > 0){
                didHaveCachedCopy=YES;
                NSLog(@"loaded cached reviews");
            }
        }
    }
    
    NSNumber *cacheTime = [reviewFileCacheTimestamps objectForKey:cacheFileName];
    if (cacheTime != nil){
        long fileTime = [cacheTime longValue];
        long now = CFAbsoluteTimeGetCurrent();
        if (now-3600000 < fileTime){
            [doneListener lookupDone];
            return;
        }
    }
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation  setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) 
    {
        NSLog(@"recieved reviews json file ");
        NSData* data=[(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:filePath atomically:YES];
        if ([data length] > 5){
            NSMutableArray *resultReviewList = [self getReviewsFromJsonArray:data];
            if (skip==0){
                if (didHaveCachedCopy){
                    [reciever didRecieveUpdatedReviews:resultReviewList];
                } else {
                    [reciever didRecieveReviews:resultReviewList];
                }
            } else {
                [reciever didRecieveAppendedReviews:resultReviewList];
            }
            [reviewFileCacheTimestamps setObject:[NSNumber numberWithLong:CFAbsoluteTimeGetCurrent()] forKey:cacheFileName];
        }
        
        [doneListener lookupDone];
        [operation autorelease];
    } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) 
    {
        NSLog(@"Failed to recieved reviews from http ");
      
        [doneListener lookupDone];
        [operation autorelease];
    }]; 
    [operation start]; 
}

-(void) sendAppendReviewListTo:(id <ReviewListReciever>)reciever skip:(int)skip  {
    [self sendReviewListTo:reciever withQueryString:lastReviewQuery skipFirst:skip];
}

-(void) sendReviewListTo:(id <ReviewListReciever>)reciever withQueryString:(NSString*)queryString {
    lastReviewQuery=queryString;
    [self sendReviewListTo:reciever withQueryString:queryString skipFirst:0];
}

-(void) sendReviewListTo:(id <ReviewListReciever>)reciever{
    [self sendReviewListTo:reciever withQueryString:@"index=1"];
}


-(void) setDoneListener:(id <DoneListener>) listener{
    doneListener = listener;
}

NSMutableArray *otherVersions;
NSMutableArray *similarRatings;
NSMutableArray *sameDeveloper;

-(void) parseJsonSimilarAppsResponceData:(id) JSON {
    NSDictionary *versions;
    NSDictionary *similar;
    NSDictionary *developer;
    versions = [(NSDictionary*)JSON objectForKey:@"versions"];
    for (NSDictionary *version in versions){
        OtherVersionAppData *reviewData = [self parseSimilarAppDictionary:version];
        [otherVersions addObject:reviewData];
    }
    similar = [(NSDictionary*)JSON objectForKey:@"similar"];
    for (NSDictionary *similarApp in similar){
        ReviewData *reviewData = [self parseReviewDictionary:similarApp];
        [similarRatings addObject:reviewData];
    }
    developer = [(NSDictionary*)JSON objectForKey:@"developer"];
    for (NSDictionary *dev in developer){
        ReviewData *reviewData = [self parseReviewDictionary:dev];
        [sameDeveloper addObject:reviewData];
    }
}

-(void) sendSimilarAppsListTo:(id <SimilarAppsListReciever>)reciever forReviewId:(int) reviewId{

    otherVersions  = [[NSMutableArray array] retain];
    similarRatings = [[NSMutableArray array] retain];
    sameDeveloper  = [[NSMutableArray array] retain];

    
    NSString *requestString =  [NSString stringWithFormat:
                                @"http://digital-storytime.com/WebService/getJsonReview.php?%morelike=%d&key=helloWorld123",reviewId];
  
    [self genericOneStageJsonRetrieverFor:requestString
                             cacheTimeout:60
                          withDataHandler:^(NSData *data)
     {
         NSError *error;
         NSDictionary *JSON = AFJSONDecode(data, &error);
         [self parseJsonSimilarAppsResponceData:JSON];
         
         [reciever didRecieveVersions:otherVersions andSimilarByRating:similarRatings andByDeveloper:sameDeveloper];
         
         if ([otherVersions count] + [similarRatings count] + [sameDeveloper count] > 0){
             return YES;
         }
         return NO;
     }]; 

    
    /*
    
    NSString *cacheFileName = [self filenameFromUrl:requestString];
    
    otherVersions  = [[NSMutableArray array] retain];
    similarRatings = [[NSMutableArray array] retain];
    sameDeveloper  = [[NSMutableArray array] retain];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cacheFileName];
    
    BOOL didHaveCachedCopy=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSError *error;
        NSDictionary *JSON = AFJSONDecode(data, &error);
        [self parseJsonSimilarAppsResponceData:JSON];
        
        [reciever didRecieveVersions:otherVersions andSimilarByRating:similarRatings andByDeveloper:sameDeveloper];

        if ([otherVersions count] + [similarRatings count] + [sameDeveloper count] > 0){
          //  didHaveCachedCopy=YES;
            NSLog(@"loaded similar apps from cache");
        }
    }
    
    NSNumber *cacheTime = [reviewFileCacheTimestamps objectForKey:cacheFileName];
    if (cacheTime != nil){
        long fileTime = [cacheTime longValue];
        long now = CFAbsoluteTimeGetCurrent();
        if (now-3600000 < fileTime){
            NSLog(@"Similar no need for lookup");
      
            return;
        }
    }
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
     
    [operation  setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) 
     {
         NSLog(@"recieved similar apps over http");
         
         NSData* data=[(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
         [data writeToFile:filePath atomically:YES];
         NSError *error;
         NSDictionary *JSON = AFJSONDecode(data, &error);
         
         [self parseJsonSimilarAppsResponceData:JSON];
         [reciever didRecieveVersions:otherVersions andSimilarByRating:similarRatings andByDeveloper:sameDeveloper];
         [operation autorelease];
     } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) 
     {
         NSLog(@"failed to recieve similar apps");
         [operation autorelease];
     }];
    [operation start];*/
}

-(NSMutableArray*) parseJsonQueryResponceData:(NSArray *) JSON 
{
    NSMutableArray *results = [[NSMutableArray array] retain];
    for (NSDictionary *section in (NSArray*)JSON ){
        
        NSMutableArray *queries = [NSMutableArray array];
        
        NSMutableArray *titlesTemp = [section objectForKey:@"text"];
        NSMutableArray *queriesTemp = [section objectForKey:@"query"];
        
        for (int i = 0; i < [titlesTemp count]; i ++){
            QueryItem *item = [[QueryItem alloc] initWithText:[titlesTemp objectAtIndex:i] andQuery:[queriesTemp objectAtIndex:i]];
            [queries addObject:item];
        }
        NSString *sectionTitle = [section objectForKey:@"heading"];
        
        QuerySection *querySection = [[QuerySection alloc] initWithTitle:sectionTitle andIcon:@"" andQueries:queries];
        [results addObject:querySection];
    }
    return results;
}


-(void) sendQueryListTo:(id <QueryListReciever>)reciever {
    
    NSString *requestString =  @"http://digital-storytime.com/WebService/getJsonReview.php?searches=1&key=helloWorld123";
    [self genericOneStageJsonRetrieverFor:requestString
                             cacheTimeout:60*12
                          withDataHandler:^(NSData *data)
     {
         NSError *error;
         NSDictionary *JSON = AFJSONDecode(data, &error);
         NSArray *sections = [JSON objectForKey:@"sections"];
         NSMutableArray *queries = [self parseJsonQueryResponceData:sections];
         [reciever didRecieveQueries:queries];
         return YES;
     }]; 
    
    /*
    
    NSString *cacheFileName = [self filenameFromUrl:requestString];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cacheFileName];
    
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation  setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) 
     {
         NSLog(@"recieved query list");
         NSError *error;
         NSData* data=[(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
         [data writeToFile:filePath atomically:YES];
          
         [operation autorelease];
     } 
    failure:^(AFHTTPRequestOperation *operation, NSError *error) 
     {
         NSLog(@"failed to download query list");
     
         [operation autorelease];
     }];
    [operation start];*/
}





-(void) sendInfoPageHtmlTo:(id <ArrayListReciever>)reciever {
    
    NSString *requestString =  @"http://digital-storytime.com/WebService/getJsonReview.php?info_page=1&key=helloWorld123";
    [self genericOneStageJsonRetrieverFor:requestString
                             cacheTimeout:60*12
                          withDataHandler:^(NSData *data)
                          {
                              NSError *error;
                              NSMutableArray *JSON = AFJSONDecode(data, &error);
                              [reciever didRecieveArray:JSON];
                              if ([data length] > 5){
                                  return YES;
                              }
                              return NO;
                          }]; 
    /*
    isPedingInfoList=YES;
    NSString *cacheFileName = [self filenameFromUrl:requestString];
     
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cacheFileName];
    
    BOOL didHaveCachedCopy=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSError *error;
        NSMutableArray *JSON = AFJSONDecode(data, &error);
        [reciever didRecieveArray:JSON];
        
        if ([otherVersions count] + [similarRatings count] + [sameDeveloper count] > 0){
            didHaveCachedCopy=YES;
            NSLog(@"loaded similar apps from cache");
        }
    }
    
    NSNumber *cacheTime = [reviewFileCacheTimestamps objectForKey:cacheFileName];
    if (cacheTime != nil){
        long fileTime = [cacheTime longValue];
        long now = CFAbsoluteTimeGetCurrent();
        if (now-3600000 < fileTime){
            NSLog(@"Similar no need for lookup");
            return;
        }
    }
    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation  setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject) 
     {
         NSLog(@"recieved similar apps over http");
         
         NSData* data=[(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
         [data writeToFile:filePath atomically:YES];
         NSError *error;
         NSMutableArray *JSON = AFJSONDecode(data, &error);
         [reciever didRecieveArray:JSON];
         isPedingInfoList=NO;
         [operation autorelease];
     } 
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) 
     {
         NSLog(@"failed to recieve similar apps");
         isPedingInfoList=NO;
         [operation autorelease];
     }];
    [operation start];*/
}


-(void) sendMyFavesTo:(id <ReviewListReciever>)reciever {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *requestString = [NSString stringWithFormat:@"http://digital-storytime.com/WebService/getJsonReview.php?myfaves=%d&key=helloWorld123",app.thisUserId];
    [self genericTwoStageJsonRetrieverFor:requestString
                             cacheTimeout:0
                          withDataHandler:^(NSData *data, BOOL isUpdate)
     {
         
         NSMutableArray *resultReviewList = [self getReviewsFromJsonArray:data];
         [reciever didRecieveReviews:resultReviewList];
         if ([resultReviewList count] > 0){
             return YES;
         }
         return NO;
     }];     
}

-(void)checkForMessages:(void (^)(NSString *message, NSString *button1Label,NSString *button1Url, NSString *button2label, NSString *button2url))messageHandler{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *requestString =  [NSString stringWithFormat:@"http://digital-storytime.com/WebService/getJsonReview.php?myMessages=%d&key=helloWorld123",app.thisUserId];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation  
     setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) 
     {
         NSData* data=[(NSString*)responseObject dataUsingEncoding:NSUTF8StringEncoding];
         
         if ([data length] > 5){
             NSError *error;
             NSDictionary *JSON = AFJSONDecode(data, &error);
             NSString *message = [JSON objectForKey:@"message"];
            //TBD
         }
         [operation autorelease];
     } 
     failure:^(AFHTTPRequestOperation *operation, NSError *error) 
     {
         [operation autorelease];
     }]; 
    [operation start]; 

}

@end
