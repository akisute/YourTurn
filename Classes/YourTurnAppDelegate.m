//
//  YourTurnAppDelegate.m
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import "YourTurnAppDelegate.h"
#import "YTMainViewController.h"
#import "YTQueue.h"


@implementation YourTurnAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [[YTQueue newInstance] load];
    
    navigationController = [[UINavigationController alloc] init];
//    YTMainViewController *mainViewController = [[[YTMainViewController alloc] initWithNibName:@"YTMainView"
//                                                                                       bundle:nil] autorelease];
    YTMainViewController *mainViewController = [[YTMainViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[navigationController pushViewController:mainViewController animated:NO];
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[YTQueue instance] save];
}

- (void)dealloc
{
	[navigationController release];
    [window release];
    [super dealloc];
}


@end
