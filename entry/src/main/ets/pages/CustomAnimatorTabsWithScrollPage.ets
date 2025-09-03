import { CommonHeader } from "../common/common_header";
import { ComponentFactory } from "../tabs_animator/ComponentFactory";
import { TabsBean } from "../tabs_animator/TabItemBean";
import { CustomAnimatorTabs } from "../views/CustomAnimatorTabs";
import { CustomAnimatorWithScrollTabs } from "../views/CustomAnimatorWithScrollTabs";

/**
 * 带有动画的tabs-可滚动
 */
@Entry
@Component
export struct CustomAnimatorTabsWithScrollPage {
  private ctx: UIContext = this.getUIContext();
  @State currentSelectedIndex: number = 0

  @State itemIndex: number = 0
  @State barTitles: string[] = [];
  @Provide('factory') factory: ComponentFactory = new ComponentFactory();
  @State tabDataList?: Array<TabsBean> = new Array

  /**
   * 背景渐变处理
   */
  private transCallBack: (position: number, swipeRatio: number) => void = (position: number, swipeRatio: number) => {
    // LogUtils.d("-------------huidiao----swipeRatio:" + swipeRatio + "  .currentIndex:" + position)
  }

  aboutToAppear(): void {
    this.factory.barStyle = {
      selectFontColor:'#1cb584',
      defaultFontColor: '#676767',
      selectBarColor: '#1cb584',
      selectFontSize: 16,
    }
  }

  build() {
    Column() {
      CommonHeader({title:'带有动画的Tabs'})

      CustomAnimatorWithScrollTabs({//数据比较多的时候，tabs可以滚动的时候使用这个
        // barTitles: ['文档'],
        barTitles: ['语文','数学','英语','体育','语文1','数学2','英语3','体育4'],
        startIndex: this.itemIndex,
        currentIndex: this.itemIndex,
        transCallBack: this.transCallBack
      }).height("100%").backgroundColor(Color.Transparent)
        .layoutWeight(1)
    }
  }

  /**
   * 定位到指定位置
   * @param params
   */
  scrollToItem(params: string): void {
    if (params === 'tab1') {
      this.itemIndex = 0
    } else if (params === 'tab2') {
      this.itemIndex = 1
    } else if (params === 'tab3') {
      this.itemIndex = 2
    }
  }

  @Builder
  TabBuilder(tabName: string, targetIndex: number) {
    Column() {
      Text(tabName)
        .fontColor(targetIndex == this.currentSelectedIndex ?  '#5FC398' :'#676767' )
        .fontWeight(targetIndex == this.currentSelectedIndex ? FontWeight.Bold : FontWeight.Normal)
        .fontSize(targetIndex == this.currentSelectedIndex ? 16 : 14)
      Row()
        .margin({top:5})
        .height(2)
        .width(20)
        .backgroundColor(targetIndex == this.currentSelectedIndex ?'#5FC398': Color.White )
    }
    .padding({
      top: 7,
      bottom: 7,
      left: 20,
      right: 20
    })
    .onClick(() => {
      this.currentSelectedIndex = targetIndex;
    })
  }
}
