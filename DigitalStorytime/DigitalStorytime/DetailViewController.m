//
//  DetailViewController.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/9/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "DetailViewController.h"
#import "BookReviewCell.h"
#import "PleaseWaitLoadingCell.h"
#import "AppDelegate.h"
#import "ReviewDetailsPages.h"
#import "UIImageView+AFNetworking.h"
#import "FlurryAnalytics.h"

@interface DetailViewController ()
@property (retain, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize tableView;
@synthesize searchBar;

@synthesize detailItem = _detailItem;

@synthesize masterPopoverController = _masterPopoverController;
@synthesize dataItems;
@synthesize allDataItems;

@synthesize searchText;
@synthesize enableFilter;

@synthesize filterAgeGroup;
@synthesize filterLanguage;

- (void)dealloc
{
    [_detailItem release];

    [_masterPopoverController release];
    [tableView release];
    [addSpace release];
    [searchBar release];
    [filterLanguage release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release]; 
        _detailItem = [newDetailItem retain]; 

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

#define UIColorFromRGB(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

-(void)portraitLayout{
    UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DS-Logo2.png"]] autorelease];
    self.navigationItem.titleView = img;
    self.navigationItem.titleView.frame = CGRectMake(320, self.navigationItem.titleView.frame.origin.y, 113, 35);
    
   // addSpace = [[UIWebView alloc] initWithFrame:CGRectMake(0, 830, 768, 137)];
   // [self.view addSubview:addSpace];
   // NSURL *ads = [NSURL URLWithString:@"http://digital-storytime.com/WebService/AdsForApp.php?count=3&top=1&bottom=1&lrmargin=10"];
   // NSURLRequest *requestAds = [NSURLRequest requestWithURL:ads];
   // [addSpace loadRequest:requestAds];
    /*searchBar.frame = CGRectMake(0, 0, 768, 44);
    tableView.frame = CGRectMake(0, 44, 768, 870);
    [self.view addSubview:searchBar];
    [tableView reloadData];*/
    
}

-(void)landscapeLayout{
    self.navigationItem.titleView=nil;
  //  [addSpace removeFromSuperview];
    /*searchBar.frame = CGRectMake(200, 0, 400, 44);
    tableView.frame = CGRectMake(0, 0, 700, 710);
    tableView.autoresizingMask = 0;
    [searchBar removeFromSuperview];
    [self.navigationController.view addSubview:searchBar];
    [tableView reloadData];*/
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft 
        || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self landscapeLayout];
    } else {
        [self portraitLayout];
    }
}

