//
//  RootViewController.m
//  Makaton Dictionary
//
//  Created by James Smith on 05/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "SignViewController.h"

@implementation RootViewController

@synthesize searchBar;

- (id)init
{
    self = [super init];
    
    if (self != nil) {
        [ self reload ];
    }
    return self;
}

- (void) reload {
    NSDirectoryEnumerator *dirEnum;
    NSString *file;
    
    for (int i=0; i<26; i++) {
        fileList[i] = [ [ NSMutableArray alloc ] init ];
    }
        
    dirEnum = [ [ NSFileManager defaultManager ] enumeratorAtPath: [NSHomeDirectory() stringByAppendingPathComponent:@"Makaton Dictionary.app"]];
    
    while ((file = [dirEnum nextObject])) {
        if ([[file pathExtension] isEqualToString:@"png"] && [file compare:@"icon.png"] != NSOrderedSame) {
            file = [ file stringByDeletingPathExtension ];
            char index = ( [ file cStringUsingEncoding : NSASCIIStringEncoding ] )[0];
            if (index >= 'a' && index <= 'z') {
                index -= 32;
            }
            if (index >= 'A' && index <= 'Z') {
                index -= 65;
                [ fileList[(int) index] addObject: [file capitalizedString] ];
            }
        }
    }
    
    nActiveSections = 0;
    activeSections = [ [ NSMutableArray alloc ] init ];
    sectionTitles = [ [ NSMutableArray alloc ] init ];
    for (int i=0; i<26; i++) {
        if ([fileList[i]count] > 0) {
            nActiveSections++;
            [ activeSections addObject: fileList[i] ];
            [ sectionTitles addObject: [ NSString stringWithFormat: @"%c", i+65] ];
        }
    }
}

- (void)viewDidLoad
{
    self.title = @"Makaton";
    [super viewDidLoad];
    
    UISearchBar *tempSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,self.tableView.frame.size.width, 0)];
    
    self.searchBar = tempSearchBar;
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    [self.searchBar release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return nActiveSections;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [ NSMutableArray arrayWithObjects:
            @"A", @"B", @"C", @"D", @"E", @"F",
            @"G", @"H", @"I", @"J", @"K", @"L",
            @"M", @"N", @"O", @"P", @"Q", @"R",
            @"S", @"T", @"U", @"V", @"W", @"X",
            @"Y", @"Z", nil
    ];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
    return [ sectionTitles objectAtIndex: section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ [ activeSections objectAtIndex: section] count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    int i=0;
    for (NSString * sectionTitle in sectionTitles) {
        if ([sectionTitle isEqualToString:title]) {
            [ tableView scrollToRowAtIndexPath:[ NSIndexPath indexPathForRow:0 inSection: i ] atScrollPosition: UITableViewScrollPositionTop animated: YES];
            return i;
        }
        i++;
    }
    return -1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [[ activeSections objectAtIndex: [indexPath indexAtPosition: 0]] objectAtIndex:[indexPath indexAtPosition:1]];
    CellIdentifier = [ CellIdentifier stringByStandardizingPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.text = CellIdentifier;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignViewController *signViewController = [[SignViewController alloc] init];
    NSString *CellIdentifier = [[ activeSections objectAtIndex: [indexPath indexAtPosition: 0]] objectAtIndex:[indexPath indexAtPosition:1]];
    signViewController.title = CellIdentifier;
    [self.navigationController pushViewController:signViewController animated:YES];
    [[signViewController imageView] setImage: [UIImage imageNamed: [[CellIdentifier lowercaseString] stringByAppendingString:@".png" ]]];
    [signViewController release];
}

#pragma mark UISearchBarDelegate

- (void) searchBarTextDidBeginEditing: (UISearchBar*)sBar
{
    searchBar.showsCancelButton = YES;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void) searchBarTextDidEndEditing: (UISearchBar *)sBar
{
    searchBar.showsCancelButton = NO;
}

- (void) searchBarTextDidChange: (UISearchBar *)sBar textDidChange:(NSString*)searchText
{
    
}

- (void) searchBarCancelButtonClicked: (UISearchBar*)sBar
{
    [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked: (UISearchBar*)sBar
{
    [searchBar resignFirstResponder];    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

@end
