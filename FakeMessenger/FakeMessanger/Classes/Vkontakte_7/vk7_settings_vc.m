//
//  vkonaktePostMessage.m
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "vk7_settings_vc.h"
#import "AppDelegate.h"

#import "vk7_vc.h"
#import "DB_vk7.h"
#import "vk7_settings_cell.h"

#import "NSDate-Utilities.h"

typedef enum
{
    bubble_Type_Text,
    bubble_Type_Image,
    bubble_Type_Music,
    bubble_Type_Text_Image,
    bubble_Type_Text_Music,
    bubble_Type_Image_Music,
    bubble_Type_Text_Image_Music,
}BubbleType;

#define kScreenWidth   320.f

#define kTableHeight_Ios7_inch4 570.f
#define kTableHeight_Ios7_ne_inch4 480.f
#define kTableHeight_ne_Ios7_inch4 510.f
#define kTableHeight_ne_Ios7_ne_inch4 416.f

#define k_Time_Label_Font_size 11.f
#define k_Time_Date_view_H   284.f
#define k_Time_Date_picker_H 216.f
#define kToolbarHeight 44.f

//Date

#define k_Date_Offset 17.f

//Time

#define k_Time_Label_Offset_output_X 36.f
#define k_Time_Label_Offset_input_X  7.f
#define k_Time_Label_Offset_Y  22.f

//Text

#define k_Text_Label_Offset_X 10.f
#define k_Text_Label_Offset_Y 5.f
#define k_Text_Label_Offset_W 225.f
#define k_Text_Label_Offset_H 900.f
#define k_Text_Label_Font_Size 16.f

//ImageView

#define k_ImageView_Offset_Output_X 7.f
#define k_ImageView_Offset_Input_X  13.f
#define k_ImageView_OnlyImage_Offset_Output_Y 6.f
#define k_ImageView_OnlyImage_Offset_Input_Y  7.f
#define k_ImageView_OnlyImage_Text_Offset_Y 9.f
#define k_ImageView_OnlyImage_Text_Offset_W 10.f

//Music

#define k_MusicView_Offset_W 230.f
#define k_MusicView_Offset_H 40.f

#define k_Performer_Label_Offset_W 183.f
#define k_Performer_Label_Offset_H 20.f
#define k_Performer_Label_Font_Size 15.f

#define k_SongTitle_Label_Offset_W 183.f
#define k_SongTitle_Label_Offset_H 20.f
#define k_SongTitle_Label_Font_Size 14.f

//Cell H

#define k_Cell_Offset 1.f

//Bubble

#define k_Bubble_Offset_Y 6.f

#define k_Bubble_Type_Text_Offset_X 32.f
#define k_Bubble_Type_Text_Offset_W 32.f
#define k_Bubble_Type_Text_Offset_H 14.f

#define k_Bubble_Type_Image_Offset_X 19.5f
#define k_Bubble_Type_Image_Offset_Output_W 19.5f
#define k_Bubble_Type_Image_Offset_Input_W  22.f
#define k_Bubble_Type_Image_Offset_Output_H 13.5f
#define k_Bubble_Type_Image_Offset_Input_H  15.f

#define k_Bubble_Type_Music_Offset_X 30.f
#define k_Bubble_Type_Music_Offset_W 30.f
#define k_Bubble_Type_Music_Offset_H 31.f

#define k_Bubble_Type_Text_Image_Offset_X 30.f
#define k_Bubble_Type_Text_Image_Offset_W 30.f
#define k_Bubble_Type_Text_less_Image_Offset_X 20.f
#define k_Bubble_Type_Text_less_Image_Offset_W 20.f
#define k_Bubble_Type_Text_Image_Offset_H 16.f

#define k_Bubble_Type_Text_Music_Offset_X 30.f
#define k_Bubble_Type_Text_Music_Offset_W 30.f
#define k_Bubble_Type_Text_Music_Offset_H 27.f

#define k_Bubble_Type_Image_Music_Offset_X 20.f
#define k_Bubble_Type_Image_Music_Offset_W 20.f
#define k_Bubble_Type_Image_Music_Offset_H 30.f

#define k_Bubble_Type_Text_Image_Music_Offset_X 23.f
#define k_Bubble_Type_Text_Image_Music_Offset_W 23.f
#define k_Bubble_Type_Text_Image_Music_Offset_H 32.f

@interface vk7_settings_vc () < UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate >

@property (assign) BOOL ban;
@property (assign) BOOL messageCreatedEarly;
@property (assign) BOOL dateFromDataBase;
@property (assign) BOOL inputMassegeBool;

@property (assign, nonatomic) BubbleType type;
@property (nonatomic, strong) UITableView *tableView;

//Date

@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) NSDate *changeDate;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) UIDatePicker *datePicker;

//Music
@property (nonatomic, strong) NSString *m_performer;
@property (nonatomic, strong) NSString *m_song_title;
@property (strong, nonatomic) UITextField *enter_performer;
@property (strong, nonatomic) UITextField *enter_song_title;

@property (nonatomic, strong) UIImage *imageFromData;
@property (nonatomic, strong) UITextView *textPostMessage;

@property (nonatomic, strong) DB_vk7 *message;
@property (strong, nonatomic) NSString *recipientName;
@property (strong, nonatomic) NSString *carrierName;
@property (readonly, nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation vk7_settings_vc

//инициализация нового сообщения
- (id)initWithRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier
{
    self = [ super init ];
    if(self)
    {
        self.recipientName = recipientName;
        self.carrierName = carrier;
    }
    return self;
}

//инициализация редактируемого сообщения
- (id)initWithInfoMessage:(DB_vk7 *)infoMessage andRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier
{
    self = [ super init ];
    if (self)
    {
        self.message = infoMessage;
        self.recipientName = recipientName;
        self.carrierName = carrier;
        
        if ( self.message.bool_message_created )
        {
            self.messageCreatedEarly = YES;
            self.dateFromDataBase = YES;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [ super viewDidLoad ];
   
    self.title = @"Настройки";
    self.view.backgroundColor = [ UIColor whiteColor ];
    [ self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault ];

    NSDate *date = [ NSDate date ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
    self.changeDate = date;
    self.dateString = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:date ] ];
    
#pragma mark Table Setup
    
    if (is_ios_7())
    {
       if (is_4_inch())
           self.tableView = [ [ UITableView alloc ] initWithFrame:CGRectMake( 0, 0, kScreenWidth, kTableHeight_Ios7_inch4 )style:UITableViewStyleGrouped ];
       else
           self.tableView = [ [ UITableView alloc ] initWithFrame:CGRectMake( 0, 0, kScreenWidth, kTableHeight_Ios7_ne_inch4 )style:UITableViewStyleGrouped ];
    }
    else
    {
        if (is_4_inch())
            self.tableView = [ [ UITableView alloc ] initWithFrame:CGRectMake( 0, 0, kScreenWidth, kTableHeight_ne_Ios7_inch4 )style:UITableViewStyleGrouped ];
        else
            self.tableView = [ [ UITableView alloc ] initWithFrame:CGRectMake( 0, 0, kScreenWidth, kTableHeight_ne_Ios7_ne_inch4 )style:UITableViewStyleGrouped ];
    }
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [ UIColor whiteColor ];
    self.tableView.scrollEnabled = NO;
    [ self.view addSubview:self.tableView ];
    
#pragma mark TextPostMessage
    
    if( is_4_inch() )
        self.textPostMessage = [ [ UITextView alloc ] initWithFrame:CGRectMake(10.f, 5.f, kScreenWidth - 50.f, 230.f) ];
    else
        self.textPostMessage = [ [ UITextView alloc ] initWithFrame:CGRectMake(10.f, 5.f, kScreenWidth - 50.f, 145.f) ];
    self.textPostMessage.tag = 1000;
    self.textPostMessage.delegate = self;
    self.textPostMessage.backgroundColor = [UIColor clearColor];
    self.textPostMessage.font = [ UIFont fontWithName:@"Helvetica" size:18.0f ];
    self.textPostMessage.scrollEnabled = YES;

    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolbarHeight)];
    toolBar.translucent = YES;
    
    UIBarButtonItem *doneButton = [ [ UIBarButtonItem alloc ]initWithTitle:@"Готово"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(hideKeyboard:) ];
    UIBarButtonItem *fixedButton = [ [ UIBarButtonItem alloc ] init ];
    doneButton.width = 60;
    fixedButton.width = 220;
    
    UIToolbar *toolbarDate = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolbarHeight)];
    [ self.dateView addSubview:toolbarDate ];

    [toolBar setItems:[NSArray arrayWithObjects:fixedButton, doneButton, nil]];
    
    self.textPostMessage.inputAccessoryView = toolBar;

}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [ self addMessage ];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - Add to DataBase -

