import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThelaRegi extends StatefulWidget {
  const ThelaRegi({super.key});

  @override
  State<ThelaRegi> createState() => _ThelaRegiState();
}

class _ThelaRegiState extends State<ThelaRegi> {
  final _formKey = GlobalKey<FormState>();

  // Location data
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

  // Form controllers
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final phoneController = TextEditingController();
  final nidController = TextEditingController();
  final postController = TextEditingController();
  final localAddressController = TextEditingController();
  final repNameController = TextEditingController();
  final repPhoneController = TextEditingController();

  String? selectedDivision;
  String? selectedDistrict;
  String? selectedThana;

  // Get available districts based on selected division
  List<String> get availableDistricts {
    if (selectedDivision == null) return [];
    return districts[selectedDivision] ?? [];
  }

  // Get available upazilas based on selected division and district
  List<String> get availableUpazilas {
    if (selectedDivision == null || selectedDistrict == null) return [];
    return thanas[selectedDivision]?[selectedDistrict] ?? [];
  }

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveToFirestore() async {
    try {
      // Generate the email based on the nid
      String email = "${nidController.text}@gmail.com";

      // Check if a document with the given email exists
      var existingDoc =
          await _firestore.collection('Thelasmia').doc(email).get();

      // If the document exists, show a message
      if (existingDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This email is already registered!')),
          );
        }
      } else {
        // If the document does not exist, add a new document
        await _firestore.collection('Thelasmia').doc(email).set({
          'name': nameController.text,
          'fatherName': fatherNameController.text,
          'motherName': motherNameController.text,
          'phone': phoneController.text,
          'nid': nidController.text,
          'division': selectedDivision,
          'district': selectedDistrict,
          'thana': selectedThana,
          'post': postController.text,
          'localAddress': localAddressController.text,
          'representativeName': repNameController.text,
          'representativePhone': repPhoneController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'approved': false,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          _clearForm();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _clearForm() {
    nameController.clear();
    fatherNameController.clear();
    motherNameController.clear();
    phoneController.clear();
    nidController.clear();
    postController.clear();
    localAddressController.clear();
    repNameController.clear();
    repPhoneController.clear();
    setState(() {
      selectedDivision = null;
      selectedDistrict = null;
      selectedThana = null;
    });
  }

  Future<void> showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Registration'),
          content: const Text('Do you want to submit this registration?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                saveToFirestore();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thelassemia registration",
            style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        backgroundColor: const Color(0xff008000),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.sp),
                _buildTextField(
                  controller: nameController,
                  hintText: "Name",
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter name' : null,
                ),
                SizedBox(height: 15.h),
                _buildTextField(
                  controller: fatherNameController,
                  hintText: "Father Name",
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter father\'s name'
                      : null,
                ),
                SizedBox(height: 15.h),
                _buildTextField(
                  controller: motherNameController,
                  hintText: "Mother Name",
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter mother\'s name'
                      : null,
                ),
                SizedBox(height: 15.h),
                _buildTextField(
                  controller: phoneController,
                  hintText: "Phone Number",
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter phone number'
                      : null,
                ),
                SizedBox(height: 15.h),
                _buildTextField(
                  controller: nidController,
                  hintText: "NID/Birth Certificate",
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter NID/Birth Certificate'
                      : null,
                ),
                SizedBox(height: 15.h),
                _buildDropdownField(
                  items: divisions,
                  hint: "Division",
                  value: selectedDivision,
                  onChanged: (value) {
                    setState(() {
                      selectedDivision = value;
                      selectedDistrict = null;
                      selectedThana = null;
                    });
                  },
                ),
                SizedBox(height: 15.h),
                _buildDropdownField(
                  items: availableDistricts,
                  hint: "District",
                  value: selectedDistrict,
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value;
                      selectedThana = null;
                    });
                  },
                ),
                SizedBox(height: 15.h),
                _buildDropdownField(
                  items: availableUpazilas,
                  hint: "Thana",
                  value: selectedThana,
                  onChanged: (value) {
                    setState(() {
                      selectedThana = value;
                    });
                  },
                ),
                SizedBox(height: 15.h),
                _buildTextField(
                  controller: postController,
                  hintText: "Post",
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter post' : null,
                ),
                SizedBox(height: 15.h),
                _buildTextField(
                  controller: localAddressController,
                  hintText: "Local Address",
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter local address'
                      : null,
                ),
                SizedBox(height: 15.h),
                _buildTextField(
                  controller: repNameController,
                  hintText: "Representative Name",
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter representative name'
                      : null,
                ),
                SizedBox(height: 15.h),
                _buildTextField(
                  controller: repPhoneController,
                  hintText: "Representative Phone Number",
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter representative phone number'
                      : null,
                ),
                SizedBox(height: 25.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showConfirmationDialog();
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xff008000)),
                        foregroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r))),
                        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(
                            horizontal: 60.w, vertical: 15.h))),
                    child: const Text("Submit"),
                  ),
                ),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: const Color(0xffD32F2F),
            width: 1.w,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
            color: Color(0xffD32F2F), fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: const Color(0xffD32F2F), width: 1.w)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: const Color(0xff008000), width: 1.w)),
      ),
    );
  }

  Widget _buildDropdownField({
    required List<String> items,
    required String hint,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: 21.5.h, horizontal: 15.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: const Color(0xffD32F2F),
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: const Color(0xffD32F2F),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide(color: const Color(0xff008000), width: 1.w)),
      ),
      isExpanded: true,
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(fontSize: 16.sp),
          ),
        );
      }).toList(),
      iconEnabledColor: const Color(0xffD32F2F),
      hint: Text(
        hint,
        style: const TextStyle(
          color: Color(0xffD32F2F),
          fontWeight: FontWeight.w400,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a $hint';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    phoneController.dispose();
    nidController.dispose();
    postController.dispose();
    localAddressController.dispose();
    repNameController.dispose();
    repPhoneController.dispose();
    super.dispose();
  }
}
