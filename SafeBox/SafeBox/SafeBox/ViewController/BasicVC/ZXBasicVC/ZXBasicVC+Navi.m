//
//  ZXBasicVC+Navi.m
//  MEMobile
//
//  Created by LamTsanFeng on 16/2/22.
//  Copyright © 2016年 GZMiracle. All rights reserved.
//

#import "ZXBasicVC+Navi.h"

#define kStackMsg NSLog(@"当前堆栈情况:%@",[GlobalConstants sharedGlobalConstants].arrayVCs)

#define kPresentMark @"------------PresentVC MARK------------"

@implementation ZXBasicVC (Navi)

- (void)viewDidLoadNavi
{
    if ([GlobalConstants sharedGlobalConstants].arrayVCs.count == 0) {
        
//        UIStoryboard *stor = [UIStoryboard storyboardWithName:MAINSTORYBOARD_IPHONE bundle:[NSBundle mainBundle]];
//        ZXNavController *zxNavVC = (ZXNavController *)[stor instantiateInitialViewController];
        
        [[GlobalConstants sharedGlobalConstants].arrayVCs addObject:self.navigationController.viewControllers.firstObject];
    }
}

- (void)viewWillAppearNavi:(BOOL)animated
{
    
}
- (void)viewDidAppearNavi:(BOOL)animated
{

}
- (void)viewWillDisappearNavi:(BOOL)animated
{

}
- (void)viewDidDisappearNavi:(BOOL)animated
{
    /** navi堆栈已经存在该vc */
    if (![self.navigationController.viewControllers containsObject:self]) {
        /** 有返回操作 并且 当前记录堆栈存在该vc */
        if (self.isSetNavBackBar && [[GlobalConstants sharedGlobalConstants].arrayVCs containsObject:self]) {
            /** 移除vc */
            [[GlobalConstants sharedGlobalConstants].arrayVCs removeLastObject];
            kStackMsg;
        }
    }
}

#pragma mark ----------------- present页面推送 --------------
- (void)presentVC:(UIViewController *)viewController animated:(BOOL)animated
{
    [self presentVC:viewController animated:animated completion:nil];
}

- (void)presentVC:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{
    /** 创建present标记 */
    [[GlobalConstants sharedGlobalConstants].arrayVCs addObject:kPresentMark];
    
    [super presentViewController:viewController animated:animated completion:^{
        /** 判断present是否存在导航栏 */
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)viewController;
            for (UIViewController *vc in nav.viewControllers) {
                [self addObjectWithVC:vc];
            }
        } else {
            [self addObjectWithVC:viewController];
        }
        
        if (completion) completion();
    }];
    [self performSelectorOnMainThread:@selector(donotSleep) withObject:nil waitUntilDone:NO];
}

- (void)dismissVC:(BOOL)flag
{
    [self dismissVC:flag completion:nil];
}

- (void)dismissVC:(BOOL)flag completion:(void (^)(void))completion
{
    /** 根据present标记移除vc */
    __block NSInteger markIndex = NSNotFound;
    [[GlobalConstants sharedGlobalConstants].arrayVCs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:kPresentMark]) {
            markIndex = idx;
            *stop = YES;
        }
    }];
    if (markIndex == NSNotFound) {
        /** 不存在标记，不允许dismiss */
        if (completion) completion();
        return;
    }
    NSInteger vcCount = [GlobalConstants sharedGlobalConstants].arrayVCs.count;
    [[GlobalConstants sharedGlobalConstants].arrayVCs removeObjectsInRange:NSMakeRange(markIndex, vcCount-markIndex)];
    
    [super dismissViewControllerAnimated:flag completion:completion];
    kStackMsg;
}

- (void)donotSleep
{
    /**
     * 为了唤醒主线程立即执行presentVC: animated: completion:
     * 什么都不需要做，只是为了唤醒主线程
     */
}

#pragma mark ----------------- push页面推送 --------------
- (void)pushViewController:(ZXBasicVC *)viewController animated:(BOOL)animated
{
    
    if ([[GlobalConstants sharedGlobalConstants].arrayVCs containsObject:viewController]) {
        NSLog(@"😱😱😱该VC已存在堆栈，不能重复推出(push)。");
        return;
    }
    /** 确保动画是可显示的状态 */
    if ([UIView areAnimationsEnabled] == NO) {
        [UIView setAnimationsEnabled:YES];
    }
    
    [self.navigationController pushViewController:viewController animated:animated];
    
    [self addObjectWithVC:viewController];
}

