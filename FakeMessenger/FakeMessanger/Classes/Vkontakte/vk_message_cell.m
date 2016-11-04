//
//  vkonakteCell.m
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "vk_message_cell.h"
#import "DB_vk.h"

#import "NSDate-Utilities.h"

#define k_Date_Label_Offset_X 5.f
#define k_Date_Label_Offset_Y 3.f
#define k_Date_Label_Font_size 13.f
#define k_Date_Offset 18.f
#define k_Time_Label_Font_size 13.f

#define k_Text_Label_output_Offset_X 10.f
#define k_Text_Label_input_Offset_X  15.f
#define k_Text_Label_Offset_Y 6.f
#define k_Text_Label_Font_Size 16.f
//#define k_Text_Label_Offset_Y 6.f

//Music View

#define k_PlayImage_Offset_X 0.f
#define k_PlayImage_Offset_Y 0.f
#define k_PlayImage_Offset_W 40.f
#define k_PlayImage_Offset_H 40.f

#define k_Performer_Label_Offset_X 47.f
#define k_Performer_Label_Offset_Y -1.f
#define k_Performer_Label_Offset_W 183.f
#define k_Performer_Label_Offset_H 20.f
#define k_Performer_Label_Font_Size 14.f

#define k_SongTitle_Label_Offset_X 47.f
#define k_SongTitle_Label_Offset_Y 17.f
#define k_SongTitle_Label_Offset_W 183.f
#define k_SongTitle_Label_Offset_H 20.f
#define k_SongTitle_Label_Font_Size 14.f

#define k_MusicView_output_Offset_X 9.f
#define k_MusicView_input_Offset_X  14.f
#define k_MusicView_Offset_Y 13.f
#define k_MusicView_Offset_if_Text_Y 1.f
#define k_MusicView_Offset_if_Image_Y 1.f
#define k_MusicView_Offset_if_Text_Image_Y 3.f
#define k_MusicView_Offset_W 230.f
#define k_MusicView_Offset_H 40.f

//Image

//#define k_Image_playImage(x)      [ NSString stringWithFormat:@"%@_tb_TapBarBackgound", x ]
//UIImage *i = [ UIImage imageNamed:k_Image_playImage(@"i") ];

@interface vk_message_cell ()
{
    UILabel *dateLabel;
    UILabel *timeLabel;
    UILabel *textLabel;
    UILabel *performerLabel;
    UILabel *songTitleLabel;
    UIView *musicView;
    UIImageView *imageView;
    UIImageView *playImage;
    UIImageView *bubbleImage;
}

@end

@implementation vk_message_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
#pragma mark Init
        
        bubbleImage = [ [ UIImageView alloc ] init ];
        imageView   = [ [ UIImageView alloc ] init ];
        playImage   = [ [ UIImageView alloc ] init ];
        musicView = [ [ UIView alloc ] init ];
        textLabel = [ [ UILabel alloc ] init ];
        dateLabel = [ [ UILabel alloc ] init ];
        timeLabel = [ [ UILabel alloc ] init ];
        performerLabel = [ [ UILabel alloc ] init ];
        songTitleLabel = [ [ UILabel alloc ] init ];

#pragma mark Date
        
        dateLabel.backgroundColor = [ UIColor clearColor ];
        dateLabel.shadowOffset = CGSizeMake(0,1);
        dateLabel.textColor   = [ UIColor colorWithRed:0.54 green:0.58 blue:0.65 alpha:1.0 ];
        dateLabel.shadowColor = [ UIColor colorWithRed:0.91 green:0.94 blue:0.96 alpha:1.0 ];
        dateLabel.font = [ UIFont fontWithName:@"HelveticaNeue-Bold" size:k_Date_Label_Font_size ];
        
#pragma mark Time
        
        timeLabel.backgroundColor = [ UIColor clearColor ];
        timeLabel.shadowOffset = CGSizeMake(0,1);
        timeLabel.textColor   = [ UIColor colorWithRed:(152.0f/255.f) green:(164.0f/255.f)  blue:(180.0f/255.f) alpha:1.0 ];
        timeLabel.shadowColor = [ UIColor colorWithRed:0.91 green:0.94 blue:0.96 alpha:1.0 ];
        timeLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Time_Label_Font_size ];
        
#pragma mark Text

        textLabel.backgroundColor = [ UIColor clearColor ];
        textLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Text_Label_Font_Size ];

#pragma mark Image

        imageView.layer.cornerRadius = 7.f;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor colorWithRed:(220.0f/255.f) green:(221.0f/255.f) blue:(224.0f/255.f) alpha:1.0];
  
