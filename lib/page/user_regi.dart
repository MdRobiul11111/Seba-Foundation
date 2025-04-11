import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:seba_app1/page/home_page.dart';

class UserRegi extends StatefulWidget {
  const UserRegi({super.key});

  @override
  State<UserRegi> createState() => _UserRegiState();
}

class _UserRegiState extends State<UserRegi> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _localAddressController = TextEditingController();

  String? _bloodGroup;
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  bool _isLoading = false;
  bool _donationComplete = false;
  bool _asABloodDonor = false;
  @override
  void initState() {
    super.initState();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      // Get the current user
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Get the email of the current user
        String email = currentUser.email!;
        fetchUserData(email);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> fetchUserData(String email) async {
    try {
      // Fetch the document for the given email
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(email).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Extract the phoneNumber field
        String phoneNumber = userDoc['phoneNumber'];

        // Set the value to the TextEditingController
        _phoneController.text = phoneNumber;
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  final List<String> blood = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', "AB+", "AB-"];
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
      'Bandarban': [
        'Ali Kadam',
        'Bandarban Sadar',
        'Lama',
        'Naikhongchhari',
        'Rowangchhari',
        'Ruma',
        'Thanchi'
      ],
      'Brahmanbaria': [
        'Akhaura',
        'Bancharampur',
        'Brahmanbaria Sadar',
        'Kasba',
        'Nabinagar',
        'Nasirnagar',
        'Sarail',
        'Ashuganj',
        'Bijoynagar'
      ],
      'Chandpur': [
        'Chandpur Sadar',
        'Faridganj',
        'Haimchar',
        'Hajiganj',
        'Kachua',
        'Matlab Dakshin',
        'Matlab Uttar',
        'Shahrasti'
      ],
      'Chittagong': [
        'Anwara',
        'Banshkhali',
        'Boalkhali',
        'Chandanaish',
        'Fatikchhari',
        'Hathazari',
        'Lohagara',
        'Mirsharai',
        'Patiya',
        'Rangunia',
        'Raozan',
        'Sandwip',
        'Satkania',
        'Sitakunda'
      ],
      'Comilla': [
        'Barura',
        'Brahmanpara',
        'Burichong',
        'Chandina',
        'Chauddagram',
        'Daudkandi',
        'Debidwar',
        'Homna',
        'Comilla Sadar',
        'Laksam',
        'Monohorgonj',
        'Meghna',
        'Muradnagar',
        'Nangalkot',
        'Titas'
      ],
      'Cox\'s Bazar': [
        'Chakaria',
        'Cox\'s Bazar Sadar',
        'Kutubdia',
        'Maheshkhali',
        'Ramu',
        'Teknaf',
        'Ukhia'
      ],
      'Feni': [
        'Chhagalnaiya',
        'Daganbhuiyan',
        'Feni Sadar',
        'Parshuram',
        'Sonagazi',
        'Fulgazi'
      ],
      'Khagrachari': [
        'Dighinala',
        'Khagrachhari',
        'Lakshmichhari',
        'Mahalchhari',
        'Manikchhari',
        'Matiranga',
        'Panchhari',
        'Ramgarh'
      ],
      'Lakshmipur': [
        'Lakshmipur Sadar',
        'Raipur',
        'Ramganj',
        'Ramgati',
        'Kamalnagar'
      ],
      'Noakhali': [
        'Begumganj',
        'Chatkhil',
        'Companiganj',
        'Hatiya',
        'Senbagh',
        'Noakhali Sadar',
        'Subarnachar',
        'Kabirhat'
      ],
      'Rangamati': [
        'Bagaichhari',
        'Barkal',
        'Kawkhali',
        'Belaichhari',
        'Kaptai',
        'Juraichhari',
        'Langadu',
        'Naniyachar',
        'Rajasthali',
        'Rangamati Sadar'
      ]
    },
    'Dhaka': {
      'Dhaka': ['Dhamrai', 'Dohar', 'Keraniganj', 'Nawabganj', 'Savar'],
      'Faridpur': [
        'Alfadanga',
        'Bhanga',
        'Boalmari',
        'Charbhadrasan',
        'Faridpur Sadar',
        'Madhukhali',
        'Nagarkanda',
        'Sadarpur',
        'Saltha'
      ],
      'Gazipur': [
        'Gazipur Sadar',
        'Kaliakair',
        'Kaliganj',
        'Kapasia',
        'Sreepur'
      ],
      'Gopalganj': [
        'Gopalganj Sadar',
        'Kashiani',
        'Kotalipara',
        'Muksudpur',
        'Tungipara'
      ],
      'Kishoreganj': [
        'Austagram',
        'Bajitpur',
        'Bhairab',
        'Hossainpur',
        'Itna',
        'Karimganj',
        'Katiadi',
        'Kishoreganj Sadar',
        'Kuliarchar',
        'Mithamain',
        'Nikli',
        'Pakundia',
        'Tarail'
      ],
      'Madaripur': ['Kalkini', 'Madaripur Sadar', 'Rajoir', 'Shibchar'],
      'Manikganj': [
        'Daulatpur',
        'Ghior',
        'Harirampur',
        'Manikganj Sadar',
        'Saturia',
        'Shibalaya',
        'Singair'
      ],
      'Munshiganj': [
        'Gazaria',
        'Lohajang',
        'Munshiganj Sadar',
        'Sirajdikhan',
        'Sreenagar',
        'Tongibari'
      ],
      'Narayanganj': [
        'Araihazar',
        'Bandar',
        'Narayanganj Sadar',
        'Rupganj',
        'Sonargaon'
      ],
      'Narsingdi': [
        'Belabo',
        'Monohardi',
        'Narsingdi Sadar',
        'Palash',
        'Raipura',
        'Shibpur'
      ],
      'Rajbari': ['Baliakandi', 'Goalandaghat', 'Pangsha', 'Rajbari Sadar'],
      'Shariatpur': [
        'Bhedarganj',
        'Damudya',
        'Gosairhat',
        'Naria',
        'Shariatpur Sadar',
        'Zajira'
      ],
      'Tangail': [
        'Basail',
        'Bhuapur',
        'Delduar',
        'Dhanbari',
        'Ghatail',
        'Gopalpur',
        'Kalihati',
        'Madhupur',
        'Mirzapur',
        'Nagarpur',
        'Sakhipur',
        'Tangail Sadar'
      ]
    },
    'Khulna': {
      'Bagerhat': [
        'Bagerhat Sadar',
        'Chitalmari',
        'Fakirhat',
        'Kachua',
        'Mollahat',
        'Mongla',
        'Morrelganj',
        'Rampal',
        'Sarankhola'
      ],
      'Chuadanga': ['Alamdanga', 'Chuadanga Sadar', 'Damurhuda', 'Jibannagar'],
      'Jessore': [
        'Abhaynagar',
        'Bagherpara',
        'Chaugachha',
        'Jhikargachha',
        'Keshabpur',
        'Jessore Sadar',
        'Manirampur',
        'Sharsha'
      ],
      'Jhenaidah': [
        'Harinakunda',
        'Jhenaidah Sadar',
        'Kaliganj',
        'Kotchandpur',
        'Maheshpur',
        'Shailkupa'
      ],
      'Khulna': [
        'Batiaghata',
        'Dacope',
        'Dumuria',
        'Dighalia',
        'Koyra',
        'Paikgachha',
        'Phultala',
        'Rupsa',
        'Terokhada'
      ],
      'Kushtia': [
        'Bheramara',
        'Daulatpur',
        'Khoksa',
        'Kumarkhali',
        'Kushtia Sadar',
        'Mirpur'
      ],
      'Magura': ['Magura Sadar', 'Mohammadpur', 'Shalikha', 'Sreepur'],
      'Meherpur': ['Gangni', 'Meherpur Sadar', 'Mujibnagar'],
      'Narail': ['Kalia', 'Lohagara', 'Narail Sadar'],
      'Satkhira': [
        'Assasuni',
        'Debhata',
        'Kalaroa',
        'Kaliganj',
        'Satkhira Sadar',
        'Shyamnagar',
        'Tala'
      ]
    },
    'Mymensingh': {
      'Jamalpur': [
        'Bakshiganj',
        'Dewanganj',
        'Islampur',
        'Jamalpur Sadar',
        'Madarganj',
        'Melandaha',
        'Sarishabari'
      ],
      'Mymensingh': [
        'Bhaluka',
        'Dhobaura',
        'Fulbaria',
        'Gaffargaon',
        'Gauripur',
        'Haluaghat',
        'Ishwarganj',
        'Mymensingh Sadar',
        'Muktagachha',
        'Nandail',
        'Phulpur',
        'Trishal'
      ],
      'Netrokona': [
        'Atpara',
        'Barhatta',
        'Durgapur',
        'Khaliajuri',
        'Kendua',
        'Madan',
        'Mohanganj',
        'Netrokona Sadar',
        'Purbadhala'
      ],
      'Sherpur': [
        'Jhenaigati',
        'Nakla',
        'Nalitabari',
        'Sherpur Sadar',
        'Sreebardi'
      ]
    },
    'Rajshahi': {
      'Bogra': [
        'Adamdighi',
        'Bogra Sadar',
        'Dhunat',
        'Dhupchanchia',
        'Gabtali',
        'Kahaloo',
        'Nandigram',
        'Sariakandi',
        'Sherpur',
        'Shibganj',
        'Sonatala'
      ],
      'Chapai Nawabganj': [
        'Bholahat',
        'Gomastapur',
        'Nachole',
        'Chapai Nawabganj Sadar',
        'Shibganj'
      ],
      'Joypurhat': [
        'Akkelpur',
        'Joypurhat Sadar',
        'Kalai',
        'Khetlal',
        'Panchbibi'
      ],
      'Naogaon': [
        'Atrai',
        'Badalgachhi',
        'Dhamoirhat',
        'Manda',
        'Mohadevpur',
        'Naogaon Sadar',
        'Niamatpur',
        'Patnitala',
        'Porsha',
        'Raninagar',
        'Sapahar'
      ],
      'Natore': [
        'Bagatipara',
        'Baraigram',
        'Gurudaspur',
        'Lalpur',
        'Natore Sadar',
        'Singra'
      ],
      'Pabna': [
        'Atgharia',
        'Bera',
        'Bhangura',
        'Chatmohar',
        'Faridpur',
        'Ishwardi',
        'Pabna Sadar',
        'Santhia',
        'Sujanagar'
      ],
      'Rajshahi': [
        'Bagha',
        'Bagmara',
        'Charghat',
        'Durgapur',
        'Godagari',
        'Mohonpur',
        'Paba',
        'Puthia',
        'Tanore'
      ],
      'Sirajganj': [
        'Belkuchi',
        'Chauhali',
        'Kamarkhanda',
        'Kazipur',
        'Raiganj',
        'Shahjadpur',
        'Sirajganj Sadar',
        'Tarash',
        'Ullahpara'
      ]
    },
    'Rangpur': {
      'Dinajpur': [
        'Birampur',
        'Birganj',
        'Biral',
        'Bochaganj',
        'Chirirbandar',
        'Phulbari',
        'Ghoraghat',
        'Hakimpur',
        'Kaharole',
        'Khansama',
        'Dinajpur Sadar',
        'Nawabganj',
        'Parbatipur'
      ],
      'Gaibandha': [
        'Fulchhari',
        'Gaibandha Sadar',
        'Gobindaganj',
        'Palashbari',
        'Sadullapur',
        'Saghata',
        'Sundarganj'
      ],
      'Kurigram': [
        'Bhurungamari',
        'Char Rajibpur',
        'Chilmari',
        'Phulbari',
        'Kurigram Sadar',
        'Nageshwari',
        'Rajarhat',
        'Raomari',
        'Ulipur'
      ],
      'Lalmonirhat': [
        'Aditmari',
        'Hatibandha',
        'Kaliganj',
        'Lalmonirhat Sadar',
        'Patgram'
      ],
      'Nilphamari': [
        'Dimla',
        'Domar',
        'Jaldhaka',
        'Kishoreganj',
        'Nilphamari Sadar',
        'Saidpur'
      ],
      'Panchagarh': [
        'Atwari',
        'Boda',
        'Debiganj',
        'Panchagarh Sadar',
        'Tetulia'
      ],
      'Rangpur': [
        'Badarganj',
        'Gangachara',
        'Kaunia',
        'Rangpur Sadar',
        'Mithapukur',
        'Pirgachha',
        'Pirganj',
        'Taraganj'
      ],
      'Thakurgaon': [
        'Baliadangi',
        'Haripur',
        'Pirganj',
        'Ranisankail',
        'Thakurgaon Sadar'
      ]
    },
    'Sylhet': {
      'Habiganj': [
        'Ajmiriganj',
        'Bahubal',
        'Baniyachong',
        'Chunarughat',
        'Habiganj Sadar',
        'Lakhai',
        'Madhabpur',
        'Nabiganj'
      ],
      'Moulvibazar': [
        'Barlekha',
        'Kamalganj',
        'Kulaura',
        'Moulvibazar Sadar',
        'Rajnagar',
        'Sreemangal',
        'Juri'
      ],
      'Sunamganj': [
        'Bishwamvarpur',
        'Chhatak',
        'Derai',
        'Dharampasha',
        'Dowarabazar',
        'Jagannathpur',
        'Jamalganj',
        'Sullah',
        'Sunamganj Sadar',
        'Tahirpur'
      ],
      'Sylhet': [
        'Balaganj',
        'Beanibazar',
        'Bishwanath',
        'Companiganj',
        'Fenchuganj',
        'Golapganj',
        'Gowainghat',
        'Jaintiapur',
        'Kanaighat',
        'Sylhet Sadar',
        'Zakiganj'
      ]
    }
  };

  // Function to show loading dialog
  void _showLoadingDialog() {
    setState(() {
      _isLoading = true;
    });
  }

  String getCurrentDate() {
    return DateFormat('dd/MM/yy').format(DateTime.now());
  }

  // Function to hide loading dialog
  void _hideLoadingDialog() {
    setState(() {
      _isLoading = false;
    });
  }

  // Function to validate and save data
  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      _showLoadingDialog();

      try {
        // Get current user
        User? currentUser = FirebaseAuth.instance.currentUser;
        DateTime now = DateTime.now();
        String formattedDate = DateFormat('yyyy-MM-dd').format(now);
        if (currentUser != null) {
          // Create user data map
          Map<String, dynamic> userData = {
            'name': _nameController.text.trim(),
            'bloodGroup': _bloodGroup,
            'phoneNumber': _phoneController.text.trim(),
            'age': _ageController.text.trim(),
            'division': selectedDivision,
            'district': selectedDistrict,
            'upazila': selectedUpazila,
            'localAddress': _localAddressController.text.trim(),
            'donationComplete': _donationComplete,
            'asABloodDonor': _asABloodDonor,
            'createdAt': FieldValue.serverTimestamp(),
            'profile_image': "No image",
            'current_date': formattedDate,
          };

          // Save to Firestore
          await FirebaseFirestore.instance
              .collection('UserRegress')
              .doc(currentUser.email)
              .set(userData);

          if (_asABloodDonor) {
            Map<String, dynamic> donationData = {
              'name': _nameController.text.trim(),
              'bloodGroup': _bloodGroup,
              'phoneNumber': _phoneController.text.trim(),
              'division': selectedDivision,
              'district': selectedDistrict,
              'upazila': selectedUpazila,
              'localAddress': _localAddressController.text.trim(),
              'donationComplete': _donationComplete,
              'asABloodDonor': _asABloodDonor,
              'createdAt': FieldValue.serverTimestamp(),
              'profile_image': "No image",
            };

            await FirebaseFirestore.instance
                .collection('Donation')
                .doc(currentUser.email)
                .set(donationData);
          }

          _hideLoadingDialog();

          // Navigate to HomePage
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // Use a default email if currentUser is null
          String userEmail = currentUser?.email ?? "abc@gmail.com";

          // Create user data map
          Map<String, dynamic> userData = {
            'name': _nameController.text.trim(),
            'bloodGroup': _bloodGroup,
            'phoneNumber': _phoneController.text.trim(),
            'age': _ageController.text.trim(),
            'division': selectedDivision,
            'district': selectedDistrict,
            'upazila': selectedUpazila,
            'localAddress': _localAddressController.text.trim(),
            'donationComplete': _donationComplete,
            'asABloodDonor': _asABloodDonor,
            'createdAt': FieldValue.serverTimestamp(),
          };

          // Save to Firestore
          await FirebaseFirestore.instance
              .collection('UserRegress')
              .doc(userEmail) // Use the userEmail as the document ID
              .set(userData);

          if (_asABloodDonor) {
            Map<String, dynamic> donationData = {
              'name': _nameController.text.trim(),
              'bloodGroup': _bloodGroup,
              'phoneNumber': _phoneController.text.trim(),
              'division': selectedDivision,
              'district': selectedDistrict,
              'upazila': selectedUpazila,
              'localAddress': _localAddressController.text.trim(),
              'donationComplete': _donationComplete,
              'asABloodDonor': _asABloodDonor,
              'createdAt': FieldValue.serverTimestamp(),
            };

            await FirebaseFirestore.instance
                .collection('Donation')
                .doc(userEmail)
                .set(donationData);
          }

          _hideLoadingDialog();
          // Navigate to HomePage
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          // _hideLoadingDialog();
          //_showErrorDialog('User not authenticated. Please login first.');
        }
      } catch (e) {
        _hideLoadingDialog();
        _showErrorDialog('Error saving data: ${e.toString()}');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("User Registration ",
                style: TextStyle(color: Colors.white, fontSize: 17.sp)),
            backgroundColor: Color(0xff008000),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0.w),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14.sp),
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
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w),
                          ),
                          hintText: "Name",
                          hintStyle: TextStyle(
                              color: Color(0xFFD32F2E),
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xFFD32F2E), width: 0.w)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xff008000), width: 0.w)),
                        )),
                    SizedBox(height: 14.h),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.5.h, horizontal: 15.w),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xff008000), width: 0.w)),
                      ),
                      isExpanded: true,
                      items: blood.map((blood) {
                        return DropdownMenuItem<String>(
                            value: blood,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(blood,
                                  style: TextStyle(fontSize: 15.sp)),
                            ));
                      }).toList(),
                      iconEnabledColor: Color(0xFFD32F2E),
                      hint: Text("Blood group",
                          style: TextStyle(
                              color: Color(0xFFD32F2E),
                              fontWeight: FontWeight.w300)),
                      onChanged: (value) {
                        setState(() {
                          _bloodGroup = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a blood group';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          // You can add more validation for phone number format if needed
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xFFD32F2E), width: 0.w)),
                          hintText: "Phone Number",
                          hintStyle: TextStyle(
                              color: Color(0xFFD32F2E),
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xFFD32F2E), width: 0.w)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xff008000), width: 0.w)),
                        )),
                    SizedBox(height: 14.h),
                    TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          // Validate that age is a number
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xFFD32F2E), width: 0.w)),
                          hintText: "Age",
                          hintStyle: TextStyle(
                              color: Color(0xFFD32F2E),
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xFFD32F2E), width: 0.w)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xff008000), width: 0.w)),
                        )),
                    SizedBox(height: 14.h),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.5.h, horizontal: 15.w),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xff008000), width: 0.w)),
                      ),
                      isExpanded: true,
                      items: divisions.map((division) {
                        return DropdownMenuItem<String>(
                            value: division,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(division),
                            ));
                      }).toList(),
                      iconEnabledColor: Color(0xFFD32F2E),
                      hint: Text("Division",
                          style: TextStyle(
                              color: Color(0xFFD32F2E),
                              fontWeight: FontWeight.w300)),
                      onChanged: (value) {
                        setState(() {
                          selectedDivision = value;
                          selectedDistrict = null;
                          selectedUpazila = null;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a division';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.5.h, horizontal: 15.w),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xff008000), width: 0.w)),
                      ),
                      isExpanded: true,
                      items: selectedDivision == null
                          ? []
                          : districts[selectedDivision]?.map((district) {
                                return DropdownMenuItem<String>(
                                    value: district,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(district),
                                    ));
                              }).toList() ??
                              [],
                      iconEnabledColor: Color(0xFFD32F2E),
                      hint: Text("District",
                          style: TextStyle(
                              color: Color(0xFFD32F2E),
                              fontWeight: FontWeight.w300)),
                      onChanged: (value) {
                        setState(() {
                          selectedDistrict = value;
                          selectedUpazila = null;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a district';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.5.h, horizontal: 15.w),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xFFD32F2E), width: 0.w)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(19.r),
                            borderSide: BorderSide(
                                color: Color(0xff008000), width: 0.w)),
                      ),
                      isExpanded: true,
                      items: selectedDistrict == null
                          ? []
                          : thanas[selectedDivision]?[selectedDistrict]
                                  ?.map((upazila) {
                                return DropdownMenuItem<String>(
                                    value: upazila,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(upazila),
                                    ));
                              }).toList() ??
                              [],
                      iconEnabledColor: Color(0xFFD32F2E),
                      hint: Text("Thana",
                          style: TextStyle(
                              color: Color(0xFFD32F2E),
                              fontWeight: FontWeight.w300)),
                      onChanged: (value) {
                        setState(() {
                          selectedUpazila = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an upazila';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14.h),
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
                              borderSide: BorderSide(
                                  color: Color(0xFFD32F2E), width: 0.w)),
                          hintText: "Local Address",
                          hintStyle: TextStyle(
                              color: Color(0xFFD32F2E),
                              fontWeight: FontWeight.w400),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xFFD32F2E), width: 0.w)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(19.r),
                              borderSide: BorderSide(
                                  color: Color(0xff008000), width: 0.w)),
                        )),
                    SizedBox(height: 14.h),
                    Theme(
                      data: Theme.of(context).copyWith(
                        checkboxTheme: CheckboxThemeData(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (states) {
                            if (states.contains(MaterialState.selected)) {
                              return Color(0xFFD32F2E); // Color when checked
                            }
                            return Colors.transparent; // Color when unchecked
                          }),
                          checkColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Checkmark color
                          side: BorderSide(
                            color: Color(
                                0xFFD32F2E), // Border color when unchecked
                            width: 2.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                4.0), // Optional: Rounded corners
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _asABloodDonor,
                                onChanged: (value) {
                                  setState(() {
                                    _asABloodDonor = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                "As a Blood Donor",
                                style: TextStyle(
                                  color: Color(0xFFD32F2E), // Text color
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed: _saveUserData,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 55.h),
                        backgroundColor: Color(0xff008000),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19.r)),
                      ),
                      child: Text("Register",
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white)),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Loading overlay
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xff008000),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _localAddressController.dispose();
    super.dispose();
  }
}
