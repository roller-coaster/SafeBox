//
//  DemoViewController1.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "DemoViewController1.h"
#import "CustomButtonTableViewCell.h"
@interface DemoViewController1 ()<CustomButtonTableViewCellDelegate>

@end

@implementation DemoViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [CustomButtonTableViewCell identifier];
    CustomButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        cell.delegate = self;
    } 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arrray = @[@[@"1",@"2",@"3",@"3"],@[@"1",@"2",@"3",@"3",@"4",@"6"],@[@"1",@"2",@"3",@"3",@"4",@"6",@"4",@"6",@"1",@"2",@"3",@"3",@"4",@"6"]];
    [cell showCustomViewWithHeaders:@"1234" titles:arrray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrray = @[@[@"1",@"2",@"3",@"3"],@[@"1",@"2",@"3",@"3",@"4",@"6"],@[@"1",@"2",@"3",@"3",@"4",@"6",@"4",@"6",@"1",@"2",@"3",@"3",@"4",@"6"]];
    return [CustomButtonTableViewCell customCellForHeightWithHeaders:@"111" titles:arrray[indexPath.row]];
}


#pragma mark - CustomButtonTableViewCellDelegate
- (void)customButtonTableViewCellWithText:(NSString *)text{
    NSLog(@"我选择了:%@",text);
}
@end
