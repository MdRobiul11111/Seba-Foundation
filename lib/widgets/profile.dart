import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool value = false;
  bool value1 = false;
  bool isDataLoaded = false; // Flag to track if data is loaded

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController localAddressController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Dropdown data
  final List<String> blood = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', "AB+", "AB-"];
  String? selectedBlood;
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedThana;

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
        'Manikganj Sadar',
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

  @override
  void initState() {
    super.initState();

    /// _fetchData(); // Fetch data when the widget is initialized
    readalldata();
    _loadUserImage();
  }

  Map<String, dynamic>? allData;

  String getCurrentDate() {
    return DateFormat('dd/MM/yy').format(DateTime.now());
  }

  _submitForm(BuildContext context) async {
    // Check if all required fields are filled

    // Show confirmation dialog
    bool confirmUpload = await _showConfirmationDialog();
    if (!confirmUpload) return; // If user selects "No", stop execution

    // Show progress dialog
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
    DateTime now = DateTime.now();

    String formattedDate = value != allData?['donationComplete'] ||
            allData?['donationComplete'] == null
        ? DateFormat('yyyy-MM-dd').format(now)
        : allData?['current_date'];
    Logger().f(formattedDate);
    // Create a model map
    Map<String, dynamic> donationData = {
      'name': nameController.text,
      'bloodGroup': selectedBlood,
      'current_date': formattedDate,
      'phoneNumber': numberController.text,
      'division': selectedDivision,
      'district': selectedDistrict,
      'upazila': selectedThana,
      'localAddress': localAddressController.text,
      'donationComplete': value,
      'asABloodDonor': value1,
      'age': ageController.text,
      'profile_image': _imagePath?.isNotEmpty == true
          ? _imageUrl
          : (_imageUrl?.isNotEmpty == true ? _imageUrl : "No image"),
    };

    try {
      // Get current user's email
      final userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        throw Exception('No user logged in');
      }

      // Upload data to Firestore using email as document ID
      await FirebaseFirestore.instance
          .collection('UserRegress')
          .doc(userEmail)
          .set(donationData);
      if (!value1) {
        DocumentSnapshot donationDoc = await FirebaseFirestore.instance
            .collection('Donation')
            .doc(userEmail)
            .get();

        if (donationDoc.exists) {
          await FirebaseFirestore.instance
              .collection('Donation')
              .doc(userEmail)
              .delete();
          Logger().f("Existing data in 'Donation' deleted.");
        }
      } else {
        await FirebaseFirestore.instance
            .collection('Donation')
            .doc(userEmail)
            .set(donationData);
      }
      // Dismiss progress dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data uploaded successfully')),
        );
      }
    } catch (e) {
      // Dismiss progress dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload data: $e')),
        );
      }
    }
  }

