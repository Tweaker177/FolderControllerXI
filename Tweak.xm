
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#include <stdlib.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#include <CSColorPicker/CSColorPicker.h>

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.i0stweak3r.foldercontroller.plist"


static int kGradientStyleSelection = 0;
static CGFloat kFloatyOpacity;
static bool kEnabled;
static bool kFloatyOpacityEnabled = YES;
static bool kFolderIconOpacityEnabled = YES;
static double kFolderIconOpacityColor;
static double kFolderIconOpacityWhite;
static bool kWantsCornerRadius = YES;
static double kIconCornerRadius;
static bool kWantsTapToClose = YES;
static bool kWantsPinchToClose = YES;

static CGFloat kBackgroundFolderRadius = 35.f;

static bool kWantsStatusBarWithFolder = YES;

static bool kNoFX = YES; //no blur open folders

static bool kReducedTransOn = YES; //dark bg

/* defaults vary for layout of iPad and iPhone, need to address this at some point. Not a big issue though, if used it will be user set and is off by default */
static double kCustomRows; 
static double kCustomColumns;

static bool kWantsCustomInsets;
static double kTopInset = 0.f;
static double kBottomInset = 0.f;
static double kSideInset = 0.f;
static bool kCustomLayout = YES;
static bool kHidesTitle;
static NSString *kNewBorderColor = @"000000";
static bool kWantsAutoClose = NO;

static bool kRandomGradientsEnabled = YES;

static CGFloat screenHeight, screenWidth;
static bool kWantsNoFolderDelete;


static bool kColorFolders = YES;
static NSString *kOpenFolderColorHex =
@"FF0000";
static NSString *kOpenGradient2Hex= @"FF0000";
//actually this is gradient 3 now
//was kBorderColorHex originally

static CGFloat kCustomBorderWidth = 0;
//closed folders or icons below
static NSString *kIconHex  = @"FF0000";
static NSString *kBorderHex = @"000000";
static CGFloat kBorderWidth = 0.f;
static bool kColorIcons = YES;
static bool kWantsNoMiniGrid = NO;

static int kFolderSizeSelection = 0;
static NSString *kOpenGradient3Hex = @"000000";

static NSString *kIconGradient3Hex =  @"FF0000";

static bool kFolderGradientsEnabled = YES;

static bool kIconGradientsEnabled = YES; 
//Actually is Supports Theme Image Enabled

static bool kMultiItem = YES;

UIImageView* _tintView;

@interface SBFolderIconImageView : UIView 
@end
//Allows access to all inherited properties of UIViews

@interface SBFolderBackgroundView : UIView

{
UIImageView* _tintView;
}

+(CGSize)folderBackgroundSize;
+(CGFloat)cornerRadiusToInsetContent;
-(id)initWithFrame:(CGRect)frame;
-(void)layoutSubviews;
@end

@interface SBFolderIconBackgroundView : UIView
-(id)initWithFrame:(CGRect)frame;
@end

@interface SBFloatyFolderView : UIView
/* not used, was going to use to adjust title appearance for full page folder and full-width in landscape
-(CGFloat)_titleVerticleOffsetForOrientation:(NSInteger)arg1;

-(CGFloat)_titleFontSize;
*/
@end


%hook SBFolder
-(bool)isEmpty {
if(kWantsNoFolderDelete) {
return 0;
}
return %orig;
}

-(bool)shouldRemoveWhenEmpty {
if(kWantsNoFolderDelete) {
return 0;
}
return %orig;
}
%end

%hook SBFolderIcon
-(BOOL)canBeAddedToMultiItemDrag {
if(kEnabled && kMultiItem) {
return 1;
}
return %orig;
}
%end


%hook SBFolderController
- (void)_addFakeStatusBarView {
if(kEnabled && kWantsStatusBarWithFolder) {
return;
}
return %orig;
}
%end


