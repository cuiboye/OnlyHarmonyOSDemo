import { MyController } from "./MyController";
import { promptAction } from "@kit.ArkUI";

@Component
export struct ChildComponent{
  controller: MyController = new MyController()
  @State value:string = ''

  aboutToAppear(): void {
    this.controller.onClickFatherFunction = (value:string)=>{
      this.value = value
      promptAction.showToast({message:'子组件监听到了父组件中的方法执行'})
    }
  }

  build() {
    Column(){
      Text(`子组件监听到了父组件中的方法执行,子组件接收的值为： ${this.value}`)
    }
  }
}