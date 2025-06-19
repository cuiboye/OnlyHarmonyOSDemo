
import { CommonHeader } from '../../common/common_header';
import { router } from '@kit.ArkUI';

/**
 * 第二个页面
 */

class SecondRouterParams{
  id:number = 0
  name:string = ''
}

@Entry
@Component
struct SecondRouter {
  @State message: string = 'Hello World'

  aboutToAppear(){
    //在aboutToAppear接收参数
    const params:SecondRouterParams = router.getParams() as SecondRouterParams;
    const id:number = params.id;
    const name:string = params.name;
    console.log(`接受到的参数： id=${id},name=${name}`)
    console.log(`生命周期： aboutToAppear`)
  }

  onPageShow(){
    console.log(`生命周期： onPageShow`)
  }

  onPageHide(){
    console.log(`生命周期： onPageHide`)
  }

  aboutToDisappear(){
    console.log(`生命周期： aboutToDisappear`)
  }

  build() {
    Column() {
        CommonHeader({title:'第二个页面'})

        Button('返回到上一个页面并携带参数').onClick(() => {
          router.back({
            url:'pages/routerdemo/first_router',
            params:{'backParams':'secondRouter'}
          })
        })

        Button('跳转到第三个页面').onClick(() => {
          router.pushUrl({
            url:'pages/routerdemo/ThreeRouterPage',
          })
        })
    }
    .height('100%')
  }
}