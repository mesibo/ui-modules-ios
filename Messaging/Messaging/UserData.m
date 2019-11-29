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

#import "UserData.h"
#import "LetterTitleImage.h"
#import "MesiboImage.h"
#import "MesiboConfiguration.h"
#import "Mesibo/Mesibo.h"

@interface UserData() {
    MesiboUserProfile *mUser;
    UIImage *mThumbnail;
    UIImage *mImage;
    NSString *mLastMessage;
    NSString *mTime;
    NSString *mCatchedPicturePath;
    int mUnreadCount;
    int mStatus;
    BOOL mDeleted;
    uint64_t mId;
    
    BOOL mFixedImage;
    NSIndexPath * mUserListPosition;
    uint64_t mTypingTs;
    MesiboUserProfile *mTypingProfile;
    NSTimer *mUserListTimer;
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
    
    mUserListTimer = nil;
    mUser = nil;
    mThumbnail = nil;
    mImage = nil;
    mLastMessage = nil;
    mTime = @"";
    mCatchedPicturePath = nil;
    mStatus = MESIBO_MSGSTATUS_RECEIVEDNEW;
    mDeleted = NO;
    mId = 0;
    mUnreadCount = 0;
    
    mFixedImage = NO;
    mUserListPosition = nil;
    mTypingTs = 0;
    mTypingProfile = nil;
    return self;
}

-(void) setMessage:(uint64_t)messageid time:(NSString*)msgtime status:(int)status deleted:(BOOL)deleted msg:(NSString*)msg {
    mTime = msgtime;
    mStatus = status;
    mDeleted = deleted;
    mId = messageid;
    mLastMessage = msg;
}

-(NSString *) getPeer {
    return mUser.address;
}

-(uint32_t) getGroupId {
    return mUser.groupid;
}

-(uint64_t) getMid {
    return mId;
}

-(void) setMid:(uint64_t)msgid {
    mId = msgid;
}

-(void) setUser:(MesiboUserProfile *) profile {
    mUser = profile;
    if(mFixedImage)
        return;
    
    if(!mUser.picturePath || !mCatchedPicturePath || [mUser.picturePath isEqualToString:mCatchedPicturePath]) {
        mImage = nil;
        mThumbnail = nil;
    }
}

-(void) setFixedImage:(BOOL) fixed {
    mFixedImage = fixed;
}

-(int) getUnreadCount {
    return mUnreadCount;
}

-(void) setUnreadCount:(int)count {
    mUnreadCount = count;
}

-(void) clearUnreadCount {
    mUnreadCount = 0;
}

-(int) getMessageStatus {
    return mStatus;
}

-(void) setMessageStatus:(int) status {
    mStatus = status;
}

-(void) setLastMessage:(NSString *) lastMsg {
    mLastMessage = lastMsg;
}

-(NSString *) getLastMessage {
    if([self isDeleted])
        return MESSAGEDELETED_STRING;
    return mLastMessage;
}

-(NSString *) getTime {
    return mTime;
}

-(void) setTime:(NSString *)msgTime {
    mTime = msgTime;
}

-(NSString *) getName {
    return mUser.name;
}

-(NSString *) getUserStatus {
    return mUser.status;
}

-(BOOL)isDeleted {
    return mDeleted;
}

-(void)setDeleted:(BOOL)deleted {
    mDeleted = deleted;
}

-(NSString *) getImagePath {
    return [MesiboInstance getProfilePicture:mUser type:MESIBO_FILETYPE_AUTO];
}

-(void) setThumbnail:(UIImage *) thumbnail {
    mThumbnail = thumbnail;
}

-(void) setImage:(UIImage *)image {
    mImage = image;
}

-(UIImage *) getImage {
    NSString *path = [self getImagePath];
    if(!path || !mCatchedPicturePath || [mUser.picturePath isEqualToString:mCatchedPicturePath]) {
        mThumbnail = nil;
        mImage = nil;
    }
    
    if(mImage) return mImage;
    
    if(!mUser) return nil;
    
    mCatchedPicturePath = path;
    if(!mCatchedPicturePath) return nil;
    
    mImage = [MesiboInstance loadImage:nil filePath:path maxside:0];
    mThumbnail = [MesiboInstance loadImage:mImage filePath:path maxside:60];
    
    return mImage;
}

-(UIImage *) getThumbnail {
    NSString *path = [self getImagePath];
    if(!path || !mCatchedPicturePath || ![mUser.picturePath isEqualToString:mCatchedPicturePath]) {
        mThumbnail = nil;
        mImage = nil;
    }
    
    if(mThumbnail) return mThumbnail;
    
    [self getImage];
    return mThumbnail;
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

-(void) clearTyping {
    mTypingTs = 0;
}

-(void) setTyping:(MesiboUserProfile *) profile {
    mTypingTs = [MesiboInstance getTimestamp];
    mTypingProfile = profile;
}

-(uint64_t) getTypingTimeout {
    if(0 == mTypingTs)
        return 0;
    
    uint64_t elapsed = [MesiboInstance getTimestamp] - mTypingTs;
    uint64_t timeout = [MesiboInstance getUiOptions].mTypingIndicationTimeMs;
    if(elapsed >= timeout)
        return 0;
    
    return timeout-elapsed;
}

-(MesiboUserProfile *) getTypingProfile {
    return mTypingProfile;
}

-(void) setUserListPosition:(NSIndexPath *) position {
    mUserListPosition = position;
}

-(NSIndexPath *) getUserListPosition {
    return mUserListPosition;
}

-(NSTimer *) getUserListStatusTimer {
    return mUserListTimer;
}

-(void) setUserListStatusTimer:(NSTimer *)timer {
    mUserListTimer = timer;
}

+(UserData *) getUserDataFromParams:(MesiboParams *) params {
    if(!params || !params.profile)
        return nil;
    
    return [UserData getUserDataFromProfile:params.profile];
}

+(UserData *) getUserDataFromProfile:(MesiboUserProfile *) profile {
    if(!profile) return nil;
    
    UserData *d = (UserData *) profile.other;
    if(!d) {
        d = [UserData initialize:profile];
        profile.other = d;
    }
    return d;
}

@end
