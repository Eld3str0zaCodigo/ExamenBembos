# Bembos en SwiftUI

Proyecto académico para la Evaluación 03 A. Implementa exclusivamente Bembos y las cinco pantallas solicitadas. Arquitectura MVVM, navegación SwiftUI y datos en memoria. No necesita servidor, conexión a internet ni dependencias externas.

## Abrir en tu Mac

1. Descomprime la carpeta completa.
2. Abre **Bembos.xcodeproj** con Xcode 15 o posterior.
3. Selecciona el esquema **Bembos** y un simulador de iPhone con iOS 16 o posterior.
4. Presiona **⌘R** para compilar y ejecutar.
5. Para ejecutar las pruebas incluidas, presiona **⌘U**.

No abras los archivos Swift por separado ni crees un proyecto nuevo para copiarlos. El ZIP ya contiene la configuración de Xcode, los recursos y el esquema compartido.

En un iPhone físico: selecciona el proyecto → target Bembos → Signing & Capabilities → tu Team. Si Xcode pide un identificador único, cambia `pe.edu.tecsup.BembosJose`. Para probar en simulador no necesitas configurar un Team.

## Acceder

Puedes crear una cuenta desde «¿No tienes cuenta? Regístrate» o usar:

- Correo: **demo@bembos.pe**
- Contraseña: **Bembos!1**

Las cuentas nuevas permanecen disponibles al cerrar sesión mientras la app siga ejecutándose. Al terminar el proceso, se borran y vuelve a estar disponible solamente la cuenta de demostración. Este comportamiento es intencional: el documento exige almacenamiento temporal en memoria.

## Funciones incluidas

| Pantalla | Implementación |
| --- | --- |
| Splash | Logo centrado; entrada con escala y opacidad; nombre con una fuente TTF incluida; transición automática al Login después de 2 segundos con Task.sleep. |
| Login | Email y SecureField; botón deshabilitado con campos vacíos; validación en LoginViewModel; errores @Published; acceso con las cuentas en memoria; enlace a Registro. |
| Registro | Nombre, email, contraseña y confirmación; validaciones; email único sin distinguir mayúsculas ni espacios externos; usuario compartido; mensaje de éxito durante 1,2 segundos antes de Home. |
| Home | Ocho hamburguesas en @Published var items: [ItemModel]; ScrollView + LazyVStack; imagen, nombre y subtítulo por fila; búsqueda reactiva; cierre de sesión con regreso a Login. |
| Detalle | NavigationLink(value:) y navigationDestination; ItemModel por valor; imagen hero; título, precio, categoría, presentación, preparación, descripción e ingredientes; ScrollView. |

La contraseña debe tener al menos seis caracteres, una mayúscula y un carácter especial admitido, como `!`, `@`, `#`, `$`, `%`, `&`, `*`, `+`, `-`, `_` o `?`. Los puntos, comas, punto y coma, letras acentuadas y signos de acentuación no satisfacen el requisito de carácter especial. No se exige un número porque el documento no lo solicita.

La búsqueda encuentra nombres, subtítulos, categorías e ingredientes; ignora mayúsculas, tildes y espacios externos. Por ejemplo, «clasica» encuentra «Clásica» y «tocino» encuentra productos que lo contienen.

## Organización del código

- `BembosApp.swift`: punto de entrada, propietario del SessionStore y cambio entre Splash, Login y Home.
- `Models.swift`: User, ItemModel y ocho productos de muestra.
- `SessionStore.swift`: usuarios, credenciales y sesión compartidos en memoria.
- `Validation.swift`: reglas comunes de correo y contraseña.
- `ViewModels.swift`: LoginViewModel, RegisterViewModel y HomeViewModel.
- `SplashView.swift`, `LoginView.swift`, `RegisterView.swift`, `HomeView.swift`, `DetailView.swift`: las cinco pantallas.
- `Brand.swift`: paleta, tipografía y componentes de formulario.
- `Assets.xcassets`: logo, icono y fotografías incluidas en el proyecto.
- `Resources`: fuente incluida y licencia.
- `BembosTests/BembosTests.swift`: pruebas de reglas, registro, unicidad, sesión, login y búsqueda.
- `RESPUESTAS_ANALITICAS.md`: las cinco respuestas que exige la evaluación.
- `VERIFICACION.md`: revisión efectuada y recorrido para comprobar en Xcode.

## Identidad visual y datos

El azul domina el Splash, encabezado y botones. El blanco organiza formularios y tarjetas; rojo y amarillo mantienen los acentos del logo. Se incluye el logo oficial y fotografías locales para no depender de descargas durante la exposición. La fuente DejaVu Sans Condensed Bold Oblique se registra en Info.plist y se utiliza con `.font(.custom(...))` en el nombre del Splash y títulos. No se presenta como la tipografía corporativa oficial de Bembos.

Logo y fotografías proceden del sitio de Bembos, consultado el 5 de noviembre de 2026:

- https://www.bembos.com.pe/
- https://www.bembos.com.pe/menu/hamburguesas

Los nombres se inspiran en la carta de Bembos. Los precios, porciones y textos del catálogo son datos ilustrativos del ejercicio; no constituyen una carta comercial vigente. Los recursos de la marca se incluyen como referencia para este proyecto académico. La licencia de la fuente se adjunta en `Bembos/Resources/FONT-LICENSE.txt`.

Los datos de cuentas y contraseñas se conservan exclusivamente en memoria para cumplir el ejercicio. Una aplicación comercial requeriría autenticación mediante un servicio y manejo seguro de credenciales.
