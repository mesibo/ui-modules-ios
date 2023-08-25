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

//#import "MesiboUI.h"
#import "Includes.h"
#import "MesiboMessageViewController.h"
#import "UserListViewController.h"
#import <CoreData/CoreData.h>
#include "UIColors.h"
#include "MesiboMessageViewHolder.h"

#import "MesiboImage.h"
#import "MesiboCommonUtils.h"
#import "MesiboUIAlerts.h"
#import "MesiboUIManager.h"
#import "Includes.h"
//#import "ImagePicker.h"
//#import "MesiboUtils.h"
#ifdef USE_PLACEHOLDER
#import "UITextView+Placeholder.h"
#endif
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
    CGRect showUserStatusFrame;
    CGRect hideUserStatusFrame;
    CGRect mChatBoxframe, mChatBoxExtendedFrame;
    MesiboMessageProperties *mMesiboParam;
    NSBundle *ChatBundle;
    BOOL showAttachments;
    BOOL closeMediaPane;
    
    CGRect contextMenuFrame;
    CGRect chatEditFrame;
    UIView *mReplyTextView;
    UIImage *mReplyImageThumb;
    NSString *mReplyUsernameStorage;
    MesiboMessage *mReplyMessage;
    
    UIButton *mProfileThumbnail;
    UserData *mUserData;
    MesiboUiDefaults *mMesiboUIOptions;
    
    NSMutableArray *mUserButtons;
    UIColor *mPrimaryColor;
    
    MesiboMessageModel *mModel;
    
    MesiboTableController *mTableController;
    id<MesiboUIListener> mTableDelegate;
    BOOL mSendEnabled;
    BOOL mViewActive;
    
    MesiboMessageScreen *mScreen;
    
    __weak UIImageView *_profileImageView;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
    }
    
    mScreen = [MesiboMessageScreen new];
    mScreen.parent = self;
    mScreen.options = _mOpts;
    
    _profileImageView = nil;
    mViewActive = NO;
    mSendEnabled = YES;
    mModel = nil;
    mMesiboUIOptions = [MesiboUI getUiDefaults];
    mPrimaryColor = [UIColor getColor:0xff00868b];
    if(mMesiboUIOptions.mToolbarColor)
        mPrimaryColor = [UIColor getColor:mMesiboUIOptions.mToolbarColor];
    
    
    closeMediaPane = false;
    mReplyUsernameStorage = nil;
    mReplyMessage = nil;
    
    mMesiboParam = (MesiboMessageProperties *) [[MesiboMessageProperties alloc] init];
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    
    
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
    
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    mScreenSize = [UIScreen mainScreen].bounds.size;
    
    CGRect leftframe;
    leftframe.size.height = 50;
    leftframe.size.width = 100;
    leftframe.origin.x = 0;
    leftframe.origin.y = 0;
    UIView *leftview = [[UIView alloc] initWithFrame:leftframe];
    
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[MesiboImage imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barButtonBackPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, UIBAR_BUTTON_SIZE, UIBAR_BUTTON_SIZE)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [leftview addSubview:button];
    
    mProfileThumbnail =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    mUserData = [UserData getUserDataFromProfile:_mUser];
    
    [self setProfilePicture];

    [mProfileThumbnail addTarget:self action:@selector(openProfileImage:)forControlEvents:UIControlEventTouchUpInside];
    
    [mProfileThumbnail setFrame:CGRectMake(0, 0, PROFILE_THUMBNAIL_IMAGE_NAVBAR, PROFILE_THUMBNAIL_IMAGE_NAVBAR)];
    
    
    mProfileThumbnail.layer.cornerRadius = mProfileThumbnail.layer.frame.size.width/2;
    mProfileThumbnail.layer.borderColor = [UIColor getColor:WHITE_COLOR].CGColor;
    mProfileThumbnail.layer.borderWidth = 0.6;
    mProfileThumbnail.layer.masksToBounds = YES;
    
    [leftview addSubview:mProfileThumbnail];
    
    
    
    
    UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:mProfileThumbnail];
    
    UIBarButtonItem *leftitems = [[UIBarButtonItem alloc] initWithCustomView:leftview];
    
    self.navigationItem.leftBarButtonItems = @[barButton, /*spaceBtn,*/ barButton1];
    
    [_mUser getImagePath];
    
    NSString *username = [MesiboCommonUtils getUserName:_mUser];
    self.title = username;
    
    [_mChatTable registerClass:[MesiboMessageViewHolder class] forCellReuseIdentifier:MESIBO_CELL_IDENTIFIER ];
    
    _mChatView.backgroundColor = [UIColor getColor:mMesiboUIOptions.messageInputBackgroundColor];
    _mChatView.layer.borderWidth = 0.5;
    _mChatView.layer.borderColor = [UIColor getColor:mMesiboUIOptions.messageInputBorderColor].CGColor;
    
    _mChatEdit.layer.borderWidth = 0.5;
    _mChatEdit.layer.borderColor = [UIColor getColor:mMesiboUIOptions.messageInputBorderColor].CGColor;
    _mChatEdit.layer.cornerRadius = 4.0;
    
    if(mMesiboUIOptions.messageInputTextColor) {
        _mChatEdit.textColor = [UIColor getColor:mMesiboUIOptions.messageInputTextColor];
    }
    
    if(mMesiboUIOptions.messageInputTextBackgroundColor) {
        _mChatEdit.backgroundColor = [UIColor getColor:mMesiboUIOptions.messageInputTextBackgroundColor];
    }
    
    
    int editCornerRadius = 0;
    
    if(mMesiboUIOptions.messageInputTextCornerRadiusRatio >= 2) {
        editCornerRadius = _mChatEdit.frame.size.height/mMesiboUIOptions.messageInputTextCornerRadiusRatio;
        
        _mChatEdit.layer.cornerRadius = editCornerRadius;
    }
    
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:_mChatTable.frame];
    tempImageView.backgroundColor = [UIColor getColor:mMesiboUIOptions.messagingBackgroundColor];
    _mChatTable.backgroundView = tempImageView;
    
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:NAVBAR_TITLE_FONT_SIZE];;
    CGSize size = [username sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    CGSize titleSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_TITLEVIEW_WIDTH, 0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor getColor:NAVIGATION_TITLE_COLOR];
    titleLabel.font = titleFont;
    titleLabel.text = @"Mesibo User Name For Size";
    titleLabel.numberOfLines = 1;
    
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.tag = 21;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    [titleLabel sizeToFit];
    titleLabel.text = username;
    
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
    
    self.navigationItem.titleView = twoLineTitleView;
    
    mScreen.subtitle = subTitleLabel;
    mScreen.title = titleLabel;
    mScreen.titleArea = twoLineTitleView;
    
    mScreen.subtitle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    mScreen.subtitle.text = mMesiboUIOptions.connectingIndicationTitle;
    
    showUserStatusFrame = mScreen.title.frame;
    CGRect frame = showUserStatusFrame;
    frame.origin.y += NAVBAR_TITLE_FONT_DISPLACEMENT;
    
    hideUserStatusFrame = frame;
    
    mScreen.title.frame = hideUserStatusFrame;
    
    
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    mScreen.subtitle.hidden = YES;
    
    UIMenuItem *resendMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_RESEND_TITLE action:@selector(resend:)];
    UIMenuItem *forwardMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_FORWARD_TITLE action:@selector(forward:)];
    UIMenuItem *shareMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_SHARE_TITLE action:@selector(share:)];
    UIMenuItem *favoriteMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_FAVORITE_TITLE action:@selector(favorite:)];
    UIMenuItem *replyMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_REPLY_TITLE action:@selector(reply:)];
    UIMenuItem *encMenuItem = [[UIMenuItem alloc] initWithTitle:MENU_REPLY_ENCRYPTION action:@selector(encryption:)];
    
    NSMutableArray<UIMenuItem *> *context_menu = [NSMutableArray new];
    if(mMesiboUIOptions.enableReply) {
        [context_menu addObject:replyMenuItem];
    }
    
    [context_menu addObject:resendMenuItem];
    
    if(mMesiboUIOptions.enableForward) {
        [context_menu addObject:forwardMenuItem];
    }
    
    if([[MesiboInstance e2ee] isEnabled])
        [context_menu addObject:encMenuItem];
    
    [context_menu addObject:shareMenuItem];
    [context_menu addObject:favoriteMenuItem];
    [[UIMenuController sharedMenuController] setMenuItems:context_menu];
    [[UIMenuController sharedMenuController] update];
    
    
    _mChatEdit.userInteractionEnabled = YES;
    [_mChatView bringSubviewToFront:_mChatEdit];
    
    _mContextMenu.hidden = NO;
