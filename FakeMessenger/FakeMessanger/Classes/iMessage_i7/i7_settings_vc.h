//
//  iPhonePostMessage.h
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_i7.h"

@interface i7_settings_vc : UIViewController < UITableViewDataSource, UITableViewDelegate>

- (id)initWithInfoMessage:(DB_i7 *)infoMessage andRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier;
- (id)initWithRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier;

@end
