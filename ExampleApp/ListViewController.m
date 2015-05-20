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

    NSArray *data;
}


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
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        data = [PlistManager getAllObjectsWithFileName:@"data.plist"];
        [self reload];
    });
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
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [[data objectAtIndex:indexPath.row]valueForKey:@"name"];
    cell.detailTextLabel.text = [[data objectAtIndex:indexPath.row]valueForKey:@"surname"];
    
    if ([[data objectAtIndex:indexPath.row]valueForKey:kNameImage]) {
        NSLog(@"%@",[[data objectAtIndex:indexPath.row]valueForKey:kNameImage]);
        cell.imageView.image = [[PlistManager loadImageWithName:[data objectAtIndex:indexPath.row]]valueForKey:kNameImage];
    }
    
    return cell;
}

-(void)reload{
    [self.tableView reloadData];
}

@end
