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

#import "MesiboMessageViewHolder.h"
#import "MesiboMessageViewController.h"
//#import "ImageViewer.h"
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIImage+Tint.h"
#import "UIColors.h"
#import "MesiboImage.h"
#import "Includes.h"
#import "MesiboUIManager.h"
#import "MesiboConfiguration.h"
#import "LetterTitleImage.h"

#define BUBBULE_TOP_MARGIN  8
#define BUBBLE_BOTTOM_MARGIN 5
#define BUBBLE_LEFT_MARGIN  10

#define BUBBLE_RIGHT_MARGIN 10


#define OUTGOINGBUBBLE_TO_SCREEN_RIGHT_MARGIN   10
#define INCOMINGBUBBLE_TO_SCREEN_LEFT_MARGIN   10

//with extra space of 5
#define FAVORITE_ICON_WIDTH 25
#define SINGLIE_LINE_HEIGHT 35

/*
 @implementation UITextView (DisableCopyPaste)
 
 - (BOOL)canBecomeFirstResponder
 {
 return NO;
 }
 
 @end*/

#define RIGHT_OUT_MARGIN    4

@interface MesiboMessageViewHolder() {
    UIView *_parentView;
    
    UIImageView *_chatPicture;
    UITextView *_messageLabel;
    UILabel *_timeLabel;
    UILabel *_senderName;
    UIView *_replyView;
    UIImageView *_bubbleChatImage;
    UIImageView *_statusIcon;
    UIImageView *_favoriteIcon;
    MesiboMessage * _message;
    MesiboMessageView *_uiData;
    UILabel *_titleLabel;
    ThumbnailProgressView *_mDownloadProgressView;
    UIImageView *_audioVideoPlayLayer;
    
    bool isDownloading ;
    int mFavoriteIconWidth;
    bool mIstimeLabelOverPicture;
    UIButton *mAccessoryView;
    NSIndexPath *mIndexPath;
    
    CGFloat _mLeft_x;
    CGFloat _mRight_x;
    
    CGFloat _screenWidth;
    
    CGFloat max_witdh ;
    CGFloat pic_max_witdh ;
    CGFloat pos_y;
    CGFloat pos_x;
    UIViewAutoresizing globlResizing;
}
@end

@implementation MesiboMessageViewHolder

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _screenWidth = screenRect.size.width;
    max_witdh = 0.75*_screenWidth;
    pic_max_witdh = [MesiboInstance getMessageWidthInPoints];
    
    _mLeft_x = BUBBLE_LEFT_MARGIN + INCOMINGBUBBLE_TO_SCREEN_LEFT_MARGIN;
    _mRight_x = self.contentView.frame.size.width  - (BUBBLE_RIGHT_MARGIN + OUTGOINGBUBBLE_TO_SCREEN_RIGHT_MARGIN);
    
    if (self) {
        // Helpers
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        _messageLabel = [[UITextView alloc] init];
        _chatPicture = [[UIImageView alloc] init];
        
        _bubbleChatImage = [[UIImageView alloc] init];
        _timeLabel = [[UILabel alloc] init];
        _statusIcon = [[UIImageView alloc] init];
        _senderName =[[UILabel alloc] init];
        _titleLabel = [[UILabel alloc]init];
        _favoriteIcon = [[UIImageView alloc] init];
        _replyView = [[UIView alloc] init];
        _audioVideoPlayLayer = [[UIImageView alloc] init];
        
        _mDownloadProgressView = [[ThumbnailProgressView alloc] init];
        uint32_t toolbarColor = [MesiboInstance getUiOptions].mToolbarColor;
        UIColor *color = nil;
        if(toolbarColor)
            color = [UIColor getColor:toolbarColor];
        
        [_mDownloadProgressView config:nil progressColor:nil tickColor:color lineWidth:0 arrowUp:NO];
        
        [self.contentView addSubview:_bubbleChatImage];
        [self.contentView addSubview:_senderName];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_chatPicture];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_statusIcon];
        [self.contentView addSubview:_favoriteIcon];
        [self.contentView addSubview:_replyView];
        
        
        
        _messageLabel.delegate = self;
        [_messageLabel canBecomeFirstResponder ];
        [_chatPicture addSubview:_audioVideoPlayLayer];
        [_chatPicture addSubview:_mDownloadProgressView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(singleTapGestureCaptured)];
        [_bubbleChatImage addGestureRecognizer:singleTap];
        [_bubbleChatImage setMultipleTouchEnabled:YES];
        [_bubbleChatImage setUserInteractionEnabled:YES];
        
    }
    
    return self;
}


-(MesiboMessageView *) getMessage {
    return _uiData;
}

-(void) setMessage:(MesiboMessageView *)uidata indexPath:(NSIndexPath *)indexPath {
    _uiData = uidata;
    _message = [uidata getMesiboMessage];
    
    [self buildCell];
    [_uiData setHeight:self.height];
    mIndexPath = indexPath;
}


