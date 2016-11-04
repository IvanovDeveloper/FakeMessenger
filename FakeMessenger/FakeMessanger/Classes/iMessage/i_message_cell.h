//
//  iPhoneCell.h
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_i.h"

@interface i_message_cell : UITableViewCell

- (void)setupMessage:(DB_i *)dictNow mesageBefore:(DB_i *)dictBefore;

@end
