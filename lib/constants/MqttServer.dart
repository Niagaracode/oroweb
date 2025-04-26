import 'dart:async';
import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../state_management/MqttPayloadProvider.dart';

class MqttServer {
  static MqttServer? _instance;
  MqttPayloadProvider? providerState;
  static MqttClient _client = MqttServerClient("13.235.254.21", "");
  static StreamSubscription? mqttListen;

  factory MqttServer() {
    _instance ??= MqttServer._internal();
    return _instance!;
  }

  MqttServer._internal();

  bool get isConnected => _client.connectionStatus?.state == MqttConnectionState.connected;

  void initializeMQTTServer({MqttPayloadProvider? state}) {

    String uniqueId = const Uuid().v4();
    print('Unique ID: $uniqueId');
    initMqtt(state);
  }

  Future<void> initMqtt(mqttState) async
  {
    final state = _client.connectionStatus?.state;
    if (state != null && state == MqttConnectionState.connected)
    {
      providerState = mqttState;
      log('MqttService already Connected');
    }
    else
    {
      _client = MqttServerClient("3.0.229.165", "");
      _client.logging(on: false);
      _client.port = 1883;
      _client.keepAlivePeriod = 60;
      _client.onDisconnected = onDisconnected;
      _client.autoReconnect = false;
      _client.onSubscribed = onSubscribed;
      _client.onConnected = onConnected;
      _client.onUnsubscribed = onUnsubscribed;
      _client.onSubscribeFail = onSubscribeFail;

      final mqttMsg = MqttConnectMessage()
          .authenticateAs('niagara', 'niagara@123')
          .withClientIdentifier("ClientIdentifier-flutter")
          .withWillMessage('connection-failed')
          .withWillTopic('willTopic')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce)
          .withWillTopic('failed');
      _client.connectionMessage = mqttMsg;
      await _connectMqtt();
    }
  }

  void onConnected() async
  {
    log('MqttService Connected');
    final prefs = await SharedPreferences.getInstance();
    String subscribeTopic = (prefs.getString('subscribeTopic') ?? "Nop");
    if(subscribeTopic != "Nop"){
      subscribeTopicMqtt(subscribeTopic);
    }
    _listenMqtt();
  }

  static void onDisconnected() {
    log('MqttService Disconnected');
  }

  static void onSubscribed(String? topic) {
    log('MqttService Subscribed topic is : $topic');
  }

  static void onUnsubscribed(String? topic) {
    log('MqttService Unsubscribed topic is : $topic');
  }

  static void onSubscribeFail(String? topic) {
    log('MqttService Failed subscribe topic : $topic');
  }

  static Future<void> _connectMqtt() async
  {
    if (_client.connectionStatus!.state != MqttConnectionState.connected)
    {
      try {
        await _client.connect();
      } catch (e) {
        log('MqttService Connection failed$e');
      }
    } else {
      log('MqttService MQTT Server already connected ');
    }
  }

  static Future<void> disconnectMqtt() async
  {
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      try {
        _client.disconnect();
      } catch (e) {
        log('MqttService Disconnection Failed $e');
      }
    } else {
      log('MQTT Server already disconnected ');
    }
  }

  void subscribeTopicMqtt(String topic)
  {
    final state = _client.connectionStatus?.state;
    if (state != null && state == MqttConnectionState.connected){
      _client.subscribe(topic, MqttQos.atLeastOnce);
    }else{
      initMqtt(providerState);
    }
  }

  static void publish(String topic, String message, {bool retain = true})
  {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(
      topic,
      MqttQos.atLeastOnce,
      builder.payload!,
      retain: retain,
    );
    builder.clear();
  }

  void unSubscribeTopic(String topic)
  {
    final state = _client.connectionStatus?.state;
    if (state != null) {
      if (state == MqttConnectionState.connected) {
        _client.unsubscribe(topic);
      }else{
        initMqtt(providerState);
      }
    }else{
      initMqtt(providerState);
    }
  }

  static void onClose(){
    mqttListen?.cancel();
    disconnectMqtt();
  }

  void _listenMqtt()
  {
    mqttListen = _client.updates!.listen((dynamic t)
    async
    {
      MqttPublishMessage recMessage = t[0].payload;
      final message =  MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
      log(message);

    });
  }
}