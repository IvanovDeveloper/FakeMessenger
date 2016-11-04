//
//  iPhonePostMessage.m
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//


#import "i7_settings_vc.h"
#import "i7_vc.h"

#import "AppDelegate.h"
#import "NSDate-Utilities.h"
#import <QuartzCore/QuartzCore.h>

typedef enum
{
    bubble_Type_Text,
    bubble_Type_Image,
}BubbleType;

#define kScreenWidth   320.f

#define kTableHeight_Ios7_inch4    570.f
#define kTableHeight_Ios7_ne_inch4 480.f
#define kTableHeight_ne_Ios7_inch4    510.f
#define kTableHeight_ne_Ios7_ne_inch4 416.f

#define k_Time_Date_view_H   284.f
#define k_Time_Date_picker_H 216.f
#define kToolbarHeight 44.f

//Date

#define k_Date_Offset 38.f

//Text

#define k_Text_Label_Offset_X 0.f
#define k_Text_Label_OFFset_Y 3.f
#define k_Text_Label_Offset_W 210.f
#define k_Text_Label_Offset_H 900.f
#define k_Text_Label_Font_Size 17.1f

//Bubble

#define k_Bubble_Offset_Y 1.5f

#define k_Bubble_Type_Text_Offset_Output_X 41.f
#define k_Bubble_Type_Text_Offset_Input_X  11.f
#define k_Bubble_Type_Text_Offset_W 31.f
#define k_Bubble_Type_Text_Offset_H 15.f

#define k_Bubble_Type_Image_Offset_Output_X 0.f
#define k_Bubble_Type_Image_Offset_Output_Y 0.f
#define k_Bubble_Type_Image_Offset_Input_X  0.f
#define k_Bubble_Type_Image_Offset_Input_Y  0.f
#define k_Bubble_Type_Image_Offset_W 1.f
#define k_Bubble_Type_Image_Offset_H 2.f

//Cell

#define k_Cell_Offset 0.f

@interface i7_settings_vc () < UIAlertViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate >

@property (assign) BOOL ban;
@property (assign) BOOL messageCreatedEarly;
@property (assign) BOOL dateFromDataBase;
@property (assign) BOOL inputMassegeBool;
@property (assign) BOOL iMassegeBool;

@property (assign, nonatomic) BubbleType type;
@property (nonatomic, strong) UITableView *tableView;

//Date

@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) NSDate *changeDate;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) UIImage *imageFromData;
@property (nonatomic, strong) UITextView *textPostMessage;

@property (nonatomic, strong) DB_i7 *message;
@property (weak, nonatomic) NSString *recipientName;
@property (weak, nonatomic) NSString *carrierName;
@property (readonly, nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation i7_settings_vc

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
- (id)initWithInfoMessage:(DB_i7 *)infoMessage andRecipientName:(NSString *)recipientName andCarrierName:(NSString *)carrier
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
//
- (void)viewDidLoad
{
    [ super viewDidLoad ];
    
    self.title = is_RU_lang()?@"Настройки":@"Settings";
    self.view.backgroundColor = [ UIColor whiteColor ];
    [ self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault ];

    NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
    self.changeDate = [ NSDate date ];
    self.dateString = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:[ NSDate date ] ] ];
    
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
    self.tableView.backgroundColor = [ UIColor whiteColor ];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [ self.view addSubview:self.tableView ];
    
#pragma mark TextPostMessage
    
    if( is_4_inch() )
        self.textPostMessage = [ [ UITextView alloc ] initWithFrame:CGRectMake(10.f, 5.f, kScreenWidth - 50.f, 230.f) ];
    else
        self.textPostMessage = [ [ UITextView alloc ] initWithFrame:CGRectMake(10.f, 5.f, kScreenWidth - 50.f, 145.f) ];
    self.textPostMessage.tag = 1000;
    self.textPostMessage.delegate = self;
    self.textPostMessage.scrollEnabled = YES;
    self.textPostMessage.backgroundColor = [UIColor clearColor];
    self.textPostMessage.font = [ UIFont fontWithName:@"Helvetica" size:18.0f ];
    
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
    
        CGSize textSize = [ self calculationSizeText ];
        CGFloat cellHeight = [self calculationHeightCell ];
    
