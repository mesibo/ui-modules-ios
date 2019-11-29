/** Copyright (c) 2019 Mesibo
 * https://mesibo.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the terms and condition mentioned
 * on https://mesibo.com as well as following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions, the following disclaimer and links to documentation and
 * source code repository.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of Mesibo nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific prior
 * written permission.
 *
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Documentation
 * https://mesibo.com/documentation/
 *
 * Source Code Repository
 * https://github.com/mesibo/ui-modules-ios
 *
 */

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
