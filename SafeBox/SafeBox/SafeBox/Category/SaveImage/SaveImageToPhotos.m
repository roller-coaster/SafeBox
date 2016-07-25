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


+ (void)createCustomAlbumWithTitle:(NSString *)title complete:(void (^)(id result))complete faile:(void (^)())faile{
    if (title.length == 0) {
        if (faile) faile();
    }else{
        if (iOS8Later) {
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
                    [ThreadDAO executeInMainQueue:^{
                        NSLog(@"已经存在了，不需要创建了");
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
                        [ThreadDAO executeInMainQueue:^{
                            NSLog(@"创建了%@相册失败",title);
                            if (faile) faile();
                        }];
                    }else{
                        /** 获取创建成功的相册 */
                        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCustomAssetCollectionIdentifier] options:nil].firstObject;
                        [ThreadDAO executeInMainQueue:^{
                            NSLog(@"创建了%@相册成功",title);
                            if (complete) complete(createCollection);
                        }];
                    }
                }
            }];
        }else{
            [ThreadDAO executeInGlobalQueue:^{
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                NSMutableArray *groups=[[NSMutableArray alloc]init];
                ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop){
                    if (group)
                    {
                        [groups addObject:group];
                        
                    }else{
                        BOOL haveHDRGroup = NO;
                        for (ALAssetsGroup *gp in groups)
                        {
                            NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                            
                            if ([name isEqualToString:title])
                            {
                                /** 已经创建过相册了 */
                                [ThreadDAO executeInMainQueue:^{
                                    NSLog(@"已经存在了，不需要创建了");
                                    if (complete) complete(title);
                                }];
                                haveHDRGroup = YES;
                            }
                        }
                        
                        if (!haveHDRGroup)
                        {
                            //do add a group named "XXXX"
                            [library addAssetsGroupAlbumWithName:title resultBlock:^(ALAssetsGroup *group)     {
                                
                                //创建相簿成功
                                [groups addObject:group];
                                [ThreadDAO executeInMainQueue:^{
                                    NSLog(@"创建了%@相册成功",title);
                                    if (complete) complete(title);
                                }];
                            } failureBlock:^(NSError *error){
                                [ThreadDAO executeInMainQueue:^{
                                    NSLog(@"创建了%@相册失败",title);
                                    if (faile) faile();
                                }];
                            }];
                            haveHDRGroup = YES;
                        }
                        //创建相簿
                        [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
                    }
                };
            }];
        }
    }
}


#pragma mark - 保存图片到自定义相册
+ (void)saveImageToCustomPhotosAlbumWithTitle:(NSString *)title image:(UIImage *)saveImage complete:(void (^)(id))complete failer:(void (^)(NSError *))failer{
    [SaveImageToPhotos createCustomAlbumWithTitle:title complete:^(id result){
        if ([result isKindOfClass:[NSString class]]) {
            [SaveImageToPhotos saveToAlbumWithImageData:saveImage customAlbumName:result completionBlock:^(ALAsset *asset){
                if (complete) complete(asset);
            } failureBlock:^(NSError *error) {
                if (failer) failer(error);
            }];
        }else{
            __block NSError *error = nil;
            __block PHObjectPlaceholder *placeholder = nil;
            PHAssetCollection *assetCollection = (PHAssetCollection *)result;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                placeholder = [PHAssetChangeRequest creationRequestForAssetFromImage:saveImage].placeholderForCreatedAsset;
                PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                [request addAssets:@[placeholder]]; 
                //将最新保存的图片设置为封面
                [request insertAssets:@[placeholder] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            } error:&error];
            if (error) {
                NSLog(@"保存失败");
                if (failer) failer(error);
            } else {
                NSLog(@"保存成功");
                /** 获取相册所有对象 */
                PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                /** 返回保存对象 */
                if (complete) complete([assets lastObject]);
            } 
        }
    } faile:^{
        if (failer) failer(nil);
    }];
}


#pragma mark - ios7.0后保存相片到自定义相册
+ (void)saveToAlbumWithImageData:(UIImage *)imageData
                 customAlbumName:(NSString *)customAlbumName
                 completionBlock:(void (^)(ALAsset *asset))completionBlock
                    failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock(asset);
                    }
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
    [assetsLibrary writeImageToSavedPhotosAlbum:imageData.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName.length > 0) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock(asset);
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(weakSelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
            }];
        } else {
            if (failureBlock) {
                failureBlock(nil);
            }
        }
    }];
}

@end
