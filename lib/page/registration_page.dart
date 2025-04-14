import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seba_app1/page/home_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  final _postController = TextEditingController();
  final _localAddressController = TextEditingController();
// Check if Representative Code exists in Firestore
  // Future<bool> _checkRepresentativeCodeExists(String code) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final doc = await firestore.collection('Representative').doc(code).get();
  //   return doc.exists;
  // }

  String? selectedDivision;
  String? selectedDistrict;
  String? selectedThana;
  bool isLoading = false;

  final List<String> divisions = [
    'Barisal',
    'Chittagong',
    'Dhaka',
    'Khulna',
    'Mymensingh',
    'Rajshahi',
    'Rangpur',
    'Sylhet'
  ];

  final Map<String, List<String>> districts = {
    'Barisal': [
      'Barguna',
      'Barisal',
      'Bhola',
      'Jhalokati',
      'Patuakhali',
      'Pirojpur'
    ],
    'Chittagong': [
      'Bandarban',
      'Brahmanbaria',
      'Chandpur',
      'Chittagong',
      'Comilla',
      'Cox\'s Bazar',
      'Feni',
      'Khagrachari',
      'Lakshmipur',
      'Noakhali',
      'Rangamati'
    ],
    'Dhaka': [
      'Dhaka',
      'Faridpur',
      'Gazipur',
      'Gopalganj',
      'Kishoreganj',
      'Madaripur',
      'Manikganj',
      'Munshiganj',
      'Narayanganj',
      'Narsingdi',
      'Rajbari',
      'Shariatpur',
      'Tangail'
    ],
    'Khulna': [
      'Bagerhat',
      'Chuadanga',
      'Jessore',
      'Jhenaidah',
      'Khulna',
      'Kushtia',
      'Magura',
      'Meherpur',
      'Narail',
      'Satkhira'
    ],
    'Mymensingh': ['Jamalpur', 'Mymensingh', 'Netrokona', 'Sherpur'],
    'Rajshahi': [
      'Bogra',
      'Chapai Nawabganj',
      'Joypurhat',
      'Naogaon',
      'Natore',
      'Pabna',
      'Rajshahi',
      'Sirajganj'
    ],
    'Rangpur': [
      'Dinajpur',
      'Gaibandha',
      'Kurigram',
      'Lalmonirhat',
      'Nilphamari',
      'Panchagarh',
      'Rangpur',
      'Thakurgaon'
    ],
    'Sylhet': ['Habiganj', 'Moulvibazar', 'Sunamganj', 'Sylhet']
  };
  final Map<String, Map<String, List<String>>> thanas = {
    'Barisal': {
      'Barisal': [
        'Kotwali Barisal',
        'Hijla',
        'Mehediganj',
        'Muladi',
        'Babuganj',
        'Bakerganj',
        'Banaripara',
        'Agauljhara',
        'Gournadi',
        'Wazirpur',
        'Jhalokati',
        'Nalchithi',
        'Rajapur',
        'Kathalia'
      ],
      'Bhola': [
        'Bhola',
        'Daulatkhan',
        'Tajumuddin',
        'Borhanuddin',
        'Lalmohan',
        'Char Fashion',
        'Monpura'
      ],
      'Patuakhali': [
        'Patuakhali',
        'Baufal',
        'Galachipa',
        'Dashmina',
        'Dumki',
        'Kalapara',
        'Mirzaganj',
        'Rangabali'
      ],
      'Pirojpur': [
        'Pirojpur',
        'Bhandaria',
        'Nesarabad',
        'Kaukhali',
        'Nazirpur',
        'Zia Nagar',
        'Mathbaria',
      ],
      'Barguna': [
        'Amtali',
        'Taltali',
        'Patharghata',
        'Barguna sadar',
        'Betagi',
        'Bamna'
      ]
    },
    'Chittagong': {
      'Chandpur': [
        'Chandpur',
        'Hajiganj',
        'means',
        'means Answer',
        'means South',
        'Shaharasti',
        'Kachua',
        'Faridganj',
        'Haimchar',
        'Brahmanbaria Sadar',
        'Sarail',
        'Ashuganj',
        'Nasirnagar',
        'Nabinagar',
        'Bancharampur',
        'Kasba',
        'Akhaura'
      ],
      'Chittagong': [
        'Kotwali, CMP',
        'Pahartali (North Zone)',
        'Pachlaish',
        'Chandgaon',
        'Khulsi',
        'Bakulia',
        'Bayezid Bostami',
        'Port',
        'Double Mooring',
        'Halishahar',
        'Patenga',
        'Karnafuli',
        'Immigration (Port)',
        'Pahartali (Port Zone)'
      ],
      'Comilla': [
        'Kotwali Comilla',
        'Chauddagram',
        'Debiddar',
        'Homna',
        'Laksam',
        'Daudkandi',
        'Burichang',
        'Chandina',
        'Barura',
        'Muradnagar',
        'Brahmanpara',
        'Meghna',
        'Manoharganj',
        'Titas',
        'Sadar South Comilla'
      ],
      'Cox\'s Bazar': [
        'Sandeep',
        'Cox’s Bazar',
        'Ramu',
        'Ukhia',
        'Ramu',
        'Teknaf',
        'Chakoria',
        'Kutubdia',
        'Maheshkhali',
        'Pekua'
      ],
      'Feni': [
        'Feni',
        'Sonagazi',
        'Fulgazi',
        'Parashuram',
        'Chagalnaiya',
        'Daganbhuiyan'
      ],
      'Laxmipur': ['Laxmipur', 'Raipura', 'Ramganj', 'Ramgati'],
      'Noakhali': [
        'Sudharam, Noakhali',
        'Begumganj',
        'Senbagh',
        'Sonaimuri',
        'Companiganj',
        'Chatkhil',
        'Hatia',
        'Charjabbar'
      ],
    },
    'Dhaka': {
      'Dhaka': [
        'Ramna',
        'Dhanmondi',
        'Shahbag',
        'New Market',
        'Lalbagh',
        'Kotwali',
        'Hazaribagh',
        'Kamrangirchar',
        'Sutrapur',
        'Demra',
        'Jatrabari',
        'Motijheel',
        'Sabujbagh',
        'Khilgaon',
        'platoon',
        'Uttara',
        'Airport',
        'Turag',
        'Uttarkhan',
        'Dakshin Khan',
        'Gulshan',
        'Cantonment',
        'Badda',
        'Khilkhet',
        'Tejgaon',
        'Tejgaon Shi / A',
        'Mohammadpur',
        'Adabar',
        'Mirpur',
        'Pallabi',
        'Kafrul',
        'Shah Ali',
        'Savar',
        'Dhamrai',
        'Keraniganj',
        'Nawabganj',
        'Dohar',
        'Ashulia',
        'South Keraniganj'
      ],
      'Faridpur': [
        'Kotwali Faridpur',
        'Madhukhali',
        'Boalmari',
        'Alfadanga',
        'Charbhadrasan',
        'Nagarkanda',
        'Sadarpur',
        'Salta',
        'Bhanga'
      ],
      'Gazipur': [
        'Joydevpur',
        'Tongi',
        'Kaliakair',
        'Sreepur',
        'Kapasia',
        'Kaliganj'
      ],
      'Gopalganj': [
        'Gopalganj',
        'Maksudpur',
        'Kashiani',
        'Kotalipara',
        'Tungipara'
      ],
      'Kishoreganj': [
        'Kishoreganj',
        'Karimganj',
        'Tarail',
        'Hossainpur',
        'Katiadi',
        'Bajitpur',
        'Kuliyarchar',
        'Bhairab',
        'Itna',
        'Mithamin',
        'Nikli',
        'Pakundia',
        'Ashtagram'
      ],
      'Madaripur': ['Madaripur', 'Rajoir', 'Kalkini', 'Shivchar'],
      'Manikganj': [
        'Manikganj',
        'Ghior',
        'Shibalaya',
        'Daulatpur',
        'Harirampur',
        'Saturia',
        'Singair'
      ],
      'Munshiganj': [
        'Munshiganj',
        'Tongibari',
        'Louhjong',
        'Srinagar',
        'Sirajdikhan',
        'Gazaria'
      ],
      'Narayanganj': [
        'Narayanganj',
        'Fatullah',
        'Port',
        'Siddirganj',
        'Araihazar',
        'Sonargaon',
        'Rupganj',
      ],
      'Narsingdi': [
        'Narsingdi',
        'Raipur',
        'Shibpur',
        'Belabo',
        'Manohardi',
        'Palash'
      ],
      'Rajbari': [
        'Rajbari',
        'Baliakandi',
        'Pangsha',
        'Goalanda',
        'Gosairhat',
        'Vederganj',
        'Damudda',
        'Jajira',
        'Naria',
        'Palang',
        'Shakhipur',
      ],
      'Tangail': [
        'Tangail',
        'Mirzapur',
        'Nagarpur',
        'Sakhipur',
        'Basail',
        'Delduar',
        'Madhupur',
        'Ghatail',
        'Kalihati',
        'Bhuapur',
        'Jamuna Bridge East',
        'Dhanbari',
        'Gopalpur'
      ]
    },
    'Khulna': {
      'Bagerhat': [
        'Bagerhat',
        'Fakirhat',
        'Mollarhat',
        'Chitalmari',
        'Kachua',
        'Mongla',
        'Moralganj',
        'Sharankhola',
        'Rampal'
      ],
      'Chuadanga': [
        'Chuadanga',
        'Alamdanga',
        'Jivannagar',
        'Damurhuda',
        'Meherpur',
        'Gangni',
        'Mujibnagar'
      ],
      'Jessore': [
        'Kotwali Jessore',
        'Jhikargachha',
        'Sharsha',
        'Chougachha',
        'Monirampur',
        'Keshabpur',
        'Abhaynagar',
        'Bagharpara',
        'Benapole Port ',
        'Benapole Check Post'
      ],
      'Khulna': [
        'Khulna',
        'Sonadanga',
        'Khalishpur',
        'Daulatpur',
        'Khanjahan Ali',
        'Fultala',
        'Dighalia',
        'Paikgachha',
        'Batiaghata',
        'Dumuria',
        'Terkhada',
        'Rupsa',
        'Dakop',
        'Koira'
      ],
      'Kushtia': [
        'Kushtia',
        'Khoksa',
        'Kumarkhali',
        'Bheramara',
        'Daulatpur',
        'Mirpur',
        'Islamic University'
      ],
      'Magura': [
        'Magura',
        'Shalikha',
        'Sreepur',
        'Mohammadpur',
        'Jhenaidah',
        'Kaliganj',
        'Shailkupa',
        'Harinakundu',
        'Kotchadpur',
        'Maheshpur'
      ],
      'Narail': ['Narail', 'Kalia', 'Lohagarh', 'Naragati'],
      'Satkhira': [
        'Satkhira',
        'Kalaroa',
        'l k',
        'Kaliganj',
        'Debhata',
        'Asashuni',
        'Patkelghata'
      ]
    },
    'Mymensingh': {
      'Jamalpur': [
        'Jamalpur',
        'Melandah',
        'Sarishabar',
        'Dewanganj',
        'Islampur',
        'Madarganj',
        'Bakshiganj',
        'Bahadurabad'
      ],
      'Mymensingh': [
        'Kotwali Mymensingh',
        'Muktagachha',
        'Phulbari',
        'Trishal',
        'Gauripur',
        'Ishwarganj',
        'Nandail',
        'Phulpur',
        'Haluaghat',
        'Dhobaura',
        'Gafargaon',
        'Bhaluka',
        'Tarakanda'
      ],
      'Netrokon': [
        'Netrokona',
        'Barhatta',
        'Kalmakanda',
        'Durgapur',
        'Purbadhala',
        'Kendua',
        'Madan',
        'Mohanganj',
        'Khalijuri',
        'Sherpur'
      ],
      'Sherpur': ['Nakla', 'Nalitabari', 'Srivardi', 'Jhenaigati']
    },
    'Rajshahi': {
      'Bogra': [
        'Bogra',
        'Shibganj',
        'Sonatala',
        'Gabtali',
        'Sariakandi',
        'Adamdighi',
        'Dhupchachia',
        'Kahalu',
        'Sherpu',
        'Dhunat',
        'Nandigram',
        'Shahjahanpur'
      ],
      'Chapai Nawabganj': [
        'Chapai Nawabganj',
        'Shibganj',
        'Gomstapur',
        'Nachol',
        'Bholahat'
      ],
      'Joypurhat': ['Joypurhat', 'Kalai', 'Khetlal', 'Akkelpur', 'Pachbibi'],
      'Naogaon': [
        'Naogaon',
        'Rayanagar',
        'Atrai',
        'Dhamrai',
        'Budalgachhi',
        'Mahadevpur',
        'Patnitala',
        'Niamatpur',
        'Manda',
        'Sapahar',
        'Parsha'
      ],
      'Natore': [
        'Natore',
        'Singra',
        'Baghatipara',
        'Gurudaspur',
        'Lalpur',
        'Borigram',
        'Naldanga'
      ],
      'District': [
        'Pabna',
        'Ishwardi',
        'Atgharia',
        'Chatmohar',
        'Bhangora',
        'Faridpur (Pabna)',
        'Suryanagar',
        'Fence',
        'Sathya',
        'Ataikula'
      ],
      'Rajshahi': [
        'Boalia',
        'Rajapur',
        'Motihar',
        'Shah Makdum',
        'Paba',
        'Gudagari',
        'Tanar',
        ' Mohanpur',
        'Puthia',
        'Bagmara',
        'Durgapur',
        ' Charghat',
        'Bagha'
      ],
      'Sirajganj': [
        'Sirajganj',
        'Shahjadpur',
        'Ullapara',
        'Taras',
        'Kazipur',
        'Kamarkhand',
        'Raiganj',
        'Belkuchi',
        'Jamuna Bridge West',
        'Salanga',
        'Enayetpur'
      ]
    },
    'Rangpur': {
      'Dinajpur District': [
        'Kotwali Dinajpur',
        'Chiri Port',
        'Real',
        'Parbatipur',
        'Birganj',
        'B haganj',
        'Kaharol',
        'Khansama',
        'Phulbari',
        'Nawabganj (Dinajpur)',
        'Ghoraghat',
        'Hakimpur'
      ],
      'Gaibandha': [
        'Gaibandha ',
        'Sadullapur',
        'Sundarganj',
        'Palashbari',
        'Gobindganj',
        'Satghata',
        'Fulchhari'
      ],
      'Kurigram': [
        'Kurigram',
        'Rajarhat',
        'Phulbari',
        'Nageshwar',
        'Burungamari',
        'Ulipur',
        'Chilmari',
        'Raomari',
        'Rajibpur',
        'Dusmara',
        'K hakata'
      ],
      'Lalmonirhat': [
        'Lalmonirhat',
        'Aditmari',
        'Kaliganj',
        'Hatibanda',
        'Patgram'
      ],
      'Nilphamari': [
        'Nilphamari',
        'Syedpur',
        'Jaldhaka',
        'Kishoreganj (Nilphamari)',
        'Domar',
        'Dimla',
        'Syedpur Police Outpost'
      ],
      'Panchagarh': ['Panchagarh', 'Boda', 'Atwari', 'Tetulia', 'Debiganj'],
      'Rangpur': [
        'Kotwali, Rangpur',
        'Gangachura',
        'Bhodarganj',
        'Taraganj',
        'Mithapukur',
        'Pirgachha',
        'Kaunia',
        'Pirganj'
      ],
      'Thakurgaon': [
        'Thakurgaon',
        'Baliadangi',
        'Rani Sankoul',
        'Pirganj',
        'Haripur'
      ]
    },
    'Sylhet': {
      'Habiganj': [
        'Habiganj',
        'Madhabpur',
        'Chunarughat',
        'Bahubal',
        'Lakhai',
        'Nabiganj',
        'Baniachang',
        'Ajmiriganj',
        'Shayestaganj'
      ],
      'Moulvibazar': [
        'Moulvibazar',
        'Srimangal',
        'Kamalganj',
        'Rajnagar',
        'Kulaura',
        'Baralekha',
        'Jury'
      ],
      'Sunamganj': [
        'Sunamganj',
        'Chhatak',
        'Jagannathpur',
        'Tahirpur',
        'Bishwambarpur',
        'Doarabazar',
        'Dirai',
        'Salna',
        'Jamalganj',
        'Dharmapasha',
        'Madhyanagar'
      ],
      'Sylhet': [
        'Kotwali (Sylhet)',
        'Balaganj',
        'Jaintapur',
        'Gowainghat',
        'Kanaighat',
        'Companiganj',
        'Zakiganj',
        'Beanibazar',
        'Golapganj',
        'Bishwanath',
        'Fenchuganj',
        'South Surma',
        'Osmani Nagar'
      ]
    }
  };
  void _showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
  }

  void _hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();

      try {
        // Get current user
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // Create user data map
          Map<String, dynamic> userData = {
            'name': _nameController.text.trim(),
            'fatherName': _fatherNameController.text.trim(),
            'motherName': _motherNameController.text.trim(),
            'phoneNumber': _phoneController.text.trim(),
            'nidOrBirthCertificate': _nidController.text.trim(),
            'division': selectedDivision,
            'district': selectedDistrict,
            'thana': selectedThana,
            'post': _postController.text.trim(),
            'localAddress': _localAddressController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          };

          // Save to Firestore
          await FirebaseFirestore.instance
              .collection('Registration')
              .doc(currentUser.email)
              .set(userData);

          _hideLoadingDialog();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration Successful!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );

          // Clear form fields
          _formKey.currentState!.reset();
        } else {
          _hideLoadingDialog();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('User not authenticated. Please login first.')),
          );
        }
      } catch (e) {
        _hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Form"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "Name",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _fatherNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your father\'s name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "Father Name",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _motherNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mother\'s name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "Mother Name",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "Phone Number",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nidController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your NID/Birth Certificate';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "NID/Birth Certificate",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedDivision,
                  items: divisions.map((division) {
                    return DropdownMenuItem<String>(
                      value: division,
                      child: Text(division),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDivision = value;
                      selectedDistrict = null;
                      selectedThana = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a division';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "Division",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedDistrict,
                  items: selectedDivision == null
                      ? []
                      : districts[selectedDivision]?.map((district) {
                            return DropdownMenuItem<String>(
                              value: district,
                              child: Text(district),
                            );
                          }).toList() ??
                          [],
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                      selectedThana = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a district';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "District",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedThana,
                  items: selectedDistrict == null
                      ? []
                      : thanas[selectedDivision]?[selectedDistrict]
                              ?.map((upazila) {
                            return DropdownMenuItem<String>(
                              value: upazila,
                              child: Text(upazila),
                            );
                          }).toList() ??
                          [],
                  onChanged: (value) {
                    setState(() {
                      selectedThana = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an upazila';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "Thana",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _postController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your post';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "Post",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _localAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your local address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19.r),
                      borderSide:
                          BorderSide(color: Color(0xFFD32F2E), width: 0.w),
                    ),
                    hintText: "Local Address",
                    hintStyle: TextStyle(
                        color: Color(0xFFD32F2E), fontWeight: FontWeight.w400),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xFFD32F2E), width: 0.w)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 0.w)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    _postController.dispose();
    _localAddressController.dispose();
    super.dispose();
  }
}
