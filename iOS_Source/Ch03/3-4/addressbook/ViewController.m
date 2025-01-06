//
//  ViewController.m
//  addressbook
//
//  Created by Yoshitaka Yamashita on 3/16/14.
//  Copyright (c) 2014 Yoshitaka Yamashita. All rights reserved.
//

#import "ViewController.h"

// 各セクションを表すenumを宣言
typedef NS_ENUM(NSInteger, SectionType) {
    SectionTypeName,
    SectionTypePhoneNumbers,
    SectionTypeEmails,
};

// ABPeoplePickerNavigationControllerDelegateへの準拠を宣言
@interface ViewController () <ABPeoplePickerNavigationControllerDelegate>
// 選択した連絡先を保持するプロパティを宣言
@property(strong, nonatomic) ABRecordRef __attribute__((NSObject)) person;
@end

@implementation ViewController

- (IBAction)performContactsButtonAction:(id)sender
{
    ABPeoplePickerNavigationController *controller = [[ABPeoplePickerNavigationController alloc] init];
    controller.peoplePickerDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

// ABPeoplePickerNavigationControllerでキャンセルを押した時の処理
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

// ABPeoplePickerNavigationControllerで１つの連絡先を選んだ時に、
// デフォルトの処理（連絡先の詳細を表示してプロパティを選ぶ）を行うかどうかを返す
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    // 選択した連絡先をプロパティに保持し、テーブルビューを更新
    self.person = person;
    [self.tableView reloadData];
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

// ABPeoplePickerNavigationControllerで１つのプロパティ（電話番号やメールアドレス等）を選んだ時に、
// デフォルトの処理（電話をかける、新規メール作成画面に遷移する等）を行うかどうかを返す
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.person ? 3 : 0;
}

// 指定したプロパティ（電話番号やメールアドレス）が何件あるかを返す
- (NSInteger)numberOfValuesOfProperty:(ABPropertyID)property
{
    ABPropertyType type = ABPersonGetTypeOfProperty(property);
    if (type & kABMultiValueMask) {
        CFTypeRef multiValue = ABRecordCopyValue(self.person, property);
        CFIndex count = ABMultiValueGetCount(multiValue);
        CFRelease(multiValue);
        
        return count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch ((SectionType)section) {
        case SectionTypeName:
            return 1;
            
        case SectionTypeEmails:
            return [self numberOfValuesOfProperty:kABPersonEmailProperty];
            
        case SectionTypePhoneNumbers:
            return [self numberOfValuesOfProperty:kABPersonPhoneProperty];
    }
}

// 指定したプロパティの指定したインデックスで示される値を取得
- (id)valueOfProperty:(ABPropertyID)property index:(CFIndex)index
{
    ABPropertyType type = ABPersonGetTypeOfProperty(property);
    if (type & kABMultiValueMask) {
        CFTypeRef multiValue = ABRecordCopyValue(self.person, property);
        CFTypeRef value = ABMultiValueCopyValueAtIndex(multiValue, index);
        CFRelease(multiValue);
        
        return (__bridge_transfer id)value;
    } else {
        return (__bridge_transfer id)ABRecordCopyValue(self.person, property);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCell"];
    
    NSString *value;
    switch ((SectionType)indexPath.section) {
        case SectionTypeName:
            value = (__bridge_transfer NSString *)ABRecordCopyCompositeName(self.person);
            break;
            
        case SectionTypeEmails:
            value = [self valueOfProperty:kABPersonEmailProperty index:indexPath.row];
            break;
            
        case SectionTypePhoneNumbers:
            value = [self valueOfProperty:kABPersonPhoneProperty index:indexPath.row];
            break;
    }
    
    cell.textLabel.text = value;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch ((SectionType)section) {
        case SectionTypeName:
            return @"名前";
            
        case SectionTypeEmails:
            return @"メールアドレス";
            
        case SectionTypePhoneNumbers:
            return @"電話番号";
    }
}

@end
