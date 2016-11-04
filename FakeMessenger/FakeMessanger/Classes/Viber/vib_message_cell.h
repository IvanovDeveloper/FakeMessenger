//
//  vibonakteCell.h
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_vib.h"

@interface vib_message_cell : UITableViewCell

- (void)setupMessage:(DB_vib *)dictNow mesageBefore:(DB_vib *)dictBefore;

@end
