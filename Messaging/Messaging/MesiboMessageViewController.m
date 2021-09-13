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

//#import "MesiboUI.h"
#import "Includes.h"
#import "MesiboMessageViewController.h"
#import "UserListViewController.h"
#import <CoreData/CoreData.h>
//#import "MessageData.h"
#include "UIColors.h"
#include "MesiboMessageViewHolder.h"
//#include "ProfileHandler.h"

//#import "ProfileHandler.h"
//#import "ImageViewer.h"
//#import "GradColors.h"
#import "MesiboImage.h"
#import "MesiboCommonUtils.h"
#import "MesiboUIAlerts.h"
#import "TextToEmoji.h"
#import "MesiboUIManager.h"
#import "Includes.h"
//#import "ImagePicker.h"
//#import "MesiboUtils.h"
#import "UITextView+Placeholder.h"
#import "LetterTitleImage.h"
//#import "MesiboModel.h"
#import "MesiboTableController.h"


#define DB_INCOMING 101
#define DB_OUTGOING 102

#define SELECTION_NONE      0
#define SELECTION_FORWARD    1
#define SELECTION_DELETE    2

@interface MessageViewController ()
{
    CGSize  mScreenSize;
    CGFloat mConstrain;
    
    CGFloat mOrgParentHeight;
    CGFloat mKBHeight;
    UILabel *mUserStatusLabel;
    UILabel *mUserNameLabel;
    CGRect showUserStatusFrame;
    CGRect hideUserStatusFrame;
    CGRect mChatBoxframe, mChatBoxExtendedFrame;
    MesiboParams *mMesiboParam;
    NSBundle *ChatBundle;
    BOOL showAttachments;
    BOOL closeMediaPane;
    BOOL mDeletedGroup;
  
    CGRect contextMenuFrame;
    CGRect chatEditFrame;
    UIView *mReplyTextView;
    UIImage *mReplyImageThumb;
    NSString *mReplyUsernameStorage;
    MesiboUiOptions *mMesiboUIOPtions;
    UIButton *mProfileThumbnail;
    UserData *mUserData;
    MesiboUiOptions *mMesiboUIOptions;
    
    NSMutableArray *mUserButtons;
    UIColor *mPrimaryColor;
    
    MesiboMessageModel *mModel;
    
    MesiboTableController *mTableController;
    id mTableDelegate;
    BOOL mSendEnabled;
    
}

@end

