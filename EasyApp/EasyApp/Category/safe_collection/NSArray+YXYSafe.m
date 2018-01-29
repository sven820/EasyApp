//
//  NSArray+YCFSafe.m
//  YCFComponentKit_OC
//
//  Created by JJ.sven on 16/8/9.
//  Copyright © 2016年 yaochufa. All rights reserved.
//

#import "NSArray+YXYSafe.h"

@implementation NSArray (YXYSafe)

+ (BOOL)checkIsEmptyOrNotArray:(NSArray *)array
{
    if (array && [array isKindOfClass:[NSArray class]] && array.count > 0)
    {
        return NO;
    }
    
    return YES;
}

+ (NSUInteger)safe_indexOfObject:(id)obj inArray:(NSArray *)array
{
#ifdef OpenSafeCollection
    if (obj == nil || [NSArray checkIsEmptyOrNotArray:array])
    {
        return NSNotFound;
    }
    else
    {
        NSUInteger index = [array indexOfObject:obj];
        return index;
    }
#else
    return [array indexOfObject:obj];
#endif
}

+ (id)safe_objectAtIndex:(NSInteger)index array:(NSArray *)array
{
#ifdef OpenSafeCollection
    if (!([array isKindOfClass:[NSArray class]])) {
        return nil;
    }
    if (array && array.count > index) {
        return[array objectAtIndex:index];
    } else {
        return nil;
    }
#else
    return [array objectAtIndex:index];
#endif
}
+ (id)safe_objectAtIndex:(NSInteger)index array:(NSArray *)array classType:(Class)classType
{
    id element = [self safe_objectAtIndex:index array:array];
    if ([element isKindOfClass:classType]) {
        return element;
    }
    return nil;
}
+ (void)safe_addObject:(id)obj array:(NSMutableArray *)array
{
#ifdef OpenSafeCollection
    if (obj == nil ||![array isKindOfClass:[NSMutableArray class]] || [obj isEqual:[NSNull null]])
    {
        return;
    }
    [array addObject:obj];
#else
    [array addObject:obj];
#endif
}
+ (void)safe_insertObject:(id)obj index:(NSInteger)index array:(NSMutableArray *)array
{
#ifdef OpenSafeCollection
    if (obj == nil ||![array isKindOfClass:[NSMutableArray class]] || [obj isEqual:[NSNull null]] || index < 0)
    {
        return;
    }
    [array insertObject:obj atIndex:index];
#else
    [array insertObject:obj atIndex:index];
#endif
}
+ (void)safe_insertObjects:(NSArray *)objs indexSet:(NSIndexSet *)indexSet array:(NSMutableArray *)array
{
#ifdef OpenSafeCollection
    if ([self checkIsEmptyOrNotArray:objs] ||![array isKindOfClass:[NSMutableArray class]])
    {
        return;
    }
    if (indexSet == nil || indexSet.count == 0 || ![indexSet isKindOfClass:[NSIndexSet class]])
    {
        return;
    }
    [array insertObjects:objs atIndexes:indexSet];
#else
    [array insertObjects:objs atIndexes:indexSet];
#endif
}

+ (void)safe_replaceObject:(id)obj index:(NSInteger)index array:(NSMutableArray *)array
{
#ifdef OpenSafeCollection
    if (obj == nil
        ||![array isKindOfClass:[NSMutableArray class]]
        || [obj isEqual:[NSNull null]]
        || index < 0
        || index >=array.count)
    {
        return;
    }
    [array replaceObjectAtIndex:index withObject:obj];
#else
    [array replaceObjectAtIndex:index withObject:obj];
#endif
}
@end
