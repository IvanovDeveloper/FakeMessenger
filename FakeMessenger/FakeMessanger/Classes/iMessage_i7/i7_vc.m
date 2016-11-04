//
//  iPhoneViewController.m
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//

#import "i7_vc.h"
#import "AppDelegate.h"

#import "FM_StatusBarView.h"
#import "FM_Toolbar.h"

#import "i7_settings_vc.h"
#import "i7_message_cell.h"
#import "DB_i7.h"

#import "UIImage+Filtrr.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>

#define k_Screen_W 320.f

#define k_Table_H_is_4_inch   460.f
#define k_Table_H_is_3_5_inch 372.f

#define k_Toolbar_H 44.f
#define k_Toolbar_Y_is_4_inch   460.f
#define k_Toolbar_Y_is_3_5_inch 372.f

#define k_PanelFake_H 43.f
#define k_PanelFake_Y_is_4_inch 525.f
#define k_PanelFake_Y_is_3_5_inch 437.f

#define k_Date_Offset 38.f


@interface i7_vc () < UIAlertViewDelegate, NSFetchedResultsControllerDelegate,
                      UIActionSheetDelegate, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate, UITextFieldDelegate >

@property (strong, nonatomic) UITableView *tableView;

// TabBar
///Tittle

@property (strong, nonatomic) UITextField *recipientField;
@property (strong, nonatomic) UILabel *nameUser;
@property (nonatomic, strong) UIButton *buttonName;

// ToolBar //

@property (strong, nonatomic) FM_Toolbar *toolbar;
@property (strong, nonatomic) UITextField *carrierField;

// CoreData //
@property (strong, nonatomic) NSFetchedResultsController *controller;

@end

@implementation i7_vc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#pragma mark Setup View
    
    [ [ UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleDefault ];
    
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:@"i7_iMessage"])
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"i7_iMessage" ];
    
#pragma mark CoreData Time
   
    [ self sortDataBase ];
    
#pragma mark Таблица и ее настройки
    
    if (is_4_inch())
        self.tableView = [ [ UITableView alloc ] initWithFrame:CGRectMake(0, 0, k_Screen_W, k_Table_H_is_4_inch) style:UITableViewStylePlain ];
    else
        self.tableView = [ [ UITableView alloc ] initWithFrame:CGRectMake(0, 0, k_Screen_W, k_Table_H_is_3_5_inch) style:UITableViewStylePlain ];

    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [ UIColor clearColor ];
    self.tableView.backgroundColor = [ UIColor whiteColor ];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//
    self.view.backgroundColor = [ UIColor whiteColor ];
    [ self.view addSubview:self.tableView ];
    
#pragma mark Setup TabBar
    
    [ self.navigationController.navigationBar setBackgroundImage:[ UIImage imageNamed:is_RU_lang()?@"i7_tb_TapBarBackgound_RUS":@"i7_tb_TapBarBackgound_ENG"] forBarMetrics:UIBarMetricsDefault ];
    
// Title
//Enter name button
    
    self.buttonName = [ [ UIButton alloc ] initWithFrame:CGRectMake(0.f, 20.f, 220.f, 44.f) ];
    self.buttonName.backgroundColor = [ UIColor clearColor ];
    [ self.buttonName addTarget:self action:@selector(addName:) forControlEvents:UIControlEventTouchUpInside ];
    
//Recipient name
    
    self.recipientField = [ [ UITextField alloc ] init ];
    self.carrierField   = [ [ UITextField alloc ] init ];
    self.carrierField.text = @"Carrier";
    
    self.nameUser = [ [ UILabel alloc ] init ];
    self.nameUser.text = is_RU_lang()?@"Введите имя":@"Enter name";
    self.nameUser.font = is_ios_7()?[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]:[ UIFont fontWithName:@"Helvetica" size:16 ];
    self.nameUser.textAlignment = NSTextAlignmentCenter;
    self.nameUser.backgroundColor = [ UIColor clearColor ];
    self.nameUser.textColor = [ UIColor blackColor ];
    for( DB_i7 *item in self.controller.fetchedObjects )
    {
        self.nameUser.text = item.s_recipient_name;
        self.carrierField .text = item.s_carrier_name;
        break;
    }
    [ self.nameUser sizeToFit ];
    [ self userName ];
    
    [ self.buttonName addSubview:self.nameUser ];
    self.navigationItem.titleView = self.buttonName;

    for( DB_i7 *message in self.controller.fetchedObjects )
    {
        if ( [ message.bool_anonym boolValue ] == YES )
            [ self bluredUserName ];
        else
            [ self normalUserName ];
        break;
    }
    