@implementation MessageViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    mSendEnabled = YES;
    mModel = nil;
    mMesiboUIOptions = [MesiboUI getUiOptions];
    mPrimaryColor = [UIColor getColor:0xff00868b];
    if(mMesiboUIOptions.mToolbarColor)
        mPrimaryColor = [UIColor getColor:mMesiboUIOptions.mToolbarColor];
    
    mDeletedGroup = NO;
    
    // Do any additional setup after loading the view.

    closeMediaPane = false;
    mReplyUsernameStorage = nil;
    
    mMesiboParam = (MesiboParams *) [[MesiboParams alloc] init];
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    
    if(nil == bundleURL) {
        
        
    }
    
    mMesiboUIOPtions = [MesiboUI getUiOptions];
    
    ChatBundle = [[NSBundle alloc] initWithURL:bundleURL];
    
    _loadEarlyMessageBtn.alpha=1;
    self.navigationItem.backBarButtonItem=nil;
    self.navigationItem.hidesBackButton = YES;
    
    mConstrain = _mChatShiftConstrain.constant;
    
    
    _mChatTable.delegate =self;
    _mChatTable.transform = CGAffineTransformMakeScale (1,-1);
    _mChatEdit.delegate = self;
    
    _mChatTable.dataSource = self;
    
    mModel = [MesiboMessageModel new];
    mTableController = [MesiboTableController new];
    
    [mTableController setup:self tableView:_mChatTable model:mModel delegate:self uidelegate:mTableDelegate];
    

    self.automaticallyAdjustsScrollViewInsets = false;
    
    //_mChatTable.transform = CGAffineTransformMakeScale(1, -1);
    mScreenSize = [UIScreen mainScreen].bounds.size;
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[MesiboImage imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barButtonBackPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, UIBAR_BUTTON_SIZE, UIBAR_BUTTON_SIZE)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    mProfileThumbnail =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    mUserData = [UserData getUserDataFromProfile:_mUser];
    [mUserData setUnreadCount:0];
    
    //UIImage *profImage = [mUserData getThumbnail];
    [self setProfilePicture];
    
    //[mProfileThumbnail setImage:profImage forState:UIControlStateNormal];
    [mProfileThumbnail addTarget:self action:@selector(openProfileImage:)forControlEvents:UIControlEventTouchUpInside];
    [mProfileThumbnail setFrame:CGRectMake(0, 0, PROFILE_THUMBNAIL_IMAGE_NAVBAR, PROFILE_THUMBNAIL_IMAGE_NAVBAR)];
    
    
    mProfileThumbnail.layer.cornerRadius = mProfileThumbnail.layer.frame.size.width/2;
    mProfileThumbnail.layer.borderColor = [UIColor getColor:WHITE_COLOR].CGColor;
    mProfileThumbnail.layer.borderWidth = 0.6;
    mProfileThumbnail.layer.masksToBounds = YES;
    
    
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:mProfileThumbnail];
    
    UIBarButtonItem *spaceBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBtn.width = 10;
    
    self.navigationItem.leftBarButtonItems = @[barButton, /*spaceBtn,*/ barButton1];
    
    NSArray *btnArray = [[MesiboInstance getDelegates] Mesibo_onGetMenu:self type:1 profile:_mUser];
    
    
    mUserButtons = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < [btnArray count]; i++) {
        UIButton *button = [btnArray objectAtIndex:i];
        [button addTarget:self action:@selector(uiBarButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
        [button setFrame:CGRectMake(0, 0, UIBAR_BUTTON_SIZE, UIBAR_BUTTON_SIZE)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [mUserButtons insertObject:barButton atIndex:0];
    }
    self.navigationItem.rightBarButtonItems = mUserButtons;
    
    
    //self.navigationItem.rightBarButtonItems = mForwardButtons;
    
    [_mUser getImage]; // needed?? earlier we were doing startProfilePictureTransfer
    
    NSString *username = [MesiboCommonUtils getUserName:_mUser];
    self.title = username;
    
    [_mChatTable registerClass:[MesiboMessageViewHolder class] forCellReuseIdentifier:MESIBO_CELL_IDENTIFIER ];
    
    _mChatView.backgroundColor = [UIColor getColor:CHAT_INPUTBAR_CLR];
    _mChatView.layer.borderWidth = 0.5;
    _mChatView.layer.borderColor = [UIColor getColor:GRAY_COLOR].CGColor;
    
    _mChatEdit.layer.borderWidth = 0.5;
    _mChatEdit.layer.borderColor = [UIColor getColor:GRAY_COLOR].CGColor;
    _mChatEdit.layer.cornerRadius = 4.0;
    
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:_mChatTable.frame];
    tempImageView.backgroundColor = [UIColor getColor:CHAT_BOX_BACKGROUND_CLR];
    //[_mChatTable addSubview:tempImageView];
    //[_mChatTable sendSubviewToBack:tempImageView];
    _mChatTable.backgroundView = tempImageView;
    
    //_mChatTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat background"]];
    
    //_mChatEdit.delegate = self;
    
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:NAVBAR_TITLE_FONT_SIZE];;
    CGSize size = [username sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    // we use width to calcuate number of lines
    CGSize titleSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_TITLEVIEW_WIDTH, 0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor getColor:NAVIGATION_TITLE_COLOR];
    titleLabel.font = titleFont;
    titleLabel.text = username;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.tag = 21;
    
    [titleLabel sizeToFit];
    
    UIFont *subtitleFont = [UIFont systemFontOfSize:NAVBAR_SUBTITLE_FONT_SIZE];
    size = [username sizeWithAttributes:@{NSFontAttributeName: subtitleFont}];
    CGSize subtitleSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleSize.height, NAVBAR_TITLEVIEW_WIDTH + NAVBAR_TITLEVIEW_WIDTH, 0)];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = [UIColor getColor:NAVIGATION_TITLE_COLOR];;
    subTitleLabel.font = [UIFont systemFontOfSize:NAVBAR_SUBTITLE_FONT_SIZE];
    //dummy neglect the value and do not change
    subTitleLabel.text = @". . . . . dummy connection status . . . . . . ";
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    subTitleLabel.tag = 20;
    [subTitleLabel sizeToFit];
    
    UIView *twoLineTitleView = [[UIView alloc] initWithFrame:CGRectMake(-140, 0, NAVBAR_TITLEVIEW_WIDTH, titleSize.height + subtitleSize.height)];
    twoLineTitleView.clipsToBounds = YES;
    [twoLineTitleView addSubview:titleLabel];
    [twoLineTitleView addSubview:subTitleLabel];
    
    UITapGestureRecognizer *uiTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChatUserProfile)];
    uiTapGestureRecognizer.numberOfTapsRequired = 1;
    [twoLineTitleView addGestureRecognizer:uiTapGestureRecognizer];
    
    self.navigationItem.titleView = twoLineTitleView;
    
    mUserStatusLabel = subTitleLabel;
    mUserNameLabel = titleLabel;
    
    // to set ellipsis glyph in the status (useful for group status which is long)
    mUserStatusLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    mUserStatusLabel.text = mMesiboUIOPtions.connectingIndicationTitle;
    
    showUserStatusFrame = mUserNameLabel.frame;
    CGRect frame = showUserStatusFrame;
    frame.origin.y += NAVBAR_TITLE_FONT_DISPLACEMENT;
    
    hideUserStatusFrame = frame;
    
    mUserNameLabel.frame = hideUserStatusFrame;
    
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    mUserStatusLabel.hidden = YES;
    
    //https://zearfoss.wordpress.com/tag/uiresponderstandardeditactions/
    UIMenuItem *resendMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_RESEND_TITLE action:@selector(resend:)];
    UIMenuItem *forwardMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_FORWARD_TITLE action:@selector(forward:)];
    UIMenuItem *shareMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_SHARE_TITLE action:@selector(share:)];
    UIMenuItem *favoriteMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_FAVORITE_TITLE action:@selector(favorite:)];
    UIMenuItem *replyMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_REPLY_TITLE action:@selector(reply:)];
    
    if(mMesiboUIOPtions.enableForward) {
        [[UIMenuController sharedMenuController] setMenuItems: @[replyMenuItem,resendMenuItem,forwardMenuItem,shareMenuItem,favoriteMenuItem]];
    }else {
        [[UIMenuController sharedMenuController] setMenuItems: @[replyMenuItem,resendMenuItem,shareMenuItem,favoriteMenuItem]];
        
    }
    [[UIMenuController sharedMenuController] update];
    
    _mChatEdit.userInteractionEnabled = YES;
    [_mChatView bringSubviewToFront:_mChatEdit];
    
    _mContextMenu.hidden = YES;
    //_mChatEdit.text = CHATBOX_PLACE_HOLDER_TEXT;
    //_mChatEdit.textColor = [UIColor lightGrayColor]; //optional
    
    //UITextView has no placeholder like UITextField so we are using category class
