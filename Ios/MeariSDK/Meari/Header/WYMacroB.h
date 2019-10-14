
#ifndef WYMacroB_h
#define WYMacroB_h


#pragma mark - /* UserDefaults **/
#define WY_USER_ACCOUNT     [MeariUser sharedInstance].userInfo.userAccount
#define WY_USER_ID          [MeariUser sharedInstance].userInfo.userID
#define WY_USER_NICK        [MeariUser sharedInstance].userInfo.nickName
#define WY_USER_IMAGE       [MeariUser sharedInstance].userInfo.avatarUrl

#pragma mark - /* Network */
#define WY_Network_NoReachable  ({\
__block BOOL noReachable = NO;\
[MeariUser HttpMonitorNetworkStatus:^(MeariNetworkReachabilityStatus status) {\
    noReachable = status == MeariNetworkReachabilityStatusNotReachable;\
}];\
(noReachable);\
})


#pragma mark - /* Localization **/
#define WYLocalString(key)      [[NSBundle wy_bundle] localizedStringForKey:key value:nil table:nil]
#define WYLocal_Tips            WYLocalString(@"Tips")
#define WYLocal_Cancel          WYLocalString(@"Cancel")
#define WYLocal_OK              WYLocalString(@"OK")
#define WYLocal_Timeout         WYLocalString(@"Timeout")
#define WYLocal_Set             WYLocalString(@"Set")
#define WYLocal_Next            WYLocalString(@"Next")





#pragma mark - /* Font **/
#define WYFontNormal(arg)       [UIFont systemFontOfSize:arg]
#define WYFontBold(arg)         [UIFont boldSystemFontOfSize:arg]
#define WYFont_Text_XXS_Normal  WYFontNormal(11.0f)
#define WYFont_Text_XXS_Bold    WYFontBold(11.0f)
#define WYFont_Text_XS_Normal   WYFontNormal(13.0f)
#define WYFont_Text_XS_Bold     WYFontBold(13.0f)
#define WYFont_Text_S_Normal    WYFontNormal(15.0f)
#define WYFont_Text_S_Bold      WYFontBold(15.0f)
#define WYFont_Text_M_Normal    WYFontNormal(17.0f)
#define WYFont_Text_M_Bold      WYFontBold(17.0f)
#define WYFont_Text_L_Normal    WYFontNormal(19.0f)
#define WYFont_Text_L_Bold      WYFontBold(19.0f)
#define WYFont_Text_XL_Normal   WYFontNormal(21.0f)
#define WYFont_Text_XL_Bold     WYFontBold(21.0f)




#pragma mark - /* Color **/
#define WY_SVP_BGColor              [UIColor colorFromHexCode:@"000000aa"]
#define WY_MainColor                [UIColor colorFromHexCode:@"21bba3"]
#define WY_BGColor_Highlighted_cell [UIColor colorFromHexCode:@"efeff0"]
#define WY_BGColor_LightGray        [UIColor colorFromHexCode:@"f8f8f8"]
#define WY_BGColor_LightGray2       [UIColor colorFromHexCode:@"e1e0e6"]
#define WY_BGColor_LightGray3       [UIColor colorFromHexCode:@"cecece"]
#define WY_BGColor_LightOrange      [UIColor colorFromHexCode:@"ffeedd"]
#define WY_BGColor_White_A          [UIColor colorFromHexCode:@"ffffffd9"]
#define WY_FontColor_LightBlack     [UIColor colorFromHexCode:@"848484"]
#define WY_LineColor_LightGray      [UIColor colorFromHexCode:@"d4d4d4"]
#define WY_FontColor_Black          [UIColor colorFromHexCode:@"333333"]
#define WY_FontColor_LightBlack     [UIColor colorFromHexCode:@"848484"]
#define WY_FontColor_SLightBlack    [UIColor colorFromHexCode:@"cccccc"]
#define WY_FontColor_Gray           [UIColor colorFromHexCode:@"9a9a9a"]
#define WY_FontColor_Gray2          [UIColor colorFromHexCode:@"a1a1a1"]
#define WY_FontColor_GrayA          [UIColor colorFromHexCode:@"aaaaaa"]
#define WY_FontColor_LightGray      [UIColor colorFromHexCode:@"cccccc"]
#define WY_FontColor_Cyan           [UIColor colorFromHexCode:@"21bba3"]
#define WY_FontColor_Red            [UIColor colorFromHexCode:@"f24434"]
#define WY_FontColor_Orange         [UIColor colorFromHexCode:@"f39700"]
#define WY_FontColor_DarkOrange     [UIColor colorFromHexCode:@"ff9966"]
#define WY_FontColor_LightOrange    [UIColor colorFromHexCode:@"ffcc99"]
#define WY_FontColor_Disabled       [UIColor colorFromHexCode:@"cccccc"]
#define WY_FontColor_White          [UIColor colorFromHexCode:@"ffffff"]
#define WY_FontColor_DarkYellow     [UIColor colorFromHexCode:@"f4e036"]
#define WY_FontColor_Yellow         [UIColor yellowColor]
#define WY_BounderColor_Brown       [UIColor colorFromHexCode:@"949494"]



#define WY_NormalRowHeight 70



#endif /* WYMacroB_h */




