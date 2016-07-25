//
//  UtilityHeader.h
//  UtilityLayer
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#ifndef UtilityHeader_h
#define UtilityHeader_h

//! 系统版本
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

/** --------------- 归档 ------------- */
#import "ArchiverUtils.h"
/** --------------- 文件操作 -------------- */
#import "FileUtility.h"
#import "VideoUtils.h"
/** ------------------ 时间 -------------- */
#import "NSDate+Analyse.h"
#import "NSDate+Common.h"
#import "NSDate+Millisecond.h"

/** ----------- 数据源操作 ------------------ */
#import "CoverData.h"

/** ------------- 描边 ------------ */
#import "UIView+Layer.h"
/** ------------- 颜色  --------------- */
#import "UIColor+Addition.h"

/** ------------- 压缩图片大小  --------------- */
#import "UIImage+Size.h"

#endif /* UtilityHeader_h */
