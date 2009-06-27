//
//  YTMainViewController.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/20.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YTMainViewController : UITableViewController {
    UITableViewCell *manageAttendeesCell;
    UITableViewCell *settingsCell;
    UITableViewCell *startCell;
}

-(IBAction)openAboutView;

@end
