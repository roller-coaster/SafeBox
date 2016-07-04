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
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
#define IOS8_OR_LATER NLSystemVersionGreaterOrEqualThan(8.0)
#define IOS9_OR_LATER NLSystemVersionGreaterOrEqualThan(9.0)

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

#endif /* UtilityHeader_h */