%hook SBFolderTitleTextField
-(id)initWithFrame:(CGRect)frame {
if(!kEnabled) { return %orig; }
screenWidth = [[UIScreen mainScreen] bounds].size.width;
screenHeight = [[UIScreen mainScreen] bounds].size.height;

if((kFolderSizeSelection == 1) || (kFolderSizeSelection == 2 && screenWidth > screenHeight)) {

frame = CGRectMake(0, -20, screenWidth, 16.f);

return %orig(frame);
}
return %orig;
}
%end


%hook SBFloatyFolderView
-(id)initWithFrame:(CGRect)frame {
if((kEnabled) && ((kFolderSizeSelection == 1) || (kFolderSizeSelection==2))) {
self = %orig;
screenHeight = [[UIScreen mainScreen] bounds].size.height;
screenWidth = [[UIScreen mainScreen] bounds].size.width;
self.frame= CGRectMake(0,0,screenWidth,screenHeight);
self.bounds = 
CGRectMake(0,0,screenWidth,screenHeight);
return self;
}
return %orig;
}

-(bool)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2 {
if(kEnabled && kWantsAutoClose) {
return 1;
%orig;
}
return %orig;
}

%end

%hook SBFolderBackgroundView
+(CGSize)folderBackgroundSize {
screenHeight = [[UIScreen mainScreen] bounds].size.height;
screenWidth = [[UIScreen mainScreen] bounds].size.width;

if((kEnabled) && (kFolderSizeSelection == 1)) {

CGSize folderSize = CGSizeMake(screenWidth-16.f, screenHeight - 77.f);
return folderSize;
}
else if((kEnabled) && (kFolderSizeSelection == 2)&&(screenHeight > screenWidth)) {
CGSize folderSizeSquare = CGSizeMake(screenWidth-16.f, screenWidth-16.f);
return folderSizeSquare;
}
else if((kEnabled) && (kFolderSizeSelection == 2)&&(screenHeight < screenWidth)) {
CGSize folderSizeSquare = CGSizeMake(screenHeight-16.f, screenHeight-16.f);
return folderSizeSquare;
}
else {
return %orig; }
}



