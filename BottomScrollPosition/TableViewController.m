//
//  TableViewController.m
//  BottomScrollPosition
//
//  Created by Brian Mancini on 9/28/14.
//  Copyright (c) 2014 iOSExamples. All rights reserved.
//

#import "TableViewController.h"
#import "KeyboardBarView.h"
#import "UITableView+ScrollHelpers.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) KeyboardBarView *keyboardBar;

@end

@implementation TableViewController


-(void)loadView
{
    [super loadView];
    
    // Set the title
    self.title = @"Scroll To Bottom";
    
    // Prevent cell selection because we don't need it in this table...
    self.tableView.allowsSelection = false;
    
    // Add gesture recognizer to dismiss the keyboard when a tap gesture happens
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Add a notification for keyboard change events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Populate the temporary data used for this example
    [self populateTableData];
    [self.tableView reloadData];
    
    // Scroll to the bottom with our Category helper
    [self.tableView scrollToBottom:false];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Remove notification for keyboard change events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


// This is a helper function to populate the table data with
// values from 1980 - 2014
-(void)populateTableData
{
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for(int i = 1980; i < 2015; i++) {
        [temp addObject:[NSNumber numberWithInt:i]];
    }
    self.tableData = [NSArray arrayWithArray:temp];
}

// Reimplements inputAccessorView from UIResponder to dock keyboardBar at bottom
- (UIView*)inputAccessoryView
{
    if (self.keyboardBar == nil) {
        self.keyboardBar = [[KeyboardBarView alloc]init];
    }
    return self.keyboardBar;
}

// Enables the keyboard bar
- (BOOL)canBecomeFirstResponder
{
    return true;
}

// Calls helper function on KeyboardBarView that will
// end up calling ResignFirstResponder on the TextField
- (void)hideKeyboard
{
    [self.keyboardBar dismissKeyboard];
}


#pragma Handle keyboard events

// Scrolls the table by an appropriate amount
-(void)keyboardWillChange:(NSNotification *)notification
{
    CGRect beginFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame =  [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat delta = (endFrame.origin.y - beginFrame.origin.y);
    NSLog(@"Keyboard YDelta %f -> B: %@, E: %@", delta, NSStringFromCGRect(beginFrame), NSStringFromCGRect(endFrame));
    
    if(self.tableView.scrolledToBottom && fabs(delta) > 0.0) {
        
        NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
        
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            
            // Make the tableview scroll opposite the change in keyboard offset.
            // This causes the scroll position to match the change in table size 1 for 1
            // since the animation is the same as the keyboard expansion
            self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y - delta);
            
        } completion:nil];
    }
}

#pragma Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"example";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.tableData[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

@end
