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

#import "UserListViewController.h"
#import "MesiboMessageViewController.h"
#import "MesiboImage.h"
#import "UIImage+Tint.h"
#import "UIColors.h"
#import "MesiboCommonUtils.h"
#import "MesiboUIAlerts.h"
#import "CreateNewGroupViewController.h"
#import "LetterTitleImage.h"
#import "MesiboConfiguration.h"
#import "MesiboUIManager.h"
#import "Includes.h"


@implementation UserListViewController

{
    
    NSMutableArray *mUsersList;
    // for housing serached messaged from database and userlist in "forward to user" list
    NSMutableArray *mCommonNFilterArray;
    NSMutableArray *mTableList;
    //NSMutableDictionary *mProfilesLookup;
    CGRect mShowUserStatusFrm;
    CGRect mHideUserStatusFrm;
    MesiboUiDefaults *mMesiboUIOptions;
    
    BOOL mIsMessageSearching;
    NSMutableArray *mUtilityArray;
    
    NSMutableArray *mSelectedMembers;
    
    NSBundle *mMessageBundle;
    NSTimer* mUiUpdateTimer;
    uint64_t mTiUpdateTimestamp;
    uint64_t mRefreshTs;
    
    UIColor *mStatusColor, *mTypingColor, *mPrimaryColor;
    MesiboReadSession *mReadSession;
    
    NSMutableArray* mGroupMembers;
    MesiboProfile* mGroupProfile ;
    
    MesiboUserListScreen *mScreen;
    MesiboUserListRow *mMessageRow;
    
    BOOL mFirstOnline;
}

-(void) setGroupMembers:(NSMutableArray *)members {
    mGroupMembers = members;
}

-(NSString*)titleAddSpace:(NSString*)title {
    int len = (int) title.length;
    if(len >= 16) return title;
    
    int spaceCount = ((16-len)/2) + 1;
    
    NSString *result = [NSString stringWithFormat:@".%@%@%@.",[@" " stringByPaddingToLength:spaceCount withString:@" " startingAtIndex:0], title, [@" " stringByPaddingToLength:spaceCount withString:@" " startingAtIndex:0]];
    return result;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } 
    
    mScreen = [MesiboUserListScreen new];
    mScreen.parent = self;
    mScreen.options = _mOpts;
    mScreen.mode = _mMode;
    
    mMessageRow = [MesiboUserListRow new];
    mMessageRow.screen = mScreen;
    
    mReadSession = nil;
    mUiUpdateTimer = nil;
    mTiUpdateTimestamp = 0;
    mRefreshTs = 0;
    mFirstOnline = NO;
    mMesiboUIOptions = [MesiboUI getUiDefaults];
    mUsersList = [[NSMutableArray alloc] init];
    mCommonNFilterArray = [[NSMutableArray alloc] init];
    mUtilityArray = [[NSMutableArray alloc] init];
    mSelectedMembers = [[NSMutableArray alloc] init];
    mGroupMembers = [[NSMutableArray alloc] init];
    
    if(!_mUiDelegateForMessageView)
        _mUiDelegateForMessageView = _mUiDelegate;
    
    
    mPrimaryColor = [UIColor getColor:0xff00868b];
    if(mMesiboUIOptions.mToolbarColor)
        mPrimaryColor = [UIColor getColor:mMesiboUIOptions.mToolbarColor];
    
    
    mStatusColor = [UIColor getColor:mMesiboUIOptions.mUserListStatusColor];
    mTypingColor = [UIColor getColor:mMesiboUIOptions.mUserListTypingIndicationColor];
    
    if(_mForwardGroupid) {
        mGroupProfile = [MesiboInstance getGroupProfile:_mForwardGroupid];
        [MesiboInstance addListener:self];
        if(mGroupProfile && (!mGroupMembers || !mGroupMembers.count)) {
            [[mGroupProfile getGroupProfile] getMembers:256 restart:YES listener:self];
        }
    }
    
    
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:MESIBO_UI_BUNDLE withExtension:@"bundle"];
    
    if(nil == bundleURL) {
        
    }
    
    [self updateTitles:mScreen.mode];
    
    mMessageBundle = [[NSBundle alloc] initWithURL:bundleURL];
    _mUsersTableView.delegate = self;
    
    mScreen.table = _mUsersTableView;
    
    
    [self initSearchController];
    
    [self initCommonNavigationButtons];
    [self initMessageListNavigationTitles];
    
    [self initOtherListNavigationButtons];
    
    [MesiboCommonUtils setNavigationBarColor:self.navigationController.navigationBar color:mPrimaryColor];
    
    if(_mUiDelegate) [_mUiDelegate MesiboUI_onInitScreen:mScreen];
    
    [self initMessageListNavigationButtons];
}

-(void) initSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = NSLocalizedString(@"Search", comment: "");
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    
    [self.searchController.searchBar setBackgroundImage:[UIImage new]];
    [self.searchController.searchBar setTranslucent:YES];
    
    BOOL enableSearch = mMesiboUIOptions.enableSearch;
    
    if(USERLIST_MODE_FORWARD == _mMode || USERLIST_MODE_EDITGROUP == _mMode)
        enableSearch = NO;
    
    
    if(enableSearch) {
        _mUsersTableView.tableHeaderView = self.searchController.searchBar;
        
        self.searchController.delegate = self;
        self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
        self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
        self.definesPresentationContext = YES;  // know where you want
        //UISearchController to be displayed
        if(!mMesiboUIOptions.alwaysShowSearchBar) {
            [self.tableView setContentOffset:CGPointMake(0, self.searchController.searchBar.frame.size.height)];
            
        } else {
            [self.tableView setContentOffset:CGPointMake(0, 0)];
        }
        _mUsersTableView.allowsMultipleSelectionDuringEditing = NO;
        _mUsersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.definesPresentationContext = YES;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    mScreen.search = self.searchController;
}

