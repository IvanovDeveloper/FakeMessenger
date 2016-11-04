//
//  vkonakteCell.m
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "wat_message_cell.h"
#import "DB_wat.h"

#import "NSDate-Utilities.h"

#define k_Date_Label_Offset_Y 15.f
#define k_Date_Label_Font_size 12.f
#define k_Date_Offset 25.f
#define k_Time_Label_Font_size 11.f

#define k_Checkmark_X 3.f
#define k_Checkmark_Y 4.f

#define k_Text_Label_output_Offset_X 8.f
#define k_Text_Label_input_Offset_X  17.f
#define k_Text_Label_Font_Size 16.f
#define k_Text_Label_Offset_Y 4.f

@interface wat_message_cell ()
{
    UILabel *dateLabel;
    UILabel *timeLabel;
    UILabel *textLabel;
    UIImageView *dateImage;
    UIImageView *checkmarkImage;
    UIImageView *imageView;
    UIImageView *bubbleImage;
}

@end

@implementation wat_message_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
#pragma mark Init
//        if (is_ios_6())
//            NSLog(@"");
        bubbleImage = [ [ UIImageView alloc ] init ];
        imageView   = [ [ UIImageView alloc ] init ];
        dateImage   = [ [ UIImageView alloc ] init ];
        checkmarkImage   = [ [ UIImageView alloc ] init ];
        textLabel = [ [ UILabel alloc ] init ];
        dateLabel = [ [ UILabel alloc ] init ];
        timeLabel = [ [ UILabel alloc ] init ];

#pragma mark Date
        
        dateImage.image = [ UIImage imageNamed:@"wat_bm_BubbleData" ];
        dateImage.frame = CGRectMake(110.f, 5.f, dateImage.image.size.width, dateImage.image.size.height );
        
        dateLabel.layer.cornerRadius = 10.f;
        dateLabel.layer.masksToBounds = YES;
        dateLabel.backgroundColor = [ UIColor clearColor ];
        dateLabel.textColor = [ UIColor blackColor ];
        dateLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Date_Label_Font_size ];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.frame = CGRectMake( 0, 0, 100.f, 20.f);
        dateLabel.center = CGPointMake(160, k_Date_Label_Offset_Y);
        
#pragma mark Time
        
        timeLabel.backgroundColor = [ UIColor clearColor ];
        timeLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Time_Label_Font_size ];
        
#pragma mark Text

        textLabel.backgroundColor = [ UIColor clearColor ];
        textLabel.font = [ UIFont fontWithName:@"Helvetica-Light" size:k_Text_Label_Font_Size ];

#pragma mark Image

        imageView.layer.cornerRadius = 10.f;
        imageView.layer.masksToBounds = YES;
        
#pragma mark Cell setup
        
        self.backgroundColor = [ UIColor clearColor ];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Setup -

- (void)setupMessage:(DB_wat *)dictNow mesageBefore:(DB_wat *)dictBefore
{
#pragma mark Reset

    int offsetDate = 0;
    textLabel.frame   = CGRectZero;
    timeLabel.frame   = CGRectZero;
    imageView.frame   = CGRectZero;
    bubbleImage.frame = CGRectZero;

    textLabel.text    = nil;
    dateLabel.text    = nil;
    timeLabel.text    = nil;
    imageView.image   = nil;
    bubbleImage.image = nil;
    checkmarkImage.image = nil;
    
    [timeLabel   removeFromSuperview];
    [dateLabel   removeFromSuperview];
    [textLabel   removeFromSuperview];
    [dateImage   removeFromSuperview];
    [imageView   removeFromSuperview];
    [bubbleImage removeFromSuperview];
    [checkmarkImage removeFromSuperview];

#pragma mark Date
    
    double timestamp1 = [ dictNow.d_timestamp doubleValue];
    double timestamp2 = [ dictBefore.d_timestamp doubleValue];
    NSTimeInterval interval1 = timestamp1;
    NSTimeInterval interval2 = timestamp2;
    NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval1 ];
    NSDate *dateFromDB2 = [ NSDate dateWithTimeIntervalSince1970:interval2 ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:is_RU_lang()?@"ru_RU":@"en_GB" ];
    NSString *now    = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB ] ];
    NSString *before = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB2 ] ];
    
    if ( [ now isEqualToString:before ] )
    {
        
    }
    else
    {
        offsetDate = k_Date_Offset;
        [ self addSubview:dateImage ];
        [ self addSubview:dateLabel ];
    }

    if( [ dateFromDB isToday ] )
        dateLabel.text = is_RU_lang()?@"Сегодня":@"Today";
    else
    {
        if( [ dateFromDB isYesterday ] )
            dateLabel.text = is_RU_lang()?@"Вчера":@"Yesterday";
        else
        {
            if ( is_RU_lang() )
            {
                [ dateFormatter setDateFormat:@"d MMM" ];
                dateLabel.text = [ [ dateFormatter stringFromDate:dateFromDB ] lowercaseString ];
            }
            else
            {
                [ dateFormatter setDateFormat:@"MMM d" ];
                dateLabel.text = [ dateFormatter stringFromDate:dateFromDB ];
            }
        }
    }
    
