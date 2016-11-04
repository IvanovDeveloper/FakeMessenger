//
//  vibonaktePostMessage.m
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "vib_settings_vc.h"
#import "AppDelegate.h"

#import "vib_vc.h"
#import "DB_vib.h"
#import "vib_settings_cell.h"

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

#define k_Time_Label_Font_size 10.f
#define k_Time_Date_view_H   284.f
#define k_Time_Date_picker_H 216.f
#define kToolbarHeight 44.f

//Date

#define k_Date_Offset 26.f

//Time

#define k_Time_Label_Offset_output_X 84.f
#define k_Time_Label_Offset_input_X  46.f
#define k_Time_Label_Offset_Y  8.f

//Text

#define k_Text_Label_Offset_X 10.f
#define k_Text_Label_Offset_Y 10.f
#define k_Text_Label_Offset_Output_W 210.f
#define k_Text_Label_Offset_Input_W 218.f
#define k_Text_Label_Offset_H 900.f
#define k_Text_Label_Font_Size 16.f

//ImageView

#define k_ImageView_Offset_Output_X 5.f
#define k_ImageView_Offset_Input_X  10.5f
#define k_ImageView_OnlyImage_Offset_Y 5.f

//Cell H

#define k_Cell_Offset -1.f

//Bubble

#define k_Bubble_Offset_Y 5.f

#define k_Bubble_Type_Text_Output_Offset_X 64.f
#define k_Bubble_Type_Text_Output_Offset_W 21.f
#define k_Bubble_Type_Text_Output_Offset_H 23.f
#define k_Bubble_Type_Text_Input_Offset_X  42.f
#define k_Bubble_Type_Text_Input_Offset_W 19.f
#define k_Bubble_Type_Text_Input_Offset_H 17.f

#define k_Bubble_Type_Image_Output_Offset_X 58.f
#define k_Bubble_Type_Image_Output_Offset_W 15.5f
#define k_Bubble_Type_Image_Output_Offset_H 27.5f
#define k_Bubble_Type_Image_Input_Offset_X 43.f
#define k_Bubble_Type_Image_Input_Offset_W 16.f
#define k_Bubble_Type_Image_Input_Offset_H 13.f

@interface vib_settings_vc () < UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate >

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

@property (nonatomic, strong) UIImage *imageFromData;
@property (nonatomic, strong) UIImagePickerController *mediaUI;
@property (nonatomic, strong) UIImagePickerController *outPicker;
@property (nonatomic, strong) UIImagePickerController *inPicker;
@property (nonatomic, strong) UITextView *textPostMessage;