-(void) initMessageListNavigationTitles {
    if(mScreen.mode != USERLIST_MODE_MESSAGES) return;
    
    UIFont *titleFont = [UIFont boldSystemFontOfSize:NAVBAR_TITLE_FONT_SIZE];
    
    NSString *title = [self getAppTitle];
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    
    CGSize titleSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    // keep maximum size so that bigger app name can be accomodated
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_TITLEVIEW_WIDTH, titleSize.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor getColor:NAVIGATION_TITLE_COLOR];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = titleFont;
    titleLabel.text = title;
    titleLabel.tag = 21;
    
    UIFont *subtitleFont = [UIFont systemFontOfSize:NAVBAR_SUBTITLE_FONT_SIZE];
    size = [@"Connecting" sizeWithAttributes:@{NSFontAttributeName: subtitleFont}];
    CGSize subtitleSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleSize.height, NAVBAR_TITLEVIEW_WIDTH, subtitleSize.height)];
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = [UIColor getColor:NAVIGATION_TITLE_COLOR];
    subTitleLabel.font = [UIFont systemFontOfSize:NAVBAR_SUBTITLE_FONT_SIZE];
    subTitleLabel.text = @". . . . .  . . . . . . . . ";
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.tag = 20;
    
    CGFloat vw = MAX(subTitleLabel.frame.size.width, titleLabel.frame.size.width);
    
    
    UIView *twoLineTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vw, titleSize.height + subtitleSize.height)];
    [twoLineTitleView addSubview:titleLabel];
    [twoLineTitleView addSubview:subTitleLabel];
    
    
    
    self.navigationItem.titleView = twoLineTitleView;
    
    
    mScreen.title = titleLabel;
    mScreen.subtitle = subTitleLabel;
    mScreen.titleArea = twoLineTitleView;
    
    [MesiboCommonUtils associateObject:mScreen.title obj:mScreen];
    [MesiboCommonUtils associateObject:mScreen.subtitle obj:mScreen];
    [MesiboCommonUtils associateObject:mScreen.titleArea obj:mScreen];
    
    int status = [MesiboInstance getConnectionStatus];
    if(status == MESIBO_STATUS_ONLINE)
        mScreen.subtitle.text = @"";
    else
        mScreen.subtitle.text = mMesiboUIOptions.connectingIndicationTitle;
    
    mShowUserStatusFrm = mScreen.title.frame;
    CGRect frame = mShowUserStatusFrm;
    frame.origin.y += NAVBAR_TITLE_FONT_DISPLACEMENT;
    
    mHideUserStatusFrm = frame;
    
    mScreen.title.frame = mHideUserStatusFrm;
    mScreen.subtitle.hidden = YES;
}

