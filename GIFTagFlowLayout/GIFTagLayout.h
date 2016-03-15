//
//  GIFTagLayout.h
//  GIFTagFlow
//
//  Created by Eric Young on 3/15/16.
//  Copyright © 2016 gifit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  GIFTagLayout;

@protocol GIFTagLayoutDelegate <NSObject>

-(CGFloat)collectionView:(UICollectionView*)collectionView widthForTagAtIndexPath:(NSIndexPath*)index withHeight:(CGFloat)height;

@end

@interface GIFTagLayout : UICollectionViewLayout

@property (weak, nonatomic) id <GIFTagLayoutDelegate>delegate;
@property (assign, nonatomic) int numberOfRows;
@property (assign, nonatomic) float cellPadding;

@end