#ifdef USE_PLACEHOLDER
    _mChatEdit.placeholder = CHATBOX_PLACE_HOLDER_TEXT;
    _mChatEdit.placeholderColor = [UIColor lightGrayColor]; //optional
#endif
    _mChatEdit.text = @""; // so that placeholder visible

#if 0
    _mUser.unread = 0;
#endif
    
    _mReplyView.layer.cornerRadius = REPLY_VIEW_CORNER_RADIUS;
    _mReplyView.layer.masksToBounds = YES;
    
    
    if(mDeletedGroup) {
        _mChatView.hidden = YES;
    }
    
    showAttachments = [MesiboInstance isFileTransferEnabled];
    
    if(!showAttachments) {
        _mAttachButton.hidden = YES;
        _mPaneBtn.hidden = YES;
        _mCameraBtn.hidden = YES;
        _mChatEdit.translatesAutoresizingMaskIntoConstraints = YES;
        _mChatEdit.frame = _mChatEdit.frame = CGRectMake(10, _mChatEdit.frame.origin.y, _mChatEdit.frame.size.width + _mPaneBtn.frame.size.width, _mChatEdit.frame.size.height);
    }
    
    [self onLogin:nil];
    [self updateUserActivity:nil activity:MESIBO_ACTIVITY_NONE];
}

-(void) setTableViewDelegate:(id) tableDelegate {
    mTableDelegate = tableDelegate;
}

-(MesiboTableController *) getTableController {
    return mTableController;
}

- (void) share:(NSString *) text image:(UIImage *)image {
    
}

-(void) forwardMessages:(NSArray *)msgids {
    
    [MesiboUIManager launchUserListViewcontroller:self  withChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"] withContactChooser:USERLIST_FORWARD_MODE withForwardMessageData:msgids withMembersList:nil withForwardGroupName:nil withForwardGroupid:0];
}

-(void) enableSelectionActionButtons:(BOOL)enable buttons:(NSArray *) buttons {
    
    if(enable)
        self.navigationItem.rightBarButtonItems = buttons;
    else
        self.navigationItem.rightBarButtonItems = mUserButtons;
    
    [self closeContextMenu];
}



- (void)sendPresence :(int) presence {
    if(!mSendEnabled)
        return;
    
    uint32_t msgid = 0;

    [MesiboInstance sendActivity:mMesiboParam msgid:msgid activity:presence interval:10000];
}



-(BOOL) loadMessages {
    [mModel loadMessages:MESIBO_READ_MESSAGES];
    return YES;
}


- (void) uiBarButtonPressed: (id) sender {
    int tag = (int) [(UIBarButtonItem*)sender tag];
    [[MesiboInstance getDelegates] Mesibo_onMenuItemSelected:self type:1 profile:_mUser item:tag];
}


- (void) showChatUserProfile  {
    [[MesiboInstance getDelegates] Mesibo_onShowProfile:self profile:_mUser];
}

- (void) openProfileImage:(UITapGestureRecognizer *)sender{
    
    NSString *picturePath = [_mUser getImageOrThumbnailPath];
    
    if(picturePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:picturePath];
        [MesiboUIManager showImageInViewer:self withImage:image withTitle:[MesiboCommonUtils getUserName:_mUser]];
    }
}

- (IBAction)loadEarlierMessagesFromDatabase:(id)sender {
    _loadEarlyMessageBtn.alpha = 0;
}


- (IBAction)onLogin:(id)sender {
    
    if([_mUser getGroupId])
        [mMesiboParam setGroup:[_mUser getGroupId]];
    else
        [mMesiboParam setPeer:[_mUser getAddress]];

    [mModel reset];
    [mModel setDelegate:self];
    [mModel enableReadReceipt:YES];
    [mModel enableCallLogs:YES];
    [mModel enableMessages:YES];
    [mModel setDestination:mMesiboParam];
    [mModel start];
    [self loadMessages];
    
    if(![_mUser getGroupId])
        [self sendPresence:MESIBO_ACTIVITY_JOINED];
}

-(void) setProfilePicture {
    UIImage *image = [mUserData getThumbnail];
    if(!image) {
        image = [mUserData getDefaultImage:mMesiboUIOptions.useLetterTitleImage];
    }
    
    image = [MesiboInstance loadImage:image filePath:nil maxside:PROFILE_THUMBNAIL_IMAGE_NAVBAR];
    [mProfileThumbnail setImage:image forState:UIControlStateNormal];
}