-(void)buildCell {
    [self resetCell];
    
    _mLeft_x = BUBBLE_LEFT_MARGIN + INCOMINGBUBBLE_TO_SCREEN_LEFT_MARGIN;
    _mRight_x = self.contentView.frame.size.width  - (BUBBLE_RIGHT_MARGIN + OUTGOINGBUBBLE_TO_SCREEN_RIGHT_MARGIN);
    pos_x=0;
    pos_y=BUBBULE_TOP_MARGIN;
    
    
    if([_message isCustom] || [_message isMissedCall]) {
        globlResizing = UIViewAutoresizingFlexibleRightMargin;
        [self setCustomCell];
        [self setNeedsLayout];
        return;
    }
    
    if(MESSAGEVIEW_TIMESTAMP == [_uiData getType]) {
        [self setDateCell];
        [self setNeedsLayout];
        return;
    }
    
    globlResizing = UIViewAutoresizingFlexibleLeftMargin;
    
#if 0
    if(_message.mIsFavorite)
        mFavoriteIconWidth = FAVORITE_ICON_WIDTH;
    else
        mFavoriteIconWidth = 0;
#else
    mFavoriteIconWidth = 0;
#endif
    
    if([_message isIncoming]){
        globlResizing = UIViewAutoresizingFlexibleRightMargin;
        if([_message getGroupId] > 0 && _uiData.mShowName)
            [self setSenderName]; // clear doubsts about gid . . ..
    }
    
    if(_uiData.mIsReplyEnabled) {
        [self setReplyView];
        
    } else if([_message hasMedia]) {
        [self setChatPicture];
        if([[_uiData getTitle] length]){
            [self setTitleLabel];
        }
    }
    
    [self measureTimeLabelFrame];
    if([[_uiData getMessage] length]==0) {
        [self setTimeLabel];
        
    }else {
        [self setTextView];
        [self setTimeLabel];
    }
    [self setBubble];
    [self addStatusIcon];
    [self setStatusIcon];
    [self addFavoriteIcon];
    [self setNeedsLayout];
}
#pragma mark resetCell

- (void) resetCell {
    mAccessoryView = nil;
    
    
    _chatPicture.image = nil;
    _chatPicture.frame = CGRectMake(0, 0, 0, 0);
    _statusIcon.frame = CGRectMake(0, 0, 0, 0);
    _bubbleChatImage.frame = CGRectMake(0, 0, 0, 0);
    _messageLabel.frame =CGRectMake(0, 0, 0, 0);
    _timeLabel.frame =CGRectMake(0, 0, 0, 0);
    _senderName.frame =CGRectMake(0, 0, 0, 0);
    _titleLabel.frame =CGRectMake(0, 0, 0, 0);
    _mDownloadProgressView.frame =CGRectMake(0, 0, 0, 0);
    _audioVideoPlayLayer.frame =CGRectMake(0, 0, 0, 0);
    _favoriteIcon.frame =CGRectMake(0, 0, 0, 0);
    _replyView.frame =CGRectMake(0, 0, 0, 0);
    
    //_chatPicture.image = nil;
    _messageLabel.text = nil;
    _bubbleChatImage.image = nil;
    _timeLabel.text = nil;
    _statusIcon.image = nil;
    _senderName.text = nil;
    _titleLabel.text = nil;
    _mDownloadProgressView.hidden = YES;
    _audioVideoPlayLayer.hidden = YES;
    isDownloading = NO;
    _favoriteIcon.image = nil;
    NSArray *viewsToRemove = [_replyView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
}

- (void) setCustomCell {
    
    
    NSString *msg = [_uiData getMessage];
    UIImage *image = [_uiData getCustomImage];
        
    if(image) {
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
        imageAttachment.image = image;
        CGFloat imageOffsetY = -5.0;
        imageAttachment.bounds = CGRectMake(0, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@""];
        [completeText appendAttributedString:attachmentString];
        NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:msg];
        [completeText appendAttributedString:textAfterIcon];
        
        
        _messageLabel.textAlignment=NSTextAlignmentRight;
        _messageLabel.attributedText=completeText;
        
    } else {
        _messageLabel.text = msg;
    }
    
    _messageLabel.frame = CGRectMake(0, 0, max_witdh, MAXFLOAT);
    
    _messageLabel.font = [UIFont systemFontOfSize:MESSAGE_FONT_SIZE_CUSTOM];
    //_messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    _messageLabel.backgroundColor = [UIColor getColor:[_uiData getCustomColor]];
    _messageLabel.userInteractionEnabled = NO;
//    _messageLabel.scrollEnabled = NO;
    _messageLabel.editable = NO;
    _messageLabel.textColor=[UIColor getColor:MESSAGE_FONT_COLOR_NORMAL];
    
    _messageLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    
    
    [_messageLabel sizeToFit];
    
    CGFloat textView_w = _messageLabel.frame.size.width;
    CGFloat textView_h = _messageLabel.frame.size.height;
    
    CGFloat textView_x = (_screenWidth - textView_w)/2;
    CGFloat textView_y = pos_y;
    
    //_messageLabel.layer.cornerRadius = textView_h/2;
    _messageLabel.layer.cornerRadius = 5;
    _messageLabel.layer.masksToBounds = true;
    
    _messageLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    
    _messageLabel.autoresizingMask = globlResizing;
    _messageLabel.hidden = NO;
    pos_y += _messageLabel.frame.size.height ;
}

