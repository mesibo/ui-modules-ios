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

#import "MesiboMessageViewHolder.h"
#import "MesiboMessageViewController.h"
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
#define BUBBLE_BOTTOM_MARGIN 7
#define BUBBLE_LEFT_MARGIN  5
#define CUSTOM_BUBBLE_BOTTOM_MARGIN 15

#define BUBBLE_RIGHT_MARGIN 10


#define OUTGOINGBUBBLE_TO_SCREEN_RIGHT_MARGIN   10
#define INCOMINGBUBBLE_TO_SCREEN_LEFT_MARGIN   10

//with extra space of 5
#define FAVORITE_ICON_WIDTH 25
#define SINGLIE_LINE_HEIGHT 35

#define RIGHT_OUT_MARGIN    4

@interface MesiboMessageViewHolder() {
    UIView *_parentView;
    
    UIImageView *_chatPicture;
    UITextView *_messageLabel;
    UILabel *_timeLabel;
    UILabel *_senderName;
    UIView *_replyView;
    UIView *_bubbleView;
    UIView *_titleView;
   // UIImageView *_bubbleChatImage;
    UIImageView *_statusIcon;
    UIImageView *_favoriteIcon;
    MesiboMessage * _message;
    MessageData *_uiData;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
    UILabel *_headingLabel;
    UILabel *_fileNameLabel;
    UILabel *_fileSizeLabel;
    ThumbnailProgressView *_mDownloadProgressView;
    UIImageView *_audioVideoPlayLayer;
    
    bool isDownloading ;
    int mFavoriteIconWidth;
    bool mIstimeLabelOverPicture;
    BOOL showFileInfo;
    UIButton *mAccessoryView;
    NSIndexPath *mIndexPath;
    
    CGRect _mTitleViewFrame;
    CGFloat _mLeft_x;
    CGFloat _mRight_x;
    
    CGFloat _screenWidth;
    
    CGFloat max_witdh ;
    CGFloat pic_max_witdh ;
    CGFloat pos_y;
    CGFloat pos_x;
    CGFloat single_line_height;
    UIViewAutoresizing globlResizing;
}
@end

@implementation MesiboMessageViewHolder

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    single_line_height = 0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _screenWidth = screenRect.size.width;
    max_witdh = 0.75*_screenWidth;
    pic_max_witdh = [MesiboInstance getMessageWidthInPoints];
    
    _mLeft_x = BUBBLE_LEFT_MARGIN + INCOMINGBUBBLE_TO_SCREEN_LEFT_MARGIN;
    _mRight_x = self.contentView.frame.size.width  - (BUBBLE_RIGHT_MARGIN + OUTGOINGBUBBLE_TO_SCREEN_RIGHT_MARGIN);
    
    _mTitleViewFrame = CGRectMake(0, 0, 0, 0);
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        _messageLabel = [[UITextView alloc] init];
        _chatPicture = [[UIImageView alloc] init];
        
        //_bubbleChatImage = [[UIImageView alloc] init];
        _bubbleView = [[UIView alloc] init];
        _titleView = [[UIView alloc] init];
        _timeLabel = [[UILabel alloc] init];
        _statusIcon = [[UIImageView alloc] init];
        _senderName =[[UILabel alloc] init];
        _titleLabel = [[UILabel alloc]init];
        _subtitleLabel = [[UILabel alloc]init];
        _headingLabel = [[UILabel alloc]init];
        _fileNameLabel = [[UILabel alloc]init];
        _fileSizeLabel = [[UILabel alloc]init];
        _favoriteIcon = [[UIImageView alloc] init];
        _replyView = [[UIView alloc] init];
        _audioVideoPlayLayer = [[UIImageView alloc] init];
        
        _mDownloadProgressView = [[ThumbnailProgressView alloc] init];
        uint32_t toolbarColor = [MesiboUI getUiDefaults].mToolbarColor;
        UIColor *color = nil;
        if(toolbarColor)
            color = [UIColor getColor:toolbarColor];
        
        [_mDownloadProgressView config:nil progressColor:nil tickColor:color lineWidth:0 arrowUp:NO];
        
        //[self.contentView addSubview:_bubbleChatImage];
        [self.contentView addSubview:_bubbleView];
        [self.contentView addSubview:_titleView];
        [self.contentView addSubview:_senderName];
        [self.contentView addSubview:_messageLabel];
        [self.contentView addSubview:_chatPicture];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_subtitleLabel];
        [self.contentView addSubview:_headingLabel];
        [self.contentView addSubview:_fileNameLabel];
        [self.contentView addSubview:_fileSizeLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_statusIcon];
        [self.contentView addSubview:_favoriteIcon];
        [self.contentView addSubview:_replyView];
        
        _messageLabel.delegate = self;
        [_messageLabel canBecomeFirstResponder ];
        [_chatPicture addSubview:_audioVideoPlayLayer];
        [_chatPicture addSubview:_mDownloadProgressView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured)];
        [_bubbleView addGestureRecognizer:singleTap];
        [_bubbleView setMultipleTouchEnabled:YES];
        [_bubbleView setUserInteractionEnabled:YES];
        
    }
    
    return self;
}

-(MessageData *) getMessage {
    return _uiData;
}

-(BOOL) showE2EIndicator {
    if(![MesiboUI getUiDefaults].e2eIndicator) return NO;
    if([_message isIncoming] && [_message isEndToEndEncrypted])
        return YES;

    return NO;
}