// Left Button
    
    [ self leftBtn:self.nameUser.frame.size.width ];
    
#pragma mark Setup Toolbar
    
    self.toolbar = [ [ FM_Toolbar alloc ] initWithFrame:is_4_inch()?CGRectMake(0, k_Toolbar_Y_is_4_inch,   k_Screen_W, k_Toolbar_H):
                                                                    CGRectMake(0, k_Toolbar_Y_is_3_5_inch, k_Screen_W, k_Toolbar_H)];
    [ self.toolbar.editButton    addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventTouchUpInside ];
    [ self.toolbar.carrierButton addTarget:self action:@selector(addCarrier:)  forControlEvents:UIControlEventTouchUpInside ];
    [ self.toolbar.modeButton    addTarget:self action:@selector(changeMode:)  forControlEvents:UIControlEventTouchUpInside ];
    self.toolbar.clear.action      = @selector(allowRemoveAll:);
    self.toolbar.screenShot.action = @selector(makeScreenshot:);
    self.toolbar.addPost.action    = @selector(addPost:);
    
    [ self.view addSubview:self.toolbar ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ self.navigationController.navigationBar setBackgroundImage:[ UIImage imageNamed:is_RU_lang()?@"i7_tb_TapBarBackgound_RUS":@"i7_tb_TapBarBackgound_ENG"] forBarMetrics:UIBarMetricsDefault ];
    
    [ self.controller performFetch:NULL ];
    [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
}

#pragma mark - Table Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controller.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int offsetDate = 0;
    DB_i7 *message1 = [ self.controller objectAtIndexPath:indexPath ];
    
    if ( indexPath.row == 0)
    {
        offsetDate = k_Date_Offset;
    }
    else
    {
        NSIndexPath *indexPathBefore = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
        DB_i7 *message2 = [ self.controller objectAtIndexPath:indexPathBefore ];
        
        double timestamp1 = [ message1.d_timestamp doubleValue];
        double timestamp2 = [ message2.d_timestamp doubleValue];
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
            if( ( [ message1.bool_inputMassege boolValue ] == 0 && [ message2.bool_inputMassege boolValue ] == 1 )
             || ( [ message1.bool_inputMassege boolValue ] == 1 && [ message2.bool_inputMassege boolValue ] == 0 ) )
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
        }
    }
    
    NSLog(@"CELL%d H === %f",indexPath.row, ( [ message1.f_cell_h floatValue ] + offsetDate ));
    return [ message1.f_cell_h floatValue ] + offsetDate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIndentify = @"CellIndentify";
    i7_message_cell *cell = [ tableView dequeueReusableCellWithIdentifier:CellIndentify ];
    
    if( cell == nil )
        cell = [ [ i7_message_cell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentify ];
    
    if ( indexPath.row == 0 )
    {
        if ( self.controller.fetchedObjects.count != 1 )
        {
            NSIndexPath *indexPathAfter  = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
            DB_i7 *message1 = [ self.controller objectAtIndexPath:indexPath ];
            DB_i7 *message3 = [ self.controller objectAtIndexPath:indexPathAfter ];
            [ cell setupMessage:message1 mesageBefore:nil mesageAfter:message3 ];
        }
        else
        {
            DB_i7 *message1 = [ self.controller objectAtIndexPath:indexPath ];
            [ cell setupMessage:message1 mesageBefore:nil mesageAfter:nil ];
        }
    }
    else
    {
        if ( indexPath.row == ( self.controller.fetchedObjects.count - 1 ) )
        {
            NSIndexPath *indexPathBefore = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
            DB_i7 *message1 = [ self.controller objectAtIndexPath:indexPath ];
            DB_i7 *message2 = [ self.controller objectAtIndexPath:indexPathBefore ];
            [ cell setupMessage:message1 mesageBefore:message2 mesageAfter:nil ];
        }
        else
        {
            NSIndexPath *indexPathBefore = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
            NSIndexPath *indexPathAfter  = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
            DB_i7 *message1 = [ self.controller objectAtIndexPath:indexPath ];
            DB_i7 *message2 = [ self.controller objectAtIndexPath:indexPathBefore ];
            DB_i7 *message3 = [ self.controller objectAtIndexPath:indexPathAfter ];
            [ cell setupMessage:message1 mesageBefore:message2 mesageAfter:message3 ];
        }
    }
    
    return cell;
}