-(void) initCommonNavigationButtons {
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[MesiboImage imageNamed:@"ic_arrow_back_white.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(barButtonBackPressed:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

-(void) initMessageListNavigationButtons {
    if(mScreen.mode != USERLIST_MODE_MESSAGES) return;
    
    if(!mMesiboUIOptions.enableBackButton)
        self.navigationItem.leftBarButtonItem = nil;
    
    NSArray *btnArray = mScreen.buttons;
    NSMutableArray *barBtnArray = [[NSMutableArray alloc] init];
    for(int i = 0 ; btnArray && i < [btnArray count]; i++) {
        UIButton *button = [btnArray objectAtIndex:i];
        [MesiboCommonUtils associateObject:button obj:mScreen];
        if(button.tag == MESIBOUI_TAG_NEWMESSAGE) {
            [MesiboCommonUtils cleanTargets:button];
            [button addTarget:self action:@selector(selectContactForMessage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [button setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [barBtnArray insertObject:barButton atIndex:0];
    }
    
    if(mMesiboUIOptions.enableMessageButton && (!btnArray || !btnArray.count)) {
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [MesiboCommonUtils associateObject:button obj:mScreen];
        [button setImage:[UIImage imageNamed:@"ic_message_white"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
        [button addTarget:self action:@selector(selectContactForMessage:)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [barBtnArray insertObject:barButton atIndex:0];
    }
    
    self.navigationItem.rightBarButtonItems = barBtnArray;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
}

-(void) initOtherListNavigationButtons {
    if(mScreen.mode == USERLIST_MODE_MESSAGES) return;
    
    if(_mMode== USERLIST_MODE_FORWARD) {
        UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button1 setImage:[MesiboImage imageNamed:@"ic_forward_white.png"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(forwardMessageToContacts)forControlEvents:UIControlEventTouchUpInside];
        [button1 setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
        UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem = barButton1;
        
    } else if (_mMode == USERLIST_MODE_GROUPS || _mMode == USERLIST_MODE_EDITGROUP) {
        UIButton *button1 =  [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button1 setImage:[MesiboImage imageNamed:@"ic_group_add_white.png"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(createNewGroup)forControlEvents:UIControlEventTouchUpInside];
        [button1 setFrame:CGRectMake(0, 0, USERLIST_NAVBAR_BUTTON_SIZE, USERLIST_NAVBAR_BUTTON_SIZE)];
        UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem = barButton1;
        
    }
}

-(NSString *) getAppTitle {
    NSString *appTitle = mMesiboUIOptions.messageListTitle;
    if(!appTitle || !appTitle.length) appTitle = [MesiboInstance getAppName];
    return appTitle;;
}

-(void) setNavigationTitle:(NSString *) title subtitle:(NSString *) subtitle {
    
}

- (void) updateTitles: (int) mode {
    if(mode == USERLIST_MODE_MESSAGES) {
        
        self.title = [self getAppTitle] ;
    }
    else if(mode == USERLIST_MODE_CONTACTS)
        self.title = mMesiboUIOptions.selectContactTitle ;
    else if(mode == USERLIST_MODE_FORWARD)
        self.title = mMesiboUIOptions.forwardTitle ;
    else if(mode == USERLIST_MODE_GROUPS)
        self.title = mMesiboUIOptions.selectGroupContactsTitle ;
    else if(mode == USERLIST_MODE_EDITGROUP)
        self.title = mMesiboUIOptions.selectGroupContactsTitle ;
    
}

#if 0
- (void) uiBarButtonPressed: (id) sender {
    int tag = (int) [(UIBarButtonItem*)sender tag];
    if(tag == 0 ){
        [self selectContactForMessage:nil];
    } else {
        
        if(_mUiDelegate)
            [_mUiDelegate MesiboUI_onClicked:mScreen row:nil view:sender];
    }
    
}
#endif

-(void) selectContactForMessage:(id) sender {
    
    MesiboUserListScreenOptions *ulopts = [MesiboUserListScreenOptions new];
    ulopts.mode = USERLIST_MODE_CONTACTS;
    ulopts.listener = _mUiDelegate;
    ulopts.mlistener = _mUiDelegateForMessageView;
    [MesiboUIManager launchUserListViewcontroller:self opts:ulopts];
}


-(void) refreshTable:(NSIndexPath *)indexPath {
    if(mUiUpdateTimer) {
        [mUiUpdateTimer invalidate];
        mUiUpdateTimer = nil;
    }
    
    mTiUpdateTimestamp = [MesiboInstance getTimestamp];
    
    //NSLog(@"Updating table");
    if(nil == indexPath) {
        [_mUsersTableView reloadData];
        return;
    }
    
    MesiboUserListRow *mrow = [self mesiboRowForIndexPath:indexPath];
    
    @try {
        UITableViewCell *cell = [_mUsersTableView cellForRowAtIndexPath:indexPath];
        if(cell)
            [self updateCell:cell index:indexPath mrow:mrow];
    }
    @catch(NSException *e) {
        [_mUsersTableView reloadData];
    }
}

-(void) refreshTable {
    [self refreshTable:nil];
}

-(void) addToLookup:(MesiboProfile *) profile {
    NSString *key = [profile getAddress];
    if([profile getGroupId]) {
        key = [NSString stringWithFormat:@"group%u", [profile getGroupId]];
    }
    
}

-(void) lookup:(MesiboProfile *) profile {
    NSString *key = [profile getAddress];
    if([profile getGroupId]) {
        key = [NSString stringWithFormat:@"group%u", [profile getGroupId]];
    }
    
}

-(void) updateNotificationBadge {
}

-(void) addNewMessage:(MesiboMessage *)params {
    
    if(mUiUpdateTimer) {
        [mUiUpdateTimer invalidate];
        mUiUpdateTimer = nil;
    }
    
    if(params.groupid && !params.groupProfile)
        return;
    
    if(!mIsMessageSearching) {
        mTableList = mUsersList;
    } else {
        mTableList = mCommonNFilterArray;
    }
    
    
    MesiboProfile *mp = params.profile;
    if(params.groupProfile)
        mp = params.groupProfile;
    
    if(mp == nil ) {
        NSLog(@"NIL PROFILE - MUST NOT HAPPEN");
        //NSLog(@" Crash %@ (message: %@)", [NSThread callStackSymbols], message);
        return;
    }
    
    if(YES && mIsMessageSearching) {
        NSLog(@"Searching");
        mp = [params.profile cloneProfile];
        
        if(params.groupProfile) {
            mp = [params.groupProfile cloneProfile];
        }
    }
    
    
    UserData *oud = [UserData getUserDataFromProfile:mp];
    
    [oud setMessage:params];
    
    
    if([params isRealtimeMessage]) {
        [self updateNotificationBadge];
    }
    
    if(YES || (!mIsMessageSearching && ![params isDbSummaryMessage] && ![params isDbMessage])) {
        for(int i=0; i< [mTableList count]; i++) {
            
            MesiboProfile *up = (MesiboProfile *)mTableList[i];
            UserData *ud = [UserData getUserDataFromProfile:up];
            
            //TBD, if list in not reordered, we can only update a cell instead of table
            if([params compare:[ud getPeer] groupid:[ud getGroupId]]) {
                [mTableList removeObjectAtIndex:i];
                //[mTableList insertObject:params.profile atIndex:0];
                //[_mUsersTableView reloadData];
                break ;
            }
        }
    }
    
    
    int count  = 0;
    if([params isDbSummaryMessage] || [params isDbMessage])
        count = (int) [mTableList count];
    
    [UserData getUserDataFromProfile:mp]; //initialize `other` right away as it's getting checked in onUserProfileUpdated
    [mTableList insertObject:mp atIndex:count];
    
    if([params isRealtimeMessage]) {
        
        uint64_t ts = [MesiboInstance getTimestamp];
        
        if((ts - mTiUpdateTimestamp) > 2000) {
            [self refreshTable:nil];
            return;
        }
        
        NSTimeInterval to = 2.0; // 1 second
        if((ts - params.ts) < 5000) {
            to = 0.5; //half second
        }
        
        mTiUpdateTimestamp = ts; // so that it doesn't keep updating
        
        mUiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:to target: self
                                                        selector:@selector(refreshTable) userInfo: nil repeats: NO];
    }
    
    return ;
}

-(void) updateUiIfLastMessage:(MesiboMessageProperties *)params {
    if(![params isLastMessage]) return;
    [MesiboInstance runInThread:YES handler:^{
        [self refreshTable:nil];
        [self updateNotificationBadge];
    }];
}

-(void) updateConnectionStatus:(NSInteger)status {
    NSLog(@"UI: OnConnectionStatus status: %d", status);
    status = [MesiboInstance getConnectionStatus];
    
    if(status == MESIBO_STATUS_ONLINE) {
        NSString *title = [self getAppTitle];
        self.title = title ;
        mScreen.title.text = title;
        
        [self updateContactsSubTitle:mMesiboUIOptions.onlineIndicationTitle];
    } else if(status == MESIBO_STATUS_CONNECTING) {
        [self updateContactsSubTitle:mMesiboUIOptions.connectingIndicationTitle];
    } else if(status == MESIBO_STATUS_SUSPEND) {
        [self updateContactsSubTitle:mMesiboUIOptions.suspendedIndicationTitle];
    } else if(status == MESIBO_STATUS_NONETWORK) {
        [self updateContactsSubTitle:mMesiboUIOptions.noNetworkIndicationTitle];
        
    } else if(status == MESIBO_STATUS_SHUTDOWN) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self updateContactsSubTitle:mMesiboUIOptions.offlineIndicationTitle];
    }
}

-(void) Mesibo_onMessage:(MesiboMessage *) msg {
    if(_mMode != USERLIST_MODE_MESSAGES)
        return;
    
    if(([msg isCall] && ![msg isMissedCall]) || [msg isEndToEndEncryptionStatus]) {
        [self updateUiIfLastMessage:msg];
        return;
    }
    
    if(msg.groupid && !msg.groupProfile) {
        [self updateUiIfLastMessage:msg];
        return;
    }
    
    [self addNewMessage:msg];
    [self updateUiIfLastMessage:msg];
}

-(void) Mesibo_onMessageUpdate:(MesiboMessage *)message {
    [self Mesibo_onMessageStatus:message];
}

-(void) Mesibo_onMessageStatus:(MesiboMessage *)msg {
    if(_mMode != USERLIST_MODE_MESSAGES)
        return;
    
    if([msg isRealtimeMessage] && msg.groupid && [msg isMessageStatusInProgress]) return;
    
    for(int j=0;j<[mUsersList count];j++) {
        
        MesiboProfile *personz =[mUsersList objectAtIndex:j];
        UserData *oud = (UserData *) [personz getUserData];
        
        if(msg.mid == [oud getMid]) {
            
            [oud setMessage:msg];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:0];
            UITableViewCell* cell = [_mUsersTableView cellForRowAtIndexPath:indexPath];
            
            UILabel *pInfo = (UILabel*)[cell viewWithTag:102];
            [self setUserRow:[oud getMessage] OnLabel:pInfo];
            
        }
    }
}

-(void) Mesibo_onConnectionStatus:(NSInteger)status {
    if(status == MESIBO_STATUS_ONLINE) {
        if(!mFirstOnline && [MesiboInstance getLastProfileUpdateTimestamp] > mRefreshTs) {
            [self showUserList:YES];
        }
        
        mFirstOnline = YES;
    }
    [self updateConnectionStatus:status];
}

-(void) Mesibo_onPresence:(MesiboPresence *)message {
    int activity = message.presence;
    
    if(MESIBO_PRESENCE_TYPING != activity && MESIBO_PRESENCE_TYPINGCLEARED != activity && MESIBO_PRESENCE_LEFT != activity) {
        return;
    }
    
    if(!message.profile)
        return;
    
    if(message.groupid && !message.groupProfile)
        return;
    
    MesiboProfile *mp = message.profile;
    if(message.groupProfile)
        mp = message.groupProfile;
    
    UserData *ud = [UserData getUserDataFromProfile:mp];
    
    if(MESIBO_PRESENCE_LEFT == activity) {
    }
    else
        [ud setTyping:(message.groupid > 0)?message.profile:nil];
    
    [self refreshTable:[ud getUserListPosition]];
    
}


-(void) updateContacts:(MesiboProfile *) profile {
    if(!profile) {
        [self showUserList:YES];
        return;
    }
    
    
    if(![profile getUserData]) {
        //NSLog(@"No message for %@", profile.name);
        return;
    }
    
    
    UserData *ud = [UserData getUserDataFromProfile:profile];
    if(ud) {
        NSIndexPath *indexPath = [ud getUserListPosition];
        if(!indexPath)
            return;
        
        MesiboProfile *mp = [self getProfileAtIndexPath:indexPath];
        
        if(mp && mp != profile) {
            return;
        }
        
        if([mp isDeleted]) {
            [mTableList removeObject:mp];
            indexPath = nil;
        }
        
        [self refreshTable:indexPath];
    }
    
    return;
    
}

-(void) Mesibo_onProfileUpdated:(MesiboProfile *)profile {
    
    // check before adding to up thread
    if(profile && ![profile getUserData])
        return;
    
    if([MesiboInstance isUiThread]) {
        [self updateContacts:profile];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateContacts:profile];
        
    });
    
}

-(void) Mesibo_onGroupMembers:(MesiboProfile *) groupProfile members:(NSArray *)members {
    if(_mMode != USERLIST_MODE_EDITGROUP)
        return;
    
    [mGroupMembers removeAllObjects];
    for(int i=0; i < members.count; i++) {
        MesiboGroupMember *m = members[i];
        MesiboProfile *u = [m getProfile];
        [mGroupMembers addObject:u];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateContacts:nil];
        
    });
}

-(void) updateContactsSubTitle :(NSString *)status {
    
    if(status.length == 0) {
        
        mScreen.subtitle.hidden = YES;
        mScreen.subtitle.text = @"";
        
        [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
            mScreen.title.frame = mHideUserStatusFrm;
        }
                         completion:^(BOOL finished){
        }];
        
    }else {
        
        mScreen.subtitle.hidden = NO;
        [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
            mScreen.title.frame = mShowUserStatusFrm;
        }
                         completion:^(BOOL finished){
            
            mScreen.subtitle.hidden = NO;
            mScreen.subtitle.text = status;
            
        }];
        
    }
}

-(NSSet *) getGroupMembers:(NSString*) members {
    if(!members)
        return nil;
    
    NSArray *s = [members componentsSeparatedByString: @":"];
    if(!s || s.count < 2)
        return nil;
    
    NSArray *users = [s[1] componentsSeparatedByString: @","];
    if(!users)
        return nil;
    
    return [NSSet setWithArray:users];
}


- (void) showUserList:(BOOL)animated {
    mRefreshTs = [MesiboInstance getTimestamp];
    
    int b = [MesiboInstance getConnectionStatus];
    [self updateConnectionStatus:b];
    
    if(_mMode == USERLIST_MODE_MESSAGES) {
        [mUsersList removeAllObjects];
        
        [self.tableView reloadData];
        
        [MesiboInstance addListener:self];
        
        if(mReadSession)
            [mReadSession stop];
        
        [MesiboReadSession endAllSessions];
        
        mReadSession = [[MesiboReadSession alloc] initWith:self];
        [mReadSession enableSummary:YES];
        
        int rc = [mReadSession read:mMesiboUIOptions.mUserListMaxRows];
    }else {
        
        
        MesiboProfile *mp;
        NSMutableArray *tempArray = (NSMutableArray *)[MesiboInstance getSortedProfiles];
        mUsersList = [tempArray mutableCopy];
        
        if(mUsersList.count > 0) {
            for(int i=(int)(mUsersList.count-1);  i >= 0; i--) {
                MesiboProfile *profile= [mUsersList objectAtIndex:i];
                
                [profile setMark:NO];
                
                if([profile getGroupId] == 0  && (nil == [profile getAddress] || [profile getAddress].length == 0 ))
                    [mUsersList removeObject:profile];
                else if(_mMode == USERLIST_MODE_GROUPS || _mMode == USERLIST_MODE_EDITGROUP) {
                    if([profile getGroupId] > 0)
                        [mUsersList removeObject:profile];
                }
            }
        }
        
        
        if(_mMode == USERLIST_MODE_CONTACTS && [mMesiboUIOptions.createGroupTitle length] > 0) {
            mp = [[MesiboProfile alloc] init];
            [mp setName:mMesiboUIOptions.createGroupTitle];
            NSString *imageFile = [[MesiboCommonUtils getBundle] pathForResource :[NSString stringWithFormat:@"group"] ofType:@"png"];
            [mp setImageFromFile:imageFile];
            [mp setLookedup:YES];
            
            UserData *od = [UserData new];
            [od setTextMessage:CREATE_NEW_GROUP_DISCRIPTION];
            [od setFixedImage:YES];
            [od setThumbnail:[MesiboImage getDefaultGroupImage]];
            [mp setUserData:od];
            mp.status =@"Create a new group?";
            [mUsersList insertObject:mp atIndex:0];
        }
        
        if(_mMode == USERLIST_MODE_FORWARD  ) {
            
            [mUtilityArray removeAllObjects];
            [mCommonNFilterArray removeAllObjects];
            if(mMesiboUIOptions.showRecentInForward)
                mUtilityArray = [[MesiboInstance getRecentProfiles] mutableCopy];
            mCommonNFilterArray = [mUsersList mutableCopy];
            
        }
        
        if(mGroupMembers && mGroupMembers.count > 0 && (_mMode == USERLIST_MODE_GROUPS || _mMode == USERLIST_MODE_EDITGROUP)) {
            for(int i=0; i < mGroupMembers.count;  i++) {
                MesiboProfile *profile= [mGroupMembers objectAtIndex:i];
                [profile setMark:YES];
            }
            
            if(mUtilityArray != mGroupMembers)
                [mUtilityArray removeAllObjects];
            
            [mCommonNFilterArray removeAllObjects];
            
            mUtilityArray = [mGroupMembers mutableCopy];
            mCommonNFilterArray = [mUsersList mutableCopy];
            
        }
        
        [_mUsersTableView reloadData];
        
    }
}

-(IBAction)barButtonBackPressed:(id)sender {
    if(_mMode == USERLIST_MODE_FORWARD || _mMode == USERLIST_MODE_GROUPS || _mMode == USERLIST_MODE_EDITGROUP) {
        for(int i=0;  i< mUsersList.count; i++) {
            MesiboProfile *profile= [mUsersList objectAtIndex:i];
            [profile setMark:NO];
            
        }
    }
    
    if(_mMode == USERLIST_MODE_MESSAGES && self.parentViewController && !self.parentViewController.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_mMode == USERLIST_MODE_FORWARD || USERLIST_MODE_EDITGROUP == _mMode) {
        if (section==0)
            return  [mUtilityArray count];
        else
            return [mCommonNFilterArray count];
    }
    
    if (section==0) {
        if ([self isSearching])
            return  [mUtilityArray count];
        else
            return [mUsersList count];
    }else if (section==1) {
        return [mCommonNFilterArray count];
    }
    else
        return 0;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    
    if(_mMode == USERLIST_MODE_FORWARD  ) {
        if(mMesiboUIOptions.showRecentInForward)
            mUtilityArray = [[[MesiboInstance getRecentProfiles] filteredArrayUsingPredicate:resultPredicate] mutableCopy];
        mCommonNFilterArray = [[mUsersList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    } else {
        mUtilityArray = [[mUsersList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    }
}



- (void)updateSearchResultsForSearchController:(UISearchController *)aSearchController {
    
    NSString *searchString = aSearchController.searchBar.text;
    [self filterContentForSearchText:searchString
                               scope:[[self.searchController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    if(![searchString isEqualToString:@""] && _mMode==USERLIST_MODE_MESSAGES) {
        mIsMessageSearching = YES;
        [mCommonNFilterArray removeAllObjects];
        
        //Do not set SUMMARY flag for search
        if(mReadSession)
            [mReadSession stop];
        
        mReadSession = [[MesiboReadSession alloc] initWith:self];
        [mReadSession read:100];
        
    }else {
        mIsMessageSearching = NO;
        [self showUserList:YES];
        
    }
    [_mUsersTableView reloadData];
    
    
    return ;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    mIsMessageSearching = NO;
    
    MesiboUiDefaults *opt = [MesiboUI getUiDefaults];
    
    [self.searchController setActive:NO];
    
    [mUtilityArray removeAllObjects];
    [mCommonNFilterArray removeAllObjects];
    if(mMesiboUIOptions.showRecentInForward)
        mUtilityArray = [[MesiboInstance getRecentProfiles] mutableCopy];
    mCommonNFilterArray = [mUsersList mutableCopy];
    
    [self refreshTable];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_mUiDelegate) {
        MesiboUserListRow *mrow = [self mesiboRowForIndexPath:indexPath];
        CGFloat height = [_mUiDelegate MesiboUI_onGetCustomRowHeight:mScreen row:mrow];
        
        if(height >= 0) {
            return height;
        }
    }
    
    return 76;
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
    [MesiboCommonUtils setNavigationBarColor:self.navigationController.navigationBar color:mPrimaryColor];
    
    if([_mUiDelegate respondsToSelector:@selector(MesiboUI_onShowScreen:)]) {
        [_mUiDelegate MesiboUI_onShowScreen:mScreen];
    }
    
    [self.searchController setActive:NO];
    [self showUserList:animated];
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    [MesiboInstance setAppInForeground:self screenId:0 foreground:YES];
    int b = [MesiboInstance getConnectionStatus];
    [self updateConnectionStatus:b];
    
    // UI sometime not setting the status after launching, need to be investigated
    [MesiboInstance queueInThread:YES delay:1000 handler:^{
        int b = [MesiboInstance getConnectionStatus];
        if(b == MESIBO_STATUS_ONLINE)
            [self updateConnectionStatus:b];
    }];
    
    NSLog(@"viewDidAppear: userviewcontroller: %d", b);
    
}

-(void) viewDidDisappear:(BOOL)animated {
    //[MesiboInstance setAppInForeground:self screenId:0 foreground:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(_mMode == USERLIST_MODE_FORWARD || USERLIST_MODE_EDITGROUP == _mMode) {
        
        if(mUtilityArray.count==0)
            return 0;
        else
            return SECTION_CELL_HEIGHT;
        
    }
    
    if(!mIsMessageSearching) {
        return  0;
    } else {
        
        if(mUtilityArray.count==0 && section==0)
            return 0;
        if(mCommonNFilterArray.count==0 &&  section==1)
            return 0;
    }
    
    return SECTION_CELL_HEIGHT;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, SECTION_CELL_HEIGHT);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor getColor:BACKGROUND_SEARCH_SECTION_HEAD];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    MesiboUiDefaults *opt = [MesiboUI getUiDefaults];
    
    if(_mMode == USERLIST_MODE_FORWARD || USERLIST_MODE_EDITGROUP == _mMode) {
        if(section==0) {
            if(_mMode == USERLIST_MODE_FORWARD)
                label.text = opt.recentUsersTitle;
            else
                label.text = opt.groupNotMemberTitle;
            
        } else {
            label.text = opt.allUsersTitle;
            
        }
        
        
    } else {
        
        if(section==0) {
            
            if([mUtilityArray count]==0)
                label.text = @"";
            else
                label.text = [NSString stringWithFormat:SEARCH_USERS_STRING, (int)[mUtilityArray count]];
            
            
        }
        else {
            if([mCommonNFilterArray count]==0)
                label.text = @"";
            else
                label.text = [NSString stringWithFormat:SEARCH_MESSAGES_STRING,(int) [mCommonNFilterArray count]];
            
        }
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.0];
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    label.center = view.center;
    label.autoresizingMask = UIViewAutoresizingNone;
    [view addSubview:label];
    return  view;
    
}

-(void)onTypingTimer:(NSTimer *)timer {
    MesiboProfile *mp = (MesiboProfile *) [timer userInfo];
    if(!mp)
        return;
    
    UserData *oud = [UserData getUserDataFromProfile:mp];
    NSIndexPath *index = [oud getUserListPosition];
    if(index)
        [self refreshTable:index];
}

-(BOOL) isSearching {
    return (self.searchController.active && ![self.searchController.searchBar.text isEqualToString:@""]);
}

#pragma mark - Table view data source

-(void) updateCell:(UITableViewCell *)cell index:(NSIndexPath *)indexPath mrow:(MesiboUserListRow *) mrow{
    MesiboProfile *mp = [self getProfileAtIndexPath:indexPath];
    
    if(!mp) {
        return;
    }
    
    UILabel *pName = (UILabel*)[cell viewWithTag:101];
    
    NSString *name = [mp getName];
    if(!name || !name.length) {
        if([mp getAddress])
            name = [mp getAddress];
        else
            name = [NSString stringWithFormat:@"Group %u", [mp getGroupId]];
    }
    
    pName.text = name;
    
    UIImageView *pImage = (UIImageView *)[cell viewWithTag:100];
    [pImage layoutIfNeeded];
    
    UserData *ud = [UserData getUserDataFromProfile:mp];
    [ud setUserListPosition:indexPath];
    
    UIImage *profileImage = [ud getThumbnail];
    
    if(!profileImage) {
        profileImage = [ud getDefaultImage:mMesiboUIOptions.useLetterTitleImage];
        [ud setThumbnail:profileImage];
    }
    
    [pImage setImage:profileImage];
    pImage.layer.cornerRadius = pImage.frame.size.width/2;
    pImage.layer.masksToBounds = YES;
    NSString *messageDetail ;
    
    UILabel *pInfo = (UILabel*)[cell viewWithTag:102];
    UILabel *alertInfo = (UILabel*)[cell viewWithTag:105];
    UILabel *timeDetails = (UILabel*)[cell viewWithTag:104];
    
    if(_mMode != USERLIST_MODE_MESSAGES) {
        
        pInfo.text = @"";
        
        alertInfo.alpha = 0;
        timeDetails.alpha=0;
        if([mp getStatus])
            pInfo.text = [mp getStatus];
        messageDetail = [mp getStatus];
        
    }else {
        
        UserData *oud = [UserData getUserDataFromProfile:mp];
        messageDetail = [oud getLastMessage];
        
        timeDetails.text = [oud getTime];
        
        int newMessage = [oud getUnreadCount];
        
        if(newMessage) {
            alertInfo.hidden = NO;
            [alertInfo layoutIfNeeded];
            alertInfo.layer.cornerRadius = alertInfo.frame.size.height/2;
            alertInfo.layer.masksToBounds = YES;
            alertInfo.text = [NSString stringWithFormat:@"%d",newMessage];
            
        } else {
            alertInfo.hidden = YES;
        }
        
        int status = [oud getMessageStatus];
        
        BOOL typing = [ud isTyping];
        
        if(typing) {
            [pInfo setTextColor:mTypingColor];
            
            NSString *typingText = mMesiboUIOptions.typingIndicationTitle;
            MesiboProfile *typingProfile = [ud getTypingProfile];
            
            if(typingProfile) {
                NSString *name = [typingProfile getName];
                if(!name)
                    name = [typingProfile getAddress];
                
                typingText = [NSString stringWithFormat:@"%@ is %@", name, mMesiboUIOptions.typingIndicationTitle];
            }
            
            [pInfo setText:typingText];
            
        } else {
            [pInfo setTextColor:mStatusColor];
            [self setUserRow:[oud getMessage] OnLabel:pInfo];
        }
        
        [pInfo sizeToFit];
        
    }
    
    if(_mMode ==USERLIST_MODE_FORWARD || _mMode == USERLIST_MODE_GROUPS || _mMode == USERLIST_MODE_EDITGROUP) {
        
        if(cell.accessoryView == nil) {
            
            UIImageView *accView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            if([mp isMarked]) {
                accView.image = [MesiboImage getCheckedImage];
            }else{
                accView.image = [MesiboImage getUnCheckedImage];
            }
            [accView setTag:33];
            cell.accessoryView = accView;
            
        }else {
            
            UIImageView *accView = (UIImageView *)[cell.accessoryView viewWithTag:33];
            if([mp isMarked]) {
                accView.image = [MesiboImage getCheckedImage];
            }else{
                accView.image = [MesiboImage getUnCheckedImage];
            }
        }
    }
    
    [pName sizeToFit];
    [pInfo sizeToFit];
    
    int x = pName.frame.origin.y;
    int x1 = pInfo.frame.origin.y;
    int x2 = pImage.frame.origin.y;
    int height = pName.frame.size.height;
    height += pInfo.frame.size.height;
    int iheight = pImage.frame.size.height;
    
    if(iheight > height)
        height = iheight;
    
    
    if(mrow) {
        mrow.row = cell;
        mrow.name = pName;
        mrow.subtitle = pInfo;
        mrow.timestamp = timeDetails;
        mrow.image = pImage;
        [_mUiDelegate MesiboUI_onUpdateRow:mScreen row:mrow last:YES];
    }
}

-(MesiboUserListRow *) mesiboRowForIndexPath:(NSIndexPath *)indexPath {
    if(!_mUiDelegate) return nil;
    
    MesiboProfile *mp = [self getProfileAtIndexPath:indexPath];
    
    if(!mp) return nil;
    
    MesiboUserListRow *mrow = mMessageRow;
    [mrow reset];
    mrow.profile = mp;
    
    if(_mMode == USERLIST_MODE_MESSAGES) {
        
        UserData *oud = [UserData getUserDataFromProfile:mp];
        mrow.message = [oud getMessage];
    }
    
    return mrow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MesiboUserListRow *mrow = [self mesiboRowForIndexPath:indexPath];
    if(mrow) {
        UITableViewCell *cell = [_mUiDelegate MesiboUI_onGetCustomRow:mScreen row:mrow];
        
        if(cell)
            return cell;
    }
    
    static NSString * resueIdentifier = @"cells";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:resueIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:resueIdentifier];
        
    }
    
    UIColor *altCellColor = [UIColor whiteColor];
    if(mMesiboUIOptions.userListBackgroundColor > 0) {
        altCellColor = [UIColor getColor:mMesiboUIOptions.userListBackgroundColor];
    }
    
    cell.backgroundColor = altCellColor;
    
    [self updateCell:cell index:indexPath mrow:mrow];
    
    
    return cell;
}

-(NSString *)trim:(NSString *)string {
    return [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(void)setUserRow:(MesiboMessage *)m OnLabel:(UILabel *)lbl{
    int status = [m getStatus];
    UIImage *statusImage = [MesiboImage getStatusIcon:status];
    NSString *strText = m.message;
    
    if(!strText) {
        strText = @"";
    }
    
    if(!lbl) return;
    
    NSTextAttachment *messageStatus = [[NSTextAttachment alloc] init];
    NSTextAttachment *messageType = [[NSTextAttachment alloc] init];
    
    if([m isDeleted]) {
        messageType.image = [MesiboImage getDeletedMessageIcon];
        strText = mMesiboUIOptions.deletedMessageTitle;
        statusImage = nil;
    }
    else if([m hasImage])
        messageType.image = [MesiboImage imageNamed:@"ic_photo_18pt" color:USERLIST_ICON_COLOR];
    else if([m hasVideo])
        messageType.image = [MesiboImage imageNamed:@"ic_videocam_18pt" color:USERLIST_ICON_COLOR];
    else if([m hasDocument])
        messageType.image = [MesiboImage imageNamed:@"ic_attach_file_18pt" color:USERLIST_ICON_COLOR];
    else if([m hasLocation])
        messageType.image = [MesiboImage imageNamed:@"ic_location_on_18pt" color:USERLIST_ICON_COLOR];
    else if([m isMissedCall] && [m isVideoCall])
        messageType.image = [MesiboImage getMissedCallIcon:YES];
    else if([m isMissedCall] && ![m isVideoCall])
        messageType.image = [MesiboImage getMissedCallIcon:NO];
    
    if(messageType.image) {
        messageType.bounds = CGRectIntegral( CGRectMake(0, -3, USERLIST_STATUS_ICON_SIZE, USERLIST_STATUS_ICON_SIZE));
    }
    
    if(statusImage) {
        
        messageStatus.image = statusImage;
        messageStatus.bounds = CGRectIntegral( CGRectMake(0, -3, USERLIST_STATUS_ICON_SIZE, USERLIST_STATUS_ICON_SIZE));
        
    }
    
    NSString* newString = strText;
    
    
    NSMutableAttributedString *attachmentString = nil;
    NSMutableAttributedString *subAttachmentString = nil;
    NSMutableAttributedString *finalString = nil;
    
    
    if(nil != messageStatus)
        attachmentString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:messageStatus]];
    
    if(nil != messageType)
        subAttachmentString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:messageType]];
    
    finalString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableAttributedString *myString = nil;
    if(newString)
        myString= [[NSMutableAttributedString alloc] initWithString:newString];

    NSMutableAttributedString *space= [[NSMutableAttributedString alloc] initWithString:@""];
    
    if(statusImage) {
        [finalString appendAttributedString:attachmentString];
        [finalString appendAttributedString:space];
    }
    
    if(messageType.image) {
        [finalString appendAttributedString:subAttachmentString];
        [finalString appendAttributedString:space];
    }
    
    if(statusImage || messageType.image)
        [finalString appendAttributedString:space];
    
    [finalString appendAttributedString:myString];
    if(lbl)
        lbl.attributedText = finalString;
}

