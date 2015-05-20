//
//  AddViewController.h
//  PListManager
//
//  Created by Hipolito Arias on 20/5/15.
//  Copyright (c) 2015 Hipolito Arias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnBoy;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;

@property (weak, nonatomic) IBOutlet UITextField *fieldName;
@property (weak, nonatomic) IBOutlet UITextField *filedSurname;
@property (weak, nonatomic) IBOutlet UITextField *fieldAge;

- (IBAction)tapBoy:(id)sender;
- (IBAction)tapFemale:(id)sender;
- (IBAction)tapMale:(id)sender;

@end
