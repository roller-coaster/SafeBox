//
//  SaveImageToPhotos.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/7/3.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveImageToPhotos : NSObject


+ (void)saveImageToCustomPhotosAlbumWithTitle:(NSString *)title image:(UIImage *)saveImage complete:(void (^)(id ,NSError *))complete;

@end