-(void) updateUserStatusBlank {
    
    
    mUserStatusLabel.hidden = YES;
    
    [UIView animateWithDuration:0.2
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         mUserNameLabel.frame = hideUserStatusFrame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

-(int) updateUserStatus :(NSString *)status duration:(long)duration {
    
    
    if(!status) {
        //TBD, add groupstatus
        if(![_mUser getGroupId] || ![_mUser getStatus])
            [self updateUserStatusBlank];
        else
            [self updateUserStatus:[_mUser getStatus] duration:0];
        return 0;
        
    }
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         mUserNameLabel.frame = showUserStatusFrame;
                     }
                     completion:^(BOOL finished){
                         
                         mUserStatusLabel.hidden = NO;
                         mUserStatusLabel.text = status;
                         
                     }];
    
    
    return 0;
    
}

-(int) updateUserActivity:(MesiboParams *)params activity:(int) activity {
    int connectionStatus = [MesiboInstance getConnectionStatus];
    
    if(MESIBO_STATUS_CONNECTING == connectionStatus) {
        return [self updateUserStatus:mMesiboUIOPtions.connectingIndicationTitle duration:0];
    }
    if(MESIBO_STATUS_NONETWORK == connectionStatus) {
        return [self updateUserStatus:mMesiboUIOPtions.noNetworkIndicationTitle duration:0];
    }
    if(MESIBO_STATUS_SUSPEND == connectionStatus) {
        return [self updateUserStatus:mMesiboUIOPtions.suspendedIndicationTitle duration:0];
    }
    if(MESIBO_STATUS_CONNECTFAILURE == connectionStatus) {
        return [self updateUserStatus:mMesiboUIOPtions.offlineIndicationTitle duration:0];
    }
    if(MESIBO_STATUS_ONLINE != connectionStatus) {
        return [self updateUserStatus:mMesiboUIOPtions.offlineIndicationTitle duration:0];
    }
    
    
    NSString *status = nil;
    MesiboProfile *profile = _mUser;
    uint32_t groupid = 0;
    if(params) {
        groupid = params.groupid;
        if(params.profile) profile = params.profile;
    }
    
    if([profile isTypingInGroup:groupid]) {
        [mUserData setTyping:nil];
        status = STATUS_TYPING;
        if(params && params.groupid && params.profile) {
            NSString *name = [profile getName];
            if(!name)
                name = [params.profile getAddress];
            status = [NSString stringWithFormat:@"%@ is %@", name, STATUS_TYPING];
        }
    } else if(groupid && [profile isChatting]) {
        status = STATUS_TYPING;
    } else if(groupid && [profile isOnline]) {
        status = mMesiboUIOPtions.userOnlineIndicationTitle;
    }
    
    return [self updateUserStatus:status duration:0];
}



-(void) barButtonBackPressed:(id)sender {
    if([mTableController cancelSelectionMode])
        return;
    
    if(mModel) {
        [mModel stop];
    }
    
    if(!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    mOrgParentHeight = _height_parent.constant;
    
    contextMenuFrame = _mContextMenu.frame;
    
    chatEditFrame = _mChatEdit.frame;
    _mContextMenu.hidden = NO;
    
    [MesiboInstance setAppInForeground:self screenId:1 foreground:YES];
    if(mModel) {
        [mModel start];
    }

}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
    
    _mContextMenu.alpha = 0;
    if(![_mUser getGroupId])
        [self sendPresence:MESIBO_ACTIVITY_LEFT];
    
    if(mModel) {
        [mModel stop];
    }
    
    
}

-(void)screenLock:(NSNotification *)notification {
    [MesiboInstance setAppInForeground:self screenId:1 foreground:YES];
    if(mModel) {
        [mModel start];
    }
}

-(void)screenUnlock:(NSNotification *)notification {
    if(![_mUser getGroupId])
        [self sendPresence:MESIBO_ACTIVITY_LEFT];
    
    if(mModel) {
        [mModel stop];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    mUserNameLabel.text = [MesiboCommonUtils getUserName:_mUser];
    
    UIImage *updatedImage = nil;
    NSString *picturePath = [_mUser getImageOrThumbnailPath];
    
    if(picturePath) {
        updatedImage = [UIImage imageWithContentsOfFile:picturePath];
        
    }
    
    UserData *ud = [UserData getUserDataFromProfile:_mUser];
    
    if(nil == updatedImage)
        updatedImage = [ud getThumbnail];
    
    if(nil != updatedImage) {
        [ud setThumbnail:updatedImage];
        [self setProfilePicture];
    }
    
    
    [MesiboCommonUtils setNavigationBarColor:self.navigationController.navigationBar color:mPrimaryColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenLock:) name:UIApplicationProtectedDataDidBecomeAvailable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenUnlock:) name:UIApplicationProtectedDataWillBecomeUnavailable object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:YES]; // to pass tap to other views
    [self.view addGestureRecognizer:tap];
    
    if(_mUser != nil) {
        
        if(![[_mUser getDraft] isEqualToString:@""] && [_mUser getDraft] !=nil) {
            
            _mChatEdit.text=[_mUser getDraft];
            _mChatEdit.textColor = [UIColor blackColor];
            
        }
        
        
    }
    if([_mChatEdit.text length] > 0) {
        _mCameraBtn.hidden=YES;
        
    }
    
    _mContextMenu.alpha = 1;
    
}


