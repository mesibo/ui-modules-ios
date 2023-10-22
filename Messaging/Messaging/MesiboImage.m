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

#import "MesiboImage.h"
#import <UIKit/UIKit.h>
#import "UIColors.h"
#import "UIImage+Tint.h"
#import "Includes.h"
#import "MesiboCommonUtils.h"


@implementation MesiboImage

static NSMutableArray * statusImages = nil;
static UIImage * favoriteImage = nil;
static UIImage * favoriteImageOverPicture = nil;
static UIImage * userListChecked = nil;
static UIImage * userListUnChecked = nil;
static UIImageView *mUserListChecked = nil;
static UIImageView *mUserListUnChecked = nil;
static UIImage * mCheckedImage = nil;
static UIImage * mUnCheckedImage = nil;
static NSString *mDefaultUserProfilePath = nil ;
static NSString *mDefaultGroupProfilePath  = nil;
static UIImage * mDefaultProfileImage = nil;
static UIImage * mDefaultGroupImage = nil;
static UIImage * mAudioVideoPlayImage = nil;
static UIImage * mDefaultLocationImage = nil;
static UIImage * mSecureMessageImage = nil;
static UIImage * mSecureIconImage = nil;
static NSMutableDictionary *mImageDict = nil;

+(void) initialize {
    //_mBubble
}


+(NSMutableArray*)getStatusImages
{
    
    if(!statusImages) {
        statusImages = [[NSMutableArray alloc] init];
        UIImage *tintedImage = [MesiboImage imageNamed:@"ic_av_timer"];
        tintedImage = [tintedImage imageTintedWithColor:[UIColor getColor:NORMAL_TICK_COLOR] ];
        [statusImages addObject:tintedImage];
        tintedImage = [MesiboImage imageNamed:@"ic_check"];
        tintedImage = [tintedImage imageTintedWithColor:[UIColor getColor:NORMAL_TICK_COLOR] ];
        [statusImages addObject:tintedImage];
        tintedImage = [MesiboImage imageNamed:@"ic_done_all"];
        tintedImage = [tintedImage imageTintedWithColor:[UIColor getColor:NORMAL_TICK_COLOR] ];
        [statusImages addObject:tintedImage];
        tintedImage = [MesiboImage imageNamed:@"ic_done_all"];
        tintedImage = [tintedImage imageTintedWithColor:[UIColor getColor:NOTIFIED_TICK_COLOR] ];
        [statusImages addObject:tintedImage];
        tintedImage = [MesiboImage imageNamed:@"ic_error"];
        tintedImage = [tintedImage imageTintedWithColor:[UIColor getColor:ERROR_TICK_COLOR] ];
        [statusImages addObject:tintedImage];

        
    }
    return statusImages;
}

+ (UIImage*) getAudioVideoPlayImage {
    if(nil == mAudioVideoPlayImage) {
        mAudioVideoPlayImage = [MesiboImage imageNamed:@"ic_play_circle_outline_white_48pt"];
        //mAudioVideoPlayImage = [mAudioVideoPlayImage imageTintedWithColor:[UIColor getColor:WHITE_COLOR] ];
    }
    return mAudioVideoPlayImage;
}

+ (UIImage*) getCheckedImage {
    if(nil == mCheckedImage) {
        mCheckedImage = [MesiboImage imageNamed:@"ic_check_circle"];
        mCheckedImage = [mCheckedImage imageTintedWithColor:[UIColor getColor:CHECKED_COLOR] ];
    }
    return mCheckedImage;
}

+ (UIImage*) getRadioCheckedImage {
    if(nil == mCheckedImage) {
        mCheckedImage = [MesiboImage imageNamed:@"ic_radio_button_checked"];
        mCheckedImage = [mCheckedImage imageTintedWithColor:[UIColor getColor:CHECKED_COLOR] ];
    }
    return mCheckedImage;
}

+ (UIImage*) getUnCheckedImage {
    if(nil == mUnCheckedImage) {
        mUnCheckedImage = [MesiboImage imageNamed:@"ic_radio_button_unchecked"];
        mUnCheckedImage = [mUnCheckedImage imageTintedWithColor:[UIColor getColor:NORMAL_TICK_COLOR] ];
    }
    return mUnCheckedImage;
}

