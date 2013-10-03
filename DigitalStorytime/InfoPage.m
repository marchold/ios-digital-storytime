//
//  InfoPage.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/11/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "InfoPage.h"
#import "DataFetcher.h"

@implementation InfoPage
@synthesize scrollView;
@synthesize pageControlDots;
@synthesize webViews;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    DataFetcher *dataFetcher = [DataFetcher getSingltonInstance];
    [dataFetcher sendInfoPageHtmlTo:self];
    width=-1;
    height=-1;
}

- (void)didRecieveArray:(NSMutableArray *)array{
    int count = [array count];
    pageControlDots.numberOfPages = count;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 6, scrollView.frame.size.height);
    self.webViews = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
    for (int i = 0; i < count; i++){
        UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)] autorelease];
        [scrollView addSubview:webView];
        NSDictionary *pageData = [array objectAtIndex:i];
        [webViews addObject:webView];
        NSString *htmlString = [pageData objectForKey:@"text"];
        [webView loadHTMLString:htmlString baseURL:nil];
        
                 
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth;
    if (width==-1) {
        pageWidth = scrollView.frame.size.width;
    } else {
        pageWidth = width;
    }
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControlDots.currentPage = page;
    [sender setContentOffset: CGPointMake(sender.contentOffset.x, 0)];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    int oldWidth=1;
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight 
        ||toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) 
    {
        width=1024;
        height=605;
        oldWidth=768;
    }
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait 
        ||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) 
    {
        width=768;
        height=863;
        oldWidth=1024;
    }
    self.view.frame = CGRectMake(0,0, width, height);
    
    int i =0;
    if (webViews!=nil)
    {
        for (UIWebView *webView in webViews){
            webView.frame = CGRectMake(width * i++,
                                                      0,
                                                      width,
                                                      height);
            [webView setUserInteractionEnabled:NO];
            [webView reloadInputViews];
        }
    }
    int page = floor((scrollView.contentOffset.x - oldWidth / 2) / oldWidth) + 1;
    NSLog(@"Page = %d",page);
    [scrollView setContentOffset:CGPointMake(page*width, scrollView.contentOffset.y)];
    scrollView.contentSize = CGSizeMake(width * 6, height);
    page = floor((scrollView.contentOffset.x - width / 2) / width) + 1;
    [scrollView setContentOffset:CGPointMake(page*width, scrollView.contentOffset.y)];
    
    [self scrollViewDidScroll:scrollView];
}






- (void)viewDidUnload
{    
    [self setScrollView:nil];
    [self setPageControlDots:nil];
    self.webViews=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [webViews release];
    [scrollView release];
    [pageControlDots release];
    [super dealloc];
}
- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
