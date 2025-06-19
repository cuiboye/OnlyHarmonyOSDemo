/**
 * worker线程
 */
import worker from '@ohos.worker';

let parent = worker.workerPort

// 处理来自主线程的消息
parent.onmessage =  function(message){
  console.info("onmessage: " + message.data)
  parent.postMessage("message from main thread.")
}