#pragma mark Music

        playImage.frame = CGRectMake(k_PlayImage_Offset_X, k_PlayImage_Offset_Y, k_PlayImage_Offset_W, k_PlayImage_Offset_H);
        playImage.backgroundColor = [ UIColor clearColor ];
        playImage.image = [ UIImage imageNamed:@"vk_sett_MusicPlay" ];
        
        performerLabel.frame = CGRectMake(k_Performer_Label_Offset_X, k_Performer_Label_Offset_Y, k_Performer_Label_Offset_W, k_Performer_Label_Offset_H);
        performerLabel.backgroundColor = [ UIColor clearColor ];
        performerLabel.font = [ UIFont fontWithName:@"HelveticaNeue-Bold" size:k_Performer_Label_Font_Size ];
        
        songTitleLabel.frame = CGRectMake(k_SongTitle_Label_Offset_X, k_SongTitle_Label_Offset_Y, k_SongTitle_Label_Offset_W, k_SongTitle_Label_Offset_H);
        songTitleLabel.backgroundColor = [ UIColor clearColor ];
        songTitleLabel.textColor = [ UIColor colorWithRed:(150.0f/255.f) green:(156.0f/255.f) blue:(163.0f/255.f) alpha:1.0];
        songTitleLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_SongTitle_Label_Font_Size ];
        
        musicView.backgroundColor = [ UIColor clearColor ];
        
#pragma mark Cell setup
        
        self.backgroundColor = [ UIColor clearColor ];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Setup -

- (void)setupMessage:(DB_vk *)dictNow mesageBefore:(DB_vk *)dictBefore
{
#pragma mark Reset

    int offsetDate = 0;
    textLabel.frame   = CGRectZero;
    dateLabel.frame   = CGRectZero;
    timeLabel.frame   = CGRectZero;
    imageView.frame   = CGRectZero;
    bubbleImage.frame = CGRectZero;

    textLabel.text    = nil;
    dateLabel.text    = nil;
    timeLabel.text    = nil;
    imageView.image   = nil;
    bubbleImage.image = nil;
    
    [timeLabel   removeFromSuperview];
    [dateLabel   removeFromSuperview];
    [textLabel   removeFromSuperview];
    [imageView   removeFromSuperview];
    [bubbleImage removeFromSuperview];
    [musicView removeFromSuperview];

#pragma mark Date
    
    double timestamp = [ dictNow.d_timestamp doubleValue];
    NSTimeInterval interval = timestamp;
    NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];

    double timestamp2 = [ dictBefore.d_timestamp doubleValue];
    NSTimeInterval interval2 = timestamp2;
    NSDate *dateFromDB2 = [ NSDate dateWithTimeIntervalSince1970:interval2 ];
    NSDateFormatter *dateFormatter2 = [ [ NSDateFormatter alloc ] init ];
    dateFormatter2.dateFormat = @"YYYY-MM-dd";
    dateFormatter2.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
    
    
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
    
    
    NSDate *post_date = dateFromDB;
    if( [ post_date isToday ] )
    {
        [ dateFormatter setDateFormat:@"d MMMM" ];
        dateLabel.text = [ NSString stringWithFormat:@"сегодня, %@",[ dateFormatter stringFromDate:dateFromDB ] ];
    }
    else
    {
        if( [ post_date isYesterday ] )
        {
            [ dateFormatter setDateFormat:@"d MMMM" ];
            dateLabel.text = [ NSString stringWithFormat:@"вчера, %@",[ dateFormatter stringFromDate:dateFromDB ] ];
        }
        else
        {
            if ( [ post_date isThisWeek ] )
            {
                [ dateFormatter setDateFormat:@"cccc, d MMMM" ];
                dateLabel.text = [ [ dateFormatter stringFromDate:dateFromDB ] lowercaseString ];
            }
            else
            {
                if( [ post_date isThisYear ] )
                {
                    [ dateFormatter setDateFormat:@"d MMMM" ];
                    dateLabel.text = [ [ dateFormatter stringFromDate:dateFromDB ] lowercaseString ];
                }
                else
                {
                    [ dateFormatter setDateFormat:@"d" ];
                    NSString *day = [ dateFormatter stringFromDate:dateFromDB ];
                    [ dateFormatter setDateFormat:@"MMM" ];
                    NSString *month = [ [ dateFormatter stringFromDate:dateFromDB ] lowercaseString ];
                    month = [ month substringToIndex:3 ];
                    [ dateFormatter setDateFormat:@"yyyy" ];
                    dateLabel.text = [ NSString stringWithFormat:@"%@ %@ %@",day, month, [ dateFormatter stringFromDate:dateFromDB ] ];
                }
            }
        }
    }

    [ dateLabel sizeToFit ];
    
    dateLabel.frame = CGRectMake( ( ( self.bounds.size.width/2 ) - ( dateLabel.frame.size.width/2 ) + k_Date_Label_Offset_X ),
                                 k_Date_Label_Offset_Y,
                                 dateLabel.frame.size.width,
                                 dateLabel.frame.size.height);
    

   
    
    
#pragma mark Time
    
    dateFormatter.dateFormat = @"HH:mm";
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
    }
    
#pragma mark Image
    
    if( dictNow.data_image != nil)
    {
        imageView.image = [ UIImage imageWithData:dictNow.data_image ];
        imageView.frame = CGRectMake([ dictNow.f_image_view_x floatValue ],
                                     [ dictNow.f_image_view_y floatValue ],
                                     [ dictNow.f_image_view_w floatValue ],
                                     [ dictNow.f_image_view_h floatValue ]);
    }
    
