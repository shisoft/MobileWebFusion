//
//  SWFContactDetailsViewController.m
//  webfusion
//
//  Created by Jack Shi on 13-7-18.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFContactDetailsViewController.h"
#import "SWFUserContact.h"
#import "SWFAvatarHelper.h"
#import "SWFUniversalContact.h"
#import "UIImage+SWFUtilities.h"
#import "SWFGetContactDetailsRequest.h"
#import "SWFUserContactMethod.h"
#import "SWFUserContactGroup.h"
#import "SWFUserContactDetails.h"
#import "SWFWrapper.h"
#import "SWFUpdateUserContactMethodOrderRequest.h"
#import "SWFDeleteContactFromIDRequest.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "SWFAddContactViewController.h"
#import "SWFUserContactPickerViewController.h"
#import "SWFCombineContactRequest.h"
#import "SWFRenameUserContactRequest.h"
#import "SWFDeleteUserContactRequest.h"
#import "SWFComposeTopicViewController.h"
#import "TITokenField.h"
#import "SWFContactNewsViewController.h"

@interface SWFContactDetailsViewController ()

@end

@implementation SWFContactDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"ui.contactDetails", @"")];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ui.edit", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}

- (void)edit{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing) {
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"ui.done", @"");
    } else {
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleBordered];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"ui.edit", @"");
    }
}

- (void)loadUserContact : (SWFUserContact*) uc{
    self.userContact = uc;
    [self.tableView reloadData];
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SWFGetContactDetailsRequest *r = [[SWFGetContactDetailsRequest alloc] init];
        r.ID = uc.ID;
        SWFWrapper *rv = [r getContactDatails];
        if ([rv isKindOfClass:[SWFWrapper class]]){
            SWFUserContactDetails *d = [rv objectValueWithClass:[SWFUserContactDetails class]];
            self.contactMethods = d.ucls;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if ([self.contactMethods count] > 1) {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                }
            });
        }
    });
}

- (IBAction)addButtonPressed:(id)sender {
    SWFAddContactViewController *acvc = [[SWFAddContactViewController alloc] init];
    [self presentViewController:acvc animated:YES completion:nil];
    [acvc staticName:self.userContact.name UITitle:NSLocalizedString(@"ui.addContactMethod",@"")];
}

- (IBAction)combineButtonPressed:(id)sender {
    SWFUserContactPickerViewController *picker = [[SWFUserContactPickerViewController alloc] initWithNibName:@"SWFUserContactPickerViewController" bundle:nil];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nc animated:YES completion:nil];
    [picker loadContactsFromSource:0 exceptionIDs:[NSArray arrayWithObjects:self.userContact, nil] callback:^(id _uc) {
        SWFUserContact *uc = _uc;
        SWFCombineContactRequest *r = [[SWFCombineContactRequest alloc] init];
        r.oid = self.userContact.ID;
        r.nid = uc.ID;
        [r combineContact];
        UINavigationController *nc = self.navigationController;
        [nc popToRootViewControllerAnimated:YES];
        SWFContactDetailsViewController *cdvc = [[SWFContactDetailsViewController alloc] initWithNibName:@"SWFContactDetailsViewController" bundle:nil];
        [nc pushViewController:cdvc animated:YES];
        [cdvc loadUserContact:_uc];
    } title:NSLocalizedString(@"ui.combineContactTo", @"")];
}

- (IBAction)renameButtonPressed:(id)sender {
    __block UIAlertView *alert = [UIAlertView initAlertViewWithTitle:nil message:NSLocalizedString(@"ui.renameUserContact", @"") cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"ui.ok", @""), nil] onDismiss:^(int buttonIndex) {
        NSString *name = [alert textFieldAtIndex:0].text;
        SWFRenameUserContactRequest *r = [[SWFRenameUserContactRequest alloc] init];
        r.name = name;
        r.ID = self.userContact.ID;
        [r renameUserContact];
        self.userContact.name = name;
        [self.tableView reloadData];
    } onCancel:^{
        
    }];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert textFieldAtIndex:0].text = self.userContact.name;
}

