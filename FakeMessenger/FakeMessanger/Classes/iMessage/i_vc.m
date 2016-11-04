//
//  iPhoneViewController.m
//  FakeMessanger
//
//  Created by developer on 10/4/13.
//  Copyright (c) 2013 Roga. All rights reserved.
//
#warning Остановился на том что:
#warning Нужно протестировать размеры имени
#warning Решить проблему с падением при выходе в маин вью

#import "i_vc.h"
#import "i_settings_vc.h"
#import "i_message_cell.h"
#import "DB_i.h"

#define L_F_Table_H_4inch   465.f
#define L_F_Table_H_3i5inch 377.f
#define L_F_PanelFake_H         40.f
#define L_F_PanelFake_Y_4inch   528.f
#define L_F_PanelFake_Y_3i5inch 440.f

#define L_V_DateOffset 15.f

#define k_I_TapBackground @"i_tb_TapBarBackgound"
#define k_I_BackButton    is_RU()?@"i_tb_BackButton_RUS":@"i_tb_BackButton_ENG"
#define k_I_EditButton    is_RU()?@"i_tb_EditButton_RUS":@"i_tb_EditButton_ENG"
#define k_I_FakePanel     [[NSUserDefaults standardUserDefaults ] boolForKey:L_KEY ]?(is_RU_lang()?@"i_FakePanel_MSG_RUS":@"i_FakePanel_MSG_ENG"):(is_RU_lang()?@"i_FakePanel_iMSG_RUS":@"i_FakePanel_iMSG_ENG")

#define L_PREDICATE  @"i"
#define L_ENITY_NAME @"DB_i"
#define L_KEY        @"i_iMessage"

@interface i_vc () <UIAlertViewDelegate, NSFetchedResultsControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *nameUser;
@property (strong, nonatomic) UITextField *recipientField;
@property (strong, nonatomic) UITextField *carrierField;
@property (strong, nonatomic) UIButton *buttonName;
@property (strong, nonatomic) FM_Toolbar *toolbar;

@property (strong, nonatomic) NSFetchedResultsController *controller;

@end

@implementation i_vc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sortDataBase];
    [self defaultSettings];
    [self defaultSettingsUI];
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    if ( is_ios_7() )
        [ self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:k_I_TapBackground] forBarMetrics:UIBarMetricsDefault ];

//    [((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL];
}

-(void)defaultSettings
{
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:L_KEY])
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:L_KEY ];
}