#ifdef USE_PLACEHOLDER
    _mChatEdit.placeholder = CHATBOX_PLACE_HOLDER_TEXT;
    _mChatEdit.placeholderColor = [UIColor lightGrayColor]; //optional
#endif
    _mChatEdit.text = @""; // so that placeholder visible
    
    _mReplyView.layer.cornerRadius = REPLY_VIEW_CORNER_RADIUS;
    _mReplyView.layer.masksToBounds = YES;
    
    
    if([_mUser isBlocked] || ([_mUser isGroup] && ![_mUser isActive])) {
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
    
    
    mScreen.profile = _mUser;
    mScreen.profileImage = mProfileThumbnail;
    mScreen.table = _mChatTable;
    mScreen.editText = _mChatEdit;
    
    [MesiboCommonUtils associateObject:mScreen.title obj:mScreen];
    [MesiboCommonUtils associateObject:mScreen.subtitle obj:mScreen];
    [MesiboCommonUtils associateObject:mScreen.titleArea obj:mScreen];
    [MesiboCommonUtils associateObject:mScreen.profileImage obj:mScreen];
    [MesiboCommonUtils associateObject:mScreen.editText obj:mScreen];
    
    mTableController = [MesiboTableController new];
    
    [mTableDelegate MesiboUI_onInitScreen:mScreen];
    
    [mTableController setup:self screen:mScreen model:mModel delegate:self uidelegate:mTableDelegate];
    
    NSArray *btnArray = mScreen.buttons;
    mUserButtons = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < [btnArray count]; i++) {
        UIButton *button = [btnArray objectAtIndex:i];
        [MesiboCommonUtils associateObject:button obj:mScreen];
        [button setFrame:CGRectMake(0, 0, UIBAR_BUTTON_SIZE, UIBAR_BUTTON_SIZE)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [mUserButtons insertObject:barButton atIndex:0];
    }
    
    self.navigationItem.rightBarButtonItems = mUserButtons;
    
    [self onLogin:nil];
    [self updateUserActivity:nil activity:MESIBO_PRESENCE_NONE];
    
    [self setInputAreaColor];
    
}