#pragma mark - Edit cell -

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DB_i7 *message1 = self.controller.fetchedObjects[ indexPath.row ];
    NSManagedObjectContext *context = message1.managedObjectContext;
    [ context deleteObject:message1 ];
}

#pragma mark - Move cell -

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.editing;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    DB_i7 *message1 = self.controller.fetchedObjects[ sourceIndexPath.row ];
    DB_i7 *message2 = self.controller.fetchedObjects[ destinationIndexPath.row ];
    NSNumber *number1 =  message1.d_timestamp;
    NSNumber *number2 =  message2.d_timestamp;
    message1.d_timestamp = number2;
    message2.d_timestamp = number1;
}


#pragma mark - Alert -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DB_i7 *message = self.controller.fetchedObjects[ indexPath.row ];
    i7_settings_vc  *newViewPostMessage = [ [ i7_settings_vc alloc ] initWithInfoMessage:message andRecipientName:self.nameUser.text andCarrierName:self.carrierField.text ];
    [self.navigationController pushViewController:newViewPostMessage animated:YES];
}
//когда уже была нажата кнопка на алерте
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag > 999 )
    {
        
#pragma mark Name User
        
        if ( alertView.tag == 1000 )
        {
            if ( buttonIndex == 0 )
                return;
            
            if ( buttonIndex == 1 )
            {
                if( [ self.recipientField.text isEqualToString:@"" ] )
                    return;
                else
                {
                    self.nameUser.text = self.recipientField.text;
                    [ self.nameUser sizeToFit ];
//Add to CoreData
                    for(DB_i7 *item in self.controller.fetchedObjects)
                    {
                        item.s_recipient_name = self.recipientField.text;
                    }
                    [ self.controller performFetch:NULL ];
                    [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
//Resize
                    
                    [ self userName ];
                    
//Left Btn
                   
                    [ self leftBtn:self.nameUser.frame.size.width ];
                    
//Blured
                    
                    for( DB_i7 *message in self.controller.fetchedObjects )
                    {
                        if ( [ message.bool_anonym boolValue ] == YES )
                            [ self bluredUserName ];
                        else
                            [ self normalUserName ];
                        break;
                    }
                }
            }
        }

#pragma mark Carrier
        
        if ( alertView.tag == 1010 )
        {
            if ( buttonIndex == 0 )
                return;

            if ( buttonIndex == 1 )
            {
                if( [ self.carrierField.text isEqualToString:@"" ] )
                    return;
                else
                {
//Add to CoreData
                    for(DB_i7 *item in self.controller.fetchedObjects)
                    {
                        item.s_carrier_name = self.carrierField.text;
                    }
                    
                    [ self.controller performFetch:NULL ];
                    [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
                }
            }
        }
        
        if ( alertView.tag == 1011 )
        {
            if ( buttonIndex == 0 )
                return;
            if ( buttonIndex == 1 )
                [ self clearDatabase ];
        }
    }
}



#pragma mark - TabBar methods -

-(void)leftBtn:(float)widthUserName
{
    if ( is_RU_lang()?( widthUserName <= 140.f ):( widthUserName <= 110.f ) )
    {
        UIImage *backBtnImage = [ UIImage imageNamed:is_RU_lang()?@"i7_tb_BackButton_RUS":@"i7_tb_BackButton_ENG" ];
        UIView *containingView = [[UIView alloc] initWithFrame:is_ios_7()?CGRectMake(0, 0, backBtnImage.size.width - 10.f, backBtnImage.size.height):
                                                                          CGRectMake(0, 0, backBtnImage.size.width , backBtnImage.size.height)];
        UIButton *backBtn = [ UIButton buttonWithType:UIButtonTypeCustom ];
        [ backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal ];
        [ backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside ];
        
        if ( is_ios_7() )
            backBtn.frame = CGRectMake(-9, 0, backBtnImage.size.width, backBtnImage.size.height);
        else
            backBtn.frame = CGRectMake(0, 0, backBtnImage.size.width, backBtnImage.size.height);
        
        [containingView addSubview:backBtn];
        UIBarButtonItem *cancelButton = [ [ UIBarButtonItem alloc ] initWithCustomView:containingView ] ;
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
    else
    {
        UIImage *backBtnImage = [ UIImage imageNamed:@"i7_tb_BackButton" ];
        UIView *containingView = [[UIView alloc] initWithFrame:is_ios_7()?CGRectMake(0, 0, backBtnImage.size.width - 10.f, backBtnImage.size.height):
                                                                          CGRectMake(0, 0, backBtnImage.size.width , backBtnImage.size.height)];
        UIButton *backBtn     = [ UIButton buttonWithType:UIButtonTypeCustom ];
        [ backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal ];
        [ backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside ];
        
        if ( is_ios_7() )
            backBtn.frame = CGRectMake(-9, 0, backBtnImage.size.width, backBtnImage.size.height);
        else
            backBtn.frame = CGRectMake(0, 0, backBtnImage.size.width, backBtnImage.size.height);
        
        [containingView addSubview:backBtn];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:containingView] ;
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

-(void)userName
{
    if ( is_RU_lang()?( self.nameUser.frame.size.width <= 140.f ):( self.nameUser.frame.size.width <= 110.f ) )
        self.nameUser.center = is_RU_lang()?CGPointMake(70, 22):CGPointMake(52, 22);
    else
    {
        if ( is_RU_lang()?( self.nameUser.frame.size.width <= 170.f ):( self.nameUser.frame.size.width <= 170.f ) )
            self.nameUser.center = is_RU_lang()?CGPointMake(70, 22):CGPointMake(80, 22);
        else
        {
            if ( is_RU_lang()?( self.nameUser.frame.size.width <= 200.f ):( self.nameUser.frame.size.width <= 200.f ) )
            {
                self.nameUser.textAlignment = NSTextAlignmentRight;
                self.nameUser.frame = is_RU_lang()?CGRectMake(-(self.nameUser.frame.size.width-160.f), 12.f, self.nameUser.frame.size.width, self.nameUser.frame.size.height):
                CGRectMake(-(self.nameUser.frame.size.width-165.f), 12.f, self.nameUser.frame.size.width, self.nameUser.frame.size.height);
            }
            else
            {
                self.nameUser.textAlignment = NSTextAlignmentRight;
                self.nameUser.frame = is_RU_lang()?CGRectMake(-45.f, 12.f, 200, self.nameUser.frame.size.height):
                CGRectMake(-40.f, 12.f, 200.f, self.nameUser.frame.size.height);
            }
        }
    }
}


-(void)goback:(id)notused {
    [ self.navigationController popViewControllerAnimated:YES ];
}

-(void)addName:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Введите имя":@"Enter name"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Ввод":@"OK", nil ];
    addNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    addNameAlert.tag = 1000;
    
    self.recipientField.tag = 101;
    self.recipientField = [ addNameAlert textFieldAtIndex:0 ];
    [ self.recipientField setDelegate:self ] ;
    
    for(DB_i7 *item in self.controller.fetchedObjects)
    {
        self.recipientField.text = item.s_recipient_name;
        break;
    }
    [ self.controller performFetch:NULL ];
    
    [addNameAlert show];
}
//max length recipientName
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [ self.recipientField.text length ] >= 30 && ![ string isEqualToString:@"" ] )
        return NO;
    else
        return YES;
}