+ (UIImageView *) getCheckedImageView {
    
    if(nil == mUserListChecked) {
        
        userListChecked = [MesiboImage imageNamed:@"ic_done_all"];
        userListChecked = [userListChecked imageTintedWithColor:[UIColor getColor:NOTIFIED_TICK_COLOR] ];
        mUserListChecked = [[UIImageView alloc] initWithImage:userListChecked];
        [mUserListChecked setFrame:CGRectMake(0, 0, 28.0, 28.0)];
    }
    return mUserListChecked;
}

+ (UIImageView *) getUnCheckedImageView {
    
    if(nil == mUserListUnChecked) {
        userListUnChecked = [MesiboImage imageNamed:@"ic_radio_button_unchecked"];
        userListUnChecked = [userListUnChecked imageTintedWithColor:[UIColor getColor:NOTIFIED_TICK_COLOR] ];
        mUserListUnChecked = [[UIImageView alloc] initWithImage:userListUnChecked];
        [mUserListUnChecked setFrame:CGRectMake(0, 0, 28.0, 28.0)];

    }
    return mUserListUnChecked;
}
+ (UIImage *) getFavoriteImage {
    
    if(nil == favoriteImage) {
       favoriteImage = [MesiboImage imageNamed:@"ic_star"];
       favoriteImage = [favoriteImage imageTintedWithColor:[UIColor getColor:NORMAL_TICK_COLOR] ];
    }
    return favoriteImage;
}

+ (UIImage *) getFavoriteImageOverPicture {
    
    if(nil == favoriteImageOverPicture) {
        favoriteImageOverPicture = [MesiboImage imageNamed:@"ic_star"];
        favoriteImageOverPicture = [favoriteImageOverPicture imageTintedWithColor:[UIColor getColor:WHITE_COLOR] ];
    }
    return favoriteImageOverPicture;
}

+ (NSString *)imageNameKey:(NSString *)name color:(uint32_t)color {
    return [NSString stringWithFormat:@"%@_%u", name, color];
}

+ (UIImage *)imageNamed:(NSString *)imageName color:(uint32_t)color
{
    if(!mImageDict)
        mImageDict = [NSMutableDictionary new];
    
    NSString *key = [self imageNameKey:imageName color:color];
    
    UIImage *im = [mImageDict objectForKey:key];
    if(im) return im;
    
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    NSBundle *  ChatBundle = [[NSBundle alloc] initWithURL:bundleURL];
    im = [UIImage imageNamed:imageName inBundle:ChatBundle compatibleWithTraitCollection:nil];
    
    if(im) {
        if(color > 0)
            im = [im imageTintedWithColor:[UIColor getColor:color]];
    
        [mImageDict setObject:im forKey:key];
    }
    
    return im ;
}

+ (UIImage *)imageNamed:(NSString *)imageName {
    return [MesiboImage imageNamed:imageName color:0];
}

+(UIImage *) getSecureIcon {
    if(!mSecureIconImage) {
        mSecureIconImage = [MesiboImage imageNamed:@"ic_lock"];
        mSecureIconImage = [mSecureIconImage imageTintedWithColor:[UIColor getColor:0xBBEE0000] ];

    }
    return mSecureIconImage;
    
}


+(void) setSecureIcon:(UIImageView*)placeHolder {
    if(!mSecureMessageImage) {
        mSecureMessageImage = [MesiboImage imageNamed:@"ic_lock"];
        mSecureMessageImage = [mSecureMessageImage imageTintedWithColor:[UIColor getColor:NORMAL_TICK_COLOR] ];
        //CGSize s = {16, 16};
       // mSecureMessageImage = [mSecureMessageImage resizeTo:s];
    }
    placeHolder.image = mSecureMessageImage;
}

+ (void) updateStatusIcon :(UIImageView*)placeHolder : (int) status {

        placeHolder.image = [MesiboImage getStatusIcon:status] ;
}

+(UIImage *) getMissedCallIcon:(BOOL)video {
    if(video)
     return [MesiboImage imageNamed:@"baseline_missed_video_call_black_18pt" color:ICON_COLOR_MISSEDCALL];
    
    return [MesiboImage imageNamed:@"baseline_phone_missed_black_18pt" color:ICON_COLOR_MISSEDCALL];
                             
}

+(UIImage *) getDeletedMessageIcon {
    return [MesiboImage imageNamed:@"ic_cancel" color:ICON_COLOR_DELETED];
}

