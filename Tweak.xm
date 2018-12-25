#define PLIST_PATH                                                             \
@"/var/mobile/Library/Preferences/com.i0stweak3r.foldercontroller.plist"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <CSColorPicker/CSColorPicker.h>

static CGFloat kFloatyOpacity;
static bool kEnabled = YES;
static bool kFloatyOpacityEnabled = YES;
static bool kFolderIconOpacityEnabled = YES;
static double kFolderIconOpacityColor;
static double kFolderIconOpacityWhite;
static bool kWantsCornerRadius = YES;
static double kIconCornerRadius;
static bool kWantsTapToClose = YES;
static bool kWantsPinchToClose = YES;
static bool kWantsNested = YES;
static CGFloat kBackgroundFolderRadius = 35.f;

static bool kNoFX = YES; //no blur open folders

static bool kReducedTransOn = YES; //dark bg
static double kCustomRows = 3.f;
static double kCustomColumns = 3.f;
static bool kWantsCustomInsets = YES;
static double kTopInset = 0.f;
static double kBottomInset = 0.f;
static double kSideInset = 0.f;
static bool kCustomLayout = YES;
static bool kHidesTitle= YES;
/** not implemented yet
static bool kFullPage = YES;
static bool kHidePageDots = YES;
**/
static bool kColorFolders = YES;
static NSString *kOpenFolderColorHex =
@"FFFFFF";
static NSString *kBorderColorHex= @"000000";
static CGFloat kCustomBorderWidth = 0;
//closed folders or icons below
static NSString *kIconHex  = @"FFFFFF";
static NSString *kBorderHex = @"FFFFFF";
static CGFloat kBorderWidth = 0;
static bool kColorIcons = YES;

@interface SBFolderIconImageView : UIView 
@end
//Allows access to all inherited properties of UIViews

@interface SBFolderBackgroundView : UIView
@end

%hook SBFolderBackgroundView
-(id)initWithFrame:(CGRect)frame {
if(kEnabled && kColorFolders) {
%orig;
self.backgroundColor = [UIColor colorFromHexString:kOpenFolderColorHex];

self.layer.borderColor = [UIColor colorFromHexString:kBorderColorHex].CGColor;
self.layer.borderWidth= kCustomBorderWidth;
self.layer.cornerRadius = kBackgroundFolderRadius;
self.layer.backgroundColor = [UIColor colorFromHexString:kOpenFolderColorHex].CGColor;
return self;
}
return %orig;
}

-(void)_setContinuousCornerRadius:(CGFloat)arg1 {
if(kWantsCornerRadius) {
arg1= kBackgroundFolderRadius;
return %orig(arg1);
}
return %orig;
}
%end
/** more folder background stuff not used yet
-(BOOL)_shouldUseDarkBackground
+(CGSize)folderBackgroundSize 
**/


%hook SBFolderSettings
-(bool)allowNestedFolders {
    if ((kEnabled) && (kWantsNested)) {
        return TRUE;
    }
    return %orig;
}

- (void)setAllowNestedFolders:(bool)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        arg1 = TRUE;
        return %orig(arg1);
    }
    return %orig;
}

- (void)setPinchToClose:(bool)arg1 {
    if ((kEnabled) && (kWantsPinchToClose)) {
        arg1 = YES;
        return %orig(arg1);
    }
    return %orig;
}
%end

/* This method changes corner radius of folder icons, but Snowboard
 tweak and theme engine makes it not work. works with Anemone tho.
*/

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
%orig;
 if ((kEnabled) && (kWantsCornerRadius)) {
self.layer.cornerRadius = kIconCornerRadius;
}
 if ((kEnabled) && (kColorIcons)) {

self.layer.borderWidth = kBorderWidth;
self.layer.borderColor = [UIColor colorFromHexString:kBorderHex].CGColor;
self.layer.backgroundColor = [UIColor colorFromHexString:kIconHex].CGColor;
return self;
}
return self;
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
    if (kHidesTitle) {
        return 0;
    }
    return %orig;
}

