import { TabBarItemInterface } from "./TabBarItemInterface";
import { TabBarStyle } from "./TabBarStyle";
import { TabContInterface } from "./TabContInterface";
import { TabInfo } from "./TabInfo";

/**
 * 组件工厂，可以注册TabInfo对象并使用
 */
export class ComponentFactory {

  public barStyle?:TabBarStyle

  // tabInfo对象集合
  private tabsInfo: Map<string, TabInfo>

  // 注册标题集合
  private keys: string[] = [];

  /**
   * 构造器
   */
  public constructor() {
    this.tabsInfo = new Map();
  }

  /**
   * 设置tab项内容
   * @param name - tab项标题
   * @param content - tab项内容
   */
  public set(name: string, tabInfo: TabInfo) {
    if (this.tabsInfo.has(name)) {
      this.keys.push(name);
    }
    this.tabsInfo.set(name, tabInfo);
  }

  /**
   * 设置tab项内容
   * @param name - tab项标题
   * @param content - tab项内容
   */
  public getTabInfo(name: string) :TabInfo {
    return this.tabsInfo.get(name) as TabInfo;
  }

  /**
   * 获取tab项内容
   * @param name - tab项标题
   * @returns: tab项内容
   */
  public getContent(name: string): WrappedBuilder<[TabContInterface]> | undefined {
    return this.tabsInfo.get(name)?.contentbuilder;
  }

  /**
   * 获取tabBar
   * @param name - tab项标题
   * @returns: tabBar
   */
  public getBar(name: string): WrappedBuilder<[TabBarItemInterface]> | undefined {
    return this.tabsInfo.get(name)?.barBuilder;
  }


  /**
   * 获取callBack
   */
  public getCb(name: string): ((tag:boolean, isScroller: boolean) => void) | undefined  {
    return this.tabsInfo.get(name)?.cb
  }

  /**
   * 获取callBack
   */
  public setCb(name: string, func: (tag:boolean, isScroller: boolean) => void = (isScroller: boolean) => {
  }) {
    this.tabsInfo.get(name)?.setCb(func)
  }

  /**
   * 删除tab项
   * @param name - tab项标题
   */
  public delete(name: string) {
    this.keys = [];
    this.tabsInfo.delete(name);
  }

  /**
   * 获取注册标题集合
   * @returns: 包含所有注册标题的数组
   */
  public toArray(): string[] {
    if (this.keys.length > 0) {
      return this.keys;
    }
    let array: string[] = [];
    let keys: IterableIterator<string> = this.tabsInfo.keys()
    for (let keysElement of keys) {
      array.push(keysElement);
    }
    return array;
  }
}