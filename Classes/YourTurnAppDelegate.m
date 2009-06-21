//
//  YourTurnAppDelegate.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YourTurnAppDelegate.h"
//#import "YTQueueTableViewController.h"
#import "YTMainViewController.h"
#import "YTQueue.h"


@implementation YourTurnAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [[YTQueue newInstance] load];
    
    self.navigationController = [[[UINavigationController alloc] init] autorelease];
//    YTQueueTableViewController *queueTableViewController = [[[YTQueueTableViewController alloc] initWithNibName:@"YTQueueTableView"
//                                                                                                         bundle:nil] autorelease];
    YTMainViewController *mainViewController = [[[YTMainViewController alloc] initWithNibName:@"YTMainView"
                                                                                       bundle:nil] autorelease];
	[self.navigationController pushViewController:mainViewController animated:NO];
    [window addSubview:self.navigationController.view];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[YTQueue instance] save];
}

- (void)dealloc
{
	[self.navigationController release];
    [window release];
    [super dealloc];
}


@end
