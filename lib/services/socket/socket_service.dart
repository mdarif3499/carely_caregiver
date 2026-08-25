import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/utils/log/app_log.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  SocketService._();

  static io.Socket? _socket;
  
  // Internal event bus to manage multiple listeners per event name
  static final Map<String, List<void Function(dynamic)>> _handlers = {};

  static bool get isConnected => _socket?.connected ?? false;

  static void connect() async {
    final token = await SharePrefsHelper.getString(SharedPreferenceValue.token);
    if (token.isEmpty) {
      appLog('⚠️ Socket: Token empty, skipping connection.', source: 'SOCKET');
      return;
    }

    if (_socket != null && _socket!.connected) return;

    if (_socket == null) {
      final url = AppApiEndPoint.instance.socketUrl;
      appLog('🔌 Socket: Initializing new connection to $url', source: 'SOCKET');
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
          appLog('🔑 Socket: Authenticated with token', source: 'SOCKET');
        }

        _reRegisterListeners();
      });

      _socket!.onDisconnect((_) => appLog('⚠️ Socket: Disconnected', source: 'SOCKET'));
      _socket!.onConnectError((e) => appLog('❌ Socket: Connect Error $e', source: 'SOCKET'));
      _socket!.onError((e) => appLog('❌ Socket: General Error $e', source: 'SOCKET'));

    } else {
      appLog('🔌 Socket: Attempting to reconnect existing instance...', source: 'SOCKET');
      _socket!.connect();
    }
  }

  /// Internal helper to re-attach handlers when socket reconnects
  static void _reRegisterListeners() {
    if (_socket == null) return;
    _handlers.forEach((event, handlers) {
      _socket!.off(event);
      _socket!.on(event, (data) {
        appLog('📩 Socket: Event triggered [$event]', source: 'SOCKET');
        final listeners = List<void Function(dynamic)>.from(handlers);
        for (var h in listeners) {
          try { h(data); } catch (e) { appLog('❌ Error in handler for $event: $e'); }
        }
      });
    });
  }

  /// Register a listener for a specific event
  static void on(String event, void Function(dynamic data) handler) {
    if (!_handlers.containsKey(event)) {
      _handlers[event] = [];
      
      // If socket is already connected, register the core listener immediately
      if (_socket != null) {
        _socket!.on(event, (data) {
          appLog('📩 Socket: Received data for [$event]', source: 'SOCKET');
          final listeners = List<void Function(dynamic)>.from(_handlers[event] ?? []);
          for (var h in listeners) {
             try { h(data); } catch (e) { appLog('❌ Error in handler for $event: $e'); }
          }
        });
      }
    }

    if (!_handlers[event]!.contains(handler)) {
      _handlers[event]!.add(handler);
    }
    appLog('👂 Socket: Registered listener for [$event]', source: 'SOCKET');
  }

  /// Remove a specific listener
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

  /// Emit an event with data
  static void emit(String event, dynamic data) {
    if (_socket == null || !_socket!.connected) connect();
    _socket?.emit(event, data);
    appLog('📤 Socket: Emitted event [$event] with data: $data', source: 'SOCKET');
  }

  /// Fully disconnect and clear state
  static void disconnect() {
    _socket?.dispose();
    _socket = null;
    _handlers.clear();
    appLog('🔌 Socket: Manually disconnected and cleared', source: 'SOCKET');
  }
}