#pragma mark Mode

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 )
    {
        for(DB_i7 *item in self.controller.fetchedObjects)
        {
            item.bool_anonym = [NSNumber numberWithBool:YES];
        }
        [ self.controller performFetch:NULL ];
        
        [ self bluredUserName ];
    }
    if ( buttonIndex == 1 )
    {
        for(DB_i7 *item in self.controller.fetchedObjects)
        {
            item.bool_anonym = [NSNumber numberWithBool:NO];
        }
        [ self.controller performFetch:NULL ];
        
        [ self normalUserName ];
    }
}

- (UIImage *)makeImage:(UIView *)v withSize:(CGSize)imgSize
{
    UIGraphicsBeginImageContext(imgSize);
    [ v.layer renderInContext:UIGraphicsGetCurrentContext() ];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - Toolbar methods -
#pragma mark Edit

//включить режим редактирования
-(void)startEditing
{
    [ self.tableView setEditing:YES animated:YES ];
    
    UIImage *doneImage   = [ UIImage imageNamed:is_ios_7()?@"FM_tbb_editDone_ios7":@"FM_tbb_editDone" ];
    UIView  *doneView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doneImage.size.width , doneImage.size.height) ];
    UIButton *doneButton = [ UIButton buttonWithType:UIButtonTypeCustom ];
    doneButton.frame = CGRectMake(0, 0, doneImage.size.width, doneImage.size.height);
    [ doneButton setBackgroundImage:doneImage forState:UIControlStateNormal ];
    [ doneButton addTarget:self action:@selector(stopEditing) forControlEvents:UIControlEventTouchUpInside ];
    
    [doneView addSubview:doneButton];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithCustomView:doneView];
    
    [ self.toolbar.toolbarButtons removeObjectAtIndex:0 ];
    [ self.toolbar.toolbarButtons insertObject:done atIndex:0 ];
    [ self.toolbar setItems:self.toolbar.toolbarButtons ];
}

