//
//  FavoritesPage.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/25/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "FavoritesPage.h"
#import "FavoritesCell.h"
#import "ReviewData.h"
#import "DataFetcher.h"
#import "AppDelegate.h"
#import "ReviewDetailsPages.h"


@implementation FavoritesPage
@synthesize verifiedText;
@synthesize mTableView;
@synthesize emailAddressInput;
@synthesize dataItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DataFetcher *dataFetcher = [DataFetcher getSingltonInstance];
    [dataFetcher sendMyFavesTo:self];
    mTableView.backgroundView = nil;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setEmailAddressInput:nil];
    [self setVerifiedText:nil];
    [self setMTableView:nil];
    self.dataItems = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)backButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)tellMeAboutPriceDrops:(id)sender {
}

- (IBAction)removeAllFavorites:(id)sender {
}

- (IBAction)emailMeWhenPriceDrops:(id)sender {
}

- (IBAction)recievePushNotifications:(id)sender {
}

- (void)dealloc {
    [emailAddressInput release];
    [verifiedText release];
    [mTableView release];
    self.dataItems = nil;
    [super dealloc];
}
- (IBAction)verifyEmailButtonClicked:(id)sender {
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataItems == nil)
        return  0;
    return [dataItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}



-(void) buyButtonClicked:(UIButton*)button {
    ReviewData *review = [dataItems objectAtIndex:button.tag];
    [review openReferralURL];
}

-(void) deleteFavoriteButtonClicked:(UIButton*)button {
    ReviewData *review   = [dataItems objectAtIndex:button.tag];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *requestString =  [NSString stringWithFormat:
                                @"http://digital-storytime.com/WebService/getJsonReview.php?dontwantit=%d&review=%d&key=helloWorld123",app.thisUserId,review.reviewId];    
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc]initWithRequest:request] autorelease];
    [operation  
     setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) 
     {
      
     } 
     failure:^(AFHTTPRequestOperation *operation, NSError *error) 
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to connect to server" 
                                                         message:@"There was a problem saving your request, please check your internet connection." 
                                                        delegate:nil 
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         [alert release];
     }]; 
    [operation start];

    [dataItems removeObjectAtIndex:button.tag];
    [mTableView reloadData];
}



#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FavoritesCell *cell = (FavoritesCell *)[aTableView dequeueReusableCellWithIdentifier:@"FavoritesCell"];
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FavoritesCell" owner:cell options:nil];
        cell = [nib objectAtIndex:0];
    }
    ReviewData *review   = [dataItems objectAtIndex:[indexPath row]];
    [cell.iconImage setImageWithURL:[NSURL URLWithString:review.icon]];
    cell.title.text = review.bookTitle;
    cell.description.text = review.shortQuote;
    DataFetcher *dataFetcher = [DataFetcher getSingltonInstance];
    [cell.buyButton setTitle:[dataFetcher getFormatedCurrency:review.price] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 20)];
    titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    if (review.price==0){
        titleLabel.text = @"download";
    } else {
        titleLabel.text = @"buy";
    }
    titleLabel.numberOfLines = 1;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    titleLabel.textColor = UIColorFromRGB(0xFFeffd8);
    [cell.buyButton addSubview:titleLabel]; //add label to button instead.
    
    [cell.buyButton addTarget:self 
                       action:@selector(buyButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    
    cell.buyButton.tag = indexPath.row;
    
    cell.removeButton.tag = indexPath.row;
    [cell.removeButton addTarget:self
                          action:@selector(deleteFavoriteButtonClicked:) 
                forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

}

- (void)didRecieveReviews:(NSMutableArray *)listOfReviews{
    self.dataItems = listOfReviews;
    dispatch_async(dispatch_get_main_queue(), ^{
        [mTableView reloadData];
    });    
}
- (void)didRecieveUpdatedReviews:(NSMutableArray *)listOfReviews{
    self.dataItems = listOfReviews;    
    dispatch_async(dispatch_get_main_queue(), ^{
        [mTableView reloadData];
    });

}
- (void)didRecieveAppendedReviews:(NSMutableArray *)listOfReviews{
    NSLog(@"Recieved unexpected append result in favorites page");    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReviewDetailsPages *reviewDetailsPages = [[[ReviewDetailsPages alloc] initWithNibName:@"ReviewDetailsPages" bundle:nil] autorelease];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.currentReview = [dataItems objectAtIndex:[indexPath row]];
    [self presentModalViewController:reviewDetailsPages animated:NO];
}

@end
