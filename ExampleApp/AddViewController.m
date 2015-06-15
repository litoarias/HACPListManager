
//
//  AddViewController.m
//  PListManager
//
//  Created by Hipolito Arias on 20/5/15.
//  Copyright (c) 2015 Hipolito Arias. All rights reserved.
//

#import "AddViewController.h"
#import "HACPlistManager.h"

#define kFileName @"users.plist"

@interface AddViewController (){
    UIImage* selectedImage;
}

- (IBAction)tapAdd:(id)sender;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnBoy.layer.opacity = .5;
    self.btnFemale.layer.opacity = .5;
    self.btnMale.layer.opacity = .5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




# pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

# pragma mark - IBActions

- (IBAction)tapAdd:(id)sender {
    NSLog(@"Add object");
    [self insertObject];
}

- (IBAction)tapBoy:(id)sender {
    self.btnBoy.layer.opacity = 1;
    self.btnFemale.layer.opacity = .5;
    self.btnMale.layer.opacity = .5;
    selectedImage = [UIImage imageNamed:@"boy"];
}

- (IBAction)tapFemale:(id)sender {
    self.btnBoy.layer.opacity = .5;
    self.btnFemale.layer.opacity = 1;
    self.btnMale.layer.opacity = .5;
    selectedImage = [UIImage imageNamed:@"female"];
}

- (IBAction)tapMale:(id)sender {
    self.btnBoy.layer.opacity = .5;
    self.btnFemale.layer.opacity = .5;
    self.btnMale.layer.opacity = 1;
    selectedImage = [UIImage imageNamed:@"male"];
}


# pragma MARK - PRIVATE METHODS

- (void) insertObject{
    
    if (self.fieldAge.text.length     > 0 &&
        self.fieldName.text.length    > 0 &&
        self.filedSurname.text.length > 0 &&
        selectedImage)
    {
        // Add object image
        NSDictionary *object = @{@"name"    : self.fieldName.text,
                                 @"surname" : self.filedSurname.text,
                                 @"age"     : self.fieldAge.text,
                                 kImage     : selectedImage};
        
        
        [HACPlistManager insertObjectWithData:object fileName:kFileName];
        
    }
    else
    {
        // No add
        [[[UIAlertView alloc]initWithTitle:@"Error" message:@"All fields it's required." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    }
}

@end
