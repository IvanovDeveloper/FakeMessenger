//
//  Header.h
//  FakeMessanger
//
//  Created by Developer on 4/1/14.
//  Copyright (c) 2014 Roga. All rights reserved.
//

/* Define Almanah
L_ - local define
k_ - global define
k_I - its image
k_T - its text
k_V - its diferent number value
k_F - its value for frame
k_F_S - its value for frame in ..._settings_vc
i7 - its ios7
i6 - its ios6
i4 - its inch 4
i3i5 - its inch 3.5
*/

#ifndef FakeMessanger_Header_h
#define FakeMessanger_Header_h

/* Text */

#define k_T_Ok @"OK"
#define k_T_Yes @"Yes"
#define k_T_Date @"Date"
#define k_T_Done @"Done"
#define k_T_Inbox @"Inbox"
#define k_T_Cancel @"Cancel"
#define k_T_Carrier @"Carrier"
#define k_T_iMessage @"iMessage"
#define k_T_Settings @"Settings"
#define k_T_EnterName @"Enter name"
#define k_T_NormalMode @"Normal Mode"
#define k_T_AnonymMode @"Anonymous mode"
#define k_T_EnterCarrier @"Enter carrier"
#define k_T_AreYouSureDel @"Are you sure you want to delete all?"

#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""
#define k_T_ @""

/* Image */

#define k_I_FM_tbb_edit     is_i7()?@"FM_tbb_edit_ios7":@"FM_tbb_edit"
#define k_I_FM_tbb_editDone is_i7()?@"FM_tbb_editDone_ios7":@"FM_tbb_editDone"

/* Frame Value */

#define k_F_Screen_W 320.f
#define k_F_Toolbar_H         44.f
#define k_F_Toolbar_Y_4inch   460.f
#define k_F_Toolbar_Y_3i5inch 372.f
#define k_F_Table_H_4inch   465.f
#define k_F_Table_H_3i5inch 377.f

#define k_F_S_Table_H_i7_i4      570.f
#define k_F_S_Table_H_i7_i3i5    480.f
#define k_F_S_Table_H_i6_4inch   510.f
#define k_F_S_Table_H_i6_3i5inch 416.f

/* Color */

#define k_Color_Background_View_i RGBa(219, 226, 237, 1)

/* Rect */

#define k_Rect_Table is_ios_7()?CGRectMake(0, 0, k_F_Screen_W, k_F_Table_H_4inch):CGRectMake(0, 0, k_F_Screen_W, k_F_Table_H_3i5inch)

#endif
