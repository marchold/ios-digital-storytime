//
//  ReviewData.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/19/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import "ReviewData.h"

@implementation ReviewData 
@synthesize  bookTitle;
@synthesize reviewBody;
@synthesize price;
@synthesize icon;
@synthesize reviewId;
@synthesize itunesUrl;

@synthesize dateOfReview;
@synthesize dealPageExpireDays;
@synthesize developer;
@synthesize excludeFromDealPage;

@synthesize isInEnglish;
@synthesize isInFrench;
@synthesize isInGerman;
@synthesize isInItalian;
@synthesize isInJapanese;
@synthesize isInDutch;
@synthesize isInSpanish;
@synthesize isInKorean;
@synthesize isInChinese;

@synthesize reviewerID;
@synthesize sizeInMB;
@synthesize version;

@synthesize YouTubeLink;

@synthesize ageLowerLimit;
@synthesize ageUpperLimit;
@synthesize  agePlus;

@synthesize overallRating;
@synthesize animationRating;
@synthesize audioQualityRating;
@synthesize educationalRating;
@synthesize gamePuzzleExtraRating;
@synthesize originalityRating;
@synthesize interactivityRating;

@synthesize appReleaseDate;
@synthesize appleId;
@synthesize author;
@synthesize bedtimeRating;

@synthesize developerWebSite;
@synthesize iTunesCategory;

@synthesize historicalHighPrice;
@synthesize historicalLowPrice;

@synthesize minutesMax;
@synthesize minutesMin;
@synthesize minutesPlus;

@synthesize basedOnPrintBook;
@synthesize liteVersionAvailable;
@synthesize usesMotionSensors;
@synthesize supportsOrientationLandscape;
@synthesize supportsOrientationPortrait;
@synthesize alowsRecordOwnNarration;
@synthesize pages;

@synthesize rereadabilityRating;
@synthesize shortQuote;
@synthesize options;
@synthesize synopsis;
@synthesize coverPageImageUrl;
@synthesize ipadScreenShots;
@synthesize iphoneScreenShots;
@synthesize screenShots;

@synthesize affileateBuyUrl;

-(NSString*)reviewBodyForSummaryList{
    return [reviewBody stringByStrippingHTML];
}
 
-(void) dealloc {
    [dateOfReview release];
    [developer release];
    [bookTitle release];
    [reviewBody release];
    [icon release];
    [itunesUrl release];
    [YouTubeLink release];
    [appReleaseDate release];
    [author release];
    [developerWebSite release];
    [iTunesCategory release];
    [shortQuote release];
    [options release];
    [synopsis release];
    [coverPageImageUrl release];
    [ipadScreenShots release];
    [iphoneScreenShots release];
    [screenShots release];
    [appleId release];
    [affileateBuyUrl release];
    [super dealloc];
}
//         


-(NSString*)affileateLink {
    
    NSString *link = [NSString stringWithFormat:@"%@%@%@%@%@",
                      @"http://target.georiot.com/Proxy.ashx?grid=3494&id=yF7N2GKRgoA&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252Fus%252F",
                      @"app",
                      @"%252Fid",
                      self.appleId,
                      @"%253Fmt%253D8%2526uo%253D4%2526partnerId%253D30"];
                      
                      
      return link;
}

#pragma mark - Affileate links
- (void)openReferralURL
{
    NSURL *referralURL = [NSURL URLWithString:self.affileateLink];
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:referralURL] delegate:self startImmediately:YES];
    [con release];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[UIApplication sharedApplication] openURL:self.affileateBuyUrl];
}
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    self.affileateBuyUrl = [response URL];
    if( [affileateBuyUrl.host hasSuffix:@"itunes.apple.com"])
    {
        [connection cancel];
        [self connectionDidFinishLoading:connection];
        return nil;
    }
    else
    {
        return request;
    }
}
@end
