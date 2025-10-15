import { HMRouter } from "@hadss/hmrouter"
import { drawing } from "@kit.ArkGraphics2D"
import { CommonHeader } from "../common/common_header"
import { NavigationConstants } from "../common/constants/NavigationConstants"
import { promptAction } from "@kit.ArkUI"

/**
 * 横向滚动的List-定位到中间，设置开始和结束位置的偏移量
 */
@HMRouter({pageUrl:NavigationConstants.HORIZONTALLISTWITHCENTERSCOLL_PAGE})
@Component
export struct HorizontalListWithCenterScollPage {
  private firstLevelListScroller: Scroller = new Scroller()
  @State selectFirstLevelIndex: number = 0 //一级类别选中项
  @StorageProp('displayWidth') @Watch("testWatch") displayWidth: number = 0
  private isUserScroll: boolean = false
  list: Array<string> =
    ['牡丹花', '菊花', '玫瑰花', '栀子花', '金银花', '仙人掌', '梨花', '西瓜', 'aa', 'bb', 'aa', 'bb', 'aa', 'bb',]

  /**
   * 测试@Watch
   */
  testWatch(propName:string){
    console.log(`propName is ${propName}`)
    promptAction.showToast({message:'屏幕状态发生了变化'})
  }
 
  build() {
    Column() {
      CommonHeader()
      List({ space: 30, scroller: this.firstLevelListScroller }) {
        ForEach(this.list, (item: string, index: number) => {
          ListItem() {
            FirstMenuItemComponent({
              data: item,
              index: index,
              selectFirstLevelIndex: this.selectFirstLevelIndex
            })
          }
          .margin({ bottom: 122 })
          .height(40)
          .onClick(() => {
            // 数据打点：拍照生成页 一级tab选中
            this.firstLevelListScroller.scrollToIndex(index, true, ScrollAlign.CENTER)
          })
        })
      }
      .friction(10)
      .onScrollIndex((start: number, end: number, center: number) => {
        if (this.isUserScroll) {
          this.selectFirstLevelIndex = center
        }
      })
      .onScrollStart(() => {
        this.isUserScroll = true
        this.slideDarkBackgroundStar()
      })
      .onScrollStop(() => {
        this.isUserScroll = false
        this.slideDarkBackgroundStop()
        this.firstLevelListScroller.scrollToIndex(this.selectFirstLevelIndex, true, ScrollAlign.CENTER)
      })
      .scrollBar(BarState.Off)
      .contentStartOffset(this.displayWidth / 2 -
        (new drawing.Font().measureText(this.list[this.selectFirstLevelIndex], 0) / 2)) //设置List开始位置的偏移量
      .contentEndOffset(this.displayWidth / 2 -
        (new drawing.Font().measureText(this.list[this.selectFirstLevelIndex], 0) / 2)) //设置List结束位置的偏移量
      .listDirection(Axis.Horizontal)
      .height(25)

      Text()
        .width(10)
        .height(2)
        .backgroundColor(Color.Blue)
        .margin({ top: 10 })
    }

    .backgroundColor(Color.Pink)
    .width('100%')
  }

  private slideDarkBackgroundStar() {

  }

  private slideDarkBackgroundStop() {

  }
}

@Component
export struct FirstMenuItemComponent {
  data: string = ''
  index: number = 0
  @Prop selectFirstLevelIndex: number

  build() {
    Column() {
      Text(this.data ?? '')
        .fontSize(13)
        .fontColor(this.selectFirstLevelIndex === this.index ? '#ffffff' : '#99ffffff')
        .fontWeight(this.selectFirstLevelIndex === this.index ? FontWeight.Medium : FontWeight.Normal)
    }
  }
}