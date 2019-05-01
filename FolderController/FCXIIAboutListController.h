#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <notify.h>
#import <Social/Social.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAboutListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>


@interface FCXIIAboutListController : HBAboutListController
- (void)love;
-(void)loadView;
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section;
- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section;
-(void)viewWillAppear:(BOOL)animated;
@end