-(void) setTableViewDelegate:(id<MesiboUIListener>) tableDelegate {
    mTableDelegate = tableDelegate;
}

-(MesiboTableController *) getTableController {
    return mTableController;
}

- (void) share:(NSString *) text image:(UIImage *)image {
    
}

-(void) forwardMessages:(NSArray *)msgids {
    
    [MesiboUIManager launchUserListViewcontroller:self  withChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"] withContactChooser:USERLIST_MODE_FORWARD withForwardMessageData:msgids withMembersList:nil withForwardGroupName:nil withForwardGroupid:0];
}

-(void) enableSelectionActionButtons:(BOOL)enable buttons:(NSArray *) buttons {
    
    if(enable)
        self.navigationItem.rightBarButtonItems = buttons;
    else
        self.navigationItem.rightBarButtonItems = mUserButtons;
    
    [self closeContextMenu];
}

-(BOOL) loadMessages {
    [mModel loadMessages:MESIBO_READ_MESSAGES];
    return YES;
}


- (void) openProfileImage:(UITapGestureRecognizer *)sender{
    
    UIImage *image = [_mUser getImageOrThumbnail];
    if(image) {
        [MesiboUIManager showImageInViewer:self withImage:image withTitle:[MesiboCommonUtils getUserName:_mUser] handler:^(UIImageView *image, UILabel *caption) {
            _profileImageView = image;
            if(_profileImageView) {
                _profileImageView.image = [_mUser getImageOrThumbnail];
            }
        }];
        return;
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
        [_mUser sendJoined];
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
    
    
    mScreen.subtitle.hidden = YES;
    
    [UIView animateWithDuration:0.2
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
        mScreen.title.frame = hideUserStatusFrame;
    }
                     completion:^(BOOL finished){
        
    }];
    
}

-(int) updateUserStatus :(NSString *)status duration:(long)duration {
    
    
    if(!status) {
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
        mScreen.title.frame = showUserStatusFrame;
    }
                     completion:^(BOOL finished){
        
        mScreen.subtitle.hidden = NO;
        mScreen.subtitle.text = status;
        
    }];
    
    
    return 0;
    
}

