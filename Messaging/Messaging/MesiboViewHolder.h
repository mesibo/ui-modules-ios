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

#import <UIKit/UIKit.h>
#import "MesiboTableController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MesiboViewHolder : UITableViewCell

-(void) reset;

// once set, can not be unset
-(void) setCustomCell;

-(BOOL) isCustomCell;
-(void) setParent:(UIViewController *) parent;
-(UIViewController *) getParent;

-(void) setTableController:(MesiboTableController *) tc;
-(MesiboTableController *) getTableController;

-(BOOL) isSelectionMode;
-(void) addSelectedMessage:(id)data;
-(BOOL) isSelected:(id)data;


-(void) delete:(nullable id)sender;
-(void) forward:(id)sender;
-(void) resend:(id)sender;
-(void) share:(id)sender;
-(void) reply:(id)sender;

-(UIView *) getAccessoryView;

@end

NS_ASSUME_NONNULL_END
