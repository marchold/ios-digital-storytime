//
//  AppDelegate.m
//  DigitalStorytime
//
//  Created by Marc Kluver on 3/9/12.
//  Copyright (c) 2012 catglo. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "FlurryAnalytics.h"
#import "NSString+Html.h"
#import "AFJSONUtilities.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize currentReview;
@synthesize thisUserId;

- (void)dealloc
{
    [_window release];
    [_splitViewController release];
    [super dealloc];
}


-(NSData*) waitForData {
    NSData *data;
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://digital-storytime.com/WebService/getJsonReview.php?generate_user=1&key=helloWorld123"]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];      
    return data;
}

- (void)didRecieveReviews:(NSMutableArray *)listOfReviews{
    [detailViewController didRecieveReviews:listOfReviews];
}
- (void)didRecieveUpdatedReviews:(NSMutableArray *)listOfReviews{
    [detailViewController didRecieveUpdatedReviews:listOfReviews];
}
- (void)didRecieveAppendedReviews:(NSMutableArray *)listOfReviews{
    [detailViewController didRecieveAppendedReviews:listOfReviews];
    NSLog(@"Suspoius! did not expect appended reviews sent to app delegate!");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
    UINavigationController *masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];

    
    preferances = [NSUserDefaults standardUserDefaults];

    DataFetcher *dataFetcher = [DataFetcher getSingltonInstance];
    NSString *requestString =  @"http://digital-storytime.com/WebService/getJsonReview.php?searches=1&key=helloWorld123";
    NSString *cacheFileName = [dataFetcher filenameFromUrl:requestString];
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:cacheFileName];

    NSData *data;
    NSError * error = nil;
    NSDictionary *newUserData;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userId"] != 0) {
        NSString *thisUserIdString = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
        thisUserId = [thisUserIdString integerValue];
        data = [NSData dataWithContentsOfFile:filePath];
        if (data == nil){
            data = [self waitForData];
        }
        newUserData = AFJSONDecode(data, &error);
        
    } else {
        [dataFetcher sendReviewListTo:self];
        data = [self waitForData];  
        newUserData = AFJSONDecode(data, &error);
        NSLog(@"%@",newUserData);
        NSString *thisUserIdString = [newUserData objectForKey:@"id"];
        thisUserId = [thisUserIdString integerValue];
        [preferances setValue:thisUserIdString forKey:@"userId"];
        [preferances setValue:[newUserData objectForKey:@"username"] forKey:@"username"];
        [preferances setValue:[newUserData objectForKey:@"key"] forKey:@"key"];
        [data writeToFile:filePath atomically:YES];
    }    
    NSLog(@"%@",newUserData);
    NSMutableArray *sections = [newUserData objectForKey:@"sections"];
    NSMutableArray *queries = [dataFetcher parseJsonQueryResponceData:sections];
    masterViewController.queryList = queries;        
   
  
    detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
    UINavigationController *detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:detailViewController] autorelease];
    
    masterViewController.detailViewController = detailViewController;
    
    self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
    self.splitViewController.delegate = detailViewController;
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
    
    
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
    
  //  [dataFetcher checkForMessages:^(NSString *message, NSString *button1Lable, NSString *button2label, NSString *button2url){
   //     
   // }];
    
    
    [FlurryAnalytics startSession:@"BFNMZYLVTTSCEA9CC43I"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
