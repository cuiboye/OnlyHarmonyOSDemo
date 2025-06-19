import { CommonHeader } from '../../../common/common_header'
import { HomePage } from './home/home_page';
import HomeSearch from './home/home_search';
import { ShopCarPage } from './ShopCarPage';

/**
 * 挖酒主页
 */
@Entry
@Component
struct WajiuMainPage {
  @State titleBarPadding: number = 0;
  private tabsController: TabsController = new TabsController()
  @State currentIndex: number = 0
  @StorageProp('navigationHeight') navigationHeight: number = 0

  build() {
    Column() {
      Tabs({ index:this.currentIndex,barPosition: BarPosition.End, controller: this.tabsController }) {
        TabContent() {
          HomePage()
        }.tabBar(this.TabBuilder('首页', 0, $r('app.media.tabbar_home'), $r('app.media.tabbar_home_red')))

        TabContent() {
          Text('分类')
        }.tabBar(this.TabBuilder('分类', 1, $r('app.media.tabbar_category'), $r('app.media.tabbar_category_red')))

        TabContent() {
          Text('信息台')
        }
        .tabBar(this.TabBuilder('信息台', 2, $r('app.media.tabbar_information_desk'), $r('app.media.tabbar_information_desk_red')))

        TabContent() {
          ShopCarPage()
        }
        .tabBar(this.TabBuilder('采购车', 3, $r('app.media.tabbar_shopping_car'), $r('app.media.tabbar_shopping_car_red')))

        TabContent() {
          Text('我的')
        }.tabBar(this.TabBuilder('我的', 4, $r('app.media.tabbar_mine'), $r('app.media.tabbar_mine_red')))
      }.layoutWeight(1)
      .onChange((index:number)=>{
        if(index){
          this.currentIndex = index
        }
      })
    }

    .height('100%')
    .width('100%')
    .padding({ bottom: px2vp(this.navigationHeight) }) //导航栏的高度为px，需要转为vp
  }

  //自定义导航栏
  @Builder TabBuilder(text: string, targetIndex: number, normalImage: Resource, selectedImage: Resource) {
    Column() {
      Image(targetIndex == this.currentIndex ? selectedImage : normalImage)
        .width(28)
        .margin({ bottom: 5 })
      Text(text)
        .fontSize(12)
        .fontColor(targetIndex == this.currentIndex ? $r('app.color.f56e1d') : $r('app.color.999999'))
    }.onClick(() => {
      this.currentIndex = targetIndex;
    })
    .backgroundColor($r('app.color.f8f7f7'))
    .width('100%')
    .padding({ top: 5, bottom: 5 })
  }
}
