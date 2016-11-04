//
//  vkonaktePostMessage.m
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "wat_settings_vc.h"
#import "AppDelegate.h"

#import "wat_vc.h"
#import "DB_wat.h"

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

#define k_Time_Label_Offset_output_isRUS_X 70.f
#define k_Time_Label_Offset_output_isENG_X 70.f
#define k_Time_Label_Offset_input_isRUS_X  29.f
#define k_Time_Label_Offset_input_isENG_X  29.f
#define k_Time_Label_Offset_Y  19.f

//Text

#define k_Text_Label_Offset_X 10.f
#define k_Text_Label_Offset_Y 5.f
#define k_Text_Label_Offset_W 245.f
#define k_Text_Label_Offset_H 900.f
#define k_Text_Label_Font_Size 16.f

//ImageView

#define k_ImageView_Offset_Output_X 7.f
#define k_ImageView_Offset_Input_X  13.f
#define k_ImageView_OnlyImage_Offset_Output_Y 6.f
#define k_ImageView_OnlyImage_Offset_Input_Y  7.f
#define k_ImageView_OnlyImage_Text_Offset_Y 9.f
#define k_ImageView_OnlyImage_Text_Offset_W 10.f

//Cell H

#define k_Cell_Offset 0.f

//Bubble

#define k_MaxW_LastLetters_Output 187.f
#define k_MaxW_LastLetters_Input  165.f

#define k_Bubble_Offset_Y 5.f

#define k_Bubble_Type_Text_Offset_Output_X 84.f
#define k_Bubble_Type_Text_Offset_Output_W 78.f
#define k_Bubble_Type_Text_Offset_Input_X  7.f
#define k_Bubble_Type_Text_Offset_Input_W  60.f
#define k_Bubble_Type_Text_Offset_H 10.f

#define k_Bubble_Type_Image_Offset_X 19.5f
#define k_Bubble_Type_Image_Offset_Output_W 19.5f
#define k_Bubble_Type_Image_Offset_Input_W  22.f
#define k_Bubble_Type_Image_Offset_Output_H 13.5f
#define k_Bubble_Type_Image_Offset_Input_H  15.f

@interface wat_settings_vc () < UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate >

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
@property (nonatomic, strong) UITextView *textPostMessage;

@property (nonatomic, strong) DB_wat *message;
@property (strong, nonatomic) NSString *recipientName;
@property (strong, nonatomic) NSString *carrierName;
@property (readonly, nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation wat_settings_vc

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
- (id)initWithInfoMessage:(DB_wat *)infoMessage andRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier
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
        self.message = [ NSEntityDescription insertNewObjectForEntityForName:@"DB_wat" inManagedObjectContext:_context ];
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
    if ( [ self isTextNil ] && self.imageFromData != nil )
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
    else
        return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
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
        if ( indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 )
        {
            cell = [ [ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier ];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            [ cell setSelectionStyle:UITableViewCellSelectionStyleNone ];
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
                cell.textLabel.text = is_RU_lang()?[ NSString stringWithFormat:@"Дата : %@", self.dateString ]:[ NSString stringWithFormat:@"Date : %@", self.dateString ];
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    if ( alertView.tag == 104 )
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
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok" , nil ];
    addNameAlert.tag = 101;
    [ addNameAlert show ];
}

- (void)refleshImage:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok" , nil ];
    addNameAlert.tag = 102;
    [ addNameAlert show ];
}

- (void)refleshText:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok" , nil ];
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
            (is_ios_7()?(self.view.frame.origin.y - 165):(self.view.frame.origin.y - 141.f)),
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
            (is_ios_7()?(self.view.frame.origin.y + 165):(self.view.frame.origin.y + 141.f)),
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
    
    textLabel.frame = CGRectMake(k_Text_Label_Offset_X,
                                 k_Text_Label_Offset_Y,
                                 k_Text_Label_Offset_W,
                                 k_Text_Label_Offset_H );
//    if ( ![ self biggerOneNumberLines ] && [ self textSize ].width >= 185.f )
//        textLabel.frame = CGRectMake(k_Text_Label_Offset_X, k_Text_Label_Offset_Y, 200.f, k_Text_Label_Offset_H );
    
    textLabel.numberOfLines = 0;
    textLabel.opaque = NO;
    textLabel.font = [ UIFont fontWithName:@"Helvetica-Light" size:k_Text_Label_Font_Size ];
    textLabel.text = self.textPostMessage.text;
    [ textLabel sizeToFit ];
    
//    CGSize size2 = [textLabel.text sizeWithFont:[ UIFont fontWithName:@"Helvetica-Light" size:k_Text_Label_Font_Size ]
//                              constrainedToSize:(CGSize){textLabel.frame.size.width, k_Text_Label_Offset_H}
//                                  lineBreakMode:NSLineBreakByWordWrapping];
//    textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y,size2.width, size2.height);
    textSize.width  = textLabel.frame.size.width;
    textSize.height = textLabel.frame.size.height;
    
    return textSize;
}

