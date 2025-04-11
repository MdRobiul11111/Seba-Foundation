import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seba_app1/page/home_page.dart';

class RegiAmbulance extends StatefulWidget {
  const RegiAmbulance({super.key});

  @override
  State<RegiAmbulance> createState() => _RegiAmbulanceState();
}

class _RegiAmbulanceState extends State<RegiAmbulance> {
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

  final Map<String, Map<String, List<String>>> Thanas = {
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedThana;

  List<String> get availableDistricts {
    return _selectedDivision != null ? districts[_selectedDivision]! : [];
  }

  List<String> get availableThanas {
    if (_selectedDivision != null && _selectedDistrict != null) {
      return Thanas[_selectedDivision]?[_selectedDistrict] ?? [];
    }
    return [];
  }

  void _onDivisionChanged(String? value) {
    setState(() {
      _selectedDivision = value;
      _selectedDistrict = null;
      _selectedThana = null;
    });
  }

  void _onDistrictChanged(String? value) {
    setState(() {
      _selectedDistrict = value;
      _selectedThana = null;
    });
  }

  void _storeData() async {
    // Get the values from the text controllers
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String license = _licenseController.text.trim();
    String vehicle = _vehicleController.text.trim();
    String address = _addressController.text.trim();

    // Check if all fields are filled
    if (name.isEmpty ||
        phone.isEmpty ||
        license.isEmpty ||
        vehicle.isEmpty ||
        address.isEmpty ||
        _selectedDivision == null ||
        _selectedDistrict == null ||
        _selectedThana == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // Create a reference to the document in Firestore
    final docRef = FirebaseFirestore.instance
        .collection('AmbulanceDatabase_temp')
        .doc('$license@gmail.com');

    // Check if the document already exists
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Document already exists, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("An ambulance with this license number already exists")),
      );
    } else {
      // Document does not exist, store the information
      await docRef.set({
        'name': name,
        'phone': phone,
        'license': license,
        'vehicle': vehicle,
        'address': address,
        'division': _selectedDivision,
        'district': _selectedDistrict,
        'thana': _selectedThana,
        'timestamp': FieldValue.serverTimestamp(), // Optional: Add a timestamp
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ambulance registered successfully")),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
      // Clear the form fields
      _nameController.clear();
      _phoneController.clear();
      _licenseController.clear();
      _vehicleController.clear();
      _addressController.clear();
      setState(() {
        _selectedDivision = null;
        _selectedDistrict = null;
        _selectedThana = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTER AMBULANCE",
            style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        backgroundColor: const Color(0xff008000),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.sp),
              Text("Register Ambulance",
                  style: TextStyle(
                      color: const Color(0xffD32F2F),
                      fontWeight: FontWeight.bold,
                      fontSize: 19.sp)),
              SizedBox(height: 15.sp),
              _buildTextField(_nameController, "Name"),
              SizedBox(height: 15.h),
              _buildTextField(_phoneController, "Phone Number"),
              SizedBox(height: 15.h),
              _buildTextField(_licenseController, "Driving License Number"),
              SizedBox(height: 15.h),
              _buildTextField(
                  _vehicleController, "Vehicle Registration Number"),
              SizedBox(height: 15.h),
              _buildDropdown(
                "Division",
                _selectedDivision,
                divisions,
                _onDivisionChanged,
              ),
              SizedBox(height: 15.h),
              _buildDropdown(
                "District",
                _selectedDistrict,
                availableDistricts,
                _onDistrictChanged,
              ),
              SizedBox(height: 15.h),
              _buildDropdown(
                "Thana",
                _selectedThana,
                availableThanas,
                (value) {
                  setState(() {
                    _selectedThana = value;
                  });
                },
              ),
              SizedBox(height: 15.h),
              _buildTextField(_addressController, "Local Address"),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: _storeData,
                  style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Color(0xff008000)),
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    )),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 60.w, vertical: 15.h)),
                  ),
                  child: const Text("Submit"),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: const Color(0xffD32F2F), width: 1.w),
        ),
        hintText: hint,
        hintStyle: const TextStyle(
            color: Color(0xffD32F2F), fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: const Color(0xffD32F2F), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: const Color(0xff008000), width: 1.w),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.symmetric(vertical: 21.5.h, horizontal: 15.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: const Color(0xffD32F2F), width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: const Color(0xffD32F2F), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(color: const Color(0xff008000), width: 1.w),
        ),
      ),
      isExpanded: true,
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(item, style: TextStyle(fontSize: 16.sp)),
          ),
        );
      }).toList(),
      iconEnabledColor: const Color(0xffD32F2F),
      hint: Text(hint,
          style: const TextStyle(
              color: Color(0xffD32F2F), fontWeight: FontWeight.w400)),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an option';
        }
        return null;
      },
    );
  }
}