-(void)setDateCell {
    
    _messageLabel.text = [_uiData getDate];
    _messageLabel.frame = CGRectMake(0, 0, max_witdh, MAXFLOAT);
    
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    //_messageLabel.font = [UIFont fontWithName:MESSAGE_DATE_FONT_NAME size:MESSAGE_DATE_FONT_SIZE+5];
    //[_messageLabel sizeToFit];
    _messageLabel.font = [UIFont fontWithName:MESSAGE_DATE_FONT_NAME size:MESSAGE_DATE_FONT_SIZE];
    _messageLabel.textColor = [UIColor getColor:MESSAGE_DATE_FONT_COLOR];
    _messageLabel.backgroundColor = [UIColor getColor:SYSTEM_MESSAGES_BACKGROUND_COLOR];
    //_messageLabel.layer.cornerRadius = MESSAGE_DATE_LABEL_CORNER_RADIUS;
    //_messageLabel.layer.masksToBounds = YES;
    _messageLabel.autoresizingMask = UIViewAutoresizingNone;
    
    _messageLabel.editable = NO;
    _messageLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [_messageLabel sizeToFit];
    
    CGFloat textView_w = _messageLabel.frame.size.width;
    CGFloat textView_h = _messageLabel.frame.size.height;
    
    CGFloat textView_x = (_screenWidth - textView_w)/2;
    CGFloat textView_y = pos_y;
    
    //_messageLabel.layer.cornerRadius = textView_h/2;
    _messageLabel.layer.cornerRadius = 5;
    _messageLabel.layer.masksToBounds = true;
    
    _messageLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    
    _messageLabel.autoresizingMask = globlResizing;
    _messageLabel.hidden = NO;
    pos_y += _messageLabel.frame.size.height ;
}

#pragma mark - setsenderName

- (void) setSenderName {
    
    UIFont *fontz = [UIFont systemFontOfSize:15];
    _senderName.text = [_message getSenderName];
    _senderName.textColor = [LetterTitleImage textColor:_senderName.text];
    _senderName.font = fontz;
    _senderName.userInteractionEnabled = NO;
    _senderName.alpha = 0.7;
    _senderName.textAlignment = NSTextAlignmentLeft;
    
    [_senderName sizeToFit];
    CGFloat sender_x = _mLeft_x;
    CGFloat sender_y = pos_y;
    CGFloat sender_w = _senderName.frame.size.width;
    CGFloat sender_h = _senderName.frame.size.height;
    
    _senderName.autoresizingMask = globlResizing;
    _senderName.frame = CGRectMake(sender_x, sender_y, sender_w, sender_h);
    
    pos_y+= sender_h;
    
    //pos_y+=3;
}

- (void) setReplyView {
    
    CGFloat picView_x;
    CGFloat picView_y;
    CGFloat picView_w = pic_max_witdh;
    CGFloat picView_h = picView_w;
    
    if ([_message isIncoming]){
        picView_x = _mLeft_x;
        
    }else {
        picView_x = _mRight_x - picView_w;
    }
    picView_y = pos_y;
    
    _replyView.autoresizingMask = globlResizing;
    
    UIView *testView;
    if(nil != _uiData.mReplyImage) {
        testView = [[_uiData.mReplyBundle loadNibNamed:@"ReplyImageView" owner:self options:nil] objectAtIndex:0];
    }else {
        testView = [[_uiData.mReplyBundle loadNibNamed:@"ReplyOnlyTextView" owner:self options:nil] objectAtIndex:0];
    }
    
    testView.frame = CGRectMake(0, 0, pic_max_witdh, 10);
    [testView setNeedsLayout];
    [testView layoutIfNeeded];
    
    UILabel *namelabel = [testView viewWithTag:100];
    if(nil != _uiData.mReplyUserName)
        namelabel.text = _uiData.mReplyUserName;
    else
        namelabel.text = @"Unknown User";
    
    UILabel *messagelabel = [testView viewWithTag:101];
    if(nil != _uiData.mReplyMessage)
        messagelabel.text = _uiData.mReplyMessage;
    else
        messagelabel.text = @"";
    
    [messagelabel sizeToFit];
    
    picView_h = 5 + CGRectGetMaxY(messagelabel.frame);
    
    UIImageView *imageView = [testView viewWithTag:102];
    if(nil != _uiData.mReplyImage && nil != imageView) {
        imageView.image = _uiData.mReplyImage;
    }
    
    testView.layer.cornerRadius = 5;
    testView.layer.masksToBounds = YES;
    
    _replyView.frame = CGRectMake(picView_x, picView_y, pic_max_witdh, picView_h);
    testView.frame = CGRectMake(0, 0, testView.frame.size.width, picView_h);
    
    [_replyView addSubview:testView];
    pos_y +=_replyView.frame.size.height+3;
    
}

