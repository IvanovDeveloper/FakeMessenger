//
//  vk_cell_PostMessage.h
//  FakeMessanger
//
//  Created by developer on 10/10/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    cell_Switch = 0,
    cell_Music = 1,
    cell_Image,
    cell_Text_View,
}CellType2;

#define kSwitch  1

@interface vk7_settings_cell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(CellType2)type;

@end
