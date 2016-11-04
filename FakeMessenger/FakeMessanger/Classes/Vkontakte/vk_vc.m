
//  vkontakteViewController.m
//  FakeMessanger
//
//  Created by developer on 8/30/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//
#import "menu_vc.h"

#import "vk_vc.h"
#import "AppDelegate.h"

#import "FM_StatusBarView.h"
#import "FM_TableView.h"
#import "FM_Toolbar.h"

#import "vk_settings_vc.h"
#import "vk_message_cell.h"
#import "DB_vk.h"

#import "UIImage+Filtrr.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>

#define k_Screen_W 320.f

#define k_Table_H_is_4_inch 465.f
#define k_Table_H_is_3_5_inch 377.f

#define k_Toolbar_H 44.f
#define k_Toolbar_Y_is_4_inch 460.f
#define k_Toolbar_Y_is_3_5_inch 372.f

#define k_PanelFake_H 40.f
#define k_PanelFake_Y_is_4_inch 528.f
#define k_PanelFake_Y_is_3_5_inch 440.f

#define k_Date_Offset 18.f

@implementation vk_vc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [ super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self )
    {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#pragma mark Setup View
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
//Background
    
    CGRect rect = [ [ UIScreen mainScreen ] applicationFrame ];
    CGRect rect2 = rect;
    rect2.origin.y = rect2.origin.y -20;
    UIImageView *backgroundView = [ [ UIImageView alloc ] initWithFrame:rect2 ];
    backgroundView.image = [ UIImage imageNamed:@"vk_Background" ];
    [ self.view addSubview:backgroundView ];
 
#pragma mark Setup CoreData
    
    [ self sortDataBase ];

#pragma mark Setup TableView
    
    if (is_4_inch())
        self.tableView = [ [ UITableView alloc ] initWithFrame:CGRectMake(0, 0, k_Screen_W, k_Table_H_is_4_inch) style:UITableViewStylePlain ];
    else
        self.tableView = [ [ UITableView alloc ] initWithFrame:CGRectMake(0, 0, k_Screen_W, k_Table_H_is_3_5_inch) style:UITableViewStylePlain ];
    
    self.tableView.backgroundColor = [ UIColor clearColor ];
//    self.tableView.backgroundColor = [ UIColor whiteColor ];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [ self.view addSubview:self.tableView ];

#pragma mark Setup TabBar
    
    [ self.navigationController.navigationBar setBackgroundImage:[ UIImage imageNamed:@"vk_tb_TapBarBackgound"] forBarMetrics:UIBarMetricsDefault ];
    
//Title
//Enter name button
    
    self.buttonName = [ [ UIButton alloc ] initWithFrame:CGRectMake(0.f, 20.f, 220.f, 40.f) ];
    self.buttonName.backgroundColor = [ UIColor clearColor ];
    [ self.buttonName addTarget:self action:@selector(addName:) forControlEvents:UIControlEventTouchUpInside ];

//Recipient name
    
    self.nameUser = [ [ UILabel alloc ] initWithFrame:CGRectMake(- 6.9f, 2.f, 182.f, 20.f) ];
    self.nameUser.text = @"Введите имя";
    self.nameUser.textColor = [ UIColor whiteColor ];
    self.nameUser.shadowOffset = CGSizeMake(0,-1);
    self.nameUser.shadowColor = [ UIColor colorWithRed:0.28 green:0.36 blue:0.45 alpha:1.0 ];
    self.nameUser.backgroundColor = [ UIColor clearColor ];
    self.nameUser.font = [ UIFont fontWithName:@"HelveticaNeue-Bold" size:16 ];
    self.nameUser.textAlignment = NSTextAlignmentCenter;
    [ self.buttonName addSubview:self.nameUser ];
    
    self.recipientField = [ [ UITextField alloc ] init ];
    self.carrierField   = [ [ UITextField alloc ] init ];
    self.carrierField.text = @"Carrier";
    
    for( DB_vk *message in self.controller.fetchedObjects )
    {
        self.nameUser.text = message.s_recipient_name;
        self.carrierField.text = message.s_carrier_name;
        break;
    }
    [ self.controller performFetch:NULL ];
    
//Label online
    
    self.labelOnline = [ [ UILabel alloc ] initWithFrame:CGRectMake(0, 22.f, 171.f, 15.f) ];
    self.labelOnline.text = @"online";
    self.labelOnline.textColor = [ UIColor colorWithRed:0.79 green:0.83 blue:0.90 alpha:1.0 ];
    self.labelOnline.shadowOffset = CGSizeMake(0,-1);
    self.labelOnline.shadowColor = [ UIColor colorWithRed:0.28 green:0.36 blue:0.45 alpha:1.0 ];
    self.labelOnline.backgroundColor = [ UIColor clearColor ];
    self.labelOnline.font = [ UIFont fontWithName:@"HelveticaNeue" size:13 ];
    self.labelOnline.textAlignment = NSTextAlignmentCenter;
    [ self.buttonName addSubview:self.labelOnline ];
    
    self.navigationItem.titleView = self.buttonName;

//Left Button
    
    UIImage *backBtnImage = [ UIImage imageNamed:@"vk_tb_BackButton_RUS" ];
    UIView *containingView = [[UIView alloc] init ];
    
    if ( is_ios_7() )
        containingView.frame = CGRectMake(0, 0, backBtnImage.size.width - 10.f, backBtnImage.size.height);
    else
        containingView.frame = CGRectMake(0, 0, backBtnImage.size.width , backBtnImage.size.height);
    
    UIButton *backBtn = [ UIButton buttonWithType:UIButtonTypeCustom ];
    [ backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal ];
    [ backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside ];
    
    if ( is_ios_7() )
        backBtn.frame = CGRectMake(-10, 0, backBtnImage.size.width, backBtnImage.size.height);
    else
        backBtn.frame = CGRectMake(0, 0, backBtnImage.size.width, backBtnImage.size.height);
    
    [containingView addSubview:backBtn];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:containingView] ;

    self.navigationItem.leftBarButtonItem = cancelButton;