#pragma mark - ChatPicture

- (void) setChatPicture {
    
    CGFloat picView_x;
    CGFloat picView_y;
    CGFloat picView_w = pic_max_witdh;
    CGFloat picView_h = picView_w;
    
    if ([_message isIncoming]){
        picView_x = _mLeft_x;
        
    }else {
        picView_x = _mRight_x - picView_w;
    }
    picView_y = pos_y;
    
    
    _chatPicture.autoresizingMask = globlResizing;
    
    if([_message hasMedia] && _message.media.location)
        picView_h = ((float)picView_w  * 2 )/ 3;
    
    _chatPicture.frame = CGRectMake(picView_x, picView_y, picView_w, picView_h);
    
    _chatPicture.image = [_uiData getThumbnail];
    
    //UIView *downloadVu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    if([_message hasMedia] && (_message.media.location || [_message.media.file isTransferred])) {
        _mDownloadProgressView.hidden = YES;
    } else {
        _mDownloadProgressView.hidden = NO;
        _mDownloadProgressView.frame = CGRectMake(0, 0, FILE_PROGRESS_SIZE, FILE_PROGRESS_SIZE);
        _mDownloadProgressView.mArrowDirectionUp = !([_message isIncoming]);
        _mDownloadProgressView.center = [_chatPicture convertPoint:_chatPicture.center fromView:_chatPicture.superview];
        [_mDownloadProgressView setCircularState:FFCircularStateIcon];
        
    }
    
    [self setPlayerView];
    
    /*
     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
     action:@selector(singleTapGestureCaptured)];
     [_chatPicture addGestureRecognizer:singleTap];
     [_chatPicture setMultipleTouchEnabled:YES];
     [_chatPicture setUserInteractionEnabled:YES];
     */
    pos_y +=_chatPicture.frame.size.height+3;
    
    
}


- (void) setTitleLabel {
    
    _titleLabel.frame = CGRectMake(0, 0, max_witdh, MAXFLOAT);
    
    if([_message hasMedia]){
        _titleLabel.frame = CGRectMake(0, 0, _chatPicture.frame.size.width, MAXFLOAT);
    }
    
    _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:TITLE_FONT_SIZE];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.clipsToBounds = YES;
    _titleLabel.userInteractionEnabled = NO;
    _titleLabel.textColor=[UIColor getColor:TITLE_COLOR];
    
    _titleLabel.text=[_uiData getTitle];
    [_titleLabel sizeToFit];
    
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_w = _chatPicture.frame.size.width;
    CGFloat textView_h = _titleLabel.frame.size.height;
    
    pos_y = pos_y +5 ;
    
    if ([_message isIncoming]){
        textView_x = _mLeft_x;
        
    }else {
        textView_x = _mRight_x - textView_w;
    }
    textView_y = pos_y;
    
    if([_message hasMedia]) {
        textView_x = _chatPicture.frame.origin.x;
    }
    _titleLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    _titleLabel.autoresizingMask = globlResizing;
    pos_y +=_titleLabel.frame.size.height +5 ;
    
}