-(id)initWithFrame:(CGRect)frame {
SBFolderBackgroundView *view = %orig;

screenHeight = [[UIScreen mainScreen] bounds].size.height;
screenWidth = [[UIScreen mainScreen] bounds].size.width;

if((kEnabled) && (kFolderSizeSelection == 0)&&(screenHeight > screenWidth)) {
CGSize normalSize = [%c(SBFolderBackgroundView)folderBackgroundSize];
view.frame= CGRectMake (0,0, normalSize.width, normalSize.height);
view.bounds = view.frame;

}
if((kEnabled) && (kFolderSizeSelection == 0)&&(screenHeight < screenWidth)) {
CGSize normalSize =
[%c(SBFolderBackgroundView)folderBackgroundSize];
view.frame= CGRectMake (0,0, normalSize.width, normalSize.height);
view.bounds = view.frame;

}

if((kEnabled) && (kFolderSizeSelection == 1)) {

view.frame = CGRectMake(0,0, screenWidth-16.f, screenHeight-77.f);
view.bounds = view.frame;
}


//Trying to create square folder size of device width

if((kEnabled) && (kFolderSizeSelection == 2)) {
if (screenWidth > screenHeight) {
    float tempHeight = screenWidth;
    screenWidth = screenHeight;
    screenHeight = tempHeight; 
}
//room for statusBar in landscape 
view.frame = CGRectMake(0,0, screenWidth -16.f, screenWidth - 16.f);
view.bounds = view.frame;

} //end of If full width folder

if(kEnabled && kFolderGradientsEnabled) {

view.layer.borderColor = [UIColor colorFromHexString: kNewBorderColor].CGColor;
view.layer.borderWidth= kCustomBorderWidth;
view.layer.cornerRadius = kBackgroundFolderRadius;

UIImageView* tintView = MSHookIvar<UIImageView *>(self, "_tintView");

tintView = [[UIImageView alloc]initWithFrame: view.frame];
tintView.image = nil;

tintView.backgroundColor = nil;
tintView.layer.backgroundColor = nil;
tintView.alpha = 0;
tintView.userInteractionEnabled = 0;
tintView.opaque = 1;
tintView.hidden= YES; 
_tintView= tintView;
[_tintView setHidden: YES];

CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;

int randomInt= arc4random_uniform(7);
if(!kRandomGradientsEnabled) { 
switch (kGradientStyleSelection) {
case 0: randomInt= 0; break;
case 1: randomInt= 2; break;
case 2: randomInt= 3; break;
case 3: randomInt= 4; break;
case 4: randomInt= 5; break;
case 5: randomInt= 6; break;
case 6: randomInt = 1; break;
default: randomInt = 0; break; }
}



switch (randomInt) {
case 0: gradient.startPoint = CGPointZero;
gradient.endPoint = CGPointMake(1.0, 1.0);
gradient.colors= [NSArray arrayWithObjects: (id)[UIColor colorFromHexString:kOpenFolderColorHex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient3Hex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient2Hex].CGColor, nil];
   [view.layer insertSublayer:gradient atIndex:0];
      [view.layer insertSublayer:gradient atIndex:1];
break;
case 1:  gradient.startPoint = CGPointMake(1.0, 0.5);
gradient.endPoint = CGPointMake(0, 0.5);
gradient.colors= [NSArray arrayWithObjects: (id)[UIColor colorFromHexString:kOpenFolderColorHex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient3Hex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient2Hex].CGColor, nil];
   [view.layer insertSublayer:gradient atIndex:0];
      [view.layer insertSublayer:gradient atIndex:1];
break;
case 2: gradient.startPoint = CGPointMake(0.5, 0);
gradient.endPoint = CGPointMake(0.5, 1);
gradient.colors= [NSArray arrayWithObjects: (id)[UIColor colorFromHexString:kOpenFolderColorHex].CGColor, (id)[UIColor colorFromHexString: kOpenGradient2Hex].CGColor, (id)[UIColor colorFromHexString: kOpenGradient3Hex].CGColor, nil];
   [view.layer insertSublayer:gradient atIndex:0];
      [view.layer insertSublayer:gradient atIndex:1];
break;
case 3:

gradient.colors= [NSArray arrayWithObjects: (id)[UIColor colorFromHexString: kOpenGradient2Hex].CGColor, (id)[UIColor colorFromHexString:kOpenFolderColorHex].CGColor, (id)[UIColor colorFromHexString: kOpenGradient3Hex].CGColor, nil];

gradient.locations= [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.31],[NSNumber numberWithFloat:0.52],[NSNumber numberWithFloat:0.74],nil];

   [view.layer insertSublayer:gradient atIndex:0];
      [view.layer insertSublayer:gradient atIndex:1];

break;

case 4: 
gradient.colors= [NSArray arrayWithObjects:(id)[UIColor colorFromHexString:kOpenGradient3Hex].CGColor, (id)[UIColor colorFromHexString:kOpenFolderColorHex].CGColor, (id)[UIColor colorFromHexString:kOpenGradient2Hex].CGColor, nil];

gradient.locations= [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.15],[NSNumber numberWithFloat:0.37],[NSNumber numberWithFloat:0.80],nil];

   [view.layer insertSublayer:gradient atIndex:0];
      [view.layer insertSublayer:gradient atIndex:1];

break;

case 5: 
    gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);
    gradient.colors =[NSArray arrayWithObjects: (id)[UIColor colorFromHexString:kOpenFolderColorHex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient3Hex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient2Hex].CGColor, nil];
            [view.layer insertSublayer:gradient atIndex:0];
      [view.layer insertSublayer:gradient atIndex:1];
break;
case 6:    gradient.startPoint = CGPointMake(0.9, 1.0);
    gradient.endPoint = CGPointMake(0.15, 0.05);
    gradient.colors =[NSArray arrayWithObjects: (id)[UIColor colorFromHexString:kOpenFolderColorHex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient3Hex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient2Hex].CGColor, nil];
            [view.layer insertSublayer:gradient atIndex:0];
      [view.layer insertSublayer:gradient atIndex:1];
break;

