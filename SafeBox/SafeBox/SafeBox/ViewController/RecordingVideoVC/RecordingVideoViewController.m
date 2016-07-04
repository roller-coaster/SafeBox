//
//  RecordingVideoViewController.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/21.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "RecordingVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface RecordingVideoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** 顶部View */
@property (nonatomic, strong) UIView *topView;

/** 动画时间 */
@property (nonatomic, assign) CGFloat animationTime;


@property (nonatomic, strong) UIView *recordingView;

@property (nonatomic, strong) UIView *bottomView;
@end

@implementation RecordingVideoViewController

#pragma mark - Public Methods
- (void)showRecordingVideoViewInController:(id)controller animated:(BOOL)animated{
    if (IOS8_OR_LATER) {
        /** 因选择UIModalPresentationCustom 不会触发 viewDidAppear 和 viewDidDisappear 等方法，需要手动执行 目的：让小视频动画暂停与继续 */
        self.modalPresentationStyle = UIModalPresentationCustom;
    } else {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    if ([controller isKindOfClass:[ZXBasicVC class]]) {
        
        [(ZXBasicVC *)controller presentVC:self animated:NO completion:nil];
    } else {
        [controller presentViewController:self animated:NO completion:nil];
    }
    _topView.alpha = 0.0f;
    if (animated) {
        [UIView animateKeyframesWithDuration:self.animationTime delay:0.1f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            _topView.alpha = 0.3f;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        _topView.alpha = 0.3f;
    }
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationTime = 0.2f;
    // Do any additional setup after loading the view.
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 4)];
    _topView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3f];
    [self.view addSubview:_topView];
    
    /** 手势 */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_topView addGestureRecognizer:tap];
    
    CGFloat height = SCREEN_HEIGHT / 6;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height)];
    _bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bottomView];
    
    _recordingView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(_bottomView.frame) - CGRectGetHeight(_topView.frame))];
    _recordingView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_recordingView];
    
    [self recoderVideoButton];
}

#pragma mark 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark 开始录制视频
- (void)recoderVideoButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 100);
    [button setTitle:@"开始录制" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.center = CGPointMake(CGRectGetWidth(_bottomView.frame) / 2, CGRectGetHeight(_bottomView.frame) / 2);
    [button addTarget:self action:@selector(recoderingAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:button];
}

- (void) recoderingAction{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];  
    //获取对摄像头的访问权限。
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {//用户尚未做出了选择这个应用程序的问候
            
        }
            break;
        case AVAuthorizationStatusRestricted:
        {//此应用程序没有被授权访问的照片数据。可能是家长控制权限
            
        }
            break;
        case AVAuthorizationStatusDenied:
        {//用户已经明确否认了这一照片数据的应用程序访问.
            
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {//用户已授权应用访问照片数据
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *pickCon = [[UIImagePickerController alloc] init];
                pickCon.delegate = self;
                pickCon.allowsEditing = YES;
                pickCon.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickCon.videoQuality = UIImagePickerControllerQualityTypeHigh;
                pickCon.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                pickCon.videoMaximumDuration = 60.0f;
                [self presentViewController:pickCon animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark 收回界面
- (void)dismiss{
    _topView.alpha = 0.0f;
    [UIView animateKeyframesWithDuration:self.animationTime delay:0.1f options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        _topView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    [self dismissVC:YES];
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
}
@end