#pragma mark Add Добавление значений полей в базу
    
    if ( [ self.message.bool_message_created boolValue ] == NO )
    {
        _context = ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext;
        self.message = [ NSEntityDescription insertNewObjectForEntityForName:@"DB_i7" inManagedObjectContext:_context ];
    }
    
    self.message.bool_inputMassege    = [NSNumber numberWithBool:self.inputMassegeBool];
    self.message.bool_message_created = [NSNumber numberWithBool:YES];
    self.message.d_timestamp = [ NSNumber numberWithDouble:self.changeDate.timeIntervalSince1970 ];
    self.message.s_recipient_name =  self.recipientName;
    self.message.s_carrier_name   = self.carrierName;
    if ( self.imageFromData != nil )
    {
        self.message.data_image_original = [ self makeScreenshotFromViewOriginal ];
        self.message.data_image          = [ self makeScreenshotFromView ];
    }
    else
    {
        self.message.data_image_original = nil;
        self.message.data_image          = nil;
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
    
#pragma mark Add Bubble Size
    
//if_Text
    if ( ![ self isTextNil ] && self.imageFromData == nil )
    {
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Text ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
    }
//if_Image
    if ( self.imageFromData != nil )
    {
        CGRect bubbleRect = [ self calculationBubbleImageSize:bubble_Type_Image ];
        self.message.f_bubble_x = [ NSNumber numberWithFloat:bubbleRect.origin.x ];
        self.message.f_bubble_y = [ NSNumber numberWithFloat:bubbleRect.origin.y ];
        self.message.f_bubble_w = [ NSNumber numberWithFloat:bubbleRect.size.width ];
        self.message.f_bubble_h = [ NSNumber numberWithFloat:bubbleRect.size.height ];
    }
    
//save to Base
    
    [ _context save:NULL ];
}

#pragma mark - Table Methods -

//для какого ряда работает редактирование
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [ [ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        [ cell setSelectionStyle:UITableViewCellSelectionStyleNone ];
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
                    optionsSwitch.on = YES;
                else
                    optionsSwitch.on = NO;
            }
            [ optionsSwitch addTarget:self action:@selector(setOnInput:) forControlEvents:UIControlEventValueChanged ];
            break;
        }
        
#pragma mark cell 1

        case 1:
        {
            cell.textLabel.text = @"iMessage";
            cell.accessoryView = optionsSwitch;
            
            if( YES == [[NSUserDefaults standardUserDefaults ] boolForKey:@"i7_iMessage" ] )
            {
                self.iMassegeBool = 1;
                optionsSwitch.on = YES;
            }
            else
            {
                self.iMassegeBool = 0;
                optionsSwitch.on = NO;
            }
            [ optionsSwitch addTarget:self action:@selector(setOnIMessage:) forControlEvents:UIControlEventValueChanged ];
            break;
        }

#pragma mark cell 2
            
        case 2:
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
                    cell.textLabel.text = is_RU_lang()?[ NSString stringWithFormat:@"Дата : %@", self.dateString ]:[ NSString stringWithFormat:@"Date : %@", self.dateString ];
                else
                    cell.textLabel.text = is_RU_lang()?@"Дата :":@"Date :";
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0, 0.0, 44, 44);
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"FM_sett_Delete"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(refleshTime:)  forControlEvents:UIControlEventTouchUpInside];
            
            cell.accessoryView = button;
            break;
        }
            