- (void) viewDidLayoutSubviews {
    
    [mTableController scrollToBottom:NO];
    
    mChatBoxframe = _mChatEdit.frame;
    mChatBoxExtendedFrame = mChatBoxframe;
    mChatBoxExtendedFrame.size.width +=40;
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if(_mUser != nil) {
        
        if(![_mChatEdit.text isEqualToString:CHATBOX_PLACE_HOLDER_TEXT]) {
            
            _mUser.draft = _mChatEdit.text;
        }
        
        
    }
    _mContextMenu.alpha = 0;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) Mesibo_onFileTransferProgress:(MesiboFileInfo *)file {
    if([file isTransferred]) {
        
    }
    return YES;
}

-(UIAlertAction *) addAlert:(UIAlertController *)view title:(NSString *)title type:(int) filetype {
    return [UIAlertAction
            actionWithTitle:title
            style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action)
            {
                if(filetype >= 0)
                    [self pickMediaWithFiletype:filetype];
                
                [self closeContextMenu];
                [view dismissViewControllerAnimated:YES completion:nil];
            }];
}




- (void) openImagePickerUI {
    ImagePicker *im = [ImagePicker sharedInstance];
    im.mParent = self;
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:PICKER_ALERT_TITLE
                                 message:PICKER_ALERT_MESSAGE
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* camera = [self addAlert:view title:PICKER_ALERT_CAMERA_TITLE type:PICK_CAMERA_IMAGE];
    UIAlertAction* Image = [self addAlert:view title:PICKER_ALERT_GALLERY_TITLE type:PICK_VIDEO_GALLERY];
    UIAlertAction* location = [self addAlert:view title:PICKER_ALERT_LOCATION_TITLE type:PICK_LOCATION];
    UIAlertAction* audio = [self addAlert:view title:PICKER_ALERT_AUDIO_TITLE type:PICK_AUDIO_FILES];
    UIAlertAction* files = [self addAlert:view title:PICKER_ALERT_FILES_TITLE type:PICK_DOCUMENTS];
    UIAlertAction* cancel = [self addAlert:view title:PICKER_ALERT_CANCEL_TITLE type:-1];
    
    
    [view addAction:camera];
    [view addAction:Image];
    [view addAction:location];
    [view addAction:audio];
    [view addAction:files];
    
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    
}



- (void) pickMediaWithFiletype :(int)filetype{
    ImagePicker *im = [ImagePicker sharedInstance];
    im.mParent = self;
    [MesiboUIManager pickImageData:im withParent:self withMediaType:filetype withBlockHandler:^(ImagePickerFile *picker) {
        
        
        NSLog(@"Returned data %@", [picker description]);
        
        [self applicationFileTypeMapping:picker];
        
        
        if(picker.fileType == MESIBO_FILETYPE_LOCATION) {
            [self insertMessage:picker];
        }else  {
            
            BOOL hdControl = YES ;
            
            if(picker.fileType == MESIBO_FILETYPE_IMAGE)
                hdControl = NO;
            
            
            [MesiboUIManager launchImageEditor:im withParent:self withImage:picker.image title:nil hideEditControls:hdControl showCaption:YES showCropOverlay:NO squareCrop:NO maxDimension:1280  withBlock:^BOOL(UIImage *image, NSString *caption) {
                picker.message = caption;
                picker.image = image;
                
                [self insertMessage:picker];
                
                NSLog(@"message data %@",caption);
                return YES;
                
            }];
            
            
        }
        
        _mChatEdit.text = @"";
        _height_parent.constant = mOrgParentHeight;
        
    }];
    
}
- (void) applicationFileTypeMapping : (ImagePickerFile *)file{
    
    if(file.fileType == PICK_LOCATION) {
        file.fileType = MESIBO_FILETYPE_LOCATION;
        return;
    } else if (file.fileType == PICK_CAMERA_IMAGE || file.fileType == PICK_FACEBOOK_IMAGES || file.fileType == PICK_IMAGE_GALLERY || file.fileType == PICK_VIDEO_GALLERY || file.fileType == PICK_VIDEO_RECORDING){
        if (file.filePath != nil)
            file.fileType = MESIBO_FILETYPE_VIDEO;
        else
            file.fileType = MESIBO_FILETYPE_IMAGE;
        return;
    }else if (file.fileType == PICK_DOCUMENTS  ){
        file.fileType = MESIBO_FILETYPE_AUTO;
        return;
    }else if (file.fileType == PICK_AUDIO_FILES  ){
        file.fileType = MESIBO_FILETYPE_AUDIO;
        return;
    }
    return;
    
}

- (IBAction)cancelReplyView:(id)sender {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            //Animations
                            _height_parent.constant = _height_parent.constant - _mReplyVuHeight.constant;
                            _mReplyVuHeight.constant=0;
                            [_mChatView layoutIfNeeded];
                            
                        }
                     completion:^(BOOL finished) {
                         //mReplyTextView = nil;
                         [mReplyTextView removeFromSuperview];
                         UIView *removeView = [_mReplyView viewWithTag:200];
                         [removeView removeFromSuperview];
                         
                     }];
}

- (MesiboMessage *) insertTextMessage:(NSString *)message   {
    
    MesiboMessage *m = [MesiboMessage new];
    m.mid = [MesiboInstance random];
    m.ts = [MesiboInstance getTimestamp];
    [m setStatus:MESIBO_MSGSTATUS_OUTBOX];
    [m setOrigin:MESIBO_ORIGIN_REALTIME];
    m.message = [message dataUsingEncoding:NSUTF8StringEncoding];
    [mModel insert:m];
    [mTableController insert:m];
    
    if(mReplyTextView)
        [self cancelReplyView:nil];
    
    return m;
    
}