-(UIView *) getAccessoryView {
    if(MESSAGEVIEW_MESSAGE != [_uiData getType])
        return nil;
    
    if(![super isSelectionMode]) {
        mAccessoryView = nil;
        return nil;
    }
    
    if(!mAccessoryView) {
        //mAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        mAccessoryView =  [UIButton buttonWithType:UIButtonTypeCustom];
        
        //Apple's iPhone Human Interface Guidelines recommends a minimum target size of 44 pixels wide 44 pixels tall
        [mAccessoryView setFrame:CGRectMake(0, 0, 44, 44)];
        
        [mAccessoryView addTarget:self action:@selector(onMessageSelectButton:)forControlEvents:UIControlEventTouchUpInside];
    }
    /*
     if([_message isSelected])
     mAccessoryView.image = [MesiboImage getCheckedImage];
     else
     mAccessoryView.image = [MesiboImage getUnCheckedImage];
     */
    
    [mAccessoryView addTarget:self action:@selector(onMessageSelectButton:)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *image = nil;
    if([super isSelected:_uiData])
        image = [MesiboImage getCheckedImage];
    else
        image = [MesiboImage getUnCheckedImage];
    
    [mAccessoryView setImage:image forState:UIControlStateNormal];
    
    return mAccessoryView;
}

-(IBAction)onMessageSelectButton:(id)sender  {
    [self singleTapGestureCaptured];
}

-(void) clicked {
    [self singleTapGestureCaptured];
}

#pragma mark = singleTapGestureCaptured
- (void) singleTapGestureCaptured {
    
    if([super isSelectionMode]) {
        [super addSelectedMessage:_uiData];
        return;
    }
    
    // Don't do this, this seems to be disable further actions
    //[_chatPicture setMultipleTouchEnabled:YES];
    //[_chatPicture setUserInteractionEnabled:YES];
    
    
    if(![_message hasMedia])
        return;
    
    if(_message.media.location) {
        [self openActionSheet:nil];
        return;
    }
    
    MesiboFileInfo *file = _message.media.file;
    if(!file) return;
    //int type = file.type;
    
    if(![file isTransferred]) {// image video not downloaded  then
        
        if(isDownloading || [file getStatus] == MESIBO_FILESTATUS_INPROGRESS) {
            [MesiboInstance stopFileTransfer:file];
            [self stopProgressBar];
            return;
        }
        
        isDownloading = YES;
        [_mDownloadProgressView startSpinProgressBackgroundLayer];
        //[_downloadVu setCircularState:FFCircularStateStopSpinning];
        file.userInteraction = true;
        
        //TBD, temporary, till API issue is fixed
        MesiboParams *p = [file getParams];
        if(p && p.expiry == 0)
            p.expiry = DEFAULT_MSGPARAMS_EXPIRY;
        
        if(![MesiboInstance startFileTransfer:file])
            [self stopProgressBar];
        
    }else {
        if(file.type ==MESIBO_FILETYPE_VIDEO || file.type ==MESIBO_FILETYPE_AUDIO){
            
            [MesiboUIManager showVideofile:[self getParent] withVideoFilePath:[file getPath]];
            
        }
        else if(file.type == MESIBO_FILETYPE_IMAGE){
            [MesiboUIManager showImageInViewer:[self getParent] withImage:[_uiData getImage] withTitle:[_message getSenderName]];
            
        } else {
            
            [MesiboUIManager openGenericFiles:[self getParent] withFilePath:[file getPath]];
            
        }
        
    }
}

-(void) setPlayerView {
    if(![_message hasMedia] || !_message.media.file || ![_message.media.file isTransferred])
        return;

    
    if(_message.media.file.type == MESIBO_FILETYPE_VIDEO || _message.media.file.type == MESIBO_FILETYPE_AUDIO) {
        _audioVideoPlayLayer.hidden = NO;
        _audioVideoPlayLayer.userInteractionEnabled = NO;
        _audioVideoPlayLayer.frame = _chatPicture.frame;
        _audioVideoPlayLayer.center = [_chatPicture convertPoint:_chatPicture.center fromView:_chatPicture.superview];
        _audioVideoPlayLayer.backgroundColor = [UIColor getColor:SEMI_TANSPERENT_COLOR];
        _audioVideoPlayLayer.image = [MesiboImage getAudioVideoPlayImage];
        _audioVideoPlayLayer.contentMode = UIViewContentModeCenter;
    } else {
        _audioVideoPlayLayer.hidden = YES;
        
    }
}

- (void) setProgress:(int) progress {
    
    float i = ((float)progress / 100 );
    
    if(!isDownloading) {
        isDownloading = YES;
        [_mDownloadProgressView startSpinProgressBackgroundLayer];
        //[_mDownloadProgressView setCircularState:FFCircularStateIcon];
    }
    
    [_mDownloadProgressView stopSpinProgressBackgroundLayer];
    [_mDownloadProgressView setProgress:i];
    
    return;
}

- (void) startProgressBar {
    [_mDownloadProgressView startSpinProgressBackgroundLayer];
    [_mDownloadProgressView setCircularState:FFCircularStateIcon];
    
}

- (void) stopProgressBar {
    isDownloading = NO;
    if(![_message hasMedia] || !_message.media.file || ![_message.media.file isTransferred])
        return;
    
    if([_message.media.file isTransferred]) {
        [self setPlayerView];
        if(_message.media.file.mode == MESIBO_FILEMODE_DOWNLOAD) {
            _mDownloadProgressView.hidden = YES;
            return;
        }
        
        //momemntary display upload successful
        [_mDownloadProgressView  setCircularState:  FFCircularStateCompleted];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _mDownloadProgressView.hidden = YES;
        });
    } else {
        [_mDownloadProgressView stopSpinProgressBackgroundLayer];
        [_mDownloadProgressView setProgress:0];
        [_mDownloadProgressView  setCircularState:  FFCircularStateFailed];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_mDownloadProgressView  setCircularState:  FFCircularStateIcon];
        });
    }
}

-(void) updateFileProgress:(MesiboFileInfo *) file {
    
    int progress = [file getProgress];
    
    if([file isTransferred]) {
        //UIImage *image = file.image;
        if(file.image)
            _chatPicture.image = file.image;
        [self stopProgressBar];
        return;
    }
    
    int status = [file getStatus];
    
    if(MESIBO_FILESTATUS_INPROGRESS == status) {
        [self setProgress:progress];
        return;
    }
    
    if(MESIBO_FILEMODE_UPLOAD == file.mode) {
        //TBD, we need to use default for DOWNLOAD as we donot have message status
        [self updateStatusIcon:MESIBO_MSGSTATUS_FAIL];
    }
    
    [self stopProgressBar];
}

#pragma mark - TextView