-(CGFloat)calculationHeightCell
{

CGRect bubbleRect = CGRectZero;
    
//if_Text
    
    if ( ![ self isTextNil ] && self.imageFromData == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text ];
    }
    
//if_Image
    
    if ( [ self isTextNil ] && self.imageFromData != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Image ];
    }

//    NSLog(@"CELL 2 HEIGHT = %f",bubbleRect.size.height + k_Bubble_Offset_Y - k_Cell_Offset );
    return bubbleRect.size.height + k_Bubble_Offset_Y - k_Cell_Offset;
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
        default:
            break;
    }
    return imageViewSize;
}

-(CGRect)calculationSizeTime
{
    CGFloat cellHeight = [ self calculationHeightCell ];
    CGRect timeSize   = CGRectZero;
    CGRect bubbleRect = CGRectZero;
    
    //if_Text
    
    if ( ![ self isTextNil ] && self.imageFromData == nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Text ];
    }
    
    //if_Image
    
    if ( [ self isTextNil ] && self.imageFromData != nil )
    {
        bubbleRect = [ self calculationBubbleImageSize: bubble_Type_Image ];
    }
    
    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = is_RU_lang()?@"HH:mm":@"HH:mm";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:is_RU_lang()?@"ru_RU":@"en_GB" ];
    
    UILabel *timeLabel = [ [ UILabel alloc ] init ];
    timeLabel.text = [ NSString stringWithFormat:@"%@",[ [ dateFormatter stringFromDate:self.changeDate ] uppercaseString ] ];
    timeLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Time_Label_Font_size ];
    [ timeLabel sizeToFit ];
    
    
    if ( self.inputMassegeBool == 0 )
    {
        timeSize = CGRectMake(kScreenWidth - ( is_RU_lang()?k_Time_Label_Offset_output_isRUS_X:k_Time_Label_Offset_output_isENG_X),
                              cellHeight - k_Time_Label_Offset_Y,
                              timeLabel.frame.size.width,
                              timeLabel.frame.size.height);
    }
    else
    {
        timeSize = CGRectMake(bubbleRect.size.width - (is_RU_lang()?k_Time_Label_Offset_input_isRUS_X:k_Time_Label_Offset_input_isENG_X),
                              cellHeight - k_Time_Label_Offset_Y,
                              timeLabel.frame.size.width,
                              timeLabel.frame.size.height);
    }
    return timeSize;
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
            float textOffset_W = 0.f;
            float textOffset_H = 0.f;

            if ( self.inputMassegeBool == 0 )
            {
                if ( ( [ self weightLastLetters ] >= k_MaxW_LastLetters_Output ) /*|| ( [ self numberLines ] == 2 && [ self textSize ].width >= 300.f )*/ )
                        textOffset_H = 14;
            }
            else
            {
                if ( ( [ self weightLastLetters ] >= k_MaxW_LastLetters_Input  ) /*|| ( [ self numberLines ] == 2 && [ self textSize ].width >= 300.f )*/ )
                    textOffset_H = 14;
            }
            if ( [ self biggerOneNumberLines ]  && [ self textSize ].width >= 170.f )
            {
                if ( self.inputMassegeBool == 0 )
                    textOffset_W = 50.f;
                else
                    textOffset_W = 34.f;
            }
            
            
            
            NSLog(@"======= weightLastLetters ===== %f",[ self weightLastLetters ]);
//            NSLog(@"======= TEXT W ===== %f",[ self weightLastLetters ]);
            
            
            if ( self.inputMassegeBool == 0 )
            {
                bubbleImageSize = CGRectMake((kScreenWidth - (textSize.width + k_Bubble_Type_Text_Offset_Output_X - textOffset_W)),
                                             (k_Bubble_Offset_Y),
                                             (textSize.width  + k_Bubble_Type_Text_Offset_Output_W - textOffset_W ),
                                             (textSize.height + k_Bubble_Type_Text_Offset_H + textOffset_H ));
            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake( k_Bubble_Type_Text_Offset_Input_X,
                                             (k_Bubble_Offset_Y),
                                             (textSize.width  + k_Bubble_Type_Text_Offset_Input_W - textOffset_W ),
                                             (textSize.height + k_Bubble_Type_Text_Offset_H + textOffset_H ));
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
        default:
            break;
    }
    return bubbleImageSize;
}

-(BOOL)biggerOneNumberLines
{
    if ( [self textSize].height > 20.f )
        return YES;
    else
        return NO;
}