-(void) setMessage:(MessageData *)uidata indexPath:(NSIndexPath *)indexPath {
    _uiData = uidata;
    _message = [uidata getMesiboMessage];
    
    [self buildCell];
    [_uiData setHeight:self.height];
    mIndexPath = indexPath;
}

-(void) setMesiboRow:(MesiboMessageRow *) row {
    row.messageText = _messageLabel;
    row.title = _titleLabel;
    row.subtitle = _subtitleLabel;
    row.heading = _headingLabel;
    row.filename = _fileNameLabel;
    row.filesize = _fileSizeLabel;
    row.name = _senderName;
    row.timestamp = _timeLabel;
    row.status = _statusIcon;
    row.image = _chatPicture;
    row.replyView = _replyView;
    row.titleView = _titleView;
    row.heading = _headingLabel;
    row.footer = nil;
    row.selected = [super isSelected:_uiData];
}

-(NSIndexPath *) getPosition {
    return mIndexPath;
}


-(void)buildCell {
    [self resetCell];
    
    _mLeft_x = BUBBLE_LEFT_MARGIN + INCOMINGBUBBLE_TO_SCREEN_LEFT_MARGIN;
    _mRight_x = self.contentView.frame.size.width  - (BUBBLE_RIGHT_MARGIN + OUTGOINGBUBBLE_TO_SCREEN_RIGHT_MARGIN);
    pos_x = 0;
    pos_y = BUBBULE_TOP_MARGIN;
    
    if([_message isCustom] || [_message isMissedCall] || MESIBO_MSGSTATUS_E2E == [_message getStatus]) {
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
    
    if([_message isForwarded]) {
        [self setHeadingLabel];
    }
    
    mFavoriteIconWidth = 0;
    
    if([_message isIncoming]){
        globlResizing = UIViewAutoresizingFlexibleRightMargin;
        if([_message isGroupMessage] && [_uiData isShowName])
            [self setSenderName]; // clear doubsts about gid . . ..
    }
    
    if([_uiData isReply]) {
        [self setReplyView];
        
    } else if([_uiData hasThumbnail]) {
        [self setChatPicture];
        
        [self setFileNameLabel];
        [self setFileSizeLabel];
        
        if([[_uiData getTitle] length]){
            [self setTitleLabel];
        }
        
        if([[_uiData getSubTitle] length]){
            [self setSubTitleLabel];
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
    [self setTitleView];
    
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
    _bubbleView.frame = CGRectMake(0, 0, 0, 0);
    _titleView.frame = CGRectMake(0, 0, 0, 0);
    _messageLabel.frame =CGRectMake(0, 0, 0, 0);
    _timeLabel.frame =CGRectMake(0, 0, 0, 0);
    _senderName.frame =CGRectMake(0, 0, 0, 0);
    _titleLabel.frame =CGRectMake(0, 0, 0, 0);
    _subtitleLabel.frame =CGRectMake(0, 0, 0, 0);
    _headingLabel.frame =CGRectMake(0, 0, 0, 0);
    _fileNameLabel.frame =CGRectMake(0, 0, 0, 0);
    _fileSizeLabel.frame =CGRectMake(0, 0, 0, 0);
    _mDownloadProgressView.frame =CGRectMake(0, 0, 0, 0);
    _audioVideoPlayLayer.frame =CGRectMake(0, 0, 0, 0);
    _favoriteIcon.frame =CGRectMake(0, 0, 0, 0);
    _replyView.frame =CGRectMake(0, 0, 0, 0);
    
    //_chatPicture.image = nil;
    _messageLabel.text = nil;
   // _bubbleChatImage.image = nil;
    _timeLabel.text = nil;
    _statusIcon.image = nil;
    _senderName.text = nil;
    _titleLabel.text = nil;
    _subtitleLabel.text = nil;
    _headingLabel.text = nil;
    _fileNameLabel.text = nil;
    _fileSizeLabel.text = nil;
    _mDownloadProgressView.hidden = YES;
    _audioVideoPlayLayer.hidden = YES;
    isDownloading = NO;
    showFileInfo = NO;
    _favoriteIcon.image = nil;
    NSArray *viewsToRemove = [_replyView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    _timeLabel.backgroundColor = [UIColor clearColor];
    _statusIcon.backgroundColor =  [UIColor clearColor];
    
    _mTitleViewFrame = CGRectMake(0, 0, 0, 0);
    _bubbleView.layer.zPosition = -1;
}

- (void) setCustomCell {
    
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    NSString *msg = [_uiData getMessage];
    UIImage *image = [_uiData getImage];
        
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
    
    _messageLabel.font = [MesiboUI getUiDefaults].customFont;
    _messageLabel.backgroundColor = [UIColor getColor:[_uiData getColor]];
    _messageLabel.userInteractionEnabled = NO;
    _messageLabel.editable = NO;
    _messageLabel.textColor=[UIColor getColor:opts.messageTextColor];
    
    _messageLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [_messageLabel sizeToFit];
    
    CGFloat textView_w = _messageLabel.frame.size.width;
    CGFloat textView_h = _messageLabel.frame.size.height;
    
    CGFloat textView_x = (_screenWidth - textView_w)/2;
    CGFloat textView_y = pos_y;
    
    _messageLabel.layer.cornerRadius = 5;
    _messageLabel.layer.masksToBounds = true;
    
    _messageLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    
    _messageLabel.autoresizingMask = globlResizing;
    _messageLabel.hidden = NO;
    pos_y += _messageLabel.frame.size.height ;
}

-(void)setDateCell {
    
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    
    _messageLabel.text = [_uiData getDate];
    _messageLabel.frame = CGRectMake(0, 0, max_witdh, MAXFLOAT);
    
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = opts.dateFont;
    _messageLabel.textColor = [UIColor getColor:opts.dateTextColor];
    _messageLabel.backgroundColor = [UIColor getColor:opts.dateBackgroundColor];
    _messageLabel.autoresizingMask = UIViewAutoresizingNone;
    
    _messageLabel.editable = NO;
    _messageLabel.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    [_messageLabel sizeToFit];
    
    CGFloat textView_w = _messageLabel.frame.size.width;
    CGFloat textView_h = _messageLabel.frame.size.height;
    
    CGFloat textView_x = (_screenWidth - textView_w)/2;
    CGFloat textView_y = pos_y;
    
    _messageLabel.layer.cornerRadius = 5;
    _messageLabel.layer.masksToBounds = true;
    
    _messageLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    
    _messageLabel.autoresizingMask = globlResizing;
    _messageLabel.hidden = NO;
    pos_y += _messageLabel.frame.size.height ;
}

#pragma mark - setsenderName

- (void) setSenderName {
    
    _senderName.text = [_uiData getUsername];
    _senderName.textColor = [LetterTitleImage textColor:_senderName.text];
    _senderName.font = [UIFont systemFontOfSize:15];;
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
    
    UIView *innerView;
    NSBundle *bundle = [MesiboUI getMesiboUIBumble];
    
    int width = pic_max_witdh;
    if([_uiData getReplyBitmap]) {
        innerView = [[bundle loadNibNamed:@"ReplyImageView" owner:self options:nil] objectAtIndex:0];
    }else {
        innerView = [[bundle loadNibNamed:@"ReplyOnlyTextView" owner:self options:nil] objectAtIndex:0];
        width = max_witdh;
    }
    
    MesiboUiDefaults *uio = [MesiboUI getUiDefaults];
    if (![_message isIncoming]) {
        innerView.backgroundColor = [UIColor getColor:uio.titleBackgroundColorForMe];
        
    } else {
        innerView.backgroundColor = [UIColor getColor:uio.titleBackgroundColorForPeer];
    }
        
    innerView.frame = CGRectMake(0, 0, width, 10);
    [innerView setNeedsLayout];
    [innerView layoutIfNeeded];
    
    UILabel *namelabel = [innerView viewWithTag:100];
    namelabel.text = [_uiData getReplyName];
    
    UILabel *messagelabel = [innerView viewWithTag:101];
    messagelabel.text = [_uiData getReplyString];
    
    [namelabel sizeToFit];
    [messagelabel sizeToFit];
    
    picView_h = 5 + CGRectGetMaxY(messagelabel.frame);
    
    UIImageView *imageView = [innerView viewWithTag:102];
    if(nil != [_uiData getReplyBitmap] && nil != imageView) {
        imageView.image = [_uiData getReplyBitmap];
    }
    
    innerView.layer.cornerRadius = 5;
    innerView.layer.masksToBounds = YES;
    
    int maxwidth = MAX(namelabel.frame.size.width, messagelabel.frame.size.width);
    maxwidth += 50;
    maxwidth = innerView.frame.size.width;
    _replyView.frame = CGRectMake(picView_x, picView_y, pic_max_witdh, picView_h);
    innerView.frame = CGRectMake(0, 0, maxwidth, picView_h);
    
    [_replyView addSubview:innerView];
    pos_y +=_replyView.frame.size.height+3;
    
}

#pragma mark - ChatPicture

- (void) setChatPicture {
    
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    UIImage *image = [_uiData getImage];
    if(!image) return;
    int widthpercent = opts.horizontalImageWidth;
    if(image.size.height > image.size.width && image.size.width > 150) {
        widthpercent = opts.verticalImageWidth;
    }
    
    CGFloat picwitdh = (_screenWidth*widthpercent)/100;
    if(picwitdh > pic_max_witdh) picwitdh = pic_max_witdh;
    
    CGFloat picFrameWidth = picwitdh; // this we are using when smaller image is used and outgoing file so that image is
                                      // left aligned
    
    if(image.size.height < 150 && image.size.width < 150 && ![_message isFileTransferRequired]) {
        picwitdh = pic_max_witdh/4;
        showFileInfo = YES;
    }
    
    CGFloat picheight = (image.size.height*picwitdh)/image.size.width;
    
    CGFloat picView_x;
    CGFloat picView_y;
    CGFloat picView_w = picwitdh;
    CGFloat picView_h = picheight;
    
    if ([_message isIncoming]){
        picView_x = (_mLeft_x - BUBBLE_LEFT_MARGIN) + 2;
        
    }else {
        picView_x = _mRight_x - picFrameWidth;
    }
    picView_y = pos_y;
    
    
    _chatPicture.autoresizingMask = globlResizing;
    _chatPicture.frame = CGRectMake(picView_x, picView_y, picView_w, picView_h);
    
    _chatPicture.image = image;
    _chatPicture.layer.zPosition = 100;
    _chatPicture.hidden = NO;
    
    if(![_message isFileTransferRequired]) {
        _mDownloadProgressView.hidden = YES;
    } else {
        _mDownloadProgressView.hidden = NO;
        _mDownloadProgressView.frame = CGRectMake(0, 0, FILE_PROGRESS_SIZE, FILE_PROGRESS_SIZE);
        _mDownloadProgressView.mArrowDirectionUp = [_message isUploadRequired];
        _mDownloadProgressView.center = [_chatPicture convertPoint:_chatPicture.center fromView:_chatPicture.superview];
        [_mDownloadProgressView setCircularState:FFCircularStateIcon];
    }
    
    [self setPlayerView];
    
    pos_y +=_chatPicture.frame.size.height+3;
    
    CGRect headingFrame = _headingLabel.frame;
    headingFrame.origin.x = picView_x;
    _headingLabel.frame = headingFrame;
    _headingLabel.autoresizingMask = globlResizing;
    
}

-(CGFloat) getMessageWidth {
    if(![_message hasThumbnail])
        return max_witdh;
    
    if([_message hasAudio] || [_message hasDocument]) {
        return pic_max_witdh;
    }
    
    return _chatPicture.frame.size.width;
}

-(CGFloat) getPictureWidth {
    if(![_message hasThumbnail])
        return 0;
    
    return [self getMessageWidth];
}

- (void) setTitleLabel {
    CGFloat msgWidth = [self getMessageWidth];
    
    _titleLabel.frame = CGRectMake(0, 0, msgWidth, MAXFLOAT);

    
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    
    if(opts.titleFont) _titleLabel.font = opts.titleFont;
   
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.clipsToBounds = YES;
    _titleLabel.userInteractionEnabled = NO;
    _titleLabel.textColor=[UIColor getColor:opts.titleTextColor];
    _titleLabel.numberOfLines = 2;
    
    _titleLabel.text=[_uiData getTitle];
    [_titleLabel sizeToFit];
    
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_w = msgWidth;
    CGFloat textView_h = _titleLabel.frame.size.height;
    
    if(0 == _mTitleViewFrame.origin.y)
        _mTitleViewFrame.origin.y = pos_y;
    
    pos_y = pos_y + 5 ;
    
    if ([_message isIncoming]){
        textView_x = _mLeft_x;
        
    }else {
        textView_x = _mRight_x - textView_w;
    }
    textView_y = pos_y;
    
    if([_message hasThumbnail]) {
        textView_x = _chatPicture.frame.origin.x;
    }
    _titleLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    _titleLabel.autoresizingMask = globlResizing;
    pos_y +=_titleLabel.frame.size.height +5 ;
    
    _mTitleViewFrame.size.height = pos_y - _mTitleViewFrame.origin.y;
    
    CGRect headingFrame = _headingLabel.frame;
    headingFrame.origin.x = textView_x;
    _headingLabel.frame = headingFrame;
    _headingLabel.autoresizingMask = globlResizing;
    
}

- (void) setSubTitleLabel {
    CGFloat msgWidth = [self getMessageWidth];
    
    _subtitleLabel.frame = CGRectMake(0, 0, msgWidth, MAXFLOAT);

    
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    if(opts.subtitleFont) _subtitleLabel.font = opts.subtitleFont;
    
    _subtitleLabel.backgroundColor = [UIColor clearColor];
    _subtitleLabel.clipsToBounds = YES;
    _subtitleLabel.userInteractionEnabled = NO;
    _subtitleLabel.textColor=[UIColor getColor:opts.titleTextColor];
    _subtitleLabel.numberOfLines = 3;
    
    _subtitleLabel.text=[_uiData getSubTitle];
    [_subtitleLabel sizeToFit];
    
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_w = msgWidth;
    CGFloat textView_h = _subtitleLabel.frame.size.height;
    
    if(0 == _mTitleViewFrame.origin.y)
        _mTitleViewFrame.origin.y = pos_y;
    
    pos_y = pos_y +5 ;
    
    if ([_message isIncoming]){
        textView_x = _mLeft_x;
        
    }else {
        textView_x = _mRight_x - textView_w;
    }
    textView_y = pos_y;
    
    if([_message hasThumbnail]) {
        textView_x = _chatPicture.frame.origin.x;
    }
    _subtitleLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    _subtitleLabel.autoresizingMask = globlResizing;
    pos_y +=_subtitleLabel.frame.size.height + 5 ;
    
    _mTitleViewFrame.size.height = pos_y - _mTitleViewFrame.origin.y;
    
    CGRect headingFrame = _headingLabel.frame;
    headingFrame.origin.x = textView_x;
    _headingLabel.frame = headingFrame;
    _headingLabel.autoresizingMask = globlResizing;
    
}

- (void) setFileNameLabel {
    if(!showFileInfo || ![_uiData getFileName])
        return;
    
    CGFloat msgWidth = [self getMessageWidth];
    
    _fileNameLabel.frame = CGRectMake(0, 0, msgWidth, MAXFLOAT);

    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    
    if(opts.messageFont) _fileNameLabel.font = opts.messageFont;
    
    _fileNameLabel.backgroundColor = [UIColor clearColor];
    _fileNameLabel.clipsToBounds = YES;
    _fileNameLabel.userInteractionEnabled = NO;
    _fileNameLabel.textColor=[UIColor getColor:opts.messageTextColor];
    _fileNameLabel.numberOfLines = 2;
    
    _fileNameLabel.text=[_uiData getFileName];
    [_fileNameLabel sizeToFit];
    
    CGFloat textView_w = msgWidth - (_chatPicture.frame.size.width + 10);
    CGFloat textView_h = _fileNameLabel.frame.size.height;
    CGFloat textView_x = _chatPicture.frame.origin.x + _chatPicture.frame.size.width + 10;
    CGFloat textView_y = _chatPicture.frame.origin.y;
    
    _fileNameLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    _fileNameLabel.autoresizingMask = globlResizing;
    
}

- (void) setFileSizeLabel {
    if(!showFileInfo || ![_uiData getFileSize])
        return;
    
    CGFloat msgWidth = [self getMessageWidth];
    
    _fileSizeLabel.frame = CGRectMake(0, 0, msgWidth, MAXFLOAT);

    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    
    if(opts.messageFont) _fileSizeLabel.font = opts.messageFont;
    
    _fileSizeLabel.backgroundColor = [UIColor clearColor];
    _fileSizeLabel.clipsToBounds = YES;
    _fileSizeLabel.userInteractionEnabled = NO;
    _fileSizeLabel.textColor=[UIColor getColor:opts.messageTextColor];
    _fileSizeLabel.numberOfLines = 1;
    
    _fileSizeLabel.text=[_uiData getFileSize];
    [_fileSizeLabel sizeToFit];
    
    CGFloat textView_w = _fileNameLabel.frame.size.width;
    CGFloat textView_h = _fileSizeLabel.frame.size.height;
    CGFloat textView_x = _fileNameLabel.frame.origin.x;
    CGFloat textView_y = _fileNameLabel.frame.origin.y + _fileNameLabel.frame.size.height + 5;
    
    _fileSizeLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    _fileSizeLabel.autoresizingMask = globlResizing;
    
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
    
    if(![_message isRichMessage])
        return;
    
    if([_message isFileTransferRequired] || [_message isFileTransferInProgress]) {
        [_message toggleFileTransfer:1];
        return;
    }
    
    MesiboFile *file = [_message getFile];
    
    if(!file || MESIBO_FILETYPE_LOCATION == file.type) {
        if([_message hasLocation] || (file && MESIBO_FILETYPE_LOCATION == file.type)) {
            [self openActionSheet:nil];
            return;
        }
    }
    
    if(!file.path || !file.path.length || [_message openExternally]) {
        [self openUrl:file.url];
        return;
    }
    
    
    if(file.type ==MESIBO_FILETYPE_VIDEO || file.type ==MESIBO_FILETYPE_AUDIO){
        [MesiboUIManager showVideofile:[self getParent] withVideoFilePath:file.path];
    } else if(file.type == MESIBO_FILETYPE_IMAGE){
        [MesiboUIManager showImageFile:[self getParent] path:file.path withTitle:[_message.profile getNameOrAddress:@"+"]];
    } else {
        [MesiboUIManager openGenericFiles:[self getParent] withFilePath:file.path];
    }
    
}

-(void) setPlayerView {
    if(![_message isRichMessage] || [_message isFileTransferRequired])
        return;

    
    if([_message hasAudio] || [_message hasVideo] ) {
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
    
    if(![_message isRichMessage] || ![_message isFileTransferRequired])
        return;
    
    [_message stopFileTransfer];
    
    if(![_message isFileTransferRequired]) {
        [self setPlayerView];
        _mDownloadProgressView.hidden = YES;
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

-(void) updateFileProgress:(MesiboFile *) file {
    
   
}

#pragma mark - TextView

- (void) setHeadingLabel {
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    if(!opts.forwardedTitle || !opts.forwardedTitle.length)
        return;
    
    _headingLabel.frame = CGRectMake(0, 0, [self getMessageWidth], MAXFLOAT);
    
    
    if(opts.headingFont) _headingLabel.font = opts.headingFont;
        
        
        
    _headingLabel.backgroundColor = [UIColor clearColor];
    _headingLabel.clipsToBounds = YES;
    _headingLabel.userInteractionEnabled = NO;
    _headingLabel.textColor=[UIColor getColor:opts.headingTextColor];
    
    _headingLabel.text= opts.forwardedTitle;
    [_headingLabel sizeToFit];
    
    CGFloat textView_x;
    CGFloat textView_y;
    CGFloat textView_w = _headingLabel.frame.size.width;
    CGFloat textView_h = _headingLabel.frame.size.height;
    
    pos_y = pos_y + 2 ;

    // we will later adjust x in text view
    if ([_message isIncoming]){
        textView_x = _mLeft_x;
        
    }else {
        textView_x = _mRight_x;
    }
    
    textView_y = pos_y;
    
    _headingLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    _headingLabel.autoresizingMask = globlResizing;
    pos_y +=_headingLabel.frame.size.height +5 ;
    
}


-(void)setTextView {
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    
    if(0 == single_line_height) {
        CGRect rect =  [self measureHeight:@"12:34" font:opts.messageFont width:max_witdh];
        single_line_height = rect.size.height;
    }
    
    _messageLabel.frame = CGRectMake(0, 0, max_witdh, MAXFLOAT);

    
    if(opts.messageFont)
        _messageLabel.font = opts.messageFont;
    
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.userInteractionEnabled = NO;
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString *msg = [_uiData getMessage];
    
    //added Appr 14, 2022
    msg = [msg stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    CGRect tr =  [self measureHeight:[NSString stringWithFormat:@"%@ 12:34 56", msg] font:opts.messageFont width:max_witdh];
    
    if([_uiData isReply]) {
        _messageLabel.frame = CGRectMake(0, 0, pic_max_witdh, MAXFLOAT);
        _messageLabel.textColor=[UIColor getColor:opts.messageReplyTextColor];
        
    }else if([_uiData hasThumbnail]){
        _messageLabel.frame = CGRectMake(0, 0, [self getMessageWidth], MAXFLOAT);
        _messageLabel.textColor=[UIColor getColor:opts.messagePictureTextColor];
        
    } if([_message isDeleted]) {
        _messageLabel.textColor=[UIColor getColor:opts.messageDeletedTextColor];
        msg = opts.deletedMessageTitle;
    } else {
        _messageLabel.textColor=[UIColor getColor:opts.messageTextColor];
    }
    
    _messageLabel.text= msg;
    _messageLabel.userInteractionEnabled = YES;
    _messageLabel.dataDetectorTypes = UIDataDetectorTypeLink;
    _messageLabel.scrollEnabled = NO;
    _messageLabel.editable = NO;
    
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
    
    CGFloat titleViewBottom = _mTitleViewFrame.origin.y + _mTitleViewFrame.size.height;
    
    if(titleViewBottom > 0 && (pos_y <= titleViewBottom+10))
        pos_y = titleViewBottom+10;
    
    if (![_message isIncoming]) {
        textView_x = (self.contentView.frame.size.width - textView_w) - (BUBBLE_RIGHT_MARGIN + OUTGOINGBUBBLE_TO_SCREEN_RIGHT_MARGIN);
        textView_y = pos_y;
        textView_x -= [self isSingleLineCase]?_timeLabel.frame.size.width+25+mFavoriteIconWidth:0.0;
    } else {
        textView_x = BUBBLE_LEFT_MARGIN + INCOMINGBUBBLE_TO_SCREEN_LEFT_MARGIN;
        textView_y = pos_y;
    }
    
    if([_uiData hasThumbnail]) {
        textView_x = _chatPicture.frame.origin.x;
    }if([_uiData isReply]) {
        textView_x = _replyView.frame.origin.x;
    }
    
    int minwidth = _timeLabel.frame.size.width + 10;
    if([self showE2EIndicator]) minwidth += 25 + 10;
    
    if([self showE2EIndicator]) textView_w += 25 + 5;
    
    if(0 && tr.size.height < _messageLabel.frame.size.height && _messageLabel.frame.size.height > 1.75*single_line_height) {
    }
    
    if(0 && textView_w < minwidth)
        textView_w = minwidth;
    
    if([msg length]) {
        _messageLabel.frame = CGRectMake(textView_x, textView_y, textView_w, textView_h);
    }else {
        _messageLabel.frame = CGRectMake(textView_x, textView_y, 0, 0);
        
    }
    _messageLabel.autoresizingMask = globlResizing;
    pos_y +=_messageLabel.frame.size.height +4;
    
    
    // check if we can accomodate status in the last line of the text itself
    if(tr.size.height < _messageLabel.frame.size.height && _messageLabel.frame.size.height > 1.75*single_line_height) {
        pos_y -= single_line_height;
    }
    
    CGRect headingFrame = _headingLabel.frame;
    headingFrame.origin.x = textView_x;
    _headingLabel.frame = headingFrame;
    _headingLabel.autoresizingMask = globlResizing;
    
}

#pragma mark - TimeLabel

-(CGRect) measureHeight:(NSString *)text font:(UIFont *)font width:(int) width {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
    
    // here instead of 200 we can use any thing like 250,300, 350 4000
    return [attributedText boundingRectWithSize:(CGSize){(CGFloat)width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
}

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

-(void) setTimeStatusBackground {
    return;
    
    if([_message hasThumbnail]) {
        NSString *t = [_uiData getTitle];
        if(t || t.length) return;
        
        _timeLabel.backgroundColor = [UIColor grayColor];
        _statusIcon.backgroundColor =  [UIColor grayColor];
    }
}

#define STATUS_ICON_MARGIN      18
#define INCOMING_TIME_RIGHT_MARGIN 5
#define OUTGOING_TIME_RIGHT_MARGIN 23

-(void)setTimeLabel {
    
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    
    _timeLabel.textColor = [UIColor getColor:opts.timeTextColor];
    _timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    _timeLabel.userInteractionEnabled = NO;
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self setTimeStatusBackground];
    
    _timeLabel.text = [_uiData getTime];
    [_timeLabel sizeToFit];
    
    //Set position
    CGFloat time_x;
    CGFloat time_y = pos_y;
    
    NSString *msg = [_uiData getMessage];
    
    if (![_message isIncoming]) {
        time_x = MAX ( _messageLabel.frame.origin.x + (_messageLabel.frame.size.width - _timeLabel.frame.size.width) - OUTGOING_TIME_RIGHT_MARGIN, _chatPicture.frame.origin.x + ([self getMessageWidth] - _timeLabel.frame.size.width) - OUTGOING_TIME_RIGHT_MARGIN);
        
    } else {
        time_x = MAX(_messageLabel.frame.origin.x + (_messageLabel.frame.size.width - _timeLabel.frame.size.width)-INCOMING_TIME_RIGHT_MARGIN,
                     _chatPicture.frame.origin.x + ([self getMessageWidth] - _timeLabel.frame.size.width));
        
    }
    
    if ([self isSingleLineCase] && msg.length != 0 && ![_uiData hasThumbnail]  && ([[_uiData getTitle] length])==0) {
        time_x = _messageLabel.frame.origin.x + _messageLabel.frame.size.width + mFavoriteIconWidth ;
        time_y -= 20;  // take time view above when singlie line
    }
    
    if([_message isIncoming]) {
        
        if(CGRectGetMaxX(_senderName.frame) > time_x+_timeLabel.frame.size.width) {
            time_x = CGRectGetMaxX(_senderName.frame) - _timeLabel.frame.size.width;
            
        }
        
        
    }
    if([_uiData isReply]  ) {
        time_x = _replyView.frame.origin.x + (pic_max_witdh - _timeLabel.frame.size.width);
        if ([_message isOutgoing]) time_x -= OUTGOING_TIME_RIGHT_MARGIN;
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
    
    if([self showE2EIndicator]) {
        time_x -= STATUS_ICON_MARGIN; // for e2ee
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
    
    return (textView_height <= SINGLIE_LINE_HEIGHT && textView_width + delta_x <= MAX_SIZE_TEXTWIDTH_PERCENTAGE*view_width)?YES:NO;
}



#pragma mark - Bubble

- (void)setTitleView {
    if([_uiData isReply] || [_message isCustom])
        return;
    
    if(![_uiData getTitle].length && ![_uiData getSubTitle].length)
        return;
    
    _mTitleViewFrame.origin.x = _bubbleView.frame.origin.x;
    _mTitleViewFrame.size.width = _bubbleView.frame.size.width;
    _titleView.frame = _mTitleViewFrame;
    
    MesiboUiDefaults *uio = [MesiboUI getUiDefaults];
    if (![_message isIncoming]) {
        _titleView.backgroundColor = [UIColor getColor:uio.titleBackgroundColorForMe];
        
    } else {
        _titleView.backgroundColor = [UIColor getColor:uio.titleBackgroundColorForPeer];
    }
    
    _titleView.autoresizingMask = globlResizing;
}

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
    if([_uiData hasThumbnail]) {
        bubble_height = _chatPicture.frame.size.height + bubble_height;
        
    }
    if([_uiData isReply]) {
        bubble_height = _replyView.frame.size.height + bubble_height;
        
    }
    
    NSString *msg = [_uiData getMessage];
    
    bubble_height = MAX ((CGRectGetMaxY(_timeLabel.frame)+5) ,(  CGRectGetMaxY(_chatPicture.frame)+7));
    MesiboUiDefaults *uio = [MesiboUI getUiDefaults];
    
    if (![_message isIncoming]) {
        bubble_x = _timeLabel.frame.origin.x - 3;
        if([[_uiData getTitle] length])
            bubble_x = MIN(_titleLabel.frame.origin.x-3, bubble_x);
        
        if([[_uiData getSubTitle] length])
            bubble_x = MIN(_subtitleLabel.frame.origin.x-3, bubble_x);
        
        if([[_uiData getMessage] length])
            bubble_x = MIN(_messageLabel.frame.origin.x-3, bubble_x);
        
        if([_uiData hasThumbnail]) {
            bubble_x = MIN(_chatPicture.frame.origin.x-3, bubble_x);
        }
        if([_uiData isReply]) {
            bubble_x = MIN(_replyView.frame.origin.x-3, bubble_x);
            
        }

        bubble_width = self.contentView.frame.size.width - bubble_x - marginRight;
        bubble_x -= RIGHT_OUT_MARGIN;
        
        _bubbleView.backgroundColor = [UIColor getColor:uio.messageBackgroundColorForMe];
        _titleView.backgroundColor = [UIColor getColor:uio.titleBackgroundColorForMe];
        
    } else {
        bubble_x = marginLeftOuter;
        bubble_width = MAX( CGRectGetMaxX(_timeLabel.frame)+marginRight,
                           _chatPicture.frame.origin.x + [self getPictureWidth] + marginRight);
        
        if([_uiData isReply]) {
            bubble_width = MAX(CGRectGetMaxX(_replyView.frame)+marginRight, bubble_width);
        }
        
        if([self showE2EIndicator]) {
            bubble_width += STATUS_ICON_MARGIN;
        }
        
        _bubbleView.backgroundColor = [UIColor getColor:uio.messageBackgroundColorForPeer];
        _titleView.backgroundColor = [UIColor getColor:uio.titleBackgroundColorForPeer];
        
    }
    
    if([_message isForwarded]) {
        
        bubble_width = MAX( bubble_width,
                           _headingLabel.frame.size.height + marginRight);
    }
    
    if([[_uiData getTitle] length] == 0 ) {
        if(msg.length == 0 || [msg isEqualToString:@""] ) {
            bubble_height -=4;
            
        }
    }
    
    bubble_height +=BUBBLE_BOTTOM_MARGIN;
    
    //TBD, adjust as per the width and height of the cell
    _bubbleView.layer.cornerRadius = 6;
    _bubbleView.layer.shadowColor = [[UIColor grayColor] CGColor];
    _bubbleView.layer.shadowOffset = CGSizeMake(0, 0);
    _bubbleView.layer.shadowRadius = 3.0;
    _bubbleView.layer.shadowOpacity = 0.5;
    
    _bubbleView.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);
    _bubbleView.autoresizingMask = globlResizing;
    
}


-(CGFloat) height {
    if([_message isCustom] || [_message isMissedCall] || MESIBO_MSGSTATUS_E2E == [_message getStatus])
        return _messageLabel.frame.size.height + CUSTOM_BUBBLE_BOTTOM_MARGIN + 5;
    
    if(MESSAGEVIEW_TIMESTAMP == [_uiData getType]) {
        return _messageLabel.frame.size.height + CUSTOM_BUBBLE_BOTTOM_MARGIN;
    }
    
    //return _bubbleChatImage.frame.size.height;
    return _bubbleView.frame.size.height + BUBBLE_BOTTOM_MARGIN;
}

#pragma mark - StatusIcon

-(void)addStatusIcon {
    if(([_message isIncoming] && ![self showE2EIndicator]) || [_message isDeleted]) return;
    
    CGRect time_frame = _timeLabel.frame;
    CGRect status_frame = CGRectMake(0, 0, ICON_SIZE, ICON_SIZE);
    status_frame.origin.x = time_frame.origin.x + time_frame.size.width + 3;
    status_frame.origin.y = time_frame.origin.y +(time_frame.size.height/2)-HALF_ICON_SIZE;
    _statusIcon.frame = status_frame;
    _statusIcon.contentMode = UIViewContentModeScaleToFill;
    _statusIcon.autoresizingMask = globlResizing  ;
    
}


-(void)setStatusIcon {
    _statusIcon.hidden = NO;
    
    if(![_message isIncoming])
        [self updateStatusIcon:_message.status];
    else if([self showE2EIndicator])
        [MesiboImage setSecureIcon:_statusIcon];
    else
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
}

- (void)delete:(nullable id)sender {
    [super delete:self];
    return;
}

- (void)resend:(id)sender {
    [_message resend];
    
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
}

-(void) encryption:(id) sender {
    uint32_t gid = _message.groupid;
    NSString *addr = _message.peer;
    
    MesiboProfile *profile = [MesiboInstance getProfile:gid?nil:addr groupid:gid];
    [MesiboUI showEndToEncEncryptionInfo:[self getParent] profile:profile];
}

- (void)copy:(id)sender {
    MesiboTableController *cv = [self getTableController];
    [cv copy:self];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if([_message hasThumbnail])
        pasteboard.image = [_uiData getImage];
    else
        pasteboard.string = [_uiData getMessage];
    
}

-(BOOL) canPerformAction:(SEL)action withSender:(id)sender {
    if(MESSAGEVIEW_MESSAGE != [_uiData getType])
        return NO;
    
    BOOL ret = (action == @selector(copy:) || action == @selector(delete:) ||
                action == @selector(share:) || action == @selector(favorite:) || action == @selector(encryption:))  ;
    if(ret) return YES;
    
    if(action == @selector(forward:) || action == @selector(reply:)) {
        if([_message isFailed]) return NO;
        return YES;
    }
    
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
}

-(void) openUrl:(NSString *) urlstr {
    if(!urlstr) return;
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:urlstr];
    [application openURL:url options:@{} completionHandler:nil];
}

-(void)openAppleMap:(CLLocationCoordinate2D) cordinates {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:cordinates addressDictionary:nil];
    MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
    item.name = [_uiData getTitle];
    [item openInMapsWithLaunchOptions:nil];
}

-(void)openGoogleMap:(CLLocationCoordinate2D) cordinates {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?center=%f,%f",cordinates.latitude,cordinates.longitude]];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:nil];
}

-(void)openActionSheet:(id)sender {
    MesiboUiDefaults *opts = [MesiboUI getUiDefaults];
    
    CLLocationCoordinate2D rdOfficeLocation = CLLocationCoordinate2DMake(_message.latitude,_message.longitude);
    
    if(LOCATION_APP_APPLE == opts.preferredLocationApp) {
        [self openAppleMap:rdOfficeLocation];
        return;
    }
    
    BOOL canHandleGoogleMap = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]];
    
    if(!canHandleGoogleMap) {
        NSLog(@"Unable to use Google Map. Add \"comgooglemaps\" in LSApplicationQueriesSchemes and try again. Refer to the LSApplicationQueriesSchemes documentation for details");
        [self openAppleMap:rdOfficeLocation];
        return;
    }
    
    if(LOCATION_APP_GOOGLEMAP == opts.preferredLocationApp) {
        [self openGoogleMap:rdOfficeLocation];
        return;
    }
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Open Map Option"
                                 message:@""
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* googlemap = [UIAlertAction actionWithTitle:@"Google Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //construct a URL using the comgooglemaps schema
        if(LOCATION_APP_PROMPTONCE == opts.preferredLocationApp) {
            opts.preferredLocationApp = LOCATION_APP_GOOGLEMAP;
        }
        [self openGoogleMap:rdOfficeLocation];
        //Do some thing here
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    UIAlertAction* applemap = [UIAlertAction actionWithTitle:@"Apple Map" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        if(LOCATION_APP_PROMPTONCE == opts.preferredLocationApp) {
            opts.preferredLocationApp = LOCATION_APP_APPLE;
        }
        
        [self openAppleMap:rdOfficeLocation];
        //Do some thing here
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [view dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [view addAction:applemap];
    [view addAction:googlemap];
    
    [view addAction:cancel];
    [[self getParent] presentViewController:view animated:YES completion:nil];
    
}

@end

