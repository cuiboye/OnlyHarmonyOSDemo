import { HMRouter } from "@hadss/hmrouter";
import { CommonHeader } from "../../common/common_header";
import { NavigationConstants } from "../../common/constants/NavigationConstants";
import { ChildComponent } from "./ChildComponent";
import { MyController } from "./MyController";

/**
 * 1）子组件监听父组件中的方法操作：使用controller
 * 2）父组件监听子组件中的方法操作：直接给子组件传递一个参数，这个参数是方法类型的
 */
@HMRouter({ pageUrl: NavigationConstants.CHILDLISTENERFATHERFUNCTION_PAGE })
@Component
export struct ChildListenerFatherFunctionPage {
  controller: MyController = new MyController()

  build() {
    Column() {
      CommonHeader()
      Button('click-我是父组件')
        .onClick(() => {
          this.controller.onClickFatherFunction('父组件执行了方法')
        })

      ChildComponent({controller:this.controller})
    }
  }
}