@property (nonatomic, strong) DB_vib *message;
@property (weak, nonatomic) NSString *recipientName;
@property (weak, nonatomic) NSString *carrierName;
@property (readonly, nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation vib_settings_vc

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
- (id)initWithInfoMessage:(DB_vib *)infoMessage andRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier
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
   
    self.title = is_RU_lang()?@"Настройки":@"Settings";
    self.view.backgroundColor = [ UIColor whiteColor ];
    [ self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault ];

    NSDate *date = [ NSDate date ];
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
    self.changeDate = date;
    self.dateString = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:date ] ];
    
    self.mediaUI   = [[UIImagePickerController alloc] init];
    self.outPicker = [[UIImagePickerController alloc] init];
    self.inPicker  = [[UIImagePickerController alloc] init];
    
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
    
    UIBarButtonItem *doneButton = [ [ UIBarButtonItem alloc ]initWithTitle:is_RU_lang()?@"Готово":@"Done"
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
    
    if( self.imageFromData == nil && [ self isTextNil ] )
        return;

//Расчитанные размеры вьюх которые будут добавлены на cell
    
    CGFloat cellHeight = [self calculationHeightCell ];
    CGSize textSize = [ self calculationSizeText ];
    CGRect timeRect = [ self calculationSizeTime ];
    
    
#pragma mark Add Добавление значений полей в базу
    
    if ( [ self.message.bool_message_created boolValue ] == NO )
    {
        _context = ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext;
        self.message = [ NSEntityDescription insertNewObjectForEntityForName:@"DB_vib" inManagedObjectContext:_context ];
    }
    
    self.message.bool_inputMassege = [NSNumber numberWithBool:self.inputMassegeBool];
    self.message.bool_message_created = [NSNumber numberWithBool:YES];
    self.message.d_timestamp = [ NSNumber numberWithDouble:self.changeDate.timeIntervalSince1970 ];
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
    if ( ![ self isTextNil ] && self.imageFromData == nil )
    {
        self.message.s_type_bubble = @"Text";
        
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Text ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
    }
//if_Image
    if ( self.imageFromData != nil )
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
    vib_settings_cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (cell == nil)
    {
        if ( indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 )
        {
            cell = [ [ vib_settings_cell alloc ] initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:CellIdentifier ];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            [ cell setSelectionStyle:UITableViewCellSelectionStyleNone ];
        }
        if ( indexPath.row == 3 )
        {
            cell = [ [ vib_settings_cell alloc ] initWithStyle:UITableViewCellStyleSubtitle
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
            cell.textLabel.text = is_RU_lang()?@"Входящие":@"Inbox";
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
                cell.textLabel.text = is_RU_lang()?[ NSString stringWithFormat:@"Дата : %@", [ dateFormatter stringFromDate:dateFromDB ] ]:[ NSString stringWithFormat:@"Date : %@", [ dateFormatter stringFromDate:dateFromDB ] ];
            }
            else
            {
                if( self.dateString != nil )
                {
                    cell.textLabel.text = is_RU_lang()?[ NSString stringWithFormat:@"Дата : %@", self.dateString ]:[ NSString stringWithFormat:@"Date : %@", self.dateString ];
                }
                else
                {
                    cell.textLabel.text = is_RU_lang()?@"Дата :":@"Date :";
                }
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0, 0.0, 44, 44);
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"FM_sett_Delete"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(refleshTime:)  forControlEvents:UIControlEventTouchUpInside];
            
            cell.imageView.image = nil;
            cell.accessoryView = button;
            break;
        }
            
#pragma mark cell 2
            
        case 2:
        {
            if( self.message.data_image != nil && self.messageCreatedEarly )
            {
                cell.textLabel.text = is_RU_lang()?@"Изменить":@"Change";
                self.imageFromData = [ UIImage imageWithData:self.message.data_image_original ];
                cell.imageView.image = [ self makeScreenshotFromViewSettings ];
            }
            else
            {
                if ( self.imageFromData == nil )
                {
                    cell.textLabel.text = is_RU_lang()?@"Добавить":@"Add";
                    cell.imageView.image = [ UIImage imageNamed:@"FM_sett_ImageDefault" ];
                }
                else
                {
                    cell.textLabel.text = is_RU_lang()?@"Изменить":@"Change";
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
            [ cell.outButton addTarget:self action:@selector(outAvatarStartMediaBrowserFromViewController:usingDelegate:) forControlEvents:UIControlEventTouchUpInside ];
            [ cell.inButton addTarget:self action:@selector(inAvatarStartMediaBrowserFromViewController:usingDelegate:) forControlEvents:UIControlEventTouchUpInside ];
            [ cell.outDeleteButton addTarget:self action:@selector(refleshOutImg:) forControlEvents:UIControlEventTouchUpInside ];
            [ cell.inDeleteButton  addTarget:self action:@selector(refleshInImg:)  forControlEvents:UIControlEventTouchUpInside ];

            NSString *outSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_outImage.png"];
            UIImage *outImageFromCaches = [UIImage imageWithContentsOfFile:outSTR];
            if ( outImageFromCaches != nil )
                cell.outImg.image = outImageFromCaches;
            else
                cell.outImg.image = [ UIImage imageNamed:@"vib_bm_DefaultAvatar" ];
            
            NSString *inSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_inImage.png"];
            UIImage *inImageFromCaches = [UIImage imageWithContentsOfFile:inSTR];
            if ( inImageFromCaches != nil )
                cell.inImg.image = inImageFromCaches;
            else
                cell.inImg.image = [ UIImage imageNamed:@"vib_bm_DefaultAvatar" ];
            
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
                    self.textPostMessage.text = is_RU_lang()?@"Введите текст сообщения здесь":@"Enter text message here";
                }
                self.messageCreatedEarly = NO;
            }
            else if ( [ self.textPostMessage.text isEqualToString:@"" ] )
            {
                self.textPostMessage.textColor = [UIColor grayColor];
                self.textPostMessage.text = is_RU_lang()?@"Введите текст сообщения здесь":@"Enter text message here";
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
                NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                
                if ( [ language isEqualToString:@"ru" ] )
                    self.datePicker.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
                else
                    self.datePicker.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"en_GB" ];
                
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
                
                UIBarButtonItem *addDate = [ [ UIBarButtonItem alloc ]initWithTitle:is_RU_lang()?@"Готово":@"Done"
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
        
    }
}

#pragma mark - Alert -


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 101 )
    {
        if ( buttonIndex == 0 )
            return;
        
        NSDate *date = [ NSDate date ];
        NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
        dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
        dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
        self.changeDate = date;
        self.dateString = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:date ] ];
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
        
        NSString *outSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_outImage.png"];
        NSFileManager *fm = [NSFileManager defaultManager];
        [ fm removeItemAtPath:outSTR error:nil ];
        
        [ self.tableView reloadData ];
    }
    if ( alertView.tag == 104 )
    {
        if ( buttonIndex == 0 )
            return;
        
        NSString *inSTR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_inImage.png"];
        NSFileManager *fm = [NSFileManager defaultManager];
        [ fm removeItemAtPath:inSTR error:nil ];
        
        [ self.tableView reloadData ];
    }
    if ( alertView.tag == 105 )
    {
        if ( buttonIndex == 0 )
            return;
        
        self.textPostMessage.textColor = [UIColor grayColor];
        self.textPostMessage.text = is_RU_lang()?@"Введите текст сообщения здесь":@"Enter text message here";
        
        [ self.tableView reloadData ];
    }

}

