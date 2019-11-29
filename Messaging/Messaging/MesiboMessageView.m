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

#import "MesiboMessageView.h"
#import "MesiboImage.h"
#import "MesiboConfiguration.h"

@interface MesiboMessageView() {
    id mViewHolder;
    int mType;
    BOOL mSelected;
    BOOL mDeleted;

    NSString *mCustomMessageText;
    UIImage *mCustomMessageImage;
    uint32_t mCustomMessageColor;
    
    NSString *_mMessageDate;
    NSString *_mMessageTime;
    NSString *_mMessagePrintDate;
    
    MesiboMessage *_mMessage;
    
    int mCellHeight;
}
@end

@implementation MesiboMessageView


-(id) init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    mViewHolder = nil;
    _mMessage = nil;
    mType = MESSAGEVIEW_MESSAGE;
    mSelected = NO;
    _mShowName = NO;
    mDeleted = NO;
    
    mCustomMessageText = nil;
    mCustomMessageImage = nil;
    mCustomMessageColor = 0;
    
    _mMessageDate = nil;
    _mMessageTime = nil;
    _mMessagePrintDate = nil;
    
    mCellHeight = 0;
    
    return self;
}

-(int) getType {
    return mType;
}

-(void) setType:(int) type {
    mType = type;
}

-(NSString *) getTime {
    [self setTimestamps];
    return _mMessageTime;
}

-(NSString *) getDate {
    [self setTimestamps];
    return _mMessagePrintDate;
}

-(MesiboMessage *) getMesiboMessage {
    return _mMessage;
}

-(void) setMessage:(MesiboMessage *)message {
    _mMessage = message;
    [self setMissedCallInfo];
}

-(uint64_t) getMid {
    return _mMessage.mid;
}

-(void) update {
    
}

-(void) setCustomData:(NSString *)msg image:(UIImage *)image bgcolor:(uint32_t) bgcolor {
    mCustomMessageText = msg;
    mCustomMessageImage = image;
    mCustomMessageColor = bgcolor;
}

-(UIImage *) getCustomImage {
    return mCustomMessageImage;
}

-(uint32_t) getCustomColor {
    return mCustomMessageColor;
}

-(void) setMissedCallInfo {
    if(![_mMessage isMissedCall]) return;
    
    NSString *ts = [self getTime];
    NSString *calltype = [_mMessage isVideoCall]?@"video":@"voice";
    UIImage *image = [MesiboImage getMissedCallIcon:[_mMessage isVideoCall]];
        
    NSString *msg = [NSString stringWithFormat:@" Missed %@ call at %@", calltype, ts];
    [self setCustomData:msg image:image bgcolor:SYSTEM_MESSAGES_BACKGROUND_COLOR];
}

-(NSString *) getMessage {
    
    if(mCustomMessageText)
        return mCustomMessageText;
    
    if([_mMessage isDeleted]) {
        return MESSAGEDELETED_STRING;
    }
    
    NSString *msg = [_mMessage getMessageAsString];
    
    [self setMissedCallInfo];
    
    
    return msg;
}

-(NSString *) getTitle {
    if([_mMessage isDeleted] || ![_mMessage hasMedia])
        return nil;
    
    if(_mMessage.media.file)
        return _mMessage.media.file.title;
    if(_mMessage.media.location)
        return _mMessage.media.location.title;
    return nil;
}

-(BOOL) hasImage {
    if([_mMessage isDeleted])
        return nil;
    
    return [_mMessage hasMedia];
}

-(UIImage *) getThumbnail {
    if([_mMessage isDeleted])
        return nil;
    
    if(_mMessage.media.file)
        return _mMessage.media.file.image;
    
    if(_mMessage.media.location) {
        if(_mMessage.media.location.image)
            return _mMessage.media.location.image;
        
        return [MesiboImage getDefaultLocationImage];
    }
    
    return nil;
}

-(UIImage *) getImage {
    if([_mMessage isDeleted] || ![_mMessage hasMedia])
        return nil;
    
    if(_mMessage.media.file)
        return [MesiboInstance loadImage:nil filePath:[_mMessage.media.file getPath]  maxside:0];
    
    if(_mMessage.media.location) {
        return [self getThumbnail];
    }
    
    return nil;
}


-(id) getViewHolder {
    return mViewHolder;
}

-(void) setViewHolder:(id)vh {
    mViewHolder = vh;
}

-(void) setTimestamps {
    if(_mMessagePrintDate) return;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(uint64_t)_mMessage.ts/1000.0];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    
    [dateFormatter setDateFormat:@"HH:mm"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    _mMessageTime = [dateFormatter stringFromDate:date];
    NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
    
   
    [dateFormatter1 setDateFormat:MESSAGE_DATE_FORMAT];

    _mMessageDate = [dateFormatter1 stringFromDate:date];
    _mMessagePrintDate = _mMessageDate;
    int days = [MesiboInstance daysElapsed:_mMessage.ts];
    
    if(0 == days)
        _mMessagePrintDate = @"Today";
    else if(1 == days) {
        _mMessagePrintDate = @"Yesterday";
    } else if(days < 7) {
        [dateFormatter1 setDateFormat:MESSAGE_DATE_LASTWEEK_FORMAT];
        _mMessagePrintDate = [dateFormatter1 stringFromDate:date];
    }
}

-(void) toggleSelected {
    mSelected = !mSelected;
}

-(void) setSelected:(BOOL)selected {
    mSelected = selected;
}

-(BOOL)isSelected {
    return mSelected;
}

-(void) resetHeight {
    mCellHeight = 0;
}

-(void) setHeight:(int)height {
    mCellHeight = height;
}

-(int) getHeight {
    return mCellHeight;
}

@end