-(void)setTextView {
    _messageLabel.frame = CGRectMake(0, 0, max_witdh, MAXFLOAT);
    _messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.userInteractionEnabled = NO;
    
    NSString *msg = [_uiData getMessage];

    if(_uiData.mReplyMessage) {
        _messageLabel.frame = CGRectMake(0, 0, pic_max_witdh, MAXFLOAT);
        _messageLabel.textColor=[UIColor getColor:MESSAGE_FONT_COLOR_WITH_REPLY];
        
    }else if([_uiData hasImage]){
        _messageLabel.frame = CGRectMake(0, 0, _chatPicture.frame.size.width, MAXFLOAT);
        _messageLabel.textColor=[UIColor getColor:MESSAGE_FONT_COLOR_WITH_PICTURE];
        
    } if([_message isDeleted]) {
        _messageLabel.textColor=[UIColor getColor:MESSAGEDELETED_FONT_COLOR_NORMAL];
        msg = MESSAGEDELETED_STRING;
    } else {
        _messageLabel.textColor=[UIColor getColor:MESSAGE_FONT_COLOR_NORMAL];
    }
    
    _messageLabel.text= msg;
    _messageLabel.userInteractionEnabled = YES;
    _messageLabel.dataDetectorTypes = UIDataDetectorTypeLink;
    _messageLabel.scrollEnabled = NO;
    _messageLabel.editable = NO;
    
    //_mainLabel.backgroundColor = [UIColor whiteColor];
    _messageLabel.textContainerInset = UIEdgeInsetsMake(
                                                        -0,
                                                        -_messageLabel.textContainer.lineFragmentPadding,
                                                        0,
                                                        0);
    [_messageLabel sizeToFit];
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_w = _messageLabel.frame.size.width;
    CGFloat textView_h = _messageLabel.frame.size.height;
    
    if (![_message isIncoming]) {
        textView_x = (self.contentView.frame.size.width - textView_w) - (BUBBLE_RIGHT_MARGIN + OUTGOINGBUBBLE_TO_SCREEN_RIGHT_MARGIN);
        textView_y = pos_y;
        textView_x -= [self isSingleLineCase]?_timeLabel.frame.size.width+25+mFavoriteIconWidth:0.0;
    } else {
        textView_x = BUBBLE_LEFT_MARGIN + INCOMINGBUBBLE_TO_SCREEN_LEFT_MARGIN;
        textView_y = pos_y;
    }
    
    if([_uiData hasImage]) {
        textView_x = _chatPicture.frame.origin.x;
    }if(_uiData.mIsReplyEnabled) {
        textView_x = _replyView.frame.origin.x;
    }
    
    if([msg length]) {
        _messageLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    }else {
        _messageLabel.frame = CGRectMake(textView_x, textView_y, 0, 0);
        
    }
    _messageLabel.autoresizingMask = globlResizing;
    pos_y +=_messageLabel.frame.size.height +4;
    
}

#pragma mark - TimeLabel


-(void) measureTimeLabelFrame {
    NSString *text = [_uiData getTime];
    UIFont *fontz = [UIFont systemFontOfSize:14];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: fontz}];
    
    // here instead of 200 we can use any thing like 250,300, 350 4000
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){200, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size1 = rect.size;
    size1.height = ceilf(size1.height);
    size1.width  = ceilf(size1.width);
    _timeLabel.frame = CGRectMake(0, 0, size1.width, size1.height);
    
}

#define OUTGOING_TIME_RIGHT_MARGIN 25
#define INCOMING_TIME_RIGHT_MARGIN 5
-(void)setTimeLabel {
    
    //UIFont *fontz = [UIFont systemFontOfSize:14];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    _timeLabel.userInteractionEnabled = NO;
    //_timeLabel.alpha = 0.9;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    _timeLabel.text = [_uiData getTime];
    [_timeLabel sizeToFit];
    
    //Set position
    CGFloat time_x;
    CGFloat time_y = pos_y;
    
    NSString *msg = [_uiData getMessage];
    
    if (![_message isIncoming]) {
        //additional 20 (25 vs 5) for message status icon
        time_x = MAX ( _messageLabel.frame.origin.x + (_messageLabel.frame.size.width - _timeLabel.frame.size.width) - OUTGOING_TIME_RIGHT_MARGIN, _chatPicture.frame.origin.x + (_chatPicture.frame.size.width - _timeLabel.frame.size.width) - OUTGOING_TIME_RIGHT_MARGIN);
        
    } else {
        time_x = MAX(_messageLabel.frame.origin.x + (_messageLabel.frame.size.width - _timeLabel.frame.size.width)-INCOMING_TIME_RIGHT_MARGIN,
                     _chatPicture.frame.origin.x + (_chatPicture.frame.size.width - _timeLabel.frame.size.width));
        
    }
    
    if ([self isSingleLineCase] && msg.length != 0 && ![_uiData hasImage]  && ([[_uiData getTitle] length])==0) {
        time_x = _messageLabel.frame.origin.x + _messageLabel.frame.size.width + mFavoriteIconWidth ;
        time_y -= 20;  // take time view above when singlie line
        //if (!_message.mIncoming)
        //    time_x+=5;
        
    }
    
    if([_message isIncoming]) {
        
        if(CGRectGetMaxX(_senderName.frame) > time_x+_timeLabel.frame.size.width) {
            time_x = CGRectGetMaxX(_senderName.frame) - _timeLabel.frame.size.width;
            
        }
        
        
    }
    if(_uiData.mIsReplyEnabled  ) {
        time_x = _replyView.frame.origin.x + ((pic_max_witdh - _timeLabel.frame.size.width) - OUTGOING_TIME_RIGHT_MARGIN);
        //time_y= time_y + _chatPicture.frame.size.height;
    }
    mIstimeLabelOverPicture = NO ;
    if([[_uiData getTitle] length] == 0 ) {
        if(msg.length == 0 || [msg isEqualToString:@""] ) {
            time_y = _chatPicture.frame.size.height - _timeLabel.frame.size.height + 5;
            _timeLabel.textColor = [UIColor whiteColor];
            mIstimeLabelOverPicture = YES;
            
        }
    }
    
    _timeLabel.frame = CGRectMake(time_x,
                                  time_y,
                                  _timeLabel.frame.size.width,
                                  _timeLabel.frame.size.height);
    
    _timeLabel.autoresizingMask = globlResizing;
    pos_y+= _timeLabel.frame.size.height;
    
}

