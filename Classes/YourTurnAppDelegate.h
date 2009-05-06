//
//  YourTurnAppDelegate.h
//  YourTurn
//
//  Created by Masashi Ono on 09/05/01.
//

#import <UIKit/UIKit.h>


@interface YourTurnAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UINavigationController *queueTableNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *queueTableNavigationController;

@end

