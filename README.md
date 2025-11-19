# TUGAS 7
1. Jelaskan apa itu widget tree pada Flutter dan bagaimana hubungan parent-child (induk-anak) bekerja antar widget.
Widget tree adalah strukur pohon dari deklarasi UI kita. Biasanya, root itu MaterialApp dan cabang-cabangnya adalah widget layout/komponen. Flutter akan membangun UI dengan cara merekonstruksi subtree saat ada perubahan.
Hubungan parent childnya:
1. Parent melayout dan memberi warna pada are anak
2. Child menerima constraint dari parent dan mengikuti settingan size parent
3. Child bisa mengakses resource parent/ancestornya

2. Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya.
Scaffold = rangka halaman Material (slot appBar, body, dsb). Ini dipakai sebagai kontainer utama UI.

AppBar = bar atas berisi judul “Football News”.

Padding = memberi ruang tepi (EdgeInsets.all(16) di body, dan EdgeInsets.only(top: 16) untuk teks heading).

Columnn = menata child secara vertikal (utama di body, dan di dalam Center).

Row = menata tiga kartu info (InfoCard) secara horizontal di bagian atas.

Center = memusatkan kolom konten utama (judul + grid).

SizedBox = jarak vertikal (height: 16) antara baris InfoCard dan konten berikutnya.

GridView.count = menampilkan daftar ItemCard dalam grid 3 kolom. Kita set shrinkWrap: true biar tinggi menyesuaikan konten.

Text = menampilkan teks statis (judul AppBar, heading “Selamat datang…”, label pada kartu).

Icon = menampilkan ikon pada ItemCard (ikon dari Icons.*).

Card = tampilan kartu Material untuk InfoCard (dengan elevation: 2).

Container = pembungkus serbaguna untuk ukuran, padding, dan styling (dipakai di ItemCard dan InfoCard).

3. Apa fungsi dari widget MaterialApp? Jelaskan mengapa widget ini sering digunakan sebagai widget root.
Fungsinya :
- Registrasi navigator dan route
- Menyediakan tema,localization,textdirection,mediaquery awal
- jadi ancestor untuk lookup berbasis BuildContext
Sering digunakan sebagai root karena dia langsung memasang default wiring aplikasi Material. Tanpa Material itu maka banyak API yang tidak tersedia. Selain itu, dia juga menstsandarkan perilaku UI lintas halaman aplikasinya.

4. Jelaskan perbedaan antara StatelessWidget dan StatefulWidget. Kapan kamu memilih salah satunya?
Stateless Widget = 
- Imutabel
- Sumber perubahan UI dari ancestors
- Biasanya lebih cocok untuk Icon, teks statis, card presentasional, pure render
Stateful Widget=
- Ada State<T> dan bisa berubah
- Perubahan UI nya via internal dengan setState,stream,controller
- Cocoknya untuk form input, animasi, tab controller, fetch data lalu update UI
Kita akan menggunakan stateful ketika kita butuh data dinamis pada grid/menu, controlelr/listener yang perlu dikelola terus menerus, form input, dan caching kecil di sisi UI. Kita akan gunakan stateless kalau kita hanya butuh komponen presentasional yang hanya render title dan content, ItemCard yang fungsinya sekedar tampil + kirim event, halaman statis dengan teks/ikon yang tidak terlalu berubah.

5. Apa itu BuildContext dan mengapa penting di Flutter? Bagaimana penggunaannya di metode build?
BuildContext itu “alamat” sebuah widget di dalam pohon widget. Dengan alamat ini, widget bisa “mengintip” ke atas untuk ambil layanan dari ancestor, seperti Theme, MediaQuery, Navigator, dan ScaffoldMessenger. Di kodenmu, kamu pakai Theme.of(context).colorScheme.primary untuk warna AppBar dan MediaQuery.of(context).size.width untuk lebar InfoCard. Keduanya jalan karena konteksnya berada di bawah penyedia Theme dan MediaQuery.

Penting menjaga scope. Panggil ScaffoldMessenger.of(context) dari konteks yang berada di dalam Scaffold supaya snackbar muncul. Jika butuh konteks yang lebih “dekat” ke widget tertentu, pisahkan jadi widget kecil atau gunakan Builder agar konteksnya tepat. Hindari menyimpan context untuk dipakai lama setelah build, terutama setelah widget dibuang.

6. Jelaskan konsep "hot reload" di Flutter dan bagaimana bedanya dengan "hot restart".
Hot reload menyuntik perubahan kode tanpa mereset aplikasi. State yang sedang aktif tetap ada. Cocok saat kita mengubah tampilan, teks, padding, warna, atau handler tap sederhana. Iterasi cepat karena kamu tidak kehilangan posisi UI atau nilai yang sedang tampil.

