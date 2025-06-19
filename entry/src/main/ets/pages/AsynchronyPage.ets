/**
 * 异步操作
 */
import { BusinessError } from '@kit.BasicServicesKit'

@Entry
@Component
struct AsynchronyPage {
  @State message: string = 'Hello World'

  build() {
    Column() {
      Button('Promise最基本的用法')
        .onClick(()=>{
          const promise:Promise<number> = new Promise((resolve:Function,reject:Function)=>{
            setTimeout(() => {
              const randomNumber = Math.random();
              if (randomNumber > 0.5) {
                resolve(randomNumber);
              } else {
                reject(new Error('Random number is too small'));
              }
            }, 1000);
          })

          //通过then回调获取结果和错误信息
          // promise.then((result => {//result：获取结果
          //   console.info(`Random number is ${result}`);
          // }), error => {//error:获取失败信息
          //   console.error(error.message);
          // })

          promise.then((result:number)=>{//then回调方法只传一个参数代表成功的结果
            console.info(`Random number is ${result}`);
          }).catch((error:BusinessError)=>{
            //还可以使用catch获取失败的结果
            console.error(error.message);
          })
        })
      Button('async/await')
        .onClick(()=>{
          //asynv/await是一种处理异步操作的Promise语法糖
          this.myAsyncFunction()
        })
    }
    .height('100%')
  }

  async myAsyncFunction() {
    //使用await关键字等待Promise的解析（完成或拒绝），以同步的方式编写异步操作的代码。
    //使用了await关键字来等待Promise对象的解析，并将其解析值存储在result变量中。
    try {//使用try...catch来捕捉异步中的异常
      const result:string = await new Promise((resolve:Function) => {
        setTimeout(() => {
          resolve('Hello, world!');
        }, 3000);
      });
      console.info(String(result)); // 输出： Hello, world!
    }catch (e){
      console.error(`exception:${e}`)
    }
  }
}
