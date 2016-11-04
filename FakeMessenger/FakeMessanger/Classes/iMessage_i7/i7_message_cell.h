//
//  iPhoneCell.h
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_i7.h"

@interface i7_message_cell : UITableViewCell

- (void)setupMessage:(DB_i7 *)dictNow mesageBefore:(DB_i7 *)dictBefore mesageAfter:(DB_i7 *)dictAfter;

@end
