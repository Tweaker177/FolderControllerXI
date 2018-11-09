#define PLIST_PATH @"/var/mobile/Library/Preferences/com.i0stweak3r.foldercontroller.plist"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <SpringBoard/SBFolderController.h>


static CGFloat kFloatyOpacity;
static bool kEnabled= YES;
static bool kFloatyOpacityEnabled= YES;
static bool kFolderIconOpacityEnabled= YES;
static double kFolderIconOpacityColor;
static double kFolderIconOpacityWhite;
static bool kWantsCornerRadius = YES;
static double kIconCornerRadius;
static bool kWantsTapToClose = YES;
static bool kWantsPinchToClose = YES;
static bool kWantsNested = YES;
static CGFloat kBackgroundFolderRadius = 35.f;
static bool kPlainFX = YES;
static bool kNoFX= YES;

static bool kReducedTransOn = YES;
static double kCustomRows= 3.f;
static double kCustomColumns= 3.f;
static bool kWantsCustomInsets = YES;
static double kTopInset= 0.f;
static double kBottomInset = 0.f;
static double kSideInset = 0.f;
static bool kCustomLayout = YES;
static bool kHidesTitle = YES;



/* new methods in iOS 10 that I think blocks nested folders */

%hook SBIconLayoutOverrideStrategy
-(BOOL)preservesCurrentListOrigin {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
kWantsNested = [[prefs objectForKey:@"wantsNested"] boolValue] ;

kEnabled= [[prefs objectForKey:@"enabled"] boolValue] ;

if((kEnabled)&&(kWantsNested)) {
return 1;
}
return %orig;
}

-(id)initWithLayoutInsets:(UIEdgeInsets)arg1 perservingCurrentListOrigin:(BOOL)arg2 {
if((kEnabled)&&(kWantsNested)) {
arg2= 1;
return  %orig(arg1,arg2);
}
return %orig;
}

%end

%hook SBIconController
-(bool) allowsNestedFolders {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
kWantsNested = [[prefs objectForKey:@"wantsNested"] boolValue] ;

kEnabled= [[prefs objectForKey:@"enabled"] boolValue] ;

if((kEnabled)&&(kWantsNested)) {
return YES;
}
return %orig;
}
%end

%hook SBIconListView
-(void)updateEditingStateAnimated:(BOOL)arg1 {
if((kEnabled)&&(kWantsNested)) {
arg1= 0;
return %orig;
}
return %orig;
}


-(void)_sendLayoutDelegateWouldHaveMovedIcon:(id)arg1  {
if((kEnabled)&&(kWantsNested)) {
arg1= nil;
%orig(arg1);
}
%orig;
}

-(BOOL)allowsAddingIconCount:(unsigned long long)arg1 {
if((kEnabled)&&(kWantsNested)) {
return 1;
%orig;
} else {
return %orig; }
}
%end
/** Just added ***/

%hook SBFolderController
-(BOOL) canAcceptFolderIconDrags {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];

kEnabled= [[prefs objectForKey:@"enabled"] boolValue];

kWantsNested = [[prefs objectForKey:@"wantsNested"] boolValue] ;

if((kEnabled)&&(kWantsNested)) {
return TRUE;
}
return %orig;
}
%end



%hook SBFolderSettings
-(bool) allowNestedFolders {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];

kEnabled= [[prefs objectForKey:@"enabled"] boolValue];

kWantsNested = [[prefs objectForKey:@"wantsNested"] boolValue] ;

if((kEnabled)&&(kWantsNested)) {
return TRUE;
}
return %orig;
}

-(void) setAllowNestedFolders:(bool)arg1 {

NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];

kEnabled= [[prefs objectForKey:@"enabled"] boolValue];

kWantsNested = [[prefs objectForKey:@"wantsNested"] boolValue] ;

if((kEnabled)&&(kWantsNested)) {
arg1= TRUE;
return %orig(arg1);
}
return %orig;
}

-(void)setPinchToClose:(bool)arg1 {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
kWantsPinchToClose= [[prefs objectForKey:@"wantsPinchToClose"] boolValue] ;

kEnabled= [[prefs objectForKey:@"enabled"] boolValue] ;

if((kEnabled)&&(kWantsPinchToClose)) {
arg1= YES;
return %orig(arg1);
}
return %orig;
}
%end

