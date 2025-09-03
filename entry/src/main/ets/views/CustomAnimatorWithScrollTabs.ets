import { componentUtils } from '@kit.ArkUI';
import { ComponentFactory } from '../tabs_animator/ComponentFactory';
import { TabBarItemInterface } from '../tabs_animator/TabBarItemInterface';

@Component
export struct CustomAnimatorWithScrollTabs {
  // 页签切换时长
  private animationDuration: number = 360;
  @State canSwipe: boolean = false
  @State isLeftRight: boolean = false
  @State currentIndex: number = 0;
  @State indicatorLeftMargin: number = 0;
  @State indicatorWidth: number = 0;
  @State tabsWidth: number = 0;
  private controller: TabsController = new TabsController();
  private tabLeftOffset: number = 0;
  private touchPosition: Position = { x: 0, y: 0 };
  @Prop barTitles: string[] = [];
  @Consume('factory') factory: ComponentFactory;
  @State showLineIndicator: boolean = false
  private indicatorLeftMarginStart: number = 0;
  private isStartAnimateTo: boolean = false
  @Link startIndex: number
  private currentIndexTemp = 0
  private transCallBack?: (pos: number, swipeRatio: number) => void
  private isUpDownMove: boolean = false;
  private isTag: boolean = false;
  private listController: Scroller = new Scroller()