// Function to show a confirmation dialog
  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Upload'),
              content: const Text('Are you sure you want to upload this data?'),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(false), // User clicked No
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(true), // User clicked Yes
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false; // If user dismisses dialog, return false
  }

  File? imageFile;
  bool isUploading = false;
  Future<void> readalldata() async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        throw Exception('No user logged in');
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('UserRegress')
          .doc(userEmail)
          .get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          allData = data;
          nameController.text = data['name'] ?? '';
          selectedBlood = data['bloodGroup'] ?? '';
          numberController.text = data['phoneNumber'] ?? '';
          selectedDivision = data['division'] ?? '';
          selectedDistrict = data['district'] ?? '';
          selectedThana = data['upazila'] ?? '';
          ageController.text = data['age'] ?? '';
          localAddressController.text = data['localAddress'] ?? '';
          value = data['donationComplete'] ?? false;
          value1 = data['asABloodDonor'] ?? false;
        });
      }
    } catch (e) {
      Logger().e("Error fetching data: $e");
    }
  }

  // int _currentBannerPage = 0;
  String? _imagePath;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;

  // Show loading dialog while uploading
  Future<void> _loadUserImage() async {
    try {
      String? userEmail = _auth.currentUser?.email;

      if (userEmail != null) {
        // Check if user image document exists
        DocumentSnapshot doc =
            await _firestore.collection('user_images').doc(userEmail).get();

        if (doc.exists && doc.data() != null) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // If imageUrl exists, set it to state
          if (data.containsKey('imageUrl') && data['imageUrl'] != null) {
            setState(() {
              _imageUrl = data['imageUrl'];
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(
                color: Color(0xff008000),
              ),
              SizedBox(width: 20.w),
              Text("Uploading image..."),
            ],
          ),
        );
      },
    );
  }

  void showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile image updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickImageAndUpload(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        if (context.mounted) {
          showLoadingDialog(context);
        }

        setState(() {
          _imagePath = pickedFile.path;
        });

        String? userEmail = _auth.currentUser?.email;

        if (userEmail != null) {
          String fileName =
              'profile_images/${userEmail}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          Reference storageRef = _storage.ref().child(fileName);

          await storageRef.putFile(File(pickedFile.path));

          String downloadURL = await storageRef.getDownloadURL();

          await _firestore.collection('user_images').doc(userEmail).set({
            'imageUrl': downloadURL,
            'updatedAt': FieldValue.serverTimestamp(),
            'userEmail': userEmail,
          });

          setState(() {
            _imageUrl = downloadURL;
          });

          if (context.mounted) {
            Navigator.pop(context);

            showSuccessMessage(context);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }

      debugPrint('Error picking/uploading image: $e');
    }
  }

  bool _isEditable = false;
  // Get current user email
  String? get currentUserEmail => FirebaseAuth.instance.currentUser?.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 10.0.w),
          child: Text("PROFILE",
              style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        ),
        backgroundColor: const Color(0xff008000),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0.w),
            child: IconButton(
              onPressed: _toggleEditMode,
              icon: ImageIcon(
                const AssetImage("images/editic.png"),
                color: Colors.white,
                size: 23.r,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header (remains the same as in previous code)
            SizedBox(
              width: double.infinity,
              height: 265.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 200.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xffd33333),
                          image: DecorationImage(
                            image: const AssetImage("images/cover.jpg"),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                        width: double.infinity,
                      ),
                    ],
                  ),
                  Positioned(
                    top: 125.h,
                    child: GestureDetector(
                      onTap: _isEditable
                          ? () => _pickImageAndUpload(context)
                          : null,
                      child: Stack(
                        children: [
                          _isLoading
                              ? CircleAvatar(
                                  radius: 60.r,
                                  child: CircularProgressIndicator(
                                    color: Color(0xff008000),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 60.r,
                                  backgroundImage: _imagePath != null
                                      ? Image.file(File(_imagePath!)).image
                                      : _imageUrl != null
                                          ? NetworkImage(_imageUrl!)
                                          : const AssetImage("images/logo.png"),
                                ),

                          // Camera icon overlay
                          if (_isEditable)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff008000),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                padding: EdgeInsets.all(8.r),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Name Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                controller: nameController,
                enabled: _isEditable,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2.w, color: Color(0xff008000)),
                  ),
                  labelText: "Name",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  labelStyle:
                      TextStyle(color: Color(0xff008000), fontSize: 18.sp),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Phone Number Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                controller: numberController,
                enabled: _isEditable,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2.w, color: Color(0xff008000)),
                  ),
                  labelText: "Phone Number",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  labelStyle:
                      TextStyle(color: Color(0xff008000), fontSize: 18.sp),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            //age
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                controller: ageController,
                enabled: _isEditable,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2.w, color: Color(0xff008000)),
                  ),
                  labelText: "Age",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  labelStyle:
                      TextStyle(color: Color(0xff008000), fontSize: 18.sp),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Blood Group Dropdown
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: DropdownButtonFormField<String>(
                value: selectedBlood,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2.w, color: Color(0xff008000)),
                  ),
                  labelText: "Blood Group",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  labelStyle:
                      TextStyle(color: Color(0xff008000), fontSize: 18.sp),
                ),
                items: blood.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _isEditable
                    ? (String? newValue) {
                        setState(() {
                          selectedBlood = newValue;
                        });
                      }
                    : null,
              ),
            ),
            SizedBox(height: 16.h),

            // Division Dropdown
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: DropdownButtonFormField<String>(
                value: selectedDivision,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2.w, color: Color(0xff008000)),
                  ),
                  labelText: "Division",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  labelStyle:
                      TextStyle(color: Color(0xff008000), fontSize: 18.sp),
                ),
                items: divisions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: _isEditable
                    ? (String? newValue) {
                        setState(() {
                          selectedDivision = newValue;
                          selectedDistrict = null;
                          selectedThana = null;
                        });
                      }
                    : null,
              ),
            ),
            SizedBox(height: 16.h),

            // District Dropdown (conditionally rendered)
            if (selectedDivision != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                child: DropdownButtonFormField<String>(
                  value: selectedDistrict,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    labelText: "District",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp),
                  ),
                  items: districts[selectedDivision]!.map((String district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
                  onChanged: _isEditable
                      ? (String? newValue) {
                          setState(() {
                            selectedDistrict = newValue;
                            selectedThana = null;
                          });
                        }
                      : null,
                ),
              ),
            SizedBox(height: 16.h),

            // Upazila Dropdown (conditionally rendered)
            if (selectedDivision != null && selectedDistrict != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: DropdownButtonFormField<String>(
                  value: selectedThana,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.w, color: Color(0xff008000)),
                    ),
                    labelText: "Thana",
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    labelStyle:
                        TextStyle(color: Color(0xff008000), fontSize: 18.sp),
                  ),
                  items: thanas[selectedDivision]?[selectedDistrict]
                      ?.map((String thana) {
                    return DropdownMenuItem<String>(
                      value: thana,
                      child: Text(thana),
                    );
                  }).toList(),
                  onChanged: _isEditable
                      ? (String? newValue) {
                          setState(() {
                            selectedThana = newValue;
                          });
                        }
                      : null,
                ),
              ),
            SizedBox(height: 16.h),

            // Local Address TextField
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: TextField(
                controller: localAddressController,
                enabled: _isEditable,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(width: 2.w, color: Color(0xff008000)),
                  ),
                  labelText: "Local Address",
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  labelStyle:
                      TextStyle(color: Color(0xff008000), fontSize: 18.sp),
                ),
              ),
            ),

            // Donation Complete Checkbox
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Text("Donation Complete",
                      style:
                          TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
                  Spacer(),
                  Checkbox(
                    activeColor: Color(0xff008000),
                    side: BorderSide(color: Color(0xff008000)),
                    checkColor: Colors.white,
                    value: value,
                    onChanged: _isEditable
                        ? (bool? newValue) {
                            setState(() {
                              value = newValue!;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // As a Blood Donor Checkbox
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Text("As a Blood Donor",
                      style:
                          TextStyle(color: Color(0xff008000), fontSize: 18.sp)),
                  Spacer(),
                  Checkbox(
                    activeColor: Color(0xff008000),
                    side: BorderSide(color: Color(0xff008000)),
                    checkColor: Colors.white,
                    value: value1,
                    onChanged: _isEditable
                        ? (bool? newValue) {
                            setState(() {
                              value1 = newValue!;
                            });
                          }
                        : null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),

            // Save Button (only visible in edit mode)
            if (_isEditable)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: ElevatedButton(
                  onPressed: () {
                    _saveChanges(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff008000),
                    minimumSize: Size(double.infinity, 50.h),
                  ),
                  child: Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

// Add these methods to your State class

  void _toggleEditMode() {
    setState(() {
      _isEditable = !_isEditable;
    });
  }

  _saveChanges(BuildContext context) async {
    await _submitForm(context);
    // Implement your save logic here
    // For example, save to Firestore, update local state, etc.
    setState(() {
      _isEditable = false;
    });

    // Show a success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Color(0xff008000),
        ),
      );
    }
  }
}
