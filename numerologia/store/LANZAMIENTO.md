# Lanzamiento de Flu

Identificador: `com.jrgambal.numerologia` · Versión 1.0.0 (build 1)

## Ficha de Google Play (español)

**Título (máx. 30):** Flu: Numerología y ciclos

**Descripción breve (máx. 80):**
Tu carta numerológica, tus ciclos y la compatibilidad, con mirada crítica.

**Descripción completa:**

Flu calcula tu carta numerológica pitagórica paso a paso y te ayuda a usarla como lo que es: un lenguaje
simbólico para reflexionar sobre ti, no una predicción.

TU CARTA COMPLETA
• Los seis números núcleo: Camino de Vida, Expresión, Impulso del Alma, Personalidad, Cumpleaños y Madurez.
• Números maestros (11, 22, 33) y deudas kármicas (13, 14, 16, 19).
• Cada cálculo explicado letra por letra, con su comprobación.

TUS CICLOS
• Año, Mes y Día Personal, y Año Universal.
• Los cuatro pináculos con sus edades y tu etapa actual.
• Los desafíos de cada etapa.

TU NOMBRE A FONDO
• Tabla de inclusión y lecciones kármicas.
• Planos de expresión y números puente.
• Comparación con el sistema caldeo.

COMPATIBILIDAD
• Compara dos cartas: número de la relación, números lado a lado, lo que uno desea y lo que el otro muestra.
• Preguntas para conversar, sin puntuaciones ni etiquetas de "incompatible".

APRENDE
• Un curso de 10 módulos: historia, sistemas, cálculo, significados y qué dice la ciencia.
• Evaluación final de 10 preguntas.

PRIVADA
• Sin cuentas, sin publicidad y sin analítica. Tus datos se guardan solo en tu teléfono.

La numerología es un sistema simbólico, no una ciencia. Flu es una herramienta de reflexión y entretenimiento.

**Categoría:** Estilo de vida · **Etiquetas:** numerología, autoconocimiento, reflexión

**Política de privacidad:** `https://<tu-dominio>/privacidad` (la página está en `web/privacidad.html` y se
publica con la web).

## Formulario "Seguridad de los datos" de Google Play

- ¿Tu app recoge o comparte datos de usuario? **No.** Los datos se guardan solo en el dispositivo y nunca se
  transmiten fuera de él (Google no considera "recogidos" los datos que no salen del dispositivo).
- Cifrado en tránsito: no aplica (no hay transmisión).
- Eliminación de datos: el usuario borra cada carta desde la app, o todo al desinstalarla.

## Clasificación de contenido (cuestionario IARC)

Categoría: "Referencia, noticias o educación" o "Entretenimiento". Sin violencia, sexo, lenguaje soez,
drogas, apuestas ni interacción entre usuarios. Resultado esperado: apta para todo público (PEGI 3 / Everyone).

## Recursos gráficos que pide Google Play

- Ícono 512×512: `assets/icon/icon.png` reducido (sin transparencia).
- Gráfico destacado 1024×500: pendiente.
- Al menos 2 capturas de teléfono: se pueden tomar de la versión web o del APK.

## Pasos

### Web
1. En vercel.com: **Add New → Project → Import** `Jrgambal/flutter`.
2. **Root Directory:** `numerologia`. El resto lo lee de `vercel.json` (instala Flutter y compila).
3. Vercel publica la rama de producción (`main`). Para publicar ya, fusiona la rama de trabajo en `main`
   o cambia la rama de producción en Settings → Git.

### Android (Google Play)
1. Crea una cuenta en Google Play Console (pago único de 25 USD).
2. Crea la app "Flu", idioma español, gratuita.
3. Activa **Play App Signing** (viene por defecto) y sube `app-release.aab`. Tu clave de subida es
   `upload-keystore.jks`: guárdala junto con su contraseña. Si la pierdes, Google permite restablecerla.
4. Completa la ficha, la seguridad de los datos, la clasificación y el público objetivo.
5. Las cuentas personales nuevas deben hacer una **prueba cerrada con 12 testers durante 14 días** antes de
   pasar a producción.

### iOS (más adelante)
1. Cuenta de Apple Developer (99 USD al año).
2. En una Mac con Xcode: `flutter build ipa` y subir con Transporter, o usar Codemagic desde GitHub.
3. El Bundle ID ya está configurado como `com.jrgambal.numerologia` y el nombre como "Flu".

### Firma en GitHub Actions
Para que el flujo `.github/workflows/flu.yml` genere el AAB firmado, añade en GitHub → Settings → Secrets:
- `ANDROID_KEYSTORE_BASE64`: el resultado de `base64 -w0 upload-keystore.jks`.
- `ANDROID_KEYSTORE_PASSWORD`: la contraseña de la clave.
