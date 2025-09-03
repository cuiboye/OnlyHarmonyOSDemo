import { TabBarStyle } from "./TabBarStyle";

export interface TabBarItemInterface {
  barStyle?:TabBarStyle
  tabIndex:number
  curIndex: number

  // 页签标题
  title: string;
  indicatorLeftMargin: (result:number)=>void
  indicatorWidth:  (result:number)=>void

  indicatorLeftMarginStart:(result:number)=>void

  showLineIndicator:(result:boolean)=>void
}