//
//  SWFDefAppeal.m
//  webfusion
//
//  Created by Jack Shi on 13-10-13.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFDefAppeal.h"
#import "QElement.h"
#import "QElement+Appearance.h"

@implementation SWFDefAppeal

- (id)init{
    QAppearance *def = [QElement appearance];
    self.labelColorDisabled = def.labelColorDisabled;
    self.labelColorEnabled = def.labelColorEnabled;
    
    self.actionColorDisabled = def.actionColorDisabled;
    self.actionColorEnabled = def.actionColorEnabled;
    
    self.labelFont = def.labelFont;
    self.labelAlignment = def.labelAlignment;
    
    self.backgroundColorDisabled = def.backgroundColorDisabled;
    self.backgroundColorEnabled = def.backgroundColorEnabled;
    
    self.tableSeparatorColor = def.tableSeparatorColor;
    
    self.entryTextColorDisabled = def.entryTextColorDisabled;
    self.entryTextColorEnabled = def.entryTextColorEnabled;
    self.entryAlignment = def.entryAlignment;
    self.entryFont = def.entryFont;
    
    self.buttonAlignment = def.buttonAlignment;
    
    self.valueColorEnabled = def.valueColorEnabled;
    self.valueColorDisabled = def.valueColorDisabled;
    self.valueFont = def.valueFont;
    self.valueAlignment = def.valueAlignment;
    
    self.tableBackgroundColor = def.tableBackgroundColor;
    self.tableGroupedBackgroundColor = def.tableGroupedBackgroundColor;
    
    self.sectionTitleColor = def.sectionTitleColor;
    self.sectionTitleShadowColor = def.sectionTitleShadowColor;
    self.sectionTitleFont = def.sectionTitleFont;
    self.sectionFooterColor = def.sectionFooterColor;
    self.sectionFooterFont = def.sectionFooterFont;
    return self;
}

@end
