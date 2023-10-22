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
#import "Mesibo/Mesibo.h"
#import "MesiboTableController.h"

#import "MesiboMessageView.h"

#define MODEL_MODE_MESSAGE   0
#define MODEL_MODE_LIST      1

NS_ASSUME_NONNULL_BEGIN

@protocol MesiboModelDelegate <NSObject>

@required
- (void) scrollToBottom:(BOOL)animated;
- (void) scrollToLatestChat:(BOOL)animation;

- (void) reloadTable:(BOOL)scrollToLatest;
- (void) reloadRow:(NSInteger)row;
- (void) reloadRows:(NSArray *)rows;
- (void) reloadMessage:(id)m;
@optional
@end

@interface MesiboModel : NSObject 

-(void) reset;
-(void) setMode:(int)mode ;
-(void) enableTimestamp:(BOOL)enable;
-(void) enableReverseOrder:(BOOL)enable;
-(void) insert:(MesiboMessage *) m;
//-(void) deleteMessages:(NSArray *) msgs type:(int)type;
-(void) deleteMessage:(MesiboMessageView *)m remote:(BOOL)remote refresh:(BOOL)refresh;
-(MesiboMessageView *) get:(int)row;

-(void) Mesibo_OnMessageStatus:(MesiboParams *)params;
-(BOOL) Mesibo_onFileTransferProgress:(MesiboFileInfo *)file;

-(NSInteger) count;

//TBD. instead of this, we should have protocol/delegate
-(void) setTable:(MesiboTableController *) table;

@end

NS_ASSUME_NONNULL_END