- (MesiboMessage *) insertMessage:(ImagePickerFile * )picker {
    
    MesiboMessage *m = [MesiboMessage new];
    m.mid = [MesiboInstance random];
    m.ts = [MesiboInstance getTimestamp];
    [m setStatus:MESIBO_MSGSTATUS_OUTBOX];
    [m setOrigin:MESIBO_ORIGIN_REALTIME];

    if(picker.fileType==MESIBO_FILETYPE_LOCATION) {
        
        MesiboLocation *ml = [[MesiboLocation alloc] init];
        ml.mid= m.mid;
        ml.message = picker.message;
        ml.title = picker.title;
        ml.lat = picker.lat;
        ml.lon = picker.lon;
        ml.url = picker.url;
        ml.image = nil; // nil will enable viewholder to set default image and initiate update location image
        
        [m setLocation:ml];
        [mModel insert:m];
        [mTableController insert:m];
        
        if(MESIBO_RESULT_OK != [MesiboInstance sendLocation:mMesiboParam msgid:(u_int32_t)m.mid location:ml]){
            [self markSendingFailed:0 status:MESIBO_MSGSTATUS_FAIL mids:(uint32_t)m.mid];
        }
        
    }else {
        
        MesiboFileInfo *mf = [MesiboInstance getFileInstance:mMesiboParam msgid:m.mid mode:MESIBO_FILEMODE_UPLOAD type:picker.fileType source:MESIBO_FILESOURCE_MESSAGE filePath:picker.mp4Path?picker.mp4Path:picker.filePath url:nil listener:self];
        
        mf.mid= m.mid;
        mf.message = picker.message;
        mf.image = picker.image;
        mf.asset = picker.phasset;
        mf.localIdentifier = picker.localIdentifier;
        mf.userInteraction = YES;
        
        [m setFile:mf];
    
        [mModel insert:m];
        [mTableController insert:m];
        
        if(!picker.mp4Path) {
            
            if(MESIBO_RESULT_OK != [MesiboInstance sendFile:mMesiboParam msgid:(u_int32_t)m.mid file:mf]){
                [self markSendingFailed:0 status:MESIBO_MSGSTATUS_FAIL mids:(uint32_t)m.mid];
                [mModel Mesibo_onFileTransferProgress:mf];
            } 
        } else {
            mf.localIdentifier = nil;
            mf.asset = nil;
            
            [picker setMp4TranscodingHandler:^(ImagePickerFile *mf1) {
                if(MESIBO_RESULT_OK != [MesiboInstance sendFile:mMesiboParam msgid:(u_int32_t)m.mid file:mf]){
                    [self markSendingFailed:0 status:MESIBO_MSGSTATUS_FAIL mids:(uint32_t)m.mid];
                }
            }];
        }
    }
    
   
    return m;
    
}

-(void)markSendingFailed:(int) channel status:(int)status mids:(uint32_t)mid {
    [mModel setMessageStatus:mid status:status];
   
}

- (IBAction)sendChatAction:(id)sender {
    
    NSString *message = [_mChatEdit.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(![message length])
        return;
    
    
    
    for (NSString *emojiKey in [[TextToEmoji getInstance] getEmojiTextStrings]){
        if ([message containsString:emojiKey]){
            NSString *smiley = [[TextToEmoji getInstance] getEmojiValueForString:emojiKey];
            message = [message stringByReplacingOccurrencesOfString:emojiKey withString:smiley];
        }
    }
    
    MesiboMessage *m = [self insertTextMessage:message];
    
    if(MESIBO_RESULT_OK != [MesiboInstance sendMessage:(MesiboParams *) mMesiboParam msgid:(uint32_t)m.mid string:message]){
        [self markSendingFailed:0 status:MESIBO_MSGSTATUS_FAIL mids:(uint32_t)m.mid];
    }
       
    _mChatEdit.text = @"";
    
    if(_mUser != nil  ) {
        if(![[_mUser getDraft] isEqualToString:@""]){
            _mUser.draft = @"";
        }
    }
    _height_parent.constant = mOrgParentHeight;
    
    if(showAttachments)
        _mCameraBtn.hidden=NO;
    
    
}










#pragma mark - Table view data source

-(void) scrollViewDidScroll:(UIScrollView *)scrollView  {
    [mTableController scrollViewDidScroll:scrollView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [mTableController numberOfSectionsInTableView:tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mTableController tableView:tableView numberOfRowsInSection:section];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [mTableController tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void) tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [mTableController tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [mTableController tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [mTableController tableView:tableView cellForRowAtIndexPath:indexPath];
}



#pragma mark - UITableViewDelegate


#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    [self setCloseMediaPaneValue:false];
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    
    
    mKBHeight =keyboardFrameConverted.size.height;
    _mChatShiftConstrain.constant = mConstrain  + mKBHeight;
    //[self updateViewConstraints];
    [self.view invalidateIntrinsicContentSize];
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        //[self scrollToLatestChat:YES];
        
        
    }];
    [self animateTextView];
    
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _mChatShiftConstrain.constant = mConstrain;
        
        [self.view layoutIfNeeded];
        
    }];
    
    if(![_mChatEdit.text length])
        _mCameraBtn.hidden = NO;
    
    [self setCloseMediaPaneValue:false];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:CHATBOX_PLACE_HOLDER_TEXT]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    
    [self closeContextMenu];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_mChatView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
    }
    
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
#ifdef USE_PLACEHOLDER
    textField.placeholder = CHATBOX_PLACE_HOLDER_TEXT;
