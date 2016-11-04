//
//  vibonaktePostMessage.h
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_vib.h"

@interface vib_settings_vc : UIViewController < UITableViewDataSource, UITableViewDelegate>

- (id)initWithInfoMessage:(DB_vib *)infoMessage andRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier;
- (id)initWithRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier;

@end
