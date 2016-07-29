//
//  SaveImageToPhotos.m
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/3.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "SaveImageToPhotos.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/ALAsset.h>
typedef void(^SaveImageBlock)(BOOL isYES);

@interface SaveImageToPhotos ()<UIImagePickerControllerDelegate>

@end

@implementation SaveImageToPhotos

+ (void)createCustomAlbumWithTitle:(NSString *)title complete:(void (^)(PHAssetCollection *result))complete faile:(void (^)(NSError *error))faile{
    if (title.length == 0) {
        if (complete) complete(nil);
    }else{
        [ThreadDAO executeInGlobalQueue:^{
            // 是否存在相册 如果已经有了 就不再创建
            PHFetchResult <PHAssetCollection *> *results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            BOOL haveHDRGroup = NO;
            NSError *error = nil;
            PHAssetCollection *createCollection = nil;
            for (PHAssetCollection *collection in results) {
                if ([collection.localizedTitle isEqualToString:title]) {
                    /** 已经存在了，不需要创建了 */
                    haveHDRGroup = YES;
                    createCollection = collection;
                    break;
                }
            }
            if (haveHDRGroup) {
                NSLog(@"已经存在了，不需要创建了");
                [ThreadDAO executeInMainQueue:^{
                    if (complete) complete(createCollection);
                }];
            }else{
                __block NSString *createdCustomAssetCollectionIdentifier = nil;
                /**
                 * 注意：这个方法只是告诉 photos 我要创建一个相册，并没有真的创建
                 *      必须等到 performChangesAndWait block 执行完毕后才会
                 *      真的创建相册。
                 */
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title];
                    /**
                     * collectionChangeRequest 即使我们告诉 photos 要创建相册，但是此时还没有
                     * 创建相册，因此现在我们并不能拿到所创建的相册，我们的需求是：将图片保存到
                     * 自定义的相册中，因此我们需要拿到自己创建的相册，从头文件可以看出，collectionChangeRequest
                     * 中有一个占位相册，placeholderForCreatedAssetCollection ，这个占位相册
                     * 虽然不是我们所创建的，但是其 identifier 和我们所创建的自定义相册的 identifier
                     * 是相同的。所以想要拿到我们自定义的相册，必须保存这个 identifier，等 photos app
                     * 创建完成后通过 identifier 来拿到我们自定义的相册
                     */
                    createdCustomAssetCollectionIdentifier = collectionChangeRequest.placeholderForCreatedAssetCollection.localIdentifier;
                } error:&error];
                if (error) {
                    NSLog(@"创建了%@相册失败",title);
                    [ThreadDAO executeInMainQueue:^{
                        if (faile) faile(error);
                    }];
                }else{
                    /** 获取创建成功的相册 */
                    createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCustomAssetCollectionIdentifier] options:nil].firstObject;
                    NSLog(@"创建了%@相册成功",title);
                    [ThreadDAO executeInMainQueue:^{
                        if (complete) complete(createCollection);
                    }];
                }
            }
        }];
    }
}


#pragma mark - 保存图片到自定义相册
+ (void)saveImageToCustomPhotosAlbumWithTitle:(NSString *)title image:(UIImage *)saveImage complete:(void (^)(id ,NSError *))complete{
    if (iOS8Later) {
        [SaveImageToPhotos createCustomAlbumWithTitle:title complete:^(PHAssetCollection *result) {
            [SaveImageToPhotos saveToAlbumIOS7LaterWithImage:saveImage customAlbum:result completionBlock:^(PHAsset *asset) {
                if (complete) complete(asset, nil);
            } failureBlock:^(NSError *error) {
                if (complete) complete(nil, error);
            }];
        } faile:^(NSError *error) {
            if (complete) complete(nil, error);
        }];
    }else{
        /** iOS7之前保存图片到自定义相册方法 */
        [SaveImageToPhotos saveToAlbumImageData:saveImage customAlbumName:title completionBlock:^(ALAsset *asset) {
            if (complete) complete(asset, nil);
        } failureBlock:^(NSError *error) {
            if (complete) complete(nil, error);
        }];
    }
}


#pragma mark - iOS7之后保存相片到自定义相册
+ (void)saveToAlbumIOS7LaterWithImage:(UIImage *)image 
                          customAlbum:(PHAssetCollection *)customAlbum 
                      completionBlock:(void(^)(PHAsset *asset))completionBlock 
                         failureBlock:(void (^)(NSError *error))failureBlock
{
    [ThreadDAO executeInGlobalQueue:^{
        __block NSError *error = nil;
        __block PHObjectPlaceholder *placeholder = nil;
        PHAssetCollection *assetCollection = (PHAssetCollection *)customAlbum;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            placeholder = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [request addAssets:@[placeholder]]; 
            //将最新保存的图片设置为封面
            [request insertAssets:@[placeholder] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        } error:&error];
        if (error) {
            NSLog(@"保存失败");
            [ThreadDAO executeInMainQueue:^{
                if (failureBlock) failureBlock(error);
            }];
        } else {
            NSLog(@"保存成功");
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            /** 获取相册 */
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            [ThreadDAO executeInMainQueue:^{
                if (completionBlock) completionBlock([assets lastObject]);
            }];
            /** 返回保存对象 */
        } 
    }];
}

#pragma mark - iOS7之前保存相片到自定义相册
+ (void)saveToAlbumImageData:(UIImage *)image
             customAlbumName:(NSString *)customAlbumName
             completionBlock:(void (^)(ALAsset *asset))completionBlock
                failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    /** 循环引用处理 */
    __weak ALAssetsLibrary *weakAssetsLibrary = assetsLibrary;
    void (^AddAsset)(NSURL *) = ^(NSURL *assetURL) {
        [weakAssetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [weakAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    NSLog(@"保存相片成功");
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock(asset);
                    }
                    *stop = YES;
                }else{
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    
    /** 保存图片到系统相册，因为系统的 album 相当于一个 music library, 而自己的相册相当于一个 playlist, 你的 album 所有的内容必须是链接到系统相册里的内容的. */
    [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            /** 添加自定义相册 */
            [weakAssetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                [weakAssetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if (group) {
                        [group addAsset:asset];
                        NSLog(@"保存相片成功");
                        if (completionBlock) {
                            completionBlock(asset);
                        }
                    } else {
                        AddAsset(assetURL);
                    }
                } failureBlock:^(NSError *error) {
                    NSLog(@"%@",error.localizedDescription);
                    if (failureBlock) {
                        failureBlock(error);
                    }
                }];
            } failureBlock:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
                AddAsset(assetURL);
            }];
        } else {
            
        }
        
    }];
}
@end