-(void)addMessage
{
    [ self.textPostMessage resignFirstResponder ];
    
    if( self.imageFromData == nil && [ self isTextNil ] && self.m_performer == nil )
        return;

//Расчитанные размеры вьюх которые будут добавлены на cell
    
    CGFloat cellHeight = [self calculationHeightCell ];
    CGSize textSize = [ self calculationSizeText ];
    CGRect timeRect = [ self calculationSizeTime ];
    
    
#pragma mark Add Добавление значений полей в базу
    _context = ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext;
    if ( [ self.message.bool_message_created boolValue ] == NO )
    {
//        _context = ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext;
        self.message = [ NSEntityDescription insertNewObjectForEntityForName:@"DB_vk7" inManagedObjectContext:_context ];
    }
    
    self.message.bool_inputMassege = [NSNumber numberWithBool:self.inputMassegeBool];
    self.message.bool_message_created = [NSNumber numberWithBool:YES];
    self.message.d_timestamp = [ NSNumber numberWithDouble:self.changeDate.timeIntervalSince1970 ];
    self.message.s_m_performer = self.m_performer;
    self.message.s_m_song_title = self.m_song_title;
    self.message.s_recipient_name =  self.recipientName;
    self.message.s_carrier_name = self.carrierName;
    if ( self.imageFromData != nil )
    {
        self.message.data_image_original = [ self makeScreenshotFromViewOriginal ];
        self.message.data_image = [ self makeScreenshotFromView ];
    }
    else
    {
        self.message.data_image_original = nil;
        self.message.data_image = nil;
    }
    
#pragma mark Add Text
    
    if ( [ self isTextNil ] )
    {
        self.message.s_text_message = nil;
    }
    else
    {
        self.message.s_text_message = self.textPostMessage.text;
        
        self.message.f_text_label_w = [ NSNumber numberWithFloat:textSize.width ];
        self.message.f_text_label_h = [ NSNumber numberWithFloat:textSize.height ];
    }
    
#pragma mark Add Cell Size
    
    self.message.f_cell_h = [ NSNumber numberWithFloat:cellHeight ];
    
#pragma mark Add Time Size
    
    self.message.f_time_x = [ NSNumber numberWithFloat:timeRect.origin.x ];
    self.message.f_time_y = [ NSNumber numberWithFloat:timeRect.origin.y ];
    self.message.f_time_w = [ NSNumber numberWithFloat:timeRect.size.width ];
    self.message.f_time_h = [ NSNumber numberWithFloat:timeRect.size.height ];
    
#pragma mark Add Bubble Size
    
//if_Text
    if ( ![ self isTextNil ] && self.imageFromData == nil && self.m_performer == nil )
    {
        self.message.s_type_bubble = @"Text";
        
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Text ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
    }
//if_Image
    if ( [ self isTextNil ] && self.imageFromData != nil && self.m_performer == nil )
    {
        self.message.s_type_bubble = @"Image";
        
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Image ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
        
        CGRect imageViewRect = [ self calculationImageViewSize:bubble_Type_Image ];
        self.message.f_image_view_x = [ NSNumber numberWithFloat:imageViewRect.origin.x ];
        self.message.f_image_view_y = [ NSNumber numberWithFloat:imageViewRect.origin.y ];
        self.message.f_image_view_w = [ NSNumber numberWithFloat:imageViewRect.size.width ];
        self.message.f_image_view_h = [ NSNumber numberWithFloat:imageViewRect.size.height ];
    }
//if_Music
    if ( [ self isTextNil ] && self.imageFromData == nil && self.m_performer != nil )
    {
        self.message.s_type_bubble = @"Music";
        
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Music ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
    }
//if_Text_Image
    if ( ![ self isTextNil ] && self.imageFromData != nil && self.m_performer == nil )
    {
        self.message.s_type_bubble = @"Text_Image";
        
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Text_Image ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
        
        CGRect imageViewRect = [ self calculationImageViewSize:bubble_Type_Text_Image ];
        self.message.f_image_view_x = [ NSNumber numberWithFloat:imageViewRect.origin.x ];
        self.message.f_image_view_y = [ NSNumber numberWithFloat:imageViewRect.origin.y ];
        self.message.f_image_view_w = [ NSNumber numberWithFloat:imageViewRect.size.width ];
        self.message.f_image_view_h = [ NSNumber numberWithFloat:imageViewRect.size.height ];
    }
//if_Text_Music
    if ( ![ self isTextNil ] && self.imageFromData == nil && self.m_performer != nil)
    {
        self.message.s_type_bubble = @"Text_Music";
        
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Text_Music ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
    }
//if_Image_Music
    if ( [ self isTextNil ] && self.imageFromData != nil && self.m_performer != nil )
    {
        self.message.s_type_bubble = @"Image_Music";
        
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Image_Music ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
        
        CGRect imageViewRect = [ self calculationImageViewSize:bubble_Type_Image_Music ];
        self.message.f_image_view_x = [ NSNumber numberWithFloat:imageViewRect.origin.x ];
        self.message.f_image_view_y = [ NSNumber numberWithFloat:imageViewRect.origin.y ];
        self.message.f_image_view_w = [ NSNumber numberWithFloat:imageViewRect.size.width ];
        self.message.f_image_view_h = [ NSNumber numberWithFloat:imageViewRect.size.height ];
    }
//if_Text_Image_Music
    if ( ![ self isTextNil ] && self.imageFromData != nil && self.m_performer != nil )
    {
        self.message.s_type_bubble = @"Text_Image_Music";
        
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Text_Image_Music ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
        
        CGRect imageViewRect = [ self calculationImageViewSize:bubble_Type_Text_Image_Music];
        self.message.f_image_view_x = [ NSNumber numberWithFloat:imageViewRect.origin.x ];
        self.message.f_image_view_y = [ NSNumber numberWithFloat:imageViewRect.origin.y ];
        self.message.f_image_view_w = [ NSNumber numberWithFloat:imageViewRect.size.width ];
        self.message.f_image_view_h = [ NSNumber numberWithFloat:imageViewRect.size.height ];
    }
    
//save to Base
    
    [ _context save:NULL ];
}