Hot restart memulai ulang aplikasi dari awal. Semua state direset dan main() dieksekusi ulang. Kita pilih ini saat mengubah inisialisasi global, struktur root, daftar route, dependency, atau ketika hasil hot reload terasa tidak sinkron. Aturan praktisnya sederhana. Perubahan kosmetik atau logika lokal pakai hot reload. Perubahan fundamental atau gejala "state nyangkut" pakai hot restart.

# TUGAS 8

1. Jelaskan perbedaan antara Navigator.push() dan Navigator.pushReplacement() pada Flutter. Dalam kasus apa sebaiknya masing-masing digunakan pada aplikasi Football Shop kamu?

Navigator.push() menambahkan route baru ke stack navigasi tanpa menghapus route sebelumnya. Pengguna dapat kembali ke halaman sebelumnya dengan tombol back. Di aplikasi Football Shop, saya menggunakan Navigator.push() ketika navigasi dari halaman utama ke form tambah produk (ProductFormPage), karena pengguna mungkin ingin kembali ke halaman utama setelah mengisi atau membatalkan form.

Navigator.pushReplacement() menggantikan route saat ini dengan route baru, sehingga route lama dihapus dari stack dan pengguna tidak bisa kembali ke halaman sebelumnya dengan tombol back. Di aplikasi Football Shop, saya menggunakan Navigator.pushReplacement() pada drawer ketika memilih opsi "Halaman Utama", karena ini menggantikan halaman saat ini dengan halaman utama dan tidak perlu ada history sebelumnya.

Kasus penggunaan:
- Navigator.push(): Ketika menekan tombol "Create Product" di halaman utama atau memilih "Tambah Produk" di drawer, karena pengguna bisa kembali ke halaman sebelumnya.
- Navigator.pushReplacement(): Ketika memilih "Halaman Utama" di drawer dari halaman form, karena ini adalah navigasi utama dan tidak perlu bisa kembali ke form setelahnya.

2. Bagaimana kamu memanfaatkan hierarchy widget seperti Scaffold, AppBar, dan Drawer untuk membangun struktur halaman yang konsisten di seluruh aplikasi?

Scaffold, AppBar, dan Drawer membentuk struktur dasar yang konsisten di seluruh aplikasi Football Shop:

Scaffold digunakan sebagai widget root untuk setiap halaman (MyHomePage dan ProductFormPage). Scaffold menyediakan struktur Material Design yang konsisten dengan slot untuk AppBar, body, dan drawer.

AppBar digunakan di semua halaman dengan styling yang konsisten:
- Judul "Football Shop" di halaman utama dan "Tambah Produk" di form
- Warna latar belakang menggunakan Theme.of(context).colorScheme.primary untuk konsistensi tema
- Teks putih dengan fontWeight bold untuk readability

Drawer (LeftDrawer) digunakan di semua halaman melalui property drawer di Scaffold. Drawer menyediakan navigasi yang konsisten dengan:
- DrawerHeader dengan branding "Football Shop" dan warna primary
- ListTile untuk "Halaman Utama" dan "Tambah Produk" dengan ikon yang sesuai
- Navigasi yang konsisten menggunakan Navigator.pushReplacement() untuk Home dan Navigator.push() untuk Form

Dengan struktur ini, setiap halaman memiliki:
- AppBar yang konsisten di bagian atas
- Drawer yang dapat diakses dari hamburger menu
- Body yang fleksibel untuk konten spesifik halaman

Hal ini memastikan pengalaman pengguna yang konsisten dan navigasi yang mudah di seluruh aplikasi.

3. Dalam konteks desain antarmuka, apa kelebihan menggunakan layout widget seperti Padding, SingleChildScrollView, dan ListView saat menampilkan elemen-elemen form? Berikan contoh penggunaannya dari aplikasi kamu.

Padding memberikan ruang kosong di sekeliling widget, meningkatkan readability dan visual hierarchy. Di aplikasi Football Shop, saya menggunakan Padding di:
- Setiap field form (TextFormField, DropdownButtonFormField, SwitchListTile) dengan EdgeInsets.all(8.0) untuk memberikan spacing yang konsisten antar elemen form
- Body halaman utama dengan EdgeInsets.all(16.0) untuk memberikan margin dari tepi layar

