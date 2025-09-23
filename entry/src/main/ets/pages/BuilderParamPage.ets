import { HMRouter } from '@hadss/hmrouter';
import { CommonHeader } from '../common/common_header';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * @BuilderParam的使用
 */
@HMRouter({ pageUrl: NavigationConstants.BUILDERPARAM_PAGE })
@Component
export struct BuilderParamPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      CommonHeader()
      BuilderParamComponent({
          customTopView: () => { //箭头函数自动绑定this
            this.CustomTopView()
          }
        }
      )
      Text(`this message is：${this.message}`)
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  CustomTopView() {
    Column() {
      Button('click')
        .onClick(() => {
          this.message = 'custom top view'
        })
    }.width('100%').height(60).backgroundColor(Color.Orange)
  }
}

/**
 * 子组件
 */
@Component
struct BuilderParamComponent {
  @BuilderParam customTopView?: () => void

  build() {
    Column() {
      if (this.customTopView) { //注意这个判断这样写
        this.customTopView() //注意这里有()，否则view不能显示
      } else {
        Text('我是顶部布局')
      }
    }
    .width('100%')
  }
}