-(void)deleteCell:(UISwipeGestureRecognizer*)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[sender locationInView:self.tableView]];
    DB_i *message = self.controller.fetchedObjects[indexPath.row];
    [((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext deleteObject:message];
    [((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL];
}

-(void)defaultSettingsUI
{
    self.view.backgroundColor = RGBa(219, 226, 237, 1);
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //TableView
    self.tableView = [[ UITableView alloc ] initWithFrame:is_i7()?CGRectMake(0, 0, k_F_Screen_W, L_F_Table_H_4inch)
                                                                 :CGRectMake(0, 0, k_F_Screen_W, L_F_Table_H_3i5inch) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [ UIColor clearColor ];
//    self.tableView.backgroundColor = [ UIColor whiteColor ];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.tableView addGestureRecognizer:swipe];
    
#pragma mark TabBar

    if ( is_ios_7() )
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:k_I_TapBackground] forBarMetrics:UIBarMetricsDefault];
    
    // Title
    //Enter name button
    self.buttonName = [[ UIButton alloc ] initWithFrame:CGRectMake(0.f, 20.f, 220.f, 40.f)];
    self.buttonName.backgroundColor = [UIColor clearColor];
    [self.buttonName addTarget:self action:@selector(addName:) forControlEvents:UIControlEventTouchUpInside];
    
    //Recipient name
    self.nameUser = [[ UILabel alloc ] initWithFrame:is_RU()?CGRectMake(-8.f, 8.f, 164.f, 25.f):CGRectMake(-10.f, 8.f, 169.f, 25.f)];
    self.nameUser.backgroundColor = [UIColor clearColor];
    self.nameUser.textColor = [UIColor whiteColor];
    self.nameUser.text = localize(k_T_EnterName);
    self.nameUser.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    self.nameUser.textAlignment = NSTextAlignmentCenter;
    self.nameUser.shadowOffset = CGSizeMake(0,-1);
    self.nameUser.shadowColor = [UIColor colorWithRed:0.28 green:0.36  blue:0.45 alpha:1.0];
    [self.buttonName addSubview:self.nameUser ];
    
    self.recipientField = [[ UITextField alloc ] init ];
    self.carrierField = [[ UITextField alloc ] init ];
    self.carrierField.text = k_T_Carrier;
    
    self.navigationItem.titleView = self.buttonName;
    
    // Left Button
    UIImage *backBtnImage = [UIImage imageNamed:k_I_BackButton];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = is_ios_7()?CGRectMake(-10, 0, backBtnImage.size.width, backBtnImage.size.height):CGRectMake(0, 0, backBtnImage.size.width, backBtnImage.size.height);
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containingView = [[UIView alloc] initWithFrame:is_ios_7()?CGRectMake(0, 0, backBtnImage.size.width - 10.f, backBtnImage.size.height)
                                                          :CGRectMake(0, 0, backBtnImage.size.width , backBtnImage.size.height) ];
    [containingView addSubview:backBtn];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithCustomView:containingView] ;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    //RightButton
    UIImage *rightBtnImage = [UIImage imageNamed:k_I_EditButton];
    UIImageView *rightBtn = [ [ UIImageView alloc ] initWithImage:rightBtnImage ];
    rightBtn.frame = is_ios_7()?CGRectMake(-10, 0, rightBtnImage.size.width, rightBtnImage.size.height):CGRectMake(0, 0, rightBtnImage.size.width, rightBtnImage.size.height);
    
//    [rightBtn setBackgroundImage:rightBtnImage forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightView = [[UIView alloc] initWithFrame:is_ios_7()?CGRectMake(0, 0, rightBtnImage.size.width - 20.f, rightBtnImage.size.height)
                                                     :CGRectMake(0, 0, rightBtnImage.size.width , rightBtnImage.size.height) ];
    [rightView addSubview:rightBtn];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightView] ;
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //Toolbar
    self.toolbar = [ [ FM_Toolbar alloc ] initWithFrame:is_4_inch()?CGRectMake(0, k_F_Toolbar_Y_4inch ,  k_F_Screen_W, k_F_Toolbar_H)
                                                                   :CGRectMake(0, k_F_Toolbar_Y_3i5inch, k_F_Screen_W, k_F_Toolbar_H) ];
    [self.toolbar.editButton    addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar.carrierButton addTarget:self action:@selector(addCarrier:)  forControlEvents:UIControlEventTouchUpInside];
    [self.toolbar.modeButton    addTarget:self action:@selector(changeMode:)  forControlEvents:UIControlEventTouchUpInside];
    self.toolbar.clear.action      = @selector(allowRemoveAll:);
    self.toolbar.screenShot.action = @selector(makeScreenshot:);
    self.toolbar.addPost.action    = @selector(addPost:);
    [self.view addSubview:self.toolbar];
}

