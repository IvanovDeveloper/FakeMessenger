//
//  vibonakteCell.m
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "vib_message_cell.h"
#import "DB_vib.h"

#import "NSDate-Utilities.h"

#define k_Date_Offset 26.f
#define k_DateAvatar_Offset 26.f

#define k_Date_Label_Offset_X 5.f
#define k_Date_Label_Offset_Y 4.5f
#define k_Date_Label_Font_size 12.f

#define k_Time_Label_Font_size 10.f

#define k_Text_Label_output_Offset_X 8.f
#define k_Text_Label_input_Offset_X  12.5f
#define k_Text_Label_output_Offset_Y 5.f
#define k_Text_Label_input_Offset_Y  8.f
#define k_Text_Label_Font_Size 16.f
//#define k_Text_Label_Offset_Y 6.f

//Avatar View

#define k_AvatarView_output_Offset_X 278.5f
#define k_AvatarView_input_Offset_X  1.5f
#define k_AvatarView_Offset_Y 2.f
#define k_AvatarView_Offset_W 40.f
#define k_AvatarView_Offset_H 40.f

#define k_AvatarImage_Offset_X 2.f
#define k_AvatarImage_Offset_Y 2.f
#define k_AvatarImage_Offset_W 36.f
#define k_AvatarImage_Offset_H 36.f

#define k_DelivierdImage_Offset_X 9.f
#define k_DelivierdImage_Offset_Y 16.f
#define k_DelivierdImage_Offset_W 0.f
#define k_DelivierdImage_Offset_H 0.f

@interface vib_message_cell ()
{
    UILabel *dateLabel;
    UILabel *timeLabel;
    UILabel *textLabel;

    UIView *avatarView;
    UIImageView *avatarImage;
    UIImageView *imageView;
    UIImageView *deliveredImage;
    UIImageView *bubbleImage;
}

@end

@implementation vib_message_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
#pragma mark Init
        
        bubbleImage    = [ [ UIImageView alloc ] init ];
        deliveredImage = [ [ UIImageView alloc ] init ];
        imageView      = [ [ UIImageView alloc ] init ];
        avatarImage    = [ [ UIImageView alloc ] init ];
        avatarView = [ [ UIView alloc ] init ];
        textLabel = [ [ UILabel alloc ] init ];
        dateLabel = [ [ UILabel alloc ] init ];
        timeLabel = [ [ UILabel alloc ] init ];

#pragma mark Date
        
        dateLabel.backgroundColor = RGBa(109.0f, 101.0f, 85.0f, 0.5f);
        dateLabel.textColor   = [ UIColor whiteColor ];
        dateLabel.layer.cornerRadius = 10.f;
        dateLabel.layer.masksToBounds = YES;
        dateLabel.font = [ UIFont fontWithName:@"HelveticaNeue-Bold" size:k_Date_Label_Font_size ];
        
#pragma mark Time
        
        timeLabel.backgroundColor = RGBa(109.0f, 101.0f, 85.0f, 0.5f);
        timeLabel.textColor   = [ UIColor whiteColor ];
        timeLabel.layer.cornerRadius = 10.f;
        timeLabel.layer.masksToBounds = YES;
        timeLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Time_Label_Font_size ];
        
#pragma mark Text

        textLabel.backgroundColor = [ UIColor clearColor ];
        textLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Text_Label_Font_Size ];

#pragma mark Image

        imageView.layer.cornerRadius = 4.f;
        imageView.layer.masksToBounds = YES;
        CGColorRef borderColor = CGColorRetain([UIColor colorWithRed:(77.0f/255.f) green:(77.0f/255.f) blue:(77.0f/255.f) alpha:1.0].CGColor);
        imageView.layer.borderColor = borderColor;
        imageView.layer.borderWidth = 0.8f;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor colorWithRed:(220.0f/255.f) green:(221.0f/255.f) blue:(224.0f/255.f) alpha:1.0];
  
#pragma mark Avatar

        avatarView.layer.cornerRadius = 7.f;
        avatarView.layer.masksToBounds = YES;
        avatarView.backgroundColor = RGBa(109.0f, 101.0f, 85.0f, 0.5f);
        
        avatarImage.frame = CGRectMake(k_AvatarImage_Offset_X, k_AvatarImage_Offset_Y, k_AvatarImage_Offset_W, k_AvatarImage_Offset_H);
        avatarImage.layer.cornerRadius = 7.f;
        avatarImage.layer.masksToBounds = YES;
        