- (void)refleshTime:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok", nil ];
    addNameAlert.tag = 101;
    [ addNameAlert show ];
}

- (void)refleshImage:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok", nil ];
    addNameAlert.tag = 102;
    [ addNameAlert show ];
}

- (void)refleshOutImg:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok", nil ];
    addNameAlert.tag = 103;
    [ addNameAlert show ];
}

- (void)refleshInImg:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok", nil ];
    addNameAlert.tag = 104;
    [ addNameAlert show ];
}

- (void)refleshText:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok", nil ];
    addNameAlert.tag = 105;
    [ addNameAlert show ];
}
#pragma mark -
#pragma mark setOn Switch methods
#pragma mark -

- (void)setOnInput:(UISwitch*)mySwitch {
    self.inputMassegeBool = mySwitch.on;
}

#pragma mark - Picker picture methods -

- (BOOL)outAvatarStartMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    if ( ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO )
        || (delegate == nil)
        || (controller == nil) )
    {
        return NO;
    }
    
    self.outPicker.delegate = self;
    self.outPicker.allowsEditing = YES;
    self.outPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.outPicker animated:YES completion:NULL];
    
    return YES;
}

- (BOOL)inAvatarStartMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    if ( ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO )
        || (delegate == nil)
        || (controller == nil) )
    {
        return NO;
    }
    
    self.inPicker.delegate = self;
    self.inPicker.allowsEditing = YES;
    self.inPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.inPicker animated:YES completion:NULL];
    
    return YES;
}

- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
    {
        return NO;
    }
    
//    self.mediaUI = [ [ UIImagePickerController alloc ] init ];
    self.mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.mediaUI.mediaTypes = [ UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum ];
    self.mediaUI.allowsEditing = NO;
    self.mediaUI.delegate = delegate;
    [ controller presentViewController:self.mediaUI animated:YES completion:nil ];
    
    return YES;
}