/* This method changes corner radius of folder icons, but SNOWBOARD tweak and theme engine makes it not work.
works with ANEMONE still. */

%hook SBIconImageView
+(double)cornerRadius {
if((kEnabled)&&(kWantsCornerRadius)) {
return kIconCornerRadius;
}
return %orig; 
}

%end

%hook SBFolderView
-(bool)textFieldShouldReturn {
if(kHidesTitle) {
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

/* FROM runtime header, this fixes bug where folder splits to multiple
folders in landscape and loses dark BG. Keeps scrolling as way to see next page. */

-(BOOL)_shouldConvertToMultipleIconListsInLandscapeOrientation {
return NO;
}

-(bool) _tapToCloseGestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2 {
if((kEnabled)&&(kWantsTapToClose)) {
return YES;
%orig;
}
return %orig;
}

-(void)setBackgroundAlpha:(CGFloat)arg1 {

NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
kEnabled= [[prefs objectForKey:@"enabled"] boolValue] ;

kFloatyOpacityEnabled=
[[prefs objectForKey:@"floatyOpacityEnabled"] boolValue] ;

if((kEnabled)&&(kFloatyOpacityEnabled)) {
arg1= kFloatyOpacity / 100;
return %orig(arg1);
}
return %orig;
}
%end


%hook SBFolderControllerBackgroundView
-(BOOL) effectActive {
if((kEnabled)&&(kNoFX)) {
//removes blur
return FALSE;
}
return %orig;
}

-(BOOL)isReduceTransparencyEnabled {
if((kEnabled)&&(kReducedTransOn)) {
return TRUE;
//makes backgroundViews darker

}
return %orig;
}

-(void)setEffectActive:(BOOL)arg1 {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
kNoFX= [[prefs objectForKey:@"noFX"] boolValue] ;
if((kEnabled)&&(kNoFX)) {
arg1=  FALSE;
return %orig(arg1);
}
return %orig;
}
%end

/** NOT USING AT LEAST YET
-(NSUInteger) currentEffect {
if((kEnabled)&&(kPlainFX)) {
//learned conversion credit to stack exchange 
NSNumber *iAmNumber=@0;
NSUInteger iAmUnsigned = [iAmNumber unsignedIntegerValue];

return iAmUnsigned;

}
else if((kEnabled)&&(kUnknownFX)) {
NSNumber *iAmNumber=@2;
NSUInteger iAmUnsigned = [iAmNumber unsignedIntegerValue];

return iAmUnsigned;

}
else { return %orig; }
}
//%orig = 1
//NSUInt

%end
**/
// Playing with FX

%hook SBFolderBackgroundView
-(void)_setContinuousCornerRadius:(CGFloat)arg1 {
if((kEnabled)&&(kWantsCornerRadius)) {
arg1= kBackgroundFolderRadius;
return %orig(arg1);
}
return %orig;
}
//this is necessary for open folder radius changes
+(CGFloat)cornerRadiusToInsetContent {
if((kEnabled)&&(kWantsCornerRadius)) {
return kBackgroundFolderRadius;
}
return %orig;
}

%end 

%hook SBIconColorSettings
-(bool) blurryFolderIcons {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
 kFolderIconOpacityEnabled= [[prefs objectForKey:@"folderIconOpacityEnabled"] boolValue] ;

kEnabled= [[prefs objectForKey:@"enabled"] boolValue] ;

if((kEnabled)&&(kFolderIconOpacityEnabled)) {
return FALSE;

}
return %orig;
}

-(double) colorAlpha {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];

 kFolderIconOpacityEnabled= [[prefs objectForKey:@"folderIconOpacityEnabled"] boolValue] ;

kEnabled= [[prefs objectForKey:@"enabled"] boolValue] ;

if((kEnabled)&&(kFolderIconOpacityEnabled)) {
return kFolderIconOpacityColor/100;
}
return %orig;
}

-(double) whiteAlpha {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
 kFolderIconOpacityEnabled= [[prefs objectForKey:@"folderIconOpacityEnabled"] boolValue] ;

kEnabled= [[prefs objectForKey:@"enabled"] boolValue] ;

if((kEnabled)&&(kFolderIconOpacityEnabled)) {

return kFolderIconOpacityWhite/100;

}
return %orig;
}
%end

%hook SBFWallpaperSettings
-(bool) replaceBlurs {
NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
 kFolderIconOpacityEnabled= [[prefs objectForKey:@"folderIconOpacityEnabled"] boolValue] ;

kEnabled= [[prefs objectForKey:@"enabled"] boolValue] ;

if((kEnabled)&&(kFolderIconOpacityEnabled)) {
return TRUE;
}
return %orig;
}
%end

%hook SBApplicationPlaceholder
-(bool) iconAllowsLaunch:(id)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;

}
return %orig;
}
%end

