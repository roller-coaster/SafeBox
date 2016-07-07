//
//  ViewController.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "MViewController.h"
#import "KxMenu.h"
#import "TZImagePickerController.h" //!<照片选择器
#import "SettingsViewController.h" //!<设置界面
#import "LabelTableViewCell.h"
#import "CreateFileViewController.h" //!<创建文件夹界面
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "ShowPhotosViewController.h" //!<展示图片界面

#import "CustomVideoShowView.h"
#import "RecordingVideoViewController.h" //!<录制视频

#import "AuthenticationViewController.h"

#import "LockManager.h"
#define LEFT_BUTTON_TEXT @"相册"
#define BUTTON_FONT 15.0f

#define VC_TBCELL_TITLE @"title"
#define VC_TBCELL_BLOCK @"block"
#define VC_TABCELL_NUMBER @"number"

typedef void(^didSelectCellBlock)(void);
@interface MViewController ()<TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation MViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册保险箱";
    
    [self setNaviButton];
    
    [self setDataSource];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:37.0/255.0 green:130.0/255.0 blue:223.0/255.0 alpha:1.0f];

    [LockManager loadLockPasswordWithBlock:^(BOOL isFingerprint, NSString *password) {
        if (isFingerprint) {
            
        }else{
            if (password.length == 0) {
                AuthenticationViewController *AuthenticationVC = [[AuthenticationViewController alloc] init];
                AuthenticationVC.dismissBlock = ^(BOOL dismiss){
                    if (!dismiss) {
                        [self popToVCWithClassName:[MViewController class] animated:NO];
                    }  
                };
                [self pushVC:AuthenticationVC animated:NO];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
}

- (void)dealloc{
    [self removeNotificationAction];
}

- (void)bbqdew{
    NSLog(@"找渣了");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - tableView dataSource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataSourceArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [LabelTableViewCell identifier];
    LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    /** 数据源 */
    NSArray *array = self.dataSourceArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    NSString *title = dic[VC_TBCELL_TITLE];
    NSNumber *numb = dic[VC_TABCELL_NUMBER];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.numLabe.font = [UIFont systemFontOfSize:16.0f];
    cell.numLabe.text = [NSString stringWithFormat:@"%ld",numb.integerValue];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /** 数据源 */
    NSArray *array = self.dataSourceArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    didSelectCellBlock block = dic[VC_TBCELL_BLOCK];
    if (block) {
        block();
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 2) {
        return YES;
    }
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *fileName = self.dataSourceArray[indexPath.row];
        NSString *filePath = [DOCUMENT_PATH stringByAppendingPathComponent:fileName];
        if ([FileUtility fileExist:filePath]) {
            if ([FileUtility removeFile:filePath]) {
                    
                [self.dataSourceArray removeObjectAtIndex:indexPath.row];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView  endUpdates];
            }else{
                NSLog(@"删除失败");
            }
        }else{
            [self.tableView reloadData];
            NSLog(@"文件不存在");
        }
    }
}
#pragma mark - Private
#pragma mark 设置导航栏按钮
- (void)setNaviButton{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize leftBtnSize = [LEFT_BUTTON_TEXT sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:BUTTON_FONT],NSFontAttributeName, nil]];
    leftButton.frame = CGRectMake(0, 0, leftBtnSize.width, leftBtnSize.height);
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:BUTTON_FONT]];
    [leftButton setTitle:LEFT_BUTTON_TEXT forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(selectPhotosAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMoreFunctionMenu)];
    rightBarItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    
}

#pragma mark 菜单控件显示
- (void)showMoreFunctionMenu{
    if (![KxMenu isMenuOnShow]) {
        KxMenuItem *item0 = [KxMenuItem menuItem:@"添加文件夹" image:nil target:self action:@selector(addFileItem)];
        KxMenuItem *item1 = [KxMenuItem menuItem:@"设置" image:nil target:self action:@selector(settings)];
        KxMenuItem *item2 = [KxMenuItem menuItem:@"录制视频" image:nil target:self action:@selector(recordingVideo)];
        NSMutableArray *itemList = [[NSMutableArray alloc] initWithObjects:item0,item1,item2, nil];
        CGRect rect = CGRectMake(self.view.bounds.size.width-150, 10, 150, 50);
        [KxMenu setBackGroundColor:[UIColor blackColor]];
        [KxMenu showMenuInView:self.view fromRect:rect menuItems:itemList];
    }else{
        [KxMenu dismissMenu];
    }
}