-(void)updateUI
{
    if ( self.controller.fetchedObjects.count != 0 )
    {
        DB_i *message = [self.controller.fetchedObjects objectAtIndex:0];
        if ( message.s_recipient_name != nil )
            self.nameUser.text     = message.s_recipient_name;
        if ( message.s_carrier_name != nil )
            self.carrierField.text = message.s_carrier_name;
        if ( [message.bool_anonym boolValue] == YES )
            [self bluredUserName];
        else
            [self normalUserName];
    }
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.controller.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int offsetDate = 0;
    DB_i *message1 = [self.controller objectAtIndexPath:indexPath];
    if ( indexPath.row == 0)
    {
        offsetDate = L_V_DateOffset;
    }
    else
    {
        NSIndexPath *indexPathBefore = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
        DB_i *message2 = [ self.controller objectAtIndexPath:indexPathBefore ];
        
        NSDateFormatter *dateFormatter = [[ NSDateFormatter alloc ] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
        
        double timestamp1 = [message1.d_timestamp doubleValue];
        NSTimeInterval interval1 = timestamp1;
        NSDate *dateFromDB1 = [NSDate dateWithTimeIntervalSince1970:interval1];
        
        double timestamp2 = [message2.d_timestamp doubleValue];
        NSTimeInterval interval2 = timestamp2;
        NSDate *dateFromDB2 = [ NSDate dateWithTimeIntervalSince1970:interval2];
        
        NSString *now    = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB1 ] ];
        NSString *before = [ NSString stringWithFormat:@"%@",[ dateFormatter stringFromDate:dateFromDB2 ] ];
        
        if ( ![now isEqualToString:before] )
            offsetDate = L_V_DateOffset;
    }
//    NSLog(@"CELL%ld H === %f",(long)indexPath.row,[ message1.f_cell_h floatValue ]);
    return [message1.f_cell_h floatValue] + offsetDate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellInt = @"CellIndentify";
    i_message_cell *cell = [ tableView dequeueReusableCellWithIdentifier:CellInt ];
    
    if( cell == nil ) {
        cell = [[ i_message_cell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellInt];
    }
    
    if ( indexPath.row == 0)
    {
        DB_i *message = [ self.controller objectAtIndexPath:indexPath ];
        [cell setupMessage:message mesageBefore:nil];
    }
    else
    {
        NSIndexPath *indexPathBefore = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0];
        DB_i *message1 = [self.controller objectAtIndexPath:indexPath];
        DB_i *message2 = [self.controller objectAtIndexPath:indexPathBefore];
        [cell setupMessage:message1 mesageBefore:message2];
    }
    
    return cell;
}

#pragma mark Edit cell

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DB_i *message = self.controller.fetchedObjects[indexPath.row];
    [((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext deleteObject:message];
    [((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL];
}

#pragma mark Move cell

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.editing;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    DB_i *message1 = self.controller.fetchedObjects[sourceIndexPath.row];
    DB_i *message2 = self.controller.fetchedObjects[destinationIndexPath.row];
    
    NSNumber *number1 = message1.d_timestamp;
    NSNumber *number2 = message2.d_timestamp;
    
    message1.d_timestamp = number2;
    message2.d_timestamp = number1;
}


#pragma mark - Alert

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DB_i *message = self.controller.fetchedObjects[indexPath.row];
    i_settings_vc  *newViewPostMessage = [[ i_settings_vc alloc ] initWithInfoMessage:message
                                                                     andRecipientName:self.nameUser.text
                                                                       andCarrierName:self.carrierField.text];
    [self.navigationController pushViewController:newViewPostMessage animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag > 999 )
    {
        //UserName
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
                    for(DB_i *item in self.controller.fetchedObjects)
                    {
                        item.s_recipient_name = self.recipientField.text;
                    }
                    [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
                    [self updateUI];
                }
            }
        }
        //CarrierName
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
                    for(DB_i *item in self.controller.fetchedObjects)
                    {
                        item.s_carrier_name = self.carrierField.text;
                    }
                    [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
                    [self updateUI];
                }
            }
        }
        //Delete All
        if ( alertView.tag == 1011 )
        {
            if ( buttonIndex == 0 )
                return;
            if ( buttonIndex == 1 )
                [self clearDatabase];
        }
    }
}

#pragma mark - TabBar methods

-(void)goback:(id)notused {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addName:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:localize(k_T_EnterName)
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:localize(k_T_Cancel)
                                                   otherButtonTitles:localize(k_T_Ok), nil ];
    addNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    addNameAlert.tag = 1000;
    [addNameAlert show];
    
    self.recipientField.tag = 101;
    self.recipientField = [addNameAlert textFieldAtIndex:0];
    [self.recipientField setDelegate:self] ;
    
    if ( self.controller.fetchedObjects.count != 0 )
    {
        DB_i *message = [self.controller.fetchedObjects objectAtIndex:0];
        self.recipientField.text = message.s_recipient_name;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( [ self.recipientField.text length ] >= 25 && ![ string isEqualToString:@"" ] )
        return NO;
    else
        return YES;
}

