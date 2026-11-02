class Label {
  final String hi, en;
  const Label(this.hi, this.en);
  String text(bool hindi) => hindi ? hi : en;
}

class Doctor {
  final Label name, qualification, languages;
  final int fee;
  const Doctor(this.name, this.qualification, this.languages, this.fee);
}

class Product {
  final String code;
  final Label name, description;
  final int price;
  const Product(this.code, this.name, this.description, this.price);
}

abstract interface class WellnessRepository {
  List<Doctor> get doctors;
  List<Product> get products;
  List<String> slots(DateTime date);
}

class DemoRepository implements WellnessRepository {
  @override
  List<Doctor> get doctors => const [
    Doctor(
      Label('डॉ. मीरा • नमूना', 'Dr Meera • Sample'),
      Label('एमबीबीएस, एमडी • मनोचिकित्सा', 'MBBS, MD • Psychiatry'),
      Label('हिंदी, English', 'Hindi, English'),
      800,
    ),
    Doctor(
      Label('डॉ. आरव • नमूना', 'Dr Aarav • Sample'),
      Label('एमबीबीएस • सामान्य स्वास्थ्य', 'MBBS • General health'),
      Label('हिंदी, English', 'Hindi, English'),
      600,
    ),
  ];
  @override
  List<Product> get products => const [
    Product(
      'MF-101',
      Label('वेलनेस जर्नल', 'Wellness journal'),
      Label(
        'भावनाएँ और आदतें लिखने की नमूना डायरी।',
        'Sample diary for feelings and habits.',
      ),
      299,
    ),
    Product(
      'MF-102',
      Label('केयर किट', 'Care kit'),
      Label(
        'जर्नल और आराम का eye mask। नमूना उत्पाद।',
        'Journal and relaxing eye mask. Sample product.',
      ),
      599,
    ),
  ];
  @override
  List<String> slots(DateTime date) =>
      date.day.isEven ? ['10:00', '14:30', '17:00'] : ['11:30', '16:00'];
}