default: 
 gradient.startPoint = CGPointMake(0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);
    gradient.colors =[NSArray arrayWithObjects: (id)[UIColor colorFromHexString:kOpenFolderColorHex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient3Hex].CGColor,(id)[UIColor colorFromHexString:kOpenGradient2Hex].CGColor, nil];
            [view.layer insertSublayer:gradient atIndex:0];
      [view.layer insertSublayer:gradient atIndex:1];
break;
} //end of switch

return view;
}
else if(kEnabled && kColorFolders) {

view.backgroundColor = [UIColor colorFromHexString:kOpenFolderColorHex];

view.layer.borderColor = [UIColor colorFromHexString:kNewBorderColor].CGColor;
view.layer.borderWidth= kCustomBorderWidth;
view.layer.cornerRadius = kBackgroundFolderRadius;
return view;
}
else { return view; }
}

-(id)_tintViewBackgroundColorAtFullAlpha {
if((kEnabled && kColorFolders)&&(!kFolderGradientsEnabled)) {

return [UIColor colorFromHexString:kOpenFolderColorHex];
}

else if(kEnabled && kFolderGradientsEnabled) {
return nil;
}
else { 
return %orig; }
}

-(void)_setContinuousCornerRadius:(CGFloat)arg1 {
if(kWantsCornerRadius) {
arg1= kBackgroundFolderRadius;
return %orig(arg1);
}
return %orig;
}

-(void)layoutSubviews {
if(kEnabled && kFolderGradientsEnabled) {


 
%orig;
_tintView.hidden = YES;
[_tintView setHidden: YES];

_tintView.alpha = 0.01;
_tintView.backgroundColor = [UIColor colorFromHexString: @"00000000"];
_tintView.layer.backgroundColor= [UIColor colorFromHexString: @ "00000000"].CGColor;

return;
}
else { return %orig; }
}
%end



%hook SBFolderSettings

- (void)setPinchToClose:(bool)arg1 {
    if ((kEnabled) && (kWantsPinchToClose)) {
        arg1 = YES;
        return %orig(arg1);
    }
    return %orig;
}
%end

/* This method changes corner radius of folder icons, but SNOWBOARD
 tweak and theme engine makes it not work. works with ANEMONE still. */

%hook SBIconImageView
+(double)cornerRadius {
    if ((kEnabled) && (kWantsCornerRadius)) {
        return kIconCornerRadius;
    }
    return %orig;
}

%end

/*
Changing FolderIconImageView radius at layer level works around Snowboard conflict 
*/
%hook SBFolderIconImageView
-(id)initWithFrame:(CGRect)frame {
if(!kEnabled) { return %orig; }
SBFolderIconImageView *folderIconImageView = %orig;
 if((kWantsCornerRadius) && (kColorIcons)&& (!kIconGradientsEnabled)) {
folderIconImageView.layer.cornerRadius = kIconCornerRadius;
folderIconImageView.layer.borderWidth = kBorderWidth;
folderIconImageView.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;

folderIconImageView.backgroundColor = [UIColor colorFromHexString:kIconHex];

//Just re-added I believe 

folderIconImageView.layer.backgroundColor = [UIColor colorFromHexString:kIconHex].CGColor;
return folderIconImageView;
}
else if((kWantsCornerRadius)&& (kIconGradientsEnabled)) {
folderIconImageView.layer.cornerRadius = kIconCornerRadius;

folderIconImageView.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;
folderIconImageView.layer.borderWidth = kBorderWidth;

return folderIconImageView;

}
else if(kIconGradientsEnabled) {
/* kIconGradients= supports theme image option. Right now the option is basically unused since I took away need for this switch to add borders to themed images or stock background (normal tint behind folder icons).

Going to hopefully add option to hide theme image if it's off though and show stock background, but if on show folder masks from themes
*/

folderIconImageView.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;
folderIconImageView.layer.borderWidth = kBorderWidth;
folderIconImageView.layer.cornerRadius = kIconCornerRadius;

return folderIconImageView;

}
else if (kColorIcons) {
folderIconImageView.layer.borderWidth = kBorderWidth;
folderIconImageView.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;
folderIconImageView.backgroundColor = [UIColor colorFromHexString:kIconHex];
return folderIconImageView;
}
else if(kWantsCornerRadius) {
folderIconImageView.layer.cornerRadius = kIconCornerRadius;

/*Just added this to make borders work without colored folders */
folderIconImageView.layer.borderWidth = kBorderWidth;
folderIconImageView.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;
return folderIconImageView;
}
else {
return folderIconImageView; }
}