#pragma mark cell 3
            
        case 3:
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
//нажатие ряда
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == 2 )
    {
        if ( self.ban == NO )
        {
            if ( self.dateView == nil )
            {
                if (is_4_inch())
                    self.dateView = [ [ UIView alloc ] initWithFrame:CGRectMake( 0, self.tableView.frame.size.height, kScreenWidth, k_Time_Date_view_H ) ];
                else
                    self.dateView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height, kScreenWidth, k_Time_Date_view_H)];
                
                self.dateView.backgroundColor = [ UIColor whiteColor ];
                [self.view addSubview:self.dateView];

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
    if ( indexPath.row == 3 )
    {
        [ self startMediaBrowserFromViewController:self usingDelegate:self ];
    }
}
#pragma mark -
#pragma mark setOn Switch methods
#pragma mark -

//Входящие
- (void)setOnInput:(UISwitch*)mySwitch {
    self.inputMassegeBool = mySwitch.on;
}

//Входящие
- (void)setOnIMessage:(UISwitch*)mySwitch {
    [[NSUserDefaults standardUserDefaults] setBool:mySwitch.on forKey:@"i7_iMessage" ];
    [[NSUserDefaults standardUserDefaults] synchronize ];
    self.iMassegeBool = mySwitch.on;
}

#pragma mark - Alert -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == 102 )
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
    if ( alertView.tag == 103 )
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
    addNameAlert.tag = 102;
    [ addNameAlert show ];
}

- (void)refleshImage:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы действительно хотите очистить поле?":@"Do you really want to clear the field"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"Ok" , nil ];
    addNameAlert.tag = 103;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imageFromData = nil;
    UIImage *originalImage;
    originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageFromData = [UIImage imageWithData:UIImagePNGRepresentation(originalImage)];
    
    [ self.navigationController dismissViewControllerAnimated:YES completion:^{[self.tableView reloadData];} ];
}

#pragma mark Crop

//-(UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage
//{
//
//    CGImageRef imageRef = maskImage.CGImage;
//    
//    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(imageRef),
//                                          CGImageGetHeight(imageRef),
//                                          CGImageGetBitsPerComponent(imageRef),
//                                          CGImageGetBitsPerPixel(imageRef),
//                                          CGImageGetBytesPerRow(imageRef),
//                                          CGImageGetDataProvider(imageRef), NULL, YES);
//    
//    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
//    return [UIImage imageWithCGImage:masked];
//}

- (UIImage*)image:(UIImage*)image withMask:(UIImage*)maskImage
{
    CGImageRef CGMask = maskImage.CGImage;
    CGImageRef maskScale = CGImageMaskCreate(CGImageGetWidth(CGMask),
                                        CGImageGetHeight(CGMask),
                                        CGImageGetBitsPerComponent(CGMask),
                                        CGImageGetBitsPerPixel(CGMask),
                                        CGImageGetBytesPerRow(CGMask),
                                        CGImageGetDataProvider(CGMask), nil, YES);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], maskScale);
//    CGImageRelease(mask);
    
    // Under iOS 7, UIImage with mask no longer applied mask when saving it.
    // We draw the image to context and obtain image from context to get the image applied mask
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 CGImageGetWidth(maskedImageRef),
                                                 CGImageGetHeight(maskedImageRef),
                                                 CGImageGetBitsPerComponent(maskedImageRef),
                                                 CGImageGetBytesPerRow(maskedImageRef),
                                                 CGImageGetColorSpace(maskedImageRef),
                                                 CGImageGetBitmapInfo(maskedImageRef));
    
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(maskedImageRef), CGImageGetHeight(maskedImageRef));
    CGContextDrawImage(context, imageRect, maskedImageRef);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *maskedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
//    UIImage *maskedImage = [UIImage imageWithCGImage:imageRef];
    

    
    return maskedImage;
}