#endif
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_mChatEdit resignFirstResponder];
    
    return YES;
}

- (BOOL)dismissKeyboard
{
    if([_mChatEdit isFirstResponder])
        [_mChatEdit resignFirstResponder];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    
    if(closeMediaPane) {
        [self closeContextMenu];
    }
    if(!textView.text.length) {
        _mCameraBtn.hidden=NO;
    }else {
        _mCameraBtn.hidden=YES;
        [self sendPresence:MESIBO_ACTIVITY_TYPING];
    }
    
    [self animateTextView];
}

- (void) animateTextView {
    
    CGFloat height = height = ceil(_mChatEdit.contentSize.height)-2;
    
    if (height < MIN_TEXT_VIEW_HEIGHT ) { // min cap, + 5 to avoid tiny height difference at min height
        height = MIN_TEXT_VIEW_HEIGHT;
    }
    if (height > MAX_TEXT_VIEW_HEIGHT) { // max cap
        height = MAX_TEXT_VIEW_HEIGHT;
    }
    
    height = height - MIN_TEXT_VIEW_HEIGHT;
    if(height) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        _height_parent.constant = mOrgParentHeight + _mReplyVuHeight.constant + height  ;
        
        [UIView commitAnimations];
    } else
        _height_parent.constant = mOrgParentHeight + _mReplyVuHeight.constant ;
    
}

- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [mTableController tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
}


- (BOOL) tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    
    return [mTableController tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
}


- (void) tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    //required
}

#define CGRectSetWidth(rect, w)    CGRectMake(rect.origin.x, rect.origin.y, w, rect.size.height)
#define ViewSetWidth(view, w)   view.frame = CGRectSetWidth(view.frame, w)
- (void) closeContextMenu {
    //closeMediaPane = false;
    [self setCloseMediaPaneValue:false];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //_mContextMenu.frame = CGRectMake(contextMenuFrame.origin.x,_mContextMenu.frame.origin.y,_mContextMenu.frame.size.width,_mContextMenu.frame.size.height);
    
    //_mChatEdit.frame = CGRectMake(chatEditFrame.origin.x,_mChatEdit.frame.origin.y,chatEditFrame.size.width,_mChatEdit.frame.size.height);
    
    _mContextMenu.frame = contextMenuFrame;
    _mChatEdit.frame = chatEditFrame;
    
    [UIView commitAnimations];
    
}

- (IBAction)openContexMenu:(id)sender {
    if(! closeMediaPane) {
        //closeMediaPane = true;
        [self setCloseMediaPaneValue:true];
        
            
        CGFloat shift = _mContextMenu.frame.size.width-CGRectGetMaxX(_mContextMenu.frame);
        
        _mChatEdit.translatesAutoresizingMaskIntoConstraints = YES;
        _mContextMenu.translatesAutoresizingMaskIntoConstraints = YES;
        
        
        [UIView animateWithDuration:0.7
                              delay:0.0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                //Animations
                                _mContextMenu.frame = CGRectMake(0, _mContextMenu.frame.origin.y, _mContextMenu.frame.size.width, _mContextMenu.frame.size.height);
                                
                                _mChatEdit.frame = CGRectMake(_mContextMenu.frame.size.width+10, _mChatEdit.frame.origin.y, _mChatEdit.frame.size.width - _mContextMenu.frame.size.width, _mChatEdit.frame.size.height);
                                
                            }
                         completion:^(BOOL finished) {
                             
                         }];
        
    } else {
        [self closeContextMenu];
        
    }
    
    
}


- (IBAction)captureImage:(id)sender {
    [self pickMediaWithFiletype:PICK_CAMERA_IMAGE];
    
}

- (void) setCloseMediaPaneValue : (BOOL) boolValue {
    closeMediaPane = boolValue;
    _mPaneBtn.alpha = (boolValue) ? 0:1;
    
}
- (IBAction)openMoreOption:(id)sender {
    [self closeContextMenu];
    [self openImagePickerUI];
    
}

- (IBAction)openMusicLibrary:(id)sender {
    [self closeContextMenu];
    [self pickMediaWithFiletype:PICK_AUDIO_FILES];
    
}

- (IBAction)attachDocuments:(id)sender {
    [self closeContextMenu];
    [self pickMediaWithFiletype:PICK_DOCUMENTS];
    
}

- (IBAction)sendocationDetails:(id)sender {
    [self closeContextMenu];
    [self pickMediaWithFiletype:PICK_LOCATION];
    
}

