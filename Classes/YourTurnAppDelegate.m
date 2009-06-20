//
//  YourTurnAppDelegate.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YourTurnAppDelegate.h"
#import "YTQueueTableViewController.h";
#import "YTQueue.h"


@implementation YourTurnAppDelegate

@synthesize window;
@synthesize queueTableNavigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [[YTQueue newInstance] load];
    
    self.queueTableNavigationController = [[[UINavigationController alloc] init] autorelease];
    
    YTQueueTableViewController *queueTableViewController = [[[YTQueueTableViewController alloc] initWithNibName:@"YTQueueTableView" bundle:nil] autorelease];
	//queueTableViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[self.queueTableNavigationController pushViewController:queueTableViewController animated:NO];
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
    [window release];
    [super dealloc];
}


@end
