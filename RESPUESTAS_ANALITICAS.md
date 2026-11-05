# Respuestas analíticas de la evaluación

## 1. Por qué usar @State y no @StateObject para la navegación del Splash

La navegación inicial depende de un valor simple, un Bool que indica si terminó el Splash. `@State` permite que SwiftUI almacene ese valor asociado a la identidad de la vista; cuando cambia, SwiftUI invalida las vistas que dependen de él y vuelve a evaluar sus cuerpos. No requiere una clase ni un objeto observable.

`@StateObject` conserva una instancia de una clase que implementa ObservableObject durante la vida de la identidad de la vista. Es apropiado para un ViewModel con estado y comportamiento compartido entre actualizaciones, pero no para envolver un Bool; Bool no implementa ObservableObject. Crear una clase solo para esa bandera añadiría una capa innecesaria.

En el proyecto, RootView conserva `@State private var splashCompleted`. SplashView recibe un `@Binding` para modificar ese mismo valor después de esperar dos segundos. Su `@State isVisible` controla escala y opacidad. La tarea evita cambiar la navegación si se cancela.

## 2. Diferencia entre $viewModel.email y pasar directamente el valor

En un TextField, `$viewModel.email` proporciona un Binding<String>. Ese enlace permite leer el correo actual y escribir sobre la propiedad del ViewModel cada vez que el usuario edita. Como email es @Published y el ViewModel es observado con @StateObject, los cambios pueden actualizar la interfaz y el estado del botón.

Pasar `viewModel.email` proporciona un String, un valor leído en ese momento. Es adecuado para mostrarlo en un Text, pero no ofrece al componente receptor un canal para modificar la propiedad original. Además, el inicializador de TextField que recibe `text:` exige un Binding<String>, por lo que un String directo no compila. `Binding.constant(viewModel.email)` tampoco serviría para un formulario editable porque no propaga las modificaciones a su origen.

En LoginView se enlazan email y password al LoginViewModel; la validación y los errores permanecen en ese ViewModel.

## 3. Por qué usar @EnvironmentObject para el usuario autenticado

La sesión es información que necesitan distintas ramas del árbol de vistas. Pasarla por cada inicializador obligaría a vistas intermedias a recibir y reenviar una dependencia que quizá no utilizan. @EnvironmentObject permite que las vistas descendientes accedan al mismo objeto observable inyectado en un ancestro y reaccionen a sus cambios.

BembosApp crea y conserva SessionStore con @StateObject y lo inyecta mediante `.environmentObject(session)`. RootView, LoginView, RegisterView y HomeView lo consultan con @EnvironmentObject. Cuando currentUser cambia, RootView muestra Home o Login; todas las vistas comparten una única sesión y una sola lista de cuentas.

@EnvironmentObject no crea el objeto ni equivale a una variable global: su alcance depende de dónde se inyecta. Si falta la inyección, la vista falla en ejecución. Por eso se inyecta desde la raíz. Para un componente aislado o una dependencia pequeña y explícita, pasarla por inicializador también puede ser una buena decisión.

## 4. Problema de filtrar dentro del body y solución en el ViewModel

SwiftUI puede evaluar el body repetidas veces por cambios de estado que no afectan al buscador. Ejecutar `items.filter` dentro de body recorrería toda la colección y generaría un nuevo array cada vez. Con una lista grande, comparación de textos costosa o muchas actualizaciones, esto puede añadir trabajo al hilo principal y afectar la fluidez. En una lista de ocho elementos el coste sería pequeño, pero el patrón importa al crecer.

Un array filtrado como propiedad calculada del ViewModel también volvería a filtrar cada vez que alguien lo leyera. Mover únicamente la expresión no elimina ese trabajo.

En este proyecto HomeViewModel conserva `@Published private(set) var filteredItems`. `applyFilter()` solo se ejecuta cuando cambian searchText o items, a través de didSet. La vista lee el resultado almacenado. El filtro ignora mayúsculas y tildes. Para catálogos mayores se podría aplicar debounce con Combine y, si la medición lo justifica, procesar fuera del hilo principal y publicar el resultado en MainActor.

## 5. Por qué pasar ItemModel por valor al detalle y cuándo cambiarlo

ItemModel es un struct Identifiable y Hashable. Un valor seleccionado contiene los datos que necesita el detalle y no exige que la pantalla se suscriba a un objeto mutable. DetailView declara `let item: ItemModel`; la navegación transporta ese valor y la pantalla presenta su contenido sin modificar la lista original.

Esto reduce el acoplamiento y facilita razonar sobre un detalle de solo lectura. La semántica por valor no implica que Swift haga siempre una copia profunda de todos los buffers: tipos como Array y String pueden compartir almacenamiento mediante copy-on-write hasta que se modifica.

La decisión cambiaría si el detalle necesitara reflejar actualizaciones en vivo o editar el mismo producto que otras vistas. Podría recibir un ID y consultar un repositorio observable compartido, usar un Binding<ItemModel> para editar el valor original, o recibir una clase ObservableObject mediante @ObservedObject. @ObservedObject observa una referencia proporcionada desde fuera; no es un reemplazo directo para cualquier struct.
