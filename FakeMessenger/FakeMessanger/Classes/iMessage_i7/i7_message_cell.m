//
//  iPhoneCell.m
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "i7_message_cell.h"

#import "NSDate-Utilities.h"

#define k_Date_Offset 38.f

#define k_Date_Label_Offset_X 5.f
#define k_Date_Label_Offset_Y 17.f
#define k_Date_Label_Font_size 11.f

#define k_Text_Label_output_Offset_X 12.f
#define k_Text_Label_input_Offset_X  18.f
#define k_Text_Label_Offset_Y 7.f
#define k_Text_Label_Font_Size 17.1f

@interface i7_message_cell ()
{
    UILabel *dateLabel;
    UILabel *textLabel;
//    UIImageView *imageView;
    UIImageView *bubbleImage;
}

@end

@implementation i7_message_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
#pragma mark Init
        
        dateLabel = [ [ UILabel alloc ] init ];
        textLabel = [ [ UILabel alloc ] init ];
//        imageView   = [ [ UIImageView alloc ] init ];
        bubbleImage = [ [ UIImageView alloc ] init ];
        
#pragma mark Date
        
        dateLabel.backgroundColor = [ UIColor clearColor ];
        dateLabel.textColor = RGBa(163.0f, 163.0f, 167.0f, 1.0f);
        dateLabel.font = [ UIFont fontWithName:@"HelveticaNeue-BOLD" size:k_Date_Label_Font_size ];
 
#pragma mark Text
        
        textLabel.backgroundColor = [ UIColor clearColor ];
        textLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Text_Label_Font_Size ];
        
#pragma mark Image

#pragma mark Cell setup
        
        self.backgroundColor = [ UIColor clearColor ];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupMessage:(DB_i7 *)dictNow mesageBefore:(DB_i7 *)dictBefore mesageAfter:(DB_i7 *)dictAfter
{
#pragma mark Reset
    
    int offsetDate = 0;
    BOOL isEqual = [ self bubble2:dictNow before:dictBefore after:dictAfter ];
    
    textLabel.frame   = CGRectZero;
    dateLabel.frame   = CGRectZero;
//    imageView.frame   = CGRectZero;
    bubbleImage.frame = CGRectZero;
    
    textLabel.text    = nil;
    dateLabel.text    = nil;
//    imageView.image   = nil;
    bubbleImage.image = nil;
    
    [dateLabel   removeFromSuperview];
    [textLabel   removeFromSuperview];
//    [imageView   removeFromSuperview];
    [bubbleImage removeFromSuperview];
    
#pragma mark Date
    
    double timestamp1 = [ dictNow.d_timestamp doubleValue];
    double timestamp2 = [ dictBefore.d_timestamp doubleValue];
    NSTimeInterval interval1 = timestamp1;
    NSTimeInterval interval2 = timestamp2;
    NSDate *dateFromDB1 = [ NSDate dateWithTimeIntervalSince1970:interval1 ];
    NSDate *dateFromDB2 = [ NSDate dateWithTimeIntervalSince1970:interval2 ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH";
    NSString *now    = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB1 ] ];
    NSString *before = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB2 ] ];
    
    if ( [ now isEqualToString:before ] )
    {
        if( ( [ dictNow.bool_inputMassege boolValue ] == 0 && [ dictBefore.bool_inputMassege boolValue ] == 1 )
         || ( [ dictNow.bool_inputMassege boolValue ] == 1 && [ dictBefore.bool_inputMassege boolValue ] == 0 ) )
            offsetDate = 7;
        else
        {
            dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
            NSString *now    = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB1 ] ];
            NSString *before = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB2 ] ];
            if( [ now isEqualToString:before ] )
            {}
            else
                offsetDate = 7;
        }
    }
    else
    {
        offsetDate = k_Date_Offset;
        [ self addSubview:dateLabel ];
    }
    

    dateLabel.attributedText = [ self postDate:dictNow ];
    [ dateLabel sizeToFit ];
    dateLabel.frame = CGRectMake( ( ( self.bounds.size.width/2 ) - ( dateLabel.frame.size.width/2 ) + k_Date_Label_Offset_X ),
                                 k_Date_Label_Offset_Y,
                                 dateLabel.frame.size.width,
                                 dateLabel.frame.size.height);
    
#pragma mark Text
    
    if( dictNow.s_text_message != nil )
    {
        textLabel.text = dictNow.s_text_message;
        textLabel.textAlignment = NSTextAlignmentLeft;
        
        if ( [ dictNow.bool_inputMassege boolValue ] == 0 )
        {
            textLabel.textColor = [ UIColor whiteColor ];
            textLabel.frame = CGRectMake(k_Text_Label_output_Offset_X,
                                         k_Text_Label_Offset_Y,
                                         [ dictNow.f_text_label_w floatValue ],
                                         [ dictNow.f_text_label_h floatValue ]);
        }
        else
        {
            textLabel.textColor = [ UIColor blackColor ];
            textLabel.frame = CGRectMake(k_Text_Label_input_Offset_X,
                                         k_Text_Label_Offset_Y,
                                         [ dictNow.f_text_label_w floatValue ],
                                         [ dictNow.f_text_label_h floatValue ]);
        }
        if( textLabel.frame.size.width <= 16 )
            textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        textLabel.opaque = NO;
    }
    
