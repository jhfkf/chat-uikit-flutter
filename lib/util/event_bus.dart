//订阅者回调签名
typedef EventCallback<T> = void Function(T arg);

class EventBus {
  //私有构造函数
  EventBus._internal();

  //保存单例
  static final EventBus _singleton = EventBus._internal();

  //工厂构造函数
  factory EventBus()=> _singleton;

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final Map<String, List<EventCallback>> _map = {};


  //读取指定订阅者事件
  getEventName(eventName){
    var list = _map[eventName];
    return list;
  }

  //添加订阅者
  void on(eventName, EventCallback f) {
    if (eventName == null) return;
    _map[eventName] ??= List<EventCallback>.empty(growable: true);
    _map[eventName]?.add(f);
  }

  //移除订阅者
  void off(eventName, [EventCallback? f]) {
    List<EventCallback>? list = _map[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _map.remove(eventName);
    } else {
      list.remove(f);
    }
  }

  //触发事件，事件触发后该事件所有订阅者会被调用
  void emit(eventName,[arg]) {
    List<EventCallback>? list = _map[eventName];
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      list[i](arg);
    }
  }



}

//定义一个top-level（全局）变量，页面引入该文件后可以直接使用bus
EventBus bus = EventBus();