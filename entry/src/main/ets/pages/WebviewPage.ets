import web_webview from '@ohos.web.webview'
import hilog from '@ohos.hilog'

/**
 * Webview demo
 */
class TestObj{
  test?: (data:string)=>string
  toString?: ()=>void
}

@Entry
@Component
struct WebviewPage {
  @State message: string = 'Hello World'
  controller:web_webview.WebviewController = new web_webview.WebviewController()
  @State mode: MixedMode = MixedMode.All//加载http和https

  @State webResult: string = ''

  testObj:TestObj = {
    test: (data:string) => {
      console.log(`接收到的JS参数为 ${data}`);
      return "ArkUI Web Component";
    },
    toString: () => {
      console.log('Web Component toString');
    }
  }

  build() {
    Column() {
      //加载本地html，下载操作
      // Web({ src: $rawfile("productdetail.html"), controller: this.controller })
      //   .mixedMode(this.mode)
      //   .javaScriptAccess(true)
      //   .onDownloadStart((event)=>{
      //     //下载web中的视频
      //     console.log("下载的url地址为："+event.url)
      //   })
      //   .onPageEnd((event)=>{
      //     //网页加载完成时回调
      //
      //   })

      //原生调用JS的方法
      // Web({ src: $rawfile("index.html"), controller: this.controller })
      //   .mixedMode(this.mode)
      //   .javaScriptAccess(true)
      //   .onPageEnd(event=>{
      //     //网页加载完成时回调
      //     try {
      //       this.controller.runJavaScript(
      //         'test()',
      //         (error, result) => {
      //           if (error) {
      //             console.info(`run JavaScript error: ` + JSON.stringify(error))
      //             return;
      //           }
      //           if (result) {
      //             this.webResult = result
      //             console.info(`The test() return value is: ${result}`)
      //           }
      //         });
      //       console.info('url: ', event.url);
      //     } catch (error) {
      //       console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
      //     }
      //   })

      //JS调用原生的方法
      Web({ src: $rawfile("index2.html"), controller: this.controller })
        .mixedMode(this.mode)
        .javaScriptAccess(true)
        //1）使用 javaScriptProxy 注册，无需再调用refresh方法
        .javaScriptProxy({
          object: this.testObj,
          name: "objName",
          methodList: ["test", "toString"],
          controller: this.controller

        })

        // .onPageEnd(event=>{
        //   try {
        //     //2）使用 registerJavaScriptProxy 注册时，必须调用refresh()方法
        //     //jS调用原生的方法需要先注册
        //     //this.testObj：对象名
        //     //"objName"：和JS中的objName需要一致
        //     //["test", "toString"]：testObj中的方法列表
        //     this.controller.registerJavaScriptProxy(this.testObj, "objName", ["test", "toString"]);
        //
        //     console.info('url: ', event.url);
        //   } catch (error) {
        //     console.error(`ErrorCode: ${error.code},  Message: ${error.message}`);
        //   }
        // })
        .margin({top:60})
        .height(100)
      Button('click')
        .onClick(()=>{

          // 注册后，须调用refresh接口生效
          this.controller.refresh()
        })
    }
    .height('100%')
  }
}