import { WkBaseDialogOptions } from './WkBaseDialogOptions';

type DialogOptionsCallback = (param?: Record<string, ESObject> | null) => void;

/**
 *  弹窗配置项
 */
export interface DialogOptions extends WkBaseDialogOptions {
  // 可能会用到 - 需要时拓展弹窗
  firstTitle?: ResourceStr;
  // 标题
  title?: ResourceStr;
  // 内容
  content?: ResourceStr;
  // 左侧按钮文案
  leftBtnStr?: ResourceStr
  // 左侧按钮字体颜色
  leftBtnStrColor?: ResourceStr
  // 左侧按钮背景颜色
  leftBtnBgColor?: ResourceStr

  // 右侧按钮文案
  rightBtnStr?: ResourceStr
  // 右侧按钮字体颜色
  rightBtnStrColor?: ResourceStr
  // 右侧按钮背景颜色
  rightBtnBgColor?: ResourceStr

  // 左侧按钮点击
  leftCb?: DialogOptionsCallback
  // 右侧按钮点击
  rightCb?: DialogOptionsCallback
  //分享点击回调
  ShareItemCb?:(type:number)=>void
  //文本居中
  textAlign?:TextAlign

}
