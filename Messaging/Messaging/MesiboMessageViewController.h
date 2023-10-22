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

#import <UIKit/UIKit.h>
#import "Includes.h"
#import "MesiboUI.h"
#import "UITableViewWithReloadCallback.h"
#import "MessageData.h"

#import "MesiboMessageModel.h"
#import "MesiboTableController.h"

#define SELECTION_NONE      0
#define SELECTION_FORWARD    1
#define SELECTION_DELETE    2


@interface MessageViewController : UIViewController <MesiboDelegate, UITableViewDelegate , UITableViewDataSource , UITextViewDelegate, UIGestureRecognizerDelegate, MesiboTableControllerDelegate, MesiboMessageModelDelegate>

//@property (strong, nonatomic) MesiboMessage * forwardedMesage;

@property (strong, nonatomic) IBOutlet UIButton *mChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *mSendBtn;

@property (weak, nonatomic) IBOutlet UITableViewWithReloadCallback *mChatTable;

@property (weak, nonatomic) IBOutlet UIButton *mAttachButton;
@property (weak, nonatomic) IBOutlet UIButton *mPanelMusicButton;

@property (weak, nonatomic) IBOutlet UIButton *mPanelDocButton;
@property (weak, nonatomic) IBOutlet UIButton *mPanelLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *mPanelMediaButton;

@property (strong, nonatomic) IBOutlet UIView *mChatView;

@property (strong, nonatomic) IBOutlet UITextView *mChatEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_mChatEdit;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mChatShiftConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_parent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mReplyViewHeight;

//@property (strong, nonatomic) NSString *mChatUser;

//@property (strong,nonatomic) NSString *mProfileFilePath;

@property (strong, nonatomic) MesiboProfile* mUser;
@property (nonatomic) BOOL mDismissOnBackPressed;

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

@property (strong, nonatomic) MesiboMessageScreenOptions *mOpts;

-(void) setTableViewDelegate:(id<MesiboUIListener>) tableDelegate;
-(MesiboTableController *) getTableController;
@end

