//
//  DB_vk.h
//  FakeMessanger
//
//  Created by developer on 12/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DB_vk : NSManagedObject

@property (nonatomic, retain) NSNumber * bool_anonym;
@property (nonatomic, retain) NSNumber * bool_inputMassege;
@property (nonatomic, retain) NSNumber * bool_message_created;
@property (nonatomic, retain) NSNumber * d_timestamp;
@property (nonatomic, retain) NSData * data_image;
@property (nonatomic, retain) NSNumber * f_bubble_h;
@property (nonatomic, retain) NSNumber * f_bubble_w;
@property (nonatomic, retain) NSNumber * f_bubble_x;
@property (nonatomic, retain) NSNumber * f_bubble_y;
@property (nonatomic, retain) NSNumber * f_cell_h;
@property (nonatomic, retain) NSNumber * f_image_view_h;
@property (nonatomic, retain) NSNumber * f_image_view_w;
@property (nonatomic, retain) NSNumber * f_image_view_x;
@property (nonatomic, retain) NSNumber * f_image_view_y;
@property (nonatomic, retain) NSNumber * f_text_label_h;
@property (nonatomic, retain) NSNumber * f_text_label_w;
@property (nonatomic, retain) NSNumber * f_time_h;
@property (nonatomic, retain) NSNumber * f_time_w;
@property (nonatomic, retain) NSNumber * f_time_x;
@property (nonatomic, retain) NSNumber * f_time_y;
@property (nonatomic, retain) NSString * s_carrier_name;
@property (nonatomic, retain) NSString * s_m_performer;
@property (nonatomic, retain) NSString * s_m_song_title;
@property (nonatomic, retain) NSString * s_recipient_name;
@property (nonatomic, retain) NSString * s_text_message;
@property (nonatomic, retain) NSString * s_type_bubble;
@property (nonatomic, retain) NSString * s_type_message;
@property (nonatomic, retain) NSData * data_image_original;

@end
