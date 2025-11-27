export interface ShowToastOptions {
  message: ResourceStr;
  duration?: number;
  alignment?: Alignment;
  offset?: Position | Edges | LocalizedEdges;
  backgroundColor?: ResourceColor;
  textSize?: Length;
  textColor?: ResourceColor;
  borderRadius?: Length | BorderRadiuses | LocalizedBorderRadiuses;
  padding?: Padding | Length | LocalizedPadding;
  backgroundBlurStyle?: BlurStyle;
  shadow?: ShadowOptions | ShadowStyle;
  // bottom?: string | number;
  // showMode?: ToastShowMode;
  // enableHoverMode?: boolean;
  // hoverModeArea?: HoverModeAreaType;
}