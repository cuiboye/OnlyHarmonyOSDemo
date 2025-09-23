import { HMRouter } from '@hadss/hmrouter';
import { CommonHeader } from '../common/common_header';
import { NavigationConstants } from '../common/constants/NavigationConstants';

@HMRouter({pageUrl:NavigationConstants.CUSTOMTABS_PAGE})
@Component
export struct CustomTabsPage {
  @State selectedTabIndex: number = 0

  build() {
    Column() {
      CommonHeader({title:'自定义tabs'})
      Row() {
        this.TabBuilder('tab1', 0)
        this.TabBuilder('tab2', 1)
      }
      .width('100%')
      .margin({ left: 25 })
      .padding({ bottom: 10 })
      .justifyContent(FlexAlign.Start)
      Tabs({ barPosition: BarPosition.Start, index: this.selectedTabIndex }) {
        TabContent() {
          Text('tab1')
        }
        TabContent() {
          Text('tab2')
        }
      }
      .barHeight(0)
      .layoutWeight(1)
      .width('100%')
      .onAnimationStart((index: number, targetIndex: number, extraInfo: TabsAnimationEvent)=>{
        this.selectedTabIndex = targetIndex
      })
    }
    .backgroundColor('#f5f5f5')
    .height('100%')
    .width('100%')
  }

  @Builder
  TabBuilder(tabName: string, targetIndex: number) {
    Row() {
      Text(tabName)
        .fontColor(targetIndex == this.selectedTabIndex ? Color.White : '#636363')
        .fontWeight(targetIndex == this.selectedTabIndex ? FontWeight.Bold : FontWeight.Normal)
        .fontSize(targetIndex == this.selectedTabIndex ? 12 : 11)
    }
    .backgroundColor(targetIndex == this.selectedTabIndex ? '#52B26F' : '#f5f5f5')
    .padding({
      top: 5,
      bottom: 5,
      left: 12,
      right: 12
    })
    .onClick(() => {
      this.selectedTabIndex = targetIndex;
    })
    .borderRadius(15)
  }
}