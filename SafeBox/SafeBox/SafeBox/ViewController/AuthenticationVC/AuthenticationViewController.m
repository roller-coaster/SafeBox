//
//  AuthenticationViewController.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/30.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "MViewController.h"
#import "SaveImageToPhotos.h"

#define TEXTFIELD_HEIGHT 50

#define LABEL_TEXT @"输入密码"
#define LABEL_TEXT1 @"再次输入密码"

#define LABLE_PROMPT_TEXT0 @"请设置密码，并确认密码。"
#define LABLE_PROMPT_TEXT1 @"两次密码不一致！"
#define LABLE_PROMPT_TEXT2 @"密码错误！"

@interface AuthenticationViewController ()<UITextFieldDelegate>
/** 密码输入框 */
@property (nonatomic, strong) UITextField *pwtextField0;

/** 确认密码输入框 */
@property (nonatomic, strong) UITextField *pwtextField1;

/** 提示label */
@property (nonatomic, strong) UILabel *promptLab;

/** 确认按钮 */
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) BOOL isHave1;
@end

@implementation AuthenticationViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /** 如果归档没有存储，则显示设置密码 */
    NSString *archPatch = FILE_NAME_Archiver_PATH;
    _isHave1 = YES;
    self.title = @"设置密码";
    if ([FileUtility ergodicFolder:archPatch].count > 0) {
        self.title = @"验证密码";
        /** 验证密码 */
        _isHave1 = NO;
    }
    [self showTheValidationViewWithTextField:_isHave1];
    [self addTapGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods
#pragma mark 显示验证视图
- (void)showTheValidationViewWithTextField:(BOOL)isHave{

    UIFont *font = [UIFont systemFontOfSize:18.0f];
    CGSize size0 = [LABEL_TEXT sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGSize size1 = [LABEL_TEXT1 sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];

    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size0.width + 10, size0.height)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size1.width + 10, size1.height)];
    
    label0.font = font;
    label0.text = LABEL_TEXT;
    label0.textAlignment = NSTextAlignmentCenter;
    label1.font = font;
    label1.text = LABEL_TEXT1;
    label1.textAlignment = NSTextAlignmentCenter;

    /** 输入密码 */
    _pwtextField0 = [[UITextField alloc] initWithFrame:CGRectMake(0, CURRENT_APP_CONTENT_FRAME.origin.y + TEXTFIELD_HEIGHT, CGRectGetWidth(self.view.frame) - 40, TEXTFIELD_HEIGHT)];
    _pwtextField0.delegate = self;
    _pwtextField0.center = CGPointMake(self.view.center.x, _pwtextField0.center.y);
    _pwtextField0.secureTextEntry = YES;
    _pwtextField0.borderStyle = UITextBorderStyleRoundedRect;
    _pwtextField0.leftViewMode = UITextFieldViewModeAlways;
    /** 确认密码 */
    _pwtextField1 = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pwtextField0.frame) + 10, CGRectGetWidth(self.view.frame) - 40, TEXTFIELD_HEIGHT)];
    _pwtextField1.delegate = self;
    _pwtextField1.center = CGPointMake(self.view.center.x, _pwtextField1.center.y);
    _pwtextField1.secureTextEntry = YES;
    _pwtextField1.borderStyle = UITextBorderStyleRoundedRect;
    _pwtextField1.leftViewMode = UITextFieldViewModeAlways;

    _pwtextField0.alpha = 0.0f;
    _pwtextField1.alpha = 0.0f;
    _pwtextField0.leftView = label0;
    _pwtextField1.leftView = label1;
    [self.view addSubview:_pwtextField0];
    [self.view addSubview:_pwtextField1];

    /** 提示 */
    _promptLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pwtextField0.frame), CGRectGetMaxY(_pwtextField1.frame) + 10, CGRectGetWidth(_pwtextField0.frame), CGRectGetHeight(_pwtextField0.frame))];
    _promptLab.textColor = [UIColor redColor];
    _promptLab.text = LABLE_PROMPT_TEXT0;
    [self.view addSubview:_promptLab];
    
    /** 确认按钮 */
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(CGRectGetMinX(_pwtextField0.frame), CGRectGetMaxY(_promptLab.frame) + 20, CGRectGetWidth(_pwtextField0.frame), CGRectGetHeight(_pwtextField0.frame));
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:[UIColor greenColor]];
    [_confirmBtn addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    /** 设置圆角 */
    _confirmBtn.layer.cornerRadius = 5.0f;
    _confirmBtn.hidden = YES;
    [self.view addSubview:_confirmBtn];
    [UIView animateKeyframesWithDuration:1.0f delay:0.2f options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        _pwtextField0.alpha = 1.0f;
        _pwtextField1.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    
    if (!isHave) {/** 验证密码时，不需要在显示确认密码 */
        _pwtextField1.hidden = YES;
        [UIView animateWithDuration:2.0f animations:^{
            _promptLab.center = CGPointMake(_pwtextField0.center.x, _pwtextField0.center.y + TEXTFIELD_HEIGHT);
            _confirmBtn.frame = CGRectMake(CGRectGetMinX(_pwtextField0.frame), CGRectGetMaxY(_promptLab.frame) + 20, CGRectGetWidth(_pwtextField0.frame), CGRectGetHeight(_pwtextField0.frame));
        } completion:^(BOOL finished) {
        }];
    }

    
}

#pragma mark 添加手势
- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark 回收键盘
- (void)hiddenKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _pwtextField0) {
        if (_isHave1) {/** 设置密码 */
            [_pwtextField0 resignFirstResponder];
            [_pwtextField1 becomeFirstResponder];
        }else{/** 验证密码 */
            [_pwtextField0 resignFirstResponder];
        }
    }else if (textField == _pwtextField1){
        [_pwtextField1 resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _confirmBtn.hidden = YES;
    if (_isHave1) {
        if (textField == _pwtextField1) {
            if (_pwtextField0.text.length > 0 && _pwtextField1.text.length > 0) {
                if ([_pwtextField0.text isEqualToString:_pwtextField1.text]) {
                    [UIView animateWithDuration:1.0f animations:^{
                        _confirmBtn.hidden = NO;
                    }];
                    _promptLab.text = nil;
                    [self saveToArchiver];
                }else{
                    _promptLab.text = LABLE_PROMPT_TEXT1;
                }
            }else{
                _promptLab.text = LABLE_PROMPT_TEXT1;
            }
        }else if (textField == _pwtextField0){
            if (_pwtextField0.text.length > 0 && _pwtextField1.text.length > 0) {
                if ([_pwtextField0.text isEqualToString:_pwtextField1.text]) {
                    [UIView animateWithDuration:1.0f animations:^{
                        _confirmBtn.hidden = NO;
                    }];
                    _promptLab.text = nil;
                    [self saveToArchiver];
                }else{
                    _promptLab.text = LABLE_PROMPT_TEXT1;
                }
            }else{
                _promptLab.text = LABLE_PROMPT_TEXT1;
            }
        }
    }else{
        if (textField == _pwtextField0) {
            if (_pwtextField0.text.length > 0) {
                _confirmBtn.hidden = NO;
                if ([self validationPasswordWithPassword:_pwtextField0.text]) {
                    _promptLab.hidden = YES;
                }else{
                    _confirmBtn.enabled = NO;
                    _promptLab.text = LABLE_PROMPT_TEXT2;
                }
            }
        }
    }
}

#pragma mark 保存到归档
- (void)saveToArchiver{
    UserInfoModel *infoModel = [[UserInfoModel alloc] initWithLoginPW:_pwtextField0.text isNeedFingerprint:NO];
    [UserInfoDAO sharedInstance].infoModel = infoModel;
    [ArchiverUtils ArchiverObject:[UserInfoDAO sharedInstance].infoModel filePath:[FILE_NAME_Archiver_PATH stringByAppendingPathComponent:ArchiverName]];
}

#pragma mark 验证密码
- (BOOL)validationPasswordWithPassword:(NSString *)password{
    BOOL isYES = NO;
    id obj = [ArchiverUtils UnarchiverObjectWithFilePath:[FILE_NAME_Archiver_PATH stringByAppendingPathComponent:ArchiverName]];
    [UserInfoDAO sharedInstance].infoModel = (UserInfoModel *)obj;
    if ([password isEqualToString:[UserInfoDAO sharedInstance].infoModel.loginPW]) {
        isYES = YES;
    }
    return isYES;
}

#pragma mark 点击确认按钮
- (void)clickConfirmButton{
    if (self.dismissBlock) self.dismissBlock(_pwtextField1.hidden);
}
@end
