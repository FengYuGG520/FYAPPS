#import "UIScrollView+FYPlayer.h"
#import <objc/runtime.h>
#import "FYReachabilityManager.h"
#import "FYPlayer.h"
#import "FYKVOController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface UIScrollView ()

@property (nonatomic) CGFloat fy_lastOffsetY;
@property (nonatomic) CGFloat fy_lastOffsetX;
@property (nonatomic) FYPlayerScrollDirection fy_scrollDirection;

@end

@implementation UIScrollView (FYPlayer)

#pragma mark - private method

- (void)_scrollViewDidStopScroll {
    @weakify(self)
    [self fy_filterShouldPlayCellWhileScrolled:^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (self.fy_scrollViewDidStopScrollCallback) self.fy_scrollViewDidStopScrollCallback(indexPath);
    }];
}

- (void)_scrollViewBeginDragging {
    if (self.fy_scrollViewDirection == FYPlayerScrollViewDirectionVertical) {
        self.fy_lastOffsetY = self.contentOffset.y;
    } else {
        self.fy_lastOffsetX = self.contentOffset.x;
    }
}

/**
  The percentage of scrolling processed in vertical scrolling.
 */
- (void)_scrollViewScrollingDirectionVertical {
    CGFloat offsetY = self.contentOffset.y;
    self.fy_scrollDirection = (offsetY - self.fy_lastOffsetY > 0) ? FYPlayerScrollDirectionUp : FYPlayerScrollDirectionDown;
    self.fy_lastOffsetY = offsetY;
    if (self.fy_stopPlay) return;
    
    UIView *playerView;
    if (self.fy_containerType == FYPlayerContainerTypeCell) {
        // Avoid being paused the first time you play it.
        if (self.contentOffset.y < 0) return;
        if (!self.fy_playingIndexPath) return;
        
        UIView *cell = [self fy_getCellForIndexPath:self.fy_playingIndexPath];
        if (!cell) {
            if (self.fy_playerDidDisappearInScrollView) self.fy_playerDidDisappearInScrollView(self.fy_playingIndexPath);
            return;
        }
        playerView = [cell viewWithTag:self.fy_containerViewTag];
    } else if (self.fy_containerType == FYPlayerContainerTypeView) {
        if (!self.fy_containerView) return;
        playerView = self.fy_containerView;
    }
    
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView top to scrollView top space.
    CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
    /// playerView bottom to scrollView bottom space.
    CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
    /// The height of the content area.
    CGFloat contentInsetHeight = CGRectGetMaxY(self.frame) - CGRectGetMinY(self.frame);
    
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    
    if (self.fy_scrollDirection == FYPlayerScrollDirectionUp) { /// Scroll up
        /// Player is disappearing.
        if (topSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -topSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.fy_playerDisappearingInScrollView) self.fy_playerDisappearingInScrollView(self.fy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Top area
        if (topSpacing <= 0 && topSpacing > -CGRectGetHeight(rect)/2) {
            /// When the player will disappear.
            if (self.fy_playerWillDisappearInScrollView) self.fy_playerWillDisappearInScrollView(self.fy_playingIndexPath);
        } else if (topSpacing <= -CGRectGetHeight(rect)) {
            /// When the player did disappeared.
            if (self.fy_playerDidDisappearInScrollView) self.fy_playerDidDisappearInScrollView(self.fy_playingIndexPath);
        } else if (topSpacing > 0 && topSpacing <= contentInsetHeight) {
            /// Player is appearing.
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(topSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.fy_playerAppearingInScrollView) self.fy_playerAppearingInScrollView(self.fy_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (topSpacing <= contentInsetHeight && topSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// When the player will appear.
                if (self.fy_playerWillAppearInScrollView) self.fy_playerWillAppearInScrollView(self.fy_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.fy_playerDidAppearInScrollView) self.fy_playerDidAppearInScrollView(self.fy_playingIndexPath);
            }
        }
        
    } else if (self.fy_scrollDirection == FYPlayerScrollDirectionDown) { /// Scroll Down
        /// Player is disappearing.
        if (bottomSpacing <= 0 && CGRectGetHeight(rect) != 0) {
            playerDisapperaPercent = -bottomSpacing/CGRectGetHeight(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.fy_playerDisappearingInScrollView) self.fy_playerDisappearingInScrollView(self.fy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Bottom area
        if (bottomSpacing <= 0 && bottomSpacing > -CGRectGetHeight(rect)/2) {
            /// When the player will disappear.
            if (self.fy_playerWillDisappearInScrollView) self.fy_playerWillDisappearInScrollView(self.fy_playingIndexPath);
        } else if (bottomSpacing <= -CGRectGetHeight(rect)) {
            /// When the player did disappeared.
            if (self.fy_playerDidDisappearInScrollView) self.fy_playerDidDisappearInScrollView(self.fy_playingIndexPath);
        } else if (bottomSpacing > 0 && bottomSpacing <= contentInsetHeight) {
            /// Player is appearing.
            if (CGRectGetHeight(rect) != 0) {
                playerApperaPercent = -(bottomSpacing-contentInsetHeight)/CGRectGetHeight(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.fy_playerAppearingInScrollView) self.fy_playerAppearingInScrollView(self.fy_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (bottomSpacing <= contentInsetHeight && bottomSpacing > contentInsetHeight-CGRectGetHeight(rect)/2) {
                /// When the player will appear.
                if (self.fy_playerWillAppearInScrollView) self.fy_playerWillAppearInScrollView(self.fy_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.fy_playerDidAppearInScrollView) self.fy_playerDidAppearInScrollView(self.fy_playingIndexPath);
            }
        }
    }
}

/**
 The percentage of scrolling processed in horizontal scrolling.
 */
- (void)_scrollViewScrollingDirectionHorizontal {
    CGFloat offsetX = self.contentOffset.x;
    self.fy_scrollDirection = (offsetX - self.fy_lastOffsetX > 0) ? FYPlayerScrollDirectionLeft : FYPlayerScrollDirectionRight;
    self.fy_lastOffsetX = offsetX;
    if (self.fy_stopPlay) return;
    
    UIView *playerView;
    if (self.fy_containerType == FYPlayerContainerTypeCell) {
        // Avoid being paused the first time you play it.
        if (self.contentOffset.x < 0) return;
        if (!self.fy_playingIndexPath) return;
        
        UIView *cell = [self fy_getCellForIndexPath:self.fy_playingIndexPath];
        if (!cell) {
            if (self.fy_playerDidDisappearInScrollView) self.fy_playerDidDisappearInScrollView(self.fy_playingIndexPath);
            return;
        }
       playerView = [cell viewWithTag:self.fy_containerViewTag];
    } else if (self.fy_containerType == FYPlayerContainerTypeView) {
        if (!self.fy_containerView) return;
        playerView = self.fy_containerView;
    }
    
    CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
    CGRect rect = [self convertRect:rect1 toView:self.superview];
    /// playerView left to scrollView left space.
    CGFloat leftSpacing = CGRectGetMinX(rect) - CGRectGetMinX(self.frame) - CGRectGetMinX(playerView.frame);
    /// playerView bottom to scrollView right space.
    CGFloat rightSpacing = CGRectGetMaxX(self.frame) - CGRectGetMaxX(rect) + CGRectGetMinX(playerView.frame);
    /// The height of the content area.
    CGFloat contentInsetWidth = CGRectGetMaxX(self.frame) - CGRectGetMinX(self.frame);
    
    CGFloat playerDisapperaPercent = 0;
    CGFloat playerApperaPercent = 0;
    
    if (self.fy_scrollDirection == FYPlayerScrollDirectionLeft) { /// Scroll left
        /// Player is disappearing.
        if (leftSpacing <= 0 && CGRectGetWidth(rect) != 0) {
            playerDisapperaPercent = -leftSpacing/CGRectGetWidth(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.fy_playerDisappearingInScrollView) self.fy_playerDisappearingInScrollView(self.fy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Top area
        if (leftSpacing <= 0 && leftSpacing > -CGRectGetWidth(rect)/2) {
            /// When the player will disappear.
            if (self.fy_playerWillDisappearInScrollView) self.fy_playerWillDisappearInScrollView(self.fy_playingIndexPath);
        } else if (leftSpacing <= -CGRectGetWidth(rect)) {
            /// When the player did disappeared.
            if (self.fy_playerDidDisappearInScrollView) self.fy_playerDidDisappearInScrollView(self.fy_playingIndexPath);
        } else if (leftSpacing > 0 && leftSpacing <= contentInsetWidth) {
            /// Player is appearing.
            if (CGRectGetWidth(rect) != 0) {
                playerApperaPercent = -(leftSpacing-contentInsetWidth)/CGRectGetWidth(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.fy_playerAppearingInScrollView) self.fy_playerAppearingInScrollView(self.fy_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (leftSpacing <= contentInsetWidth && leftSpacing > contentInsetWidth-CGRectGetWidth(rect)/2) {
                /// When the player will appear.
                if (self.fy_playerWillAppearInScrollView) self.fy_playerWillAppearInScrollView(self.fy_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.fy_playerDidAppearInScrollView) self.fy_playerDidAppearInScrollView(self.fy_playingIndexPath);
            }
        }
        
    } else if (self.fy_scrollDirection == FYPlayerScrollDirectionRight) { /// Scroll right
        /// Player is disappearing.
        if (rightSpacing <= 0 && CGRectGetWidth(rect) != 0) {
            playerDisapperaPercent = -rightSpacing/CGRectGetWidth(rect);
            if (playerDisapperaPercent > 1.0) playerDisapperaPercent = 1.0;
            if (self.fy_playerDisappearingInScrollView) self.fy_playerDisappearingInScrollView(self.fy_playingIndexPath, playerDisapperaPercent);
        }
        
        /// Bottom area
        if (rightSpacing <= 0 && rightSpacing > -CGRectGetWidth(rect)/2) {
            /// When the player will disappear.
            if (self.fy_playerWillDisappearInScrollView) self.fy_playerWillDisappearInScrollView(self.fy_playingIndexPath);
        } else if (rightSpacing <= -CGRectGetWidth(rect)) {
            /// When the player did disappeared.
            if (self.fy_playerDidDisappearInScrollView) self.fy_playerDidDisappearInScrollView(self.fy_playingIndexPath);
        } else if (rightSpacing > 0 && rightSpacing <= contentInsetWidth) {
            /// Player is appearing.
            if (CGRectGetWidth(rect) != 0) {
                playerApperaPercent = -(rightSpacing-contentInsetWidth)/CGRectGetWidth(rect);
                if (playerApperaPercent > 1.0) playerApperaPercent = 1.0;
                if (self.fy_playerAppearingInScrollView) self.fy_playerAppearingInScrollView(self.fy_playingIndexPath, playerApperaPercent);
            }
            /// In visable area
            if (rightSpacing <= contentInsetWidth && rightSpacing > contentInsetWidth-CGRectGetWidth(rect)/2) {
                /// When the player will appear.
                if (self.fy_playerWillAppearInScrollView) self.fy_playerWillAppearInScrollView(self.fy_playingIndexPath);
            } else {
                /// When the player did appeared.
                if (self.fy_playerDidAppearInScrollView) self.fy_playerDidAppearInScrollView(self.fy_playingIndexPath);
            }
        }
    }
}

/**
 Find the playing cell while the scrollDirection is vertical.
 */
- (void)_findCorrectCellWhenScrollViewDirectionVertical:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.fy_shouldAutoPlay) return;
    if (self.fy_containerType == FYPlayerContainerTypeView) return;

    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // First visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if (self.contentOffset.y <= 0 && (!self.fy_playingIndexPath || [indexPath compare:self.fy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.fy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Last visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.fy_playingIndexPath || [indexPath compare:self.fy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.fy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // First visible cell indexPath
        indexPath = sortedIndexPaths.firstObject;
        if (self.contentOffset.y <= 0 && (!self.fy_playingIndexPath || [indexPath compare:self.fy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.fy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Last visible cell indexPath
        indexPath = sortedIndexPaths.lastObject;
        if (self.contentOffset.y + self.frame.size.height >= self.contentSize.height && (!self.fy_playingIndexPath || [indexPath compare:self.fy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.fy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cells = nil;
    if (self.fy_scrollDirection == FYPlayerScrollDirectionUp) {
        cells = visiableCells;
    } else {
        cells = [visiableCells reverseObjectEnumerator].allObjects;
    }
    
    /// Mid line.
    CGFloat scrollViewMidY = CGRectGetHeight(self.frame)/2;
    /// The final playing indexPath.
    __block NSIndexPath *finalIndexPath = nil;
    /// The final distance from the center line.
    __block CGFloat finalSpace = 0;
    @weakify(self)
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
        if (!playerView) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        /// playerView top to scrollView top space.
        CGFloat topSpacing = CGRectGetMinY(rect) - CGRectGetMinY(self.frame) - CGRectGetMinY(playerView.frame);
        /// playerView bottom to scrollView bottom space.
        CGFloat bottomSpacing = CGRectGetMaxY(self.frame) - CGRectGetMaxY(rect) + CGRectGetMinY(playerView.frame);
        CGFloat centerSpacing = ABS(scrollViewMidY - CGRectGetMidY(rect));
        NSIndexPath *indexPath = [self fy_getIndexPathForCell:cell];
        
        /// Play when the video playback section is visible.
        if ((topSpacing >= -(1 - self.fy_playerApperaPercent) * CGRectGetHeight(rect)) && (bottomSpacing >= -(1 - self.fy_playerApperaPercent) * CGRectGetHeight(rect))) {
            /// If you have a cell that is playing, stop the traversal.
            if (self.fy_playingIndexPath) {
                indexPath = self.fy_playingIndexPath;
                finalIndexPath = indexPath;
                *stop = YES;
                return;
            }
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// if find the playing indexPath.
    if (finalIndexPath) {
        if (handler) handler(finalIndexPath);
        self.fy_shouldPlayIndexPath = finalIndexPath;
    }
}

/**
 Find the playing cell while the scrollDirection is horizontal.
 */
- (void)_findCorrectCellWhenScrollViewDirectionHorizontal:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.fy_shouldAutoPlay) return;
    if (self.fy_containerType == FYPlayerContainerTypeView) return;
    
    NSArray *visiableCells = nil;
    NSIndexPath *indexPath = nil;
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        visiableCells = [tableView visibleCells];
        // First visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.firstObject;
        if (self.contentOffset.x <= 0 && (!self.fy_playingIndexPath || [indexPath compare:self.fy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.fy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Last visible cell indexPath
        indexPath = tableView.indexPathsForVisibleRows.lastObject;
        if (self.contentOffset.x + self.frame.size.width >= self.contentSize.width && (!self.fy_playingIndexPath || [indexPath compare:self.fy_playingIndexPath] == NSOrderedSame)) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.fy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        visiableCells = [collectionView visibleCells];
        NSArray *sortedIndexPaths = [collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        visiableCells = [visiableCells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)[collectionView indexPathForCell:obj1];
            NSIndexPath *path2 = (NSIndexPath *)[collectionView indexPathForCell:obj2];
            return [path1 compare:path2];
        }];
        
        // First visible cell indexPath
        indexPath = sortedIndexPaths.firstObject;
        if (self.contentOffset.x <= 0 && (!self.fy_playingIndexPath || [indexPath compare:self.fy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.fy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
        
        // Last visible cell indexPath
        indexPath = sortedIndexPaths.lastObject;
        if (self.contentOffset.x + self.frame.size.width >= self.contentSize.width && (!self.fy_playingIndexPath || [indexPath compare:self.fy_playingIndexPath] == NSOrderedSame)) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
            if (playerView) {
                if (handler) handler(indexPath);
                self.fy_shouldPlayIndexPath = indexPath;
                return;
            }
        }
    }
    
    NSArray *cells = nil;
    if (self.fy_scrollDirection == FYPlayerScrollDirectionUp) {
        cells = visiableCells;
    } else {
        cells = [visiableCells reverseObjectEnumerator].allObjects;
    }
    
    /// Mid line.
    CGFloat scrollViewMidX = CGRectGetWidth(self.frame)/2;
    /// The final playing indexPath.
    __block NSIndexPath *finalIndexPath = nil;
    /// The final distance from the center line.
    __block CGFloat finalSpace = 0;
    @weakify(self)
    [cells enumerateObjectsUsingBlock:^(UIView *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        UIView *playerView = [cell viewWithTag:self.fy_containerViewTag];
        if (!playerView) return;
        CGRect rect1 = [playerView convertRect:playerView.frame toView:self];
        CGRect rect = [self convertRect:rect1 toView:self.superview];
        /// playerView left to scrollView top space.
        CGFloat leftSpacing = CGRectGetMinX(rect) - CGRectGetMinX(self.frame) - CGRectGetMinX(playerView.frame);
        /// playerView right to scrollView top space.
        CGFloat rightSpacing = CGRectGetMaxX(self.frame) - CGRectGetMaxX(rect) + CGRectGetMinX(playerView.frame);
        CGFloat centerSpacing = ABS(scrollViewMidX - CGRectGetMidX(rect));
        NSIndexPath *indexPath = [self fy_getIndexPathForCell:cell];
        
        /// Play when the video playback section is visible.
        if ((leftSpacing >= -(1 - self.fy_playerApperaPercent) * CGRectGetWidth(rect)) && (rightSpacing >= -(1 - self.fy_playerApperaPercent) * CGRectGetWidth(rect))) {
            /// If you have a cell that is playing, stop the traversal.
            if (self.fy_playingIndexPath) {
                indexPath = self.fy_playingIndexPath;
                finalIndexPath = indexPath;
                *stop = YES;
                return;
            }
            if (!finalIndexPath || centerSpacing < finalSpace) {
                finalIndexPath = indexPath;
                finalSpace = centerSpacing;
            }
        }
    }];
    /// if find the playing indexPath.
    if (finalIndexPath) {
        if (handler) handler(finalIndexPath);
        self.fy_shouldPlayIndexPath = finalIndexPath;
    }
}

- (BOOL)isTableView {
    return [self isKindOfClass:[UITableView class]];
}

- (BOOL)isCollectionView {
    return [self isKindOfClass:[UICollectionView class]];
}

#pragma mark - public method

- (void)fy_filterShouldPlayCellWhileScrolling:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (self.fy_scrollViewDirection == FYPlayerScrollViewDirectionVertical) {
        [self _findCorrectCellWhenScrollViewDirectionVertical:handler];
    } else {
        [self _findCorrectCellWhenScrollViewDirectionHorizontal:handler];
    }
}

- (void)fy_filterShouldPlayCellWhileScrolled:(void (^ __nullable)(NSIndexPath *indexPath))handler {
    if (!self.fy_shouldAutoPlay) return;
    @weakify(self)
    [self fy_filterShouldPlayCellWhileScrolling:^(NSIndexPath *indexPath) {
        @strongify(self)
        /// 如果当前控制器已经消失，直接return
        if (self.fy_viewControllerDisappear) return;
        if ([FYReachabilityManager sharedManager].isReachableViaWWAN && !self.fy_WWANAutoPlay) {
            /// 移动网络
            self.fy_shouldPlayIndexPath = indexPath;
            return;
        }
        if (handler) handler(indexPath);
        self.fy_playingIndexPath = indexPath;
    }];
}

- (UIView *)fy_getCellForIndexPath:(NSIndexPath *)indexPath {
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        return cell;
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (NSIndexPath *)fy_getIndexPathForCell:(UIView *)cell {
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)cell];
        return indexPath;
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        NSIndexPath *indexPath = [collectionView indexPathForCell:(UICollectionViewCell *)cell];
        return indexPath;
    }
    return nil;
}

- (void)fy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath completionHandler:(void (^ __nullable)(void))completionHandler {
    [self fy_scrollToRowAtIndexPath:indexPath animated:YES completionHandler:completionHandler];
}

- (void)fy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated completionHandler:(void (^ __nullable)(void))completionHandler {
    [self fy_scrollToRowAtIndexPath:indexPath animateWithDuration:animated ? 0.4 : 0.0 completionHandler:completionHandler];
}

/// Scroll to indexPath with animations duration.
- (void)fy_scrollToRowAtIndexPath:(NSIndexPath *)indexPath animateWithDuration:(NSTimeInterval)duration completionHandler:(void (^ __nullable)(void))completionHandler {
    BOOL animated = duration > 0.0;
    if ([self isTableView]) {
        UITableView *tableView = (UITableView *)self;
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    } else if ([self isCollectionView]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completionHandler) completionHandler();
    });
}

- (void)fy_scrollViewDidEndDecelerating {
    BOOL scrollToScrollStop = !self.tracking && !self.dragging && !self.decelerating;
    if (scrollToScrollStop) {
        [self _scrollViewDidStopScroll];
    }
}

- (void)fy_scrollViewDidEndDraggingWillDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = self.tracking && !self.dragging && !self.decelerating;
        if (dragToDragStop) {
            [self _scrollViewDidStopScroll];
        }
    }
}

- (void)fy_scrollViewDidScrollToTop {
    [self _scrollViewDidStopScroll];
}

- (void)fy_scrollViewDidScroll {
    if (self.fy_scrollViewDirection == FYPlayerScrollViewDirectionVertical) {
        [self _scrollViewScrollingDirectionVertical];
    } else {
        [self _scrollViewScrollingDirectionHorizontal];
    }
}

- (void)fy_scrollViewWillBeginDragging {
    [self _scrollViewBeginDragging];
}

#pragma mark - getter

- (NSIndexPath *)fy_playingIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSIndexPath *)fy_shouldPlayIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSInteger)fy_containerViewTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (FYPlayerScrollDirection)fy_scrollDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)fy_stopWhileNotVisible {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)fy_isWWANAutoPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)fy_shouldAutoPlay {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) return number.boolValue;
    self.fy_shouldAutoPlay = YES;
    return YES;
}

- (FYPlayerScrollViewDirection)fy_scrollViewDirection {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)fy_stopPlay {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (FYPlayerContainerType)fy_containerType {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (UIView *)fy_containerView {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGFloat)fy_lastOffsetY {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (CGFloat)fy_lastOffsetX {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void (^)(NSIndexPath * _Nonnull))fy_scrollViewDidStopScrollCallback {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))fy_shouldPlayIndexPathCallback {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - setter

- (void)setFy_playingIndexPath:(NSIndexPath *)fy_playingIndexPath {
    objc_setAssociatedObject(self, @selector(fy_playingIndexPath), fy_playingIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (fy_playingIndexPath) self.fy_shouldPlayIndexPath = fy_playingIndexPath;
}

- (void)setFy_shouldPlayIndexPath:(NSIndexPath *)fy_shouldPlayIndexPath {
    if (self.fy_shouldPlayIndexPathCallback) self.fy_shouldPlayIndexPathCallback(fy_shouldPlayIndexPath);
    objc_setAssociatedObject(self, @selector(fy_shouldPlayIndexPath), fy_shouldPlayIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_containerViewTag:(NSInteger)fy_containerViewTag {
    objc_setAssociatedObject(self, @selector(fy_containerViewTag), @(fy_containerViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_scrollDirection:(FYPlayerScrollDirection)fy_scrollDirection {
    objc_setAssociatedObject(self, @selector(fy_scrollDirection), @(fy_scrollDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_stopWhileNotVisible:(BOOL)fy_stopWhileNotVisible {
    objc_setAssociatedObject(self, @selector(fy_stopWhileNotVisible), @(fy_stopWhileNotVisible), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_WWANAutoPlay:(BOOL)fy_WWANAutoPlay {
    objc_setAssociatedObject(self, @selector(fy_isWWANAutoPlay), @(fy_WWANAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_scrollViewDirection:(FYPlayerScrollViewDirection)fy_scrollViewDirection {
    objc_setAssociatedObject(self, @selector(fy_scrollViewDirection), @(fy_scrollViewDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_stopPlay:(BOOL)fy_stopPlay {
    objc_setAssociatedObject(self, @selector(fy_stopPlay), @(fy_stopPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_containerType:(FYPlayerContainerType)fy_containerType {
    objc_setAssociatedObject(self, @selector(fy_containerType), @(fy_containerType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_containerView:(UIView *)fy_containerView {
    objc_setAssociatedObject(self, @selector(fy_containerView), fy_containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_shouldAutoPlay:(BOOL)fy_shouldAutoPlay {
    objc_setAssociatedObject(self, @selector(fy_shouldAutoPlay), @(fy_shouldAutoPlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_lastOffsetY:(CGFloat)fy_lastOffsetY {
    objc_setAssociatedObject(self, @selector(fy_lastOffsetY), @(fy_lastOffsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_lastOffsetX:(CGFloat)fy_lastOffsetX {
    objc_setAssociatedObject(self, @selector(fy_lastOffsetX), @(fy_lastOffsetX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFy_scrollViewDidStopScrollCallback:(void (^)(NSIndexPath * _Nonnull))fy_scrollViewDidStopScrollCallback {
    objc_setAssociatedObject(self, @selector(fy_scrollViewDidStopScrollCallback), fy_scrollViewDidStopScrollCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_shouldPlayIndexPathCallback:(void (^)(NSIndexPath * _Nonnull))fy_shouldPlayIndexPathCallback {
    objc_setAssociatedObject(self, @selector(fy_shouldPlayIndexPathCallback), fy_shouldPlayIndexPathCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIScrollView (FYPlayerCannotCalled)

#pragma mark - getter

- (void (^)(NSIndexPath * _Nonnull, CGFloat))fy_playerDisappearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull, CGFloat))fy_playerAppearingInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))fy_playerDidAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))fy_playerWillDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))fy_playerWillAppearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(NSIndexPath * _Nonnull))fy_playerDidDisappearInScrollView {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGFloat)fy_playerApperaPercent {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (CGFloat)fy_playerDisapperaPercent {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (BOOL)fy_viewControllerDisappear {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - setter

- (void)setFy_playerDisappearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))fy_playerDisappearingInScrollView {
    objc_setAssociatedObject(self, @selector(fy_playerDisappearingInScrollView), fy_playerDisappearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_playerAppearingInScrollView:(void (^)(NSIndexPath * _Nonnull, CGFloat))fy_playerAppearingInScrollView {
    objc_setAssociatedObject(self, @selector(fy_playerAppearingInScrollView), fy_playerAppearingInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_playerDidAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))fy_playerDidAppearInScrollView {
    objc_setAssociatedObject(self, @selector(fy_playerDidAppearInScrollView), fy_playerDidAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_playerWillDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))fy_playerWillDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(fy_playerWillDisappearInScrollView), fy_playerWillDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_playerWillAppearInScrollView:(void (^)(NSIndexPath * _Nonnull))fy_playerWillAppearInScrollView {
    objc_setAssociatedObject(self, @selector(fy_playerWillAppearInScrollView), fy_playerWillAppearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_playerDidDisappearInScrollView:(void (^)(NSIndexPath * _Nonnull))fy_playerDidDisappearInScrollView {
    objc_setAssociatedObject(self, @selector(fy_playerDidDisappearInScrollView), fy_playerDidDisappearInScrollView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_playerApperaPercent:(CGFloat)fy_playerApperaPercent {
    objc_setAssociatedObject(self, @selector(fy_playerApperaPercent), @(fy_playerApperaPercent), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_playerDisapperaPercent:(CGFloat)fy_playerDisapperaPercent {
    objc_setAssociatedObject(self, @selector(fy_playerDisapperaPercent), @(fy_playerDisapperaPercent), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setFy_viewControllerDisappear:(BOOL)fy_viewControllerDisappear {
    objc_setAssociatedObject(self, @selector(fy_viewControllerDisappear), @(fy_viewControllerDisappear), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma clang diagnostic pop