-(MesiboProfile *) getProfileAtIndexPath:(NSIndexPath *)indexPath {
    MesiboProfile *mp = nil;
    
    @try {
        
        if(_mMode == USERLIST_MODE_FORWARD || _mMode == USERLIST_MODE_EDITGROUP ) {
            
            if(indexPath.section == 0) {
                if(mUtilityArray.count > indexPath.row)
                    mp =[mUtilityArray objectAtIndex:indexPath.row];
            }
            else {
                if(mCommonNFilterArray.count > indexPath.row)
                    mp =[mCommonNFilterArray objectAtIndex:indexPath.row];
            }
            
            
        } else {
            //mp =[mUsersList objectAtIndex:indexPath.row];
            if ([self isSearching]) {
                if(indexPath.section==0)
                    mp =[mUtilityArray objectAtIndex:indexPath.row];
                else
                    mp =[mCommonNFilterArray objectAtIndex:indexPath.row];
            }else {
                if(mUsersList.count > indexPath.row)
                    mp =[mUsersList objectAtIndex:indexPath.row];
            }
            
        }
    } @catch(NSException *e) {
        mp = nil;
        NSLog(@"Exception getProfileAtIndexPath: mode %d searching %d section %d %@", _mMode, [self isSearching]?1:0, (int) indexPath.section, e);
    }
    
    
    return mp;
}

