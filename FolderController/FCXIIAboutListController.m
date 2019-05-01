#import "FCXIIAboutListController.h"
#import "PSHeaderFooterView.h"

@implementation FCXIIAboutListController

- (instancetype)init {
    self = [super init];
if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];

     appearanceSettings.tintColor =  [UIColor colorWithRed: 1.0 green: 0.5 blue: 0.01 alpha: 1.0];

appearanceSettings.statusBarTintColor = [UIColor yellowColor];
        
appearanceSettings.navigationBarTintColor = [UIColor colorWithRed: 1.0 green: 0.5 blue: 0.01 alpha: 1.0];

appearanceSettings.tableViewCellSeparatorColor = [UIColor colorWithWhite:0 alpha:0.8];
/**
appearanceSettings.navigationBarTitleColor = [UIColor colorWithRed: .80 green: .80 blue: 1.0 alpha: 1];
**/
appearanceSettings.tableViewCellBackgroundColor = [UIColor colorWithRed: .12 green: .12 blue: .3 alpha:1];

appearanceSettings.tableViewCellTextColor = [UIColor colorWithRed: .80 green: .80 blue: 1.0 alpha: 1];


appearanceSettings.tableViewCellSelectionColor = [UIColor redColor];

appearanceSettings.tableViewBackgroundColor =
[UIColor colorWithRed: 0.f green: 0.f blue: 0.2f alpha:0.2];

appearanceSettings.navigationBarBackgroundColor = [UIColor colorWithRed: .12 green: .12 blue: .3 alpha:0.85];

        self.hb_appearanceSettings = appearanceSettings;
    }
return self;
}

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


- (void)love
{
	SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
	[twitter setInitialText:@"I’m using #FolderControllerXII by @BrianVS Available in Cydia for all devices from iOS 11-12.1.2."];
	if (twitter != nil) {
		[[self navigationController] presentViewController:twitter animated:YES completion:nil];
	}
}

-(void)viewWillAppear:(BOOL)animated {
// [self reload];

[super viewWillAppear:animated];
CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.translucent = YES;
}


-(void)loadView 
{
	[super loadView];


UIImage *heart = [[UIImage alloc] initWithContentsOfFile:[[self bundle] pathForResource:@"Heart" ofType:@"png"]];
UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
[button setBackgroundImage:heart forState:UIControlStateNormal];
[button addTarget:self action:@selector(love) forControlEvents:UIControlEventTouchUpInside];
button.adjustsImageWhenHighlighted = YES;

UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:button];

rightButton.tintColor = [UIColor colorWithRed:1
                                               green:0.22
                                                blue:0.15
                                               alpha:1];
    self.navigationItem.rightBarButtonItem=rightButton;

}


+ ( NSString *)hb_supportEmailAddress {
NSString *addy = @"djvs23@icloud.com"; return addy;
}




+ (NSString *)hb_specifierPlist {
	return @"About";
}



@end