#pragma mark Image
    
//    if( dictNow.data_image != nil )
//    {
//        imageView.image = [ UIImage imageWithData:dictNow.data_image ];
//        imageView.frame = CGRectMake([ dictNow.f_image_view_x floatValue ],
//                                     [ dictNow.f_image_view_y floatValue ] + offsetDate,
//                                     [ dictNow.f_image_view_w floatValue ],
//                                     [ dictNow.f_image_view_h floatValue ]);
//    }
    
#pragma mark Bubble
    UIEdgeInsets edge = UIEdgeInsetsMake(15, 21, 30, 30);
    
    if( [ dictNow.bool_inputMassege boolValue ] == 0 )//Исходящие
    {
        if ( dictNow.data_image == nil  )
        {
            if( NO == [[NSUserDefaults standardUserDefaults ] boolForKey:@"i7_iMessage" ] )
            {
                if( isEqual )
                    bubbleImage.image = [ [ UIImage imageNamed:@"i7_bm_BubbleGreen2" ] resizableImageWithCapInsets:edge ];
                else
                    bubbleImage.image = [ [ UIImage imageNamed:@"i7_bm_BubbleGreen" ]  resizableImageWithCapInsets:edge ];
            }
            else if( YES == [[NSUserDefaults standardUserDefaults ] boolForKey:@"i7_iMessage" ] )
            {
                if( isEqual)
                    bubbleImage.image = [ [ UIImage imageNamed:@"i7_bm_BubbleBlue2" ] resizableImageWithCapInsets:edge ];
                else
                    bubbleImage.image = [ [ UIImage imageNamed:@"i7_bm_BubbleBlue" ]  resizableImageWithCapInsets:edge ];
            }
        }
        if ( dictNow.data_image != nil  )
        {
            if( isEqual )
                bubbleImage.image = [ UIImage imageWithData:dictNow.data_image ];
            else
                bubbleImage.image = [ UIImage imageWithData:dictNow.data_image ];
        }
    }
    else if ( [ dictNow.bool_inputMassege boolValue ] == 1 )//Входящее
    {
        if ( dictNow.data_image == nil  )
        {
            if( isEqual )
                bubbleImage.image = [ [ UIImage imageNamed:@"i7_bm_BubbleGray2" ]  resizableImageWithCapInsets:edge];
            else
                bubbleImage.image = [ [ UIImage imageNamed:@"i7_bm_BubbleGray" ]  resizableImageWithCapInsets:edge ];
        }
        if ( dictNow.data_image != nil  )
        {
            if( isEqual )
                bubbleImage.image = [ UIImage imageWithData:dictNow.data_image ];
            else
                bubbleImage.image = [ UIImage imageWithData:dictNow.data_image ];
        }
    }
    
    bubbleImage.frame = CGRectMake([ dictNow.f_bubble_x floatValue ],
                                   [ dictNow.f_bubble_y floatValue ] + offsetDate,
                                   [ dictNow.f_bubble_w floatValue ],
                                   [ dictNow.f_bubble_h floatValue ]);
    bubbleImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
#pragma mark Add to Cell
    
    if ( dictNow.s_text_message != nil && dictNow.data_image == nil )
        [ bubbleImage addSubview:textLabel ];

    [ self addSubview:bubbleImage ];
    
    NSLog(@"\n");
    NSLog(@"X Date_Label %f",dateLabel.frame.origin.x);
    NSLog(@"X Text_Label %f",textLabel.frame.origin.x);
    NSLog(@"X BubbleView %f",bubbleImage.frame.origin.x);
    
    NSLog(@"Y Date_Label %f",dateLabel.frame.origin.y);
    NSLog(@"Y Text_Label %f",textLabel.frame.origin.y);
    NSLog(@"Y BubbleView %f",bubbleImage.frame.origin.y);
    
    NSLog(@"W Date_Label %f",dateLabel.frame.size.width);
    NSLog(@"W Text_Label %f",textLabel.frame.size.width);
    NSLog(@"W BubbleView %f",bubbleImage.frame.size.width);
    
    NSLog(@"H Date_Label %f",dateLabel.frame.size.height);
    NSLog(@"H Text_Label %f",textLabel.frame.size.height);
    NSLog(@"H BubbleView %f",bubbleImage.frame.size.height);
    
    NSLog(@"\n");
}