//RightButton
    
    NSString *STR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/image.png"];
    UIImage *imageFromCaches = [UIImage imageWithContentsOfFile:STR];
    UIImage *avatarImage = [ UIImage imageNamed:@"FM_tb_DefaultAvatar" ];
    UIView *containingRightView = [[UIView alloc] init ];

    if ( is_ios_7() )
        containingRightView.frame = CGRectMake(0.f, 0.f, 35.f, 35.f);
    else
        containingRightView.frame = CGRectMake(0.f, 0.f, 35.f, 35.f);
    
    self.avatarButton = [ UIButton buttonWithType:UIButtonTypeCustom ];
    self.avatarButton.layer.cornerRadius = 5.f;
    self.avatarButton.layer.masksToBounds = YES;
    [ self.avatarButton addTarget:self action:@selector(addAvatar:) forControlEvents:UIControlEventTouchUpInside ];
    
    if ( imageFromCaches != nil )
        [ self.avatarButton setBackgroundImage:imageFromCaches forState:UIControlStateNormal ];
    else
        [ self.avatarButton setBackgroundImage:avatarImage forState:UIControlStateNormal ];
    
    for( DB_vk *message in self.controller.fetchedObjects )
    {
        if ( [ message.bool_anonym boolValue ] == YES )
            [ self bluredUserName ];
        else
            [ self normalUserName ];
        break;
    }

    if ( is_ios_7() )
        self.avatarButton.frame = CGRectMake(+10.f, 0.f, 35.f, 35.f);
    else
        self.avatarButton.frame = CGRectMake(0.f, 0.f, 35.f, 35.f);
    
    [containingRightView addSubview:self.avatarButton];
    
    UIBarButtonItem *avatarBarButton = [[UIBarButtonItem alloc] initWithCustomView:containingRightView] ;
    

    [ self.controller performFetch:NULL ];
    
    self.navigationItem.rightBarButtonItem = avatarBarButton;