#pragma mark - Table Methods -

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
        return YES;
    if (indexPath.row == 2)
        return YES;
    if (indexPath.row == 3)
        return YES;
    if (indexPath.row == 4)
        return YES;
    else
        return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 4)
    {
        if ( is_4_inch() )
            return 240.f;
        else
            return 155.0f;
    }
    else
    {
        return 44.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        if ( indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 )
        {
            cell = [ [ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:CellIdentifier ];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            [ cell setSelectionStyle:UITableViewCellSelectionStyleNone ];
        }
        if ( indexPath.row == 3 )
        {
            cell = [ [ vk7_settings_cell alloc ] initWithStyle:UITableViewCellStyleSubtitle
                                                 reuseIdentifier:CellIdentifier
                                                            type:cell_Music ];
        }
    }
    
    UISwitch *optionsSwitch = [ [ UISwitch alloc ] init ];
    
    switch (indexPath.row)
    {
            
#pragma mark cell 0
            
        case 0:
        {
            cell.textLabel.text = @"Входящие";
            cell.accessoryView = optionsSwitch;
            
            if( self.messageCreatedEarly )
            {
                if( [ self.message.bool_inputMassege boolValue ] == 1 )
                {
                    self.inputMassegeBool = 1;
                    optionsSwitch.on = YES;
                }
                if( [ self.message.bool_inputMassege boolValue ] == 0 )
                {
                    self.inputMassegeBool = 0;
                    optionsSwitch.on = NO;
                }
            }
            else
            {
                if( self.inputMassegeBool == 1 )
                {
                    optionsSwitch.on = YES;
                }
                else
                {
                    optionsSwitch.on = NO;
                }
            }
            
            [ optionsSwitch addTarget:self action:@selector(setOnInput:) forControlEvents:UIControlEventValueChanged ];
            break;
        }
            
#pragma mark cell 1
            
        case 1:
        {
            if( self.messageCreatedEarly )
            {
                double timestamp = [ self.message.d_timestamp doubleValue];
                NSTimeInterval interval = timestamp;
                NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval ];
                self.changeDate = dateFromDB;
                
                NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
                dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
                dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];

                self.dateString     = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB ] ];
                cell.textLabel.text = [ NSString stringWithFormat:@"Дата : %@", [ dateFormatter stringFromDate:dateFromDB ] ];
            }
            else
            {
                if( self.dateString != nil )
                {
                    cell.textLabel.text = [ NSString stringWithFormat:@"Дата : %@",self.dateString ];
                }
                else
                {
                    cell.textLabel.text = @"Дата :";
                }
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0, 0.0, 44, 44);
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"FM_sett_Delete"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(refleshTime:)  forControlEvents:UIControlEventTouchUpInside];
            
            cell.accessoryView = button;
            break;
        }
            
#pragma mark cell 2
            
        case 2:
        {
            if( self.message.data_image != nil && self.messageCreatedEarly )
            {
                cell.textLabel.text = @"Изменить";
                self.imageFromData = [ UIImage imageWithData:self.message.data_image_original ];
                cell.imageView.image = [ self makeScreenshotFromViewSettings ];
            }
            else
            {
                if ( self.imageFromData == nil )
                {
                    cell.textLabel.text = @"Добавить";
                    cell.imageView.image = [ UIImage imageNamed:@"FM_sett_ImageDefault" ];
                }
                else
                {
                    cell.textLabel.text = @"Изменить";
                    cell.imageView.image = [ self makeScreenshotFromViewSettings ];
                }
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0, 0.0, 44, 44);
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"FM_sett_Delete"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(refleshImage:)  forControlEvents:UIControlEventTouchUpInside];
            
            cell.accessoryView = button;
            break;
        }
    
#pragma mark cell 3
            
        case 3:
        {
            if( self.message.s_m_performer != nil && self.messageCreatedEarly )
            {
                self.m_performer = self.message.s_m_performer;
                self.m_song_title = self.message.s_m_song_title;
                self.enter_performer.text = self.message.s_m_performer;
                self.enter_song_title.text = self.message.s_m_song_title;
                cell.textLabel.text = [ NSString stringWithFormat:@"Исполнитель: %@", self.m_performer ];
                cell.detailTextLabel.text = [ NSString stringWithFormat:@"Название: %@", self.m_song_title ];
            }
            else
            {
                if( self.m_performer != nil )
                {
                    cell.textLabel.text = [ NSString stringWithFormat:@"Исполнитель: %@",self.m_performer ];
                    self.enter_performer.text = self.m_performer;
                }
                else
                {
                    cell.textLabel.text = @"Исполнитель:";
                }
                if( self.m_song_title != nil )
                {
                    cell.detailTextLabel.text = [ NSString stringWithFormat:@"Название: %@",self.m_song_title ];
                    self.enter_song_title.text = self.m_song_title;
                }
                else
                {
                    cell.detailTextLabel.text = @"Название:";
                }
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0, 0.0, 44, 44);
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"FM_sett_Delete"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(refleshMusic:)  forControlEvents:UIControlEventTouchUpInside];
            
            cell.accessoryView = button;
            break;
        }
            