#pragma mark Cell setup
        
        deliveredImage.image = [ UIImage imageNamed:is_RU_lang()?@"vib_bm_Delivered_RUS":@"vib_bm_Delivered_ENG" ];
        
        
        self.backgroundColor = [ UIColor clearColor ];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Setup -

- (void)setupMessage:(DB_vib *)dictNow mesageBefore:(DB_vib *)dictBefore
{
#pragma mark Reset

    int offsetDate = 0;
    int offsetDateAvatar = 0;
    textLabel.frame   = CGRectZero;
    dateLabel.frame   = CGRectZero;
    timeLabel.frame   = CGRectZero;
    imageView.frame   = CGRectZero;
    bubbleImage.frame = CGRectZero;

    textLabel.text       = nil;
    dateLabel.text       = nil;
    timeLabel.text       = nil;
    imageView.image      = nil;
    bubbleImage.image    = nil;
    
    [timeLabel      removeFromSuperview];
    [dateLabel      removeFromSuperview];
    [avatarView     removeFromSuperview];
    [textLabel      removeFromSuperview];
    [imageView      removeFromSuperview];
    [deliveredImage removeFromSuperview];
    [bubbleImage    removeFromSuperview];
    

#pragma mark Date
    
    double timestamp = [ dictNow.d_timestamp doubleValue];
    NSTimeInterval interval = timestamp;
    NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MMMM-dd";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:is_RU_lang()?@"ru_RU":@"en_GB" ];

    double timestamp2 = [ dictBefore.d_timestamp doubleValue];
    NSTimeInterval interval2 = timestamp2;
    NSDate *dateFromDB2 = [ NSDate dateWithTimeIntervalSince1970:interval2 ];
    NSDateFormatter *dateFormatter2 = [ [ NSDateFormatter alloc ] init ];
    dateFormatter2.dateFormat = @"YYYY-MMMM-dd";
    dateFormatter2.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:is_RU_lang()?@"ru_RU":@"en_GB" ];
    
    
    NSString *now    = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB ] ];
    NSString *before = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB2 ] ];
    
    if ( [ now isEqualToString:before ] )
    {
        
    }
    else
    {
        offsetDateAvatar = k_DateAvatar_Offset;
        offsetDate = k_Date_Offset;
        [ self addSubview:dateLabel ];
    }
    
    NSDate *post_date = dateFromDB;
    if( [ post_date isToday ] )
    {
            dateLabel.text = is_RU_lang()?@"  Cьогоднi  ":@"  Today  ";
    }
    else
    {
        if( [ post_date isYesterday ] )
        {
            dateLabel.text = is_RU_lang()?@"  Вчера  ":@"  Yesterday  ";
        }
        else
        {
            if ( is_RU_lang() )
            {
                [ dateFormatter setDateFormat:@"d" ];
                NSString *day = [ dateFormatter stringFromDate:dateFromDB ];
                [ dateFormatter setDateFormat:@"MMMM" ];
                NSString *month = [ [ dateFormatter stringFromDate:dateFromDB ] lowercaseString ];
                [ dateFormatter setDateFormat:@"yyyy" ];
                dateLabel.text = [ NSString stringWithFormat:@"  %@ %@ %@ г.  ",day, month, [ dateFormatter stringFromDate:dateFromDB ] ];
            }
            else
            {
                [ dateFormatter setDateFormat:@"d" ];
                NSString *day = [ dateFormatter stringFromDate:dateFromDB ];
                [ dateFormatter setDateFormat:@"MMMM" ];
                NSString *month = [ dateFormatter stringFromDate:dateFromDB ];
                [ dateFormatter setDateFormat:@"yyyy" ];
                dateLabel.text = [ NSString stringWithFormat:@"  %@ %@, %@  ",month, day, [ dateFormatter stringFromDate:dateFromDB ] ];
            }
        }
    }

    [ dateLabel sizeToFit ];
    
    dateLabel.frame = CGRectMake( ( ( self.bounds.size.width/2 ) - ( dateLabel.frame.size.width/2 ) + k_Date_Label_Offset_X ),
                                 k_Date_Label_Offset_Y,
                                 dateLabel.frame.size.width,
                                 21.f);
    

   
    
    
#pragma mark Time
    
    dateFormatter.dateFormat = @"  HH:mm  ";
    timeLabel.text = [ dateFormatter stringFromDate:dateFromDB ];
    timeLabel.frame = CGRectMake([ dictNow.f_time_x floatValue ],
                                 [ dictNow.f_time_y floatValue ] + offsetDate,
                                 [ dictNow.f_time_w floatValue ],
                                 [ dictNow.f_time_h floatValue ]);
    
    
