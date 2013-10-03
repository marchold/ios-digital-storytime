//
//  MasterViewController.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/9/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "FlurryAnalytics.h"
#import "AppDelegate.h"
#import "IconGrid.h"


//Simple class to hold list text and associated database queries
@implementation  QueryItem
@synthesize listText;
@synthesize query;
@synthesize checked;
@synthesize loading;



-(void)dealloc{
    [super dealloc];
    [listText release];
    [query release];

}

-(id) initWithText:(NSString *)_listText andQuery:(NSString *)_query{
    self = [super init];
    if (self){
        self.listText = _listText;
        self.query = _query;    }
    return self;
}

-(id) initWithText:(NSString *)_listText andQuery:(NSString*)_query selected:(BOOL)isSelected {
    self = [self initWithText:_listText andQuery:_query];
    if (self){
        self.checked=isSelected;
    }
    return self;
}

@end 


@implementation QuerySection
@synthesize heading;
@synthesize iconUrl;
@synthesize queries;

-(id) initWithTitle:(NSString *)_title andIcon:(NSString *)_iconUrl andQueries:(NSMutableArray *)_queries {
    self = [super init];
    if (self){
        self.queries = _queries;
        self.iconUrl = _iconUrl;
        self.heading = _title;
    }
    return self;
}

-(void) dealloc {
    [super dealloc];
    [heading release];
    [iconUrl release];
    [queries release];
}
@end


@implementation MasterViewController

@synthesize mTableView;
@synthesize detailViewController = _detailViewController;
@synthesize noSelection;
@synthesize queryList;

int thisUserId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"", @"");
      
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}


							
- (void)dealloc
{
    [_detailViewController release];
    [mTableView release];
    [queryList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

-(void)showInformatioIView 
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    IconGrid *iconGrid = [[[IconGrid alloc] initWithNibName:@"IconGrid" bundle:nil] autorelease];
    [app.splitViewController presentModalViewController:iconGrid animated:NO];
}

-(void)portraitLayout{
    self.navigationItem.titleView=nil;
 //   [ad removeFromSuperview];
}

-(void)landscapeLayout{
    UIImageView* img = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DS-Logo2.png"]] autorelease];
    self.navigationItem.titleView = img;
    self.navigationItem.titleView.frame = CGRectMake(self.navigationItem.titleView.frame.origin.x, self.navigationItem.titleView.frame.origin.y, 113, 35);
    UIView *frame = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 668)] autorelease];
    self.view = frame;
    [frame addSubview:mTableView];
    mTableView.frame = CGRectMake(0, 0, 320, mTableView.frame.size.height); 
 //   ad = [[UIWebView alloc] initWithFrame:CGRectMake(120, 577, 200, 125)];
 //   [frame addSubview:ad];
 //   [ad loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://digital-storytime.com/WebService/AdsForApp.php?count=1&top=1&bottom=1&lrmargin=0"]]];
    [img release];
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

- (void)didRecieveQueries:(NSMutableArray *)results {
    dispatch_async(dispatch_get_main_queue(), ^{
        queryList = results;
        QuerySection *currentSection = [queryList objectAtIndex:0];
        NSMutableArray *currentQueryList = [currentSection queries];
        lastItem = [currentQueryList objectAtIndex:0];
        lastItem.checked=YES;
        [self.tableView reloadData];
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x4f477e);
    
    UIImage *infoIcon = [UIImage imageNamed:@"info-icon.png"];
    self.navigationItem.rightBarButtonItem =   [[[UIBarButtonItem alloc] initWithImage:infoIcon
                                                                                style:UIBarButtonItemStyleBordered 
                                                                               target:self 
                                                                               action:@selector(showInformatioIView)] autorelease];     

    BOOL isPortrait = UIDeviceOrientationIsPortrait(self.interfaceOrientation);
    if (isPortrait)
    {
        [self portraitLayout];
    } else {
        [self landscapeLayout];
    }

    DataFetcher *dataFetcher = [DataFetcher getSingltonInstance];
    [dataFetcher sendQueryListTo:self];

    
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int count =  [queryList count];
    if (count < 1) count=1;
    return count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //UIImage *headerView = [UIImage imageNamed:@"topbar_purple_small.png"];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0,0,150,44)] autorelease];
    [label setBackgroundColor:UIColorFromRGB(0x473e7c)];

    if ([queryList count]==0){
        //TODO: Show a waiting thing
    } else {
        QuerySection *currentSection = [queryList objectAtIndex:section];
        label.text = currentSection.heading;
    }
    label.textColor = UIColorFromRGB(0xfeffde);
    UIFont *font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:22];
    [label setFont:font];
    label.textAlignment = UITextAlignmentCenter;
    return label;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([queryList count] < 1)
        return @"";
    QuerySection *currentSection = [queryList objectAtIndex:section];
    return [currentSection heading];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([queryList count]==0){
        return 1;
    }
    QuerySection *currentSection = [queryList objectAtIndex:section];
    NSMutableArray *currentQueryList = [currentSection queries];
    return [currentQueryList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if ([queryList count]>0){
        QuerySection *currentSection = [queryList objectAtIndex:indexPath.section];
        NSMutableArray *currentQueryList = [currentSection queries];
        QueryItem *item = [currentQueryList objectAtIndex:indexPath.row];
        cell.textLabel.text = item.listText;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
        if (item.loading){
            UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            [spinner setHidesWhenStopped:NO]; 
            
            [spinner startAnimating];
            spinner.frame = CGRectMake(0, 0, 24, 24);
            cell.accessoryView = spinner;
            [cell.imageView addSubview:spinner];
        } else {
            cell.accessoryView = nil;
            if (item.checked){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }   
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xfeffde);
    
    [cell.textLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:16]];
    
       
    return cell;
}

-(void) lookupDone {
    @synchronized ([MasterViewController class]){
        for (QuerySection *section in queryList){
            for (QueryItem *item in section.queries){
                item.loading=NO;
            }
        }
        [mTableView reloadData];
        self.detailViewController.enableFilter = YES;
    }
}


QueryItem *lastItem = nil;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @synchronized ([MasterViewController class]){
        
        if (self.detailViewController.enableFilter == NO) {
            return;
        }
        DataFetcher *dataFetcher = [DataFetcher getSingltonInstance];
        self.detailViewController.enableFilter = NO;
        [dataFetcher setDoneListener:self];
        
        [self.detailViewController showPleaseWait];
        
        QuerySection *currentSection = [queryList objectAtIndex:indexPath.section];
        NSMutableArray *currentQueryList = [currentSection queries];
        QueryItem *item = [currentQueryList objectAtIndex:indexPath.row];
        item.loading = TRUE;
        item.checked = TRUE;
        if (lastItem != nil && lastItem != item){
            lastItem.checked=NO;
        }
        [mTableView reloadData];
       
        [dataFetcher sendReviewListTo:self.detailViewController withQueryString:item.query];
        
        NSString *fluryLogMessage = [NSString stringWithFormat:@"Choose:%#",item.listText];
        [FlurryAnalytics logEvent:fluryLogMessage timed:YES];
        
        self.detailViewController.navigationItem.titleView = nil; 
        self.detailViewController.navigationItem.title = item.listText;
        
        noSelection=NO;
        lastItem = item;
        
        [self.detailViewController.searchBar setText:@""];

    }
}

@end
