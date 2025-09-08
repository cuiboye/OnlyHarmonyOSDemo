import { MyController } from "./MyController";
import { promptAction } from "@kit.ArkUI";

@Component
export struct ChildComponent{
  controller: MyController = new MyController()
  @State value:string = ''
  onChildComponentClick?: (value: string) => void//子组件的事件回调给父组件

  aboutToAppear(): void {
    this.controller.onClickFatherFunction = (value:string)=>{
      this.value = value
      promptAction.showToast({message:'子组件监听到了父组件中的方法执行'})
    }
  }

  build() {
    Column(){
      Text(`子组件监听到了父组件中的方法执行,子组件接收的值为： ${this.value}`)
      Button('我是子组件-点击我会将事件回调给父组件')
        .onClick(()=>{
          this.onChildComponentClick?.('hello')
        })
    }
  }
}