#pragma mark cell 4
            
        case 4:
        {
            if([ self.message.bool_message_created boolValue ] == 1  && self.messageCreatedEarly )
            {
                if ( self.message.s_text_message != nil )
                {
                    self.textPostMessage.textColor = [ UIColor blackColor ];
                    self.textPostMessage.text = self.message.s_text_message;
                }
                else
                {
                    self.textPostMessage.textColor = [ UIColor grayColor ];
                    self.textPostMessage.text = @"Введите текст сообщения здесь";
                }
                self.messageCreatedEarly = NO;
            }
            else if ( [ self.textPostMessage.text isEqualToString:@"" ] )
            {
                self.textPostMessage.textColor = [UIColor grayColor];
                self.textPostMessage.text = @"Введите текст сообщения здесь";
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            if ( is_ios_7() )
                button.frame = CGRectMake(0.0, 0.0, 44, 44);
            else
                button.frame = CGRectMake(10.0, 0.0, 44, 44);
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"FM_sett_Delete"] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(refleshText:)  forControlEvents:UIControlEventTouchUpInside];
            UIView *view = [ [ UIView alloc ] initWithFrame:CGRectMake(0, 0, 44, 44 ) ];
            view.backgroundColor = [ UIColor clearColor ];
            [ view addSubview:button ];
            
            if ( is_ios_7() )
                cell.accessoryView = button;
            else
                cell.accessoryView = view;
            
            [cell addSubview:self.textPostMessage];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 1 )
    {
        if ( self.ban == NO )
        {
            if ( self.dateView == nil )
            {
                if (is_4_inch())
                {
                    self.dateView = [ [ UIView alloc ] initWithFrame:CGRectMake( 0, self.tableView.frame.size.height, kScreenWidth, k_Time_Date_view_H ) ];
                }
                else
                {
                    self.dateView = [ [ UIView alloc ] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, kScreenWidth, k_Time_Date_view_H)];
                }
                self.dateView.backgroundColor = [ UIColor whiteColor ];
                [ self.view addSubview:self.dateView ];
                
//DatePicker
                
                self.datePicker = [ [ UIDatePicker alloc ] initWithFrame:CGRectMake( 0, kToolbarHeight, kScreenWidth, k_Time_Date_picker_H ) ];
                [ self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime ];
                self.datePicker.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
                if ( self.message.bool_message_created &&  self.dateFromDataBase )
                {
                    double timestamp = [ self.message.d_timestamp doubleValue];
                    NSTimeInterval interval = timestamp;
                    NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval ];
                    self.datePicker.date = dateFromDB;
                    self.dateFromDataBase = NO;
                }

                [ self.dateView addSubview:self.datePicker ];
              
//Toolbar and Button toolbar
                
                UIBarButtonItem *addDate = [ [ UIBarButtonItem alloc ]initWithTitle:@"Готово"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(didDataPicked:) ];
                UIBarButtonItem *fixedButton = [ [ UIBarButtonItem alloc ] init ];
                addDate.width = 60;
                fixedButton.width = 220;
                
                UIToolbar *toolbarDate = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolbarHeight)];
                [ self.dateView addSubview:toolbarDate ];
                
                NSArray *dateButtonArray = [ NSMutableArray arrayWithObjects:fixedButton, addDate, nil ];
                [ toolbarDate setItems:dateButtonArray ];
            }
            
            [ UIView beginAnimations:nil context:nil ];
            [ UIView setAnimationDuration:0.3 ];
            [ self changeYforTimeAndDateView:NO ];
            [ UIView commitAnimations ];
            self.ban = YES;
        }
    }
    if ( indexPath.row == 2 )
    {
        [ self startMediaBrowserFromViewController:self usingDelegate:self ];
    }
    if ( indexPath.row == 3 )
    {
        UIAlertView *song = [ [ UIAlertView alloc] initWithTitle:@"Введите данные"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Отмена"
                                               otherButtonTitles:@"Ввод", nil ];
        song.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        song.tag = 1003;
        [[song textFieldAtIndex:1] setSecureTextEntry:NO];
        [ song textFieldAtIndex:0 ].placeholder = @"Имя исполнителя";
        [ song textFieldAtIndex:1 ].placeholder = @"Название песни";
        
        self.enter_performer = [ song textFieldAtIndex:0 ];
        self.enter_performer.tag = 1;
        [ self.enter_performer setDelegate:self ];
        
        self.enter_song_title = [ song textFieldAtIndex:1 ];
        self.enter_song_title.tag = 2;
        [ self.enter_song_title setDelegate:self ];
        
        [ self.tableView reloadData ];
        [ song show ];
    }
}

#pragma mark - Enter Music -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL Return = '\0';
    if ( textField.tag == 1 )
    {
        if ( [ self.enter_performer.text length ] >= 50 && ![ string isEqualToString:@"" ] )
            Return = NO;
        else
            Return = YES;
    }
    if ( textField.tag == 2 )
    {
        if ( [ self.enter_song_title.text length ] >= 50 && ![ string isEqualToString:@"" ] )
            Return = NO;
        else
            Return = YES;
    }
    
    return Return;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 1003)
    {
        if ( buttonIndex == 0 )
        {
            return;
        }
        if ( buttonIndex == 1 )
        {
            if( [ self.enter_performer.text isEqualToString:@"" ] )
            {
                self.m_performer  = nil;
                self.m_song_title = nil;
                [ self.tableView reloadData ];
            }
            else
            {
                self.m_performer  = self.enter_performer.text;
                self.m_song_title = self.enter_song_title.text;
                [ self.tableView reloadData ];
            }
        }
    }
    if ( alertView.tag == 101 )
    {
        if ( buttonIndex == 0 )
            return;
        
        NSDate *date2 = [ NSDate date ];
        NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
        dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
        dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
        self.changeDate = date2;
        self.dateString = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:date2 ] ];
        self.datePicker.date = [ NSDate date ];
        self.dateFromDataBase = NO;
        
        [ self.tableView reloadData ];
    }
    if ( alertView.tag == 102 )
    {
        if ( buttonIndex == 0 )
            return;
        
        self.imageFromData = nil;
        
        [ self.tableView reloadData ];
    }
    if ( alertView.tag == 103 )
    {
        if ( buttonIndex == 0 )
            return;
        
        self.m_performer = nil;
        self.m_song_title = nil;
        self.enter_performer.text = nil;
        self.enter_song_title.text = nil;
        
        [ self.tableView reloadData ];
    }
    if ( alertView.tag == 104 )
    {
        if ( buttonIndex == 0 )
            return;
        
        self.textPostMessage.textColor = [UIColor grayColor];
        self.textPostMessage.text = @"Введите текст сообщения здесь";
        
        [ self.tableView reloadData ];
    }
    
}

- (void)refleshTime:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:@"Вы действительно хотите очистить поле?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Отмена"
                                                   otherButtonTitles:@"Да", nil ];
    addNameAlert.tag = 101;
    [ addNameAlert show ];
}

- (void)refleshImage:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:@"Вы действительно хотите очистить поле?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Отмена"
                                                   otherButtonTitles:@"Да", nil ];
    addNameAlert.tag = 102;
    [ addNameAlert show ];
}

- (void)refleshMusic:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:@"Вы действительно хотите очистить поле?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Отмена"
                                                   otherButtonTitles:@"Да", nil ];
    addNameAlert.tag = 103;
    [ addNameAlert show ];
}

- (void)refleshText:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:@"Вы действительно хотите очистить поле?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Отмена"
                                                   otherButtonTitles:@"Да", nil ];
    addNameAlert.tag = 104;
    [ addNameAlert show ];
}
#pragma mark -
#pragma mark setOn Switch methods
#pragma mark -

- (void)setOnInput:(UISwitch*)mySwitch {
    self.inputMassegeBool = mySwitch.on;
}

#pragma mark - Picker picture methods -

- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
    {
        return NO;
    }
    
    UIImagePickerController *mediaUI = [ [ UIImagePickerController alloc ] init ];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [ UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum ];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = delegate;
    [ controller presentViewController:mediaUI animated:YES completion:nil ];
    
    return YES;
}

//картинка береться с альбома
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageFromData = nil;
    
    UIImage *originalImage;
    originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];

    self.imageFromData = [UIImage imageWithData:UIImagePNGRepresentation(originalImage)];
    
    [ self.navigationController dismissViewControllerAnimated:YES completion:^{[self.tableView reloadData];} ];
}

//сделать скриншот
-(NSData *)makeScreenshotFromView
{
    CGSize imageSize = [ self calculationSizeImageFromData ];
    
    UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame: CGRectMake( 0, 0, imageSize.width, imageSize.height ) ];
    imageView.image = self.imageFromData;
    
    CGRect rect = CGRectMake( 0, 0, imageSize.width -1, imageSize.height -1 );
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [ imageView.layer renderInContext:context ];
    UIImage *screnshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation( screnshot );
}