- (IBAction)removeButtonPressed:(id)sender {
    __block UIAlertView *alert = [UIAlertView initAlertViewWithTitle:nil message:NSLocalizedString(@"ui.confirmDeleteUserContact", @"") cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") otherButtonTitles:[[NSArray alloc] initWithObjects:NSLocalizedString(@"ui.ok", @""), nil] onDismiss:^(int buttonIndex) {
        SWFDeleteUserContactRequest *r = [[SWFDeleteUserContactRequest alloc] init];
        r.ID = self.userContact.ID;
        [r deleteUserContact];
        [self.navigationController popViewControllerAnimated:YES];
    } onCancel:^{
        
    }];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return self.contactMethods.count;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *avatarCellIdentifier = @"avatarCellIdentifier";
    static NSString *contactNewsCellIdentifier = @"contactNewsCellIdentifier";
    static NSString *contactMethodIdentifier = @"contactMethodIdentifier";
    UITableViewCell *cell;
    NSString *cellIdentifier;
    switch (indexPath.section) {
        case 0:
            cellIdentifier = avatarCellIdentifier;
            break;
        case 1:
            cellIdentifier = contactNewsCellIdentifier;
        case 2:
            cellIdentifier = contactMethodIdentifier;
        default:
            break;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        if (indexPath.section != 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.showsReorderControl = YES;
        }
    }
    switch (indexPath.section) {
        case 0:
            self.avatarView = cell.imageView;
            cell.textLabel.text = self.userContact.name;
            if (self.avatarImage == nil){
                self.avatarImage = [UIImage imageNamed:@"default-user"];
                self.avatarImage = [self.avatarImage scaledImageToSize:CGSizeMake(128, 128)];
                self.avatarImage = [SWFAvatarHelper displayAvatar:self.userContact.avatar.avatar callback:^(id img){
                    self.avatarImage = img;
                    self.avatarView.image = self.avatarImage;
                } roundCorner:YES size:CGSizeMake(128, 128)];
                self.avatarView.image = self.avatarImage;
            } else {
                cell.imageView.image = self.avatarImage;
            }
            break;
        case 1:
        {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            NSString *feature;
            cell.userInteractionEnabled = NO;
            cell.textLabel.alpha = 0.439216f; // (1 - alpha) * 255 = 143
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"ui.contactNews", @"");
                    feature = @"HasNews";
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"ui.postToContact", @"");
                    feature = @"CanPost";
                    break;
                default:
                    break;
            }
            dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([[SWFAppDelegate getDefaultInstance] hasFeature:feature ucid:self.userContact.ID]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.userInteractionEnabled = YES;
                        cell.textLabel.alpha = 1; // (1 - alpha) * 255 = 143
                    });
                }
            });
        }
            break;
        case 2:
        {
            SWFUserContactMethod *cm = [self.contactMethods objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:cm.svr.gate];
            cell.textLabel.text = cm.uc.dispName;
            if (![cm.uc.scrName isEqualToString:cm.uc.dispName] && [cm.uc.scrName length]) {
                cell.detailTextLabel.text = cm.uc.scrName;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 64;
            break;
        case 2:
            return 55;
        default:
            return 45;
            break;
    }
}

- (BOOL) tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.contactMethods count] < 2){
        return NO;
    }
    return indexPath.section == 2;
}

- (BOOL) tableView:(UITableView *) tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.contactMethods count] < 2){
        return NO;
    }
    return indexPath.section == 2;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *ncmArr = [[NSMutableArray alloc] initWithCapacity:[self.contactMethods count]];
        for (NSUInteger i = 0;i < [self.contactMethods count]; i++){
            if (i == sourceIndexPath.row) {
                [ncmArr addObject:[self.contactMethods objectAtIndex:destinationIndexPath.row]];
            }else if (i == destinationIndexPath.row){
                [ncmArr addObject:[self.contactMethods objectAtIndex:sourceIndexPath.row]];
            }else {
                [ncmArr addObject:[self.contactMethods objectAtIndex:i]];
            }
        }
        self.contactMethods = [[NSArray alloc] initWithArray:ncmArr];
        NSMutableArray *rArr = [[NSMutableArray alloc] initWithCapacity:[ncmArr count]];
        for (SWFUserContactMethod *cm in ncmArr){
            [rArr addObject:cm.uc.ID];
        }
        SWFUpdateUserContactMethodOrderRequest *r = [[SWFUpdateUserContactMethodOrderRequest alloc] init];
        r.ID = self.userContact.ID;
        r.ucids = rArr;
        [r updateUserContactMethodOrder];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadUserContact:self.userContact];
        });
    });
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        SWFUserContactMethod *cm = [self.contactMethods objectAtIndex:indexPath.row];
        NSString *svr;
        NSString *svr_local_name = [NSString stringWithFormat:@"svr.%@", cm.uc.svr];
        svr = NSLocalizedString(svr_local_name, @"");
        [UIAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"ui.confirmDeleteContactMethod", @""), svr] cancelButtonTitle:NSLocalizedString(@"ui.cancel", @"") otherButtonTitles:[NSArray arrayWithObjects:NSLocalizedString(@"ui.ok", @""), nil] onDismiss:^(int buttonIndex) {
            dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SWFDeleteContactFromIDRequest *r = [[SWFDeleteContactFromIDRequest alloc] init];
                r.cid = self.userContact.ID;
                r.ucid = cm.ID;
                NSMutableArray *ncmArr = [[NSMutableArray alloc] initWithArray:self.contactMethods];
                [ncmArr removeObject:cm];
                self.contactMethods = ncmArr;
                 dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     [r deleteContactFromID];
                 });
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
                    if (self.contactMethods.count < 2){
                        tableView.editing = YES;
                        [self edit];
                        [self.navigationItem.rightBarButtonItem setEnabled:NO];
                    }
                });
            });
            
        } onCancel:nil];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if( sourceIndexPath.section != proposedDestinationIndexPath.section )
    {
        return sourceIndexPath;
    }
    else
    {
        return proposedDestinationIndexPath;
    }
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 1;
}

- (void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                SWFContactNewsViewController *cnvc = [[SWFContactNewsViewController alloc] init];
                cnvc.uc = self.userContact;
                [self.navigationController pushViewController:cnvc animated:YES];
            }
                break;
            case 1:
            {
                SWFComposeTopicViewController *ctvc = [[SWFComposeTopicViewController alloc] init];
                UINavigationController *navvc = [[UINavigationController alloc] initWithRootViewController:ctvc];
                [self presentViewController:navvc animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [ctvc._tokenFieldView.tokenField addTokenWithTitle:self.userContact.name];
                    [ctvc._tokenFieldView.tokenField layoutTokensAnimated:YES];
                });
            }
                break;
            default:
                break;
        }
    }
}

@end
