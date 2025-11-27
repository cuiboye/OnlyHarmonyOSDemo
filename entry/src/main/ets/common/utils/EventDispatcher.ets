import { emitter } from '@kit.BasicServicesKit';

/**
 * Emitter消息通信
 */
export class EventDispatcher {

  private constructor() {
  }


  /**
   * 发送事件
   * @param eventId 事件ID
   * @param data 发送的数据
   * @param EventPriority 事件被发送的优先级
   */
  static sendEvent<T>(eventId: string, data: T, priority: emitter.EventPriority = emitter.EventPriority.HIGH) {
    let eventData: emitter.EventData = { 'data': { "eventData": data } };
    let options: emitter.Options = { 'priority': priority };
    emitter.emit(eventId, options, eventData);
  }


  /**
   * 订阅事件
   * @param eventId 事件ID，
   * @param callback 事件的回调处理函数
   */
  static addEvent<T>(eventId: string, callback: (data: T) => void) {
    emitter.on(eventId, (eventData: emitter.EventData) => {
      callback(eventData.data?.eventData);
    });
  }


  /**
   * 单次订阅指定的事件，并在接收到该事件并执行完相应的回调函数后，自动取消订阅
   * @param eventId 事件ID
   * @param callback 事件的回调处理函数
   */
  static addEventOnce<T>(eventId: string, callback: (data: T) => void) {
    emitter.once(eventId, (eventData: emitter.EventData) => {
      callback(eventData.data?.eventData);
    });
  }


  /**
   * 取消事件订阅
   * @param eventId 事件ID
   */
  static removeEvent(eventId: string) {
    emitter.off(eventId);
  }
}