-(BOOL)isSingleLineCase {
    CGFloat delta_x = (![_message isIncoming])?_timeLabel.frame.size.width +OUTGOING_TIME_RIGHT_MARGIN +mFavoriteIconWidth:_timeLabel.frame.size.width + mFavoriteIconWidth;
    
    CGFloat textView_height = _messageLabel.frame.size.height;
    CGFloat textView_width = _messageLabel.frame.size.width;
    CGFloat view_width = self.contentView.frame.size.width;
    
    //Single Line Case
    return (textView_height <= SINGLIE_LINE_HEIGHT && textView_width + delta_x <= MAX_SIZE_TEXTWIDTH_PERCENTAGE*view_width)?YES:NO;
}



#pragma mark - Bubble

- (void)setBubble
{
    
    if([_message isCustom]) return;
    
    //Margins to Bubble
    CGFloat marginLeftOuter = 5;
    CGFloat marginRight = 2;
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 0;
    CGFloat bubble_width;
    CGFloat bubble_height =  MIN(_messageLabel.frame.size.height + 8,
                                 _timeLabel.frame.origin.y + _timeLabel.frame.size.height + 6);
    if([_uiData hasImage]) {
        bubble_height = _chatPicture.frame.size.height + bubble_height;
        
    }
    if(_uiData.mIsReplyEnabled) {
        bubble_height = _replyView.frame.size.height + bubble_height;
        
    }
    
    NSString *msg = [_uiData getMessage];
    
    bubble_height = MAX ((CGRectGetMaxY(_timeLabel.frame)+5) ,(  CGRectGetMaxY(_chatPicture.frame)+7));
    
    if (![_message isIncoming]) {
        bubble_x = _timeLabel.frame.origin.x - 3;
        if([[_uiData getMessage] length])
            bubble_x = MIN(_messageLabel.frame.origin.x-3, bubble_x);
        
        if([_uiData hasImage]) {
            bubble_x = MIN(_chatPicture.frame.origin.x-3, bubble_x);
        }
        if(_uiData.mIsReplyEnabled) {
            bubble_x = MIN(_replyView.frame.origin.x-3, bubble_x);
            
        }
        _bubbleChatImage.image = [MesiboImage bubbleImage:YES];
        bubble_width = self.contentView.frame.size.width - bubble_x - marginRight;
        bubble_x -= RIGHT_OUT_MARGIN;
        
    } else {
        bubble_x = marginLeftOuter;
        _bubbleChatImage.image = [MesiboImage bubbleImage:NO];
        bubble_width = MAX( CGRectGetMaxX(_timeLabel.frame)+marginRight,
                           _chatPicture.frame.origin.x + _chatPicture.frame.size.width + marginRight);
        
    }
    
    if([[_uiData getTitle] length] == 0 ) {
        if(msg.length == 0 || [msg isEqualToString:@""] ) {
            bubble_height -=4;
            
        }
    }
    
    bubble_height +=BUBBLE_BOTTOM_MARGIN;
    _bubbleChatImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);
    _bubbleChatImage.autoresizingMask = globlResizing;
}


-(CGFloat) height {
    if([_message isCustom] || [_message isMissedCall])
        return _messageLabel.frame.size.height + 12;
    
    if(MESSAGEVIEW_TIMESTAMP == [_uiData getType]) {
        return _messageLabel.frame.size.height + 12;
    }
    
    return _bubbleChatImage.frame.size.height;
}

#pragma mark - StatusIcon

