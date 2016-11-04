//
//  iPhoneCell.m
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "i_message_cell.h"

#import "NSDate-Utilities.h"

#define k_Date_Label_Offset_X 5.f
#define k_Date_Label_Offset_Y 3.5f
#define k_Date_Label_Font_size 12.f
#define k_Date_Offset 15.f

#define k_Text_Label_output_Offset_X 12.f
#define k_Text_Label_input_Offset_X  19.f
#define k_Text_Label_Font_Size 16.f
#define k_Text_Label_OFFset_Y 5.f

@interface i_message_cell ()
{
    UILabel *dateLabel;
    UILabel *textLabel;
    UIImageView *imageView;
    UIImageView *bubbleImage;
}

@end

@implementation i_message_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
#pragma mark Init
        
        dateLabel = [ [ UILabel alloc ] init ];
        textLabel = [ [ UILabel alloc ] init ];
        imageView   = [ [ UIImageView alloc ] init ];
        bubbleImage = [ [ UIImageView alloc ] init ];
        
#pragma mark Date
        
        dateLabel.backgroundColor = [ UIColor clearColor ];
        dateLabel.textColor = [ UIColor colorWithRed:(136.0f/255.f) green:(146.0f/255.f) blue:(165.0f/255.f) alpha:1.0];
        dateLabel.shadowOffset = CGSizeMake(0, 1.5f);
        dateLabel.shadowColor = [ UIColor colorWithRed:0.91 green:0.94 blue:0.96 alpha:1.0 ];
        dateLabel.font = [ UIFont fontWithName:@"Helvetica-Bold" size:k_Date_Label_Font_size ];
 
#pragma mark Text
        
        textLabel.backgroundColor = [ UIColor clearColor ];
        textLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:16 ];
        
#pragma mark Image

#pragma mark Cell setup
        
        self.backgroundColor = [ UIColor clearColor ];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupMessage:(DB_i *)dictNow mesageBefore:(DB_i *)dictBefore
{
#pragma mark Reset
    
    int offsetDate = 0;
    textLabel.frame   = CGRectZero;
    dateLabel.frame   = CGRectZero;
    imageView.frame   = CGRectZero;
    bubbleImage.frame = CGRectZero;
    
    textLabel.text    = nil;
    dateLabel.text    = nil;
    imageView.image   = nil;
    bubbleImage.image = nil;
    
    [dateLabel   removeFromSuperview];
    [textLabel   removeFromSuperview];
    [imageView   removeFromSuperview];
    [bubbleImage removeFromSuperview];
    
#pragma mark Date
    
    double timestamp = [ dictNow.d_timestamp doubleValue];
    NSTimeInterval interval = timestamp;
    NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    
    double timestamp2 = [ dictBefore.d_timestamp doubleValue];
    NSTimeInterval interval2 = timestamp2;
    NSDate *dateFromDB2 = [ NSDate dateWithTimeIntervalSince1970:interval2 ];
    NSDateFormatter *dateFormatter2 = [ [ NSDateFormatter alloc ] init ];
    dateFormatter2.dateFormat = @"YYYY-MM-dd HH:mm";
    
    
    NSString *now    = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB ] ];
    NSString *before = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB2 ] ];
    
    if ( [ now isEqualToString:before ] )
    {
        
    }
    else
    {
        offsetDate = k_Date_Offset;
        [ self addSubview:dateLabel ];
    }
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ( [ language isEqualToString:@"ru" ] )
    {
        dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
        [ dateFormatter setDateFormat:@"d.MM.yyyy, HH:mm" ];
        dateLabel.text = [ dateFormatter stringFromDate:dateFromDB ];
    }
    else
    {
        dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_GB" ];
        [ dateFormatter setDateFormat:@"hh:mm a" ];
        NSString *time = [ [ dateFormatter stringFromDate:dateFromDB ] uppercaseString ];
        [ dateFormatter setDateFormat:@"MMM d, yyyy" ];
        dateLabel.text = [ NSString stringWithFormat:@"%@, %@",[ dateFormatter stringFromDate:dateFromDB ], time ];
    }
    [ dateLabel sizeToFit ];
    
    dateLabel.frame = CGRectMake( ( ( self.bounds.size.width/2 ) - ( dateLabel.frame.size.width/2 ) + k_Date_Label_Offset_X ),
                                 k_Date_Label_Offset_Y,
                                 dateLabel.frame.size.width,
                                 dateLabel.frame.size.height);
    
