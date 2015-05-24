//
//  ListViewController.m
//  PListManager
//
//  Created by Hipolito Arias on 20/5/15.
//  Copyright (c) 2015 Hipolito Arias. All rights reserved.
//

#import "ListViewController.h"
#import "PlistManager.h"

#define kFileName @"users.plist"

@interface ListViewController (){
    
    NSArray *searchResults;
    NSArray *data;
}


- (IBAction)deletaAll:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    data = [PlistManager getAllObjectsWithFileName:kFileName];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [data count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSDictionary * user;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        user = [searchResults objectAtIndex:indexPath.row];
    } else {
        user = [data objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [user valueForKey:@"name"];
    cell.detailTextLabel.text = [user valueForKey:@"surname"];
    
    if ([user valueForKey:kNameImage]) {
        cell.imageView.image = [PlistManager loadImageWithName:[user valueForKey:kNameImage]];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [PlistManager deleteObjectWithData:[data objectAtIndex:indexPath.row] fileName:kFileName];
        data = [PlistManager getAllObjectsWithFileName:kFileName];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [data filteredArrayUsingPredicate:resultPredicate];
}

-(void)reload{
    [self.tableView reloadData];
}

- (IBAction)deletaAll:(id)sender {
    [PlistManager deleteAllObjectsWithFileName:kFileName];
    data = [PlistManager getAllObjectsWithFileName:kFileName];
    [self.tableView reloadData];
}


@end
