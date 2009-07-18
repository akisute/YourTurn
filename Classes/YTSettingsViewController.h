//
//  YTSettingsViewController.h
//  YourTurn
//
//  Created by Masashi Ono on 09/06/26.
//  Copyright (c) 2009, Masashi Ono
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTSwitchCell;
@class YTSelectionCell;


@interface YTSettingsViewController : UITableViewController {
    // Session section cells
    YTSwitchCell *enableLandscapeModeCell;
    YTSelectionCell *soundTurnEndSettingsCell;
    
    // Intermission section cells
    YTSelectionCell *intermissionSettingsCell;
    
    // First bell section cells
    YTSelectionCell *firstBellSettingsCell;
    YTSelectionCell *soundFirstBellSettingsCell;
}

@end
