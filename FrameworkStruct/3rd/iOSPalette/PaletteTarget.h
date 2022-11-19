//
//  TRIPPaletteTarget.h
//  Atom
//
//  Created by dylan.tang on 17/4/11.
//  Copyright © 2017年 dylan.tang All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger,PaletteTargetMode) {
    DEFAULT_NON_MODE_PALETTE = 0,//if you don't need the ColorDic(including modeKey-colorModel key-value)
    VIBRANT_PALETTE = 1 << 0,       //(普通亮度高饱和类)
    LIGHT_VIBRANT_PALETTE = 1 << 1,     //(高亮度高饱和类)
    DARK_VIBRANT_PALETTE = 1 << 2,      //(暗亮度高饱和类)
    LIGHT_MUTED_PALETTE = 1 << 3,       //(高亮度低饱和类)
    MUTED_PALETTE = 1 << 4,             //(普通亮度低饱和类)
    DARK_MUTED_PALETTE = 1 << 5,        //(暗亮度低饱和类)
    ALL_MODE_PALETTE = 1 << 6, //Fast path to All mode
};

@interface PaletteTarget : NSObject

- (instancetype)initWithTargetMode:(PaletteTargetMode)mode;

- (float)getMinSaturation;

- (float)getMaxSaturation;

- (float)getMinLuma;

- (float)getMaxLuma;

- (float)getSaturationWeight;

- (float)getLumaWeight;

- (float)getPopulationWeight;

- (float)getTargetSaturation;

- (float)getTargetLuma;

- (void)normalizeWeights;

- (NSString*)getTargetKey;

+ (NSString*)getTargetModeKey:(PaletteTargetMode)mode;

@end
