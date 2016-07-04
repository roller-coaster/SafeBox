//
//  FingerprintLockCustomView.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/7.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "FingerprintLockCustomView.h"
#import "AppDelegate.h"

@interface FingerprintLockCustomView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *pwTextFiled;

@end
@implementation FingerprintLockCustomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCenterButton];
    }return self;
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_pwTextFiled resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@"162636"]) {
        textField.text = nil;
        [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self];
    }
}


#pragma mark - private methor
#pragma mark 设置中间按钮
- (void)setCenterButton{
    /** 指纹按钮 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 50);
    button.center = self.center;
    [button setImage:[UIImage imageNamed:@"Default_Miracle_Navigationbar_back_arrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(theViewBecomAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    /** 密码框 */
    _pwTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) - 40, 50)];
    _pwTextFiled.center = CGPointMake(self.center.x, self.center.y - 70);
    _pwTextFiled.delegate = self;
    _pwTextFiled.secureTextEntry = YES;
    _pwTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_pwTextFiled];
    
    /** shous */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singerGes)];
    [self addGestureRecognizer:tap];
    
    [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self];

    [self fingerprin];

}

#pragma mark 手势方法
- (void)singerGes{
    [self endEditing:YES];
}
#pragma mark  点击按钮方法
- (void)theViewBecomAction{
    BOOL isYES = [self fingerprin];
    
}

#pragma mark 提示错误
- (void)showErrMsg{
    
}
#pragma mark  指纹解锁
- (BOOL)fingerprin{
    
    __weak typeof(self)weakSelf = self;
    __block BOOL isYES = NO;
    [ValidationFingerprint validationTheDeviceIsSupportTheFingerprintBlock:^(BOOL isSupport, NSError *error) {
        if (!weakSelf) return ;
        isYES = isSupport;
        if (isSupport) {
            [ValidationFingerprint settingFingerprintWithPrompt:@"爆炸吧！骚年！！！" leftButtonTitle:@"输入密码" reslutBlock:^(BOOL success, NSError *error) {
                if (success) {
                    [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self];
                }
            }];
        }
    }];
    
    return isYES;
}

@end