- (ZXBasicVC *)popViewControllerAnimated:(BOOL)animated
{
    /** 返回上一个界面 强制触发滑动返回标记，目的：返回过程中让键盘不消失 */
    if ([self.navigationController isKindOfClass:[ZXNavController class]]) {
        ZXNavController *navi = (ZXNavController *)self.navigationController;
        navi.isInteractived = YES;
    }
    ZXBasicVC *VC = (ZXBasicVC *)[self removeLastObjectWithVC];
    if (VC) {
        [self.navigationController popViewControllerAnimated:animated];
    }
    
    return VC;
}

- (ZXBasicVC *)popToViewController:(Class)className animated:(BOOL)animated
{
    ZXBasicVC *VC = (ZXBasicVC *)[self getObjectWithArrayVCs:className];
    
    if (VC) {
        [VC.navigationController popToViewController:VC animated:animated];
    }
    return VC;
}

- (void)popToRootVC:(BOOL)animated
{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 0) { /** 跳过第一级 */
            [[GlobalConstants sharedGlobalConstants].arrayVCs removeObject:obj];
        }
    }];
    
    [self.navigationController popToRootViewControllerAnimated:animated];
    kStackMsg;
}

#pragma mark - push
/** 推送界面＋参数 */
- (void)pushVC:(ZXBasicVC *)VC completion:(vcCompletionBlock)completionBLock;
{
    VC.completionBlock = completionBLock;
    
    [self pushVC:VC];
}
/** 推送界面 */
- (void)pushVC:(ZXBasicVC *)VC
{
    
    [self pushViewController:VC animated:YES];
}

- (void)pushVC:(ZXBasicVC *)VC animated:(BOOL)animated
{
    
    [self pushViewController:VC animated:animated];
    
}

- (void)pushMultipleVC:(NSArray *)VCs
{
    [self pushMultipleVC:VCs animated:YES];
}
- (void)pushMultipleVC:(NSArray *)VCs animated:(BOOL)animated
{
    NSArray *oldViewControllers = self.navigationController.viewControllers;
    NSMutableArray *newViewControllers = [NSMutableArray arrayWithArray:oldViewControllers];
    [newViewControllers addObjectsFromArray:VCs];
    [self.navigationController setViewControllers:newViewControllers animated:animated];
    
    for (UIViewController *VC in VCs) {
        [self addObjectWithVC:VC];
    }
}


#pragma mark - pop
/** 返回到某个界面＋参数 */
- (void)popToVCWithClassName:(Class)className completion:(vcCompletionBlock)completionBLock animated:(BOOL)animated
{
    ZXBasicVC *VC = [self popToViewController:className animated:animated];
    VC.completionBlock = completionBLock;
}
/** 返回到某个界面 */
- (void)popToVCWithClassName:(Class)className animated:(BOOL)animated
{
    [self popToViewController:className animated:animated];
}
/** 返回上一个界面＋参数 */
- (void)popToVCWithCompletion:(vcCompletionBlock)completionBLock animated:(BOOL)animated
{
    ZXBasicVC *VC = [self popViewControllerAnimated:animated];
    VC.completionBlock = completionBLock;
}

/** 返回上一个界面 */
- (void)popToVC:(BOOL)animated
{
    [self popViewControllerAnimated:animated];
}

/** 返回上一个界面(返回按钮无法传参，默认有动画) */
- (void)popToVC
{
    [self popToVC:YES];
}

#pragma mark - 添加对象到数组
- (void)addObjectWithVC:(UIViewController *)VC
{
    [[GlobalConstants sharedGlobalConstants].arrayVCs addObject:VC];
    kStackMsg;
}

#pragma mark - 从数组移除最后一个对象
- (UIViewController *)removeLastObjectWithVC
{
    UIViewController *VC = nil;
    if ([GlobalConstants sharedGlobalConstants].arrayVCs.count > 1) {
        /** 与Navigation堆栈对比判断，防止快速点击返回时执行多次 */
        if ([[self.navigationController.viewControllers lastObject] isEqual:[[GlobalConstants sharedGlobalConstants].arrayVCs lastObject]]) {
            [[GlobalConstants sharedGlobalConstants].arrayVCs removeLastObject];
            VC = [GlobalConstants sharedGlobalConstants].arrayVCs.lastObject;
            kStackMsg;
        }
    }
    return VC;
}


#pragma mark - 从数组获取对象
/**
 * 注释：根据自身堆栈判断className是否存在，存在则返回className对应的VC，并将className之后的VC销毁，若销毁过程中遇到presentVC，将其dismiss再往后销毁
 * 特殊情况：
 1、主界面只会记录MainTarBarVC而不会记录ChildVC，但入参className可输入ChildVC的className
 2、例如 A push B push C present D push E push F ；堆栈：A、B、C、present标记、D、E、F
 场景1、F执行popTo D时，执行注释说明；堆栈：A、B、C、present标记、D
 场景2、F执行popTo B时，执行注释说明；堆栈：A、B
 场景3、C执行popTo B时，执行注释说明；堆栈：A、B
 3、新增情况 堆栈：A、B、C、B、C、C、B；B执行popTo B时，查询最前面的VC；堆栈：A、B
 */
