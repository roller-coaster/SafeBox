//
//  CreateFileViewController.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/5/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "CreateFileViewController.h"

@interface CreateFileViewController ()

@property (weak, nonatomic) IBOutlet UIView *ContentView;

@end

@implementation CreateFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_ContentView addBorder:2 color:[UIColor blackColor] borderWidth:.5f];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
