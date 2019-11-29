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

#import <UIKit/UIKit.h>
#import "Includes.h"

//#import "MessageData.h"
#import "UITableViewWithReloadCallback.h"
#import "MesiboMessageView.h"

#import "MesiboMessageModel.h"
#import "MesiboTableController.h"

#define SELECTION_NONE      0
#define SELECTION_FORWARD    1
#define SELECTION_DELETE    2


@interface MessageViewController : UIViewController <MesiboDelegate, UITableViewDelegate , UITableViewDataSource , UITextViewDelegate, UIGestureRecognizerDelegate, MesiboTableControllerDelegate, MesiboMessageModelDelegate>

//@property (strong, nonatomic) MesiboMessage * forwardedMesage;

@property (strong, nonatomic) IBOutlet UIButton *mChatBtn;

@property (weak, nonatomic) IBOutlet UITableViewWithReloadCallback *mChatTable;


@property (strong, nonatomic) IBOutlet UIView *mChatView;

@property (strong, nonatomic) IBOutlet UITextView *mChatEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_mChatEdit;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mChatShiftConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_parent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mReplyViewHeight;

//@property (strong, nonatomic) NSString *mChatUser;

//@property (strong,nonatomic) NSString *mProfileFilePath;

@property (strong, nonatomic) MesiboUserProfile* mUser;

//- (void) ImagePickerCallback:(NSString *) imagePath;
//- (void) resend:(id) sender;
//- (void) forward:(id) sender;
//- (void) share:(id) sender;
//- (void) favorite:(id)sender ;
//- (void) reply:(id)sender ;

//-(BOOL) isForwardMode;
//-(void) addSelectedMessage:(UiData *)message;
//-(BOOL) isSelected:(UiData *)message;

@property (weak, nonatomic) IBOutlet UIButton *loadEarlyMessageBtn;

@property (weak, nonatomic) IBOutlet UIButton *mCameraBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mChatBoxWidth;
@property (weak, nonatomic) IBOutlet UIView *contextMenu;
@property (weak, nonatomic) IBOutlet UIView *mContextMenu;
@property (weak, nonatomic) IBOutlet UIButton *mPaneBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mDistanceChatView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mHeightReplyView;
@property (weak, nonatomic) IBOutlet UIView *mReplyLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mReplyVuHeight;
@property (weak, nonatomic) IBOutlet UIView *mReplyView;
@property (weak, nonatomic) IBOutlet UIButton *mReplyViewCancelBtn;

-(void) setTableViewDelegate:(id) tableDelegate;

@end

