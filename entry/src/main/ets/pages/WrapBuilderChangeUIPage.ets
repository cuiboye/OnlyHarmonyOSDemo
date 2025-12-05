import { CommonHeader } from '../common/common_header'
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

class Tmp {
  params:string = 'hello'
}

@Builder
function overBuilder(param:Tmp){
  Column(){
    Text(`wrapBuilderValue:${param.params}`)
  }
}

const wBuilder:WrappedBuilder<[Tmp]> = wrapBuilder(overBuilder)

/**
 * wrapBuilder的使用：按引用传递参数时，状态变量的改变会引起@Builder方法内的UI刷新。
 */
@HMRouter({ pageUrl: NavigationConstants.WRAPBUILDER_CHANGEUI_PAGE })
@Component
export struct WrapBuilderChangeUIPage {
  @State label: Tmp = new Tmp()

  build() {
    Column() {
      CommonHeader({ title: 'wrapBuilder的使用' })
      wBuilder.builder({ params: this.label.params })
      Button('点击改变值')
        .onClick(() => {
          this.label.params = "值改变了！"
        })
    }
    .height('100%')
    .width('100%')
  }
}