#pragma mark Setup Toolbar
    
    if ( is_4_inch() )
        self.toolbar = [ [ FM_Toolbar alloc ] initWithFrame:CGRectMake(0, k_Toolbar_Y_is_4_inch , k_Screen_W, k_Toolbar_H) ];
    else
        self.toolbar = [ [ FM_Toolbar alloc ] initWithFrame:CGRectMake(0, k_Toolbar_Y_is_3_5_inch, k_Screen_W, k_Toolbar_H) ];

    [ self.toolbar.editButton    addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventTouchUpInside ];
    [ self.toolbar.carrierButton addTarget:self action:@selector(addCarrier:)  forControlEvents:UIControlEventTouchUpInside ];
    [ self.toolbar.modeButton    addTarget:self action:@selector(changeMode:)  forControlEvents:UIControlEventTouchUpInside ];
    self.toolbar.clear.action       = @selector(allowRemoveAll:);
    self.toolbar.screenShot.action  = @selector(makeScreenshot:);
    self.toolbar.addPost.action     = @selector(addPost:);
    
    [ self.view addSubview:self.toolbar ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [ self.navigationController.navigationBar setBackgroundImage:[ UIImage imageNamed:@"vk_tb_TapBarBackgound"] forBarMetrics:UIBarMetricsDefault ];

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
    DB_vk *message1 = [ self.controller objectAtIndexPath:indexPath ];
    if ( indexPath.row == 0)
    {
        offsetDate = k_Date_Offset;
    }
    else
    {
        NSIndexPath *indexPathBefore = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
        DB_vk *message2 = [ self.controller objectAtIndexPath:indexPathBefore ];
        
        double timestamp = [ message1.d_timestamp doubleValue];
        NSTimeInterval interval = timestamp;
        NSDate *dateFromDB = [ NSDate dateWithTimeIntervalSince1970:interval ];
        NSDateFormatter *dateFormatter = [ [ NSDateFormatter alloc ] init ];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
        dateFormatter.locale = [ [ NSLocale alloc ] initWithLocaleIdentifier:@"ru_RU" ];
        
        double timestamp2 = [ message2.d_timestamp doubleValue];
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
        }
    }
        
    NSLog(@"CELL%d H === %f",indexPath.row,[ message1.f_cell_h floatValue ]);
    return [ message1.f_cell_h floatValue ] + offsetDate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellInt = @"CellIndentify";
    vk_message_cell *cell = [ tableView dequeueReusableCellWithIdentifier:CellInt ];
    
    if( cell == nil )
    {
        cell = [ [ vk_message_cell alloc ] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellInt ];
    }
    
    if ( indexPath.row == 0)
    {
        DB_vk *message = [ self.controller objectAtIndexPath:indexPath ];
        [ cell setupMessage:message mesageBefore:nil ];
    }
    else
    {
        NSLog(@"%ld",(long)indexPath.row);
        NSIndexPath *indexPathBefore = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
        DB_vk *message1 = [ self.controller objectAtIndexPath:indexPath ];
        DB_vk *message2 = [ self.controller objectAtIndexPath:indexPathBefore ];
        [ cell setupMessage:message1 mesageBefore:message2 ];
    }
    return cell;
}

#pragma mark  Edit cell

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DB_vk *message = self.controller.fetchedObjects[ indexPath.row ];
    NSManagedObjectContext *context = message.managedObjectContext;
    [ context deleteObject:message ];
    [self.tableView reloadData];
}

#pragma mark  Move cell 

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.editing;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    DB_vk *message1 = self.controller.fetchedObjects[  sourceIndexPath.row ];
    DB_vk *message2 = self.controller.fetchedObjects[ destinationIndexPath.row ];
    
    NSNumber *number1 =  message1.d_timestamp;
    NSNumber *number2 =  message2.d_timestamp;

    message1.d_timestamp = number2;
    message2.d_timestamp = number1;
}

#pragma mark - Alert -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DB_vk *message = self.controller.fetchedObjects[ indexPath.row ];
    vk_settings_vc  *newViewPostMessage = [[ vk_settings_vc alloc ] initWithInfoMessage:message
                                                                       andRecipientName:self.nameUser.text
                                                                         andCarrierName:self.carrierField.text ];
    [self.navigationController pushViewController:newViewPostMessage animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag > 999 )
    {

#pragma mark Name User
        
        if ( alertView.tag == 1000 )
        {
            if ( buttonIndex == 0 )
            {
                return;
            }
            if ( buttonIndex == 1 )
            {
                if( [ self.recipientField.text isEqualToString:@"" ] )
                {
                    return;
                }
                else
                {
                    self.nameUser.text = self.recipientField.text;
//Add to CoreData
                    for(DB_vk *item in self.controller.fetchedObjects)
                    {
                        item.s_recipient_name = self.recipientField.text;
                    }
                    [ self.controller performFetch:NULL ];
                    [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
                    
                    for( DB_vk *message in self.controller.fetchedObjects )
                    {
                        if ( [ message.bool_anonym boolValue ] == YES )
                            [ self bluredUserName ];
                        else
                            [ self normalUserName ];
                        break;
                    }
                    [ self.controller performFetch:NULL ];
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
                    for(DB_vk *item in self.controller.fetchedObjects)
                    {
                        item.s_carrier_name = self.carrierField.text;
                    }
                    
                    [ self.controller performFetch:NULL ];
                    [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
                }
            }
        }

#pragma mark Clear DB
        
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
#pragma mark Back button

-(void)goback:(id)notused {
    [ self.navigationController popViewControllerAnimated:YES ];
}

#pragma mark Title

-(void)addName:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:@"Введите имя"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Отмена"
                                                   otherButtonTitles:@"Ввод", nil ];
    addNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    addNameAlert.tag = 1000;
    
    self.recipientField.tag = 101;
    self.recipientField = [ addNameAlert textFieldAtIndex:0 ];
    [self.recipientField setDelegate:self ];
    
    for(DB_vk *item in self.controller.fetchedObjects)
    {
        self.recipientField.text = item.s_recipient_name;
        break;
    }
    [ self.controller performFetch:NULL ];
    
    [ addNameAlert show ];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [ self.recipientField.text length ] >= 25 && ![ string isEqualToString:@"" ] )
        
        return NO;
    else
        return YES;
}