-(void)addStatusIcon {
    if([_message isIncoming] || [_message isDeleted]) return;
    
    CGRect time_frame = _timeLabel.frame;
    CGRect status_frame = CGRectMake(0, 0, ICON_SIZE, ICON_SIZE);
    status_frame.origin.x = time_frame.origin.x + time_frame.size.width + 3;
    status_frame.origin.y = time_frame.origin.y +(time_frame.size.height/2)-HALF_ICON_SIZE;
    _statusIcon.frame = status_frame;
    _statusIcon.contentMode = UIViewContentModeScaleToFill;
    //_statusIcon.frame = CGRectMake(status_frame.origin.x, status_frame.origin.y, 18, 18);
    _statusIcon.autoresizingMask = globlResizing  ;
    
}


-(void)setStatusIcon {
    if(![_message isIncoming])
        [self updateStatusIcon:_message.status];
    _statusIcon.hidden = [_message isIncoming];
}


-(void) updateStatusIcon :(int) status {
    if(status&MESIBO_MSGSTATUS_FAIL) {
        [self stopProgressBar];
    }
    [MesiboImage updateStatusIcon:_statusIcon :status];
}

-(void) updateFavoriteIcon :(BOOL) favored {
    if(favored)
        _favoriteIcon.hidden = NO;
    else
        _favoriteIcon.hidden = YES;
}

-(void)addFavoriteIcon {
#if 0
    if(_uiData.mIsFavorite) {
        _favoriteIcon.hidden = NO;
        CGRect time_frame = _timeLabel.frame;
        CGRect favorite_frame = CGRectMake(0, 0, ICON_SIZE, ICON_SIZE);
        favorite_frame.origin.x = time_frame.origin.x - (favorite_frame.size.width + 3);
        favorite_frame.origin.y = time_frame.origin.y +(time_frame.size.height/2)-HALF_ICON_SIZE;
        
        _favoriteIcon.frame = favorite_frame;
        _favoriteIcon.contentMode = UIViewContentModeScaleToFill;
        _favoriteIcon.autoresizingMask = globlResizing  ;
        if(mIstimeLabelOverPicture)
            _favoriteIcon.image = [MesiboImage getFavoriteImageOverPicture];
        else
            _favoriteIcon.image = [MesiboImage getFavoriteImage];
    } else {
        _favoriteIcon.hidden = YES;
    }
#endif
}

// We define delete: method so that our UIMenuController delete item shows up
- (void)delete:(nullable id)sender {
    [super delete:self];
    return;
}

- (void)resend:(id)sender {
    [MesiboInstance resend:(uint32_t)_message.mid];
    
}

- (void)forward:(id)sender {
    [super forward:self];
}

- (void)reply:(id)sender {
    [super reply:self];
}


- (void)share:(id)sender {
    [super share:self];
}

- (void)favorite:(id)sender {
    //MessageViewController *cv = (MessageViewController *) [self getParent];
    //[cv favorite:self];
    
}

- (void)copy:(id)sender {
    MessageViewController *cv = (MessageViewController *) [self getParent];
    [cv copy:self];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if(_message.media)
        pasteboard.image = [_uiData getImage];
    else
        pasteboard.string = [_message getMessageAsString];
    
}

//https://zearfoss.wordpress.com/2013/05/22/masterin-copy-and-paste-in-your-ios-app/
-(BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    if(MESSAGEVIEW_MESSAGE != [_uiData getType])
        return NO;
    
    BOOL ret = (action == @selector(copy:) || action == @selector(delete:) || action == @selector(forward:) || action == @selector(share:) || action == @selector(favorite:) || action == @selector(reply:)) ;
    if(ret) return YES;
    
    if([_message isFailed]) {
        return (action == @selector(resend:));
    }
    
    return NO;
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)openAppleMap:(CLLocationCoordinate2D) cordinates {
    //Apple Maps, using the MKMapItem class
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:cordinates addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = [_uiData getTitle];
    [item openInMapsWithLaunchOptions:nil];
}

-(void)openActionSheet:(id)sender {
    BOOL canHandleGoogleMap = [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"comgooglemaps:"]];
    
    
    CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake(_message.media.location.lat,_message.media.location.lon);
    
    if(!canHandleGoogleMap) {
        [self openAppleMap:rdOfficeLocation];
        return;
    }
    
    //give the user a choice of Apple or Google Maps
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Open Map Option"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* googlemap = [UIAlertAction actionWithTitle:@"Google Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //construct a URL using the comgooglemaps schema
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",rdOfficeLocation.latitude,rdOfficeLocation.longitude]];
        if (![[UIApplication sharedApplication] canOpenURL:url]) {
            NSLog(@"Google Maps app is not installed");
            //left as an exercise for the reader: open the Google Maps mobile website instead!
        } else {
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:url options:@{} completionHandler:nil];
        }
        
        //Do some thing here
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    UIAlertAction* applemap = [UIAlertAction actionWithTitle:@"Apple Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self openAppleMap:rdOfficeLocation];
        //Do some thing here
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    if(canHandleGoogleMap) {
        
        [view addAction:googlemap];
    }
    [view addAction:applemap];
    
    [view addAction:cancel];
    [[self getParent] presentViewController:view animated:YES completion:nil];
    
}


@end