//выключить режим редактирования
-(void)stopEditing
{
    [ self.tableView setEditing:NO animated:YES ];
    
    UIImage *editImage   = [ UIImage imageNamed:is_ios_7()?@"FM_tbb_edit_ios7":@"FM_tbb_edit" ];
    UIView  *editView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, editImage.size.width , editImage.size.height) ];
    UIButton *editButton = [ UIButton buttonWithType:UIButtonTypeCustom ];
    editButton.frame = CGRectMake(0, 0, editImage.size.width, editImage.size.height);
    [ editButton setBackgroundImage:editImage forState:UIControlStateNormal ];
    [ editButton addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventTouchUpInside ];
    
    [editView addSubview:editButton];
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editView];
    
    [ self.toolbar.toolbarButtons removeObjectAtIndex:0 ];
    [ self.toolbar.toolbarButtons insertObject:editBarButton atIndex:0 ];
    [ self.toolbar setItems:self.toolbar.toolbarButtons ];
}

#pragma mark Carrier

- (void)addCarrier:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Введите название мобильного оператора":@"Enter carrier"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Ввод":@"OK", nil ];
    addNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    addNameAlert.tag = 1010;
    
    [ self.carrierField setDelegate:self ];
    self.carrierField = [ addNameAlert textFieldAtIndex:0 ];
    self.carrierField.tag = 02;
    self.carrierField.text = @"Carrier";
    
    for(DB_i7 *item in self.controller.fetchedObjects)
    {
        if ( item.s_carrier_name == nil )
            self.carrierField.text = @"Carrier";
        else
            self.carrierField.text = item.s_carrier_name;
        break;
    }
    [ self.controller performFetch:NULL ];
    
    [ addNameAlert show ];
}

#pragma mark Mode

-(void)changeMode:(id)notused
{
    UIActionSheet *addAvatarActionSheet = [ [ UIActionSheet alloc ] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:is_RU_lang()?@"Анонимный режим":@"Anonymous mode" ,
                                                                                  is_RU_lang()?@"Обычный режим":@"Normal Mode", nil ];
    addAvatarActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [addAvatarActionSheet showInView:self.view];
}

-(void)normalUserName
{
    [ self.buttonName.subviews makeObjectsPerformSelector:(@selector(removeFromSuperview)) ];
    [ self.buttonName addSubview:self.nameUser ];
}

-(void)bluredUserName
{
    [ self.buttonName.subviews makeObjectsPerformSelector:(@selector(removeFromSuperview)) ];
    
    UIImage *bluredText = [ [ [ [ self makeImage:self.nameUser withSize:self.nameUser.frame.size ] imageWithGaussianBlur ] imageWithGaussianBlur ] imageWithGaussianBlur ];
    UIImageView *imageView = [ [ UIImageView alloc ] initWithImage:bluredText ];
    if ( is_RU_lang()?( self.nameUser.frame.size.width <= 140.f ):( self.nameUser.frame.size.width <= 110.f ) )
        imageView.center = is_RU_lang()?CGPointMake(70, 22):CGPointMake(52, 22);
    else
    {
        if ( is_RU_lang()?( self.nameUser.frame.size.width <= 170.f ):( self.nameUser.frame.size.width <= 170.f ) )
            imageView.center = is_RU_lang()?CGPointMake(70, 22):CGPointMake(80, 22);
        else
        {
            if ( is_RU_lang()?( self.nameUser.frame.size.width <= 200.f ):( self.nameUser.frame.size.width <= 200.f ) )
            {
                imageView.frame = is_RU_lang()?CGRectMake(-(self.nameUser.frame.size.width-160.f), 12.f, self.nameUser.frame.size.width, self.nameUser.frame.size.height):
                CGRectMake(-(self.nameUser.frame.size.width-165.f), 12.f, self.nameUser.frame.size.width, self.nameUser.frame.size.height);
            }
            else
            {
                imageView.frame = is_RU_lang()?CGRectMake(-45.f, 12.f, 200, self.nameUser.frame.size.height):
                CGRectMake(-40.f, 12.f, 200.f, self.nameUser.frame.size.height);
            }
        }
    }
    
    [self.buttonName  addSubview:imageView];
}