SingleChildScrollView memungkinkan konten dapat di-scroll ketika konten melebihi tinggi layar. Ini sangat penting untuk form yang panjang. Di ProductFormPage, saya membungkus Column yang berisi semua field form dengan SingleChildScrollView, sehingga ketika keyboard muncul atau pada layar kecil, pengguna dapat scroll untuk mengakses semua field form tanpa terpotong.

ListView digunakan untuk menampilkan list item yang dapat di-scroll secara efisien. Di LeftDrawer, saya menggunakan ListView untuk menampilkan DrawerHeader dan ListTile items. ListView lebih efisien daripada Column karena hanya me-render item yang terlihat di layar, dan secara otomatis menangani scrolling.

Kelebihan kombinasi ini:
- Padding: Memastikan spacing yang konsisten dan tidak terlalu rapat
- SingleChildScrollView: Memastikan form tetap dapat diakses di semua ukuran layar
- ListView: Efisien untuk list yang panjang dan menangani scrolling dengan baik

4. Bagaimana kamu menyesuaikan warna tema agar aplikasi Football Shop memiliki identitas visual yang konsisten dengan brand toko?

Saya menyesuaikan warna tema di MaterialApp (lib/main.dart) menggunakan ColorScheme.fromSwatch dengan primarySwatch Colors.blue. Warna ini kemudian digunakan secara konsisten di seluruh aplikasi melalui Theme.of(context).colorScheme.primary.

Konsistensi warna di seluruh aplikasi:
- AppBar backgroundColor: Theme.of(context).colorScheme.primary (biru)
- Drawer header backgroundColor: Theme.of(context).colorScheme.primary (biru)
- Tombol "Simpan" di form: Theme.of(context).colorScheme.primary (biru)
- Semua elemen menggunakan warna dari tema yang sama

Keuntungan menggunakan hal ini:
1. Konsistensi: Semua warna berasal dari satu sumber tema sehingga perubahan warna hanya perlu dilakukan di satu tempat (MaterialApp)
2. Mudah diubah: Jika ingin mengubah identitas warna (misalnya ke hijau untuk sepak bola), cukup ubah primarySwatch di MaterialApp
3. Material Design: Mengikuti best practice Material Design dengan menggunakan ColorScheme
4. Accessibility: Flutter secara otomatis menyesuaikan warna kontras untuk readability


TUGAS 9

1. Mengapa perlu membuat model Dart saat mengambil atau mengirim data JSON?

Tanpa model Dart, semua data akan diperlakukan sebagai Map<String, dynamic> yang serba bebas tipe. Ini kelihatannya fleksibel, tetapi:

- Validasi tipe jadi lemah: salah baca field (misalnya price kadang String, kadang int) baru ketahuan saat runtime dengan error seperti type 'String' is not a subtype of type 'int'.
- Null-safety tidak maksimal: dengan model, kita bisa tandai mana field yang wajib (required) dan mana yang nullable. Kalau memakai Map, kita mudah lupa cek null dan rawan NPE.
- Maintainability buruk: kalau struktur JSON dari backend berubah (rename field, tambah field), kita harus memburu semua penggunaan map['field'] di seluruh kode. Dengan model, perubahan cukup di satu tempat (constructor fromJson atau toJson).
- Autocompletion dan dokumentasi lebih enak: IDE bisa membantu dengan autocomplete product.fields.name, tipe yang jelas, dan refactor yang aman.

Jadi model Dart berfungsi sebagai kontrak kuat antara Flutter dan JSON backend, sementara Map<String, dynamic> cocok hanya untuk prototyping cepat atau data yang benar-benar bebas.

2. Fungsi package http dan CookieRequest

- package http:
  - Client HTTP generik untuk melakukan GET, POST, dan lain-lain.
  - Tidak menyimpan session atau cookie secara otomatis.
  - Cocok untuk endpoint publik (tanpa login) atau request sederhana.

- CookieRequest (dari pbp_django_auth):
  - Dibangun di atas HTTP client, tetapi:
    - Menyimpan dan mengirim session cookie Django secara otomatis.
    - Menyediakan helper khusus seperti login, logout, postJson, get, dan sebagainya.
    - Menyelaraskan mekanisme auth dengan Django (status login, user, dan sebagainya).

Di tugas ini:
- http cocoknya untuk endpoint JSON biasa (misalnya saat masih memakai product_json).
- CookieRequest wajib dipakai untuk semua endpoint yang butuh login atau session Django (login, register, logout, daftar produk milik user, create, update, dan delete produk).

3. Mengapa instance CookieRequest dibagikan ke semua komponen?

