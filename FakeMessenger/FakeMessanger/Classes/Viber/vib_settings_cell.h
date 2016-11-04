//
//  vib_cell_PostMessage.h
//  FakeMessanger
//
//  Created by developer on 10/10/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    cell_Switch,
    cell_Music,
    cell_Image,
    cell_Text_View,
}CellType2;

#define kSwitch  1

@interface vib_settings_cell : UITableViewCell

@property(nonatomic, strong) UIButton *outButton;
@property(nonatomic, strong) UIButton *inButton;
@property(nonatomic, strong) UIButton *outDeleteButton;
@property(nonatomic, strong) UIButton *inDeleteButton;
@property(nonatomic, strong) UIImageView *outImg;
@property(nonatomic, strong) UIImageView *inImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(CellType2)type;

@end
