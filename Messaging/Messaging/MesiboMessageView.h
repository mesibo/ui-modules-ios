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