+ (UIImage*) getStatusIcon :(int) status
{
    if(status < 0) {
        return nil;
    }
    
    if(status <= MESIBO_MSGSTATUS_READ) {
        return([[MesiboImage getStatusImages] objectAtIndex:status]);
    } else if(status&MESIBO_MSGSTATUS_FAIL) {
        return([[MesiboImage getStatusImages] objectAtIndex:4]);
    }
    return nil;
}

+ (UIImage*) getDefaultProfileImage {
    if(nil == mDefaultProfileImage) {
        mDefaultProfileImage = [MesiboImage imageNamed:@"blank_profile"];
        //mDefaultProfileImage = [mDefaultProfileImage imageTintedWithColor:[UIColor getColor:NORMAL_TICK_COLOR] ];
    }
    return mDefaultProfileImage;
}

+ (UIImage*) getDefaultGroupImage {
    if(nil == mDefaultGroupImage) {
        mDefaultGroupImage = [MesiboImage imageNamed:@"group"];
        //mDefaultGroupImage = [mDefaultGroupImage imageTintedWithColor:[UIColor getColor:NORMAL_TICK_COLOR] ];
    }
    return mDefaultGroupImage;
}

+ (NSString*) getDefaultGroupProfilePath {
    if(nil == mDefaultGroupProfilePath) {
        mDefaultGroupProfilePath = [[MesiboCommonUtils getBundle] pathForResource :[NSString stringWithFormat:@"group"] ofType:@"png"];
        /*
        UIImage *imageToSave = [MesiboImage imageNamed:@"group"];
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
        mDefaultGroupProfilePath = [basePath stringByAppendingPathComponent:@"DefaultGroupImage.png"];
        [binaryImageData writeToFile:mDefaultGroupProfilePath atomically:YES];*/
        
    }
    return mDefaultGroupProfilePath;
}

+ (NSString*) getDefaultProfilePath {
    if(nil == mDefaultUserProfilePath) {
        mDefaultUserProfilePath = [[MesiboCommonUtils getBundle] pathForResource :[NSString stringWithFormat:@"DefaultUserImage"] ofType:@"png"];
        /*
        UIImage *imageToSave = [MesiboImage imageNamed:@"blank_profile"];
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        NSData * binaryImageData = UIImagePNGRepresentation(imageToSave);
        mDefaultUserProfilePath = [basePath stringByAppendingPathComponent:@"DefaultUserImage.png"];
        [binaryImageData writeToFile:mDefaultUserProfilePath atomically:YES];*/
        
    }
    return mDefaultUserProfilePath;

}

+ (UIImage*) getDefaultLocationImage {
    if(nil == mDefaultLocationImage) {
        mDefaultLocationImage = [MesiboImage imageNamed:@"default_location.jpg"];
    }
    return mDefaultLocationImage;
}

+(UIImage *) bubbleImage:(BOOL)local {
    
    static UIImage *mBubbleMe = nil;
    static UIImage *mBubbleRemote = nil;
    
    if(local) {
        if(!mBubbleMe)
            mBubbleMe = [[MesiboImage imageNamed:@"bubbleMine"]
                         stretchableImageWithLeftCapWidth:15 topCapHeight:14];
        return mBubbleMe;
    }
    
    if(!mBubbleRemote)
        mBubbleRemote = [[MesiboImage imageNamed:@"bubbleSomeone"]
                     stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    
    return mBubbleRemote;

}

+(UIImage *) getFileTypeImage:(NSString *)fileName {
    if(!fileName)
        return nil;
    
    NSString *fileExtension = [fileName pathExtension];
    if(!fileExtension)
        return nil;
    
    if([fileExtension length] > 3) {
        fileExtension = [fileExtension substringToIndex:3];
    }
    
    NSString *fileTypeImage = [NSString stringWithFormat:@"file_%@", fileExtension];
    UIImage *image = [MesiboImage imageNamed:fileTypeImage];
    if(image) return image;
    
    if([fileExtension isEqualToString:@"mp3"] || [fileExtension isEqualToString:@"wav"] ||
       [fileExtension isEqualToString:@"amr"] || [fileExtension isEqualToString:@"aif"]) {
        return [MesiboImage imageNamed:@"file_audio"];
    }
    
    return nil;
}

@end
