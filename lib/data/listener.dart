typedef OnChangeListener<T> = Function(ListenerType, T);

enum ListenerType { add, update, delete }

abstract class Listener<T> {
  final Map<String, OnChangeListener<T>> _onChangeListeners = {};

  void onChange(ListenerType type, T data) {
    _onChangeListeners.forEach((key, value) {
      value.call(type, data);
    });
  }

  void removeListener(String key) {
    _onChangeListeners.remove(key);
  }

  void setOnChangeListener(String key, OnChangeListener<T> onChangeListener) {
    _onChangeListeners[key] = onChangeListener;
  }
}
