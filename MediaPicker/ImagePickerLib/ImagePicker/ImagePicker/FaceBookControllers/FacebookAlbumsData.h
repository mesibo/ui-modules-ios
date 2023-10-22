/******************************************************************************
* By accessing or copying this work, you agree to comply with the following   *
* terms:                                                                      *
*                                                                             *
* Copyright (c) 2019-2023 mesibo                                              *
* https://mesibo.com                                                          *
* All rights reserved.                                                        *
*                                                                             *
* Redistribution is not permitted. Use of this software is subject to the     *
* conditions specified at https://mesibo.com . When using the source code,    *
* maintain the copyright notice, conditions, disclaimer, and  links to mesibo * 
* website, documentation and the source code repository.                      *
*                                                                             *
* Do not use the name of mesibo or its contributors to endorse products from  *
* this software without prior written permission.                             *
*                                                                             *
* This software is provided "as is" without warranties. mesibo and its        *
* contributors are not liable for any damages arising from its use.           *
*                                                                             *
* Documentation: https://mesibo.com/documentation/                            *
*                                                                             *
* Source Code Repository: https://github.com/mesibo/                          *
*******************************************************************************/

//
//  AlbumGallery.h
//  fun
//
//  Created by dig on 2/20/16.
//  Copyright © 2016 _TringMe_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookPhotoData.h"
@interface AlbumsData : NSObject

@property (strong , nonatomic) NSString* mAlbumID;
@property (strong , nonatomic) NSString* mAlbumProfilePicPath;
@property (strong , nonatomic) NSString* mAlbumName;
@property (assign , nonatomic) NSInteger mAlbumPhotoCount;
//@property (strong , nonatomic) PhotoGallery* mPhotoList;
@property (strong , nonatomic) NSMutableArray* mPhotoGList;

@end
