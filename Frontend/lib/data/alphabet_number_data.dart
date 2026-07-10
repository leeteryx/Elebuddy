// lib/data/alphabet_number_data.dart

class AlphabetNumberItem {
  final String symbol;
  final String name;
  final String example;

  const AlphabetNumberItem({
    required this.symbol,
    required this.name,
    required this.example,
  });
}

class AlphabetNumberData {
  static const List<AlphabetNumberItem> alphabets = [
    AlphabetNumberItem(symbol: 'A', name: 'A', example: 'Apel'),
    AlphabetNumberItem(symbol: 'B', name: 'B', example: 'Buku'),
    AlphabetNumberItem(symbol: 'C', name: 'C', example: 'Cicak'),
    AlphabetNumberItem(symbol: 'D', name: 'D', example: 'Domba'),
    AlphabetNumberItem(symbol: 'E', name: 'E', example: 'Elang'),
    AlphabetNumberItem(symbol: 'F', name: 'F', example: 'Foto'),
    AlphabetNumberItem(symbol: 'G', name: 'G', example: 'Gajah'),
    AlphabetNumberItem(symbol: 'H', name: 'H', example: 'Harimau'),
    AlphabetNumberItem(symbol: 'I', name: 'I', example: 'Ikan'),
    AlphabetNumberItem(symbol: 'J', name: 'J', example: 'Jerapah'),
    AlphabetNumberItem(symbol: 'K', name: 'K', example: 'Kucing'),
    AlphabetNumberItem(symbol: 'L', name: 'L', example: 'Landak'),
    AlphabetNumberItem(symbol: 'M', name: 'M', example: 'Matahari'),
    AlphabetNumberItem(symbol: 'N', name: 'N', example: 'Nanas'),
    AlphabetNumberItem(symbol: 'O', name: 'O', example: 'Ombak'),
    AlphabetNumberItem(symbol: 'P', name: 'P', example: 'Pohon'),
    AlphabetNumberItem(symbol: 'Q', name: 'Q', example: 'Qatar'),
    AlphabetNumberItem(symbol: 'R', name: 'R', example: 'Rusa'),
    AlphabetNumberItem(symbol: 'S', name: 'S', example: 'Singa'),
    AlphabetNumberItem(symbol: 'T', name: 'T', example: 'Tikus'),
    AlphabetNumberItem(symbol: 'U', name: 'U', example: 'Udang'),
    AlphabetNumberItem(symbol: 'V', name: 'V', example: 'Viola'),
    AlphabetNumberItem(symbol: 'W', name: 'W', example: 'Wortel'),
    AlphabetNumberItem(symbol: 'X', name: 'X', example: 'Xilofon'),
    AlphabetNumberItem(symbol: 'Y', name: 'Y', example: 'Yogurt'),
    AlphabetNumberItem(symbol: 'Z', name: 'Z', example: 'Zebra'),
  ];

  static const List<AlphabetNumberItem> numbers = [
    AlphabetNumberItem(symbol: '0', name: 'Nol', example: 'Nol Buah'),
    AlphabetNumberItem(symbol: '1', name: 'Satu', example: 'Satu Apel'),
    AlphabetNumberItem(symbol: '2', name: 'Dua', example: 'Dua Bintang'),
    AlphabetNumberItem(symbol: '3', name: 'Tiga', example: 'Tiga Bola'),
    AlphabetNumberItem(symbol: '4', name: 'Empat', example: 'Empat Kaki'),
    AlphabetNumberItem(symbol: '5', name: 'Lima', example: 'Lima Jari'),
    AlphabetNumberItem(symbol: '6', name: 'Enam', example: 'Enam Telur'),
    AlphabetNumberItem(symbol: '7', name: 'Tujuh', example: 'Tujuh Pelangi'),
    AlphabetNumberItem(
      symbol: '8',
      name: 'Delapan',
      example: 'Delapan Kaki Gurita',
    ),
    AlphabetNumberItem(
      symbol: '9',
      name: 'Sembilan',
      example: 'Sembilan Planet',
    ),
    AlphabetNumberItem(symbol: '10', name: 'Sepuluh', example: 'Sepuluh Jari'),
  ];
}
