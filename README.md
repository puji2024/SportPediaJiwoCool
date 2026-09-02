# SportsPedia

Aplikasi katalog tim olahraga iOS untuk Capstone Dicoding. Data tim diambil dari TheSportsDB dan favorit tersimpan lokal memakai Core Data.

Data katalog memakai TheSportsDB v2 `list/teams/4328` (English Premier League). Karena v2 memerlukan Premium API key, isi Build Setting `API_V2_KEY` secara lokal dan jangan commit key tersebut.

## Menjalankan proyek

1. Buka `SportsPedia.xcodeproj` dengan Xcode.
2. Pilih simulator iOS, lalu tekan Run.
3. Tambahkan foto asli developer ke `SportsPedia/Assets.xcassets/DeveloperPhoto.imageset/` sebelum pengumpulan.

SwiftGen akan meregenerasi accessor string dan asset saat build bila tersedia. Jalankan `swiftgen config run --config swiftgen.yml` setelah mengubah `Localizable.strings` atau `Assets.xcassets`. Aplikasi menyediakan bahasa Indonesia dan Inggris.

Pencarian tim menggunakan Combine dengan debounce 300 ms. Konfigurasi lint tersedia pada `.swiftlint.yml`; pasang SwiftLint agar build phase lint dapat berjalan.

## Arsitektur

Clean Architecture + MVVM dengan tiga lapisan: Domain (`Team`, use case), Data (`SportsDBService`, `FavoriteStore`, `TeamRepository`), dan Presentation (ViewModel serta SwiftUI Views). Local package `SportsPediaModules` memisahkan `SportsPediaCommon`, `SportsPediaDomain`, dan `SportsPediaData`; modul Data memegang client TheSportsDB v2 dan endpoint bertipe. Root app melakukan dependency injection manual melalui initializer. `GetTeamsUseCase` mengirim hasil melalui Combine publisher, lalu ViewModel berlangganan dengan `sink` untuk mengubah loading/sukses/error state secara reaktif.

## Wireframe

Lampirkan [wireframe visual](docs/sportspedia-wireframe.svg), [hubungan modularisasi](docs/modularization.md), dan [diagram modul](docs/sportspedia-modules.svg) pada submission.

## Catatan fitur tambahan

Fitur **Sortir daftar tim** memungkinkan pengguna mengurutkan katalog berdasarkan nama atau negara. Tujuannya mempermudah eksplorasi daftar yang panjang tanpa mengganggu pencarian maupun favorit.

## Continuous Integration

Workflow GitHub Actions di `.github/workflows/ios-ci.yml` memeriksa code style dengan SwiftLint, menjalankan XCTest dengan code coverage, menyimpan artefak hasilnya, dan melakukan audit dependency bila project menggunakan Swift Package.
