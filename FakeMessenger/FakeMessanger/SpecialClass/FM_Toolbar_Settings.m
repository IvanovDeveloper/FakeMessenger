//
//  FM_Toolbar_Settings.m
//  FakeMessanger
//
//  Created by Developer on 3/31/14.
//  Copyright (c) 2014 Roga. All rights reserved.
//

#import "FM_Toolbar_Settings.h"

#define k_V_FixedBtn 220
#define k_V_DoneBtn 60

#define k_F_Self_X 0
#define k_F_Self_Y 0
#define k_F_Self_W 320
#define k_F_Self_H 44

@implementation FM_Toolbar_Settings

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.translucent = YES;
        [self addButtons];
    }
    return self;
}

- (id)initCustom
{
    self = [ super init ];
    if(self)
    {
        self.translucent = YES;
        self.frame = CGRectMake(k_F_Self_X, k_F_Self_Y, k_F_Self_W, k_F_Self_H);
        [self addButtons];
    }
    return self;
}

-(void)addButtons
{
    UIBarButtonItem *fixedButton = [[ UIBarButtonItem alloc ] init];
    fixedButton.width = k_V_FixedBtn;
    
    self.doneBtn = [[ UIBarButtonItem alloc ]initWithTitle:localize(k_T_Done) style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.doneBtn.width = k_V_DoneBtn;
    
    [self setItems:[NSArray arrayWithObjects:fixedButton, self.doneBtn, nil]];
}

@end
