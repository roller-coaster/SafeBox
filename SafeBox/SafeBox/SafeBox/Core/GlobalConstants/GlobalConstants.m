//
//  GlobalConstants.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "GlobalConstants.h"

@implementation GlobalConstants

static GlobalConstants *sharedSelf = nil;

+ (GlobalConstants *)sharedGlobalConstants
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSelf = [[self alloc] init];
    });
    return sharedSelf;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.arrayVCs = [NSMutableArray array];
    }
    return self;
}

@end
