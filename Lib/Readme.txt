XPMenu for Delphi4/5/6

XPMenu for Delphi
Author: Khaled Shagrouni
URL: http://www.shagrouni.com/english/software/xpmenu.html
e-mail: shagrouni@hotmail.com
Version 2.1, Jan 10, 2002


XPMenu is a Delphi component to mimic Office XP menu and toolbar style.
Copyright (C) 2001, 2002 Khaled Shagrouni.

This component is FREEWARE with source code. I still hold the copyright, but
you can use it for whatever you like: freeware, shareware or commercial software.
If you have any ideas for improvement or bug reports, don't hesitate to e-mail
me <shagrouni@hotmail.com> (Please state the XPMenu version and OS information).



History:
========
Jan 10, 2002, V2.1
    - Adding support for SpeedButton, PageScroller, Panel and GroupBox.
    - Enhancing controls appearance.
    - Support for HotImages and DisabledImages for Toolbar, kindly added by
      Sylvain Ntumba <sylvain2@pinksoft.co.za>.
    - Many Bug fixes.
Dec 14, 2001, V2.0
    - Supporting new controls, thanks to Heath Provost <domains@planetsymphony.com>
      who made the basic code to subclass and paint combobox. The controls
      supported so far are: ComboBox, CustomEdit, CheckBox, RadioButton, Button,
      BitBtn and of course, Toolbar and Menu.
    - Disabled text in tool bar buttons is drawn correctly now.
    - xpMenu can detect menus and toolbars inside Frame
    - DimLevel and GrayLevel properties added to control the appearance of
      the bitmaps. (suggested by Warner <> and Enzo <postmaster@imazzo.com>)
    - Drawing bitmaps assigned to menu items is improved.
    - Fixing some problem caused by FlatMenu property .
    - Active property behavior is changed, to enforce the component to
      draw new added controls; it must be set to false first.
    - Fixing some drawing aspects.

Nov 2, 2001, V1.506
   - Changing the default color of menu bar.
   - Changing Form property type to TScrollingWinControl.
     (Suggested by Michael Martin, M.M.K@t-online.de)
Oct 7, 2001, V1.505
   - Supporting ControlBar. Added by Michiel van Oudheusden:
       michiel@iego-development.nl
Sept 5, 2001, V1.504
   - Removing some problematic code lines in the procedure: ToolBarDrawButton.
     This code causes unwanted effect on desktop when activating the component
     at run time with form contains a ToolBarButton with MenuItem.
Sept 4, 2001, V1.503
   - Bug fixed.
Sept 3, 2001, V1.502
   - Bugs fixed.
Sept 1, 2001, V1.501
   - Some minor changes and bugs fixed.
July 29, 2001, V1.501 (Beta)
   - Adding AutoDetect property.
   - Compatibility issues with Delphi4.
July 25, 2001, V1.5
   - Support for TToolbar.
   - Getting closer to XP style appearance.
   - New options.
June 23, 2001
   - Compatibility issues with Delphi4.
   - Changing the way of menus itration.
   - Making the blue select rectangle little thinner.

June 21, 2001
  Bug fixes:
   - Items correctly sized even if no image list assigned.
   - Shaded colors for top menu items if fixed for some menu bar colors.
  (Actually the bugs was due to two statements deleted by me stupidly/accidentally)

June 19, 2001
  This component is based on code which I have posted at Delphi3000.com
  (http://www.delphi3000/articles/article_2246.asp) and Borland Code-Central
  (http://codecentral.borland.com/codecentral/ccweb.exe/listing?id=16120).



Installation

A. Unzip the files: XPMENU.PAS and XPMENU.DCR Into the same directory.
B. From Delphi menu, Select File| New: Package.
C. Press Add, and browse to add the unit XPMENU.PAS.
D. Press Install.
E. The component is now installed in a new 'XP' page.
F. Save the package.


If you have a previous version installed:
Replace the old files (xpmenu.pas and xpmenu.dcr) with the new one,
open the package and recompile.
If you encounter any problems remove all the compiled units .dcu, .bpl, .dcp
(try to locate them also in 'C:\Program Files\Borland\DelphiX\Projects\Bpl' and
'C:\Program Files\Borland\DelphiX\lib'), then install pre-compiled units again.

--------------------------------------------------------------------------------


Notes on properties:

Active property:
 To activate/deactivate xpMenu, also, set this property to false then true when
 new items added at run time.

AutoDetect property:
 Set this property to True to force xpMenu to include new added items
 automatically.

UseSystemColors property:
 The global windows color scheme will be used, setting this property to true
 will override other color related properties.

OverrideOwnerDraw property:
 By default, xpMenu will not affect menu items that has owner draw handler
 assigned (any code in OnDrawItem event). To override any custom draw set this
 property to true.

Gradient property:
 IconBackcolor will be used as a gradient color for the entire menu,
 Color property will be ignored.

FlatMenu property:
 To turn menu's border to flat (drop-down and pop-up menu). Any way, a flat
 effect will not appear until a menu item is selected.

Form property:
 The default is the host form, if you want to target a different
 form other than the one hosting the component; set Form property to that form.

XPControls property:
  Specifies which control types affected by xpMenu.
  To prevent xpMenu from drawing a certain control; set the control's Tag
  property value to 999.


XPContainers property:
  Determine whether the Controls hosted by the specifies containers are affected
  by xpMenu.

GrayLevel property:
  To control image appearance in disabled items.
DimLevel property:


--------------------------------------------------------------------------------


ImageLists:
  For toolbars only ImageList assigned to Images property is used; xpMenu
  automatically generate dim and grayed images for non-hot and disabled items.

Buttons with tbsDivider style:
 xpMenu cannot draw toolbar buttons with tbsDivider style, Windows override any
 owner draw for this style (I am using Win 98). To work around this, set the
 button style to tbsSeparator and set its Tag property to none zero value.

Creation order:
 Make sure that the creation order of TXPMenu comes after any menu or toolbar
 component. To change the creation order, choose Edit | Creation Order from
 Delphi menu to open the Creation Order dialog box.


--------------------------------------------------------------------------------


Known issues:

 - In Delphi 6, XPMenu doesn't recognize buttons populated by
   Toolbar.Menu property, you need to reset Active property to true at run time.
 - Deactivate XPMenu from within controls affected by xpMenu cause error, this
   can happen also when changing any vlue of XPControls and XPContainers
   properies .
 - Deactivate XPMenu from within menu item OnClick handle cause loosing the
   drawing of the menu, to prevent this use Application.ProcessMessage before
   changing Active property:
   procedure TForm1.mnuActivateXPClick(Sender: TObject);
   begin
     Application.ProcessMessages;
     xpMenu1.Active := mnuActivateXP.Checked;
   end;
 - In menu toolbar Imagelist must be assigned to the MainMenu.


--------------------------------------------------------------------------------

Tips:

How to create menu toolbar:
 (Extracted from Delphi Help - TToolButton.MenuItem)

 To create an "IE4-style" (Office-style) toolbar that corresponds to
 an existing menu:
  1 Drop a ToolBar on the form and add a ToolButton for each top-level menu
    item you wish to create.
  2 Set the MenuItem property of each ToolButton to correspond to the top level
    menu items.
  3 Set the Grouped property of each ToolButton to True.
  4 Clear the MainMenu property of the Form (if it is assigned)

Images in toolbars and menus:
 To make an image transparent, be sure to fill the background with a unique
 color-a color your image is not using. Also, make sure that the color of the
 bottom leftmost pixel shown onscreen has the same background color; xpMenu will
 use this pixel to determine the transparent color.
