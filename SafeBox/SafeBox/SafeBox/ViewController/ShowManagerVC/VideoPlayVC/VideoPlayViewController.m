//
//  VideoPlayViewController.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/8.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


#define BOTTOMVIEW_HEIGHT 49

@interface VideoPlayViewController ()

/** 播放器 */
@property (strong, nonatomic) AVPlayer *player;
/** 播放属性 */
@property (strong, nonatomic) AVPlayerItem *playerItem;
/** 播放view */
@property (strong, nonatomic) UIImageView *showPlayView;
/** 遮罩层 */
@property (strong, nonatomic) UIView *coverView;
/** 底部View */
@property (strong, nonatomic) UIView *bottomView;
/** 播放按钮 */
@property (strong, nonatomic) UIButton *playButton;
/** 进度条 */
@property (strong, nonatomic) UISlider *slider;
/** 计时器 */
@property (strong, nonatomic) NSTimer *timer;
/** 播放时间 */
@property (strong, nonatomic) UILabel *currentTimeLabel;
@end

@implementation VideoPlayViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    //设置控件
    [self setFrameForUI];
    //创建AVPlayer
    [self createAVPlayer];
    //添加通知
    [self addNotification];
    //添加手势
    [self createGesture];
    //创建滚动View
    [self createSlider];
    //创建播放时间
    [self createCurrentTimeLabel];
    
    [self createPlayButton];
}
- (void)dealloc{
    NSLog(@"VideoPlayViewController释放");
    [_player pause];
    //移除通知
    [self removeNotification];
}
#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods


#pragma mark - Private Methods
#pragma mark 设置控件位置大小
- (void)setFrameForUI{
    /** 视频播放展示View */
    _showPlayView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    _showPlayView.center = self.view.center;
    [self.view addSubview:_showPlayView];
    
    /** 遮罩View */
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _coverView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_coverView];
    
    /** 底部View */
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - BOTTOMVIEW_HEIGHT, SCREEN_WIDTH, BOTTOMVIEW_HEIGHT)];
    _bottomView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    [self.view addSubview:_bottomView];
    
}
#pragma mark 创建AVPlayer
- (void)createAVPlayer{
    if (![self.videoPath isKindOfClass:[NSString class]]) return;
    //创建AVPlayer
    NSURL *videoUrl = [NSURL fileURLWithPath:self.videoPath];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    _playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    //播放视频
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(_showPlayView.frame), CGRectGetHeight(_showPlayView.frame));
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.showPlayView.layer addSublayer:playerLayer];
    [_player play];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
}

#pragma mark 创建播放按钮
- (void)createPlayButton{
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(10, 5, 39, 39);
    if (_player.rate == 1.0) {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
    } else {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"video_noplay"] forState:UIControlStateNormal];
    }
    [_playButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_playButton];
    
}

#pragma mark 播放暂停按钮方法
- (void)startAction:(UIButton *)button
{
    if (button.selected) {
        [_player play];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
        
    } else {
        [_player pause];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"video_noplay"] forState:UIControlStateNormal];
        
    }
    button.selected =!button.selected;
    
}


#pragma mark 创建UISlider
- (void)createSlider
{
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(60, 10,( SCREEN_WIDTH -60)* 0.75, 15)];
    [_bottomView addSubview:_slider];
    [_slider setThumbImage:[UIImage imageNamed:@"iconfont-yuan.png"] forState:UIControlStateNormal];
    _slider.continuous = NO;
    [_slider addTarget:self action:@selector(TouchUpInside:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumTrackTintColor = [UIColor colorWithRed:30 / 255.0 green:80 / 255.0 blue:100 / 255.0 alpha:1];
    _slider.center = CGPointMake(_slider.center.x, CGRectGetHeight(_bottomView.frame) / 2);
    _slider.maximumTrackTintColor = [UIColor whiteColor];
    
}

#pragma mark slider按住事件
- (void)TouchUpInside:(UISlider *)slider{
    _timer.fireDate = [NSDate distantFuture];
}
#pragma mark slider滑动事件
- (void)progressSlider:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {
        
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        
        //    NSLog(@"%f", total);
        
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //    NSLog(@"dragedSeconds:%ld",dragedSeconds);
        
        //转换成CMTime才能给player来控制播放进度
        
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        
        WeakSelf;
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            if (!weakSelf) return ;
            [weakSelf.player play];
            weakSelf.timer.fireDate = [NSDate distantPast];
            weakSelf.playButton.selected = NO;
            [weakSelf.playButton setBackgroundImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
        }];
        
    }
}

#pragma mark 创建播放时间
- (void)createCurrentTimeLabel
{
    _currentTimeLabel = [[UILabel alloc] init];
    _currentTimeLabel.font = [UIFont systemFontOfSize:9];
    _currentTimeLabel.text = @"00:00/00:00";
    _currentTimeLabel.textColor = [UIColor whiteColor];
    CGSize size = [_currentTimeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_currentTimeLabel.font,NSFontAttributeName, nil]];
    _currentTimeLabel.frame = CGRectMake( CGRectGetWidth(_bottomView.frame) - size.width - 20, CGRectGetMidY(_slider.frame), size.width, size.height);
    _currentTimeLabel.center = CGPointMake(_currentTimeLabel.center.x + 10, CGRectGetHeight(_bottomView.frame) / 2);
    [_bottomView addSubview:_currentTimeLabel];    
}
#pragma mark 播放完成
- (void)moviePlayDidEnd:(id)sender{
    
}


#pragma mark 创建手势
- (void)createGesture
{
    UITapGestureRecognizer *backtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backtapAction:)];
    [_coverView addGestureRecognizer:backtap];
}


#pragma mark 计时器事件
- (void)Stack
{
    if (_playerItem.duration.timescale != 0) {
        
        _slider.maximumValue = 1;//音乐总共时长
        _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        
        //duration 总时长
        
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        _currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", proMin, proSec, durMin, durSec];
        CGSize size = [_currentTimeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_currentTimeLabel.font,NSFontAttributeName, nil]];
        _currentTimeLabel.frame = CGRectMake(_currentTimeLabel.frame.origin.x, _currentTimeLabel.frame.origin.y, size.width, size.height);
    }    
}


#pragma mark 返回方法
-(void)backtapAction:(UITapGestureRecognizer *)backtap
{
    [_player pause];
    _timer.fireDate = [NSDate distantFuture];
    [_timer invalidate]; 
    _timer = nil;
    if (self.removeVideoPlayerVCBlock) self.removeVideoPlayerVCBlock(self);
}

#pragma mark 添加通知
- (void)addNotification{
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];

}

#pragma mark 移除通知
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}
@end
