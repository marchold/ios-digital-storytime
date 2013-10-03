//
//  DetailViewController.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/9/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"
#import "ReviewData.h"
#import "fullReview.h"
#import "sortFilter.h"


@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,
                                                    UITableViewDelegate, 
                                                    UITableViewDataSource,
                                                    ReviewListReciever,
                                                    UIPopoverControllerDelegate,
                                                    FilterListener,
                                                    UISearchBarDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UISearchBar *searchBar;
    
    UINib *cellLoader;
    DataFetcher *dataFetcher;
    NSMutableArray *dataItems;
    NSMutableArray *allDataItems;
    UIWebView *addSpace;
    sortFilter *sortFilterList;
    int lastInsertCount;
    NSString *searchText;
    BOOL enableFilter;
    NSString *filterLanguage;
    int filterAgeGroup;
    
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, atomic)  NSString *searchText;
@property (atomic) BOOL enableFilter;

@property (retain, nonatomic) id detailItem;

@property (atomic, retain) NSMutableArray *dataItems;
@property (atomic, retain) NSMutableArray *allDataItems;

@property int filterAgeGroup;
@property (atomic, retain) NSString *filterLanguage;
-(void) executeFilterByLanguage:(NSString*)language andAge:(int)ageGroup;


//For ReviewDataReciever
-(void)didRecieveReviews:(NSMutableArray *)reviewDataArray;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)showPleaseWait;

-(void) filterByLanguage:(NSString*)language andAge:(int)ageGroup;
@end
