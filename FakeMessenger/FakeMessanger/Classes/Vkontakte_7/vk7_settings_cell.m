//
//  vk_cell_PostMessage.m
//  FakeMessanger
//
//  Created by developer on 10/10/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "vk7_settings_cell.h"

@interface vk7_settings_cell ()

@property (assign, nonatomic) CellType2 type;

@end

@implementation vk7_settings_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(CellType2)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.type = type;
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.textLabel.font = [UIFont systemFontOfSize:16];
        [ self setSelectionStyle:UITableViewCellSelectionStyleNone ];
        
        [self layout];
    }
    return self;
}

- (void)layout
{
    switch (self.type)
    {
        case cell_Music:
        {
            self.imageView.image = [ UIImage imageNamed:@"vk7_sett_MusicPlayDefault" ];
            self.textLabel.font = [UIFont systemFontOfSize:12];
            self.detailTextLabel.font = [UIFont systemFontOfSize:10];
            
            break;
        }
        case cell_Image:
        {

        }
        default:
            break;
    }
}
@end