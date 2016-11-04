//
//  vkonakteCell.h
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_vk7.h"

@interface vk7_message_cell : UITableViewCell

- (void)setupMessage:(DB_vk7 *)dictNow mesageBefore:(DB_vk7 *)dictBefore;

@end
