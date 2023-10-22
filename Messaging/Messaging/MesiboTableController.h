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
#import "MesiboMessageModel.h"
#import "MesiboUI.h"

NS_ASSUME_NONNULL_BEGIN

// user MUST registerclass using MESIBO_CELL_IDENTIFIER
#define MESIBO_CELL_IDENTIFIER @"MesiboViewHolderCell"

@protocol MesiboTableControllerDelegate <NSObject>

@required
- (void) share:(NSString *) text image:(UIImage *)image;
- (BOOL) loadMessages;
- (void) enableSelectionActionButtons:(BOOL)enable buttons:(nullable NSArray *) buttons;
- (void) forwardMessages:(NSArray *) msgids;
- (void) reply:(id)data;

@optional
@end

@interface MesiboTableController : NSObject <MesiboDelegate, UITableViewDelegate , UITableViewDataSource>

-(void) setup:(id)parent screen:(MesiboMessageScreen *)screen model:(MesiboMessageModel *)model delegate:(id)delegate uidelegate:(id)uidelegate;

-(void) insert:(MesiboMessage *) m;

-(void) start;
-(void) stop;

-(void) scrollToBottom:(BOOL)animated;
-(void) scrollToLatestChat:(BOOL)animation;

-(void) reloadTable:(BOOL)scrollToLatest;
-(void) reloadRow:(NSInteger)row;
-(void) reloadRows:(NSArray *)rows;
-(void) reloadRows:(NSInteger)start end:(NSInteger)end;

-(BOOL) isSelectionMode;
-(void) addSelectedMessage:(id)data;
-(BOOL) isSelected:(id)data;
-(BOOL) cancelSelectionMode;

-(void) delete:(nullable id)sender;
-(void) forward:(id)sender;
-(void) resend:(id)sender;
-(void) reply:(id)sender;
-(void) share:(id)sender;
-(void)copy :(id) sender;

-(BOOL) onViewHolderClicked:(id) vh;

-(void)insertInTable:(NSInteger)row section:(NSInteger)section showLatest:(BOOL)showLatest animate:(BOOL)animate;

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(void) tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;
@end

NS_ASSUME_NONNULL_END