%hook SBBookmark
-(bool) iconAllowsLaunch:(id)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end

%hook SBPolicyAggregator
-(bool) allowsCapability:(long long)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end

%hook SBPolicyAggregator
-(bool) allowsTransitionRequest:(id)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end

%hook SBIconListModel
-(bool) allowsAddingIcon:(id)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end


%hook SBStarkIconListModel
-(bool) allowsAddingIcon:(id)arg1 {

if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end

%hook SBIconModel
-(void) setAllowsSaving:(bool)arg1 {
if((kEnabled)&&(kWantsNested)) {
arg1 = TRUE;
return %orig(arg1);

}
return %orig;
}

-(bool) allowsSaving {
if((kEnabled)&&(kWantsNested)) {

return TRUE;
}
return %orig;
}
%end

%hook SBApplication
-(bool) iconAllowsLaunch:(id)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end

%hook SBSpringBoardApplicationIcon
-(bool) iconAllowsLaunch:(id)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end

%hook SBStarkIconController
-(bool) iconAllowsLaunch:(id)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end

%hook SBIconView
-(bool) allowsTapWhileEditing {
if((kEnabled)&&(kWantsNested)) {
return TRUE;
}
return %orig;
}
%end

%hook SBFolderIconView
-(bool) allowsTapWhileEditing {
if((kEnabled)&&(kWantsNested)) {
return TRUE;
}
return %orig;
}
%end

%hook SBFolderController
-(bool) _allowUserInteraction {
if((kEnabled)&&(kWantsNested)) {
return TRUE;
}
return %orig;
}
%end

%hook SBPolicyAggregator
-(bool) _allowsCapabilitySpotlightWithExplanation:(id*)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end


%hook SBFolderTitleTextField
-(void) setAllowsEditing:(bool)arg1 {
if((kEnabled)&&(kWantsNested)) {
arg1 = TRUE;
return %orig(arg1);
}
return %orig;
}
%end

%hook SBIconListModel
-(bool) addIcon:(id)arg1 {
if((kEnabled)&&(kWantsNested)) {
%orig;
return TRUE;
}
return %orig;
}
%end



 %hook SBFolderIconListView
+(unsigned long long) maxVisibleIconRowsInterfaceOrientation:(long long)arg1 {
if((kEnabled)&&(kCustomLayout)) {
 %orig;
return kCustomRows;
}

return %orig;
}

%end

%hook SBFolderIconListView
+(unsigned long long) iconColumnsForInterfaceOrientation:(long long)arg1 {

if((kEnabled)&&(kCustomLayout)) {

 %orig;
return kCustomColumns;
}

return %orig;
}
%end

/**  Custom inset tweaking relative to original insets determined by number of icons per row or column **/
%hook SBFolderIconListView
-(double) bottomIconInset {
if((kEnabled) && (kWantsCustomInsets)) {
double IconInset = %orig;
IconInset = IconInset - (IconInset * kBottomInset);
return IconInset;


}
return %orig;
}
%end

%hook SBFolderIconListView
-(double) sideIconInset {
if((kEnabled) && (kWantsCustomInsets)) {
double IconInset = %orig;
IconInset = IconInset - (IconInset *kSideInset);
return IconInset;
}
return %orig;
}
%end

%hook SBFolderIconListView
-(double) topIconInset {
if((kEnabled) && (kWantsCustomInsets)) {
double IconInset = %orig;
IconInset = IconInset - (IconInset *kTopInset);
return IconInset;
}
return %orig;
}
%end


static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
    if(prefs)
    {
kEnabled = ( [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : NO );

kWantsCustomInsets = ( [prefs objectForKey:@"wantsCustomInsets"] ? [[prefs objectForKey:@"wantsCustomInsets"] boolValue] : NO );

kCustomLayout =   ( [prefs objectForKey:@"customLayout"] ? [[prefs objectForKey:@"customLayout"] boolValue] : NO );

kCustomColumns = ([prefs objectForKey:@"customColumns"] ? [[prefs objectForKey:@"customColumns"] doubleValue] : kCustomColumns);

kCustomRows = ([prefs objectForKey:@"customRows"] ? [[prefs objectForKey:@"customRows"] doubleValue] : kCustomRows);

kFloatyOpacityEnabled =  ( [prefs objectForKey:@"floatyOpacityEnabled"] ? [[prefs objectForKey:@"floatyOpacityEnabled"] boolValue] : NO );


kFloatyOpacity = ([prefs objectForKey:@"floatyOpacity"] ? [[prefs objectForKey:@"floatyOpacity"] floatValue] : kFloatyOpacity);

kFolderIconOpacityWhite = ([prefs objectForKey:@"folderIconOpacityWhite"] ? [[prefs objectForKey:@"folderIconOpacityWhite"] doubleValue] : kFolderIconOpacityWhite);

kFolderIconOpacityColor = ([prefs objectForKey:@"folderIconOpacityColor"] ? [[prefs objectForKey:@"folderIconOpacityColor"] doubleValue] : kFolderIconOpacityColor);


kFolderIconOpacityEnabled = ( [prefs objectForKey:@"folderIconOpacityEnabled"] ? [[prefs objectForKey:@"folderIconOpacityEnabled"] boolValue] : NO );

kWantsCornerRadius =  ( [prefs objectForKey:@"iconCornerRadiusEnabled"] ? [[prefs objectForKey:@"iconCornerRadiusEnabled"] boolValue] : NO );

kIconCornerRadius = ([prefs objectForKey:@"iconCornerRadius"] ? [[prefs objectForKey:@"iconCornerRadius"] doubleValue] : kIconCornerRadius);


kWantsTapToClose = ( [prefs objectForKey:@"wantsTapToClose"] ? [[prefs objectForKey:@"wantsTapToClose"] boolValue] : NO );


kWantsPinchToClose = ( [prefs objectForKey:@"wantsPinchToClose"] ? [[prefs objectForKey:@"wantsPinchToClose"] boolValue] : NO );

kWantsNested = ( [prefs objectForKey:@"wantsNested"] ? [[prefs objectForKey:@"wantsNested"] boolValue] : NO );



kBackgroundFolderRadius = ([prefs objectForKey:@"backgroundFolderRadius"] ? [[prefs objectForKey:@"backgroundFolderRadius"] floatValue] : kBackgroundFolderRadius);

kHidesTitle = ([prefs objectForKey:@"hidesTitle"] ? [[prefs objectForKey:@"hidesTitle"] boolValue] : NO);

kPlainFX=([prefs objectForKey:@"plainFX"] ? [[prefs objectForKey:@"plainFX"] boolValue] : NO);

kNoFX= ([prefs objectForKey:@"noFX"] ? [[prefs objectForKey:@"noFX"] boolValue] : NO);

kReducedTransOn= ([prefs objectForKey:@"reducedTransOn"] ? [[prefs objectForKey:@"reducedTransOn"] boolValue] : NO);

 kTopInset = ([prefs objectForKey:@"topInset"] ? [[prefs objectForKey:@"topInset"] floatValue] : kTopInset);

 kBottomInset = ([prefs objectForKey:@"bottomInset"] ? [[prefs objectForKey:@"bottomInset"] floatValue] : kBottomInset);

 kSideInset = ([prefs objectForKey:@"sideInset"] ? [[prefs objectForKey:@"sideInset"] floatValue] : kSideInset);
/*
kUnknownFX= ([prefs objectForKey:@"UnknownFX"] ? [[prefs objectForKey:@"UnknownFX"] boolValue] : NO);
*/
//plainFX is same as making inactive, havent tested unknown was curious 
//neither plainFX OR unknownFx are in prefs
}
[prefs release];
}

%ctor
{
CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.i0stweak3r.foldercontroller-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
loadPrefs();
}