-(NSData *)makeScreenshotFromView
{
    CGFloat maxW = 112.0f;
    CGFloat maxH = 106.0f;
    CGFloat minW = 30.0f;
    CGFloat minH = 26.0f;
    CGSize imageSize = [ self calculationSizeImageFromData ];
    
    //    if ( imageSize.width <=  minW || imageSize.height <=  minH )
    //    {
    //        CGRect Size = CGRectZero;
    //
    //        if ( imageSize.width <=  minW )
    //        {
    //            Size = CGRectMake(0, 0 , minW, maxH);
    //            imageSize.height = maxH;
    //        }
    //        if ( imageSize.height <=  minH )
    //            Size = CGRectMake(0, 0 , maxW, minH);
    //    }
    
    //PrepairScreenShot
    
    UIImage *small = [ [ UIImage alloc ] init ];
    small = nil;
    
    if ( imageSize.width <=  minW || imageSize.height <=  minH )
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageFromData];
        CGSize size2 = [ self.imageFromData size ];
        
        
        [ imageView setFrame:CGRectMake(0, 0, size2.width, size2.height)];
        [ [ self view ] addSubview:imageView ];
        
        CGRect rect2 = CGRectZero;
        
        if ( imageSize.width <=  minW )
        {
            rect2 = CGRectMake(0, 0 , minW, 90);
        }
        if ( imageSize.height <=  minH )
        {
            rect2 = CGRectMake(0, 0 , maxW, minH);
        }
        
        // Create bitmap image from original image data,
        // using rectangle to specify desired crop area
        CGImageRef imageRef = CGImageCreateWithImageInRect([self.imageFromData CGImage], rect2);
        UIImage *img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        NSLog(@"h renderImg == %f", size2.height );
        NSLog(@"h size2 == %f", size2.height );
        NSLog(@"h img == %f", img.size.height );
        
        //        self.imageFromData =  img;
        small =  img;
    }
    
    
    //ScreenShot
    
    UIImageView *screenshotView = [ [ UIImageView alloc ] initWithImage:self.imageFromData ];
    screenshotView.backgroundColor = [ UIColor whiteColor ];
    
    if ( imageSize.width <=  minW || imageSize.height <=  minH )
    {
        screenshotView.image = small;
        screenshotView.frame = CGRectMake( 0, 0, small.size.width, small.size.height );
        NSLog(@"W = %f H = %f",small.size.width, small.size.height);
    }
    else
    {
        screenshotView.frame = CGRectMake( 0, 0, imageSize.width, imageSize.height );
    }
    
    CGRect rect = CGRectMake( 0, 0, screenshotView.frame.size.width, screenshotView.frame.size.height );
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [ screenshotView.layer renderInContext:context ];
    
    UIImage *screnshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageFromData = screnshot;
    
    //Prepair
    
    UIImageView *viewForMask = [ [ UIImageView alloc ] init ];
    viewForMask.backgroundColor = [ UIColor whiteColor ];
    
    if ( self.inputMassegeBool == 0 )
        viewForMask.image = [[UIImage imageNamed:@"i_bm_BubbleMask2"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 19, 20, 22)];
    if ( self.inputMassegeBool == 1 )
        viewForMask.image = [[UIImage imageNamed:@"MMBubbleMaskFlip"]resizableImageWithCapInsets:UIEdgeInsetsMake(15, 19, 20, 22)];
    
    viewForMask.frame = CGRectMake(0, 0, screnshot.size.width/*imageSize.width*/, screnshot.size.height /*imageSize.height*/ );
    
    
    CGRect rectMask = CGRectMake( 0, 0, viewForMask.frame.size.width, viewForMask.frame.size.height );
    UIGraphicsBeginImageContextWithOptions(rectMask.size, NO, 1);
    CGContextRef contextRender = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(contextRender, kCGInterpolationHigh);
    [ viewForMask.layer renderInContext:UIGraphicsGetCurrentContext() ];
    UIImage *renderedMask = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//Render
    
    UIImage *renderImage = [[UIImage alloc]init];
    renderImage = [ self image:screnshot withMask:renderedMask ]; //[self cropImage:renderedMask takeMask:screnshot ];
    
//Take_Render_Image
    
    NSData *dataWithImage = [ [ NSData alloc ] init ];
    dataWithImage = UIImagePNGRepresentation( renderImage );
    
    return dataWithImage;
}