%end


%hook SBFolderIconBackgroundView
-(id)initWithFrame:(CGRect)frame {
SBFolderIconBackgroundView  *backgroundView = %orig;
if(kEnabled && kIconGradientsEnabled) {

backgroundView.layer.cornerRadius = kIconCornerRadius;


backgroundView.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;
backgroundView.layer.borderWidth = kBorderWidth;

return backgroundView;
}
else if(kEnabled && kWantsCornerRadius) {
backgroundView.layer.cornerRadius = kIconCornerRadius;


backgroundView.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;
backgroundView.layer.borderWidth = kBorderWidth;

return backgroundView;
}
/* Just added this to make Border work without color enabled */
else if(kEnabled) {
backgroundView.layer.cornerRadius = kIconCornerRadius;


backgroundView.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;
backgroundView.layer.borderWidth = kBorderWidth;

return backgroundView;
}
else { 
return backgroundView;
}
}
%end

%hook SBIcon
- (id)gridCellImage {
if(kEnabled && kWantsNoMiniGrid) {
return nil;
}
else {
return  %orig;
}
}
%end

%hook SBFolderView
-(bool)textFieldShouldReturn {
    if (kHidesTitle) {
        return 0;
    }
    return %orig;
}
%end

%hook SBFloatyFolderView
-(bool)_showsTitle {

if(kHidesTitle) {
        return 0;
    }
    return %orig;
}

/*******
 FROM runtime header, this fixes bug where folder splits to multiple
 folders in landscape and loses dark BG. Keeps scrolling as the way to see next
 page. **********/
 
 -(bool)_shouldConvertToMultipleIconListsInLandscapeOrientation {
if(kEnabled) {
 return NO;
 }
 return %orig;
}

- (bool)_tapToCloseGestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2 {
    if ((kEnabled) && ((kWantsTapToClose) || (kWantsAutoClose))) {
        return YES;
        %orig;
    }
    return %orig;
}

- (void)setBackgroundAlpha:(CGFloat)arg1 {
    if ((kEnabled) && (kFloatyOpacityEnabled)) {
        arg1 = (kFloatyOpacity / 100);
        return %orig(arg1);
    }
    return %orig;
}
%end

%hook SBFolderControllerBackgroundView
-(bool)effectActive {
    if ((kEnabled) && (kNoFX)) {
        // removes blur
        return FALSE;
    }
    return %orig;
}

- (bool)isReduceTransparencyEnabled {
    if ((kEnabled) && (kReducedTransOn)) {
        return 1;
        // makes backgroundViews darker

    }
else if((kEnabled) &&(!kNoFX)) {
/** Tried to set a BG color here but didn’t work **/
    return %orig;
}
else { return %orig; }
}

- (void)setEffectActive:(bool)arg1 {

    if ((kEnabled) && (kNoFX)) {
        arg1 = FALSE;

return %orig(arg1);

    }
else {
    return %orig; }
}
%end

%hook SBFolderBackgroundView
+(void)_setContinuousCornerRadius:(CGFloat)arg1 {
    if ((kEnabled) && (kWantsCornerRadius)) {
        arg1 = kBackgroundFolderRadius;
        return %orig(arg1);
    }
    return %orig;
}
// this is necessary for open folder radius changes
+ (CGFloat)cornerRadiusToInsetContent {
    if ((kEnabled) && (kWantsCornerRadius)) {
        return kBackgroundFolderRadius;
    }
    return %orig;
}

%end

%hook SBIconColorSettings
-(bool)blurryFolderIcons {
    if ((kEnabled) && (kFolderIconOpacityEnabled)&&(!kIconGradientsEnabled)) {
        return FALSE;
    }
    return %orig;
}

