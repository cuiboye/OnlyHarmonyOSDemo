
import router from '@ohos.router'
import { CommonHeader } from '../../common/common_header'
/**
 * 第一个页面
 */
@Entry
@Component
struct FirstRouter {
  @State message: string = 'Hello World'

  build() {
    Column() {
      CommonHeader({title:'第一个页面'})

      Button('跳转到下一个页面并携带参数').onClick(() => {
        router.pushUrl(
          {
            url: 'pages/routerdemo/second_router',
            params: {
              id: 123,
              name: '张三'
            }
          })
      })
    }
    .height('100%')
  }

  onPageShow(){
    const params:Record<string,string> = router.getParams() as Record<string,string>;
    if(params){
      const backParams:string= params['backParams']
      console.log(`接受不返回的参数为：${backParams}`)
    }
  }
}