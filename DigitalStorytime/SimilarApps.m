//
//  SimilarApps.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 2/26/12.
//  Copyright (c) 2012 City Orb. All rights reserved.
//

#import "SimilarApps.h"
#import "AppDelegate.h"
#import "DataFetcher.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Html.h"

@implementation SimilarApps
@synthesize topSixPatch;
@synthesize bottomSizPatch;
@synthesize landscapeTopSixPatch;
@synthesize landscapeBottomSixPatch;
@synthesize sameDeveloper;
@synthesize similarRatedAps;
@synthesize listOfVersions;
@synthesize sections;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void) dealloc {
    [portrait release];
    [landscape release];
    [topSixPatch release];
    [bottomSizPatch release];
    [landscapeTopSixPatch release];
    [landscapeBottomSixPatch release];
    [super dealloc];
    [listOfVersions release];
    [similarRatedAps release];
    [sections release];
    [sameDeveloper release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (void)viewDidLoad
{
    [super viewDidLoad];

    listOfVersions = nil;
    similarRatedAps = nil;
    sameDeveloper = nil;
    self.sections = [NSMutableArray array];

    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    reviewData = app.currentReview;
   
    DataFetcher *dataFetcher = [DataFetcher getSingltonInstance];
    [dataFetcher sendSimilarAppsListTo: self forReviewId:reviewData.reviewId];
    
    
}

-(void) applyTableCellImageStyles:(SimilarAppsTableCell*) view{
    view.iconImage.layer.cornerRadius = 15.0f;
    view.iconImage.layer.masksToBounds = YES;
    view.iconImage.backgroundColor = [UIColor clearColor];
    
    view.iconImageBacking.layer.masksToBounds = NO;
    view.iconImageBacking.layer.shadowOffset = CGSizeMake(0, 5);
    view.iconImageBacking.layer.shadowRadius = 2;
    view.iconImageBacking.layer.shadowOpacity = 0.5;

}

-(SimilarAppsTableCell*) generateTableCellFor:(ReviewData*) rd {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarAppsTableCell" owner:nil options:nil];
    SimilarAppsTableCell *view = [nib objectAtIndex:0];
    
    [view.iconImage setImageWithURL:[NSURL URLWithString:rd.icon]];
    
    [self applyTableCellImageStyles:view];
    
    view.title.text   = rd.bookTitle;
    if ([rd.shortQuote length] > 5){
        view.subText.text = rd.shortQuote;
    } else {
        view.subText.text = [rd.reviewBody stringByStrippingHTML];
    }

    view.priceButton.titleLabel.text = [[DataFetcher getSingltonInstance] getFormatedCurrency:rd.price];
    return  view;
}

-(SimilarAppsTableCell*) generateUnReviewedTableCellFor:(OtherVersionAppData*) app {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarAppsTableCell" owner:nil options:nil];
    SimilarAppsTableCell *view = [nib objectAtIndex:0];
    
    [view.iconImage setImageWithURL:[NSURL URLWithString:app.icon]];
    
    [self applyTableCellImageStyles:view];
    
    view.title.text   = app.title;
    view.subText.text = app.kindOfVersion;
    

    NSNumberFormatter *curencyFormatter = [[NSNumberFormatter alloc] init];
    [curencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    view.priceButton.titleLabel.text = [curencyFormatter stringFromNumber:[NSNumber numberWithFloat:app.price]];
    
    return  view;
}


typedef struct  {
    int x;
    int y;
    int width;
    int height;
} LayoutParams;

-(void) positionTableCell:(SimilarAppsTableCell*)cell withLayoutParams:(LayoutParams *)lp inView:(UIView*)container orientaionIsPortrait:(BOOL)isPortrait{
    cell.frame = CGRectMake(lp->x, lp->y, lp->width, lp->height);
    lp->x += lp->width;
    if (isPortrait)
    {
        if (lp->x > lp->width){
            lp->x = 0;
            lp->y += lp->height;
        }
    } 
    else
    {
        if (lp->x > lp->width*2){
            lp->x = 0;
            lp->y += lp->height;
        }
    }

    
    [container addSubview:cell];
}

-(void) layoutSixPac:(BOOL)isPortrait{
    int i=0;
    
    LayoutParams layoutParams;
    layoutParams.x = 0;
    layoutParams.y = 0;
    layoutParams.width  = 325;
    layoutParams.height = 85;
    
    UIView *container;
    if (isPortrait)
    {
        container = topSixPatch;
    } else {
        container = landscapeTopSixPatch;
    }
   
    
    NSMutableDictionary *alreadyDisplayedApps = [NSMutableDictionary dictionaryWithCapacity:10];
    
    for (OtherVersionAppData *app in listOfVersions){
        if ([alreadyDisplayedApps objectForKey:app.appleID] == nil){
            [alreadyDisplayedApps setObject:app forKey:app.appleID];
            SimilarAppsTableCell *view = [self generateUnReviewedTableCellFor:app];
            [self positionTableCell:view withLayoutParams:&layoutParams inView:container orientaionIsPortrait:isPortrait];
            i++;
            if (i > 5){
                if (container == topSixPatch || container==landscapeTopSixPatch){
                    i=0;
                    layoutParams.x = 0;
                    layoutParams.y = 0;
                    layoutParams.width  = 325;
                    layoutParams.height = 85;
                    if (isPortrait)
                    {
                        container = bottomSizPatch;
                    } else {
                        container = landscapeBottomSixPatch;
                    }
                } else {
                    return;
                }
            }
        }

    }
    
    for (ReviewData *rd in similarRatedAps){
        if ([alreadyDisplayedApps objectForKey:rd.appleId] == nil){
            [alreadyDisplayedApps setObject:rd forKey:rd.appleId];
            SimilarAppsTableCell *view = [self generateTableCellFor:rd];
            [self positionTableCell:view withLayoutParams:&layoutParams inView:container orientaionIsPortrait:isPortrait];
            i++;
            if (i > 5){
                if (container == topSixPatch || container==landscapeTopSixPatch){
                    if (isPortrait)
                    {
                        container = bottomSizPatch;
                    } else {
                        container = landscapeBottomSixPatch;
                    }
                    i=0;
                    layoutParams.x = 0;
                    layoutParams.y = 0;
                    layoutParams.width  = 325;
                    layoutParams.height = 85;
                } else {
                    return;
                }
            }
        }
    }
    
    for (ReviewData *rd in sameDeveloper){
        if ([alreadyDisplayedApps objectForKey:rd.appleId] == nil){
            [alreadyDisplayedApps setObject:rd forKey:rd.appleId];
            SimilarAppsTableCell *view = [self generateTableCellFor:rd];
            [self positionTableCell:view withLayoutParams:&layoutParams inView:container orientaionIsPortrait:isPortrait];
            i++;
            if (i > 5){
                if (container == topSixPatch || container==landscapeTopSixPatch){
                    if (isPortrait)
                    {
                        container = bottomSizPatch;
                    } else {
                        container = landscapeBottomSixPatch;
                    }
                    i=0;
                    layoutParams.x = 0;
                    layoutParams.y = 0;
                    layoutParams.width  = 325;
                    layoutParams.height = 85;
                } else {
                    return;
                }
            }
        }
    }
    
   
}

- (void)didRecieveVersions:(NSMutableArray *)_listOfVersions 
        andSimilarByRating:(NSMutableArray *)_similarRatedAps 
            andByDeveloper:(NSMutableArray *)_sameDeveloper 
{
    self.listOfVersions = _listOfVersions;
    self.similarRatedAps = _similarRatedAps;
    self.sameDeveloper = _sameDeveloper;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self layoutSixPac:true];
        [self layoutSixPac:false];
    });
}


