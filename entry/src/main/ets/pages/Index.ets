import router from '@ohos.router';
import { CommonHeader } from '../common/common_header';
import { APP_EXIT_INTERVAL, TIME } from '../common/constants/Constants';
import { ComponentWidget } from '../widget/component_widget';
import { ProgressTask } from './prop_link_demo';
import { PropPage } from './prop_page';
import { FirstWidget } from './provider_page';
import { StatePage } from './state_page';
import prompt from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import data from '@ohos.telephony.data';
import worker from '@ohos.worker';
import {ResManager} from 'sharelibrary'
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 全局的自定义构建函数，页面内使用Component修饰的组件都可以用
 */
// @Builder function ListViewItem(item:string){
//   Row() {
//     Text(`元素为 ${item}`).fontSize(16)
//   }.backgroundColor(Color.Red).height(30).width(100)
// }

/**
 * 全局的自定义样式
 * 全局的自定义样式的属性只能设置所有组件都有的属性才可以，如果是某个组件特有的属性则不支持，比如
 * Text的fontSize则不支持。
 * 如果想在全局的自定义样式中设置某个组件特有的属性，可以使用Extend
 */
@Styles function fillScreen() {
  .backgroundColor(Color.Red)
  .height(30)
  .width(100)
}

/**
 * 使用Extend设置某个组件特有的属性
 * 注意：@Extend只能写在全局中，不能写在局部中
 */
@Extend(Text) function priceText() {
  .fontSize(16)
  .fontColor(Color.Blue)
}

let wk = new worker.ThreadWorker("entry/ets/workers/worker.ts");

@Entry
@Component
struct Index {

  @State showImmersiveStatusBar: boolean = false;
  @State titleBarPadding: number = 0;
  array: Array<String> = ['a', 'b', 'c'];
  @State message: string = 'Hello World'
  @State totalNumber: number = 0

  // @Provide providerTotalNumber:number = 0;
  @Provide('providerTotalNumber') aaa: number = 0;
  @Provide('providerTotalNumber2') aaa2: number = 0;

  private clickBackTimeRecord: number = 0;

  searchArr:Array<String> = ['dskf','1dskf','2dskf','3dskf','4dskf','5dskf','6dskf','7dskf']

  @StorageProp('navigationHeight') navigationHeight: number = 0

  private context = getContext(this) as common.UIAbilityContext

  onPageShow(){
    //   //这是个全局设置，其他页面如果想显示状态栏，在显示其他页面的时候需要设置显示
    window.getLastWindow(this.context).then((windowClass) => {
      //
      windowClass.setWindowSystemBarProperties({
        statusBarColor: '#ffef7134',
        navigationBarColor: '#ffef7134',
        statusBarContentColor: '#ffef7134',
        navigationBarContentColor: '#ffef7134'
      })

      windowClass.setWindowSystemBarEnable(['status','navigation'], (err) => {

      });
    })
  }

  aboutToAppear(){
    //在page中监听EventHub的事件
    this.context.eventHub.on('EventHubonClick',()=>{
      prompt.showToast({message:'EventHubonClick'})
    })
  }

  myClickHandler(): void {
    console.log('HarmonyOS Hello!')
  }

  /**
   * 局部的构建函数
   */
  @Builder ListViewItem(item: string) {
    Row() {
      Text(`元素为 ${item}`).priceText() //priceText为全局的自定义属性
    }.fillScreen() //fillScreen 自定义样式
  }

  /**
   * 局部的自定义样式
   */
  @Styles fillScreen(){
    .backgroundColor(Color.Red)
    .height(30)
    .width(100)
  }

  /**
   * onBackPress:物理返回键监听
   */
  onBackPress(){
    if (this.isShowToast()) {
      prompt.showToast({
        message: '再按一次退出程序',
        duration: TIME
      });
      this.clickBackTimeRecord = new Date().getTime();
      return true;
    }
    return false;
  }

  isShowToast(): boolean {
    return new Date().getTime() - this.clickBackTimeRecord > APP_EXIT_INTERVAL;
  }

