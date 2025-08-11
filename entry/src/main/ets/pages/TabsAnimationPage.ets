import { display } from '@kit.ArkUI';

@Entry
@Component
struct TabsAnimationPage{
  tabsController: TabsController = new TabsController();
  pageInfos: NavPathStack = new NavPathStack()
  beginMoveTime :number = 0;
  // @Local currentIndex: number = 0; //当前tab页
  // @Local targetIndex: number = 0;  //目标tab页
  // @Local currentOpacity:number = 1; //当前tab页 tab选中情况下的透明度  变化值1-0
  // @Local targetOpacity:number = 0; //目标tab页 tab 将要被选中时的透明度 变化值0-1

  @State currentIndex: number = 0; //当前tab页
  @State targetIndex: number = 0;  //目标tab页
  @State currentOpacity:number = 1; //当前tab页 tab选中情况下的透明度  变化值1-0
  @State targetOpacity:number = 0; //目标tab页 tab 将要被选中时的透明度 变化值0-1

  screenWidthPx: number = 0

  @State colors: Color[] = [Color.Red, Color.Blue]


  aboutToAppear(): void {
    // 获取屏幕宽度（像素单位）
    this.screenWidthPx = display.getDefaultDisplaySync().width;
  }

  @Builder
  tabBuilder(title: string, index: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Stack(){
        Image(normalImg)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
        Image(selectedImg)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .opacity(this.currentIndex === index?  //如果选择当前的tab 则该图片显示 不透明 如果在移动过程中 target 透明度0-1 当前1-0
            this.targetIndex===index?1:this.currentOpacity:this.targetIndex===index?this.targetOpacity:0)
      }
      Stack(){
        Text(title)
          .margin({ top: 4 })
          .fontSize(12)
          .fontColor('#9E9E9E')
        Text(title)
          .margin({ top: 4 })
          .fontSize(12)
          .fontColor('#007AFF')
          .opacity(this.currentIndex === index?
            this.targetIndex===index?1:this.currentOpacity
            :this.targetIndex===index?this.targetOpacity:0)
        //if (选中页==index){
        //  if(目标页==index){
        //    认为是没有滑动，显示正常选中状态 即 透明度=1
        //  }else{
        //    滑动中，选中页的图片透明度 变化范围是[1-0]
        //  }
        // }else{
        //    if(目标页==index){
        //      滑动中，目标页的图片透明度 变化范围是[0-1]
        //    }else{
        //      不是目标页 也不是当前页 其他页 选中状态的图片透明度 = 0
        //    }
        // ]
      }

    }
    .justifyContent(FlexAlign.Center)
    .height(52)
    .width('100%')
    .onClick(() => {
      this.currentIndex = index;
      this.targetIndex = index;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }
  @Builder
  tabContentBuilder(text: string, index: number, selectedImg: Resource, normalImg: Resource) {
    TabContent() {
      Row() {
        Text(text)
          .height(300)
          .fontSize(30)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .backgroundColor(Color.White)
    .tabBar(this.tabBuilder(text, index, selectedImg, normalImg))
  }
  build() {
    Navigation(this.pageInfos){
      Tabs({ barPosition: BarPosition.End, controller:this.tabsController}) {
        this.tabContentBuilder('首页', 0, $r('app.media.app_home_tabbar_seach'), $r('app.media.app_home_tabbar_seach'))
        this.tabContentBuilder('消息', 1, $r('app.media.app_home_tabbar_seach'), $r('app.media.app_home_tabbar_seach'))
        this.tabContentBuilder('同事圈', 2, $r('app.media.app_home_tabbar_seach'), $r('app.media.app_home_tabbar_seach'))
        this.tabContentBuilder('通讯录', 3, $r('app.media.app_home_tabbar_seach'), $r('app.media.app_home_tabbar_seach'))
        this.tabContentBuilder('我的', 4, $r('app.media.app_home_tabbar_seach'), $r('app.media.app_home_tabbar_seach'))

      }
      .width('100%')
      .backgroundColor('#F3F4F5')
      .barHeight(52)
      .barMode(BarMode.Fixed)
      //tab切换动画时间，例如tab从0-5 直接展示5 不显示中间的滑动过程
      .animationDuration(0)
      // .scrollable(false)  //如果不想让内容滑动,可关闭滑动效果
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        //content 触发切换滑动开始的回调
        // Logger.info("======onAnimationStart",'index:'+index+'targetIndex:'+targetIndex)
        this.currentIndex = targetIndex
        this.targetIndex=targetIndex
        this.currentOpacity =1
        this.targetOpacity = 0
      })

      .onGestureSwipe((index: number, event: TabsAnimationEvent) =>{
        //左划小于0 右滑大于0
        let currentOffset = event.currentOffset
        console.log(`currentOffset is ${currentOffset}`)
        if (currentOffset>0&&index==0) {
          return
        }else if(currentOffset>0){
          this.targetIndex=index-1
        }else if (currentOffset<0&& index<5){
          this.targetIndex=index+1
        }else {
          return
        }

        // 获取屏幕的宽vp 根据手指左右滑动的距离除以屏幕的宽 计算tab图片的透明度
        // let percent = Math.abs(currentOffset)/(getScreenWidth()*3/4)
        let percent = Math.abs(currentOffset)/(this.screenWidthPx*3/4)
        // console.log(`百分比为：${percent}`)
        if (percent>1) {
          percent=1
        }
        if (percent<0) {
          percent=0
        }

        console.log(`百分比为：${percent*5*100}%`)

        this.currentOpacity = 1-percent
        this.targetOpacity =percent;
        // Logger.info("======onGestureSwipe",'index:'+index+'currentOffset:'+event.currentOffset+'percent:'+percent)
      })
    }.hideTitleBar(true).hideToolBar(true)
    .width('100%')
    .height('100%')
  }
}
