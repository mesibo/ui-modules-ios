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

#import "FacebookLogin.h"
#import "ImagePicker.h"
#import "AlbumTableController.h"
#ifdef FACEBOOK_ENABLE

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#endif
#import "Defines.h"
#import "ImagePickerUtils.h"





@implementation FacebookLogin

+ (FacebookLogin *)sharedInstance {
    static dispatch_once_t once;
    static FacebookLogin *sharedMyClass;
    dispatch_once(&once, ^ {
        sharedMyClass = [[self alloc] init];
        sharedMyClass.mAlbumListed = [[NSMutableArray alloc]init];
        
    });
    
    return sharedMyClass;
}

#ifdef FACEBOOK_ENABLE

-(void)initiateLogin {

    
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if(token) {
        
        [self getFacebookAlbums];
        
    } else {

        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_likes", @"user_birthday",@"user_photos",]
         fromViewController:_mParentController
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 if ([result.grantedPermissions containsObject:@"email"]) {
                     // Do work
                     FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
                     
                     if (token){
                         NSDictionary *authData = @{@"id":token.userID,
                                                    @"access_token":token.tokenString,
                                                    @"expiration_date":token.expirationDate};
                         
                         
                         [self getFacebookAlbums];

                         NSLog(@"Facebook authdata:%@", authData);
                     } else {
                         NSLog(@"currentAccessToken is nil");
                     }
                 }
             }
         }];
    }
    
}

-(void) getFacebookAlbums  {
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me?fields=albums.fields(name,photos.fields(name,picture,source))"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        
        [_mAlbumListed removeAllObjects];
        
        NSArray* albums = result[@"albums"][@"data"];
        
        //int index = 0;
        
        for( NSDictionary *albumDictionary in albums) {
            
            AlbumsData *tmpAlbum = [[AlbumsData alloc] init];
            
            tmpAlbum.mAlbumID = albumDictionary[@"id"];
            
            tmpAlbum.mAlbumID = albumDictionary[@"id"];
            
            NSLog(@"id:%@", tmpAlbum.mAlbumID);
            tmpAlbum.mAlbumName = albumDictionary[@"name"];
            
            NSLog(@"id:%@", tmpAlbum.mAlbumName);
            
            tmpAlbum.mAlbumPhotoCount = [(albumDictionary[@"photos"][@"data"]) count];
            
            tmpAlbum.mPhotoGList = [[NSMutableArray alloc] init];
            
            if( tmpAlbum.mAlbumPhotoCount>0) {
                
                tmpAlbum.mAlbumProfilePicPath = albumDictionary[@"photos"][@"data"][0][@"picture"];
                
                for( NSDictionary *pictureDictionary in albumDictionary[@"photos"][@"data"]){
                    
                    PhotoData *picture = [PhotoData new];
                    
                    picture.mId =pictureDictionary[@"id"];
                    picture.mIconPath =pictureDictionary[@"picture"];
                    picture.mSourcePath =pictureDictionary[@"source"];
                    
                    [tmpAlbum.mPhotoGList addObject:picture];
                }
            }
            
            [_mAlbumListed addObject:tmpAlbum];
        }
        int albumCount = (int)[albums count];
        
        NSLog(@"Facebook authdata:%d", albumCount);
        
        
        UIStoryboard *storyboard = [ImagePickerUtils getMeImageStoryBoard];
        
        AlbumTableController *at = [storyboard instantiateViewControllerWithIdentifier:@"AlbumTableController"];
        
        if([at isKindOfClass:[AlbumTableController class]]) {
            UINavigationController *un = [[UINavigationController alloc] initWithRootViewController:at];
            at.mAlbumsData = _mAlbumListed;
            [_mParentController presentViewController:un animated:YES completion:nil];
        }
        
        
        
    }];
    return;
}


#else

-(void)initiateLogin {
        
}



#endif
@end
