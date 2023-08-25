/** Copyright (c) 2023 Mesibo, Inc
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
    return [mMsg getTime:NO];
}

-(NSString *) getName {
    return [mUser getNameOrAddress:@"+"];
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