#pragma mark Fhoto for avatar

- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    if ( ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO )
         || (delegate == nil)
         || (controller == nil) )
    {
        return NO;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    return YES;
}

//картинка береться с альбома
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

// // //
    UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame: CGRectMake( 0, 0, 35, 35 ) ];
    imageView.image = chosenImage;
    
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [ imageView.layer renderInContext:context ];
    UIImage *screnshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [ self.avatarButton setBackgroundImage:[ UIImage imageWithData:UIImagePNGRepresentation( screnshot ) ] forState:UIControlStateNormal ];
    
// // //

    NSString *STR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/image.png"];
    UIImage *im = [ UIImage imageWithData:UIImagePNGRepresentation( screnshot ) ];
    NSData *imagedata = UIImageJPEGRepresentation(im, 1.f);
    [imagedata writeToFile:STR atomically:YES];
    
    for( DB_vk *message in self.controller.fetchedObjects )
    {
        if ( [ message.bool_anonym boolValue ] == YES )
            [ self bluredUserName ];
        else
            [ self normalUserName ];
        break;
    }
    [ self.controller performFetch:NULL ];

// // //
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{

//Add Avatar
    
    if ( actionSheet.tag == 1000 )
    {
        if ( buttonIndex == 0 )
        {
            [ self startMediaBrowserFromViewController:self usingDelegate:self ];
        }
    }
    
//Blured Avatar
    
    if ( actionSheet.tag == 1001 )
    {
        if ( buttonIndex == 0 )
        {
            for(DB_vk *item in self.controller.fetchedObjects)
            {
                item.bool_anonym = [NSNumber numberWithBool:YES];
            }
            [ self.controller performFetch:NULL ];
            [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
            
            [ self bluredUserName ];
        }
        if ( buttonIndex == 1 )
        {
            for(DB_vk *item in self.controller.fetchedObjects)
            {
                item.bool_anonym = [NSNumber numberWithBool:NO];
            }
            [ self.controller performFetch:NULL ];
            [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
            
            [ self normalUserName ];
        }
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

//добавить аватар
-(void)addAvatar:(id)notused
{
    UIActionSheet *addAvatarActionSheet = [ [ UIActionSheet alloc ] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:@"Отмена"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"Добавить фотографию", nil ];
    addAvatarActionSheet.tag = 1000;
    addAvatarActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [addAvatarActionSheet showInView:self.view];
}

#pragma mark - Toolbar methods -

-(void)startEditing
{
    [ self.tableView setEditing:YES animated:YES ];
    
    UIImage *doneImage = [ UIImage imageNamed:is_ios_7()?@"FM_tbb_editDone_ios7":@"FM_tbb_editDone" ];
    UIView *doneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doneImage.size.width , doneImage.size.height) ];
 
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

-(void)stopEditing
{
    [ self.tableView setEditing:NO animated:YES ];
    
    UIImage *editImage = [ UIImage imageNamed:is_ios_7()?@"FM_tbb_edit_ios7":@"FM_tbb_edit" ];
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, editImage.size.width , editImage.size.height) ];
    
    UIButton *editButton     = [ UIButton buttonWithType:UIButtonTypeCustom ];
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
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:@"Введите название мобильного оператора"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Отмена"
                                                   otherButtonTitles:@"Ввод", nil ];
    addNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    addNameAlert.tag = 1010;
    
    self.carrierField = [ addNameAlert textFieldAtIndex:0 ];
    self.carrierField.tag = 02;
    [ self.carrierField setDelegate:self ];
    self.carrierField.text = @"Carrier";
    
    for(DB_vk *item in self.controller.fetchedObjects)
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
                                                                cancelButtonTitle:@"Отмена"
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:@"Анонимный режим",@"Обычный режим", nil ];
    addAvatarActionSheet.tag =1001;
    addAvatarActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [addAvatarActionSheet showInView:self.view];
}