  //在TypeScript中，空字符串，0，nul,undefined
  build() {
    Column(){
      //状态栏以及标题栏
      CommonHeader()
      Scroll(){
        Column() {

          // PropPage({totalNumber:this.totalNumber})

          //@State的操作
          StatePage()

          //Flex 流式布局
          Flex({ justifyContent: FlexAlign.Start, wrap: FlexWrap.Wrap }) {
            if (this.searchArr.length > 0) {
              ForEach(this.searchArr, (item: string) => {
                Text(`${item}`)
                  .fontSize($r("app.float.flex_font_size"))
                  .borderStyle(BorderStyle.Solid)
                  .borderWidth($r('app.float.border_width'))
                  .borderColor('#00a0e9')
                  .borderRadius($r('app.float.border_radius'))
                  .backgroundColor(Color.Red)
                  .padding({
                    top: 3,
                    bottom: 3,
                    left: 5,
                    right: 5
                  })
                  .margin({
                    top: $r("app.float.flex_layout_margin"),
                    right: $r("app.float.flex_layout_margin")
                  })
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(5)
              }, (item: string) => JSON.stringify(item))
            }
          }
          .margin({
            left: $r('app.float.margin_left'),
            right: $r('app.float.margin_left')
          })
          .padding({ bottom: $r('app.float.margin_left') })

          //@Link 传递的变量的引用必须使用 $
          PropPage({ totalNumber: $totalNumber })
          Row() {
            Text(`${this.totalNumber}`)
            Button('测试@Prop状态管理').onClick(() => {
              this.totalNumber++
            })
          }

          //Provider和Consume
          Column() {
            Row() {
              Text(`${this.aaa}`)
              Button('测试Provider和Consume').onClick(() => {
                this.aaa++
              })
            }

            FirstWidget()
          }
          Button('媒体查询-多屏幕适配').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/media_page',
              },
              router.RouterMode.Standard, //跳转模式 Single/Stantard
            )
          })
          Button('异步操作').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/AsynchronyPage',
              },
            )
          })
          Button('吸顶效果').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/CeilingPage',
              },
            )
          })
          Button('拍照').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/CameraPage',
              },
            )
          })
          Button('@State @Prop @Link的Demo').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/prop_link_demo',
              },
              router.RouterMode.Standard, //跳转模式 Single/Stantard
            )
          })

          //=========== singleton模式 start ===========
          //需要将MultitonabilityEntryAbility的launchType设置为 singleton
          Button('singletonability').onClick(() => {
            // singletonability跳转

            let want: Want = {
              deviceId: '', //空字符串代表当前设备
              // bundleName: 'com.example.myapplication',
              bundleName: this.context.abilityInfo.bundleName,
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility'
            }
            this.context.startAbility(want)
              .catch((err:BusinessError) => {
              })
          })
          //=========== singleton模式 end ===========

          //=========== multiton模式 start ===========
          //需要将MultitonabilityEntryAbility的launchType设置为 multiton
          Button('multitonability').onClick(() => {
                // multitonability跳转
                let want: Want = {
                  deviceId: '',
                  // bundleName: 'com.example.myapplication',
                  bundleName: this.context.abilityInfo.bundleName,
                  moduleName: 'entry',
                  abilityName: 'MultitonabilityEntryAbility'
                }
                this.context.startAbility(want)
              })
          //=========== multiton模式 end ===========

          //=========== standard模式 start ===========
          //需要将MultitonabilityEntryAbility的launchType设置为 standard
          Button('standardability').onClick(() => {
            // standardability跳转
            let want: Want = {
              deviceId: '',
              // bundleName: 'com.example.myapplication',
              bundleName: this.context.abilityInfo.bundleName,
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility'
            }
            this.context.startAbility(want)
          })
          //=========== standard模式 end ===========

          //=========== specified模式 start ===========
          //测试这个功能：
          //1）需要在 module.json5 中将MultitonabilityEntryAbility的launchType设置为 specified
          //2）需要在 module.json5 的 module 这个标签下添加  "srcEntry": './ets/multitonability/MyAbilityStage.ts',
          Button(`创建指定实例模式-打开文档1`).onClick(() => {
            // 跳转的目的地want
            let want: Want = {
              deviceId: '',
              // bundleName: 'com.example.myapplication',
              bundleName: this.context.abilityInfo.bundleName,
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility',
              parameters: {//参数
                instanceKey: '文档1'
              }
            }
            this.context.startAbility(want)
         })

          Button(`创建指定实例模式-打开文档2`).onClick(() => {
            // 跳转的目的地want
            let want: Want = {
              deviceId: '',
              // bundleName: 'com.example.myapplication',
              bundleName: this.context.abilityInfo.bundleName,
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility',
              //这个参数需要和MyAbilityStage中的instanceKey参数一致
              parameters: {
                instanceKey: '文档2'
              }
            }
            this.context.startAbility(want)
          })
          //=========== specified模式 end ===========


          Button(`启动新的Ability并接收返回的参数`).onClick(() => {
            // 跳转的目的地want
            let want: Want = {
              deviceId: '',
              // bundleName: 'com.example.myapplication',
              bundleName: this.context.abilityInfo.bundleName,
              moduleName: 'entry',
              abilityName: 'MultitonabilityEntryAbility',
            }
            this.context.startAbilityForResult(want).then((data)=>{
              if(data.resultCode == 1001){
                //取出Ability返回的信息
                let result = data?.want?.parameters?.backParams;
                console.info(`Ability返回的result为：${result}`)
              }
            })
          })

          //启动其它的应用，启动的页面为默认的页面
          Button(`启动其它应用的UIAbility`).onClick(() => {//MyApplication22项目
            let wantInfo:Want = {
              deviceId: '', // deviceId为空表示本设备
              // 如果希望隐式仅在特定的捆绑包中进行查询，请取消下面的注释。
              bundleName: 'com.example.myapplication2',
              action: 'ohos.want.action.viewData',
              // entities可以被省略。
              entities: ['entity.system.default'],
            }
            // context为调用方UIAbility的AbilityContext
            this.context.startAbility(wantInfo).then(() => {

            }).catch((err:BusinessError) => {

            })
          })

          //可以打开其它应用的具体的某个页面
          //需要在其它应用的EntryAbility的onCreate方法中接收want，并在windowStage.loadContent判断跳转哪个页面
          Button(`打开Ability中指定的页面`).onClick(() => {//MyApplication22项目
            let wantInfo:Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.example.myapplication2',
              abilityName: 'EntryAbility',
              moduleName: 'entry', // moduleName非必选
              parameters: { // 自定义参数传递页面信息
                router: 'SecondPage',
              },
            }
            // context为调用方UIAbility的AbilityContext
            this.context.startAbility(wantInfo).then(() => {
              //then为回调，从其它Ability返回到当前Ability后的操作可以在这里处理
            }).catch((err:BusinessError) => {
              console.info(`${err}}`)
            })
          })

          //使用Want打开链接
          Button(`使用Want打开链接`).onClick(() => {
            let wantInfo:Want = {
              // bundleName: 'com.example.myapplication',
              action: 'ohos.want.action.viewData',
              entities: [ 'entity.system.browsable' ],
              uri: 'http://www.baidu.com',
              type: 'text/plain',
            };
            this.context.startAbility(wantInfo).then(() => {
            }).catch((err:BusinessError) => {
              console.info(`${err}`)
            })
          })

          //发送消息到worker线程
          Button(`发送消息到worker线程`).onClick(() => {
            // 发送消息到worker线程
            wk.postMessage("message from main thread.")

            // 处理来自worker线程的消息
            wk.onmessage = (message) =>{
              console.info("message from worker: " + message.data)
              // 根据业务按需停止worker线程
              wk.terminate()
            }
          })

          Button(`AppStorage`).onClick(() => {
            router.pushUrl(
              {
                url: 'pages/AppStoragePage',
              },
            )
          })

          Button(`访问控制申请`).onClick(() => {
            router.pushUrl(
              {
                url: 'pages/PermissionsPage',
              },
            )
          })

          //=========== EventHub start ===========
          Button('EventHub').onClick(() => {
            //使用 eventHub.emit 来发送消息
            // this.context.eventHub.emit('eventTest')

            //发送带参数的消息，参数可以有多个，形参是 可选...args: Object[] 的数组
            // this.context.eventHub.emit('eventTestWithParams',1)
            // this.context.eventHub.emit('eventTestWithParams',1,2)

            this.context.eventHub.emit('EventHubonClick')
          })
          //=========== EventHub end ===========


          Button('@Observed和@ObjectLink的Demo').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/boseved_page',
              },
              router.RouterMode.Standard, //跳转模式 Single/Stantard
              err => {
                if (err) {
                  console.log('路由失败')
                  console.log(err.code + '')
                  console.log(err.message)
                  console.log(err.name)
                }
              },
            )
          })

          Button('布局学习').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/layout_demo',
              },
              router.RouterMode.Standard, //跳转模式 Single/Stantard
              err => {
                if (err) {
                  console.log('路由失败')
                  console.log(err.code + '')
                  console.log(err.message)
                  console.log(err.name)
                }
              },
            )
          })

          //List
          Button('List列表').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/list_page',
              },
              router.RouterMode.Standard,
            )
          })


          Button('自定义弹框')
            .onClick(()=>{
              router.pushUrl(
                {
                  url: 'pages/CustomDialogPage',
                },
              )
            })

          //Grid
          Button('Grid列表').onClick(() => {
            router.pushUrl(
              {
                url:'pages/grid_demo'
              },
            )
          })

          //List的分组列表
          Button('List的分组列表').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/list_page2',
              },
              router.RouterMode.Standard,
            )
          })

          //滚动列表
          Button('滚动列表').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/scroll_page',
              },
              router.RouterMode.Standard,
            )
          })

          //Swiper轮播图
          Button('Swiper轮播图').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/swiper_demo_page',
              },
              router.RouterMode.Standard,
            )
          })

          //各种组件
          Button('各种组件').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/widget_page',
              },
              router.RouterMode.Standard,
            )
          })

          //路由操作
          Button('路由操作').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/routerdemo/first_router',
              },
            )
          })

          //路由操作
          Button('文件相关').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/FilePage',
              },
            )
          })

          //持久化数据
          Button('持久化数据').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/savedata/save_data_demo',
              },
            )
          })

          //stateStyles-多态样式
          Button('stateStyles-多态样式').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/wajiu/MutilStylePage',
              },
            )
          })

          Button('动画').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/animate/animate_main_page',
              },
            )
          })
          Button('通过LocalStorage.GetShared()在页面之间更新值').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/LocalStorageSharePage',
              },
            )
          })

          Button('挖酒项目').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/wajiu/page/wajiu_main_page',
              },
            )
          })
          Button('二级联动+MVVM模式').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/SecondLevelLinkagePage',
              },
              err => {
                if (err) {
                  console.log('路由失败')
                  console.log(err.code + '')
                  console.log(err.message)
                  console.log(err.name)
                }
              },
            )
          })
          Button('Webview Demo').onClick(() => {
            router.pushUrl(
              {
                url: 'pages/WebviewPage',
              },
            )
          })

          //引入HSP动态共享包
          //ResManager返回的Resource对象，可以传给组件直接使用，也可以从中取出资源来使用

          //传给组件直接使用
          Text(ResManager.getSharedDesc())//获取sharelibrary的值

          //从Resource对象中取出资源来使用
          //先通过当前上下文获取hsp模块的上下文，再获取hsp模块的resourceManager，然后再调用resourceManager的接口获取资源
          Text('ResManager返回的Resource对象可以从中去除资源来使用')
            .onClick(()=>{
              getContext()
                .createModuleContext('sharelibrary')
                .resourceManager
                .getStringValue(ResManager.getSharedDesc())
                .then(value=>{
                  prompt.showToast({message:value})
                })
                .catch((err:BusinessError)=>{

                })
            })

          // Button('跳转HSP的页面')
          //   .onClick(() => {
          //     router.pushUrl({
          //       url: '@bundle:com.example.myapplication/sharelibrary/ets/pages/ShareLibraryPage'
          //     })
          //   })
        }
      }.layoutWeight(1).padding({bottom:50})
      //底部安全区域的高度
      Row()
        .height(px2vp(this.navigationHeight))
        .width('100%')
        .backgroundColor(Color.White)
    }
  }
}

