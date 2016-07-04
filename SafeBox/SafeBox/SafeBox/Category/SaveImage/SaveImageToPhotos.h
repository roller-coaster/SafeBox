//
//  SaveImageToPhotos.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/3.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SaveImageToPhotosDeleagte <NSObject>

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

@end

@interface SaveImageToPhotos : NSObject

@property (nonatomic, weak) id<SaveImageToPhotosDeleagte>delegate;

+ (void)saveImageToPhotosWithImage:(UIImage *)saveImg completionBlock:(void(^)(BOOL success, NSError *error))completionBlock;

@end
