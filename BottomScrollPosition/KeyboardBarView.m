//
//  KeyboardBarView.m
//  BottomScrollPosition
//
//  Created by Brian Mancini on 9/28/14.
//  Copyright (c) 2014 iOSExamples. All rights reserved.
//

#import "KeyboardBarView.h"

@interface KeyboardBarView()

@property (nonatomic) bool hasConstraints;
@property (strong, nonatomic) UITextField *textField;


@end

@implementation KeyboardBarView

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.frame = CGRectMake(0, 0, 340, 41);
        self.backgroundColor = [UIColor colorWithRed:215.0f/255.0 green:215.0f/255.0 blue:215.0f/255.0 alpha:1.0];
        
        // create the textbox
        self.textField = [[UITextField alloc]init];
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.layer.masksToBounds = true;
        self.textField.layer.cornerRadius = 6.0f;
        [self addSubview:self.textField];
    }
    return self;
}

- (void) updateConstraints
{
    if(!self.hasConstraints) {
        self.hasConstraints = true;
        
        NSDictionary *views =
        @{
          @"textField": self.textField
        };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[textField]-6-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[textField]-6-|" options:0 metrics:nil views:views]];
    }
    [super updateConstraints];
}

#pragma mark - Instance Methods

- (void)dismissKeyboard
{
    [self.textField resignFirstResponder];
}


@end
