//
//  YourTurnAppDelegate.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import <UIKit/UIKit.h>


@interface YourTurnAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    UINavigationController *queueTableNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *queueTableNavigationController;

@end

