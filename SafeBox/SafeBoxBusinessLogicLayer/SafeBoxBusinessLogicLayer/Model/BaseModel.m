//
//  BaseModel.m
//  SafeBoxBusinessLogicLayer
//
//  Created by 丁嘉睿 on 16/5/18.
//  Copyright © 2016年 Mr.D. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (NSDictionary *)propertyClassesByName

{
    
    // Check for a cached value (we use _cmd as the cache key,
    
    // which represents @selector(propertyNames))
    
    NSMutableDictionary *dictionary = objc_getAssociatedObject([self class], _cmd);
    
    if (dictionary)
        
    {
        
        return dictionary;
        
    }
    
    // Loop through our superclasses until we hit NSObject
    
    dictionary = [NSMutableDictionary dictionary];
    
    Class subclass = [self class];
    
    while (subclass != [NSObject class])
        
    {
        
        unsigned int propertyCount;
        
        objc_property_t *properties = class_copyPropertyList(subclass,
                                                             
                                                             &propertyCount);
        
        for (int i = 0; i < propertyCount; i++)
            
        {
            
            // Get property name
            
            objc_property_t property = properties[i];
            
            const char *propertyName = property_getName(property);
            
            NSString *key = @(propertyName);
            
            // Check if there is a backing ivar
            
            char *ivar = property_copyAttributeValue(property, "V");
            
            if (ivar)
                
            {
                
                // Check if ivar has KVC-compliant name
                
                NSString *ivarName = @(ivar);
                
                if ([ivarName isEqualToString:key] ||
                    
                    [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                    
                {
                    
                    // Get type
                    
                    Class propertyClass = nil;
                    
                    char *typeEncoding = property_copyAttributeValue(property, "T");
                    
                    switch (typeEncoding[0])
                    
                    {
                            
                        case 'c': // Numeric types
                            
                        case 'i':
                            
                        case 's':
                            
                        case 'l':
                            
                        case 'q':
                            
                        case 'C':
                            
                        case 'I':
                            
                        case 'S':
                            
                        case 'L':
                            
                        case 'Q':
                            
                        case 'f':
                            
                        case 'd':
                            
                        case 'B':
                            
                        {
                            
                            propertyClass = [NSNumber class];
                            
                            break;
                            
                        }
                            
                        case '*': // C-String
                            
                        { 
                            
                            propertyClass = [NSString class]; 
                            
                            break; 
                            
                        } 
                            
                        case '@': // Object 
                            
                        { 
                            
                            //TODO: get class name 
                            // The objcType for classes will always be at least 3 characters long
                            
                            if (strlen(typeEncoding) >= 3)
                                
                            {
                                
                                // Copy the class name as a C-String
                                
                                char *cName = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                                
                                // Convert to an NSString for easier manipulation
                                
                                NSString *name = @(cName);
                                
                                // Strip out and protocols from the end of the class name
                                
                                NSRange range = [name rangeOfString:@"<"]; 
                                
                                if (range.location != NSNotFound) 
                                    
                                { 
                                    
                                    name = [name substringToIndex:range.location]; 
                                    
                                } 
                                
                                // Get class from name, or default to NSObject if no name is found 
                                
                                propertyClass = NSClassFromString(name) ?: [NSObject class]; 
                                
                                free(cName); 
                                
                            }
                            break; 
                            
                        } 
                            
                        case '{': // Struct 
                            
                        { 
                            
                            propertyClass = [NSValue class]; 
                            
                            break; 
                            
                        } 
                            
                        case '[': // C-Array 
                            
                        case '(': // Enum 
                            
                        case '#': // Class 
                            
                        case ':': // Selector 
                            
                        case '^': // Pointer 
                            
                        case 'b': // Bitfield 
                            
                        case '?': // Unknown type 
                            
                        default: 
                            
                        { 
                            
                            propertyClass = nil; // Not supported by KVC 
                            
                            break; 
                            
                        } 
                            
                    } 
                    
                    free(typeEncoding); 
                    
                    // If known type, add to dictionary 
                    
                    if (propertyClass) dictionary[key] = propertyClass;
                    
                } 
                
                free(ivar); 
                
            } 
            
        } 
        
        free(properties); 
        
        subclass = [subclass superclass]; 
        
    } 
    
    // Cache and return dictionary 
    
    objc_setAssociatedObject([self class], _cmd, dictionary,  
                             
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC); 
    
    return dictionary; 
    
}

- (void)dealloc
{
    objc_removeAssociatedObjects([self class]);
}

#pragma mark - 从文件中读取
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    if ((self = [super init]))
        
    {
        
        // Decode the property values by key, specifying the expected class
        
        [[self propertyClassesByName] enumerateKeysAndObjectsUsingBlock:^(NSString *key, Class propertyClass, BOOL *stop) {
            id object = [aDecoder decodeObjectOfClass:propertyClass forKey:key];
            
            if (object) [self setValue:object forKey:key];
        }];
        
    }
    
    return self;
    
}

#pragma mark - 写入文件
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    for (NSString *key in [self propertyClassesByName])
        
    {
        
        id object = [self valueForKey:key];
        
        if (object) [aCoder encodeObject:object forKey:key];
        
    }
    
}

#pragma mark - 深复制
- (id)deepCopy
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}


+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
