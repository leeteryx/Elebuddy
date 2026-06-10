enum QuestionType { singleChoice, yesNo, ageSelection }

class Question {
  final String id;
  final String category; // Preliminary, Cognitive, Social Emotional, dll.
  final String text;
  final String? subText;
  final String imagePath;
  final QuestionType type;
  final List<String>? options;

  Question({
    required this.id,
    required this.category,
    required this.text,
    this.subText,
    required this.imagePath,
    required this.type,
    this.options,
  });
}

final List<Question> screenerQuestions = [
  Question(
    id: 'q2',
    category: 'Preliminary',
    text: 'Tingkat Kemampuan Berbicara',
    subText: 'Mohon pilih tingkat kemampuan bicara anak anda',
    imagePath: 'images/elephant_berbicara.png',
    type: QuestionType.singleChoice,
    options: [
      'Belum bicara',
      'Bisa ya/tidak',
      'Paham kata',
      'Kurang jelas',
      'Sudah lancar',
    ],
  ),
  Question(
    id: 'q3',
    category: 'Preliminary',
    text: 'Apakah anak Anda pernah dievaluasi oleh seorang terapis?',
    imagePath: 'images/elephant_terapis.png',
    type: QuestionType.yesNo,
  ),
  Question(
    id: 'q4',
    category: 'Cognitive',
    text:
        'Apakah anak Anda bisa menggambar segitiga atau bentuk geometris lainnya dengan cara melihat (mencontoh)?',
    imagePath: 'images/elephant_draw.png',
    type: QuestionType.yesNo,
  ),
  Question(
    id: 'q5',
    category: 'Cognitive',
    text: 'Apakah anak Anda merespons jika dipanggil dari ruangan lain?',
    imagePath: 'images/elephant_respon.png',
    type: QuestionType.yesNo,
  ),
  Question(
    id: 'q6',
    category: 'Social Emotional',
    text:
        'Apakah anak Anda akan menatap mata Anda ketika Anda berbicara, bermain, atau berpakaian?',
    imagePath: 'images/elephant_social.png',
    type: QuestionType.yesNo,
  ),
  Question(
    id: 'q7',
    category: 'Motorik Kasar',
    text:
        'Apakah anak Anda bisa menendang bola kedepan tanpa kehilangan keseimbangan?',
    imagePath: 'images/elephant_bola.png',
    type: QuestionType.yesNo,
  ),
  Question(
    id: 'q8',
    category: 'Imitasi & Komunikasi',
    text: 'Jika Anda membuat wajah lucu, apakah anak Anda mencoba meniru Anda?',
    imagePath: 'images/elephant_cermin.png',
    type: QuestionType.yesNo,
  ),
];
