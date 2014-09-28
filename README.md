iOSExamples-BottomScrollPosition
================================

This project is an example of how to maintain the bottom scroll position in a UITableView when the Keyboard expands.

This example uses NotificationCenter to watch for the `UIKeyboardWillChangeFrameNotification` event. When this event is fired, an animation will scroll the TableView by the corresponding amount of change in the Keyboard's position. This will maintain the scroll position as the keyboard shrinks the tables frame.

```
// This will be called each time there is a frame change for the keyboad
// We can use the begin/end values to determine how the keyboard is going to change
// and apply appropriate scrolling to our table
-(void)keyboardWillChange:(NSNotification *)notification
{
    // Retrieve the keyboard begin / end frame values
    CGRect beginFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame =  [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat delta = (endFrame.origin.y - beginFrame.origin.y);
    NSLog(@"Keyboard YDelta %f -> B: %@, E: %@", delta, NSStringFromCGRect(beginFrame), NSStringFromCGRect(endFrame));
    
    // Lets only maintain the scroll position if we are already scrolled at the bottom
    // or if there is a change to the keyboard position
    if(self.tableView.scrolledToBottom && fabs(delta) > 0.0) {
        
        // Construct the animation details
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
```

For more information, refer to http://derpturkey.com/maintain-scroll-position-on-keyboard-expansion
