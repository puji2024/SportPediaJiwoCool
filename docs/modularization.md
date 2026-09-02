# Modularization SportsPedia

![Hubungan modul SportsPedia](sportspedia-modules.svg)

SportsPedia memakai satu repository Git dan satu Xcode project. Modul dipisahkan sebagai **local Swift Package** yang tetap berada di dalam folder `SportsPedia`; tidak ada repository Git terpisah di dalam package.

```
SportsPedia/
├── App/                         # App entry point dan Needle composition root
├── Generated/                   # NeedleGenerated.swift dan SwiftGen output
├── Presentation/RootView.swift  # Tab host / wiring ViewModel
├── Domainless/
│   ├── Common/                  # API configuration dan NeedleFoundation re-export
│   ├── Domain/                  # Team, repository contract, dan use case
│   └── Data/                    # TheSportsDB v1, repository, dan Core Data favorit
└── Feature/
    ├── Teams/                   # Daftar, filter/sort, serta detail tim
    ├── Favorites/               # Daftar dan penghapusan tim favorit
    └── Profile/                 # Konten profil developer
```

## Package dan dependency

| Package | Tanggung jawab | Bergantung pada |
| --- | --- | --- |
| `Common` | `SportsPediaAPI` untuk endpoint TheSportsDB v1; re-export `NeedleFoundation`. | NeedleFoundation |
| `Domain` | Entity `Team`, protokol repository, `GetTeamsUseCase`, dan `ManageFavoriteTeamUseCase`. | — |
| `Data` | `SportsDBService`, `TeamRepository`, dan `FavoriteStore` berbasis Core Data. | Common, Domain |
| `Teams` | Daftar tim, pencarian/filter, urutan, serta detail dan status favorit. | Domain |
| `Favorites` | Daftar favorit dan aksi hapus; memakai `TeamRow`/detail dari Teams. | Domain, Teams |
| `Profile` | Tampilan dan data profil developer. | — |

Target aplikasi mengimpor seluruh package tersebut. `RootView` hanya menjadi host tab dan membangun ViewModel dengan use case dari Domain; screen dan ViewModel berada di package feature masing-masing.

## Dependency injection dengan Needle

`SportsPediaApp` memanggil `registerProviderFactories()` dari `Generated/NeedleGenerated.swift`, lalu membuat `AppComponent`. `RootComponent` menyediakan satu instance bersama `TeamRepository` sebagai `TeamRepositoryProtocol`. Repository itu diteruskan ke `RootView`, yang membangun `DefaultGetTeamsUseCase` dan `DefaultManageFavoriteTeamUseCase` sebelum menginjeksikannya ke feature Teams dan Favorites.

Jika komponen Needle di `SportsPedia/App/DI` berubah, generate ulang file registrasi:

```sh
needle generate SportsPedia/Generated/NeedleGenerated.swift SportsPedia/App/DI
```

## Sumber data dan penyimpanan

`SportsDBService` menggunakan TheSportsDB **v1** dengan endpoint `lookup_all_teams.php?id=4328` untuk daftar tim Premier League. Konfigurasi URL berada di `Common/SportsPediaAPI`; tidak ada `API_V2_KEY` maupun import `SportsPediaData` pada app target.

`FavoriteStore` menyimpan tim favorit dengan Core Data programatis. `Data` adalah satu-satunya package yang mengetahui detail jaringan dan persistence; feature hanya menggunakan kontrak use case Domain.

## Test feature

Setiap feature memiliki Swift Testing target sendiri:

- `TeamsTests`: filter nama/negara, sorting, load sukses/gagal, dan status favorit detail.
- `FavoritesTests`: refresh serta penghapusan favorit.
- `ProfileTests`: kelengkapan data profil.

`SportsPediaTests` adalah test target Xcode yang memiliki integration test untuk memanggil TheSportsDB v1 secara langsung dan memverifikasi hasilnya dapat didekode. Test ini membutuhkan koneksi internet dan dijalankan melalui scheme aplikasi (`⌘U`).

Jalankan dari root repository:

```sh
swift test --package-path SportsPedia/Feature/Teams
swift test --package-path SportsPedia/Feature/Favorites
swift test --package-path SportsPedia/Feature/Profile
xcodebuild -project SportsPedia.xcodeproj -scheme SportsPedia test
```
