import { ImmersiveMode, LevelMode } from "@kit.ArkUI"

/**
 *  弹窗工具类，默认配置参数
 */
export class DialogDefaultConfig {

  backCancel: boolean = true
  autoCancel: boolean = true
  alignment: DialogAlignment = DialogAlignment.Center
  offset: Offset = { dx: 0, dy: 0 }

  maskRect: Rectangle = { x: 0, y: 0, width: '100%', height: '100%' }

  maskColor: ResourceColor = "#66000000"
  isModal: boolean = true
  showInSubWindow: boolean = false
  transition?: TransitionEffect
  onWillDismiss?: Callback<DismissDialogAction>
  onDidDisappear?: VoidCallback

  // 加载动画或进度条的大小
  loadingLoadSize: number = 60
  //加载动画或进度条的颜色
  loadingLoadColor: ResourceColor = Color.White
  //加载动画的提示文字
  loadingContent: ResourceStr = ''
  //文字大小
  loadingFontSize: number | string | Resource = 13
  //文字颜色
  loadingFontColor: ResourceColor = Color.White
  //背景颜色
  loadingBackgroundColor: ResourceColor = '#CC000000'
  // 背景圆角
  loadingBorderRadius: Length | BorderRadiuses = 10
  //文字与动画的间距
  loadingMarginTop: number | string | Resource = 20

  loadingPadding: Padding | Length = 25


  //TOAST文字大小
  toastFontSize: number | string | Resource = 16
  //toast文字颜色
  toastFontColor: ResourceColor = Color.White
  //toast背景颜色
  toastBackgroundColor: ResourceColor = "#333333"
  //toast背景圆角
  toastBorderRadius: Length | BorderRadiuses = 8
  // 内边距
  toastPadding: Padding | Length = { left: 16, right: 16, top: 12, bottom: 12 }
  //图片尺寸
  toastImageSize: SizeOptions = { width: 41, height: 41 }
  //Duration
  toastDuration: number = 1000
  //Duration
  toastDurationLong: number = 2000

  // levelMode: LevelMode.EMBEDDED, // 启用页面级弹出框
  // levelUniqueId: node?.getUniqueId(), // 设置页面级弹出框所在页面的任意节点ID
  // immersiveMode: ImmersiveMode.EXTEND, // 设置页面级弹出框蒙层的显示模式

  levelMode?: LevelMode

  levelUniqueId?: number;

  immersiveMode?: ImmersiveMode


}