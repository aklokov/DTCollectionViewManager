//
//  DTCollectionViewController.m
//  DTCollectionViewManager-iPad
//
//  Created by Denys Telezhkin on 1/23/13.
//  Copyright (c) 2013 MLSDev. All rights reserved.
//

#import "DTCollectionViewController.h"

@interface DTCollectionViewController ()

@property (nonatomic, retain) NSMutableArray *sections;

@property (nonatomic, retain) NSMutableDictionary *reuseIdentifiersForSupplementaryViews;
@property (nonatomic, retain) NSMutableDictionary *reuseIdentifiersForCellModels;
@end

@implementation DTCollectionViewController

- (NSMutableDictionary *)reuseIdentifiersForSupplementaryViews
{
    if (!_reuseIdentifiersForSupplementaryViews)
    {
            _reuseIdentifiersForSupplementaryViews = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    return _reuseIdentifiersForSupplementaryViews;
}

- (NSMutableDictionary *)reuseIdentifiersForCellModels
{
    if (!_reuseIdentifiersForCellModels)
    {
            _reuseIdentifiersForCellModels = [[NSMutableDictionary alloc] init];
    }
    return _reuseIdentifiersForCellModels;
}

- (NSMutableArray *)sections
{
    if (!_sections)
    {
            _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

- (NSMutableArray *)headerModels
{
    if (!_headerModels)
    {
            _headerModels = [[NSMutableArray alloc] init];
    }
    return _headerModels;
}

- (NSMutableArray *)footerModels
{
    if (!_footerModels)
    {
            _footerModels = [[NSMutableArray alloc] init];
    }
    return _footerModels;
}

- (NSMutableArray *)itemsArrayForSection:(int)index
{
    if ([self.sections count] > index)
    {
        return self.sections[index];
    }
    else if ([self.sections count] == index)
    {
        [self.sections addObject:[NSMutableArray array]];
        return [self.sections lastObject];
    }
    else
    {
        return nil;
    }
}

- (NSMutableArray *)sectionsArray
{
    return self.sections;
}

- (void)registerClass:(Class)reusableCellClass forCellReuseIdentifier:(NSString *)identifier
        forModelClass:(Class)modelClass
{
    [self.collectionView registerClass:reusableCellClass forCellWithReuseIdentifier:identifier];
    self.reuseIdentifiersForCellModels[[self reuseIdentifierForClass:modelClass]] = identifier;
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
      forModelClass:(Class)modelClass
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    self.reuseIdentifiersForCellModels[[self reuseIdentifierForClass:modelClass]] = identifier;
}

- (void)registerClass:(Class)reusableViewClass forSupplementaryViewOfKind:(NSString *)kind
  withReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:reusableViewClass forSupplementaryViewOfKind:kind
                   withReuseIdentifier:identifier];
    self.reuseIdentifiersForSupplementaryViews[kind] = identifier;
}

- (void)registerNib:(UINib *)nib forSupplementaryViewOfKind:(NSString *)kind
withReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:kind
                 withReuseIdentifier:identifier];
    self.reuseIdentifiersForSupplementaryViews[kind] = identifier;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSArray *itemsInSection = self.sections[section];

    return [itemsInSection count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell <DTCollectionViewModelTransfer> *cell;

    NSArray *itemsInSection = self.sections[indexPath.section];

    id model = itemsInSection[indexPath.row];
    NSString *reuseIdentifier = self.reuseIdentifiersForCellModels[[self reuseIdentifierForClass:[model class]]];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                     forIndexPath:indexPath];
    [cell updateWithModel:model];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView <DTCollectionViewModelTransfer> *view;
    view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                              withReuseIdentifier:self.reuseIdentifiersForSupplementaryViews[kind]
                                                     forIndexPath:indexPath];
    id model = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        if ([self.headerModels count] > indexPath.section)
        {
            model = [self.headerModels objectAtIndex:indexPath.section];
        }
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        if ([self.footerModels count] > indexPath.section)
        {
            model = [self.footerModels objectAtIndex:indexPath.section];
        }
    }
    if (model)
    {
        [view updateWithModel:model];
    }

    return view;
}

- (NSString *)reuseIdentifierForClass:(Class)class
{
    NSString * classString = NSStringFromClass(class);
    
    if ([classString isEqualToString:@"__NSCFConstantString"] ||
        [classString isEqualToString:@"__NSCFString"] ||
        class == [NSMutableString class])
    {
        return @"NSString";
    }
    if ([classString isEqualToString:@"__NSCFNumber"] ||
        [classString isEqualToString:@"__NSCFBoolean"])
    {
        return @"NSNumber";
    }
    if ([classString isEqualToString:@"__NSDictionaryI"] ||
        [classString isEqualToString:@"__NSDictionaryM"] ||
        class == [NSMutableDictionary class])
    {
        return @"NSDictionary";
    }
    if ([classString isEqualToString:@"__NSArrayI"] ||
        [classString isEqualToString:@"__NSArrayM"] ||
        class == [NSMutableArray class])
    {
        return @"NSArray";
    }
    return classString;
}


@end