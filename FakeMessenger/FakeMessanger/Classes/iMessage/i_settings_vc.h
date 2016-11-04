//
//  iPhonePostMessage.h
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DB_i.h"

@interface i_settings_vc : UIViewController

- (id)initWithInfoMessage:(DB_i *)infoMessage andRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier;
- (id)initWithRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier;

@end