-(int) updateUserActivity:(MesiboMessageProperties *)params activity:(int) activity {
    int connectionStatus = [MesiboInstance getConnectionStatus];
    
    if(MESIBO_STATUS_CONNECTING == connectionStatus) {
        return [self updateUserStatus:mMesiboUIOptions.connectingIndicationTitle duration:0];
    }
    if(MESIBO_STATUS_NONETWORK == connectionStatus) {
        return [self updateUserStatus:mMesiboUIOptions.noNetworkIndicationTitle duration:0];
    }
    if(MESIBO_STATUS_SUSPEND == connectionStatus) {
        return [self updateUserStatus:mMesiboUIOptions.suspendedIndicationTitle duration:0];
    }
    if(MESIBO_STATUS_CONNECTFAILURE == connectionStatus) {
        return [self updateUserStatus:mMesiboUIOptions.offlineIndicationTitle duration:0];
    }
    if(MESIBO_STATUS_ONLINE != connectionStatus) {
        return [self updateUserStatus:mMesiboUIOptions.offlineIndicationTitle duration:0];
    }
    
    
    NSString *status = nil;
    MesiboProfile *profile = _mUser;
    uint32_t groupid = 0;
    if(params) {
        groupid = params.groupid;
        if(params.profile) profile = params.profile;
    }
    
    if([_mUser isGroup] && ![_mUser isActive]) {
        if([_mUser isDeleted])
            return [self updateUserStatus:mMesiboUIOptions.groupDeletedTitle duration:0];
        else
            return [self updateUserStatus:mMesiboUIOptions.groupNotMemberTitle duration:0];
    }
    
    if([profile isTypingInGroup:groupid]) {
        [mUserData setTyping:nil];
        status = mMesiboUIOptions.typingIndicationTitle;
        if(params && params.groupid && params.profile) {
            NSString *name = [profile getName];
            if(!name)
                name = [params.profile getAddress];
            status = [NSString stringWithFormat:@"%@ is %@", name, mMesiboUIOptions.typingIndicationTitle];
        }
    } else if(!groupid && [profile isChatting]) {
        status = mMesiboUIOptions.joinedIndicationTitle;
    } else if(!groupid && [profile isOnline]) {
        status = mMesiboUIOptions.userOnlineIndicationTitle;
    }
    
    return [self updateUserStatus:status duration:0];
}



-(void) barButtonBackPressed:(id)sender {
    if([mTableController cancelSelectionMode])
        return;
    
    if(mModel) {
        [mModel stop];
    }
    
    [self dismiss];
}

