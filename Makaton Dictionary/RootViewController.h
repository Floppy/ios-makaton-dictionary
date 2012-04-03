//
//  RootViewController.h
//  Makaton Dictionary
//
//  Created by James Smith on 05/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UISearchBarDelegate> {

    int nActiveSections;
    NSMutableArray *fileList[26];
    NSMutableArray *activeSections;
    NSMutableArray *sectionTitles;
    
    NSMutableArray *searchedData;
    
    UISearchBar* searchBar;
    
}

@property(nonatomic, retain) UISearchBar* searchBar;

- (void) reload;

@end
