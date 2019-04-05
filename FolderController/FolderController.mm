#import <spawn.h>
#import <objc/runtime.h>
#include <CSColorPicker/CSColorPicker.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <UIKit/UIKit.h>
#import <notify.h>
#import <Social/Social.h>

@interface FolderControllerListController: PSListController 

-(void)respring:(id)sender;
-(void)twitter;
-(void)Paypal;
-(void)addMyRepo;
-(void)myOtherTweaks;
-(void)resetPrefs:(id)sender;
- (void)love;
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section;

@end

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface PSSwitchTableCell : PSControlTableCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier;
@end

@interface SRSwitchTableCell : PSSwitchTableCell
@end

@implementation SRSwitchTableCell

-(id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier { 
//init method

	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier]; 
//call the super init method
	
if (self) {
		[((UISwitch *)[self control]) setOnTintColor:[UIColor blueColor]]; 


	}
	return self;
}

@end


@implementation FolderControllerListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"FolderController" target:self];
	}
	return _specifiers;
}

- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}



- (void)twitter {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=brianvs"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=brianvs"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/brianvs"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/brianvs"]];
    }  else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/brianvs"]];
    }
}

- (void)indieDevTwitter {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=indiedevkb"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=indiedevkb"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/indiedevkb"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/indiedevkb"]];
    }  else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/indiedevkb"]];
    }
}

-(void)myOtherTweaks 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://apt.thebigboss.org/developer-packages.php?dev=i0stweak3r"]];
}

-(void)addMyRepo {
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://i0s-tweak3r-betas.yourepo.com"]];
}

- (void)Paypal
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/i0stweak3r"]];
}

- (void)love
{
	SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
	[twitter setInitialText:@"#FolderControllerXII by @BrianVS is awesome! New update hosted by @YouRepo http://i0s-tweak3r-betas.yourepo.com Also coming soon to a default repo near you. iOS 11-12.1.2."];
	if (twitter != nil) {
		[[self navigationController] presentViewController:twitter animated:YES completion:nil];
	}
}

- (void) loadView
{
	[super loadView];

 UIBarButtonItem *defaultsButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset Prefs" style:UIBarButtonItemStylePlain target:self action:@selector(resetPrefs:)];


defaultsButton.tintColor = [UIColor colorWithRed:1
                                               green:0.22
                                                blue:0.15
                                               alpha:1];

UIImage *heart = [[UIImage alloc] initWithContentsOfFile:[[self bundle] pathForResource:@"Heart" ofType:@"png"]];
UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
[button setBackgroundImage:heart forState:UIControlStateNormal];
[button addTarget:self action:@selector(love) forControlEvents:UIControlEventTouchUpInside];
button.adjustsImageWhenHighlighted = NO;

UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:button];


    self.navigationItem.rightBarButtonItems=@[defaultsButton, rightButton];
}
	/* Header banner code learned from IndieDevKB’s GitHub */

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat headerHeight = 140;
        CGFloat tableWidth =
        [[UIApplication sharedApplication] keyWindow].frame.size.width;
        
        UIImage *headerImage = [UIImage
                                imageWithContentsOfFile:@"/Library/PreferenceBundles/"
                                @"FolderController.bundle/headerImage.png"];
        
        UIImageView *headerImageView = [[UIImageView alloc]
                                        initWithFrame:CGRectMake(0, 0, tableWidth, headerHeight)];
        
        headerImageView.image = headerImage;
        [headerImageView setClipsToBounds:YES];
        [headerImageView.layer setMasksToBounds:YES];
        
        return headerImageView;
    } else {
        return [super tableView:tableView viewForHeaderInSection:section];
    }
}



- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 140;
    } else {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}

- (void)resetPrefs:(id)sender {

UIAlertController *alertWarning = [UIAlertController
                alertControllerWithTitle:@"Reset to Defaults"
                                 message:@"Warning, this will delete all your currently saved settings, and respring. Are you sure you want to proceed?"
                          preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction* yesButton = [UIAlertAction
                    actionWithTitle:@"Yes, please"
                              style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action) {
                                //Handle yes action
NSString *appDomain = @"com.i0stweak3r.foldercontroller";
[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
   
    [self respring:sender];
                            }];

UIAlertAction* noButton = [UIAlertAction
                        actionWithTitle:@"No, thanks"
                                  style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                   //Handle no, thanks                
                                }];



[alertWarning addAction:yesButton];
[alertWarning addAction:noButton];

[self presentViewController:alertWarning animated:YES completion:nil];

}

@end

// vim:ft=objc
