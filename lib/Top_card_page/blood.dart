import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class Blood extends StatefulWidget {
  const Blood({super.key});

  @override
  State<Blood> createState() => _BloodState();
}

class _BloodState extends State<Blood> {
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

  // Variable to hold available districts based on selected division
  List<String> availableDistricts = [];
  // Variable to hold available upazilas based on selected district
  List<String> availableUpazilas = [];

  bool isLoading = false;
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredResults = [];

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    setState(() => isLoading = true);
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Donation').get();

      // Store all data
      allData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': data['name'] ?? 'N/A',
          'bloodGroup': data['bloodGroup'] ?? 'N/A',
          'phoneNumber': data['phoneNumber'] ?? 'N/A',
          'age': data['age']?.toString() ?? 'N/A',
          'localAddress': data['localAddress'] ?? 'N/A',
          'phoneNumber': data['phoneNumber']?.toString() ?? 'N/A',
          'division': data['division'] ?? 'N/A',
          'district': data['district'] ?? 'N/A',
          'thana': data['thana'] ?? 'N/A',
          'profile_image': data['profile_image'] ?? 'N/A',
          'current_date': data['current_date'] ?? 'N/A',
          'donationComplete': data['donationComplete'] ?? 'N/A',
        };
      }).toList();

      setState(() {
        filteredResults = allData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading data: $e');
    }
    print("JJJJJJ$allData");
  }

  void updateDistricts(String division) {
    if (districts.containsKey(division)) {
      setState(() {
        availableDistricts = districts[division]!;
        selectedDistrict = null;
        availableUpazilas = [];
        selectedThana = null;
      });
    }
    filterResults();
  }

  void updateUpazilas(String district) {
    if (selectedDivision != null &&
        thanas.containsKey(selectedDivision) &&
        thanas[selectedDivision]!.containsKey(district)) {
      setState(() {
        availableUpazilas = thanas[selectedDivision]![district]!;
        selectedThana = null;
      });
    }
    filterResults();
  }

  void filterResults() {
    setState(() {
      filteredResults = allData.where((item) {
        bool matchesBlood =
            selectedBlood == null || item['bloodGroup'] == selectedBlood;
        bool matchesDivision =
            selectedDivision == null || item['division'] == selectedDivision;
        bool matchesDistrict =
            selectedDistrict == null || item['district'] == selectedDistrict;
        bool matchesUpazila =
            selectedThana == null || item['thana'] == selectedThana;

        return matchesBlood &&
            matchesDivision &&
            matchesDistrict &&
            matchesUpazila;
      }).toList();
    });
  }

  static const platform = MethodChannel("com.yourapp/link_opener");

  Future<void> dialPhoneNumber(String phoneNumber) async {
    try {
      await platform.invokeMethod("dialNumber", phoneNumber);
    } catch (e) {
      print("Failed to open dial pad: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search blood here",
            style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        backgroundColor: Color(0xff008000),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.sp),
                  DropdownButtonFormField<String>(
                    value: selectedBlood,
                    decoration: getDropdownDecoration("Blood group"),
                    items: blood.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBlood = value;
                      });
                      filterResults();
                    },
                  ),
                  SizedBox(height: 15.h),
                  DropdownButtonFormField<String>(
                    value: selectedDivision,
                    decoration: getDropdownDecoration("Division"),
                    items: divisions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDivision = value;
                      });
                      if (value != null) {
                        updateDistricts(value);
                      }
                    },
                  ),
                  SizedBox(height: 15.h),
                  DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    decoration: getDropdownDecoration("District"),
                    items: availableDistricts.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: selectedDivision == null
                        ? null
                        : (value) {
                            setState(() {
                              selectedDistrict = value;
                            });
                            if (value != null) {
                              updateUpazilas(value);
                            }
                          },
                  ),
                  SizedBox(height: 15.h),
                  DropdownButtonFormField<String>(
                    value: selectedThana,
                    decoration: getDropdownDecoration("Thana"),
                    items: availableUpazilas.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: selectedDistrict == null
                        ? null
                        : (value) {
                            setState(() {
                              selectedThana = value;
                            });
                            filterResults();
                          },
                  ),
                  SizedBox(height: 20.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredResults.length,
                    itemBuilder: (context, index) {
                      final donor = filteredResults[index];

                      // Calculate days since donation
                      bool isAvailable = true;
                      int daysDifference = 0;
                      int daysToShow = 0;
                      if (donor['donationComplete'] == false) {
                        // If donation is not completed, donor is available with 0 days
                        isAvailable = true;
                        daysToShow = 0;
                      } else if (donor['current_date'] != "N/A") {
                        try {
                          // Parse the donation date
                          DateTime donationDate =
                              DateTime.parse(donor['current_date']);
                          DateTime now = DateTime.now();

                          // Calculate difference in days
                          daysDifference = now.difference(donationDate).inDays;

                          // Check if 120 days have passed
                          isAvailable = daysDifference >= 120;

                          // Set the days to display
                          daysToShow = isAvailable
                              ? daysDifference
                              : 120 - daysDifference;
                        } catch (e) {
                          print("Error parsing date: $e");
                          // Default to available if date parsing fails
                          isAvailable = true;
                        }
                      }

                      return InkWell(
                        onTap: () {
                          String phoneNumber = donor['phoneNumber']!;
                          if (phoneNumber.isNotEmpty) {
                            // dialPhoneNumber(phoneNumber);
                          } else {
                            print("Phone number is empty");
                          }
                          print("Card tapped");
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Card(
                          color: Color(0xffF1F1F1),
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    donor['profile_image'] == "No image"
                                        ? Image.asset(
                                            "images/logo.png",
                                            width: 80.w,
                                            height: 80.w,
                                          )
                                        : Image.network(
                                            donor['profile_image']!,
                                            width: 80.w,
                                            height: 80.w,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                  "images/logo.png",
                                                  width: 80.w,
                                                  height: 80.w);
                                            },
                                          ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: isAvailable
                                            ? Color(0xff008000)
                                            : Color(0xffD32F2F),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w),
                                      ),
                                      child: Text(isAvailable
                                          ? "Available Now"
                                          : "Not Available"),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_outlined,
                                            color: isAvailable
                                                ? Color(0xff008000)
                                                : Color(0xffD32F2F)),
                                        Text(
                                          donor['current_date'] == "N/A"
                                              ? 'No record'
                                              : '${daysToShow} days',
                                          style: TextStyle(
                                              color: isAvailable
                                                  ? Color(0xff008000)
                                                  : Color(0xffD32F2F),
                                              fontSize: 15.sp),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                buildInfoRow("Name:", donor['name']!),
                                buildInfoRow(
                                    "Blood Group:", donor['bloodGroup']!),
                                buildInfoRow11("Number:", donor['phoneNumber']!,
                                    onTap: () {
                                  String phoneNumber = donor['phoneNumber']!;
                                  if (phoneNumber.isNotEmpty) {
                                    dialPhoneNumber(phoneNumber);
                                  } else {
                                    print("Phone number is empty");
                                  }
                                }),
                                buildInfoRow("Age:", donor['age']!),
                                buildInfoRow(
                                    "Local Address:", donor['localAddress']!),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff008000)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration getDropdownDecoration(String hint) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 18.5.h, horizontal: 15.w),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
        borderSide: BorderSide(color: Color(0xffD32F2F), width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
        borderSide: BorderSide(color: Color(0xffD32F2F), width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.r),
        borderSide: BorderSide(color: Color(0xff008000), width: 1.w),
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: Color(0xffD32F2F),
        fontWeight: FontWeight.w400,
      ),
    );
  }
// Add this modified buildInfoRow method to the _BloodState class:

  Widget buildInfoRow(String label, String value) {
    // Special handling for the phone number row
    if (label == "Number:") {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            Text(label),
            Spacer(),
            Text(value),
            SizedBox(width: 8.w),
            Icon(
              Icons.call,
              color: Color(0xff008000),
              size: 20.sp,
            ),
          ],
        ),
      );
    }

    // Default row formatting for other info types
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Text(label),
          Spacer(),
          Text(value),
        ],
      ),
    );
  }

  Widget buildInfoRow11(String label, String value, {VoidCallback? onTap}) {
    // Special handling for the phone number row
    if (label == "Number:") {
      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            Text(label),
            Spacer(),
            GestureDetector(
              onTap: onTap, // Number click action
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black, // Indicate it's clickable
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Lottie.asset("images/call.json", width: 40.w, height: 40.w)
          ],
        ),
      );
    }

    // Default row formatting for other info types
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Text(label),
          Spacer(),
          Text(value),
        ],
      ),
    );
  }
}
