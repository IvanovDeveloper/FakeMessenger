//
//  vkonakteCell.h
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_wat.h"

@interface wat_message_cell : UITableViewCell

- (void)setupMessage:(DB_wat *)dictNow mesageBefore:(DB_wat *)dictBefore;

@end
