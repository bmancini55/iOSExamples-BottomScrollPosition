//
//  UITableView+ScrollHelpers.h
//  BottomScrollPosition
//
//  Created by Brian Mancini on 9/28/14.
//  Copyright (c) 2014 iOSExamples. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (ScrollHelpers)

- (bool) scrolledToBottom;
- (void)scrollToBottom:(BOOL)animated;

@end