-(NSData *)makeScreenshotFromViewOriginal
{
    CGSize imageSize = [ self calculationSizeImageFromData ];
    
    UIImageView *screenshotView = [ [ UIImageView alloc ] initWithFrame: CGRectMake( 0, 0, imageSize.width, imageSize.height ) ];
    screenshotView.backgroundColor = [ UIColor whiteColor ];
    screenshotView.image = self.imageFromData;
    
    CGRect rect = CGRectMake( 0, 0, screenshotView.frame.size.width, screenshotView.frame.size.height );
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [ screenshotView.layer renderInContext:context ];
    
    UIImage *screnshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation( screnshot );
}

- (UIImage*)makeScreenshotFromViewSettings
{
    CGSize imageSize = [ self calculationSizeImageFromDataSettings ];
    
    UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame: CGRectMake( 0, 0, imageSize.width, imageSize.height ) ];
    imageView.image = self.imageFromData;
    
    CGRect rect = CGRectMake( 0, 0, imageSize.width - 1, imageSize.height - 1 );
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [ imageView.layer renderInContext:context ];
    
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}

#pragma mark - Text editing methods -

//начало редактирования текста
- (void)textViewDidBeginEditing:(UITextView *)textPostMessage
{
    switch ( textPostMessage.tag )
    {
        case 1000:
        {
            self.textPostMessage.textColor = [ UIColor blackColor ];
            if ( [ self isTextNil ] )
            {
                self.textPostMessage.text = nil;
            }
            [ UIView beginAnimations:nil context:NULL ];
            [ UIView setAnimationDelegate:self ];
            [ UIView setAnimationDuration:0.3 ];
            [ UIView setAnimationBeginsFromCurrentState:YES ];
            self.view.frame = CGRectMake(self.view.frame.origin.x,
            (is_ios_7()?(is_4_inch()?(self.view.frame.origin.y - 210):(self.view.frame.origin.y - 210)):(is_4_inch()?(self.view.frame.origin.y - 186.f):(self.view.frame.origin.y - 186.f))),
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
            [ UIView commitAnimations ];
            break;
        }
        default:
            break;
    }
}

//нажал ретурн
- (void)textViewDidEndEditing:(UITextView*)textPostMessage
{
    switch ( textPostMessage.tag )
    {
        case 1000:
        {
            if ( [ self.textPostMessage.text isEqualToString:@"" ] )
            {
                self.textPostMessage.textColor = [ UIColor grayColor ];
                self.textPostMessage.text = @"Введите текст сообщения здесь";
            }
            [ UIView beginAnimations:nil context:NULL ];
            [ UIView setAnimationDelegate:self ];
            [ UIView setAnimationDuration:0.3 ];
            [ UIView setAnimationBeginsFromCurrentState:YES ];
            self.view.frame = CGRectMake(self.view.frame.origin.x,
            (is_ios_7()?(is_4_inch()?(self.view.frame.origin.y + 210):(self.view.frame.origin.y + 210)):(is_4_inch()?(self.view.frame.origin.y + 186.f):(self.view.frame.origin.y + 186.f))),
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);
            [ UIView commitAnimations ];
            [ textPostMessage resignFirstResponder ];
            
            break;
        }
        default:
            break;
    }
}

//можно ли добавить текст
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [ self.textPostMessage.text length ] >= 500 && ![ text isEqualToString:@"" ] )
        return NO;
    else
        return YES;
}

-(void)hideKeyboard:(id)sender
{
    [ self.textPostMessage resignFirstResponder ];
}

#pragma mark - Data and time -

//смещение вьюхи времени и даты
-(void)changeYforTimeAndDateView:(BOOL)scritPicker
{
    if ( scritPicker )
    {
        if ( is_4_inch() )
        {
            self.dateView.frame = CGRectMake(self.dateView.frame.origin.x,
                                            (self.dateView.frame.origin.y + 265.f),
                                             self.dateView.frame.size.width,
                                             self.dateView.frame.size.height);
        }
        else
        {
            self.dateView.frame = CGRectMake(self.dateView.frame.origin.x,
                                            (self.dateView.frame.origin.y + 260.f),
                                             self.dateView.frame.size.width,
                                             self.dateView.frame.size.height);
        }
    }
    else
    {
        if ( is_4_inch() )
        {
            self.dateView.frame = CGRectMake(self.dateView.frame.origin.x,
                                            (self.dateView.frame.origin.y - 265.f),
                                             self.dateView.frame.size.width,
                                             self.dateView.frame.size.height);
        }
        else
        {
            self.dateView.frame = CGRectMake(self.dateView.frame.origin.x,
                                            (self.dateView.frame.origin.y - 260.f),
                                             self.dateView.frame.size.width,
                                             self.dateView.frame.size.height);
        }
    }
}

// Add Date
-(void)didDataPicked:(id)notused
{
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    
    self.changeDate = [ self.datePicker date ];
    self.dateString = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:[ self.datePicker date ] ] ];

    [ UIView beginAnimations:nil context:nil ];
    [ UIView setAnimationDuration:0.3 ];
    [ self changeYforTimeAndDateView:YES ];
    [ UIView commitAnimations ];
    [ self.tableView reloadData ];
    
    self.ban = NO;
}

#pragma mark - Calculation Size -

-(CGSize)calculationSizeImageFromDataSettings
{
    CGSize imageSize = CGSizeZero;
    CGFloat wightOfImage = 0.f;
    CGFloat hightOfImage = 0.f;
    CGFloat maxH = 40.0f;
    CGFloat maxW = 80.0f;
    
    if ( ( self.imageFromData.size.width ) > maxW && ( self.imageFromData.size.height > maxH ))
    {
        if ( self.imageFromData.size.height == self.imageFromData.size.width )
        {
            wightOfImage = maxH;
            hightOfImage = maxH;
        }
        if ( ( self.imageFromData.size.height > self.imageFromData.size.width )
            || ( self.imageFromData.size.height < self.imageFromData.size.width ) )
        {
            hightOfImage = maxH;
            wightOfImage = (float)((maxH/(float)self.imageFromData.size.height) * (float)self.imageFromData.size.width);
            if ( wightOfImage > maxW )
            {
                hightOfImage = (float)((maxW/(float)wightOfImage) * (float)hightOfImage);
                wightOfImage = maxW;
            }
        }
    }
    else
    {
        if ( self.imageFromData.size.width > maxW && self.imageFromData.size.height <= maxH )
        {
            hightOfImage = (float)((maxW/(float)self.imageFromData.size.width) * (float)self.imageFromData.size.height);
            wightOfImage = maxW;
        }
        if ( self.imageFromData.size.width <= maxW && self.imageFromData.size.height > maxH )
        {
            hightOfImage = maxH;
            wightOfImage = (float)((maxH/(float)self.imageFromData.size.height) * (float)self.imageFromData.size.width);
        }
        if ( ( self.imageFromData.size.width <= maxW && self.imageFromData.size.height <= maxH )
            || ( self.imageFromData.size.height == self.imageFromData.size.width ))
        {
            wightOfImage = self.imageFromData.size.width;
            hightOfImage = self.imageFromData.size.height;
        }
    }
    imageSize.width = wightOfImage;
    imageSize.height = hightOfImage;
    
    return imageSize;
}