#pragma mark Text
    
    if( dictNow.s_text_message != nil )
    {
        if ( [ dictNow.bool_inputMassege boolValue ] == 0 )
        {
            textLabel.frame = CGRectMake(k_Text_Label_output_Offset_X,
                                         k_Text_Label_output_Offset_Y,
                                         [ dictNow.f_text_label_w floatValue ],
                                         [ dictNow.f_text_label_h floatValue ]);
        }
        else
        {
            textLabel.frame = CGRectMake(k_Text_Label_input_Offset_X,
                                         k_Text_Label_input_Offset_Y,
                                         [ dictNow.f_text_label_w floatValue ],
                                         [ dictNow.f_text_label_h floatValue ]);
        }
        
        textLabel.text = dictNow.s_text_message;
        textLabel.numberOfLines = 0;
        textLabel.opaque = NO;
    }
    
#pragma mark Image
    
    if( dictNow.data_image != nil)
    {
        imageView.image = [ UIImage imageWithData:dictNow.data_image ];
        imageView.frame = CGRectMake([ dictNow.f_image_view_x floatValue ],
                                     [ dictNow.f_image_view_y floatValue ],
                                     [ dictNow.f_image_view_w floatValue ],
                                     [ dictNow.f_image_view_h floatValue ]);
        if( ( dictNow != nil && dictBefore != nil )
           && ( ( [ dictNow.bool_inputMassege boolValue ] == 0 && [ dictBefore.bool_inputMassege boolValue ] == 0 )
               || ( [ dictNow.bool_inputMassege boolValue ] == 1 && [ dictBefore.bool_inputMassege boolValue ] == 1 ) ) )
        {
            imageView.frame = CGRectMake([ dictNow.f_image_view_x floatValue ],
                                         [ dictNow.f_image_view_y floatValue ],
                                         [ dictNow.f_image_view_w floatValue ],
                                         [ dictNow.f_image_view_h floatValue ]);
        }
    }
    
#pragma mark Avatar

    if( [ dictNow.bool_inputMassege boolValue ] == 0 )//Исходящие
    {
        avatarView.frame = CGRectMake(k_AvatarView_output_Offset_X, k_AvatarView_Offset_Y + offsetDateAvatar, k_AvatarView_Offset_W, k_AvatarView_Offset_H);
        
        if ( [ dictNow.bool_anonym boolValue ] == 1)
        {
            NSString *inBluredSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_inBluredImage.png"];
            UIImage *inBluredImageFromCaches = [UIImage imageWithContentsOfFile:inBluredSTR];
            if ( inBluredImageFromCaches != nil )
                avatarImage.image = inBluredImageFromCaches;
            else
                avatarImage.image = [ UIImage imageNamed:@"vib_bm_DefaultAvatar" ];
        }
        else
        {
            NSString *inSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_inImage.png"];
            UIImage *inImageFromCaches = [UIImage imageWithContentsOfFile:inSTR];
            if ( inImageFromCaches != nil )
                avatarImage.image = inImageFromCaches;
            else
                avatarImage.image = [ UIImage imageNamed:@"vib_bm_DefaultAvatar" ];
        }
    }
    else
    {
        avatarView.frame = CGRectMake(k_AvatarView_input_Offset_X, k_AvatarView_Offset_Y + offsetDateAvatar, k_AvatarView_Offset_W, k_AvatarView_Offset_H);
        
        if ( [ dictNow.bool_anonym boolValue ] == 1)
        {
            NSString *outBluredSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_outBluredImage.png"];
            UIImage *outBluredImageFromCaches = [UIImage imageWithContentsOfFile:outBluredSTR];
            if ( outBluredImageFromCaches != nil )
                avatarImage.image = outBluredImageFromCaches;
            else
                avatarImage.image = [ UIImage imageNamed:@"vib_bm_DefaultAvatar" ];
        }
        else
        {
            NSString *outSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_outImage.png"];
            UIImage *outImageFromCaches = [UIImage imageWithContentsOfFile:outSTR];
            if ( outImageFromCaches != nil )
                avatarImage.image = outImageFromCaches;
            else
                avatarImage.image = [ UIImage imageNamed:@"vib_bm_DefaultAvatar" ];
        }
    }
    
    if( ( dictNow != nil && dictBefore != nil )
    && [ now isEqualToString:before ]
    && ( ( [ dictNow.bool_inputMassege boolValue ] == 0 && [ dictBefore.bool_inputMassege boolValue ] == 0 )
      || ( [ dictNow.bool_inputMassege boolValue ] == 1 && [ dictBefore.bool_inputMassege boolValue ] == 1 ) ) )
    {

    }
    else
    {
            [ self addSubview:avatarView ];
    }
    
