/**
 * 吸顶效果
 */
import { common } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'
import { CommonStatusBar } from '../common/common_top_statusbar'

@Entry
@Component
struct CeilingPage {
  @State list: number[] = []
  private context = getContext(this) as common.UIAbilityContext

  aboutToAppear() {//添加测试数据
    for (let i = 0; i < 30; i++) {
      this.list.push(i)
    }

    //去除安全区域，需要使用手动获取顶部的bar高度，不然吸顶展示会有问题
    window.getLastWindow(this.context).then((windowClass) => {
      windowClass.setWindowSystemBarEnable([]).then(() => {
      })
    })
  }

  @Styles
  listStyle() {
    .backgroundColor(Color.White)
    .height(72)
    .width("100%")
    .borderRadius(12)
  }

  @Builder
  TabBuilder(title: string) {
    Column() {
      Text(title)
        .fontSize(20)
        .fontColor(Color.White)
    }
    .padding({ top: 10, bottom: 10 })
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Pink)
    .height(56)
    .width('100%')
  }

  build() {
    Column(){
      CommonStatusBar()
      Scroll() {
        Column() {
          Text("头部滚动区域")
            .width("100%")
            .height("30%")
            .fontSize(20)
            .fontColor(Color.White)
            .backgroundColor('#0080DC')
            .textAlign(TextAlign.Center)

          Tabs() {
            TabContent() {
              List({ space: 10 }) {
                ForEach(this.list, (item: number) => {
                  ListItem() {
                    Text("item" + item).fontSize(16)
                  }.listStyle()
                }, (item: string) => item)
              }.width("100%")
              .height('100%')
              .edgeEffect(EdgeEffect.None)//吸顶效果关键属性
              .nestedScroll({//吸顶效果关键属性
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              })
            }.tabBar(this.TabBuilder("我是吸顶布局"))
          }
          .vertical(false)
          .height("100%")
        }.width("100%")
      }
      .edgeEffect(EdgeEffect.None)
      .backgroundColor('#DCDCDC')
      .scrollBar(BarState.Off)
      .layoutWeight(1)//这里需要设置权重，否则List会展示不全
    }
    .width('100%')
    .height('100%')
  }
}