-(CGSize)calculationSizeImageFromData
{
    CGSize imageSize = CGSizeZero;
    CGFloat wightOfImage = 0.f;
    CGFloat hightOfImage = 0.f;
    CGFloat maxH = 100.0f;
    CGFloat maxW = 174.0f;
    
    if ( ( self.imageFromData.size.width ) > maxW && ( self.imageFromData.size.height > maxH ))
    {
        if ( self.imageFromData.size.height == self.imageFromData.size.width )
        {
            wightOfImage = maxH;
            hightOfImage = maxH;
        }
        if ( ( self.imageFromData.size.height > self.imageFromData.size.width )
            || ( self.imageFromData.size.height < self.imageFromData.size.width ) )
        {
            hightOfImage = maxH;
            wightOfImage = (float)((maxH/(float)self.imageFromData.size.height) * (float)self.imageFromData.size.width);
            if ( wightOfImage > maxW )
            {
                hightOfImage = (float)((maxW/(float)wightOfImage) * (float)hightOfImage);
                wightOfImage = maxW;
            }
        }
    }
    else
    {
        if ( self.imageFromData.size.width > maxW && self.imageFromData.size.height <= maxH )
        {
            hightOfImage = (float)((maxW/(float)self.imageFromData.size.width) * (float)self.imageFromData.size.height);
            wightOfImage = maxW;
        }
        if ( self.imageFromData.size.width <= maxW && self.imageFromData.size.height > maxH )
        {
            hightOfImage = maxH;
            wightOfImage = (float)((maxH/(float)self.imageFromData.size.height) * (float)self.imageFromData.size.width);
        }
        if ( ( self.imageFromData.size.width <= maxW && self.imageFromData.size.height <= maxH )
            || ( self.imageFromData.size.height == self.imageFromData.size.width ))
        {
            wightOfImage = self.imageFromData.size.width;
            hightOfImage = self.imageFromData.size.height;
        }
    }
    imageSize.width = wightOfImage;
    imageSize.height = hightOfImage;
    
    return imageSize;
}

-(CGSize)calculationSizeText
{
    CGSize textSize = CGSizeZero;
    
    UILabel *textLabel = [ [ UILabel alloc ] init ];
    textLabel.text = self.textPostMessage.text;
    textLabel.frame = CGRectMake(k_Text_Label_Offset_X,
                                 k_Text_Label_Offset_Y,
                                 k_Text_Label_Offset_W,
                                 k_Text_Label_Offset_H );
    textLabel.numberOfLines = 0;
    textLabel.opaque = NO;
    textLabel.font = [ UIFont fontWithName:@"HelveticaNeue-Light" size:k_Text_Label_Font_Size ];
    [ textLabel sizeToFit ];
    
    textSize.width  = textLabel.frame.size.width;
    textSize.height = textLabel.frame.size.height;
    
    return textSize;
}

-(CGSize)calculationSizePerformer
{
    CGSize textSize = CGSizeZero;
    
    UILabel *textLabel = [ [ UILabel alloc ] init ];
    textLabel.text = self.m_performer;
    textLabel.frame = CGRectMake(k_Text_Label_Offset_X,
                                 k_Text_Label_Offset_Y,
                                 k_Performer_Label_Offset_W,
                                 k_Performer_Label_Offset_H );
    textLabel.numberOfLines = 0;
    textLabel.opaque = NO;
    textLabel.font = [ UIFont fontWithName:@"Helvetica" size:k_Performer_Label_Offset_H ];
    [ textLabel sizeToFit ];
    
    textSize.width = textLabel.frame.size.width;
    textSize.height = textLabel.frame.size.height;
    
    return textSize;
}

-(CGSize)calculationSizeSongTitle
{
    CGSize textSize = CGSizeZero;
    
    UILabel *textLabel = [ [ UILabel alloc ] init ];
    textLabel.text = self.m_song_title;
    textLabel.frame = CGRectMake(k_Text_Label_Offset_X,
                                 k_Text_Label_Offset_Y,
                                 k_SongTitle_Label_Offset_W,
                                 k_SongTitle_Label_Offset_H );
    textLabel.numberOfLines = 0;
    textLabel.opaque = NO;
    textLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_SongTitle_Label_Font_Size ];
    [ textLabel sizeToFit ];
    
    textSize.width = textLabel.frame.size.width;
    textSize.height = textLabel.frame.size.height;
    
    return textSize;
}

-(CGFloat)calculationHeightCell
{
    int offsetDate = 0;
    
//if date
    if ( self.dateString !=nil )
    {
//        offsetDate = k_Date_Offset;
    }

CGRect bubbleRect = CGRectZero;
    
//if_Text
    
    if ( ![ self isTextNil ] && self.imageFromData == nil && self.m_performer == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text ];
    }
    
//if_Image
    
    if ( [ self isTextNil ] && self.imageFromData != nil && self.m_performer == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Image ];
    }
    
//if_Music
    
    if ( [ self isTextNil ] && self.imageFromData == nil && self.m_performer != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Music ];
    }
    
//if_Text_Image
    
    if ( ![ self isTextNil ] && self.imageFromData != nil && self.m_performer == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text_Image ];
    }
    
//if_Text_Music
    
    if ( ![ self isTextNil ] && self.imageFromData == nil && self.m_performer != nil)
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text_Music ];
    }
    
//if_Image_Music
    
    if ( [ self isTextNil ] && self.imageFromData != nil && self.m_performer != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Image_Music ];
    }
    
//ifText_Image_Music
    
    if ( ![ self isTextNil ] && self.imageFromData != nil && self.m_performer != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text_Image_Music ];
    }
    
    NSLog(@"CELL 2 HEIGHT = %f",bubbleRect.size.height + k_Bubble_Offset_Y + offsetDate - k_Cell_Offset );
    return bubbleRect.size.height + k_Bubble_Offset_Y + offsetDate - k_Cell_Offset;
}

-(CGRect)calculationSizeTime
{
    CGFloat cellHeight = [ self calculationHeightCell ];
    CGRect timeSize   = CGRectZero;
    CGRect bubbleRect = CGRectZero;
    
//if_Text
    
    if ( ![ self isTextNil ] && self.imageFromData == nil && self.m_performer == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text ];
    }
    
//if_Image
    
    if ( [ self isTextNil ] && self.imageFromData != nil && self.m_performer == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Image ];
    }
    
//if_Music
    
    if ( [ self isTextNil ] && self.imageFromData == nil && self.m_performer != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Music ];
    }
    
//if_Text_Image
    
    if ( ![ self isTextNil ] && self.imageFromData != nil && self.m_performer == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text_Image ];
    }
    
//if_Text_Music
    
    if ( ![ self isTextNil ] && self.imageFromData == nil && self.m_performer != nil)
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text_Music ];
    }
    
//if_Image_Music
    
    if ( [ self isTextNil ] && self.imageFromData != nil && self.m_performer != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Image_Music ];
    }
    
//ifText_Image_Music
    
    if ( ![ self isTextNil ] && self.imageFromData != nil && self.m_performer != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text_Image_Music ];
    }
    
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"HH:mm";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
    
    UILabel *timeLabel = [ [ UILabel alloc ] init ];
    timeLabel.text = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:self.changeDate ] ];
    timeLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Time_Label_Font_size ];
    [ timeLabel sizeToFit ];
    
    if ( self.inputMassegeBool == 0 )
    {
        timeSize = CGRectMake(kScreenWidth - (bubbleRect.size.width + k_Time_Label_Offset_output_X),
                              cellHeight - k_Time_Label_Offset_Y,
                              timeLabel.frame.size.width,
                              timeLabel.frame.size.height);
    }
    else
    {
        timeSize = CGRectMake(bubbleRect.size.width + k_Time_Label_Offset_input_X,
                              cellHeight - k_Time_Label_Offset_Y,
                              timeLabel.frame.size.width,
                              timeLabel.frame.size.height);
    }
    return timeSize;
}