#pragma mark

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
    self.textPostMessage.textColor = [ UIColor blackColor ];
    
    if ( [ self isTextNil ] )
        self.textPostMessage.text = nil;
    
    [ UIView beginAnimations:nil context:NULL ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDuration:0.3 ];
    [ UIView setAnimationBeginsFromCurrentState:YES ];
    self.view.frame = CGRectMake(self.view.frame.origin.x,
    (is_ios_7()?(is_4_inch()?(self.view.frame.origin.y - 210):(self.view.frame.origin.y - 210)):
                (is_4_inch()?(self.view.frame.origin.y - 186.f):(self.view.frame.origin.y - 186.f))),
                              self.view.frame.size.width, self.view.frame.size.height);
    [ UIView commitAnimations ];
}
//нажал ретурн
- (void)textViewDidEndEditing:(UITextView*)textPostMessage
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
}

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

//Расчет размеров картинки
-(CGSize)calculationSizeImageFromData
{
    CGSize imageSize = CGSizeZero;
    CGFloat wightOfImage = 0.f;
    CGFloat hightOfImage = 0.f;
    CGFloat maxW = 112.0f;
    CGFloat maxH = 106.0f;
    CGFloat minW = 30.0f;
    CGFloat minH = 26.0f;
    
    if ( ( self.imageFromData.size.width ) > maxW && ( self.imageFromData.size.height > maxH ))
    {
        if ( self.imageFromData.size.height == self.imageFromData.size.width )
        {
            wightOfImage = maxH;
            hightOfImage = maxH;
        }
        if ( self.imageFromData.size.height > self.imageFromData.size.width )
        {
            wightOfImage = (float)((maxH/(float)self.imageFromData.size.height) * (float)self.imageFromData.size.width);
            hightOfImage = maxH;
            
            if ( wightOfImage <  minW )
            {
                hightOfImage = (float)( ( minW/(float)wightOfImage ) * (float)hightOfImage );
                wightOfImage = minW;
            }
        }
        if ( self.imageFromData.size.height < self.imageFromData.size.width )
        {
            wightOfImage = maxW;
            hightOfImage = (float)( ( maxW/(float)self.imageFromData.size.width ) * (float)self.imageFromData.size.height );
            
            if ( hightOfImage <  minH )
            {
                wightOfImage = (float)( ( minH/(float)hightOfImage ) * (float)wightOfImage );
                hightOfImage = minH;
            }
        }
    }
    else
    {
        if ( self.imageFromData.size.width > maxW && self.imageFromData.size.height <= maxH )
        {
            hightOfImage = (float)((maxW/(float)self.imageFromData.size.width) * (float)self.imageFromData.size.height);
            wightOfImage = maxW;
            
            if ( hightOfImage <  minH )
            {
                wightOfImage = (float)( ( minH/(float)hightOfImage ) * (float)wightOfImage );
                hightOfImage = minH;
            }
        }
        if ( self.imageFromData.size.width <= maxW && self.imageFromData.size.height > maxH )
        {
            hightOfImage = maxH;
            wightOfImage = (float)((maxH/(float)self.imageFromData.size.height) * (float)self.imageFromData.size.width);
            
            if ( wightOfImage <  minW )
            {
                hightOfImage = (float)( ( minW/(float)wightOfImage ) * (float)hightOfImage );
                wightOfImage = minW;
            }
        }
        if ( ( self.imageFromData.size.width <= maxW && self.imageFromData.size.height <= maxH )
            || ( self.imageFromData.size.height == self.imageFromData.size.width ))
        {
            wightOfImage = self.imageFromData.size.width;
            hightOfImage = self.imageFromData.size.height;
            
            if ( wightOfImage <  minW )
            {
                hightOfImage = (float)( ( minW/(float)wightOfImage ) * (float)hightOfImage );
                wightOfImage = minW;
            }
            if ( hightOfImage <  minH )
            {
                wightOfImage = (float)( ( minH/(float)hightOfImage ) * (float)wightOfImage );
                hightOfImage = minH;
            }
        }
    }
    
    imageSize.width = wightOfImage;//wightOfImage;
    imageSize.height = hightOfImage;

    if ( imageSize.width <=  minW || imageSize.height <=  minH )
    {
        CGRect Size = CGRectZero;
        
        if ( imageSize.width <=  minW )
        {
            Size = CGRectMake(0, 0 , minW, maxH);
            imageSize.height = maxH;
        }
        if ( imageSize.height <=  minH )
            Size = CGRectMake(0, 0 , maxW, minH);
    }
    
    return imageSize;
}

