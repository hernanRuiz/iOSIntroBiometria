# Introducción a biometría en IOS

Ejemplo básico de biometría en iOS. Incluye:

- Helper para comunicación con la API de biometría, para obtener, si lo tiene, de que tipo es el sensor del dispositivo (TouchID o FaceID).
- Mensajes fallback personalizados para cada tipo de sensor biométrico.
- Mensajes de error para biometría no disponible (sin datos biométricos en el dispositivo) y autenticación fallida.
- Conexión a segundo ViewController en caso de autenticación correcta.
