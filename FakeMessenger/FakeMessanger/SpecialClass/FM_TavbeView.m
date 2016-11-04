//
//  FM_TavleView.m
//  FakeMessanger
//
//  Created by developer on 12/3/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "FM_TableView.h"

#define k_Table_H_is_4_inch 465.f
#define k_Table_H_is_3_5_inch 377.f
#define k_Table_W 320.f

@implementation FM_TableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
//    self = [super init];
    if (self)
    {
        if (is_4_inch())
            self.frame = CGRectMake(0, 0, k_Table_W, k_Table_H_is_4_inch);
        else
            self.frame = CGRectMake(0, 0, k_Table_W, k_Table_H_is_3_5_inch);
        
        self.backgroundColor = [ UIColor clearColor ];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