-(NSMutableAttributedString*)postDate:(DB_i7 *)dictNow
{
    NSString *postDate;
    
    double timestamp = [ dictNow.d_timestamp doubleValue];
    NSTimeInterval interval = timestamp;
    NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ( [ language isEqualToString:@"ru" ] )
    {
        dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
        
        if( [ dateFromDB isToday ] )
        {
            [ dateFormatter setDateFormat:@"hh:mm" ];
            NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
            postDate = [ NSString stringWithFormat:@"Сегодня, %@",time ] ;
        }
        else
        {
            if( [ dateFromDB isYesterday ] )
            {
                [ dateFormatter setDateFormat:@"hh:mm" ];
                NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
                postDate = [ NSString stringWithFormat:@"Вчера, %@",time ] ;
            }
            else
            {
                if ( [ dateFromDB isThisWeek ] )
                {
                    [ dateFormatter setDateFormat:@"hh:mm" ];
                    NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
                    [ dateFormatter setDateFormat:@"cccc" ];
                    postDate = [ NSString stringWithFormat:@"%@, %@",[ dateFormatter stringFromDate:dateFromDB ], time ];
                }
                else
                {
                    
                    [ dateFormatter setDateFormat:@"MMM" ];
                    NSString *month = [ dateFormatter stringFromDate:dateFromDB ];
                    [ dateFormatter setDateFormat:@"d" ];
                    NSString *day = [ dateFormatter stringFromDate:dateFromDB ];
                    [ dateFormatter setDateFormat:@"hh:mm" ];
                    NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
                    [ dateFormatter setDateFormat:@"ccc" ];
                    postDate = [ NSString stringWithFormat:@"%@, %@ %@, %@",[ dateFormatter stringFromDate:dateFromDB ], day, month, time ];
                }
            }
        }    }
    else
    {
        dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_GB" ];
        
        if( [ dateFromDB isToday ] )
        {
            [ dateFormatter setDateFormat:@"hh:mm a" ];
            NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
            postDate = [ NSString stringWithFormat:@"Today %@",time ] ;
        }
        else
        {
            if( [ dateFromDB isYesterday ] )
            {
                [ dateFormatter setDateFormat:@"hh:mm a" ];
                NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
                postDate = [ NSString stringWithFormat:@"Yestersay %@",time ] ;
            }
            else
            {
                if ( [ dateFromDB isThisWeek ] )
                {
                    [ dateFormatter setDateFormat:@"hh:mm a" ];
                    NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
                    [ dateFormatter setDateFormat:@"cccc" ];
                    postDate = [ NSString stringWithFormat:@"%@ %@",[ dateFormatter stringFromDate:dateFromDB ], time ];
                }
                else
                {
                    
                    [ dateFormatter setDateFormat:@"MMM" ];
                    NSString *month = [ dateFormatter stringFromDate:dateFromDB ];
                    [ dateFormatter setDateFormat:@"d" ];
                    NSString *day = [ dateFormatter stringFromDate:dateFromDB ];
                    [ dateFormatter setDateFormat:@"hh:mm a" ];
                    NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
                    [ dateFormatter setDateFormat:@"ccc" ];
                    postDate = [ NSString stringWithFormat:@"%@, %@ %@, %@",[ dateFormatter stringFromDate:dateFromDB ], month, day, time ];
                }
            }
        }
    }
    
    int rang = is_RU_lang()?5:8;
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:postDate];
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor colorWithRed:(163.0f/255.f) green:(163.0f/255.f) blue:(167.0f/255.f) alpha:1.0]
                   range:NSMakeRange(([postDate length]-rang),([ postDate length ]-([postDate length]-rang)))];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue" size:11]
                   range:NSMakeRange(([postDate length]-rang),([ postDate length ]-([postDate length]-rang)))];
    
    return string;
}

-(BOOL)bubble2:(DB_i7 *)dictNow before:(DB_i7 *)dictBefore after:(DB_i7 *)dictAfter
{
    BOOL isEqual = '\0';
    
    double timestamp = [ dictNow.d_timestamp doubleValue];
    NSTimeInterval interval = timestamp;
    NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    
//    double timestamp2 = [ dictBefore.d_timestamp doubleValue];
//    NSTimeInterval interval2 = timestamp2;
//    NSDate *dateFromDB2 = [ NSDate dateWithTimeIntervalSince1970:interval2 ];
//    NSDateFormatter *dateFormatter2 = [ [ NSDateFormatter alloc ] init ];
//    dateFormatter2.dateFormat = @"YYYY-MM-dd HH:mm";
    
    double timestamp3 = [ dictAfter.d_timestamp doubleValue];
    NSTimeInterval interval3 = timestamp3;
    NSDate *dateFromDB3 = [ NSDate dateWithTimeIntervalSince1970:interval3 ];
    NSDateFormatter *dateFormatter3 = [ [ NSDateFormatter alloc ] init ];
    dateFormatter3.dateFormat = @"YYYY-MM-dd HH:mm";
    
    
    NSString *now    = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB ] ];
//    NSString *before = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB2 ] ];
    NSString *after  = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB3 ] ];

    
    if( ( dictNow != nil && dictAfter != nil )
       && [ now isEqualToString:after ]
       && ( ( [ dictNow.bool_inputMassege boolValue ] == 0 && [ dictAfter.bool_inputMassege boolValue ] == 0 )
           || ( [ dictNow.bool_inputMassege boolValue ] == 1 && [ dictAfter.bool_inputMassege boolValue ] == 1 ) ) )
        isEqual = YES;
    else
        isEqual = NO;
    
    return isEqual;
}

#pragma mark - Default -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [ super setSelected:selected animated:animated ];
}
@end