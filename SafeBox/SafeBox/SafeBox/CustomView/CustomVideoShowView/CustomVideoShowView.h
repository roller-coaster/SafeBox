//
//  CustomVideoShowView.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/12.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomVideoShowView : UIView

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

/** 大小,默认50*50 */
@property (nonatomic, assign) CGSize itemSize;

@end