-(float)numberLines
{
    UIFont *textFont = [ UIFont fontWithName:@"Helvetica-Light" size:k_Text_Label_Font_Size ];
    UILabel *textLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(k_Text_Label_Offset_X,
                                                                      k_Text_Label_Offset_Y,
                                                                      k_Text_Label_Offset_W,
                                                                      k_Text_Label_Offset_H ) ];
    textLabel.font = textFont;
    textLabel.numberOfLines = 0;
    textLabel.opaque = NO;
    
    textLabel.text = @"Hello World!";
    [ textLabel sizeToFit ];
    CGSize size = [textLabel.text sizeWithFont:textFont
                             constrainedToSize:(CGSize){k_Text_Label_Offset_W, k_Text_Label_Offset_H}
                                 lineBreakMode:NSLineBreakByWordWrapping];
    float heightOneLine = size.height;
    
    textLabel.text = self.textPostMessage.text;
    [ textLabel sizeToFit ];
    CGSize size2 = [textLabel.text sizeWithFont:textFont
                              constrainedToSize:(CGSize){k_Text_Label_Offset_W, k_Text_Label_Offset_H}
                                  lineBreakMode:NSLineBreakByWordWrapping];
    float numberLines = size2.height/heightOneLine;
    float rounded_up_numberLines = ceilf(numberLines * 100) / 100;
    
    return rounded_up_numberLines;
}

-(CGFloat)weightLastLetters
{
    UIFont *textFont = [ UIFont fontWithName:@"Helvetica-Light" size:k_Text_Label_Font_Size ];
    UILabel *textLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(k_Text_Label_Offset_X,
                                                                      k_Text_Label_Offset_Y,
                                                                      k_Text_Label_Offset_W,
                                                                      k_Text_Label_Offset_H ) ];
    textLabel.font = textFont;
    textLabel.numberOfLines = 0;
    textLabel.opaque = NO;
    
    textLabel.text = @"Hello World!";
    [ textLabel sizeToFit ];
    CGSize size = [textLabel.text sizeWithFont:textFont
                             constrainedToSize:(CGSize){k_Text_Label_Offset_W, k_Text_Label_Offset_H}
                                 lineBreakMode:NSLineBreakByWordWrapping];
    float heightOneLine = size.height;
    
    textLabel.text = self.textPostMessage.text;
    [ textLabel sizeToFit ];
    
    int i;
    int line = 1;
    int from = 1;
    NSString *text;
    
    for ( i = 1; i <= [ textLabel.text length ]; i++)
    {
        text = [textLabel.text substringToIndex:i];
        
        CGSize size2 = [text sizeWithFont:textFont constrainedToSize:(CGSize){k_Text_Label_Offset_W, k_Text_Label_Offset_H} lineBreakMode:NSLineBreakByWordWrapping];
        float numberLines = size2.height/heightOneLine;
        float rounded_up_numberLines = ceilf(numberLines * 100) / 100;
        if ( rounded_up_numberLines > line )
        {
            line = line + 1;
            from = i;
        }
    }
    if ( line != 1)
    {
        int fromProverka = from - 8;
        
        textLabel.text = [ textLabel.text substringFromIndex:fromProverka ];
        CGSize sizeProverka = [textLabel.text sizeWithFont:textFont constrainedToSize:(CGSize){k_Text_Label_Offset_W, k_Text_Label_Offset_H} lineBreakMode:NSLineBreakByWordWrapping];;
        return sizeProverka.width;

        
//        if ( sizeProverka >=)
        
        textLabel.text = [ textLabel.text substringFromIndex:from-1 ];
        [ textLabel sizeToFit ];
    
        CGSize size2 = [textLabel.text sizeWithFont:textFont
                                  constrainedToSize:(CGSize){k_Text_Label_Offset_W, k_Text_Label_Offset_H}
                                      lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"== TEXT LABEL %@",textLabel.text);
        [ textLabel sizeToFit ];
        return size2.width;
    }
    else
        return 0.f;
}

-(CGSize)textSize
{
    UIFont *textFont = [ UIFont fontWithName:@"Helvetica-Light" size:k_Text_Label_Font_Size ];
    UILabel *textLabel = [ [ UILabel alloc ] initWithFrame:CGRectMake(k_Text_Label_Offset_X,
                                                                      k_Text_Label_Offset_Y,
                                                                      k_Text_Label_Offset_W,
                                                                      k_Text_Label_Offset_H ) ];
    textLabel.font = textFont;
    textLabel.numberOfLines = 0;
    textLabel.opaque = NO;
    textLabel.text = self.textPostMessage.text;
    [ textLabel sizeToFit ];

    CGSize size = [textLabel.text sizeWithFont:textFont
                             constrainedToSize:(CGSize){k_Text_Label_Offset_W, k_Text_Label_Offset_H}
                                 lineBreakMode:NSLineBreakByWordWrapping];
        return size;
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