Um aplicativo de player de música MP3 desenvolvido em Flutter por Marcos Pinto e Thiago Torres, com reprodução em primeiro e segundo plano, gerenciamento de playlists e notificações persistentes.
✨ Funcionalidades

    ✅ Reprodução de músicas MP3

    ✅ Notificação persistente com controles de mídia

    ✅ Funcionamento em segundo plano

    ✅ Gerenciamento de playlist

    ✅ Barra de progresso e controle de volume

    ✅ Suporte a dark/light mode

📦 Instalação
Pré-requisitos

    Flutter SDK (versão 3.0 ou superior)

    Dart (versão 2.17 ou superior)

    Android Studio/Xcode (para desenvolvimento móvel)

Passos

    Clone o repositório:

bash

git clone https://github.com/Marcosfsp/mp3_player.git

    Acesse o diretório do projeto:

bash

cd mp3_player

    Instale as dependências:

bash

flutter pub get

    Execute o app:

bash

flutter run

🛠️ Configuração

Para configurar o serviço de áudio em segundo plano, adicione ao seu AndroidManifest.xml:
xml

<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />

🎨 Estrutura do Projeto

lib/
├── models/          # Modelos de dados
├── services/        # Serviços (áudio, download)
├── screens/         # Telas do aplicativo
├── widgets/         # Componentes UI reutilizáveis
└── main.dart        # Ponto de entrada