- (double)colorAlpha {
    if ((kEnabled) && (kFolderIconOpacityEnabled)) {
        return (kFolderIconOpacityColor / 100);
    }
    return %orig;
}

- (double)whiteAlpha {
    if ((kEnabled) && (kFolderIconOpacityEnabled)) {
        
        return kFolderIconOpacityWhite / 100;
    }
    return %orig;
}
%end

/* changed for gradient icons but it didn’t work (don't remember if I changed back) */

%hook SBFWallpaperSettings
-(bool)replaceBlurs {
    if ((kEnabled) && (kFolderIconOpacityEnabled)&&(!kIconGradientsEnabled)) {
        return TRUE;
    }
    return %orig;
}
%end

%hook SBFolderIconListView
+(unsigned long long)maxVisibleIconRowsInterfaceOrientation
: (long long)arg1 {
    if ((kEnabled && kCustomLayout)&&(kCustomRows >= 1)) {
        %orig;
        return kCustomRows;
    }
    
    return %orig;
}

%end

%hook SBFolderIconListView
+(unsigned long long)iconColumnsForInterfaceOrientation : (long long)arg1 {
    
    if ((kEnabled && kCustomLayout)&& (kCustomColumns >= 1)) {
        //Added extra conditional for when settings=nil

        %orig;
        return kCustomColumns;
    }
    
    return %orig;
}
%end

/**  
Custom inset tweaking relative to original insets determined by number of icons per row or column
 **/

%hook SBFolderIconListView
-(double)bottomIconInset {
    if ((kEnabled) && (kWantsCustomInsets)) {
        double IconInset = %orig;
        IconInset = IconInset - (IconInset * kBottomInset);
        return IconInset;
    }
    return %orig;
}
%end

%hook SBFolderIconListView
-(double)sideIconInset {
    if ((kEnabled) && (kWantsCustomInsets)) {
        double IconInset = %orig;
        IconInset = IconInset - (IconInset * kSideInset);
        return IconInset;
    }
    return %orig;
}
%end

%hook SBFolderIconListView
-(double)topIconInset {
    if ((kEnabled) && (kWantsCustomInsets)) {
        double IconInset = %orig;
        IconInset = IconInset - (IconInset * kTopInset);
        return IconInset;
    }
    return %orig;
}
%end

//Handle Prefs and Set Defaults

static void
loadPrefs() {
    static NSUserDefaults *prefs = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"com.i0stweak3r.foldercontroller"];
    
    kEnabled =  [[prefs objectForKey:@"enabled"] boolValue] ? [prefs boolForKey:@"enabled"] : NO;
    
    kFloatyOpacityEnabled = [prefs boolForKey:@"floatyOpacityEnabled"];
 
    kFolderIconOpacityEnabled = [prefs boolForKey:@"folderIconOpacityEnabled"];
    
    kFolderIconOpacityWhite =
    [[prefs objectForKey:@"folderIconOpacityWhite"] floatValue] ?     [[prefs objectForKey:@"folderIconOpacityWhite"] floatValue] : 70.f;
    
    kFolderIconOpacityColor =
    [[prefs objectForKey:@"folderIconOpacityColor"] floatValue] ?    [[prefs objectForKey:@"folderIconOpacityColor"] floatValue] : 70.f;
    
    kWantsCornerRadius = [prefs boolForKey:@"iconCornerRadiusEnabled"];
    
    kIconCornerRadius = [[prefs objectForKey:@"iconCornerRadius"] floatValue] ? [[prefs objectForKey:@"iconCornerRadius"] floatValue] : 10.f;
    
    kBackgroundFolderRadius =
    [[prefs objectForKey:@"backgroundFolderRadius"] floatValue] ?  [[prefs objectForKey:@"backgroundFolderRadius"] floatValue] : 38.f;
    
    kWantsTapToClose = [prefs boolForKey:@"wantsTapToClose"];
    
    kWantsPinchToClose = [prefs boolForKey:@"wantsPinchToClose"];
    
    kHidesTitle =  [prefs boolForKey:@"hidesTitle"];

    kNoFX = [prefs boolForKey:@"noFX"];
    
    kReducedTransOn =  [prefs boolForKey:@"reducedTransOn"];

    kCustomLayout = [prefs boolForKey:@"customLayout"];
    
    kCustomRows = [prefs integerForKey:@"customRows"];
    
    kCustomColumns = [prefs integerForKey:@"customColumns"];
    
    kWantsCustomInsets = [prefs boolForKey:@"wantsCustomInsets"];
    
    kTopInset = [[prefs objectForKey:@"topInset"] floatValue];
    
    kSideInset = [[prefs objectForKey:@"sideInset"] floatValue];
    
    kBottomInset = [[prefs objectForKey:@"bottomInset"] floatValue];