- (void)viewDidUnload
{
    [self setPortrait:nil];
    [self setLandscape:nil];
    [self setTopSixPatch:nil];
    [self setBottomSizPatch:nil];
    [self setLandscapeTopSixPatch:nil];
    [self setLandscapeBottomSixPatch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    SimilarAppsTableCell *cell = (SimilarAppsTableCell *)[aTableView dequeueReusableCellWithIdentifier:@"SimilarAppsTableCell"];
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarAppsTableCell" owner:cell options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSMutableArray *curSection = [sections objectAtIndex:indexPath.section];
    ReviewData *rd = [curSection objectAtIndex:indexPath.row];
    cell.title.text = rd.bookTitle;
    [cell.icon loadHTMLString:[NSString stringWithFormat:
                               @"<img src='%@'/>",rd.icon] baseURL:nil];
    cell.description.text = [rd reviewBodyForSummaryList];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *curSection = [sections objectAtIndex:section];
    return [curSection count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int sectionCount = 0;
    [self.sections removeAllObjects];
    if (listOfVersions != nil && [listOfVersions count] > 0){
        [sections addObject:listOfVersions];
        sectionCount++;
    }
    if (similarRatedAps != nil && [similarRatedAps count] > 0){
        [sections addObject:similarRatedAps];
        sectionCount++;
    }
    if (sameDeveloper != nil && [sameDeveloper count] > 0){
        [sections addObject:sameDeveloper];
        sectionCount++;
    }
    return sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableArray *curSection = [sections objectAtIndex:section];
    if (curSection == listOfVersions){
        return @"Other Versions";
    }
    if (curSection == similarRatedAps){
        return @"Similar Rated Apps";
    }
    if (curSection == sameDeveloper){
        return @"Other apps by this developer";
    }
    return @"";
    
}*/


@end
