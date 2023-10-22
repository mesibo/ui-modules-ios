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

#pragma once
#import <UIKit/UIKit.h>
#import "UserListViewController.h"

@class CreateNewGroupViewController;//define class, so protocol can see CreateNewGroupViewController
@protocol MesiboUIModifyGroupDelegate <NSObject>   //define delegate protocol
@optional
- (void) OnGroupDetailsModified: (CreateNewGroupViewController *) sender withPicturePath:(NSString*) picturePath withGroupName:(NSString*) groupName ;

@end 

@interface CreateNewGroupViewController : UIViewController <MesiboDelegate>
@property (strong , nonatomic) NSMutableArray   *mMemberProfiles;
@property (strong , nonatomic) NSMutableArray   *mExistingMembers;
@property (strong , nonatomic) UIViewController   *mParenController;
@property (assign , nonatomic) BOOL mGroupModifyMode;


@property (strong, nonatomic) NSString* mGroupName ;
@property (assign, nonatomic) uint32_t mGroupid ;
@property (weak, nonatomic) id mUiDelegate ;


@property (nonatomic, weak) id <MesiboUIModifyGroupDelegate> delegate; //define MyClassDelegate as delegate

@end
