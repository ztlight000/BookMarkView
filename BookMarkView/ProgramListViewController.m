//
//  ProgramListViewController.m
//  BookMarkView
//
//  Created by 张涛 on 2018/4/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProgramListViewController.h"

@interface ProgramListViewController ()

@end

@implementation ProgramListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return 10;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"programViewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
 
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"栏目_%ld", indexPath.row];
    
    cell.detailTextLabel.text = @"更多精彩敬请期待";
 
    return cell;
    
}


@end