-(void) showProfile:(MesiboProfile *) profile {
    MesiboMessageScreenOptions *opts = [MesiboMessageScreenOptions new];
    opts.profile = profile;
    opts.listener = _mUiDelegateForMessageView;
    [MesiboUI launchMessaging:self opts:opts];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MesiboProfile *mp = [self getProfileAtIndexPath:indexPath];
    
    if(self.mMode== USERLIST_MODE_FORWARD || _mMode == USERLIST_MODE_GROUPS || _mMode == USERLIST_MODE_EDITGROUP) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *accView = (UIImageView *)[cell.accessoryView viewWithTag:33];
        
        if([mp isMarked]) {
            accView.image = [MesiboImage getUnCheckedImage];
        }else{
            accView.image = [MesiboImage getCheckedImage];
        }
        [mp toggleMark];
        
        [_mUsersTableView reloadData];
        return;
    }
    
    if(mMesiboUIOptions.createGroupTitle && [[mp getName] isEqualToString:mMesiboUIOptions.createGroupTitle]){
        [MesiboUIManager launchUserListViewcontroller:self  withChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"UserListViewController"] withContactChooser:USERLIST_MODE_GROUPS withForwardMessageData:nil withMembersList:nil withForwardGroupName:nil withForwardGroupid:0];
        return;
    }
    
    mp = [MesiboInstance getProfile:[mp getAddress] groupid:[mp getGroupId]];
    
    [self showProfile:mp];
    
    self.searchController.active = NO;
    
}