- (IBAction)sendPhotoVideo:(id)sender {
    [self closeContextMenu];
    [self pickMediaWithFiletype:PICK_VIDEO_GALLERY];
    
}/*
  - (BOOL)canBecomeFirstResponder {
  return YES;
  }*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"TOUCHED"); // never happens
    for (UITouch *touch in touches) {
        if ( [touch view] != _mChatEdit) {
            
        }else {
            if(!closeMediaPane)
                [self closeContextMenu];
            
        }
        
    }
}


- (void)reply:(id)sender {
    MesiboMessageViewHolder *cell = sender;
    
    MesiboMessageView *m = [cell getMessage];
    MesiboMessage *mm = [m getMesiboMessage];
    
    mReplyImageThumb = nil;
    
    [UIView
     animateWithDuration:0.5
     
     animations:^{
         [mReplyTextView removeFromSuperview];
         _height_parent.constant = _height_parent.constant - _mReplyVuHeight.constant;
         _mReplyVuHeight.constant=0;
     }
     
     completion:^(BOOL finished) {
         
         if([mm isIncoming ])
             mReplyUsernameStorage = [mm getSenderName];
         else
             mReplyUsernameStorage = YOU_STRING_REPLY_VIEW;
         
         if([mm hasMedia]) {
             if(mm.media.file != nil)
                 mReplyImageThumb = mm.media.file.image ;
             if(mm.media.location != nil)
                 mReplyImageThumb = mm.media.location.image ;
             
             [self fillReplyView:mReplyImageThumb withNibName:REPLY_VIEW_WITH_IMAGE_NIB_NAME wihtUserName:mReplyUsernameStorage withMessage:[m getMessage]];
             
         }else {
             [self fillReplyView:mReplyImageThumb withNibName:REPLY_VIEW_NIB_NAME wihtUserName:mReplyUsernameStorage withMessage:[m getMessage]];
             
         }
         
         
         
         [UIView animateWithDuration:0.5
                               delay:0.0
              usingSpringWithDamping:0.9
               initialSpringVelocity:0.9
                             options:UIViewAnimationOptionCurveLinear animations:^{
                                 //Animations
                                 
                                 _mReplyVuHeight.constant=mReplyTextView.frame.size.height;
                                 _height_parent.constant = _height_parent.constant + mReplyTextView.frame.size.height;
                                 
                                 if(nil != mReplyTextView) {
                                     
                                     [_mReplyView addSubview: mReplyTextView];
                                     [_mReplyView bringSubviewToFront:_mReplyViewCancelBtn];
                                     
                                 }
                                 [_mChatView layoutIfNeeded];
                                 
                             }
                          completion:^(BOOL finished) {
                              
                          }];
         
     }];
    
    
    
    
}




-(void) fillReplyView:(UIImage *)imagetumb withNibName:(NSString *)nibName wihtUserName:(NSString *)name withMessage:(NSString *)message {
    
    mReplyTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mReplyView.frame.size.width, 100)];
    mReplyTextView = [[ChatBundle loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
    mReplyTextView.frame = CGRectMake(0, 0, _mReplyView.frame.size.width, 10);
    [mReplyTextView setNeedsLayout];
    [mReplyTextView layoutIfNeeded];
    UILabel *namelabel = [mReplyTextView viewWithTag:100];
    if(nil != name)
        namelabel.text = name;
    else
        namelabel.text = UNKOWN_USER_STRING;
    
    UILabel *messagelabel = [mReplyTextView viewWithTag:101];
    if(nil != message)
        messagelabel.text = message;
    else
        messagelabel.text = @" ";
    
    [messagelabel sizeToFit];
    [messagelabel layoutIfNeeded];
    [mReplyTextView layoutIfNeeded];
    
    // 5 is height margin
    CGFloat height = REPLYVIEW_HEIGHT_PADDING_INTERNAL + CGRectGetMaxY(messagelabel.frame);
    
    UIImageView *imageView = [mReplyTextView viewWithTag:102];
    
    if(nil != imageView) {
        if(nil != imagetumb)
            imageView.image = imagetumb;
        else
            imageView.image = nil;
        //imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, height);
    }
    
    mReplyTextView.frame = CGRectMake(0, 0, mReplyTextView.frame.size.width, height);
    
}

- (void) scrollToBottom:(BOOL)animated {
    [mTableController scrollToBottom:animated];
}

- (void) scrollToLatestChat:(BOOL)animated {
    [mTableController scrollToLatestChat:animated];
}

- (void) reloadTable:(BOOL)scrollToLatest {
    [mTableController reloadTable:scrollToLatest];
}

- (void) reloadRow:(NSInteger)row {
    [mTableController reloadRow:row];
}

- (void) reloadRows:(NSArray *)rows {
    [mTableController reloadRows:rows];
}

-(void) reloadRows:(NSInteger)start end:(NSInteger)end {
    [mTableController reloadRows:start end:end];
}

- (void) insertRow:(NSInteger)row {
    //[mTableController reloadMessage:m];
    [mTableController insertInTable:row section:0 showLatest:YES animate:YES];
}

- (void) onMessageStatus:(int)status {
    if(MESIBO_MSGSTATUS_INVALIDDEST == status && [_mUser getGroupId] > 0) {
        _mChatView.hidden = YES;
        //TBD, this is not a right way
        //[[MesiboInstance getDelegates] Mesibo_onUpdateUserProfiles:_mUser];
        [self updateUserStatus:nil duration:0];
        mSendEnabled = NO;
        NSLog(@"updated deleted profile");
    }
}

- (void) onPresence:(int)presence {
    [self updateUserActivity:nil activity:presence];
}

- (void) onProfileUpdate {
    [self setProfilePicture];
}

- (void) onShutdown {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