#pragma mark Mode

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 0 )
    {
        for(DB_i *item in self.controller.fetchedObjects)
        {
            item.bool_anonym = [NSNumber numberWithBool:YES];
        }
        [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
        [self bluredUserName];
    }
    if ( buttonIndex == 1 )
    {
        for(DB_i *item in self.controller.fetchedObjects)
        {
            item.bool_anonym = [NSNumber numberWithBool:NO];
        }
        [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
        [self normalUserName];
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

#pragma mark - Toolbar methods
#pragma mark Edit

-(void)startEditing
{
    [self.tableView setEditing:YES animated:YES];
    
    UIImage *doneImage = [UIImage imageNamed:k_I_FM_tbb_editDone];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, doneImage.size.width, doneImage.size.height);
    [doneButton setBackgroundImage:doneImage forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(stopEditing) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *doneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doneImage.size.width , doneImage.size.height)];
    [doneView addSubview:doneButton];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithCustomView:doneView];
    
    [self.toolbar.toolbarButtons removeObjectAtIndex:0];
    [self.toolbar.toolbarButtons insertObject:done atIndex:0];
    [self.toolbar setItems:self.toolbar.toolbarButtons];
}

-(void)stopEditing
{
    [self.tableView setEditing:NO animated:YES];
    
    UIImage *editImage = [UIImage imageNamed:k_I_FM_tbb_edit];
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, editImage.size.width, editImage.size.height);
    [editButton setBackgroundImage:editImage forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(startEditing) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, editImage.size.width , editImage.size.height)];
    [editView addSubview:editButton];
    
    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editView];
    
    [self.toolbar.toolbarButtons removeObjectAtIndex:0];
    [self.toolbar.toolbarButtons insertObject:editBarButton atIndex:0];
    [self.toolbar setItems:self.toolbar.toolbarButtons];
}

#pragma mark Carrier

- (void)addCarrier:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:localize(k_T_EnterCarrier)
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:localize(k_T_Cancel)
                                                   otherButtonTitles:localize(k_T_Ok), nil ];
    addNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    addNameAlert.tag = 1010;
    [addNameAlert show];
    
    self.carrierField = [addNameAlert textFieldAtIndex:0];
    self.carrierField.tag = 02;
    self.carrierField.text = k_T_Carrier;
    [self.carrierField setDelegate:self];
   
    if ( self.controller.fetchedObjects.count != 0 )
    {
        DB_i *message = [self.controller.fetchedObjects objectAtIndex:0];
        if ( message.s_carrier_name != nil )
            self.carrierField.text = message.s_carrier_name;
    }
}

#pragma mark Mode

-(void)changeMode:(id)notused
{
    UIActionSheet *addAvatarActionSheet = [ [ UIActionSheet alloc ] initWithTitle:nil
                                                                         delegate:self
                                                                cancelButtonTitle:localize(k_T_Cancel)
                                                           destructiveButtonTitle:nil
                                                                otherButtonTitles:localize(k_T_AnonymMode),localize(k_T_NormalMode), nil ];
    addAvatarActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [addAvatarActionSheet showInView:self.view];
}

-(void)normalUserName
{
    [self.buttonName.subviews makeObjectsPerformSelector:(@selector(removeFromSuperview))];
    [self.buttonName addSubview:self.nameUser];
}

-(void)bluredUserName
{
    [ self.buttonName.subviews makeObjectsPerformSelector:(@selector(removeFromSuperview)) ];
    UIImage *bluredText = [ [ [ [ self makeImage:self.nameUser withSize:self.nameUser.frame.size ] imageWithGaussianBlur ] imageWithGaussianBlur ] imageWithGaussianBlur ];
    UIImageView *imageView = [ [ UIImageView alloc ] initWithImage:bluredText ];
    imageView.frame = is_ios_7()?CGRectMake( - 8.f, 8.f, is_RU_lang()?164.f:169.f, 25.f ):CGRectMake( - 8.f, 8.f, is_RU_lang()?164.f:169.f, 25.f );
    [self.buttonName  addSubview:imageView];
}

