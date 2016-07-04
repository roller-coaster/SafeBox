//
//  SaveImageToPhotos.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/3.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "SaveImageToPhotos.h"

#import <AssetsLibrary/ALAssetsLibrary.h>

#import <Photos/Photos.h>

typedef void(^SaveImageBlock)(BOOL isYES);

@interface SaveImageToPhotos ()<UIImagePickerControllerDelegate>

@end

@implementation SaveImageToPhotos

+ (void)saveImageToPhotosWithImage:(UIImage *)saveImg completionBlock:(void (^)(BOOL, NSError *))completionBlock{
    if (IOS8_OR_LATER) {
        /** 获取相册的合集 */
        PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;        
        /** 对获取到集合进行遍历 */
        [collectonResuts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)obj;
//            NSLog(@"%@",assetCollection.localizedTitle);
            /** 我们要写入的相册 */
            if ([assetCollection.localizedTitle isEqualToString:@"Camera Roll"]) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    /** 保存相片 */
                    [PHAssetChangeRequest creationRequestForAssetFromImage:saveImg];
                } completionHandler:completionBlock];
            }
        }];
     }else{
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
         [library writeImageToSavedPhotosAlbum:saveImg.CGImage metadata:@{} completionBlock:^(NSURL *assetURL, NSError *error) {
             if (error) {
                 if (completionBlock) {
                     completionBlock(NO, error);
                 }
             }else{
                 if (completionBlock) {
                     completionBlock(YES, nil);
                 }
             }
         }];
    }
}

@end
