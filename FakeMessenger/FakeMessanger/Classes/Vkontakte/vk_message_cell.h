//
//  vkonakteCell.h
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_vk.h"

@interface vk_message_cell : UITableViewCell

- (void)setupMessage:(DB_vk *)dictNow mesageBefore:(DB_vk *)dictBefore;

@end