#pragma mark Text
    
    if( dictNow.s_text_message != nil )
    {
        if ( [ dictNow.bool_inputMassege boolValue ] == 0 )
        {
            textLabel.frame = CGRectMake(k_Text_Label_output_Offset_X,
                                         k_Text_Label_OFFset_Y,
                                         [ dictNow.f_text_label_w floatValue ],
                                         [ dictNow.f_text_label_h floatValue ]);
        }
        else
        {
            textLabel.frame = CGRectMake(k_Text_Label_input_Offset_X,
                                         k_Text_Label_OFFset_Y,
                                         [ dictNow.f_text_label_w floatValue ],
                                         [ dictNow.f_text_label_h floatValue ]);
        }
        
        textLabel.text = dictNow.s_text_message;
        textLabel.numberOfLines = 0;
        textLabel.opaque = NO;
    }
    
#pragma mark Image
    
    if( dictNow.data_image != nil )
    {
        imageView.image = [ UIImage imageWithData:dictNow.data_image ];
        imageView.frame = CGRectMake([ dictNow.f_image_view_x floatValue ],
                                     [ dictNow.f_image_view_y floatValue ] + offsetDate,
                                     [ dictNow.f_image_view_w floatValue ],
                                     [ dictNow.f_image_view_h floatValue ]);
    }
    
#pragma mark Bubble
    
    if( [ dictNow.bool_inputMassege boolValue ] == 0 )//Исходящие
    {
        if ( dictNow.data_image == nil  )
        {
            if( NO == [[NSUserDefaults standardUserDefaults ] boolForKey:@"i_iMessage" ] )
            {
                bubbleImage.image = [ [ UIImage imageNamed:@"i_bm_BubbleGreen" ] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 21, 20, 22) ];
            }
            else if( YES == [[NSUserDefaults standardUserDefaults ] boolForKey:@"i_iMessage" ] )
            {
                bubbleImage.image = [ [ UIImage imageNamed:@"i_bm_BubbleBlue" ] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 21, 20, 22) ];
            }
        }
        if ( dictNow.data_image != nil  )
        {
            bubbleImage.image = [ [ UIImage imageNamed:@"i_bm_BubbleClear" ] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 21, 20, 22) ];
        }
    }
    else if ( [ dictNow.bool_inputMassege boolValue ] == 1 )//Входящее
    {
        if ( dictNow.data_image == nil  )
        {
            bubbleImage.image = [ [ UIImage imageNamed:@"i_bm_BubbleGray" ]  resizableImageWithCapInsets:UIEdgeInsetsMake(15, 21, 20, 22) ];
        }
        if ( dictNow.data_image != nil  )
        {
            bubbleImage.image = [ [ UIImage imageNamed:@"i_bm_BubbleClearFlip" ]  resizableImageWithCapInsets:UIEdgeInsetsMake(15, 21, 20, 22) ];
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
        [ self addSubview:imageView ];
        [ imageView addSubview:bubbleImage ];
    }
    
    NSLog(@"\n");
    NSLog(@"X Date_Label %f",dateLabel.frame.origin.x);
    NSLog(@"X Text_Label %f",textLabel.frame.origin.x);
    NSLog(@"X Image_View %f",imageView.frame.origin.x);
    NSLog(@"X BubbleView %f",bubbleImage.frame.origin.x);
    
    NSLog(@"Y Date_Label %f",dateLabel.frame.origin.y);
    NSLog(@"Y Text_Label %f",textLabel.frame.origin.y);
    NSLog(@"Y Image_View %f",imageView.frame.origin.y);
    NSLog(@"Y BubbleView %f",bubbleImage.frame.origin.y);
    
    NSLog(@"W Date_Label %f",dateLabel.frame.size.width);
    NSLog(@"W Text_Label %f",textLabel.frame.size.width);
    NSLog(@"W Image_view %f",imageView.frame.size.width);
    NSLog(@"W BubbleView %f",bubbleImage.frame.size.width);
    
    NSLog(@"H Date_Label %f",dateLabel.frame.size.height);
    NSLog(@"H Text_Label %f",textLabel.frame.size.height);
    NSLog(@"H Image_view %f",imageView.frame.size.height);
    NSLog(@"H BubbleView %f",bubbleImage.frame.size.height);
    
    NSLog(@"\n");
}

#pragma mark - Default -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [ super setSelected:selected animated:animated ];
}
@end