  build() {
    Column() {
      Stack({ alignContent: Alignment.BottomStart }) {
        // The text of tab.

        List({ space: 30, scroller: this.listController }) {
          ForEach(this.barTitles, (tabName: string, tabIndex: number) => {
            ListItem() {
              Column() {
                tabBar({
                  barStyle: this.factory.barStyle,
                  tabIndex: tabIndex,
                  curIndex: this.currentIndex,
                  title: tabName,
                  indicatorLeftMargin: (result: number) => {
                    this.indicatorLeftMargin = result
                  },
                  indicatorWidth: (result: number) => {
                    this.indicatorWidth = result
                  },
                  indicatorLeftMarginStart: (result: number) => {
                    this.indicatorLeftMarginStart = result
                  },
                  showLineIndicator: (result: boolean) => {
                    this.showLineIndicator = result
                  }
                });
              }.onClick(() => {
                this.controller.changeIndex(tabIndex);
                this.currentIndex = tabIndex;
                this.startIndex = tabIndex
              })
            }
          }, (item: number, _index: number) => item.toString())
        }
        .width('100%')
        .height(43)
        .listDirection(Axis.Horizontal)
        .contentStartOffset(20)
        .contentEndOffset(10)
        .scrollBar(BarState.Off)
        .padding({ bottom: 10 })

        Column() {
          Column()
            .backgroundColor(this.factory.barStyle?.selectBarColor)
            .width(20)
            .alignItems(HorizontalAlign.Center)
            .borderRadius(4)
            .height(2)
        }
        .width(this.indicatorWidth)
        .height(4)
        .margin({
          left: this.indicatorLeftMargin,
          top: (33)
        })

      }
      .height(35)
      // .visibility(Visibility.None)
      .margin({ left: this.tabLeftOffset })

      Tabs({ index: this.startIndex, controller: this.controller }) {
        TabContent() {
          Text('tab1')
        }
        TabContent() {
          Text('tab2')
        }
        TabContent() {
          Text('tab3')
        }
        TabContent() {
          Text('tab4')
        }
        TabContent() {
          Text('tab5')
        }
        TabContent() {
          Text('tab6')
        }
        TabContent() {
          Text('tab7')
        }
        TabContent() {
          Text('tab8')
        }
      }
      .onAreaChange((_, newValue: Area) => {
        this.tabsWidth = Number.parseFloat(newValue.width.toString());
      })
      .barWidth('100%')
      .barHeight(0)
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .animationDuration(160)
      .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
        //todo
        if (this.factory.getCb(this.barTitles[index]) && !this.isTag) {
          (this.factory.getCb(this.barTitles[index]) as Function)(false, true)
          this.isTag = true
        }

        let curOffset: number = event.currentOffset;
        let targetIndex: number = index;

        if ((index === 0 && curOffset > 0) ||
          (index === this.barTitles.length - 1 && curOffset < 0)) {
          curOffset = 0;
        }

        let ratio: number = Math.abs(curOffset / this.tabsWidth); // tab滑动比例
        if (curOffset < 0) { // tab右滑
          targetIndex = index + 1;
        } else if (curOffset > 0) { // tab左滑
          targetIndex = index - 1;
        }

        this.currentIndexTemp = targetIndex

        if (this.isStartAnimateTo) {
          return
        }

        let currentIndicator = this.getCurrentIndicatorInfo(index, event);

        if (this.indicatorLeftMargin <= this.indicatorLeftMarginStart) {
          this.indicatorLeftMargin = this.indicatorLeftMarginStart
        }

        if (Math.abs(this.indicatorLeftMargin - currentIndicator.left) <= 20) {
          this.indicatorLeftMargin = currentIndicator.left;
          this.indicatorWidth = currentIndicator.width;
          this.currentIndex = currentIndicator.index;
        }

      })
      .onChange((index: number) => {
        // this.currentIndex = index // 监听索引index的变化，实现页签内容的切换。
        // this.startIndex = index
        // let targetIndexInfo = this.getTextInfo(index);
        // this.startAnimateTo(this.animationDuration, targetIndexInfo.left, targetIndexInfo.width);

        this.currentIndex = index // 监听索引index的变化，实现页签内容的切换。
        this.startIndex = index
        let targetIndexInfo = this.getTextInfo(index);
        this.startAnimateTo(this.animationDuration, targetIndexInfo.left, targetIndexInfo.width);
        this.listController.scrollToIndex(this.currentIndex, true, ScrollAlign.CENTER)
      })
      .onAnimationEnd((index: number, event: TabsAnimationEvent) => {

      })
      .onAnimationStart((index: number, targetIndex: number, _event: TabsAnimationEvent) => {
        // this.currentIndex = targetIndex;
        // let targetIndexInfo = this.getTextInfo(targetIndex);
        // this.startAnimateTo(this.animationDuration, targetIndexInfo.left, targetIndexInfo.width);

        this.currentIndex = targetIndex;
        let targetIndexInfo = this.getTextInfo(targetIndex);
        this.startAnimateTo(this.animationDuration, targetIndexInfo.left, targetIndexInfo.width);
        this.listController.scrollToIndex(this.currentIndex, true, ScrollAlign.CENTER)
      })
    }
    .margin({
      top: 10
    })
    .height('100%')
    .layoutWeight(1)
    .onAreaChange(() => {
      this.controller.changeIndex(this.currentIndex);
      this.listController.scrollToIndex(this.currentIndex, true, ScrollAlign.CENTER)
    })
    .onTouch((event?: TouchEvent) => { // 具体处理逻辑根据实际需求修改，这里仅作为示例参考
      if (event) {
        if (event.type === TouchType.Down) {
          this.isUpDownMove = false
          this.canSwipe = false
          this.isLeftRight = false
          this.touchPosition = {
            x: event.touches[0].windowX,
            y: event.touches[0].windowY
          }
        } else if (event.type === TouchType.Move) {

          if (this.isLeftRight || this.isUpDownMove) {
            return
          }

          let moveX = event.changedTouches[0].windowX - (this.touchPosition.x as number)
          let moveY = event.changedTouches[0].windowY - (this.touchPosition.y as number)

          if (!this.canSwipe && Math.abs(moveX) > 0) {
            if (Math.abs(moveX) > Math.abs(moveY)) {
              this.isUpDownMove = false
              this.isLeftRight = true;
            } else {
              this.isUpDownMove = true
              this.isLeftRight = false;
            }
            this.canSwipe = true

            if (this.factory.getCb(this.barTitles[this.currentIndex])) {
              (this.factory.getCb(this.barTitles[this.currentIndex]) as Function)(this.isUpDownMove, false)
              this.isTag = false
            }
          }

          this.touchPosition = {
            x: event.changedTouches[0].windowX,
            y: event.changedTouches[0].windowY
          }
        } else {
          this.canSwipe = false
          this.isLeftRight = false
        }
      }
    })
  }

  private getCurrentIndicatorInfo(index: number, event: TabsAnimationEvent): Record<string, number> {
    let nextIndex = index;
    if (index > 0 && event.currentOffset > 0) {
      // swipe to left.
      nextIndex--;
    } else if (index < this.barTitles.length && event.currentOffset > 0) {
      // swipe to right.
      nextIndex++;
    }

    let indexInfo = this.getTextInfo(index);
    let nextIndexInfo = this.getTextInfo(index);

    let swipeRatio = Math.abs(event.currentOffset / this.tabsWidth);

    // LogUtils.d(0x0000, 'swipeRatio', "swipeRatio:" + swipeRatio);
    let currentIndex = swipeRatio > 0.5 ? nextIndex : index;
    let currentIndicatorLeft: number = indexInfo.left + (-event.currentOffset / 3) * swipeRatio;
    let currentIndicatorWidth: number = indexInfo.width + (nextIndexInfo.width - indexInfo.width) * swipeRatio;

    if (this.transCallBack && this.currentIndexTemp === index) {
      if (event.currentOffset <= 0) {
        this.transCallBack(index, Math.abs(event.currentOffset / (this.tabsWidth / 2)))
      } else {
        this.transCallBack(index - 1, 1 - Math.abs(event.currentOffset / (this.tabsWidth / 2)))
      }
    }

    return {
      'index': currentIndex,
      'left': currentIndicatorLeft,
      'width': currentIndicatorWidth,
      'swipeRatio': swipeRatio
    };
  }

  private getTextInfo(index: number): Record<string, number> {
    let modePosition: componentUtils.ComponentInfo = componentUtils.getRectangleById(index.toString());
    return { 'left': px2vp(modePosition.screenOffset.x), 'width': px2vp(modePosition.size.width) };
  }

  private startAnimateTo(duration: number, leftMargin: number, width: number) {
    this.isStartAnimateTo = true

    if (this.transCallBack) { // && this.currentIndexTemp === this.currentIndex
      this.transCallBack(this.currentIndex, 0)
    }

    animateTo({
      duration: duration,
      curve: Curve.Linear,
      iterations: 1,
      playMode: PlayMode.Normal,
    }, () => {
      this.isStartAnimateTo = false
      this.indicatorLeftMargin = leftMargin;
      this.indicatorWidth = width;
    })
  }
}

