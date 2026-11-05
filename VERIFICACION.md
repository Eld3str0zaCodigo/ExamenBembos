# Verificación del proyecto

## Revisado en el entorno de preparación

- Los 12 archivos Swift pasan un análisis sintáctico con tree-sitter-swift, sin nodos de error ni tokens faltantes.
- El archivo project.pbxproj se pudo analizar: sus objetos, fases de compilación, targets y referencias internas existen.
- Los archivos fuente y recursos referenciados por Xcode están presentes.
- Info.plist, el esquema compartido y el workspace tienen sintaxis válida.
- Los manifiestos del catálogo de recursos tienen JSON válido y todas las imágenes se pueden decodificar.
- La fuente incluida tiene el nombre PostScript que utiliza el código y está registrada en Info.plist.
- El catálogo contiene ocho elementos.
- Se inspeccionaron el logo blanco y una fotografía de producto para comprobar su contenido.

Este entorno no dispone de Swift, Xcode ni del simulador de iOS. No se ha efectuado compilación, ejecución de XCTest ni verificación visual de las pantallas renderizadas por SwiftUI. El análisis sintáctico y estructural no reemplaza esas comprobaciones. Las pruebas incluidas deben ejecutarse en el Mac.

## Recorrido de comprobación en Xcode

1. Ejecutar con ⌘R. Comprobar entrada animada del logo y llegada a Login después de aproximadamente dos segundos.
2. Dejar los campos vacíos: Iniciar sesión debe estar deshabilitado. Escribir correo inválido y contraseña `Bembos!1`: debe aparecer un error.
3. Probar contraseñas `abcde!`, `Ab!12`, `Abcdef.`, `Abcdef,`, `Abcdef;`, `Abcdeá`: deben rechazarse por las reglas correspondientes. Los errores de credenciales solo se evalúan una vez válido el formulario.
4. Abrir Registro. Comprobar campos vacíos y confirmación diferente. Intentar usar `DEMO@BEMBOS.PE`: debe rechazarse como duplicado.
5. Registrar una cuenta nueva con contraseña `Bembos!1`. Comprobar «Cuenta creada» y llegada automática a Home tras 1,2 segundos.
6. Revisar las ocho hamburguesas. Buscar «ROYAL», «clasica» y «tocino». Buscar una cadena inexistente para mostrar el estado vacío; limpiar la búsqueda para recuperar el listado.
7. Abrir un producto. Comprobar imagen, nombre, precio, ingredientes, categoría y presentación. Desplazarse hasta el final y regresar al menú con Atrás.
8. Cerrar sesión y confirmar. Debe aparecer Login sin posibilidad de regresar a Home mediante Atrás.
9. Iniciar sesión con la cuenta creada. Cerrar sesión e intentar registrar el mismo correo, variando mayúsculas y espacios externos: debe seguir siendo duplicado.
10. Terminar la app por completo y volver a abrirla. La cuenta recién creada ya no existe; la cuenta demo sí. Este es el almacenamiento en memoria solicitado.
11. Ejecutar ⌘U para las cinco pruebas XCTest. Comprobar también las pantallas en un iPhone pequeño y con un tamaño de texto mayor.

## Comandos opcionales para Terminal en el Mac

Desde la carpeta que contiene Bembos.xcodeproj:

```bash
xcodebuild -list -project Bembos.xcodeproj
xcodebuild -project Bembos.xcodeproj -scheme Bembos -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO build
```

Para las pruebas, ⌘U desde Xcode permite usar el simulador que ya hayas seleccionado.