#pragma mark 录制视频
- (void)recordingVideo{
    RecordingVideoViewController *recordingVC = [[RecordingVideoViewController alloc] init];
    [recordingVC showRecordingVideoViewInController:self animated:YES];
}
#pragma mark 添加文件夹
- (void)addFileItem{
//    CreateFileViewController *CFVC = [[CreateFileViewController alloc] init];
//    [self pushVC:CFVC];
    CustomVideoShowView *videoView = [[CustomVideoShowView alloc] initWithFrame:self.view.frame];
    NSArray *imgs = [FileUtility ergodicFolder:FILE_NAME_PHOTOS_PATH];
    for (NSString *path in imgs) {
        if ([path hasSuffix:@"JPG"] || [path hasSuffix:@"png"] || [path hasSuffix:@"PNG"]) {
            [videoView.dataSourceArr addObject:path];
        }
    }
    [UIView animateWithDuration:2.0 animations:^{
        
    } completion:^(BOOL finished) {
        videoView.itemSize = CGSizeMake(110, 80);
        [self.view addSubview:videoView];
    }];
}
#pragma mark 设置
- (void)settings{
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    [self pushVC:settingsVC];
}
#pragma mark 点击相册按钮事件
- (IBAction)selectPhotosAction:(id)sender {
    __weak typeof(self)weakSelf = self;
    TZImagePickerController *imaegVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imaegVC.didFinishPickingPhotosWithInfosHandle = ^(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto,NSArray<NSDictionary *> *infos){
        if (!weakSelf) return ;
        for (NSInteger i = 0; i < photos.count; i ++) {
            NSDictionary *dict = infos[i];
            NSString *name = [[dict objectForKey:@"PHImageFileURLKey"] lastPathComponent];
            NSString *imagePath = [FILE_NAME_PHOTOS_PATH stringByAppendingPathComponent:name];
            if ([FileUtility fileExist:imagePath]) return;
            [UIImageJPEGRepresentation(photos[i], .75) writeToFile:imagePath atomically:YES];
            [weakSelf setDataSource];
        }
    };
    imaegVC.didFinishPickingVideoHandle = ^(UIImage *coverImage,id asset){
        if (!weakSelf) return ;
        [weakSelf saveVideoToShaHeWithAsset:asset];
    };
//    imaegVC.allowPickingVideo = NO;
    /** 需要把相册框架从pod移到项目 */
    [self presentViewController:imaegVC animated:YES completion:nil];
}

#pragma mark 保存图片到沙盒
#pragma mark 保存视频到沙盒
- (void)saveVideoToShaHeWithAsset:(id)asset{
    if (IOS7_OR_LATER) {
        PHAsset *phAsset = (PHAsset *)asset;
        [[[TZImageManager alloc] init] getVideoOutputPathWithAsset:phAsset completion:^(NSString *outputPath) {
            NSString *fileName = [outputPath lastPathComponent];
            NSString *filePath = [FILE_NAME_VIDEO_PATH stringByAppendingPathComponent:fileName];
            if ([FileUtility fileExist:filePath]) return ;
            [FileUtility copyFileAtPath:outputPath toPath:filePath];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setDataSource];
            });
        }];
    }else{
        
    }
}

#pragma mark 添加通知
- (void)addNotificationAction{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bbqdew) name:@"abc" object:nil];
}

#pragma mark 移除通知
- (void)removeNotificationAction{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"abc" object:nil];
}
#pragma mark 设置数据源
- (void)setDataSource{
    self.dataSourceArray = [NSMutableArray array];
    
    NSArray *fileArr = [FileUtility findFile:[FileUtility documentPath]];  
    
    NSArray *allFiles = [FileUtility ergodicFolder:DOCUMENT_PATH];

    NSArray *array = [FileUtility ergodicFolder:FILE_NAME_VIDEO_PATH];
    NSArray *imgs = [FileUtility ergodicFolder:FILE_NAME_PHOTOS_PATH];

    /** section1 */
    __weak typeof(self)weakSelf = self;
    NSMutableArray *section1 = nil;
    
    /** 所有文件 */
    didSelectCellBlock allBlock = ^{
        
    };
    NSInteger all = allFiles.count;
    NSNumber *allNum = [[NSNumber alloc] initWithInteger:all];
    [CoverData coverArray:&section1 withObjectsAndKeys:FILE_NAME_ALL,VC_TBCELL_TITLE,allNum,VC_TABCELL_NUMBER,allBlock,VC_TBCELL_BLOCK, nil];
    
    /** 视频 */
    didSelectCellBlock videosBlock = ^{
        
    };
    NSInteger videos = array.count;
    NSNumber *videosNum = [[NSNumber alloc] initWithInteger:videos];
    [CoverData coverArray:&section1 withObjectsAndKeys:FILE_NAME_VIDEO,VC_TBCELL_TITLE,videosNum,VC_TABCELL_NUMBER,videosBlock,VC_TBCELL_BLOCK, nil];
    
    /** 照片 */
    didSelectCellBlock photoslock = ^{
        ShowPhotosViewController *photosVC = [[ShowPhotosViewController alloc] init];
        photosVC.title = FILE_NAME_PHOTOS;
        [weakSelf pushVC:photosVC];
    };
    NSInteger photos = imgs.count;
    NSNumber *photosNum = [[NSNumber alloc] initWithInteger:photos];
    [CoverData coverArray:&section1 withObjectsAndKeys:FILE_NAME_PHOTOS,VC_TBCELL_TITLE,photosNum,VC_TABCELL_NUMBER,photoslock,VC_TBCELL_BLOCK, nil];

    if (section1) {
        [self.dataSourceArray addObject:section1];
    }
     [self.tableView reloadData];
}

@end