#pragma mark Clear DB

- (void)allowRemoveAll:(id)notused
{
    UIAlertView *addNameAlert = [ [ UIAlertView alloc] initWithTitle:localize(k_T_AreYouSureDel)
                                                             message:nil
                                                            delegate:self
                                                   cancelButtonTitle:localize(k_T_Cancel)
                                                   otherButtonTitles:localize(k_T_Yes), nil ];
    addNameAlert.tag = 1011;
    [addNameAlert show];
}

- (void)clearDatabase
{
    [self.buttonName.subviews makeObjectsPerformSelector:(@selector(removeFromSuperview))];
    [self.buttonName addSubview:self.nameUser];
    
    self.recipientField.text = nil;
    self.carrierField.text   = k_T_Carrier;
    self.nameUser.text       = localize(k_T_EnterName);
    
    //Clear CoreData
    for( DB_i *item in self.controller.fetchedObjects ) {
        NSManagedObjectContext *context = item.managedObjectContext;
        [ context deleteObject:item ];
    }
    [ ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext save:NULL ];
}

#pragma mark Screenshot

-(void)makeScreenshot:(id)sender
{
    self.toolbar.hidden = YES;
    UIImageView *panelFake = [[ UIImageView alloc ] initWithFrame:is_4_inch()?CGRectMake(0, L_F_PanelFake_Y_4inch,   k_F_Screen_W, L_F_PanelFake_H)
                                                                             :CGRectMake(0, L_F_PanelFake_Y_3i5inch, k_F_Screen_W, L_F_PanelFake_H)];
    panelFake.image = [UIImage imageNamed:k_I_FakePanel];
    [self.navigationController.view addSubview:panelFake];

    
    CALayer *layer = [[UIApplication sharedApplication] keyWindow].layer;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSString *carrierName = nil;
    if ( self.controller.fetchedObjects.count != 0 ) {
        DB_i *message = [self.controller.fetchedObjects objectAtIndex:0];
        if ( message.s_carrier_name != nil )
            carrierName = message.s_recipient_name;
        else
            carrierName = localize(k_T_Carrier);
    }
    
    UIImageView *windowView = [[ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, screenshot.size.width, screenshot.size.height)];
    windowView.image = screenshot;
    FM_StatusBarView *statusBarView = [[ FM_StatusBarView alloc ] initWithFrame:CGRectMake(0, 0, 320.f, 20.f)
                                                                       typeSkin:L_PREDICATE
                                                                    carrierName:carrierName];
    [windowView addSubview:statusBarView];
    
    CGRect rect = CGRectMake( 0, 0, screenshot.size.width, screenshot.size.height );
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [ windowView.layer renderInContext:context ];
    UIImage *screenshot2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshot2, nil, nil, nil);
    
    [panelFake removeFromSuperview];
    self.toolbar.hidden = NO;
}

#pragma mark Add Post

-(void)addPost:(id)notused
{
    i_settings_vc *newViewPostMessage = [[ i_settings_vc alloc ] initWithRecipientName:self.nameUser.text andCarrierName:self.carrierField.text];
    [self.navigationController pushViewController:newViewPostMessage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CoreData methods

- (void)sortDataBase
{
    NSManagedObjectContext *context = ((AppDelegate *)[ UIApplication sharedApplication ].delegate).managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:L_ENITY_NAME];
    request.fetchBatchSize = 10;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"d_timestamp" ascending:YES];
    NSArray *sortDescriptors = @[ sortDescriptor ];
    [request setSortDescriptors:sortDescriptors];
    request.predicate = [NSPredicate predicateWithFormat:@"s_type_message == %@", L_PREDICATE];
    
    self.controller = [ [ NSFetchedResultsController alloc ] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil ];
    self.controller.delegate = self;
    [self.controller performFetch:NULL];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [ self.tableView reloadData ];
}

@end