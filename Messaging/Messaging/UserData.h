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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Mesibo/Mesibo.h>

@interface UserData : NSObject

//@property (strong,nonatomic) UIImage *userThumbnail;
//@property (strong,nonatomic) UIImage *userImage;
//@property (assign,nonatomic) NSInteger newMessages;
//@property (assign,nonatomic) NSInteger messageStatus;
//@property (assign,nonatomic) u_int64_t mID;

+(UserData *) initialize:(MesiboProfile *) profile;

-(void) setMessage:(uint64_t)messageid time:(NSString*)msgtime status:(int)status deleted:(BOOL)deleted msg:(NSString*)msg;
-(NSString *) getPeer;
-(uint32_t) getGroupId;
-(uint64_t) getMid;
-(void) setMid:(uint64_t) msgid;
-(void) setUser:(MesiboProfile *) profile;
        
-(void) setFixedImage:(BOOL) fixed;
-(int) getUnreadCount;
-(void) setUnreadCount:(int)count;
-(void) clearUnreadCount;
-(int) getMessageStatus;
-(void) setMessageStatus:(int) status;
-(void) setLastMessage:(NSString *) lastMsg;
-(NSString *) getLastMessage;
-(NSString *) getTime;
-(void) setTime:(NSString *) msgTime;
-(NSString *) getName;
-(NSString *) getUserStatus;
-(BOOL)isDeleted;
-(void) setDeleted:(BOOL)deleted;

-(NSString *) getImagePath;
-(void) setThumbnail:(UIImage *) thumbnail;
-(void) setImage:(UIImage *)image;
-(UIImage *) getImage;
-(UIImage *) getThumbnail;
-(UIImage *) getDefaultImage:(BOOL)useTitler ;

-(void) clearTyping;
-(void) setTyping:(MesiboProfile *) profile;
-(BOOL) isTyping;
-(uint64_t) getTypingTimeout;
-(MesiboProfile *) getTypingProfile;
-(void) setUserListPosition:(NSIndexPath *)indexPath;
-(NSIndexPath *) getUserListPosition;

+(UserData *) getUserDataFromParams:(MesiboParams *) params;

+(UserData *) getUserDataFromProfile:(MesiboProfile *) profile;


@end