-(CGRect)calculationImageViewSize:(BubbleType)type
{
    self.type = type;
    CGRect imageViewSize = CGRectZero;
    
    switch (self.type)
    {
//if_Image
        case bubble_Type_Image:
        {
            CGSize imageSize = [ self calculationSizeImageFromData ];
            
            if ( self.inputMassegeBool == 0 )
            {
                UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake( k_ImageView_Offset_Output_X, k_ImageView_OnlyImage_Offset_Output_Y, imageSize.width, imageSize.height ) ];
                imageViewSize.origin.x = imageView.frame.origin.x;
                imageViewSize.origin.y = imageView.frame.origin.y;
                imageViewSize.size.width = imageView.frame.size.width;
                imageViewSize.size.height = imageView.frame.size.height;
            }
            if ( self.inputMassegeBool == 1 )
            {
                UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake( k_ImageView_Offset_Input_X, k_ImageView_OnlyImage_Offset_Input_Y, imageSize.width, imageSize.height ) ];
                imageViewSize.origin.x = imageView.frame.origin.x;
                imageViewSize.origin.y = imageView.frame.origin.y;
                imageViewSize.size.width = imageView.frame.size.width;
                imageViewSize.size.height = imageView.frame.size.height;
            }
            break;
        }
//if_Text_Image
        case bubble_Type_Text_Image:
        {
            CGSize textSize  = [ self calculationSizeText ];
            CGSize imageSize = [ self calculationSizeImageFromData ];
    
            if ( self.inputMassegeBool == 0 )
            {
                if ( imageSize.width < textSize.width )
                {
                    imageViewSize = CGRectMake(k_ImageView_Offset_Output_X,
                                               k_ImageView_OnlyImage_Text_Offset_Y + textSize.height,
                                               k_ImageView_OnlyImage_Text_Offset_W + textSize.width,
                                               imageSize.height);
                }
                if ( imageSize.width > textSize.width )
                {
                    imageViewSize = CGRectMake(k_ImageView_Offset_Output_X,
                                               k_ImageView_OnlyImage_Text_Offset_Y + textSize.height,
                                               imageSize.width,
                                               imageSize.height);
                }
            }
            if ( self.inputMassegeBool == 1 )
            {
                if ( imageSize.width < textSize.width )
                {
                    imageViewSize = CGRectMake(k_ImageView_Offset_Input_X - 1,
                                               k_ImageView_OnlyImage_Text_Offset_Y + textSize.height,
                                               k_ImageView_OnlyImage_Text_Offset_W + textSize.width,
                                               imageSize.height);
                }
                if ( imageSize.width > textSize.width )
                {
                    imageViewSize = CGRectMake(k_ImageView_Offset_Input_X - 1,
                                               k_ImageView_OnlyImage_Text_Offset_Y + textSize.height,
                                               imageSize.width,
                                               imageSize.height);
                }
            }
            break;
        }
            
//if_Image_Music
            
        case bubble_Type_Image_Music:
        {
            CGSize imageSize = [ self calculationSizeImageFromData ];
            
            if ( self.inputMassegeBool == 0 )
            {
                imageViewSize = CGRectMake(k_ImageView_Offset_Output_X,
                                           k_ImageView_OnlyImage_Offset_Output_Y,
                                           k_MusicView_Offset_W,
                                           imageSize.height);
            }
            if ( self.inputMassegeBool == 1 )
            {
                imageViewSize = CGRectMake(k_ImageView_Offset_Input_X -1,
                                           k_ImageView_OnlyImage_Offset_Input_Y,
                                           k_MusicView_Offset_W,
                                           imageSize.height);
            }
            break;
        }
            
//if_Text_Image_Music
            
        case bubble_Type_Text_Image_Music:
        {
            CGSize textSize  = [ self calculationSizeText ];
            CGSize imageSize = [ self calculationSizeImageFromData ];
            
            if ( self.inputMassegeBool == 0 )
            {
                imageViewSize = CGRectMake(k_ImageView_Offset_Output_X,
                                           k_ImageView_OnlyImage_Text_Offset_Y + textSize.height ,
                                           k_MusicView_Offset_W + 3.f,
                                           imageSize.height);
            }
            if ( self.inputMassegeBool == 1 )
            {
                imageViewSize = CGRectMake(k_ImageView_Offset_Input_X -0.5f,
                                           k_ImageView_OnlyImage_Text_Offset_Y + textSize.height,
                                           k_MusicView_Offset_W + 2.f,
                                           imageSize.height);
            }
            break;
        }
        default:
            break;
    }
    return imageViewSize;
}

