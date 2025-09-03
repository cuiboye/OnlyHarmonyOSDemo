import { TabBarItemInterface } from './TabBarItemInterface';
import { TabContInterface } from './TabContInterface';
import { TabsBean } from './TabItemBean';

/**
 * tabinfo
 */
export class TabInfo {
  // tab项标题
  title: string;
  // vip item信息
  tabBean: TabsBean
  // tab content内容
  contentbuilder: WrappedBuilder<[TabContInterface]>;
  // tabBar 页签样式
  barBuilder?: WrappedBuilder<[TabBarItemInterface]>;
  // 滑动回调
  cb: (tag:boolean, isScroller: boolean) => void = () => {
  }

  /**
   * TabInfo构造器
   * @param title - tab项标题
   * @param contentBuilder - tab项内容
   * @param barBuilder - tabBar
   */
  constructor(title: string, tabBean: TabsBean, contentBuilder: WrappedBuilder<[TabContInterface]>,
    barBuilder?: WrappedBuilder<[TabBarItemInterface]>, callb1: (isScroller: boolean) => void = () => {
    }) {
    this.title = title;
    this.tabBean = tabBean;
    this.contentbuilder = contentBuilder;
    this.barBuilder = barBuilder;
    this.cb = callb1
  }


  public setCb(cb: (tag:boolean, isScroller: boolean) => void) {
    this.cb = cb
  }
}