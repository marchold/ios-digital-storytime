//
//  sortFilter.m
//  DigitalStorytime
//
//  Created by Chea Yeam on 8/14/11.
//  Copyright 2011 City Orb. All rights reserved.
//

#import "sortFilter.h"
#import "FlurryAnalytics.h"
#import "DetailViewController.h"

@implementation sortFilter
@synthesize queryString;
@synthesize popoverController;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
        
        filterList2 = [[NSArray arrayWithObjects:
                       @"Up To 2",
                       @"3 to 5",
                       @"6 to 9",
                       @"10+",
                       nil] retain];

        filterList3 = [[NSArray arrayWithObjects:
                        @"Chinese",
                        @"Dutch",
                        @"French",
                        @"German",
                        @"Itialian",
                        @"Japnese",
                        @"Spanish",
                        nil] retain];
        queryString = @"";
    }
    return self;
}

- (void)dealloc
{
    [filterList3 release];
    [filterList3 release];

    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Fixes Overlapp of the Menu pointer dropdown
    self.contentSizeForViewInPopover = CGSizeMake(180,400);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) setFilterListener:(id <FilterListener>)listener {
    filterListener = listener;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section){
        default:
        case 0:
            switch (indexPath.row){
                case 0: [filterListener filterByLanguage:@"" andAge:1];//queryString = @"&minAge=0&maxAge=2";
                    break;
                case 1: [filterListener filterByLanguage:@"" andAge:2];//queryString = @"&minAge=3&maxAge=5";
                    break;
                case 2: [filterListener filterByLanguage:@"" andAge:3];//queryString = @"&minAge=5&maxAge=9";
                    break;
                case 3: [filterListener filterByLanguage:@"" andAge:4];//queryString = @"&minAge=10&maxAge=99";
                    break;
            }
            break;
        case 1:
            switch (indexPath.row){
                case 0: [filterListener filterByLanguage:@"c" andAge:1];
                    break;
                case 1: [filterListener filterByLanguage:@"d" andAge:1];
                    break;
                case 2: [filterListener filterByLanguage:@"f" andAge:1];
                    break;
                case 3: [filterListener filterByLanguage:@"g" andAge:1];
                    break;
                case 4: [filterListener filterByLanguage:@"i" andAge:1];
                    break;
                case 5: [filterListener filterByLanguage:@"j" andAge:1];
                    break;
                case 6: [filterListener filterByLanguage:@"s" andAge:1];
                    break;
            }
            break;
     
    }
    
    [popoverController  dismissPopoverAnimated:YES];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    NSArray *list;
    switch (indexPath.section){
        default:
        case 0:list = filterList2;
            break;
        case 1:list = filterList3;
            break;

    }

    cell.textLabel.text = [list objectAtIndex:[indexPath row]];

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section){
        default:
        case 0:return [filterList2 count];
            break;
        case 1:return [filterList3 count];
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"By Age";
        case 1:
            return @"By Langauge";
        default:
            return @"ERROR";
    }
}



@end
