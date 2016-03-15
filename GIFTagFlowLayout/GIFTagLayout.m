//
//  GIFTagLayout.m
//  GIFTagFlow
//
//  Created by Eric Young on 3/15/16.
//  Copyright © 2016 gifit. All rights reserved.
//

#import "GIFTagLayout.h"

@interface GIFTagLayout ()
@property (strong,nonatomic) NSMutableArray *cache;
@property (assign,nonatomic) float contentHeight, contentWidth;
@end

@implementation GIFTagLayout

#pragma mark - Init
- (void)commonInit {
    _cache = [NSMutableArray new];
    _numberOfRows = 2;
    _cellPadding = 2;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    _contentHeight = self.collectionView.bounds.size.height - (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom);
    
    if (self.cache.count == 0) {
        float rowHeight = self.contentHeight / self.numberOfRows;
        
        NSMutableArray *xOffset = [NSMutableArray new];
        NSMutableArray *yOffset = [NSMutableArray new];
        
        for (int y = 0; y < self.numberOfRows; y++) {
            float _yOffset = y * rowHeight;
            [yOffset addObject:[NSNumber numberWithFloat:_yOffset]];
        }
        
        for (int x = 0; x < self.numberOfRows; x++) {
            float _xOffset = 0;
            [xOffset addObject:[NSNumber numberWithFloat:_xOffset]];
        }
        
        int row = 0;
        
        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
        for (NSUInteger item = 0; item < numberOfItems; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
            CGFloat height = rowHeight ;
            
            //CGFloat tagHeight = [self.delegate collectionView:self.collectionView heightForTagAtIndexPath:indexPath withWidth:width];
            
            CGFloat tagWidth = [self.delegate collectionView:self.collectionView widthForTagAtIndexPath:indexPath withHeight:height];
            
            CGFloat width = self.cellPadding + tagWidth + self.cellPadding;
            
            CGRect frame = CGRectMake([xOffset[row] floatValue],[yOffset[row] floatValue], width, height);
            
            CGRect insetFrame = CGRectInset(frame, self.cellPadding, self.cellPadding);
            
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = insetFrame;
            
            [self.cache addObject:attributes];
            
            self.contentWidth = MAX(self.contentWidth, CGRectGetMaxX(frame));
            float newXOffset = [xOffset[row] floatValue] + width;
            xOffset[row] = [NSNumber numberWithFloat:newXOffset];
            
            row = row >= (self.numberOfRows - 1) ? 0 : ++row;
        
        }
    }
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attributes in self.cache) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [layoutAttributes addObject:attributes];
        }
    }
    return  layoutAttributes;
    
}

@end