-(void)tableView:(UITableView *)tableView didDeSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.mMode==USERLIST_MODE_FORWARD || _mMode == USERLIST_MODE_GROUPS || _mMode == USERLIST_MODE_EDITGROUP) {
        //cv.forwardedMesage = _fwdMessage;
        MesiboProfile *mp;
        if ([self isSearching]) {
            mp =[mUtilityArray objectAtIndex:indexPath.row];
            
        }else {
            mp =[mUsersList objectAtIndex:indexPath.row];
        }
        
        [mp setMark:NO];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *accView = (UIImageView *)[cell.accessoryView viewWithTag:33];
        accView.image = [MesiboImage getUnCheckedImage];
        
    }
    return;
    
}

-(void) forwardToContact:(MesiboProfile *) profile {
    [profile setMark:NO];
    MesiboMessageProperties *mesiboParamsUser = (MesiboMessageProperties *) [[MesiboMessageProperties alloc] init];
    
    MesiboMessage *m = [profile newMessage];
    [m setForwarded:_forwardIds];
    [m send];
    return;
}

-(void) forwardMessageToContacts {
    
    MesiboProfile *profile = nil, *forwardTo = nil;
    int count = 0;
    for(int i=0;  i< mUtilityArray.count; i++) {
        profile= [mUtilityArray objectAtIndex:i];
        
        if([profile isMarked]) {
            forwardTo = profile;
            [self forwardToContact:profile];
            count++;
        }
    }
    
    
    for(int i=0;  i< mCommonNFilterArray.count; i++) {
        profile= [mCommonNFilterArray objectAtIndex:i];
        if([profile isMarked]) {
            forwardTo = profile;
            [self forwardToContact:profile];
            //NSArray *p = [MesiboInstance getRecentProfiles];
            count++;
        }
    }
    
    if(!count) {
        [MesiboUIAlerts showDialogue:FORWARD_ALERT_MESSAGE withTitle:FORWARD_ALERT_TITLE];
    } else {
        
        if(count > 1) {
            [self.navigationController popViewControllerAnimated:NO];
            //[self dismissViewControllerAnimated:NO completion:nil];
            return;
        }
        
        [self showProfile:forwardTo];

        
    }
    
    
}

