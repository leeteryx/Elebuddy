class AlphabetNumberItem {
  final String symbol;
  final String name;
  final String example;
  final String emoji;

  const AlphabetNumberItem({
    required this.symbol,
    required this.name,
    required this.example,
    required this.emoji,
  });
}

class AlphabetNumberData {
  static const List<AlphabetNumberItem> alphabets = [
    AlphabetNumberItem(symbol: 'A', name: 'A', example: 'Apel', emoji: '🍎'),
    AlphabetNumberItem(symbol: 'B', name: 'B', example: 'Buku', emoji: '📚'),
    AlphabetNumberItem(symbol: 'C', name: 'C', example: 'Cicak', emoji: '🦎'),
    AlphabetNumberItem(symbol: 'D', name: 'D', example: 'Domba', emoji: '🐑'),
    AlphabetNumberItem(symbol: 'E', name: 'E', example: 'Elang', emoji: '🦅'),
    AlphabetNumberItem(symbol: 'F', name: 'F', example: 'Foto', emoji: '📷'),
    AlphabetNumberItem(symbol: 'G', name: 'G', example: 'Gajah', emoji: '🐘'),
    AlphabetNumberItem(symbol: 'H', name: 'H', example: 'Harimau', emoji: '🐯'),
    AlphabetNumberItem(symbol: 'I', name: 'I', example: 'Ikan', emoji: '🐟'),
    AlphabetNumberItem(symbol: 'J', name: 'J', example: 'Jerapah', emoji: '🦒'),
    AlphabetNumberItem(symbol: 'K', name: 'K', example: 'Kucing', emoji: '🐱'),
    AlphabetNumberItem(symbol: 'L', name: 'L', example: 'Landak', emoji: '🦔'),
    AlphabetNumberItem(
      symbol: 'M',
      name: 'M',
      example: 'Matahari',
      emoji: '☀️',
    ),
    AlphabetNumberItem(symbol: 'N', name: 'N', example: 'Nanas', emoji: '🍍'),
    AlphabetNumberItem(symbol: 'O', name: 'O', example: 'Ombak', emoji: '🌊'),
    AlphabetNumberItem(symbol: 'P', name: 'P', example: 'Pohon', emoji: '🌳'),
    AlphabetNumberItem(symbol: 'Q', name: 'Q', example: 'Qatar', emoji: '🏳️'),
    AlphabetNumberItem(symbol: 'R', name: 'R', example: 'Rusa', emoji: '🦌'),
    AlphabetNumberItem(symbol: 'S', name: 'S', example: 'Singa', emoji: '🦁'),
    AlphabetNumberItem(symbol: 'T', name: 'T', example: 'Tikus', emoji: '🐭'),
    AlphabetNumberItem(symbol: 'U', name: 'U', example: 'Udang', emoji: '🦐'),
    AlphabetNumberItem(symbol: 'V', name: 'V', example: 'Viola', emoji: '🎻'),
    AlphabetNumberItem(symbol: 'W', name: 'W', example: 'Wortel', emoji: '🥕'),
    AlphabetNumberItem(symbol: 'X', name: 'X', example: 'Xilofon', emoji: '🎵'),
    AlphabetNumberItem(symbol: 'Y', name: 'Y', example: 'Yogurt', emoji: '🥛'),
    AlphabetNumberItem(symbol: 'Z', name: 'Z', example: 'Zebra', emoji: '🦓'),
  ];

  static const List<AlphabetNumberItem> numbers = [
    AlphabetNumberItem(
      symbol: '0',
      name: 'Nol',
      example: 'Nol Buah',
      emoji: '0️⃣',
    ),
    AlphabetNumberItem(
      symbol: '1',
      name: 'Satu',
      example: 'Satu Apel',
      emoji: '🍎',
    ),
    AlphabetNumberItem(
      symbol: '2',
      name: 'Dua',
      example: 'Dua Bintang',
      emoji: '⭐⭐',
    ),
    AlphabetNumberItem(
      symbol: '3',
      name: 'Tiga',
      example: 'Tiga Bola',
      emoji: '⚽⚽⚽',
    ),
    AlphabetNumberItem(
      symbol: '4',
      name: 'Empat',
      example: 'Empat Kaki',
      emoji: '🐘',
    ),
    AlphabetNumberItem(
      symbol: '5',
      name: 'Lima',
      example: 'Lima Jari',
      emoji: '✋',
    ),
    AlphabetNumberItem(
      symbol: '6',
      name: 'Enam',
      example: 'Enam Telur',
      emoji: '🥚',
    ),
    AlphabetNumberItem(
      symbol: '7',
      name: 'Tujuh',
      example: 'Tujuh Pelangi',
      emoji: '🌈',
    ),
    AlphabetNumberItem(
      symbol: '8',
      name: 'Delapan',
      example: 'Delapan Kaki Gurita',
      emoji: '🐙',
    ),
    AlphabetNumberItem(
      symbol: '9',
      name: 'Sembilan',
      example: 'Sembilan Planet',
      emoji: '🪐',
    ),
    AlphabetNumberItem(
      symbol: '10',
      name: 'Sepuluh',
      example: 'Sepuluh Jari',
      emoji: '👐',
    ),
  ];
}
