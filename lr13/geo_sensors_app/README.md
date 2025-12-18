# Практическое занятие №13: Аппаратная часть мобильных устройств

## Цель работы

Изучить возможности работы с аппаратными датчиками и сервисами мобильного устройства. Разработать мобильное приложение, использующее геолокацию и данные сенсоров (акселерометр, гироскоп, компас).

## Используемые пакеты

- `geolocator`: Определение координат, скорости и других данных о местоположении.
- `geocoding`: Преобразование координат в адрес и наоборот.
- `sensors_plus`: Получение данных с акселерометра и гироскопа.
- `flutter_compass`: Получение данных о направлении с компаса.
- `permission_handler`: Управление разрешениями на использование сервисов устройства.

## Основные фрагменты кода

### `lib/main.dart` - Основной экран приложения

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const GeoSensorsApp());

class GeoSensorsApp extends StatelessWidget {
  const GeoSensorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo & Sensors',
      theme: ThemeData(useMaterial3: true),
      home: const GeoSensorsPage(),
    );
  }
}

class GeoSensorsPage extends StatefulWidget {
  const GeoSensorsPage({super.key});

  @override
  State<GeoSensorsPage> createState() => _GeoSensorsPageState();
}

class _GeoSensorsPageState extends State<GeoSensorsPage> {
  Position? _position;
  String _address = '-';
  CompassEvent? _compass;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gyroscopeSubscription;
  StreamSubscription? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        _accelerometerValues = [event.x, event.y, event.z];
      });
    });
    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      setState(() {
        _gyroscopeValues = [event.x, event.y, event.z];
      });
    });
    _compassSubscription = FlutterCompass.events!.listen((event) {
      setState(() {
        _compass = event;
      });
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.location.request();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);

    setState(() {
      _position = pos;
      _address = '${placemarks.first.locality}, ${placemarks.first.street ?? ''}';
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Geo & Sensors Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Определить местоположение'),
            ),
            const SizedBox(height: 12),
            Text(
              _position != null
                  ? 'Координаты: ${_position!.latitude}, ${_position!.longitude}'
                  : 'Координаты: -',
            ),
            Text('Адрес: $_address'),
            const Divider(height: 30),
            Text('Компас: ${_compass?.heading?.toStringAsFixed(2) ?? '-'}°'),
            const Divider(height: 30),
            Text(
              'Акселерометр: ${_accelerometerValues?.map((e) => e.toStringAsFixed(2)).join(', ') ?? '-'}',
            ),
            Text(
              'Гироскоп: ${_gyroscopeValues?.map((e) => e.toStringAsFixed(2)).join(', ') ?? '-'}',
            ),
          ],
        ),
      ),
    );
  }
}
```

## Результаты и выводы

В ходе выполнения практической работы было создано Flutter-приложение, демонстрирующее работу с геолокацией и основными сенсорами мобильного устройства.

- **Основной экран** отображает текущие координаты, адрес, данные акселерометра, гироскопа и компаса.

Приложение успешно выполняет все поставленные задачи. Были изучены и применены на практике основные пакеты для работы с аппаратными возможностями устройств.

## Скриншоты

*(Сюда можно добавить скриншоты работающего приложения)*

1.  **Главный экран:**
    *   (скриншот)