- (void)configureView
{
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x4f477e);
    
    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) filterButton {
    if (self.filterAgeGroup==0 && self.filterLanguage==nil){
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:sortFilterList];
        sortFilterList.delegate = self;
        BOOL isPortrait = UIDeviceOrientationIsPortrait(self.interfaceOrientation);
        if (isPortrait)
        {
            [pop setDelegate:self];
            [pop presentPopoverFromRect:CGRectMake(180, 60, 1080, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            [pop setPopoverContentSize:CGSizeMake(180, 400)];
        } 
        else
        {
            [pop setDelegate:self];
            [pop presentPopoverFromRect:CGRectMake(540, 60, 1080, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            [pop setPopoverContentSize:CGSizeMake(180, 400)];
        }
        sortFilterList.popoverController = pop;
        [sortFilterList setFilterListener:self];
    } else {
        self.filterAgeGroup=0;
        self.filterLanguage=nil;
        self.dataItems = self.allDataItems;
        [tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataItems=nil;
    self.allDataItems=nil;
  
    sortFilterList = [[sortFilter alloc] init];
    
    dataFetcher = [DataFetcher getSingltonInstance];
    [dataFetcher sendReviewListTo:self];
    
      
    enableFilter = YES;
    self.navigationItem.rightBarButtonItem =   [[[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                                style:UIBarButtonItemStyleBordered 
                                                                               target:self 
                                                                               action:@selector(showInformatioIView)] autorelease];     
   
    [self.navigationItem.rightBarButtonItem setAction:@selector(filterButton)]; 
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait(self.interfaceOrientation);
    if (isPortrait)
    {
        [self portraitLayout];
    } else {
        [self landscapeLayout];
    }

    self.filterAgeGroup = 0;
    self.filterLanguage = nil;
    
    [self configureView];
}

-(void)prefetchIcons {
    for (ReviewData *rd in allDataItems){
        UIImageView *dummyForCache = [[[UIImageView alloc] init] autorelease];
        [dummyForCache  setImageWithURL:[NSURL URLWithString:rd.icon]];
    }
}
-(void)didRecieveReviews:(NSMutableArray *)reviewDataArray {
    lastInsertCount=0;
    self.filterLanguage=nil;
    self.filterAgeGroup=0;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.allDataItems = reviewDataArray;
        self.dataItems = allDataItems;
        [self.tableView reloadData];
        [self performSelector:@selector(prefetchIcons) withObject:reviewDataArray afterDelay:0.1f];
    });
}

-(void)didRecieveUpdatedReviews:(NSMutableArray *)reviewDataArray {
    //self.allDataItems = reviewDataArray;
    lastInsertCount=0;
    dispatch_async(dispatch_get_main_queue(), ^{
        ReviewData *firstOldReview = [self.dataItems objectAtIndex:0];
        NSArray *oldDataItems = self.allDataItems;  //TODO: If there is a filter on re apply it after the merge
        
        NSMutableArray *indexPathToInsertAt = [NSMutableArray array];
        NSMutableArray *indexPathToDeleteFrom = [NSMutableArray array];
        NSMutableArray *indexPathToUpdate = [NSMutableArray array];

        BOOL updatingMode = NO; //vs.inserting
        
        for (int i = 0; i < [reviewDataArray count]; i++){
            ReviewData *currentReviewData = [reviewDataArray objectAtIndex:i];
            
            if (currentReviewData.reviewId != firstOldReview.reviewId && updatingMode==NO){
                [self.allDataItems insertObject:currentReviewData atIndex:i];
                [indexPathToInsertAt addObject:[NSIndexPath indexPathForRow:i inSection:0]]; 
                NSLog(@"  inserting %d review title = %@ , %d==%d",i,currentReviewData.bookTitle,firstOldReview.reviewId,currentReviewData.reviewId );
            } else {
                updatingMode = YES;
            }
            if (updatingMode){
                BOOL deleteThisOne=YES;
                BOOL refreshThisOne=NO;
                for (ReviewData *oldRd in oldDataItems){
                    if (oldRd.reviewId == currentReviewData.reviewId){
                        deleteThisOne=NO;
                        if (oldRd.price != currentReviewData.price){
                            refreshThisOne=YES;
                        }
                    }
                }
                if (deleteThisOne){
                    NSLog(@"  deleting  %d",i);
                    [indexPathToDeleteFrom addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                if (refreshThisOne){
                    NSLog(@"  updating  %d",i);
                    [indexPathToUpdate addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
            }
        }
        if (filterLanguage==nil && filterAgeGroup==0){
            self.dataItems = self.allDataItems;
            [tableView insertRowsAtIndexPaths:indexPathToInsertAt withRowAnimation:UITableViewRowAnimationTop];
            NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
            float version = [currSysVer floatValue];
            if (version >= 5){
                [tableView deleteRowsAtIndexPaths:indexPathToDeleteFrom withRowAnimation:UITableViewRowAnimationBottom];
                [tableView reloadRowsAtIndexPaths:indexPathToUpdate withRowAnimation:UITableViewRowAnimationBottom];
            } else {
                //TODO: I may nee to delay this one a bit so the animations can finish
                [tableView reloadData];
            }
        } else {
            [self executeFilterByLanguage:self.filterLanguage andAge:self.filterAgeGroup];
            [tableView reloadData];
        }
        
    });
}

- (void)didRecieveAppendedReviews:(NSMutableArray *)listOfReviews {
    int insertCount=0;
    for (ReviewData *rd in listOfReviews){
        
        BOOL insertThisOne=YES;
        for (ReviewData *old_rd in allDataItems){
            if (old_rd.reviewId == rd.reviewId){
                insertThisOne=NO;
            }
        }
        if (insertThisOne){
            insertCount++;
            [allDataItems addObject:rd];
        }
    }

    if (filterLanguage==nil && filterAgeGroup==0){
        self.dataItems = self.allDataItems;
    } else {
        [self executeFilterByLanguage:self.filterLanguage andAge:self.filterAgeGroup];
    }
    NSLog(@"Inserting %d reviews out of %d recieved",insertCount,[listOfReviews count]);
    if (insertCount>0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
        });
    }
}

-(void) executeFilterByLanguage:(NSString*)language andAge:(int)ageGroup{
    self.filterLanguage = language;
    self.filterAgeGroup = ageGroup;
    @synchronized ([DataFetcher class]){
        NSString *fluryLogMessage = [NSString stringWithFormat:@"Filter:%@-%d",language,ageGroup];
        [FlurryAnalytics logEvent:fluryLogMessage timed:YES];
        
        if ([language compare:@"c"] == NSOrderedSame){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.isInChinese){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if ([language compare:@"d"] == NSOrderedSame){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.isInDutch){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if ([language compare:@"f"] == NSOrderedSame){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.isInFrench){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if ([language compare:@"g"] == NSOrderedSame){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.isInGerman){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if ([language compare:@"i"] == NSOrderedSame){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.isInItalian){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if ([language compare:@"j"] == NSOrderedSame){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.isInJapanese){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if ([language compare:@"k"] == NSOrderedSame){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.isInKorean){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if ([language compare:@"s"] == NSOrderedSame){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.isInSpanish){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if (ageGroup == 1){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.ageLowerLimit <= 2){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if (ageGroup == 2){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.ageUpperLimit > 2 && rd.ageLowerLimit<=5){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if (ageGroup == 3){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.ageUpperLimit > 5 && rd.ageLowerLimit<=9){
                    [dataItems addObject:rd];
                }
            }
        }
        
        if (ageGroup == 4){
            self.dataItems = [NSMutableArray array];
            for (ReviewData *rd in allDataItems){
                if (rd.ageUpperLimit > 9){
                    [dataItems addObject:rd];
                }
            }
        }
    }
}

-(void) filterByLanguage:(NSString*)language andAge:(int)ageGroup {
    [self executeFilterByLanguage:language andAge:ageGroup];
    [tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = NSLocalizedString(@"Detail", @"Detail");
        
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Show", @"Show");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - TableView

-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (dataItems==nil || [dataItems count]<=indexPath.row) {
        PleaseWaitLoadingCell *cell = (PleaseWaitLoadingCell *)[aTableView dequeueReusableCellWithIdentifier:@"PleaseWaitLoadingCell"];
        if (!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PleaseWaitLoadingCell" owner:cell options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (/*dataFetcher.isPendingReviewList == NO && */indexPath.row > 0){
            if (indexPath.row >=50){
                NSString *fluryLogMessage = [NSString stringWithFormat:@"Scrolled to end of list %@ row count=%d",self.navigationItem.title,indexPath.row];
                [FlurryAnalytics logEvent:fluryLogMessage timed:YES];
            }
            //Trigger loading of more data because the user scrolled to the bottom of the list
            int count = [allDataItems count];
            if (count != lastInsertCount && (searchText==nil || [searchText length]<2)){
                //TODO: I need to put I time cap on this so the event can not fire over and over in rapid succession
                NSLog(@"Trigger lazy loading");
                [dataFetcher sendAppendReviewListTo:self skip:count];
                lastInsertCount = count;
            }
        } 
        return cell;
    } else {
        BookReviewCell *cell = (BookReviewCell *)[aTableView dequeueReusableCellWithIdentifier:@"BookReviewCell"];
        if (!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BookReviewCell" owner:cell options:nil];
            cell = [nib objectAtIndex:0];
        }
        dataFetcher = [DataFetcher getSingltonInstance];
        ReviewData *review   = [dataItems objectAtIndex:[indexPath row]];
        cell.bookTitle.text  = review.bookTitle;
        cell.reviewBody.text = [review reviewBodyForSummaryList];
        cell.price.text      = [dataFetcher getFormatedCurrency:review.price];
        [cell.icon setImageWithURL:[NSURL URLWithString:review.icon]];
        [cell.starBar draw:review.overallRating StarsOfSize:18];
    
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (dataItems==nil) {
        return 1;
    }
    return [dataItems count]+1;
}


-(void) showPleaseWait{
    dataItems=nil;
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewDetailsPages *reviewDetailsPages = [[[ReviewDetailsPages alloc] initWithNibName:@"ReviewDetailsPages" bundle:nil] autorelease];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.currentReview = [dataItems objectAtIndex:[indexPath row]];
    [app.splitViewController presentModalViewController:reviewDetailsPages animated:NO];
}

#pragma mark - search bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)_searchText{   // called when text changes (including clear)
    self.searchText = _searchText;
    if (searchText.length > 2){
        dataFetcher = [DataFetcher getSingltonInstance];
        [dataFetcher sendReviewListTo:self withQueryString:[NSString stringWithFormat:@"app_search=%@",searchText]];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{                    // called when keyboard search button pressed
    //TODO: Respond to enter/search key on keypad
}



@end
