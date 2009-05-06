//
//  YourTurnAppDelegate.m
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import "YourTurnAppDelegate.h"
#import "YTQueueTableViewController.h";
#import "YTQueue.h"


@implementation YourTurnAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize queueTableNavigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [[YTQueue newInstance] load];
    
    self.tabBarController = [[[UITabBarController alloc] initWithNibName:nil bundle:nil] autorelease];
    self.queueTableNavigationController = [[[UINavigationController alloc] init] autorelease];
    
    YTQueueTableViewController *queueTableViewController = [[[YTQueueTableViewController alloc] initWithNibName:@"YTQueueTableView" bundle:nil] autorelease];
	//queueTableViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[self.queueTableNavigationController pushViewController:queueTableViewController animated:NO];
    [window addSubview:self.tabBarController.view];
    [window addSubview:self.queueTableNavigationController.view];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[YTQueue instance] save];
}

- (void)dealloc
{
	[self.queueTableNavigationController release];
    [self.tabBarController release];
    [window release];
    [super dealloc];
}


@end