#pragma mark Music

    if( dictNow.s_m_performer != nil )
    {
        performerLabel.text = dictNow.s_m_performer;
        songTitleLabel.text = dictNow.s_m_song_title;
        
        if ( [ dictNow.bool_inputMassege boolValue ] == 0 )
        {
            if ( dictNow.s_text_message == nil && dictNow.data_image == nil )
            {
                musicView.frame = CGRectMake(k_MusicView_output_Offset_X,
                                             k_MusicView_Offset_Y,
                                             k_MusicView_Offset_W,
                                             k_MusicView_Offset_H);
            }
            if ( dictNow.s_text_message != nil && dictNow.data_image == nil )
            {
                musicView.frame = CGRectMake(k_MusicView_output_Offset_X,
                                             k_MusicView_Offset_Y + [ dictNow.f_text_label_h floatValue ] - k_MusicView_Offset_if_Text_Y,
                                             k_MusicView_Offset_W,
                                             k_MusicView_Offset_H);
            }
            if ( dictNow.s_text_message == nil && dictNow.data_image != nil )
            {
                musicView.frame = CGRectMake(k_MusicView_output_Offset_X,
                                             k_MusicView_Offset_Y + [ dictNow.f_image_view_h floatValue ] + k_MusicView_Offset_if_Image_Y,
                                             k_MusicView_Offset_W,
                                             k_MusicView_Offset_H);
            }
            if ( dictNow.s_text_message != nil && dictNow.data_image != nil )
            {
                musicView.frame = CGRectMake(k_MusicView_output_Offset_X,
                                             k_MusicView_Offset_Y + [ dictNow.f_text_label_h floatValue ] + [ dictNow.f_image_view_h floatValue ] + k_MusicView_Offset_if_Text_Image_Y,
                                             k_MusicView_Offset_W,
                                             k_MusicView_Offset_H);
            }
        }
        else
        {
            if ( dictNow.s_text_message == nil && dictNow.data_image == nil )
            {
                musicView.frame = CGRectMake(k_MusicView_input_Offset_X,
                                             k_MusicView_Offset_Y,
                                             k_MusicView_Offset_W,
                                             k_MusicView_Offset_H);
            }
            if ( dictNow.s_text_message != nil && dictNow.data_image == nil )
            {
                musicView.frame = CGRectMake(k_MusicView_input_Offset_X,
                                             k_MusicView_Offset_Y + [ dictNow.f_text_label_h floatValue ] - k_MusicView_Offset_if_Text_Y,
                                             k_MusicView_Offset_W,
                                             k_MusicView_Offset_H);
            }
            if ( dictNow.s_text_message == nil && dictNow.data_image != nil )
            {
                musicView.frame = CGRectMake(k_MusicView_input_Offset_X,
                                             k_MusicView_Offset_Y + [ dictNow.f_image_view_h floatValue ] + k_MusicView_Offset_if_Image_Y,
                                             k_MusicView_Offset_W,
                                             k_MusicView_Offset_H);
            }

            if ( dictNow.s_text_message != nil && dictNow.data_image != nil )
            {
                musicView.frame = CGRectMake(k_MusicView_input_Offset_X,
                                             k_MusicView_Offset_Y + [ dictNow.f_text_label_h floatValue ] + [ dictNow.f_image_view_h floatValue ] + k_MusicView_Offset_if_Text_Image_Y,
                                             k_MusicView_Offset_W,
                                             k_MusicView_Offset_H);
            }
        }
            
        [ musicView addSubview:playImage ];
        [ musicView addSubview:performerLabel ];
        [ musicView addSubview:songTitleLabel ];
    }

#pragma mark Bubble
    
    if( [ dictNow.bool_inputMassege boolValue ] == 0 )//Исходящие
    {
        bubbleImage.image = [ [ UIImage imageNamed:@"vk_bm_BubbleBlue" ] resizableImageWithCapInsets:UIEdgeInsetsMake(15.f, 19.f, 20.f, 22.f) ];
    }
    if ( [ dictNow.bool_inputMassege boolValue ] == 1 )//Входящее
    {
        bubbleImage.image = [ [ UIImage imageNamed:@"vk_bm_BubbleGrey" ] resizableImageWithCapInsets:UIEdgeInsetsMake(15.f, 21.f, 20.f, 22.f) ];
    }
    
    bubbleImage.frame = CGRectMake([ dictNow.f_bubble_x floatValue ],
                                   [ dictNow.f_bubble_y floatValue ] + offsetDate,
                                   [ dictNow.f_bubble_w floatValue ],
                                   [ dictNow.f_bubble_h floatValue ]);
    
    bubbleImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
#pragma mark Add to Cell
    
    if ( dictNow.s_text_message != nil )
    {
        [ bubbleImage addSubview:textLabel ];
    }
    if ( dictNow.data_image != nil )
    {
        [ bubbleImage addSubview:imageView ];
    }
    if ( dictNow.s_m_performer != nil )
    {
        [ bubbleImage addSubview:musicView ];
    }
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