/**
 *  弹窗工具类，参数类
 */
export interface WkBaseDialogOptions {
  uiContext?: UIContext;

  //点击返回键或手势返回时，是否关闭弹窗
  backCancel?: boolean;

  //弹框id，具有唯一性
  dialogId?: string;

  //弹窗的对齐方式。
  alignment?: DialogAlignment;

  //弹窗相对alignment所在位置的偏移量
  offset?: Offset;

  // 自定义蒙层颜色
  maskColor?: ResourceColor;

  // 弹窗是否为模态窗口，模态窗口有蒙层，非模态窗口无蒙层。
  isModal?: boolean;

  // 某弹框需要显示在主窗口之外时，是否在子窗口显示此弹窗。
  showInSubWindow?: boolean;

  //点击遮障层时，是否关闭弹窗
  autoCancel?: boolean;

  // 设置弹窗显示和退出的过渡效果。
  transition?: TransitionEffect;

  //弹窗显示动效前的事件回调。
  onWillAppear?: VoidCallback;

  //弹窗退出动效前的事件回调。
  onWillDisappear?: VoidCallback;

  //弹窗弹出时的事件回调。
  onDidAppear?: VoidCallback;

  //弹窗消失时的事件回调。
  onDidDisappear?: VoidCallback;

  //交互式关闭回调函数。
  onWillDismiss?: Callback<DismissDialogAction>;

  levelMode?: LevelMode;

  levelUniqueId?: number;

  immersiveMode?: ImmersiveMode;

}