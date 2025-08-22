import { webview } from '@kit.ArkWeb';
const TAG = 'WebComponent';
const url: string = 'https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/application-dev-guide';

/**
 * WebView长截图
 */
@Entry
@Component
export struct WebLongScreenShot {
  @State h5Width: number = 0;
  @State h5Height: number = 0;
  @State longPixelMap: PixelMap | undefined = undefined;
  private webviewController: webview.WebviewController = new webview.WebviewController();
  aboutToAppear(): void {
    webview.WebviewController.initializeWebEngine();
    webview.WebviewController.enableWholeWebPageDrawing();
    webview.WebviewController.prepareForPageLoad(url, true, 2);
  }
  async getWebSize() {
    const SCRIPT = '[document.documentElement.scrollWidth, document.documentElement.scrollHeight]';
    try {
      this.webviewController.runJavaScriptExt(SCRIPT).then((result) => {
        if (result.getType() === webview.JsMessageType.ARRAY) {
          this.h5Width = (result.getArray() as number[])[0];
          this.h5Height = (result.getArray() as number[])[1];
          console.info(TAG, `h5Width is ${this.h5Width}, h5Height is ${this.h5Height}`);
        }
      });
    } catch (error) {
      console.error(TAG, `Run script to get web page size failed. Error: ${JSON.stringify(error)}`);
    }
  }
  async webSnapshot() {
    try {
      this.webviewController.webPageSnapshot({ id: 'webTest', size: { width: this.h5Width, height: this.h5Height } },
        async (error, result) => {
          if (result) {
            this.longPixelMap = result.imagePixelMap;
          }
        });
    } catch (error) {
      console.error(TAG, `webPageSnapshot err : ${JSON.stringify(error)}`);
    }
  }
  build() {
    Stack() {
      Web({
        src: url,
        controller: this.webviewController
      })
        .id('webTest')
      Scroll() {
        Column() {
          Image(this.longPixelMap)
            .width('80%')
        }
      }
      Button('WebPageSnapshot')
        .onClick(() => {
          this.webSnapshot();
        })
    }
  }
}