-(void) createNewGroup {
    [mSelectedMembers removeAllObjects];
    
    // We must add members from original array because they won't be in mUserList
    for(int i=0;  i< mGroupMembers.count; i++) {
        MesiboProfile *profile= [mGroupMembers objectAtIndex:i];
        if([profile isMarked]) {
            [profile setMark:NO];
            [mSelectedMembers addObject:profile];
            
        }
    }
    
    for(int i=0;  i< mUsersList.count; i++) {
        MesiboProfile *profile= [mUsersList objectAtIndex:i];
        if([profile isMarked]) {
            [profile setMark:NO];
            [mSelectedMembers addObject:profile];
        }
    }
    
    if(![mSelectedMembers count]) {
        [MesiboUIAlerts showDialogue:CREATE_NEW_GROUP_ALERT_MESSAGE withTitle:CREATE_NEW_GROUP_ALERT_TITLE];
        
    } else {
        
        [MesiboUIManager launchCreateNewGroupController:self withMemeberProfiles:mSelectedMembers existingMembers:mGroupMembers  withGroupId:_mForwardGroupid modifygroup:(_mMode == USERLIST_MODE_EDITGROUP) uidelegate:_mUiDelegate];
        
    }
}

-(void) deleteConversation:(MesiboProfile *)mp indexPath:(NSIndexPath *)indexPath {
    
    if(_mMode != USERLIST_MODE_MESSAGES) {
        [mUsersList removeObjectAtIndex:indexPath.row];
        [_mUsersTableView beginUpdates];
        [_mUsersTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_mUsersTableView endUpdates];
        
    } else {
        
        [mUsersList removeObjectAtIndex:indexPath.row];
        if(mUsersList.count > 0) {
            [_mUsersTableView beginUpdates];
            [_mUsersTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_mUsersTableView endUpdates];
        } else {
            [_mUsersTableView reloadData];
        }
        [MesiboInstance deleteMessages:[mp getAddress] groupid:[mp getGroupId] ts:0];
    }
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundView = nil;
    
    if(_mMode == USERLIST_MODE_FORWARD || USERLIST_MODE_EDITGROUP == _mMode ||  mIsMessageSearching) {
        int count = 0;
        count += (mUtilityArray.count > 0) ? 1:0;
        count += (mCommonNFilterArray.count > 0) ? 1:0;
        if(count > 0)
            return 2;
        
    } else { //if (_mNewContactChooser == USERLIST_MODE_MESSAGES) {
        if(mUsersList.count > 0)
            return 1;
    }
    
    
    int margin = (self.view.bounds.size.width*10)/100; // 10% on each side
    UIView *marginView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    marginView.backgroundColor = [UIColor clearColor];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-1)];
    [marginView addSubview:messageLabel];
    
    messageLabel.text = mMesiboUIOptions.emptyUserListMessage;
    if ([self isSearching])
        messageLabel.text = mMesiboUIOptions.emptySearchListMessage;
    
    messageLabel.textColor = [UIColor getColor:mMesiboUIOptions.emptyUserListMessageColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = mMesiboUIOptions.emptyUserListMessageFont;
    
    
    UIFont * const font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular]; // Change to your own label font.
    
    CGSize const size = CGSizeMake(INFINITY, 18); // 18 is height of label.
    
    CGFloat const textWidth = [messageLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: messageLabel.font} context:nil].size.width;
    
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [messageLabel.widthAnchor constraintEqualToAnchor:marginView.widthAnchor constant:-50].active = YES;
    [messageLabel.centerXAnchor constraintEqualToAnchor:marginView.centerXAnchor].active = YES;
    [messageLabel.centerYAnchor constraintEqualToAnchor:marginView.centerYAnchor].active = YES;
    
    [messageLabel sizeToFit];
    
    self.tableView.backgroundView = marginView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if(_mMode==USERLIST_MODE_FORWARD || USERLIST_MODE_EDITGROUP == _mMode) {
        return NO;
    }
    
    return YES;
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak __typeof(self) weakSelf = self;
    
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    
    UITableViewRowAction *unreadRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:opts.unreadTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        __typeof(self) strongSelf = weakSelf;
        MesiboProfile *mp = [mUsersList objectAtIndex:indexPath.row];
        
        [mp unread];
        [self refreshTable];
        return;
        
    }];
    
    unreadRow.backgroundColor = [UIColor getColor:opts.unreadButtonColor];
    
    UITableViewRowAction *deleteRow = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:opts.deleteTitle handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        __typeof(self) strongSelf = weakSelf;
        MesiboProfile *mp = [mUsersList objectAtIndex:indexPath.row];
        
        
        
        NSString *prompt = [NSString stringWithFormat:opts.deleteAlertTitle, [mp getNameOrAddress:@"+"]];
        
        
        
        [MesiboUIAlerts showPrompt:prompt withTitle:opts.deleteMessagesTitle actionTitle:opts.deleteTitle cancelTitle:opts.cancelTitle alertStyle:NO completion:^(BOOL result) {
            if(!result) return;
            
            // if new messages received, row may have changed, don't delete in that case
            MesiboProfile *updatedMp = [mUsersList objectAtIndex:indexPath.row];
            if(updatedMp != mp) return;
            
            [strongSelf deleteConversation:mp indexPath:indexPath];
            return;
        }];
        
        return;
        
    }];
    
    deleteRow.backgroundColor = [UIColor getColor:opts.deleteButtonColor];
    
    //disabled for now till we add Archive option
#if 0
    UITableViewRowAction *archive = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:ARCHIVE_TITLE_STRING handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        
        
    }];
    archive.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
    
    
    if(_mNewContactChooser != USERLIST_MODE_MESSAGES)
        return @[deleteRow]; //return @[], we don't want to
    else
        return @[deleteRow, archive];
    
#else
    if(_mMode != USERLIST_MODE_MESSAGES)
        return @[]; // we don't allow deleting contact, TBD, this should be customizable
    else
        return @[unreadRow, deleteRow];
#endif
    
}


-(void)dealloc {
    [_searchController.view removeFromSuperview]; // It works!
}
@end







