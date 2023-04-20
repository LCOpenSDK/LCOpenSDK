//
//  Copyright © 2016年 Anson. All rights reserved.
//

#import "UIScrollView+Empty.h"
#import <objc/runtime.h>
#import <KVOController/KVOController.h>

static NSString * LCUIScrollViewEmptyKVOContext = @"LCUIScrollViewEmptyKVOContext";

@implementation UIScrollView (Empty)


static const void *IndieEmptyViewKey = &IndieEmptyViewKey;

#pragma mark - getter && setter
- (void)setLc_emptyImage:(UIImage *)lc_emptyImage
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.image = lc_emptyImage;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeCenter;
    self.lc_emptyView = imageView;
}

- (UIImage *)lc_emptyImage
{
    if (self.lc_emptyView!=nil && [self.lc_emptyView isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = (UIImageView *)self.lc_emptyView;
       
        return imageView.image;
    }
    return nil;
}

- (void)setLc_emptyView:(UIView *)lc_emptyView
{
    lc_emptyView.hidden = self.lc_emptyView.hidden;
    if (self.lc_emptyView!=nil)
    {
        [self.lc_emptyView removeFromSuperview];
    }
    [self addSubview:lc_emptyView];
    lc_emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self bringSubviewToFront:lc_emptyView];


    __weak UIScrollView *weakSelf = self;
    
    [self.KVOController observe:self keyPath:@"contentSize" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        [weakSelf contentSizeChange];
        
    }];
    
    
    objc_setAssociatedObject(self, IndieEmptyViewKey, lc_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)lc_emptyView
{
    UIView *emptyView = objc_getAssociatedObject(self, IndieEmptyViewKey);
    return  emptyView;
}

#pragma mark -
- (void)contentSizeChange
{
  
    UIView *emptyView = self.lc_emptyView;
    if (emptyView==nil)
    {
        return ;
    }
    
    //当UITbleView时 计算出row的总行数 进行判断
    if ([self isKindOfClass:[UITableView class]])
    {
        NSLog(@"%@", @"contentSize change----");
        UITableView *tv = (UITableView *)self;
        if(tv.dataSource == nil)
        {
            return ;
        }
        
        if (![tv.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        {
            return;
        }
        
        //默认section数为1  有委托用委托中的值
        NSInteger countOfSection = 1;
        if ([tv.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
        {
            countOfSection = [tv.dataSource numberOfSectionsInTableView:tv];
        }
        
        NSInteger allCountOfRow = 0;
        for (NSInteger i=0; i<countOfSection; i++)
        {
            allCountOfRow += [tv.dataSource tableView:tv numberOfRowsInSection:i];
        }
        
        if (allCountOfRow == 0)
        {
            emptyView.hidden = NO;
            [self bringSubviewToFront:emptyView];
            return ;
        }
    }//当Notepad++时 计算出item的总个数 进行判断
    else if([self isKindOfClass:[UICollectionView class]])
    {
        UICollectionView *cv = (UICollectionView *)self;
        
        if (cv.dataSource == nil)
        {
            return;
        }
        
        if (![cv.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
        {
            return ;
        }
        
        if (![cv.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
        {
            return ;
        }
        
        //默认section数为1  有委托用委托中的值
        NSInteger countOfSection = 1;
        if ([cv.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
        {
            countOfSection = [cv.dataSource numberOfSectionsInCollectionView:cv];
        }
        
        NSInteger allCountOfRow = 0;
        for (NSInteger i=0; i<countOfSection; i++)
        {
            allCountOfRow += [cv.dataSource collectionView:cv numberOfItemsInSection:i];
        }
        
        if (allCountOfRow == 0)
        {
            emptyView.hidden = NO;
            [self bringSubviewToFront:emptyView];
            return ;
        }
        
    }
    
    emptyView.hidden = YES;

   
}


#pragma mark - clear kvo
- (void)lc_clearEmptyViewInfo
{
//    if ([self isRegKVO])
//    {
//        [self removeObserver:self forKeyPath:@"contentSize" context:(__bridge void * _Nullable)(LCUIScrollViewEmptyKVOContext)];
//        [self setIsRegkVO:NO];
//    }
    
}

#pragma mark - lechange ui



@end
