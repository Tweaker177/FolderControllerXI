#define PLIST_PATH @"/var/mobile/Library/Preferences/com.i0stweak3r.foldercontroller.plist"

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
 
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
static bool kUnknownFX= YES;
static bool kReducedTransOn = YES;
static double kCustomRows= 3.f;
static double kCustomColumns= 3.f;

static bool kCustomLayout = YES;

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

%hook SBIconImageView
+(double)cornerRadius {
if((kEnabled)&&(kWantsCornerRadius)) {
return kIconCornerRadius;
}
return %orig; 
}

%end

%hook SBFloatyFolderView
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
/**
This fades home screen like iOS 9 but need to connect to method or events to turn on/off, by itself it stays on 

%hook SBFolderController
-(void) _setHomescreenAndDockAlpha:(double)arg1 {
if(kNoFX) {
arg1= 0.2f;
return %orig;
}
return %orig;
}
%end

%hook SBFolderController
-(bool) _homescreenAndDockShouldFade {
if(kNoFX) {
return YES;
}
return %orig;
}
%end
**/
%hook SBFolderControllerBackgroundView
-(BOOL) effectActive {
if((kEnabled)&&(kNoFX)) {
return FALSE;
}
return %orig;
}

-(BOOL)isReduceTransparencyEnabled {
if((kEnabled)&&(kReducedTransOn)) {
return TRUE;
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
return %orig;
}
return %orig;
}
%end

%hook SBIconModel
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

 /**
UNUSED CRAP

%hook SBPrototypeController
-(bool) _hasPreviousSettings {
return %orig;
}
%end

%hook SBPrototypeController
-(bool) _restorePreviousSettings {
return %orig;
}
%end

%hook SBPrototypeController
-(bool) isPrototypingEnabled {
return %orig;
}
%end

%hook SBPrototypeController
-(bool) isShowingSettingsUI {
return %orig;
}
%end

%hook SBIconPreviousLocationTracker
-(void) captureLocationInfoForIcon:(id)arg1 inModel:(id) {
return %orig;
}
%end

%hook SBIconPreviousLocationTracker
-(id) previousLocationInfoForIcon:(id)arg1 {
return %orig;
}
%end

%hook SBIconPreviousLocationTracker
-(id) iconModel {
return %orig;
}
%end





****/
//Just added next two methods

%hook SBPolicyAggregator
-(bool) _allowsCapabilityHomeScreenEditingWithExplanation:(id*)arg1 {
if((kEnabled)&&(kCustomLayout)) {
return TRUE;
%orig;
}
return %orig;
}
%end

%hook SBFolderController
-(void) layoutIconLists:(double)arg1 domino:(bool)arg2 forceRelayout:(bool)arg3 {
if((kEnabled)&&(kCustomLayout)) {
arg3= YES;
return %orig;
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

/**
%hook SBFolderIconListView
-(double) bottomIconInset {
if(kCustomLayout) {
return 10.f;
}
return %orig;
}
%end

%hook SBFolderIconListView
-(double) sideIconInset {
if(kCustomLayout) {
return 10.f;
}
return %orig;
}
%end

%hook SBFolderIconListView
-(double) topIconInset {
if(kCustomLayout) {
return 10.f;
}
return %orig;
}
%end
**/

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
    if(prefs)
    {
kEnabled = ( [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : NO );

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

kPlainFX=([prefs objectForKey:@"plainFX"] ? [[prefs objectForKey:@"plainFX"] boolValue] : NO);

kNoFX= ([prefs objectForKey:@"noFX"] ? [[prefs objectForKey:@"noFX"] boolValue] : NO);

kReducedTransOn= ([prefs objectForKey:@"reducedTransOn"] ? [[prefs objectForKey:@"reducedTransOn"] boolValue] : NO);

kUnknownFX= ([prefs objectForKey:@"UnknownFX"] ? [[prefs objectForKey:@"UnknownFX"] boolValue] : NO);

/**
kpickedRadius = ([prefs objectForKey:@"pickedRadius"] ? [[prefs objectForKey:@"pickedRadius"] floatValue] : kpickedRadius);

kContinuousControl=([prefs objectForKey:@"continuousControl"] ? [[prefs objectForKey:@"continuousControl"] doubleValue] : kContinuousControl); 

kExtraViewsRadius = ([prefs objectForKey:@"extraViewsRadius"] ? [[prefs objectForKey:@"extraViewsRadius"] floatValue] : kExtraViewsRadius);
**/
}
[prefs release];
}

%ctor
{
CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.i0stweak3r.foldercontroller-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
loadPrefs();
}


