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