//картинка береться с альбома
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ( picker == self.mediaUI )
    {
        self.imageFromData = nil;
        
        UIImage *originalImage;
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.imageFromData = [UIImage imageWithData:UIImagePNGRepresentation(originalImage)];
    }
    if ( picker == self.outPicker )
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
// // //
        UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame: CGRectMake( 0, 0, 40, 40 ) ];
        imageView.image = chosenImage;
        
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        [ imageView.layer renderInContext:context ];
        UIImage *screnshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
// // //
        
        NSString *STR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_outImage.png"];
        UIImage *im = [ UIImage imageWithData:UIImagePNGRepresentation( screnshot ) ];
        NSData *imagedata = UIImageJPEGRepresentation(im, 1.f);
        [imagedata writeToFile:STR atomically:YES];
        
    }
    if ( picker == self.inPicker )
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        
// // //
        UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame: CGRectMake( 0, 0, 40, 40 ) ];
        imageView.image = chosenImage;
        
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        [ imageView.layer renderInContext:context ];
        UIImage *screnshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
// // //
        
        NSString *STR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/vib_inImage.png"];
        UIImage *im = [ UIImage imageWithData:UIImagePNGRepresentation( screnshot ) ];
        NSData *imagedata = UIImageJPEGRepresentation(im, 1.f);
        [imagedata writeToFile:STR atomically:YES];
    }

    [ self.navigationController dismissViewControllerAnimated:YES completion:^{[self.tableView reloadData];} ];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//сделать скриншот
-(NSData *)makeScreenshotFromView
{
    CGSize imageSize = [ self calculationSizeImageFromData ];
    
    UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame: CGRectMake( 0, 0, imageSize.width, imageSize.height ) ];
    imageView.image = self.imageFromData;
    
    CGRect rect = CGRectMake( 0, 0, imageSize.width - 1, imageSize.height - 1 );
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
                self.textPostMessage.text = is_RU_lang()?@"Введите текст сообщения здесь":@"Enter text message here";
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
    CGFloat maxH = 170.0f;
    CGFloat maxW = 165.0f;
    
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
    if ( self.inputMassegeBool == 1 )
        textLabel.frame = CGRectMake(k_Text_Label_Offset_X,
                                     k_Text_Label_Offset_Y,
                                     k_Text_Label_Offset_Input_W,
                                     k_Text_Label_Offset_H );
    else
        textLabel.frame = CGRectMake(k_Text_Label_Offset_X,
                                     k_Text_Label_Offset_Y,
                                     k_Text_Label_Offset_Output_W,
                                     k_Text_Label_Offset_H );
    textLabel.numberOfLines = 0;
    textLabel.opaque = NO;
    textLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Text_Label_Font_Size ];
    [ textLabel sizeToFit ];
     NSLog(@"%f",textLabel.frame.size.width);
    if ( self.inputMassegeBool == 1 )
    {
        if( [ textLabel.text length ] <= 3 )
            textLabel.frame = CGRectMake(textLabel.frame.origin.x,
                                         textLabel.frame.origin.y,
                                         30.f,
                                         textLabel.frame.size.height );
    }
    else
    {
        if( [ textLabel.text length ] <= 9 )
            textLabel.frame = CGRectMake(textLabel.frame.origin.x,
                                         textLabel.frame.origin.y,
                                         85.f,
                                         textLabel.frame.size.height );
    }
        
    NSLog(@"%f",textLabel.frame.size.width);
    textSize.width  = textLabel.frame.size.width;
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
    
    if ( ![ self isTextNil ] && self.imageFromData == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text ];
    }
    
//if_Image
    
    if ( self.imageFromData != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Image ];
    }
    
    NSLog(@"CELL 2 HEIGHT = %f",bubbleRect.size.height + k_Bubble_Offset_Y + offsetDate - k_Cell_Offset );
    return bubbleRect.size.height + k_Bubble_Offset_Y + offsetDate - k_Cell_Offset;
}

