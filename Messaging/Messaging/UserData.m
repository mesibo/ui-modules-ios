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

#import "UserData.h"
#import "LetterTitleImage.h"
#import "MesiboImage.h"
#import "MesiboConfiguration.h"
#import "Mesibo/Mesibo.h"
#import "MesiboUI.h"

@interface UserData() {
    MesiboProfile *mUser;
    UIImage *mThumbnail;
    UIImage *mImage;
    NSString *mLastMessage;
    BOOL mDeleted;
    
    BOOL mFixedImage;
    NSIndexPath * mUserListPosition;
    MesiboProfile *mTypingProfile;
    MesiboMessage *mMsg;
}

@end

@implementation UserData

+(UserData *) initialize:(id)profile {
    UserData *u = [[UserData alloc] init];
    u->mUser = profile;
    return u;
}

-(id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    mUser = nil;
    mThumbnail = nil;
    mImage = nil;
    mLastMessage = nil;
    mMsg = nil;
    mDeleted = NO;
    
    mFixedImage = NO;
    mUserListPosition = nil;
    mTypingProfile = nil;
    return self;
}

-(NSString *) appendNameToMessage:(MesiboMessage *)params message:(NSString *)message {
    NSString * name = params.peer;
    if(params.profile)
        name = [params.profile getFirstName];
    
    if(!name || !name.length) return message;
    if(name.length > 12)
        name = [name substringToIndex:12];
    
    return [NSString stringWithFormat:@"%@: %@", name, message];
}

-(void) setMessage:(MesiboMessage *) message {
    mMsg = message;
    
    NSString * str = mMsg.message;
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    if([mMsg isDeleted]) {
        str = opts.deletedMessageTitle;
        [self setTextMessage:str];
        return;
    }
    
    
    if(!str || !str.length) str = mMsg.title;
    if(!str || !str.length) {
        if ([mMsg hasImage])
            str = IMAGE_STRING;
        else if ([mMsg hasVideo])
            str = VIDEO_STRING;
        else if ([mMsg hasAudio ])
            str = AUDIO_STRING;
        else if ([mMsg hasFile])
            str = ATTACHMENT_STRING;
        else if ([mMsg hasLocation])
            str = LOCATION_STRING;
    }
    
    if([mMsg isGroupMessage] && [mMsg isIncoming]) {
        str = [self appendNameToMessage:mMsg message:str];
    }
    
    if([mMsg isMissedCall]) {
        str = opts.missedVideoCallTitle;
        if([mMsg isVoiceCall])
            str = opts.missedVoiceCallTitle;
    }
    
    [self setTextMessage:str];
}

-(void) setTextMessage:(NSString *) message {
    mLastMessage = message;
}

-(NSString *) getLastMessage {
    if(!mLastMessage) return @"";
    return mLastMessage;
}

-(MesiboMessage *) getMessage {
    return mMsg;
}

-(NSString *) getPeer {
    return [mUser getAddress];
}

-(uint32_t) getGroupId {
    return [mUser getGroupId];
}

-(uint64_t) getMid {
    if(mMsg) return mMsg.mid;
    return 0;
}

-(void) setUser:(MesiboProfile *) profile {
    mUser = profile;
    if(mFixedImage)
        return;
}

-(void) setFixedImage:(BOOL) fixed {
    mFixedImage = fixed;
}

-(int) getUnreadCount {
    return [mUser getUnreadMessageCount];
}

-(int) getMessageStatus {
    if(!mMsg) return MESIBO_MSGSTATUS_RECEIVEDREAD;
    return [mMsg getStatus];
}

-(NSString *) getTime {
    if(!mMsg) return @"";

    MesiboDateTime *ts = [mMsg getTimestamp];
    if([ts isToday])
        return [ts getTime:NO];
    
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    return [ts getDate:opts.showMonthFirst today:opts.today yesterday:opts.yesterday numerical:YES];
}

-(NSString *) getName {
    return [mUser getNameOrAddress];
}

-(NSString *) getUserStatus {
    return [mUser getStatus];
}

-(BOOL)isDeleted {
    if(!mMsg)    return mDeleted;
    return (mDeleted || [mMsg isDeleted]);
}

-(void)setDeleted:(BOOL)deleted {
    mDeleted = deleted;
}

-(void) setTyping:(MesiboProfile *) profile {
    mTypingProfile = profile;
}

-(NSString *) getImagePath {
    return [mUser getImageOrThumbnailPath];
}

-(void) setThumbnail:(UIImage *) thumbnail {
    mThumbnail = thumbnail;
}

-(void) setImage:(UIImage *)image {
    mImage = image;
}

-(UIImage *) getImage {
    if(mUser) return [mUser getImageOrThumbnail];
    
    if(mImage) return mImage;
    
    return nil;
}

-(UIImage *) getThumbnail {
    if(mUser) {
        UIImage *tn = [mUser getThumbnail];
        //if(tn) mThumbnail = tn;
        return tn;
    }
    
    if(mThumbnail) return mThumbnail;
    
    return nil;
}

-(UIImage *) getDefaultImage:(BOOL)useTitler {
    UIImage *image = nil;
    
    if(useTitler)
        image = [LetterTitleImage drawTitleImage:[self getName] withSize:LETTER_TITLE_IMAGE_SIZE];
    else if([self getGroupId] > 0) {
        image = [MesiboImage getDefaultGroupImage];
    }else {
        image = [MesiboImage getDefaultProfileImage];
    }
    
    return image;
}

-(BOOL) isTyping {
    if(mTypingProfile) return [mTypingProfile isTypingInGroup:[mUser getGroupId]];
    return [mUser isTypingInGroup:[mUser getGroupId]];
}

-(MesiboProfile *) getTypingProfile {
    return mTypingProfile;
}

-(void) setUserListPosition:(NSIndexPath *) position {
    mUserListPosition = position;
}

-(NSIndexPath *) getUserListPosition {
    return mUserListPosition;
}

+(UserData *) getUserDataFromParams:(MesiboMessageProperties *) params {
    if(!params || !params.profile)
        return nil;
    
    return [UserData getUserDataFromProfile:params.profile];
}

+(UserData *) getUserDataFromProfile:(MesiboProfile *) profile {
    if(!profile) return nil;
    
    UserData *d = (UserData *) [profile getUserData];
    if(!d) {
        d = [UserData initialize:profile];
        [profile setUserData:d];
    }
    return d;
}

@end