/**
 * 默认tabBar样式
 * @param {TabBarItemInterface} $$ - 返回的页签信息
 */
@Builder
export function tabBar($$: TabBarItemInterface) {
  Row() {
    Text($$.title)
      .fontSize($$.tabIndex === $$.curIndex ? 16 : 14)
      .lineHeight(22)
      .textAlign(TextAlign.Center)
      .fontFamily('fzjunhjw_cu_0')
      .fontColor($$.tabIndex === $$.curIndex ? $$.barStyle?.selectFontColor : $$.barStyle?.defaultFontColor)
      .fontWeight($$.tabIndex === $$.curIndex ? FontWeight.Bold : FontWeight.Medium)
      .id($$.tabIndex.toString())
      .onAreaChange((_, newValue: Area) => {
        if ($$.curIndex === $$.tabIndex) {
          let positionX: number;
          let width: number = Number.parseFloat(newValue.width.toString());
          if (newValue.globalPosition.x !== undefined) {
            positionX = Number.parseFloat(newValue.globalPosition.x?.toString())
            let indicatorLeftMarginTemp = Number.isNaN(positionX) ? 0 : positionX;
            $$.indicatorLeftMargin(indicatorLeftMarginTemp)
          }
          $$.indicatorWidth(width);
        }

        setTimeout(() => {
          $$.showLineIndicator(true)
        }, 300)

      })
  }
  .justifyContent(FlexAlign.Center)
  .constraintSize({ minWidth: 35 })

  .height(35)
}