kMultiItem = [prefs boolForKey:@"multiItem"];


kColorFolders = [prefs boolForKey:@"colorFolders"];

kFolderGradientsEnabled =  [prefs boolForKey:@"folderGradientsEnabled"];

kRandomGradientsEnabled = [prefs boolForKey:@"randomGradientsEnabled"];

kOpenFolderColorHex =    [[prefs objectForKey:@"openFolderColorHex"] stringValue] ? [prefs stringForKey:@"openFolderColorHex"] : @"FF0000";

kOpenGradient2Hex =  [[prefs objectForKey:@"borderColorHex"] stringValue] ? [prefs stringForKey:@"borderColorHex"] : @"FF0000";  //Actually this is Open gradient 3
//Was 1st used as a border

kOpenGradient3Hex =   [[prefs objectForKey:@"openGradient3Hex"] stringValue] ? [prefs stringForKey:@"openGradient3Hex"] : @"000000";

kCustomBorderWidth = [[prefs objectForKey:@"customBorderWidth"] floatValue] ? 
 [[prefs objectForKey:@"customBorderWidth"] floatValue] : 0.f;

kIconHex = [[prefs objectForKey:@"iconHex"] stringValue] ? [prefs stringForKey:@"iconHex"] : @"FF0000";

kWantsNoMiniGrid= [[prefs objectForKey: @"wantsNoMiniGrid"] boolValue] ?  [prefs boolForKey:@"wantsNoMiniGrid"] : NO;

/*
kIconGradient3Hex=  [[prefs objectForKey:@"iconGradient3Hex"] stringValue];
*/
kIconGradientsEnabled =  [prefs boolForKey:@"iconGradientsEnabled"];
//Actually is Support theme images option

kBorderHex =  [[prefs objectForKey:@"borderHex"] stringValue] ? [prefs stringForKey:@"borderHex"] : @"000000";

kBorderWidth = [[prefs objectForKey:@"borderWidth"] floatValue];

kColorIcons =  [prefs boolForKey:@"colorIcons"];
/**
kWantsOpenBackgroundImage = [prefs boolForKey:@"wantsOpenBackgroundImage"];
**/

kFolderSizeSelection = [[prefs objectForKey:@"folderSizeSelection"] integerValue] ?  [[prefs objectForKey:@"folderSizeSelection"] integerValue] : 0;

kNewBorderColor =  [[prefs objectForKey:@"newBorderColor"] stringValue] ? 
[prefs stringForKey:@"newBorderColor"] : @"000000";

kGradientStyleSelection = [[prefs objectForKey:@"gradientStyleSelection"] integerValue];

kWantsNoFolderDelete = [prefs boolForKey:@"wantsNoFolderDelete"];

kWantsAutoClose=  [prefs boolForKey:@"wantsAutoClose"];


kFloatyOpacity = [[prefs objectForKey: @"floatyOpacity"] floatValue] ? [[prefs objectForKey: @"floatyOpacity"] floatValue] : 100.f;

kWantsStatusBarWithFolder = [prefs boolForKey:@"wantsStatusBar"];

}

%ctor {
    CFNotificationCenterAddObserver(
                                    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR("com.i0stweak3r.foldercontroller-prefsreload"), NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}
