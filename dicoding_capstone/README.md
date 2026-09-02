# SportsPedia

Aplikasi katalog tim olahraga iOS untuk Capstone Dicoding. Data tim diambil dari TheSportsDB dan favorit tersimpan lokal memakai Core Data.

## Menjalankan proyek

1. Buka `SportsPedia.xcodeproj` dengan Xcode.
2. Pilih simulator iOS, lalu tekan Run.
3. Tambahkan foto asli developer ke `SportsPedia/Assets.xcassets/DeveloperPhoto.imageset/` sebelum pengumpulan.

SwiftGen akan meregenerasi accessor string dan asset saat build bila tersedia. Jalankan `swiftgen config run --config swiftgen.yml` setelah mengubah `Localizable.strings` atau `Assets.xcassets`.

Pencarian tim menggunakan Combine dengan debounce 300 ms. Konfigurasi lint tersedia pada `.swiftlint.yml`; pasang SwiftLint agar build phase lint dapat berjalan.

## Arsitektur

Clean Architecture + MVVM dengan tiga lapisan: Domain (`Team`, use case), Data (`SportsDBService`, `FavoriteStore`, `TeamRepository`), dan Presentation (ViewModel serta SwiftUI Views). Root app melakukan dependency injection manual melalui initializer. `GetTeamsUseCase` mengirim hasil melalui Combine publisher, lalu ViewModel berlangganan dengan `sink` untuk mengubah loading/sukses/error state secara reaktif.

## Wireframe

Lampirkan [wireframe visual](docs/sportspedia-wireframe.svg) atau [versi teks](docs/wireframe.md) pada submission.