-(CGRect)calculationBubbleImageSize:(BubbleType)type
{
    self.type = type;
    CGRect bubbleImageSize = CGRectZero;
    

    switch (self.type)
    {
            
//if_Text
            
        case bubble_Type_Text:
        {
            CGSize textSize = [ self calculationSizeText ];
           
            if ( self.inputMassegeBool == 0 )
            {
                bubbleImageSize = CGRectMake((kScreenWidth - (textSize.width + k_Bubble_Type_Text_Offset_X)),
                                             (k_Bubble_Offset_Y),
                                             (textSize.width  + k_Bubble_Type_Text_Offset_W),
                                             (textSize.height + k_Bubble_Type_Text_Offset_H));
            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake( 0,
                                             (k_Bubble_Offset_Y),
                                             (textSize.width  + k_Bubble_Type_Text_Offset_W),
                                             (textSize.height + k_Bubble_Type_Text_Offset_H));
            }
            break;
        }
            
//if_Image
            
        case bubble_Type_Image:
        {
            CGSize imageSize = [ self calculationSizeImageFromData ];

            if ( self.inputMassegeBool == 0 )
            {
                bubbleImageSize = CGRectMake((kScreenWidth - ( imageSize.width + k_Bubble_Type_Image_Offset_X)),
                                             (k_Bubble_Offset_Y),
                                             (imageSize.width  + k_Bubble_Type_Image_Offset_Output_W),
                                             (imageSize.height + k_Bubble_Type_Image_Offset_Output_H));

            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake( 0,
                                             (k_Bubble_Offset_Y),
                                             (imageSize.width  + k_Bubble_Type_Image_Offset_Input_W),
                                             (imageSize.height + k_Bubble_Type_Image_Offset_Input_H));
            }
            break;
        }
            
//if_Music
            
        case bubble_Type_Music:
        {
            if ( self.inputMassegeBool == 0 )
            {
                bubbleImageSize = CGRectMake((kScreenWidth - (k_MusicView_Offset_W + k_Bubble_Type_Music_Offset_X)),
                                             (k_Bubble_Offset_Y),
                                             (k_MusicView_Offset_W + k_Bubble_Type_Music_Offset_W),
                                             (k_MusicView_Offset_H + k_Bubble_Type_Music_Offset_H));
            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake( 0,
                                             (k_Bubble_Offset_Y),
                                             (k_MusicView_Offset_W + k_Bubble_Type_Music_Offset_W),
                                             (k_MusicView_Offset_H + k_Bubble_Type_Music_Offset_H ));
            }
            break;
        }
            
//if_Text_Image
            
        case bubble_Type_Text_Image:
        {
            CGSize textSize  = [ self calculationSizeText ];
            CGSize imageSize = [ self calculationSizeImageFromData ];
            
            if ( self.inputMassegeBool == 0 )
            {
                if ( imageSize.width < textSize.width )
                {
                    bubbleImageSize = CGRectMake((kScreenWidth - (textSize.width  + k_Bubble_Type_Text_Image_Offset_X)),
                                                 (k_Bubble_Offset_Y),
                                                 (                   textSize.width  + k_Bubble_Type_Text_Image_Offset_W),
                                                 (imageSize.height + textSize.height + k_Bubble_Type_Text_Image_Offset_H));
                }
                if ( imageSize.width > textSize.width )
                {
                    bubbleImageSize = CGRectMake((kScreenWidth - (imageSize.width + k_Bubble_Type_Text_less_Image_Offset_X)),
                                                 (k_Bubble_Offset_Y),
                                                 (imageSize.width                    + k_Bubble_Type_Text_less_Image_Offset_W ),
                                                 (imageSize.height + textSize.height + k_Bubble_Type_Text_Image_Offset_H));
                }
            }
            if ( self.inputMassegeBool == 1 )
            {
                if ( imageSize.width < textSize.width )
                {
                    bubbleImageSize = CGRectMake( 0,
                                                 (k_Bubble_Offset_Y),
                                                 (                   textSize.width  + k_Bubble_Type_Text_Image_Offset_W),
                                                 (imageSize.height + textSize.height + k_Bubble_Type_Text_Image_Offset_H));
                }
                if ( imageSize.width > textSize.width )
                {
                    bubbleImageSize = CGRectMake( 0,
                                                 (k_Bubble_Offset_Y),
                                                 (imageSize.width                    + k_Bubble_Type_Text_less_Image_Offset_W ),
                                                 (imageSize.height + textSize.height + k_Bubble_Type_Text_Image_Offset_H));
                }
            }
            break;
        }
            
//if_Text_Music
            
        case bubble_Type_Text_Music:
        {
            CGSize textSize = [ self calculationSizeText ];
            CGSize performerSize = [ self calculationSizePerformer ];
            CGSize songTitleSize = [ self calculationSizeSongTitle ];

            if ( self.inputMassegeBool == 0 )
            {
                if ( ( ( performerSize.width + 47.f ) < textSize.width ) || ( ( songTitleSize.width + 47.f ) < textSize.width ) )
                {
                    bubbleImageSize = CGRectMake((kScreenWidth - ( textSize.width + k_Bubble_Type_Text_Music_Offset_X )),
                                                 (k_Bubble_Offset_Y),
                                                 (                        textSize.width  + k_Bubble_Type_Text_Music_Offset_W ),
                                                 (k_MusicView_Offset_H  + textSize.height + k_Bubble_Type_Text_Music_Offset_H));
                }
                if ( ( ( performerSize.width + 47.f ) > textSize.width ) || ( ( songTitleSize.width + 47.f ) > textSize.width ) )
                {
                    bubbleImageSize = CGRectMake((kScreenWidth - (k_MusicView_Offset_W + k_Bubble_Type_Text_Music_Offset_X)),
                                                 (k_Bubble_Offset_Y),
                                                 (k_MusicView_Offset_W                   + k_Bubble_Type_Text_Music_Offset_W),
                                                 (k_MusicView_Offset_H + textSize.height + k_Bubble_Type_Text_Music_Offset_H));
                }
            }
            if ( self.inputMassegeBool == 1 )
            {
                if ( ( ( performerSize.width + 47.f ) < textSize.width ) || ( ( songTitleSize.width + 47.f ) < textSize.width ) )
                {
                    bubbleImageSize = CGRectMake( 0,
                                                 (k_Bubble_Offset_Y),
                                                 (textSize.width                         + k_Bubble_Type_Text_Music_Offset_W ),
                                                 (textSize.height + k_MusicView_Offset_H + k_Bubble_Type_Text_Music_Offset_H ));
                }
                if ( ( ( performerSize.width + 47.f ) > textSize.width ) || ( ( songTitleSize.width + 47.f ) > textSize.width ) )
                {
                    bubbleImageSize = CGRectMake( 0,
                                                 (k_Bubble_Offset_Y),
                                                 (                  k_MusicView_Offset_W + k_Bubble_Type_Music_Offset_W),
                                                 (textSize.height + k_MusicView_Offset_H + k_Bubble_Type_Text_Music_Offset_H));
                }
            }
            break;
        }
            
//if_Image_Music
            
        case bubble_Type_Image_Music:
        {
            CGSize imageSize = [ self calculationSizeImageFromData ];
            
            if ( self.inputMassegeBool == 0 )
            {
               bubbleImageSize = CGRectMake((kScreenWidth - (k_MusicView_Offset_W + k_Bubble_Type_Image_Music_Offset_X)),
                                            (k_Bubble_Offset_Y),
                                            (                   k_MusicView_Offset_W + k_Bubble_Type_Image_Music_Offset_W),
                                            (imageSize.height + k_MusicView_Offset_H + k_Bubble_Type_Image_Music_Offset_H));
            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake( 0,
                                             (k_Bubble_Offset_Y),
                                             (                   k_MusicView_Offset_W + k_Bubble_Type_Image_Music_Offset_X),
                                             (imageSize.height + k_MusicView_Offset_H + k_Bubble_Type_Image_Music_Offset_H ) );
            }
            break;
        }
            
//if_Text_Image_Music
            
        case bubble_Type_Text_Image_Music:
        {
            CGSize textSize  = [ self calculationSizeText ];
            CGSize imageSize = [ self calculationSizeImageFromData ];
            
            if ( self.inputMassegeBool == 0 )
            {
                bubbleImageSize = CGRectMake((kScreenWidth - (k_MusicView_Offset_W + k_Bubble_Type_Text_Image_Music_Offset_X)),
                                             (k_Bubble_Offset_Y),
                                             (                                     k_MusicView_Offset_W + k_Bubble_Type_Text_Image_Music_Offset_W),
                                             (imageSize.height + textSize.height + k_MusicView_Offset_H + k_Bubble_Type_Text_Image_Music_Offset_H ));
            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake( 0,
                                             (k_Bubble_Offset_Y),
                                             (                                     k_MusicView_Offset_W + k_Bubble_Type_Text_Image_Music_Offset_W),
                                             (imageSize.height + textSize.height + k_MusicView_Offset_H +  k_Bubble_Type_Text_Image_Music_Offset_H));
            }
            break;
        }
        default:
            break;
    }
    return bubbleImageSize;
}

#pragma mark - BOOL methods -

-(BOOL)isTextNil {
    BOOL isEqual = '\0';
    if ( [ self.textPostMessage.text isEqualToString:@"Введите текст сообщения здесь" ] )
        isEqual = YES;
    else
        isEqual = NO;
    return isEqual;
}

#pragma mark - Memory Menagment -

-(void)dealloc {
    NSLog(@"DEALOC SETTINGS");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end