#pragma mark Bubble
    
    if( [ dictNow.bool_inputMassege boolValue ] == 0 )//Исходящие
    {
        if( ( dictNow != nil && dictBefore != nil )
           && [ now isEqualToString:before ]
           && ( ( [ dictNow.bool_inputMassege boolValue ] == 0 && [ dictBefore.bool_inputMassege boolValue ] == 0 )
               || ( [ dictNow.bool_inputMassege boolValue ] == 1 && [ dictBefore.bool_inputMassege boolValue ] == 1 ) ) )
        {
            bubbleImage.image = [ [ UIImage imageNamed:@"vib_bm_BubbleBlue2" ] resizableImageWithCapInsets:UIEdgeInsetsMake(25.f, 21.f, 70.f, 70.f) ];
        }
        else
        {
            bubbleImage.image = [ [ UIImage imageNamed:@"vib_bm_BubbleBlue" ] resizableImageWithCapInsets:UIEdgeInsetsMake(25.f, 21.f, 70.f, 70.f) ];
        }
        
        deliveredImage.frame = CGRectMake(k_DelivierdImage_Offset_X,
                                          [ dictNow.f_bubble_h floatValue ] - k_DelivierdImage_Offset_Y,
                                          deliveredImage.image.size.width,
                                          deliveredImage.image.size.height);
        
    }
    if ( [ dictNow.bool_inputMassege boolValue ] == 1 )//Входящее
    {
        if( ( dictNow != nil && dictBefore != nil )
           && [ now isEqualToString:before ]
           && ( ( [ dictNow.bool_inputMassege boolValue ] == 0 && [ dictBefore.bool_inputMassege boolValue ] == 0 )
               || ( [ dictNow.bool_inputMassege boolValue ] == 1 && [ dictBefore.bool_inputMassege boolValue ] == 1 ) ) )
        {
            bubbleImage.image = [ [ UIImage imageNamed:@"vib_bm_BubbleWhite2" ] resizableImageWithCapInsets:UIEdgeInsetsMake(25.f, 21.f, 70.f, 70.f) ];
        }
        else
        {
            bubbleImage.image = [ [ UIImage imageNamed:@"vib_bm_BubbleWhite" ] resizableImageWithCapInsets:UIEdgeInsetsMake(25.f, 21.f, 70.f, 70.f) ];
        }
    }
    
    bubbleImage.frame = CGRectMake([ dictNow.f_bubble_x floatValue ],
                                   [ dictNow.f_bubble_y floatValue ] + offsetDate,
                                   [ dictNow.f_bubble_w floatValue ],
                                   [ dictNow.f_bubble_h floatValue ]);
    
    bubbleImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
#pragma mark Add to Cell
    
    if ( dictNow.s_text_message != nil && dictNow.data_image == nil )
    {
        [ bubbleImage addSubview:textLabel ];
        [ self addSubview:bubbleImage ];
    }
    if ( dictNow.data_image != nil )
    {
        [ bubbleImage addSubview:imageView ];
    }
    if( [ dictNow.bool_inputMassege boolValue ] == 0 )
    {
        [ bubbleImage addSubview:deliveredImage ];
    }
    [ avatarView addSubview:avatarImage ];
    [ self addSubview:timeLabel ];
    [ self addSubview:bubbleImage ];
    
    NSLog(@"\n");
    NSLog(@"Y Date_Label %f",dateLabel.frame.origin.y);
    NSLog(@"Y Text_Label %f",textLabel.frame.origin.y);
    NSLog(@"Y Image_View %f",imageView.frame.origin.y);
    NSLog(@"Y BubbleView %f",bubbleImage.frame.origin.y);
    
    NSLog(@"H Date_Label %f",dateLabel.frame.size.height);
    NSLog(@"H Text_Label %f",textLabel.frame.size.height);
    NSLog(@"H Image_view %f",imageView.frame.size.height);
    NSLog(@"H BubbleView %f",bubbleImage.frame.size.height);
    NSLog(@"\n");
}

#pragma mark - Default -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [ super setSelected:selected animated:animated ];
}

@end