/*******
 FROM runtime header, this fixes bug where folder splits to multiple
 folders in landscape and loses dark BG. Keeps scrolling as the way to see next
 page. 
**********/
 
 -(bool)_shouldConvertToMultipleIconListsInLandscapeOrientation {
if(kEnabled) {
 return NO;
 }
 return %orig;
}

- (bool)_tapToCloseGestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2 {
    if ((kEnabled) && (kWantsTapToClose)) {
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
     return %orig;
}


- (void)setEffectActive:(bool)arg1 {

    if ((kEnabled) && (kNoFX)) {
        arg1 = FALSE;

return %orig(arg1);
}
    return %orig; 
}
%end


%hook SBFolderBackgroundView
+(void)_setContinuousCornerRadius : (CGFloat)arg1 {
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
    if ((kEnabled) && (kFolderIconOpacityEnabled)) {
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

%hook SBFWallpaperSettings
-(bool)replaceBlurs {
    if ((kEnabled) && (kFolderIconOpacityEnabled)) {
        return TRUE;
    }
    return %orig;
}
%end

%hook SBFolderIconListView
+(unsigned long long)maxVisibleIconRowsInterfaceOrientation
: (long long)arg1 {
    if ((kEnabled) && (kCustomLayout)) {
        %orig;
        return kCustomRows;
    }
    
    return %orig;
}

%end

%hook SBFolderIconListView
+(unsigned long long)iconColumnsForInterfaceOrientation : (long long)arg1 {
    
    if ((kEnabled) && (kCustomLayout)) {
        
        %orig;
        return kCustomColumns;
    }
    
    return %orig;
}
%end

/**  
Custom inset tweaking relative to original insets determined by number of icons per row or column **/
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

//more nested folder educated guesswork 

%hook SBApplicationPlaceholder
-(bool)iconAllowsLaunch : (id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBBookmark
-(bool)iconAllowsLaunch : (id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBPolicyAggregator
-(bool)allowsCapability : (long long)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBPolicyAggregator
-(bool)allowsTransitionRequest : (id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBIconListModel
-(bool)allowsAddingIcon:(id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBStarkIconListModel
-(bool)allowsAddingIcon:(id)arg1 {
    
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBIconModel
-(void)setAllowsSaving:(bool)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        arg1 = TRUE;
        return %orig(arg1);
    }
    return %orig;
}

- (bool)allowsSaving {
    if ((kEnabled) && (kWantsNested)) {
        
        return TRUE;
    }
    return %orig;
}
%end

%hook SBApplication
-(bool)iconAllowsLaunch : (id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBSpringBoardApplicationIcon
-(bool)iconAllowsLaunch : (id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBStarkIconController
-(bool)iconAllowsLaunch : (id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBIconView
-(bool)allowsTapWhileEditing {
    if ((kEnabled) && (kWantsNested)) {
        return TRUE;
    }
    return %orig;
}
%end

%hook SBFolderIconView
-(bool)allowsTapWhileEditing {
    if ((kEnabled) && (kWantsNested)) {
        return TRUE;
    }
    return %orig;
}
%end

%hook SBFolderController
-(bool)_allowUserInteraction {
    if ((kEnabled) && (kWantsNested)) {
        return TRUE;
    }
    return %orig;
}
%end

%hook SBPolicyAggregator
-(bool)_allowsCapabilitySpotlightWithExplanation : (id *)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

%hook SBFolderTitleTextField
-(void)setAllowsEditing : (bool)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        arg1 = TRUE;
        return %orig(arg1);
    }
    return %orig;
}
%end

%hook SBIconListModel
-(bool)addIcon:(id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        %orig;
        return TRUE;
    }
    return %orig;
}
%end

/* new methods in iOS 10 that I think blocks nested folders */

%hook SBIconLayoutOverrideStrategy
- (bool)preservesCurrentListOrigin {
    if ((kEnabled) && (kWantsNested)) {
        return 1;
    }
    return %orig;
}

- (id)initWithLayoutInsets:(UIEdgeInsets)arg1
perservingCurrentListOrigin:(bool)arg2 {
    if ((kEnabled) && (kWantsNested)) {
        arg2 = 1;
        return %orig(arg1, arg2);
    }
    return %orig;
}
%end

%hook SBIconController
- (bool)allowsNestedFolders {
    if ((kEnabled) && (kWantsNested)) {
        return YES;
    }
    return %orig;
}
%end

%hook SBIconListView
- (void)updateEditingStateAnimated : (bool)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        arg1 = 0;
        return %orig;
    }
    return %orig;
}

- (void)_sendLayoutDelegateWouldHaveMovedIcon:(id)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        arg1 = nil;
        %orig(arg1);
    }
    %orig;
}

- (bool)allowsAddingIconCount:(unsigned long long)arg1 {
    if ((kEnabled) && (kWantsNested)) {
        return 1;
        %orig;
    } else {
        return %orig;
    }
}
%end

%hook SBFolderController
- (bool)canAcceptFolderIconDrags {
    if ((kEnabled) && (kWantsNested)) {
        return TRUE;
    }
    return %orig;
}
%end

//Handle prefs with user defaults

static void
loadPrefs() {
    static NSUserDefaults *prefs = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"com.i0stweak3r.foldercontroller"];
    
    kEnabled = [prefs boolForKey:@"enabled"];
    
    kFloatyOpacityEnabled = [prefs boolForKey:@"floatyOpacityEnabled"];
    
    kFloatyOpacity = [[prefs objectForKey:@"floatyOpacity"] floatValue];
    
    kFolderIconOpacityEnabled = [prefs boolForKey:@"folderIconOpacityEnabled"];
    
    kFolderIconOpacityWhite =
    [[prefs objectForKey:@"folderIconOpacityWhite"] floatValue];
    
    kFolderIconOpacityColor =
    [[prefs objectForKey:@"folderIconOpacityColor"] floatValue];
    
    kWantsCornerRadius = [prefs boolForKey:@"iconCornerRadiusEnabled"];
    
    kIconCornerRadius = [[prefs objectForKey:@"iconCornerRadius"] floatValue];
    
    kBackgroundFolderRadius =
    [[prefs objectForKey:@"backgroundFolderRadius"] floatValue];
    
    kWantsTapToClose = [prefs boolForKey:@"wantsTapToClose"];
    
    kWantsPinchToClose = [prefs boolForKey:@"wantsPinchToClose"];
    
    kHidesTitle = [prefs boolForKey:@"hidesTitle"];
    
    kNoFX = [prefs boolForKey:@"noFX"];
    
    kReducedTransOn = [prefs boolForKey:@"reducedTransOn"];
    
    kCustomLayout = [prefs boolForKey:@"customLayout"];
    
    kCustomRows = [prefs integerForKey:@"customRows"];
    
    kCustomColumns = [prefs integerForKey:@"customColumns"];
    
    kWantsCustomInsets = [prefs boolForKey:@"wantsCustomInsets"];
    
    kTopInset = [[prefs objectForKey:@"topInset"] floatValue];
    
    kSideInset = [[prefs objectForKey:@"sideInset"] floatValue];
    
    kBottomInset = [[prefs objectForKey:@"bottomInset"] floatValue];
    
    kWantsNested = [prefs boolForKey:@"wantsNested"];
//NEW STUFF ADDED

kColorFolders = [prefs boolForKey:@"colorFolders"];

kOpenFolderColorHex =    [[prefs objectForKey:@"openFolderColorHex"] stringValue];

kBorderColorHex =  [[prefs objectForKey:@"borderColorHex"] stringValue];

kCustomBorderWidth = [[prefs objectForKey:@"customBorderWidth"] floatValue];

kIconHex = [[prefs objectForKey:@"iconHex"] stringValue];

kBorderHex =  [[prefs objectForKey:@"borderHex"] stringValue];

kBorderWidth = [[prefs objectForKey:@"borderWidth"] floatValue];

kColorIcons =  [prefs boolForKey:@"colorIcons"];

  
}

%ctor {
    CFNotificationCenterAddObserver(
                                    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR("com.i0stweak3r.foldercontroller-prefsreload"), NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}
