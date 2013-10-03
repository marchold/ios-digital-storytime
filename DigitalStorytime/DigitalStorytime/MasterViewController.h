//
//  MasterViewController.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/9/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"


@class DetailViewController;

//Structure that hold's database queries and titles for the list
@interface QueryItem : NSObject {
    BOOL checked;
    BOOL loading;
    NSString *listText;
    NSString *query;
}
-(id) initWithText:(NSString *)_listText andQuery:(NSString*)_query;
-(id) initWithText:(NSString *)_listText andQuery:(NSString*)_query selected:(BOOL)isSelected;
@property BOOL checked;
@property BOOL loading;
@property (retain,nonatomic) NSString *listText;
@property (retain,nonatomic) NSString *query;
@end;


@interface MasterViewController : UITableViewController <QueryListReciever,DoneListener> {
    NSArray *queryList;    
    IBOutlet UITableView *mTableView;
    BOOL noSelection;
    UIWebView *ad;
    QueryItem *lastItem;
}
@property (retain, nonatomic) IBOutlet UITableView *mTableView;
@property (retain, nonatomic) NSArray *queryList;   
@property BOOL noSelection;

@property (retain, nonatomic) DetailViewController *detailViewController;

- (void)didRecieveQueries:(NSMutableArray *)results;

@end




//Structure that hold's the section titles, icon's, and list of queries for that section
@interface QuerySection : NSObject {
    NSString *heading;
    NSString *iconUrl;
    NSMutableArray *queries;

}
@property (retain,nonatomic) NSString *heading;
@property (retain,nonatomic) NSString *iconUrl;
@property (retain,nonatomic) NSMutableArray *queries;

-(id) initWithTitle:(NSString *)title andIcon:(NSString *)iconUrl andQueries:(NSMutableArray *)queries;
@end;