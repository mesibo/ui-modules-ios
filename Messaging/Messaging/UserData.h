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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Mesibo/Mesibo.h>

@interface UserData : NSObject

+(UserData *) initialize:(MesiboProfile *) profile;

-(void) setMessage:(MesiboMessage *) message;
-(void) setTextMessage:(NSString *) message;
-(NSString *) getPeer;
-(uint32_t) getGroupId;
-(uint64_t) getMid;
-(void) setUser:(MesiboProfile *) profile;
        
-(void) setFixedImage:(BOOL) fixed;
-(int) getUnreadCount;
-(int) getMessageStatus;
-(NSString *) getLastMessage;
-(NSString *) getTime;
-(NSString *) getName;
-(NSString *) getUserStatus;
-(MesiboMessage *) getMessage;
-(BOOL)isDeleted;
-(void) setDeleted:(BOOL)deleted;

-(NSString *) getImagePath;
-(void) setThumbnail:(UIImage *) thumbnail;
-(void) setImage:(UIImage *)image;
-(UIImage *) getImage;
-(UIImage *) getThumbnail;
-(UIImage *) getDefaultImage:(BOOL)useTitler ;

-(void) setTyping:(MesiboProfile *) profile;
-(BOOL) isTyping;
-(MesiboProfile *) getTypingProfile;
-(void) setUserListPosition:(NSIndexPath *)indexPath;
-(NSIndexPath *) getUserListPosition;


+(UserData *) getUserDataFromParams:(MesiboMessageProperties *) params;

+(UserData *) getUserDataFromProfile:(MesiboProfile *) profile;


@end