#pragma mark Clear DB

- (void)allowRemoveAll:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:is_RU_lang()?@"Вы уверены что хотите удалить все?":@"Are you sure you want to delete all?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:is_RU_lang()?@"Отмена":@"Cancel"
                                                   otherButtonTitles:is_RU_lang()?@"Да":@"OK", nil ];
    addNameAlert.tag = 1011;
    [ addNameAlert show ];
}

- (void)clearDatabase
{
    [ self.buttonName.subviews makeObjectsPerformSelector:(@selector(removeFromSuperview)) ];
    [ self.buttonName addSubview:self.nameUser ];
    
    self.recipientField.text = nil;
    self.carrierField.text = @"Carrier";
    self.nameUser.text = is_RU_lang()?@"Введите имя":@"Enter name";
    
    if( YES == [[NSUserDefaults standardUserDefaults ] boolForKey:@"i7_iMessage" ] )
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"i7_iMessage" ];
        [[NSUserDefaults standardUserDefaults] synchronize ];
    }
    
//Clear CoreData
    
    for( DB_i7 *item in self.controller.fetchedObjects )
    {
        NSManagedObjectContext *context = item.managedObjectContext;
        [ context deleteObject:item ];
        [ context save:NULL ];
    }
    [ self.controller performFetch:NULL ];
}
#pragma mark Screenshot

-(void)makeScreenshot:(id)sender
{
    UIImageView *panelFake = [ [ UIImageView alloc ] init ];
    
    if( NO == [[NSUserDefaults standardUserDefaults ] boolForKey:@"i7_iMessage" ] )
        panelFake.image = [ UIImage imageNamed:is_RU_lang()?@"i7_FakePanel_MSG_RUS":@"i7_FakePanel_MSG_ENG" ];
    else
        panelFake.image = [ UIImage imageNamed:is_RU_lang()?@"i7_FakePanel_iMSG_RUS":@"i7_FakePanel_iMSG_ENG" ];

    if ( is_4_inch() )
        panelFake.frame = CGRectMake(0, k_PanelFake_Y_is_4_inch,   k_Screen_W, k_PanelFake_H);
    else
        panelFake.frame = CGRectMake(0, k_PanelFake_Y_is_3_5_inch, k_Screen_W, k_PanelFake_H);
    self.toolbar.hidden = YES;
    
    [ self.navigationController.view addSubview:panelFake ];

    
    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *windowView = [ [ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, screenshot.size.width, screenshot.size.height)];
    windowView.image = screenshot;
    FM_StatusBarView *statusBarView = [ [ FM_StatusBarView alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f)
                                                                        typeSkin:@"i7"
                                                                     carrierName:self.carrierField.text ];
    [ windowView addSubview:statusBarView ];
    
    CGRect rect = CGRectMake( 0, 0, screenshot.size.width, screenshot.size.height );
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [ windowView.layer renderInContext:context ];
    UIImage *screenshot2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshot2, nil, nil, nil);
    
    self.toolbar.hidden = NO;
    [ panelFake removeFromSuperview ];
}

#pragma mark Add Post

-(void)addPost:(id)notused
{
    i7_settings_vc *newViewPostMessage = [ [ i7_settings_vc alloc ] initWithRecipientName:self.nameUser.text andCarrierName:self.carrierField.text ];
    [ self.navigationController pushViewController:newViewPostMessage animated:YES ];
}

#pragma mark - Default -

-(void)dealloc{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CoreData methods -

- (void)sortDataBase
{
    NSManagedObjectContext *context = ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext;
    NSFetchRequest *request = [ NSFetchRequest fetchRequestWithEntityName:@"DB_i7" ];
    request.fetchBatchSize = 10;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"d_timestamp" ascending:YES];
    NSArray *sortDescriptors = @[ sortDescriptor ];
    [ request setSortDescriptors:sortDescriptors ];
    request.predicate = [ NSPredicate predicateWithFormat:@"s_type_message == %@", @"i7" ];
    
    self.controller = [ [ NSFetchedResultsController alloc ] initWithFetchRequest:request
                                                             managedObjectContext:context
                                                               sectionNameKeyPath:nil
                                                                        cacheName:nil ];
    self.controller.delegate = self;
    [ self.controller performFetch:NULL ];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [ self.tableView reloadData ];
}
@end