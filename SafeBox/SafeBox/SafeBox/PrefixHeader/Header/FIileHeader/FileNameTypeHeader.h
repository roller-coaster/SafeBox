//
//  FileNameTypeHeader.h
//  SafeBox
//
//  Created by 丁嘉睿 on 16/6/1.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#ifndef FileNameTypeHeader_h
#define FileNameTypeHeader_h

#define FILE_NAME_ALL @"全部文件"
#define FILE_NAME_VIDEO @"视频"
#define FILE_NAME_PHOTOS @"照片"
#define FILE_NAME_Archiver @"Archiver"
#define FILE_NAME_ALL_PATH [DOCUMENT_PATH stringByAppendingPathComponent:FILE_NAME_ALL]
#define FILE_NAME_VIDEO_PATH [DOCUMENT_PATH stringByAppendingPathComponent:FILE_NAME_VIDEO]
#define FILE_NAME_PHOTOS_PATH [DOCUMENT_PATH stringByAppendingPathComponent:FILE_NAME_PHOTOS]

#define FILE_NAME_Archiver_PATH [DOCUMENT_PATH stringByAppendingPathComponent:FILE_NAME_Archiver]

#define ArchiverName @"Archiver.archiver"
#endif /* FileNameTypeHeader_h */
