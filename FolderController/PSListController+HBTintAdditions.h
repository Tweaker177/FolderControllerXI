#import <CepheiPrefs/HBAppearanceSettings.h>

#import <Preferences/PSListController.h>

@class HBAppearanceSettings;

 NS_ASSUME_NONNULL_BEGIN

@interface PSListController (HBTintAdditions)



/**
 * The appearance settings for the view controller.
 *
 * This should only be set in an init or viewDidLoad method of the view
 * controller. The result when this property or its properties are changed after
 * the view has appeared is undefined.
 */


@property (nonatomic, copy, nullable, setter=hb_setAppearanceSettings:) HBAppearanceSettings 
*hb_appearanceSettings;


/***
%p hb_appearanceSettings
-(instancetype) init
{
	self = [super init]; 

    if (self) {


        HBAppearanceSettings *appearanceSettings 

= [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:240.f / 255.f green:10.f / 255.f blue:14.f / 255.f alpha:1];
        appearanceSettings.tableViewCellSeparatorColor =  [UIColor colorWithWhite:134.f / 255.f alpha:1];  appearanceSettings.tableViewCellTextColor = [UIColor colorWithWhite:242.f / 255.f alpha:1];
      
appearanceSettings.tableViewCellSelectionColor =  [UIColor colorWithWhite:13.f / 255.f alpha:0.6];
appearanceSettings.navigationBarBackgroundColor= [UIColor colorWithWhite:13.f / 255.f alpha:1];
	appearanceSettings.navigationBarTitleColor = [UIColor colorWithWhite:242.f / 255.f alpha:1];  appearanceSettings.navigationBarTintColor = [UIColor colorWithRed: 240.f/255.f green:44.f / 255.f blue:44.f/255.f alpha:1];
appearanceSettings.tableViewBackgroundColor= [UIColor colorWithRed: 15.f/ 255.f green:245.f/241.f blue: 200.f/255.f alpha:1];
appearanceSettings.translucentNavigationBar = YES;
        self.hb_appearanceSettings = appearanceSettings;
    }

    return self;
}
***/

@end
/*
MSHookIvar[[[%p][hb_appearanceSettings alloc] [super init]
[%c][HBAppearanceSettings]<[HBListController]<[PSListController]]]
 {  if (self) {

*/



NS_ASSUME_NONNULL_END