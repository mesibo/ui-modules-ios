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

#ifndef MesiboStrings_h
#define MesiboStrings_h

#import "UIColors.h"


#define NAVIGATION_BAR_COLOR 0XFF00868b
#define NAVIGATION_TITLE_COLOR 0XFFFFFFFF

/* ----------------------------Bubblechatcell.m---------------------------*/
#define STATUS_ICON_SIZE 20
#define FILE_PROGRESS_SIZE 40

#define ICON_SIZE 20
#define HALF_ICON_SIZE 10

#define MAX_SIZE_TEXTWIDTH_PERCENTAGE 0.75
//pic_max_witdh = [MesiboInstance getMessageWidthInPoints];

#define SEMI_TANSPERENT_COLOR  0X40000000



/* ----------------------------MesiboImages.m---------------------------*/


#define NOTIFIED_TICK_COLOR            0XA023b1ef
#define NORMAL_TICK_COLOR              0XFFAAAAAA
#define ERROR_TICK_COLOR               0XFFCC0000

#define CHECKED_COLOR              0XFF00868b

#define ICON_COLOR_MISSEDCALL               0XFFCC0000
#define ICON_COLOR_DELETED               0XFFAAAAAA

#define USERLIST_ICON_COLOR               0XFF7F7F7F

/* -------------------------- MessageViewController.m--------------*/

#define PROFILE_THUMBNAIL_IMAGE_NAVBAR 32
#define ACTIVITY_DISPLAY_DURATION 10000
#define STATUS_CAST  (ACTIVITY_DISPLAY_DURATION - 2000)
#define ONLINE_TIME 60000




#define NO_CONTACTS_AVAILABLE  @"No contact is currently available."

#define DEFAULT_MSGPARAMS_EXPIRY 3600*24*7

#define MESIBO_READ_MESSAGES  20

#define NAVBAR_LEFT_MARGIN  -16
#define UIBAR_BUTTON_SIZE 44
#define NAVBAR_TITLEVIEW_WIDTH 160
#define NAVBAR_TITLE_FONT_SIZE  16
#define NAVBAR_TITLE_FONT_DISPLACEMENT 5
#define NAVBAR_SUBTITLE_FONT_SIZE 12
#define NAVBAR_TITLEVIEW_HEIGHT 18
#define CHATBOX_PLACE_HOLDER_TEXT @"Type your message . . ."

#define REPLY_VIEW_CORNER_RADIUS 5.0


#define MESSAGE_DATE_FORMAT   @"d MMM yyyy"
#define MESSAGE_DATE_LASTWEEK_FORMAT   @"E, d MMM"

#define MESSAGE_DATE_SECTION_HEIGHT   40.0
#define MESSAGE_DATE_FONT_NAME  @"Helvetica"
#define MESSAGE_DATE_LABEL_CORNER_RADIUS  10.0

#define REPLYVIEW_HEIGHT_PADDING_INTERNAL 5



#define REPLY_VIEW_NIB_NAME @"ReplyOnlyTextView"
#define REPLY_VIEW_WITH_IMAGE_NIB_NAME @"ReplyImageView"

#define MIN_TEXT_VIEW_HEIGHT  35
#define MAX_TEXT_VIEW_HEIGHT  100


#define MENU_RESEND_TITLE  @"Resend"
#define MENU_FORWARD_TITLE  @"Forward"
#define MENU_SHARE_TITLE  @"Share"
#define MENU_FAVORITE_TITLE  @"Favorite"
#define MENU_REPLY_TITLE  @"Reply"
#define MENU_REPLY_ENCRYPTION  @"Encryption"

#define MSG_STATUS_131_4GROUP_TITLE  @"Invalid Group"
#define MSG_STATUS_131_4GROUP_MESSAGE  @"You are not a member of this group or not allowed to send message to this group"
#define YOU_STRING_REPLY_VIEW  @"You"


/* -------------------------- USERLISTVIEWCONTROLLER.m--------------*/


#define USERLIST_STATUS_ICON_SIZE    18
#define LETTER_TITLE_IMAGE_SIZE 150
#define SECTION_CELL_HEIGHT 40


#define USERLIST_NAVBAR_BUTTON_SIZE  UIBAR_BUTTON_SIZE


//#define CREATE_NEW_GROUP_STRING @"Create a New Group"
#define CREATE_NEW_GROUP_DISCRIPTION  @"Add group members from the list"

#define ATTACHMENT_STRING @" Attachment"
#define IMAGE_STRING @" Picture"
#define VIDEO_STRING @" Video"
#define AUDIO_STRING @" Audio"
#define LOCATION_STRING @" Location"

#define DELETE_ALERT_MESSAGES  @"Delete chat with %@"

#define FORWARD_ALERT_TITLE  @"Forwarding"
#define FORWARD_ALERT_MESSAGE @"Select users from the list."

#define CREATE_NEW_GROUP_ALERT_TITLE  @"New Group"
#define CREATE_NEW_GROUP_ALERT_MESSAGE @"Add group members from the list"

#define EMPTY_USERLIST_MESAGE_FONT_NAME @"Palatino-Italic"
#define EMPTY_USERLIST_MESAGE_FONT_COLOR GRAY_COLOR
#define EMPTY_USERLIST_MESAGE_FONT_SIZE 20.0



#define ARCHIVE_TITLE_STRING  @"Archive"

#define  FREQUENT_USER_LIST_STRING @"Frequent Users"
#define  SEARCH_USERS_STRING    @" %d USERS"
#define  SEARCH_MESSAGES_STRING  @" %d MESSAGES"

#define  CREATE_GROUP_TITLE_STRING  @"Create Group"
#define  MODIFY_GROUP_TITLE_STRING  @"Edit Group"

#define  GROUP_NAME_FAIL_TITLE  @"Group name"
#define  GROUP_NAME_FAIL_MSG  @"Group name should be more than 2 characters"

#define  GROUP_CREATION_FAIL_TITLE  @"Group Creation Faied"
#define  GROUP_CREATION_FAIL_MSG  @"Please check internet connection and try again later"

#define  GROUP_PICTURE_TITLE_STRING  @"Group picture"
#define  GROUP_PICTURE_MSG_STRING  @"Change your group picture."
#define  CAMERA_STRING  @"Camera"
#define  PHOTOGALLERY_STRING  @"PhotoGallery"
#define  CANCEL_STRING  @"Cancel"


#define  CREATE_GROUP_NOMEMEBER_TITLE_STRING  @"No Members"
#define  CREATE_GROUP_NOMEMEBER_MESSAGE_STRING  @"Add two or more members to create a group"


#define CROPPER_TITLE @"Crop image or rotate"

#endif /* MesiboStrings_h */