-(CGRect)calculationSizeTime
{
    CGFloat cellHeight = [ self calculationHeightCell ];
    CGRect timeSize   = CGRectZero;
    CGRect bubbleRect = CGRectZero;
    int offsetH = 10;
//if_Text
    
    if ( ![ self isTextNil ] && self.imageFromData == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text ];
    }
    
//if_Image
    
    if ( self.imageFromData != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Image ];
    }
    
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"  HH:mm  ";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
    
    UILabel *timeLabel = [ [ UILabel alloc ] init ];
    timeLabel.text = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:self.changeDate ] ];
    timeLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Time_Label_Font_size ];
    [ timeLabel sizeToFit ];
    
    if ( self.inputMassegeBool == 0 )
    {
        timeSize = CGRectMake(kScreenWidth - (bubbleRect.size.width + k_Time_Label_Offset_output_X),
                              (cellHeight/2) - k_Time_Label_Offset_Y,
                              timeLabel.frame.size.width,
                              timeLabel.frame.size.height + offsetH);
    }
    else
    {
        timeSize = CGRectMake(bubbleRect.size.width + k_Time_Label_Offset_input_X,
                              (cellHeight/2) - k_Time_Label_Offset_Y,
                              timeLabel.frame.size.width,
                              timeLabel.frame.size.height + offsetH);
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
                UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake( k_ImageView_Offset_Output_X, k_ImageView_OnlyImage_Offset_Y, imageSize.width, imageSize.height ) ];
                imageViewSize.origin.x = imageView.frame.origin.x;
                imageViewSize.origin.y = imageView.frame.origin.y;
                imageViewSize.size.width = imageView.frame.size.width;
                imageViewSize.size.height = imageView.frame.size.height;
            }
            if ( self.inputMassegeBool == 1 )
            {
                UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame:CGRectMake( k_ImageView_Offset_Input_X, k_ImageView_OnlyImage_Offset_Y, imageSize.width, imageSize.height ) ];
                imageViewSize.origin.x = imageView.frame.origin.x;
                imageViewSize.origin.y = imageView.frame.origin.y;
                imageViewSize.size.width = imageView.frame.size.width;
                imageViewSize.size.height = imageView.frame.size.height;
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
                bubbleImageSize = CGRectMake((kScreenWidth - (textSize.width + k_Bubble_Type_Text_Output_Offset_X)),
                                             (k_Bubble_Offset_Y),
                                             (textSize.width  + k_Bubble_Type_Text_Output_Offset_W),
                                             (textSize.height + k_Bubble_Type_Text_Output_Offset_H));
            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake( k_Bubble_Type_Text_Input_Offset_X,
                                             (k_Bubble_Offset_Y),
                                             (textSize.width  + k_Bubble_Type_Text_Input_Offset_W),
                                             (textSize.height + k_Bubble_Type_Text_Input_Offset_H));
            }
            break;
        }
            
//if_Image
            
        case bubble_Type_Image:
        {
            CGSize imageSize = [ self calculationSizeImageFromData ];

            if ( self.inputMassegeBool == 0 )
            {
                bubbleImageSize = CGRectMake((kScreenWidth - ( imageSize.width + k_Bubble_Type_Image_Output_Offset_X)),
                                             (k_Bubble_Offset_Y),
                                             (imageSize.width  + k_Bubble_Type_Image_Output_Offset_W),
                                             (imageSize.height + k_Bubble_Type_Image_Output_Offset_H));

            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake( k_Bubble_Type_Image_Input_Offset_X,
                                             (k_Bubble_Offset_Y),
                                             (imageSize.width  + k_Bubble_Type_Image_Input_Offset_W),
                                             (imageSize.height + k_Bubble_Type_Image_Input_Offset_H));
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
    if ( [ self.textPostMessage.text isEqualToString:is_RU_lang()?@"Введите текст сообщения здесь":@"Enter text message here" ] )
        isEqual = YES;
    else
        isEqual = NO;
    return isEqual;
}

#pragma mark - Memory Menagment -

-(void)dealloc {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end