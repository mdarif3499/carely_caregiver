import 'dart:async';
import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/utils/log/app_log.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  SocketService._();

  static io.Socket? _socket;
  static final Map<String, List<void Function(dynamic)>> _handlers = {};
  static final Completer<void> _initCompleter = Completer<void>();
  static bool _isInitializing = false;

  static bool get isConnected => _socket?.connected ?? false;

  static Future<void> connect() async {
    if (_isInitializing) return;
    if (_socket != null && _socket!.connected) return;

    _isInitializing = true;
    try {
      final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
      if (token.isEmpty) {
        appLog('⚠️ Socket: Token empty, skipping connection.', source: 'SOCKET');
        _isInitializing = false;
        return;
      }

      if (_socket == null) {
        final url = AppApiEndPoint.instance.socketUrl;
        appLog('🔌 Socket: Initializing connection to $url', source: 'SOCKET');
        
        _socket = io.io(
          url,
          io.OptionBuilder()
              .setTransports(['websocket'])
              .setAuth({'token': token})
              .enableAutoConnect()
              .enableReconnection()
              .setReconnectionAttempts(10)
              .setReconnectionDelay(2000)
              .build(),
        );

        _socket!.onConnect((_) async {
          appLog('✅ Socket: Connected', source: 'SOCKET');
          final currentToken = await SharePrefsHelper.getString(SharedPreferenceValue.token);
          if (currentToken.isNotEmpty) {
            _socket!.emit('authenticate', currentToken);
          }
          _reRegisterListeners();
        });

        _socket!.onDisconnect((_) => appLog('⚠️ Socket: Disconnected', source: 'SOCKET'));
        _socket!.onConnectError((e) => appLog('❌ Socket: Connect Error $e', source: 'SOCKET'));
      } else {
        _socket!.connect();
      }

      if (!_initCompleter.isCompleted) _initCompleter.complete();
    } finally {
      _isInitializing = false;
    }
  }

  static void _reRegisterListeners() {
    if (_socket == null) return;
    _handlers.forEach((event, handlers) {
      _socket!.off(event);
      _socket!.on(event, (data) {
        appLog('📩 Socket: Event triggered [$event]', source: 'SOCKET');
        for (var h in List.from(handlers)) {
          try { h(data); } catch (e) { appLog('❌ Handler Error: $e'); }
        }
      });
    });
  }

  static void on(String event, void Function(dynamic data) handler) async {
    if (_socket == null) await connect();
    
    if (!_handlers.containsKey(event)) {
      _handlers[event] = [];
      
      appLog('🔗 Socket: Binding core listener for [$event]', source: 'SOCKET');
      _socket?.on(event, (data) {
        appLog('📩 Socket: Raw data received for [$event]: $data', source: 'SOCKET');
        final listeners = _handlers[event] ?? [];
        for (var h in List.from(listeners)) {
          try { h(data); } catch (e) { appLog('❌ Handler Error: $e'); }
        }
      });
    }

    if (!_handlers[event]!.contains(handler)) {
      _handlers[event]!.add(handler);
    }
    appLog('👂 Socket: Registered listener for [$event]', source: 'SOCKET');
  }

  static void off(String event, void Function(dynamic data) handler) {
    if (_handlers.containsKey(event)) {
      _handlers[event]!.remove(handler);
      if (_handlers[event]!.isEmpty) {
        _socket?.off(event);
        _handlers.remove(event);
      }
      appLog('🔕 Socket: Removed listener for [$event]', source: 'SOCKET');
    }
  }

  static void emit(String event, dynamic data) async {
    if (_socket == null) await connect();
    // Wait for connection if it's currently connecting
    if (_socket != null && !_socket!.connected) {
      appLog('⏳ Socket: Waiting for connection before emit [$event]...', source: 'SOCKET');
      int attempts = 0;
      while (!_socket!.connected && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }
    }
    
    _socket?.emit(event, data);
    appLog('📤 Socket: Emitted [$event] with: $data', source: 'SOCKET');
  }

  static void disconnect() {
    _socket?.dispose();
    _socket = null;
    _handlers.clear();
    appLog('🔌 Socket: Manually disconnected', source: 'SOCKET');
  }
}
