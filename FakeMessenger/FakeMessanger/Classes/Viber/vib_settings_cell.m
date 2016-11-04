//
//  vib_cell_PostMessage.m
//  FakeMessanger
//
//  Created by developer on 10/10/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "vib_settings_cell.h"

@interface vib_settings_cell ()

@property (assign, nonatomic) CellType2 type;

@end

@implementation vib_settings_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(CellType2)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.type = type;
        
        self.outButton = [ [ UIButton alloc ] initWithFrame:CGRectMake( 0.f, 0.f, 160.f, 44.f ) ];
        self.inButton  = [ [ UIButton alloc ] initWithFrame:CGRectMake( 160.f, 0.f, 160.f, 44.f )];
        self.outDeleteButton = [ UIButton buttonWithType:UIButtonTypeCustom ];
        self.inDeleteButton  = [ UIButton buttonWithType:UIButtonTypeCustom ];
        self.outImg = [ [ UIImageView alloc ] initWithFrame:CGRectMake(is_ios_7()?17.f:11.f, 2.f, 40.f, 40.f) ];
        self.inImg  = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0.f, 2.f, 40.f, 40.f) ];
        
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

// ImageView
            
//            UIImageView *outImg = [ [ UIImageView alloc ] initWithFrame:CGRectMake(is_ios_7()?17.f:11.f, 2.f, 40.f, 40.f) ];
//            UIImageView *inImg  = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0.f, 2.f, 40.f, 40.f) ];
            
//            NSString *outSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_outImage.png"];
//            UIImage *outImageFromCaches = [UIImage imageWithContentsOfFile:outSTR];
//            if ( outImageFromCaches != nil )
//                self.outImg.image = outImageFromCaches;
//            else
//                self.outImg.image = [ UIImage imageNamed:@"vib_bm_DefaultAvatar" ];
//            
//            NSString *inSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_inImage.png"];
//            UIImage *inImageFromCaches = [UIImage imageWithContentsOfFile:inSTR];
//            if ( inImageFromCaches != nil )
//                self.inImg.image = inImageFromCaches;
//            else
//                self.inImg.image = [ UIImage imageNamed:@"vib_bm_DefaultAvatar" ];
// Label
            
            UILabel *outLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(is_ios_7()?73.f:63.f, 0.f, 66, 44) ];
            outLabel.backgroundColor = [ UIColor clearColor ];
            outLabel.text = is_RU_lang()?@"Фото\nдруга":@"Photo\nfriend";
            outLabel.font = [ UIFont fontWithName:@"Helvetica" size:12 ];
            outLabel.numberOfLines = 2;
            outLabel.opaque = NO;
            
            UILabel *inLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(56.f, 0.f, 66, 44) ];
            inLabel.backgroundColor = [ UIColor clearColor ];
            inLabel.text = is_RU_lang()?@"Моё\nфото":@"My\nphoto";
            inLabel.font = [ UIFont fontWithName:@"Helvetica" size:12 ];
            inLabel.numberOfLines = 2;
            inLabel.opaque = NO;
           
// Delete Button
            
            self.outDeleteButton.frame = CGRectMake(116.0, 0.0, 44, 44);
            self.outDeleteButton.backgroundColor = [UIColor clearColor];
            [self.outDeleteButton setBackgroundImage:[UIImage imageNamed:@"FM_sett_Delete"] forState:UIControlStateNormal];
            
            self.inDeleteButton.frame = CGRectMake(is_ios_7()?101.0:107.f, 0.0, 44, 44);
            self.inDeleteButton.backgroundColor = [UIColor clearColor];
            [self.inDeleteButton setBackgroundImage:[UIImage imageNamed:@"FM_sett_Delete"] forState:UIControlStateNormal];
            
// Add to cell
            [ self addSubview:self.outButton ];
            [ self addSubview:self.inButton ];
            [ self.outButton addSubview:self.outImg ];
            [ self.inButton  addSubview:self.inImg ];
            [ self.outButton addSubview:outLabel ];
            [ self.inButton  addSubview:inLabel ];
            [ self.outButton addSubview:self.outDeleteButton ];
            [ self.inButton  addSubview:self.inDeleteButton ];
            
            
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