-(void)normalUserName
{
    [ self.buttonName.subviews makeObjectsPerformSelector:(@selector(removeFromSuperview)) ];
    [ self.buttonName addSubview:self.nameUser ];
    [ self.buttonName addSubview:self.labelOnline ];
    
    NSString *STR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/image.png"];
    UIImage *imageFromCaches = [UIImage imageWithContentsOfFile:STR];
    UIImage *avatarImage = [ UIImage imageNamed:@"FM_tb_DefaultAvatar" ];
    
    if ( imageFromCaches != nil )
        [ self.avatarButton setBackgroundImage:imageFromCaches forState:UIControlStateNormal ];
    else
        [ self.avatarButton setBackgroundImage:avatarImage forState:UIControlStateNormal ];
}

-(void)bluredUserName
{
    [ self.buttonName.subviews makeObjectsPerformSelector:(@selector(removeFromSuperview)) ];
    
    //Blured Avatar
    
    NSString *STR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/image.png"];
    UIImage *imageFromCaches = [UIImage imageWithContentsOfFile:STR];
    UIImage *avatarImage = [ UIImage imageNamed:@"FM_tb_DefaultAvatar" ];
    UIImage *bluredImage = [ [ UIImage alloc ] init ];
    
    if ( imageFromCaches != nil )
        bluredImage = [ imageFromCaches imageWithGaussianBlur ];
    else
        bluredImage = [ avatarImage imageWithGaussianBlur ];
    for (int x = 0; x<5; ++x)
    {
        bluredImage = [ bluredImage imageWithGaussianBlur ];
    }
    
    [ self.avatarButton setBackgroundImage:bluredImage forState:UIControlStateNormal ];
    
    //Blured Recipient Name
    
    UIImage *bluredText = [ [ [ [ self makeImage:self.nameUser withSize:self.nameUser.frame.size ] imageWithGaussianBlur ] imageWithGaussianBlur ] imageWithGaussianBlur ];
    UIImageView *imageView = [ [ UIImageView alloc ] initWithFrame: CGRectMake( - 6.9f, 2, 182, 20 ) ];
    imageView.image = bluredText;
    
    [ self.buttonName addSubview:self.labelOnline ];
    [ self.buttonName  addSubview:imageView ];
}

#pragma mark Clear

- (void)allowRemoveAll:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:@"Вы уверены что хотите удалить все?"
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Отмена"
                                                   otherButtonTitles:@"Да", nil ];
    addNameAlert.tag = 1011;
    [ addNameAlert show ];
}

//очистить базу
- (void)clearDatabase
{
    [ self normalUserName ];
    self.recipientField.text = nil;
    self.carrierField.text = @"Carrier";
    self.nameUser.text = @"Введите имя";
    
//Clear Avatar Button
    
    [ self.avatarButton setBackgroundImage:[ UIImage imageNamed:@"FM_tb_DefaultAvatar"] forState:UIControlStateNormal ];
    
    NSString *STR = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/image.png"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [ fm removeItemAtPath:STR error:nil ];
    
//Clear CoreData
    
    for(DB_vk *item in self.controller.fetchedObjects)
    {
        NSManagedObjectContext *context = item.managedObjectContext;
        [ context deleteObject:item ];
        [ context save:NULL ];
    }
    [ self.controller performFetch:NULL ];
}

-(void)makeScreenshot:(id)sender
{
    UIImageView *panelFake = [ [ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"vk_FakePanel_RUS" ] ];
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
                                                                        typeSkin:@"vk"
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

-(void)addPost:(id)notused
{
    vk_settings_vc *newViewPostMessage = [ [ vk_settings_vc alloc ] initWithRecipientName:self.nameUser.text andCarrierName:self.carrierField.text ];
    [ self.navigationController pushViewController:newViewPostMessage animated:YES ];
}

#pragma mark - Default -

-(void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CoreData methods -

- (void)sortDataBase
{
    NSManagedObjectContext *context = ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext;
    NSFetchRequest *request = [ NSFetchRequest fetchRequestWithEntityName:@"DB_vk" ];
    request.fetchBatchSize = 10;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"d_timestamp" ascending:YES];
    NSArray *sortDescriptors = @[ sortDescriptor ];
    [ request setSortDescriptors:sortDescriptors ];
    request.predicate = [ NSPredicate predicateWithFormat:@"s_type_message == %@", @"VK" ];
    
    self.controller = [ [ NSFetchedResultsController alloc ] initWithFetchRequest:request
                                                             managedObjectContext:context
                                                               sectionNameKeyPath:nil
                                                                        cacheName:nil ];
    self.controller.delegate = self;
    [ self.controller performFetch:NULL ];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [ self.tableView reloadData ];
}
@end