#pragma mark Time
    
    if( [ dictNow.bool_inputMassege boolValue ] == 0 )
        timeLabel.textColor = RGBa(154.0f, 173.0f, 138.0f, 1.0f);
    else
        timeLabel.textColor = RGBa(173.0f, 173.0f, 173.0f, 1.0f);

    dateFormatter.dateFormat = is_RU_lang()?@"HH:mm":@"HH:mm";
    timeLabel.text = [[ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
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
                                         k_Text_Label_Offset_Y,
                                         [ dictNow.f_text_label_w floatValue ],
                                         [ dictNow.f_text_label_h floatValue ]);
        }
        else
        {
            textLabel.frame = CGRectMake(k_Text_Label_input_Offset_X,
                                         k_Text_Label_Offset_Y,
                                         [ dictNow.f_text_label_w floatValue ],
                                         [ dictNow.f_text_label_h floatValue ]);
        }
        textLabel.text = dictNow.s_text_message;
        textLabel.numberOfLines = 0;
        textLabel.opaque = NO;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
   
#pragma mark checkmark Image

    if( [ dictNow.bool_inputMassege boolValue ] == 0 )
    {
        if ( dictNow.data_image == nil )
            checkmarkImage.image = [ UIImage imageNamed:@"wat_bm_ChekmarkGreen" ];
        else
            checkmarkImage.image = [ UIImage imageNamed:@"wat_bm_ChekmarkWhite" ];
            
        checkmarkImage.frame = CGRectMake([ dictNow.f_time_x floatValue ] + [ dictNow.f_time_w floatValue ] + k_Checkmark_X,
                                          [ dictNow.f_time_y floatValue ] + offsetDate + k_Checkmark_Y,
                                          checkmarkImage.image.size.width,
                                          checkmarkImage.image.size.height);
    }
#pragma mark Image
    
    if( dictNow.data_image != nil)
    {
        if ( [ dictNow.bool_inputMassege boolValue ] == 0 )
            imageView.backgroundColor = RGBa(193.0f, 213.0f, 235.0f, 1.0f);
        else
            imageView.backgroundColor = RGBa(240.0f, 240.0f, 240.0f, 1.0f);
        
        imageView.image = [ UIImage imageWithData:dictNow.data_image ];
        imageView.frame = CGRectMake([ dictNow.f_image_view_x floatValue ],
                                     [ dictNow.f_image_view_y floatValue ],
                                     [ dictNow.f_image_view_w floatValue ],
                                     [ dictNow.f_image_view_h floatValue ]);
    }
    
#pragma mark Bubble
    
    if( [ dictNow.bool_inputMassege boolValue ] == 0 )//Исходящие
    {
        bubbleImage.image = [ [ UIImage imageNamed:@"wat_bm_BubbleGreen" ] resizableImageWithCapInsets:UIEdgeInsetsMake(10.f, 10.f, 40.f, 150.f) ];
    }
    if ( [ dictNow.bool_inputMassege boolValue ] == 1 )//Входящее
    {
        bubbleImage.image = [ [ UIImage imageNamed:@"wat_bm_BubbleWhite" ] resizableImageWithCapInsets:UIEdgeInsetsMake(10.f, 20.f, 40.f, 150.f) ];
    }
    
    bubbleImage.frame = CGRectMake([ dictNow.f_bubble_x floatValue ],
                                   [ dictNow.f_bubble_y floatValue ] + offsetDate,
                                   [ dictNow.f_bubble_w floatValue ],
                                   [ dictNow.f_bubble_h floatValue ]);
    
    bubbleImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
#pragma mark Add to Cell
    
    if ( dictNow.s_text_message != nil )
        [ bubbleImage addSubview:textLabel ];
    if ( dictNow.data_image != nil )
        [ bubbleImage addSubview:imageView ];

    [ self addSubview:bubbleImage ];
    [ self addSubview:timeLabel ];
    if( [ dictNow.bool_inputMassege boolValue ] == 0 )
        [ self addSubview:checkmarkImage ];
}

#pragma mark - Default -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [ super setSelected:selected animated:animated ];
}

@end