-(CGSize)calculationSizeText
{
    CGSize textSize = CGSizeZero;
    
    UILabel *textLabel = [ [ UILabel alloc ] init ];
    textLabel.font = [ UIFont fontWithName:@"HelveticaNeue" size:k_Text_Label_Font_Size ];
    textLabel.numberOfLines = 0;
    textLabel.opaque = YES;
    textLabel.text = self.textPostMessage.text;
    textLabel.frame = CGRectMake(k_Text_Label_Offset_X,
                                 k_Text_Label_OFFset_Y,
                                 k_Text_Label_Offset_W,
                                 k_Text_Label_Offset_H );
    [ textLabel sizeToFit ];
    if( textLabel.frame.size.width <= 16 )
        textLabel.frame = CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y, 16.f, textLabel.frame.size.height );
    
    textSize.width  = textLabel.frame.size.width;
    textSize.height = textLabel.frame.size.height;

    return textSize;
}

-(CGFloat)calculationHeightCell
{
    int offsetDate = 0;
//    float imageOffset = 0.f;
    CGRect bubbleRect = CGRectZero;
    
//if date
    
    if ( self.dateString !=nil )
    {
//        offsetDate = k_Date_Offset;
    }
    
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

//вычисление размеров bubble
-(CGRect)calculationBubbleImageSize:(BubbleType)type
{
    self.type = type;
    CGRect bubbleImageSize = CGRectZero;
//    int offset = 0;
    
    if ( self.dateString != nil )
    {
//        offset = k_Date_Offset;
    }
    switch (self.type)
    {
            
//if_Text
            
        case bubble_Type_Text:
        {
            CGSize textSize = [ self calculationSizeText ];
            
            if ( self.inputMassegeBool == 0 )
            {
                bubbleImageSize = CGRectMake(kScreenWidth - (textSize.width + k_Bubble_Type_Text_Offset_Output_X),
                                            k_Bubble_Offset_Y,
                                            (textSize.width  + k_Bubble_Type_Text_Offset_W),
                                            (textSize.height + k_Bubble_Type_Text_Offset_H) );
            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake(k_Bubble_Type_Text_Offset_Input_X,
                                            k_Bubble_Offset_Y,
                                            (textSize.width  + k_Bubble_Type_Text_Offset_W),
                                            (textSize.height + k_Bubble_Type_Text_Offset_H) );
            }
            break;
        }
            
//if_Image
            
        case bubble_Type_Image:
        {
            CGSize imageSize = [ self calculationSizeImageFromData ];
            
            if ( self.inputMassegeBool == 0 )
            {
                bubbleImageSize = CGRectMake(kScreenWidth - (imageSize.width + k_Bubble_Type_Image_Offset_Output_X),
                                             k_Bubble_Offset_Y,
                                            (imageSize.width  + k_Bubble_Type_Image_Offset_W ),
                                            (imageSize.height + k_Bubble_Type_Image_Offset_H ) );
            }
            if ( self.inputMassegeBool == 1 )
            {
                bubbleImageSize = CGRectMake(k_Bubble_Type_Image_Offset_Input_X,
                                             k_Bubble_Offset_Y,
                                            (imageSize.width  + k_Bubble_Type_Image_Offset_W ),
                                            (imageSize.height + k_Bubble_Type_Image_Offset_H ) );
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

-(void)dealloc{
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end