-(void) dismiss {
    if(_mDismissOnBackPressed || !self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setSetatusBarColor_not_in_use {
    CGRect statusBarFrame;
    if (@available(iOS 13.0, *)) {
        statusBarFrame = self.view.window.windowScene.statusBarManager.statusBarFrame;
    } else {
        // Fallback on earlier versions
        statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    }
    
    UIView *statusBar  = [[UIView alloc]initWithFrame:statusBarFrame];
    statusBar.backgroundColor = [UIColor getColor:mMesiboUIOptions.messageInputBackgroundColor];
    [self.view addSubview:statusBar];
}

// https://stackoverflow.com/questions/46881641/iphone-x-set-the-color-of-the-area-around-home-indicator
-(void) setSafeAreaColor {
    
    if (@available(iOS 11.0, *)) {
    } else {
        return;
    }
    
    UIView *insetView = [[UIView alloc]initWithFrame:CGRectZero];
    insetView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:insetView];
    [self.view sendSubviewToBack:insetView];
    
    [insetView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [insetView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [insetView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    if (@available(iOS 11.0, *)) {
        [insetView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    } else {
    }
    
    insetView.backgroundColor = [UIColor getColor:mMesiboUIOptions.messageInputBackgroundColor];
}

-(void) setButtonImageColor:(UIButton *)btn color:(UIColor *)color {
    if(!btn) return;
    UIImage *image = [[btn currentImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    if(!image) return;
    btn.tintColor = color;
    [btn setImage:image forState:UIControlStateNormal];
}

-(void) setInputAreaColor {
    [self setSafeAreaColor];
    
    UIColor *bgColor = [UIColor getColor:mMesiboUIOptions.messageInputBackgroundColor];
    _mCameraBtn.backgroundColor = bgColor;
    _mSendBtn.backgroundColor = bgColor;
    _mPaneBtn.backgroundColor = bgColor;
    _mPanelMediaButton.backgroundColor = bgColor;
    _mPanelLocationButton.backgroundColor = bgColor;
    _mPanelDocButton.backgroundColor = bgColor;
    _mPanelMusicButton.backgroundColor = bgColor;
    _mAttachButton.backgroundColor = bgColor;
    
    
    if(mMesiboUIOptions.messageInputButtonsColor) {
        UIColor *btnColor = [UIColor getColor:mMesiboUIOptions.messageInputButtonsColor];
        [self setButtonImageColor:_mCameraBtn color:btnColor];
        [self setButtonImageColor:_mSendBtn color:btnColor];
        [self setButtonImageColor:_mPaneBtn color:btnColor];
        [self setButtonImageColor:_mPanelMediaButton color:btnColor];
        [self setButtonImageColor:_mPanelLocationButton color:btnColor];
        [self setButtonImageColor:_mPanelDocButton color:btnColor];
        [self setButtonImageColor:_mPanelMusicButton color:btnColor];
        [self setButtonImageColor:_mAttachButton color:btnColor];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    mViewActive = YES;
    
    mOrgParentHeight = _height_parent.constant;
    
    contextMenuFrame = _mContextMenu.frame;
    
    chatEditFrame = _mChatEdit.frame;
    _mContextMenu.hidden = NO;
    
    
    
    
    [MesiboInstance setAppInForeground:self screenId:1 foreground:YES];
    if(mModel) {
        [mModel start];
    }
    
    [self arrangeMediaPaneButtons];
    [self updateUserActivity:nil activity:MESIBO_PRESENCE_NONE];
    
    [MesiboInstance queueInThread:YES delay:1000 handler:^{
        if(!mViewActive) return; // if the view was closed by the time this was called
        [self updateUserActivity:nil activity:MESIBO_PRESENCE_NONE];
    }];
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
    
    [self closeContextMenu];
    
    mViewActive = NO;
    
    _mContextMenu.alpha = 0;

    if(![_mUser getGroupId])
        [_mUser sendLeft];
    
    if(mModel) {
        [mModel pause];
    }
    
}

-(void)screenUnlock:(NSNotification *)notification {
    [MesiboInstance setAppInForeground:self screenId:1 foreground:YES];
    if(mModel) {
        [mModel start];
    }
}

-(void)screenLock:(NSNotification *)notification {
    if(![_mUser getGroupId])
        [_mUser sendLeft];;
    
    if(mModel) {
        [mModel pause];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    mScreen.title.text = [MesiboCommonUtils getUserName:_mUser];
    
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
    
    if([mTableDelegate respondsToSelector:@selector(MesiboUI_onShowScreen:)]) {
        [mTableDelegate MesiboUI_onShowScreen:mScreen];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenUnlock:) name:UIApplicationProtectedDataDidBecomeAvailable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenLock:) name:UIApplicationProtectedDataWillBecomeUnavailable object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    //tap.delegate = self;
    [tap setCancelsTouchesInView:YES]; // to pass tap to other views
    [self.view addGestureRecognizer:tap];
    
    if(_mUser != nil) {
        
        if(![[_mUser getDraft] isEqualToString:@""] && [_mUser getDraft] !=nil) {
            
            _mChatEdit.text=[_mUser getDraft];
            if(mMesiboUIOptions.messageInputTextColor) {
                _mChatEdit.textColor = [UIColor getColor:mMesiboUIOptions.messageInputTextColor];
            }
            
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
    
    MesiboUiDefaults *opt = [MesiboUI getUiDefaults];
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:opt.shareMediaTitle
                                 message:opt.shareMediaSubTitle
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* camera = [self addAlert:view title:opt.shareMediaCameraTitle type:PICK_CAMERA_IMAGE];
    UIAlertAction* Image = [self addAlert:view title:opt.shareMediaGalleryTitle type:PICK_VIDEO_GALLERY];
    UIAlertAction* location = [self addAlert:view title:opt.shareMediaLocationTitle type:PICK_LOCATION];
    UIAlertAction* audio = [self addAlert:view title:opt.shareMediaAudioTitle type:PICK_AUDIO_FILES];
    UIAlertAction* files = [self addAlert:view title:opt.shareMediaDocumentTitle type:PICK_DOCUMENTS];
    UIAlertAction* cancel = [self addAlert:view title:opt.cancelTitle type:-1];
    
    
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
        
        [self applicationFileTypeMapping:picker];

        if(picker.fileType == MESIBO_FILETYPE_LOCATION) {
            [self insertMessage:picker];
        }else  {
            
            BOOL hdControl = YES ;
            
            if(picker.fileType == MESIBO_FILETYPE_IMAGE)
                hdControl = NO;
            
            
            // do not set maxDimension. API now takes care of it and we can avoid multiple resize
            [MesiboUIManager launchImageEditor:im withParent:self withImage:picker.image title:nil hideEditControls:hdControl showCaption:YES showCropOverlay:NO squareCrop:NO maxDimension:0  withBlock:^BOOL(UIImage *image, NSString *caption) {
                picker.message = caption;
                picker.image = image;
                
                [self insertMessage:picker];
                
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
    
    mReplyMessage = nil;
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8
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

-(void) imageToNative:(UIImage *)image {
    
    CGImageRef imageRef = image.CGImage;
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef dataRef = CGDataProviderCopyData(dataProvider);
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    CGBitmapInfo bminfo = CGImageGetBitmapInfo(imageRef);
    
    int another = (int)bminfo& kCGBitmapAlphaInfoMask; // this can be compared against CGImageAlphaInfo
    
    int rgb565 = 0, pf = 1;
    BOOL endianLittle = NO, alphaFirst = NO, alphaLast = NO;
    
    if(kCGImageAlphaPremultipliedFirst == alpha || kCGImageAlphaFirst == alpha || kCGImageAlphaNoneSkipFirst == alpha)
        alphaFirst = YES;
    if(kCGImageAlphaPremultipliedLast == alpha || kCGImageAlphaLast == alpha || kCGImageAlphaNoneSkipLast == alpha)
        alphaLast = YES;
    
    int bitsPerpixel = CGImageGetBitsPerPixel(imageRef);
    
    if (@available(iOS 12.0, *)) {
        CGImagePixelFormatInfo format = CGImageGetPixelFormatInfo(imageRef);
        CGImageByteOrderInfo byteOrder = CGImageGetByteOrderInfo(imageRef);
        
        if(format == kCGImagePixelFormatRGB565)
            rgb565 = 1;
        
        if(byteOrder == kCGImageByteOrder16Little || byteOrder == kCGImageByteOrder32Little)
            endianLittle = YES;
        
        if(kCGImagePixelFormatPacked != format) {
            alphaFirst = NO;
            alphaLast = NO;
            rgb565 = 0;
        }
        
    } else {
        int bo = (int)(bminfo&kCGImageByteOrderMask);
        if(bo == kCGImageByteOrder16Little || bo == kCGImageByteOrder32Little)
            endianLittle = YES;
        
    }
    
    if(bitsPerpixel) {
        alphaFirst = NO;
        alphaLast = NO;
        rgb565 = 0;
    }
    
    if (alphaFirst && endianLittle) {
        pf = 1;
    } else if (alphaFirst) {
        pf = 2;
    } else if (alphaLast && endianLittle) {
        pf = 3;
    } else if (alphaLast) {
        pf = 4;
    } else {
        //   https://stackoverflow.com/questions/15291957/uiimage-byte-order-was-changed
        // if we can't handle format, just conver to RBGA
        // may be we should do it for RGB565 too
        //image = [ImageUtils resizeImageUsingCGContext:image width:0 height:0 idata:nil];
        imageRef = image.CGImage;
        dataProvider = CGImageGetDataProvider(imageRef);
        dataRef = CGDataProviderCopyData(dataProvider);
        pf = 5;
        
    }
    

    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    const uint8_t *idata = (const uint8_t *)CFDataGetBytePtr(dataRef);
    
    return;
}


-(MesiboMessage *) insertMessage:(ImagePickerFile * )picker {
    
    MesiboMessage *m = [_mUser newMessage];
    m.message = picker.message;
    //m.title = picker.title;
    [m setContentType:picker.fileType];
    [m setUiContext:self];
    
    if(mReplyMessage) {
        [m setInReplyTo:mReplyMessage.mid];
    }
    
    if(picker.fileType==MESIBO_FILETYPE_LOCATION) {
        
        m.latitude = picker.lat;
        m.longitude = picker.lon;
        [m setThumbnail:picker.image];
        [m send];
        return m;
    }
    
    
    if(picker.fileType==MESIBO_FILETYPE_IMAGE) {
        [m setContent:picker.image];
        [m send];
        return m;
    }
    
    if(picker.fileType==MESIBO_FILETYPE_VIDEO && picker.image) {
    }
    
    m.asset = picker.phasset;
    m.localIdentifier = picker.localIdentifier;
    m.sendFileName = YES;
    [m setContent:picker.filePath];
    
    if(!picker.mp4Path) {
        [m send];
        return m;
    }
    
    //These both points to mov file resources, hence we are setting ot to null
    m.localIdentifier = nil;
    m.asset = nil;
    
    [picker setMp4TranscodingHandler:^(ImagePickerFile *mf1) {
        [m setContent:mf1.filePath];
        [m send];
    }];
    
    return m;
    
}

-(void)markSendingFailed:(int) channel status:(int)status mids:(uint32_t)mid {
    
}

- (IBAction)sendChatAction:(id)sender {
    
    NSString *message = [_mChatEdit.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(![message length])
        return;
    
    MesiboMessage *m = [_mUser newMessage];
    [m setUiContext:self];
    m.message = message;
    if(mReplyMessage) {
        [m setInReplyTo:mReplyMessage.mid];
    }
    [m send];
    
    _mChatEdit.text = @"";
    
    if(_mUser != nil  ) {
        _mUser.draft = @"";
    }
    _height_parent.constant = mOrgParentHeight;
    
    if(mReplyTextView)
        [self cancelReplyView:nil];
    
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
    
    // [_mChatEdit removeConstraints:_mChatEdit.constraints];
    //closeMediaPane = false;
    [self setCloseMediaPaneValue:false];
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    
    
    mKBHeight = keyboardFrameConverted.size.height;
    
    int safearea = 0;
    if (@available(iOS 11.0, *)) {
        safearea = self.view.safeAreaInsets.bottom;
        if(safearea > 1) safearea -= 1; // some margin
    }
    
    _mChatShiftConstrain.constant = mConstrain  + mKBHeight - safearea;
    
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
    
    //closeMediaPane = false;
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
        //textView.text = CHATBOX_PLACE_HOLDER_TEXT;
        //textView.textColor = [UIColor lightGrayColor]; //optional
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

- (BOOL)dismissKeyboard {
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
        [_mUser sendTyping];
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
}

#define CGRectSetWidth(rect, w)    CGRectMake(rect.origin.x, rect.origin.y, w, rect.size.height)
#define ViewSetWidth(view, w)   view.frame = CGRectSetWidth(view.frame, w)
- (void) closeContextMenu {
    //closeMediaPane = false;
    [self setCloseMediaPaneValue:false];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    _mContextMenu.frame = contextMenuFrame;
    _mChatEdit.frame = chatEditFrame;
    
    [UIView commitAnimations];
    
}

- (IBAction)openContexMenu:(id)sender {
    if(!closeMediaPane) {
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
    [self closeContextMenu];
    
}

-(void) arrangeMediaPaneButtons {
    CGRect frames[4];
    frames[0] = _mPanelMediaButton.frame;
    frames[1] = _mPanelLocationButton.frame;
    frames[2] = _mPanelDocButton.frame;
    frames[3] = _mPanelMusicButton.frame;
    
    int maxcount = 4;
    int count = 0;
    if(mMesiboUIOptions.mediaButtonPosition >= 0 && mMesiboUIOptions.mediaButtonPosition < maxcount)
        count++;
    
    if(mMesiboUIOptions.locationButtonPosition >= 0 && mMesiboUIOptions.locationButtonPosition < maxcount)
        count++;
    
    if(mMesiboUIOptions.docButtonPosition >= 0 && mMesiboUIOptions.docButtonPosition < maxcount)
        count++;
    
    if(mMesiboUIOptions.audioButtonPosition >= 0 && mMesiboUIOptions.audioButtonPosition < maxcount)
        count++;
    
    maxcount = count;
    
    int xoff = 36;
    // note that space is distributed bteweeb 5 buttons including more button
    if(count == 3) xoff = 36 + 12;
    if(count == 2) xoff = 36 + 36;
    
    
    frames[1].origin.x = frames[0].origin.x + xoff;
    frames[2].origin.x = frames[1].origin.x + xoff;
    frames[3].origin.x = frames[2].origin.x + xoff;
    
    if(mMesiboUIOptions.mediaButtonPosition >= 0 && mMesiboUIOptions.mediaButtonPosition < maxcount) {
        _mPanelMediaButton.frame = frames[mMesiboUIOptions.mediaButtonPosition];
    } else {
        _mPanelMediaButton.hidden  = YES;
    }
    
    if(mMesiboUIOptions.locationButtonPosition >= 0 && mMesiboUIOptions.locationButtonPosition < maxcount) {
        _mPanelLocationButton.frame = frames[mMesiboUIOptions.locationButtonPosition];
    } else {
        _mPanelLocationButton.hidden = YES;
    }
    
    if(mMesiboUIOptions.docButtonPosition >= 0 && mMesiboUIOptions.docButtonPosition < maxcount) {
        _mPanelDocButton.frame = frames[mMesiboUIOptions.docButtonPosition];
    } else {
        _mPanelDocButton.hidden = YES;
    }
    
    if(mMesiboUIOptions.audioButtonPosition >= 0 && mMesiboUIOptions.audioButtonPosition < maxcount) {
        _mPanelMusicButton.frame = frames[mMesiboUIOptions.audioButtonPosition];
    } else {
        _mPanelMusicButton.hidden = YES;
    }
    
    
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
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    
    MessageData *m = [cell getMessage];
    MesiboMessage *mm = [m getMesiboMessage];
    mReplyMessage = mm;
    
    mReplyImageThumb = nil;
    
    //__weak MesiboMessageViewHolder *wself = self;
    [UIView
     animateWithDuration:0.5
     
     animations:^{
        [mReplyTextView removeFromSuperview];
        _height_parent.constant = _height_parent.constant - _mReplyVuHeight.constant;
        _mReplyVuHeight.constant=0;
    }
     
     completion:^(BOOL finished) {
        
        mReplyUsernameStorage = [m getReplyName];
        mReplyImageThumb = [m getImage];
        
        if(mReplyImageThumb) {
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
        namelabel.text = @"";
    
    UILabel *messagelabel = [mReplyTextView viewWithTag:101];
    if(nil != message)
        messagelabel.text = message;
    else
        messagelabel.text = @" ";
    
    [messagelabel sizeToFit];
    [messagelabel layoutIfNeeded];
    [mReplyTextView layoutIfNeeded];
    
    CGFloat height = REPLYVIEW_HEIGHT_PADDING_INTERNAL + CGRectGetMaxY(messagelabel.frame);
    
    UIImageView *imageView = [mReplyTextView viewWithTag:102];
    
    if(nil != imageView) {
        if(nil != imagetumb)
            imageView.image = imagetumb;
        else
            imageView.image = nil;
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
    if((MESIBO_MSGSTATUS_INVALIDDEST == status || MESIBO_MSGSTATUS_NOTMEMBER == status) && [_mUser getGroupId] > 0) {
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
    if(_profileImageView)
        _profileImageView.image = [_mUser getImageOrThumbnail];
    
    if([_mUser isDeleted]) {
        [self dismiss];
        return;
    }
    
    [self setProfilePicture];
    
    mScreen.title.text = [MesiboCommonUtils getUserName:_mUser];
    
    if([_mUser isBlocked] || ([_mUser isGroup] && ![_mUser isActive])) {
        _mChatView.hidden = YES;
    } else {
        _mChatView.hidden = NO;
    }
}

- (void) onShutdown {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
