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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Mesibo/Mesibo.h"

#define MESSAGEVIEW_TIMESTAMP    0
#define MESSAGEVIEW_MESSAGE      1
#define MESSAGEVIEW_MESSAGELIST  2
#define MESSAGEVIEW_CONTACTS     3
#define MESSAGEVIEW_GROUP        4
#define MESSAGEVIEW_EDIT_GROUP 5
#define MESSAGEVIEW_SELECTION_GROUP 6
#define MESSAGEVIEW_FORWARD_MODE  7



@interface MesiboMessageView : NSObject

//@property (assign,nonatomic) int mCellHeight;
@property (assign,nonatomic) BOOL mIsReplyEnabled;
@property (strong,nonatomic) NSString *mReplyMessage;
@property (strong,nonatomic) NSString *mReplyUserName;
@property (strong,nonatomic) UIImage *mReplyImage;
@property (strong,nonatomic) UIView *mReplyView;
@property (strong,nonatomic) NSBundle *mReplyBundle;
@property (assign,nonatomic) BOOL mShowName;

@property (assign,nonatomic) BOOL mIsFavorite;

-(void) setMessage:(MesiboMessage *)message;

-(MesiboMessage *) getMesiboMessage;

-(int) getType;
-(void) setType:(int) type;

-(NSString *) getTitle;
-(NSString *) getMessage;
-(BOOL) hasImage;
-(UIImage *) getThumbnail;
-(UIImage *) getImage;
-(UIImage *) updateDefaultFileImage;
-(UIImage *) getCustomImage;
-(uint32_t) getCustomColor;
-(uint64_t) getMid;

-(NSString *) getTime;
-(NSString *) getDate;

-(void) resetHeight;
-(void) setHeight:(int)height;
-(int) getHeight;


-(void) setViewHolder:(id) vh;
-(id) getViewHolder;

@end