- (UIViewController *)getObjectWithArrayVCs:(Class)className
{
    if (className == nil || ![className isSubclassOfClass:[ZXBasicVC class]]) return nil;
    
    /** 当前调用者在堆栈的位置 */
    __block NSInteger index = NSNotFound;
    /** 新增主界面的子VC判断 */
    __block Class queryClassName = className;
    
    NSInteger vcCount = [GlobalConstants sharedGlobalConstants].arrayVCs.count;
    
    __block BOOL isExists = NO;
    /** 判断className是否存在堆栈内 */
    [[GlobalConstants sharedGlobalConstants].arrayVCs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:queryClassName] && idx < vcCount-1) { /** 顺序遍历 不能为最后一个 */
            isExists = YES;
            index = idx;
            *stop = YES;
        }
    }];
    
    if (isExists == NO) {
        NSLog(@"😱😱😱推送指定对象%@在堆栈内不存在 或 最后一个", queryClassName);
        return nil;
    }
    
    return [self getViewControllerByIndex:index childIndex:0];
}

- (UIViewController *)getViewControllerByIndex:(NSInteger)index childIndex:(NSInteger)childIndex
{
    /** 倒序获取查找vc的位置 */
    __block NSInteger presentIndex = NSNotFound;
    [[GlobalConstants sharedGlobalConstants].arrayVCs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == index) { /** 倒序遍历 查询到指定位置 */
            *stop = YES;
        } else {
            if ([obj isEqual:kPresentMark]) {
                presentIndex = idx;
                *stop = YES;
            }
        }
    }];
    
    /** 存在present，先dismiss，再递归 */
    if (presentIndex != NSNotFound) {
        [self dismissVC:NO completion:nil];
        return [self getViewControllerByIndex:index childIndex:childIndex];
    }
    
    ZXBasicVC *VC = nil;
    if (index != NSNotFound) {
        NSInteger vcCount = [GlobalConstants sharedGlobalConstants].arrayVCs.count;
        /** 获取vc实例 */
        VC = [GlobalConstants sharedGlobalConstants].arrayVCs[index];
        /** 删除当前VC后的所有堆栈 */
        [[GlobalConstants sharedGlobalConstants].arrayVCs removeObjectsInRange:NSMakeRange(index+1, vcCount-index-1)];
    }
    kStackMsg;
    return VC;
}

#pragma mark ------------------- 导航栏设置 -------------------
#pragma mark - /** 隐藏导航栏返回Item*/
- (void)hideNavgationBackBarItem
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - /** 设置导航栏左边Item*/
- (BOOL)setNavBackBarTitle:(BOOL)isSetNavBackBar
{
    [self hideNavgationBackBarItem];
    
    if (isSetNavBackBar) {
        NSInteger VCsCount = [GlobalConstants sharedGlobalConstants].arrayVCs.count-1;
        /** 当前VC */
        ZXBasicVC *preVC = [GlobalConstants sharedGlobalConstants].arrayVCs[VCsCount];
        
        /** 堆栈当前VC不等于实际当前VC 不设置返回按钮［忽略堆栈外的VC 例如搜索、主界面子VC］ */
        if (![preVC isMemberOfClass:[self class]]) {
            return NO;
        }
        
        if (VCsCount > 0) {
            /** 获取上级VC */
            preVC = [GlobalConstants sharedGlobalConstants].arrayVCs[VCsCount-1];
        } else {
            /** 只存在一个VC 不设置返回 */
            return NO;
        }
        
        /** 上一个vc为presentVC标记，则取消返回按钮和侧滑功能 */
        if (![preVC isKindOfClass:[ZXBasicVC class]]) {
            return NO;
        }
        
        
//        NSString *title = preVC.title;
        NSString *title = @" ";
        
        UIBarButtonItem *navBackBarButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(popToVC)];
        UIImage *leftBackImg = [UIImage imageNamed:@"Default_Miracle_Navigationbar_back_arrow"];
        [navBackBarButton setBackgroundImage:[leftBackImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, leftBackImg.size.width, 0, 0)]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [navBackBarButton setTitlePositionAdjustment:UIOffsetMake(5, 0) forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = navBackBarButton;
        return YES;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    return NO;
}

@end