- Session harus konsisten: begitu user login, cookie session disimpan di CookieRequest. Kalau setiap halaman membuat instance CookieRequest baru, cookie tidak ikut pindah sehingga halaman lain dianggap belum login.
- Satu sumber kebenaran untuk auth: status login, header, dan cookie hanya dikelola di satu objek. Semua widget yang butuh request cukup memanggil context.watch<CookieRequest>().
- Lebih mudah di-maintain: kalau nanti cara login, header, atau base URL berubah, kita cukup mengubah di satu tempat (setup CookieRequest), bukan di semua halaman.

Karena itu CookieRequest dibungkus dengan Provider di main.dart, lalu di-inject ke seluruh aplikasi lewat widget tree.

4. Konfigurasi konektivitas Flutter dan Django

Agar Flutter bisa berkomunikasi dengan Django dengan benar, perlu beberapa konfigurasi:

- 10.0.2.2 di ALLOWED_HOSTS (Django):
  - Android emulator mengakses host (localhost PC) melalui 10.0.2.2, bukan localhost.
  - Kalau alamat ini tidak diizinkan di ALLOWED_HOSTS, Django akan menolak request dengan error Bad Request (400).

- CORS dan pengaturan cookie atau SameSite:
  - Jika Flutter web atau origin lain mengakses Django, perlu CORS yang mengizinkan origin tersebut.
  - Cookie session butuh konfigurasi SameSite dan Secure yang benar supaya ikut terkirim di setiap request.
  - Jika salah:
    - Request bisa diblok oleh browser (CORS error).
    - Cookie tidak terkirim sehingga semua endpoint yang butuh login selalu dianggap tidak terautentik (user = anonymous).

- Izin internet di Android (AndroidManifest.xml):
  - Perlu uses-permission android:name="android.permission.INTERNET".
  - Kalau lupa, aplikasi Android tidak bisa membuka koneksi HTTP sama sekali (request selalu gagal atau tidak jalan).

Tanpa konfigurasi di atas, gejalanya adalah request gagal, status code aneh (400 atau 403), atau selalu dianggap belum login walaupun sudah login.

5. Mekanisme pengiriman data dari input hingga tampil di Flutter

Alur lengkapnya kira-kira seperti ini:

1. Input di Flutter:
   - User mengisi form (login, register, create product) lewat TextFormField, DropdownButtonFormField, SwitchListTile, dan lain-lain.
   - Saat user menekan tombol submit, Flutter mengumpulkan nilai ke variabel state seperti _name, _price, dan seterusnya, lalu memvalidasi dengan validator.

2. Mengirim ke Django:
   - Flutter membentuk payload JSON dengan jsonEncode atau map biasa (untuk login).
   - Mengirim ke Django lewat CookieRequest.postJson atau request.login ke endpoint yang sesuai seperti /auth/login/ atau /api/flutter/products/create/.

3. Proses di Django:
   - Django view menerima request dan membaca body JSON dengan json.loads(request.body) atau form POST.
   - Data divalidasi (required field, tipe data, relasi user).
   - Jika valid, Django menyimpan atau mengambil data dari database (misalnya Product.objects.create atau Product.objects.all).
   - Django mengembalikan JSON response berisi status (success atau error) dan data yang dibutuhkan.

4. Diterima kembali di Flutter:
   - Flutter membaca response JSON sebagai Map atau List.
   - Provider (ProductProvider) mengubah JSON menjadi model Dart (Product atau Fields) lewat fromJson.
   - State di provider di-update (misalnya _products, _error, _isLoading), lalu notifyListeners dipanggil.

5. Ditampilkan di UI:
   - Widget seperti ProductListPage memakai Consumer<ProductProvider> untuk rebuild ketika data berubah.
   - Data product ditampilkan dalam ListView.builder, ListTile, gambar dengan Image.network, dan sebagainya.

6. Mekanisme autentikasi dari login, register, hingga logout

Register:
1. User mengisi username dan password di halaman register Flutter.
2. Flutter mengirim payload ke endpoint Django seperti /auth/register/ atau api_register lewat CookieRequest.postJson.
3. Django memvalidasi form UserCreationForm (cek unik, panjang password, dan konfirmasi password).
4. Jika sukses, Django membuat user baru dan mengembalikan response sukses.
5. Flutter menampilkan snackbar atau pesan sukses dan mengarahkan user ke halaman login.

Login:
1. User mengisi username dan password pada halaman login Flutter.
2. Flutter memanggil request.login("http://localhost:8000/auth/login/", dan seterusnya).
3. Django:
   - Memanggil authenticate.
   - Jika valid, memanggil login(request, user) dan membuat session serta cookie.
   - Mengembalikan JSON dengan status true, message, dan username.
