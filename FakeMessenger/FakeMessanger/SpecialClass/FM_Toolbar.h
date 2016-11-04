//
//  FM_Toolbar.h
//  FakeMessanger
//
//  Created by developer on 12/2/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FM_Toolbar : UIToolbar

@property(nonatomic, strong) UIButton *editButton;
@property(nonatomic, strong) UIButton *carrierButton;
@property(nonatomic, strong) UIButton *modeButton;
@property(nonatomic, strong) UIBarButtonItem *clear;
@property(nonatomic, strong) UIBarButtonItem *screenShot;
@property(nonatomic, strong) UIBarButtonItem *addPost;

@property(nonatomic, strong) NSMutableArray *toolbarButtons;
@end
