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
#import "MessageData.h"

#define MESIBO_MODEL_MESSAGE   0
#define MESIBO_MODEL_SUMMARY      1

NS_ASSUME_NONNULL_BEGIN

@protocol MesiboMessageModelDelegate <NSObject>

@required
- (void) scrollToBottom:(BOOL)animated;
- (void) scrollToLatestChat:(BOOL)animated;

- (void) reloadTable:(BOOL)scrollToLatest;
- (void) reloadRow:(NSInteger)row;
- (void) reloadRows:(NSArray *)rows;
- (void) reloadRows:(NSInteger)start end:(NSInteger)end;
- (void) insertRow:(NSInteger)row;
- (void) onMessageStatus:(int)status;
- (void) onPresence:(int)presence;
- (void) onProfileUpdate;
- (void) onShutdown;
@optional
@end

@interface MesiboMessageModel : NSObject <MesiboDelegate>

-(void) reset;
-(void) setDestination:(MesiboMessageProperties *)params ;
-(BOOL) loadMessages:(int)count;
-(void) start;
-(void) pause;
-(void) stop;
-(void) updateConnectionStatus;
-(void) enableTimestamp:(BOOL)enable;
-(void) enableReverseOrder:(BOOL)enable;
-(void) enableCallLogs:(BOOL)enable;
-(void) enableMessages:(BOOL)enable;
-(void) enableReadReceipt:(BOOL)enable;
-(void) insert:(MesiboMessage *) m;
-(void) setMessageStatus:(uint64_t)msgid status:(int)status;
-(void) deleteMessage:(MessageData *)m remote:(BOOL)remote refresh:(BOOL)refresh;
-(void) deleteMessage:(uint64_t)msgid refresh:(BOOL)refresh;
-(MessageData *) get:(int)row;
-(NSInteger) count;
-(void) serach:(NSString *)query;


//TBD. instead of this, we should have protocol/delegate
-(void) setDelegate:(id) delegate;
-(int) lastStatus;

@end

NS_ASSUME_NONNULL_END