4. pbp_django_auth menyimpan cookie session di CookieRequest.
5. Flutter mengecek response status:
   - Jika true, tampilkan snackbar, lalu Navigator.pushReplacement ke MyHomePage.
   - Kalau false, tampilkan dialog atau error.

Akses endpoint setelah login:
- Semua request berikutnya menggunakan CookieRequest.get atau postJson, sehingga cookie session selalu ikut terkirim.
- Django melihat request.user sebagai user yang sudah login sehingga dapat memfilter produk milik user, membatasi akses, dan sebagainya.

Logout:
1. Di Flutter, user menekan menu Logout (misalnya di LeftDrawer).
2. Flutter memanggil request.logout("http://localhost:8000/auth/logout/").
3. Django memanggil logout(request) dan menghapus session.
4. Django mengembalikan JSON dengan status true, message, dan username.
5. Flutter menampilkan snackbar "Logged out..." dan mengarahkan user kembali ke LoginPage dengan Navigator.pushReplacement.

7. Implementasi checklist secara bertahap

Secara garis besar, langkah yang saya lakukan:

1. Setup dependency dan proyek:
   - Menambahkan http, provider, dan pbp_django_auth di pubspec.yaml.
   - Menjalankan flutter pub get.
   - Mengatur MaterialApp dan tema dasar di main.dart.

2. Membuat model Product:
   - Di awal sempat mengikuti format serializers Django (model/pk/fields), lalu menyesuaikan dengan bentuk JSON dari product_to_dict.
   - Menulis class Product dan Fields dengan fromJson dan toJson.

3. Menyusun Provider untuk state management:
   - Membuat ProductProvider dengan state _products, _isLoading, dan _error.
   - Menambahkan method fetchProducts dan fetchProductDetail.
   - Menggunakan notifyListeners setiap kali state berubah.

4. Mengintegrasikan CookieRequest dengan Provider:
   - Di main.dart, membungkus MaterialApp dengan Provider<CookieRequest> dan ChangeNotifierProvider<ProductProvider>.
   - Memanggil productProvider.setRequest(request) agar provider memiliki akses ke CookieRequest.

5. Autentikasi (login, register, logout):
   - Membuat halaman LoginPage dan RegisterPage dengan form dan validasi.
   - Login:
     - Memanggil request.login("/auth/login/", dan seterusnya).
     - Kalau sukses, mengarahkan ke MyHomePage.
   - Register:
     - Memanggil request.postJson("/auth/register/", jsonEncode dan seterusnya).
     - Menampilkan pesan dan mengarahkan ke login.
   - Logout:
     - Menambahkan menu Logout di LeftDrawer.
     - Memanggil request.logout("/auth/logout/"), menampilkan snackbar, lalu kembali ke LoginPage.

6. Fetch dan tampilkan data produk:
   - Menghubungkan endpoint Django:
     - List: /api/flutter/products/?filter=all|mine yang mengembalikan JSON dengan status dan data berupa daftar product_to_dict.
     - Detail: /json/<id>/ (atau flutter_product_detail) untuk satu produk.
   - Mengonversi JSON flat ke model Product atau Fields di ProductProvider.
   - Menampilkan list di ProductListPage dengan ListView.builder dan Consumer<ProductProvider>.

7. Form create product yang terhubung ke Django:
   - Mengubah ProductFormPage:
     - Mengirim data lewat request.postJson("/api/flutter/products/create/", jsonEncode dan seterusnya).
     - Meng-handle sukses atau gagal lewat snackbar dan navigasi kembali ke home.

8. Filter All Product dan My Products:
   - Di views.py sudah ada logika filter berdasarkan query filter=all|mine.
   - Di Flutter:
     - Menambah parameter initialFilter di ProductListPage.
     - Di menu utama:
       - All Product menuju ProductListPage(initialFilter: "all").
       - My Products menuju ProductListPage(initialFilter: "mine").
     - Di ProductProvider.fetchProducts, menambahkan query ?filter=filter supaya backend memakai filter yang tepat.

9. Debugging dan penyesuaian format JSON:
   - Menemukan error type 'String' is not a subtype of type 'int' karena beberapa field seperti user, price, dan sebagainya tidak selalu dalam bentuk int.
   - Menambahkan konversi aman seperti int.tryParse dan cek tipe sebelum cast di ProductProvider saat membangun model Product.

Dengan langkah-langkah ini, integrasi Flutter dan Django berjalan. Login, register, dan logout memakai session Django, produk bisa dimuat dan difilter (all dan mine), dan form Flutter terhubung ke endpoint Django untuk menyimpan data.