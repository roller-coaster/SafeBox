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


/**
 *  @author djr
 *  
 *  创建相册
 *  @param title 相册名称
 *  @param complete 成功
 *  @param faile 失败
 */
+ (void)createCustomAlbumWithTitle:(NSString *)title complete:(void (^)(id))complete faile:(void (^)())faile;


+ (void)saveImageToCustomPhotosAlbumWithTitle:(NSString *)title image:(UIImage *)saveImage complete:(void (^)(id))complete failer:(void (^)(NSError *))failer;
@end
