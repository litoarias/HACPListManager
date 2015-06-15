//
//  ListViewController.m
//  PListManager
//
//  Created by Hipolito Arias on 20/5/15.
//  Copyright (c) 2015 Hipolito Arias. All rights reserved.
//

#import "ListViewController.h"
#import "HACPlistManager.h"

#import "RuntimeClass.h"

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
    
    
//    NSLog(@"%@",[RuntimeClass buildClassFromDictionary:@[@"name",@"surname",@"age"] withName:@"Person"]);
    
    id Person = [RuntimeClass buildClassFromDictionary:@[@"name",@"surname",@"age"] withName:@"Person"];
    
    NSLog(@"1. %@",Person);
    
    [Person setValue:@"Lito" forKey:@"name"];
    [Person setValue:@"Arias" forKey:@"surname"];
    [Person setValue:@"31" forKey:@"age"];
//    NSDictionary* Person1 = [RuntimeClass buildClassFromDictionary:@[@"Lito",@"Arias",@"31"] withName:@"Person"];
    
    NSLog(@"2.%@",Person);
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    data = [HACPlistManager getAllObjectsWithFileName:kFileName];
    
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
        cell.imageView.image = [HACPlistManager loadImageWithName:[user valueForKey:kNameImage]];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [HACPlistManager deleteObjectWithData:[data objectAtIndex:indexPath.row] fileName:kFileName];
        data = [HACPlistManager getAllObjectsWithFileName:kFileName];
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
    [HACPlistManager deleteAllObjectsWithFileName:kFileName];
    data = [HACPlistManager getAllObjectsWithFileName:kFileName];
    [self.tableView reloadData];
}


@end
