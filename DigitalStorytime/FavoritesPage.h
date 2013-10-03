//
//  FavoritesPage.h
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/25/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFetcher.h"

@interface FavoritesPage : UIViewController <UITableViewDelegate,ReviewListReciever,UITabBarDelegate,UITableViewDataSource>{
    IBOutlet UITextField *emailAddressInput;
    IBOutlet UILabel *verifiedText;
    IBOutlet UITableView *mTableView;    
    NSMutableArray *dataItems;
}
@property (retain, nonatomic) IBOutlet UITextField *emailAddressInput;
@property (retain, nonatomic) IBOutlet UILabel *verifiedText;
@property (retain, nonatomic) IBOutlet UITableView *mTableView;
@property (retain, nonatomic) NSMutableArray *dataItems;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)tellMeAboutPriceDrops:(id)sender;
- (IBAction)removeAllFavorites:(id)sender;
- (IBAction)emailMeWhenPriceDrops:(id)sender;
- (IBAction)recievePushNotifications:(id)sender;
- (IBAction)verifyEmailButtonClicked:(id)sender;

- (void)didRecieveReviews:(NSMutableArray *)listOfReviews;
- (void)didRecieveUpdatedReviews:(NSMutableArray *)listOfReviews;
- (void)didRecieveAppendedReviews:(NSMutableArray *)listOfReviews;

-(void) deleteFavoriteButtonClicked:(UIButton*)button;


@end
