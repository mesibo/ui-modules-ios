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
#ifndef __MESIBOUI_H
#define __MESIBOUI_H
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Mesibo/Mesibo.h"
//#import "UITableViewWithReloadCallback.h"

@interface MesiboCell : UITableViewCell {
    
}
@end

@protocol MesiboMessageViewDelegate <NSObject>
@required
- (UITableView *) getMesiboTableView;
- (CGFloat)MesiboTableView:(UITableView *)tableView heightForMessage:(MesiboMessage *)message;
- (MesiboCell *)MesiboTableView:(UITableView *)tableView cellForMessage:(MesiboMessage *)message;
- (MesiboCell *)MesiboTableView:(UITableView *)tableView show:(MesiboMessage *)message;
@optional
@end

@interface MesiboUiOptions : NSObject
@property (nonatomic) UIImage *contactPlaceHolder;
@property (nonatomic) UIImage *messagingBackground;

@property (nonatomic) BOOL useLetterTitleImage;

@property (nonatomic) BOOL enableVoiceCall;
@property (nonatomic) BOOL enableVideoCall;
@property (nonatomic) BOOL enableForward;
@property (nonatomic) BOOL enableSearch;
@property (nonatomic) BOOL enableBackButton;
@property (nonatomic) BOOL enableMessageButton;

@property (copy, nonatomic) NSString *messageListTitle;
@property (copy, nonatomic) NSString *userListTitle;
@property (copy, nonatomic) NSString *createGroupTitle;
@property (copy, nonatomic) NSString *selectContactTitle;
@property (copy, nonatomic) NSString *selectGroupContactsTitle;
@property (copy, nonatomic) NSString *forwardTitle;

@property (copy, nonatomic) NSString *userOnlineIndicationTitle;
@property (copy, nonatomic) NSString *onlineIndicationTitle;
@property (copy, nonatomic) NSString *offlineIndicationTitle;
@property (copy, nonatomic) NSString *connectingIndicationTitle;
@property (copy, nonatomic) NSString *noNetworkIndicationTitle;
@property (copy, nonatomic) NSString *suspendedIndicationTitle;


@property (copy, nonatomic) NSString *emptyUserListMessage;

@property (nonatomic) BOOL showRecentInForward;
@property (nonatomic) BOOL mConvertSmilyToEmoji;

@property (assign, nonatomic) int *mLetterTitleColors;
@property (assign, nonatomic) int mToolbarColor;
@property (assign, nonatomic) int mStatusBarColor;
@property (assign, nonatomic) int mToolbarTextColor;
@property (assign, nonatomic) int mUserListTypingIndicationColor;
@property (assign, nonatomic) int mUserListStatusColor;
@property (assign, nonatomic) int messageBackgroundColorForMe;
@property (assign, nonatomic) int messageBackgroundColorForPeer;
@property (assign, nonatomic) int messagingBackgroundColor;


@property (assign, nonatomic) uint64_t mMaxImageFileSize;
@property (assign, nonatomic) uint64_t mMaxVideoFileSize;

@property (assign, nonatomic) BOOL mEnableNotificationBadge;


@end


@interface MesiboUI : NSObject

+(void) launchEditGroupDetails:(id) parent groupid:(uint32_t) groupid;

+(UIViewController *) getMesiboUIViewController ;
+ (UIViewController *) getMesiboUIViewController:(id)uidelegate;

+(UIImage *) getDefaultImage:(BOOL) group;

+(void) launchMessageViewController:(UIViewController *) parent profile:(MesiboProfile*)profile ;

+(MesiboUiOptions *) getUiOptions;
+(void) setUiOptions:(MesiboUiOptions *)options;

+(void) launchMessageViewController:(UIViewController *) parent profile:(MesiboProfile*)profile uidelegate:(id)uidelegate;

@end


#endif
