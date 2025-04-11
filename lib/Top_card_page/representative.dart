import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seba_app1/page/RegistrationPage.dart';

class Representative extends StatefulWidget {
  const Representative({super.key});

  @override
  State<Representative> createState() => _RepresentativeState();
}

class _RepresentativeState extends State<Representative> {
  final _formKey = GlobalKey<FormState>();
  final List<String> representativeCategories = ['Institutional', 'Regional'];
  String? selectedCategory;
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedThana;
  String? selectedUnion;

  // Controllers for text fields
  final TextEditingController instituteName = TextEditingController();
  final TextEditingController representativeCodeController =
      TextEditingController();
  final TextEditingController localAddressController = TextEditingController();
  final TextEditingController unionNameController = TextEditingController();

  // Loading state
  bool isLoading = false;
  String? errorMessage;

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

  // Function to check if representative code exists
  Future<bool> checkRepresentativeCodeExists(String code) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('Representative')
          .doc(code)
          .get();

      return docSnapshot.exists;
    } catch (e) {
      setState(() {
        errorMessage = "Error checking code: ${e.toString()}";
      });
      return false;
    }
  }

  // Function to handle form submission
  Future<void> submitForm() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      try {
        // Check if the representative code exists
        bool codeExists = await checkRepresentativeCodeExists(
            representativeCodeController.text);

        if (codeExists) {
          setState(() {
            errorMessage = "Representative code already exists!";
            isLoading = false;
          });

          // Show error dialog
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegistrationPage()));
        } else {
          setState(() {
            isLoading = false;
          });
          // Code doesn't exist, navigate to registration page
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Representative code do not  exists. Please use a different code."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        setState(() {
          errorMessage = "Error: Do not get code";
          isLoading = false;
          setState(() {
            isLoading = false;
          });
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Representative registration ",
            style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        backgroundColor: Color(0xff008000),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
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
                // Representative Category Dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 21.5.h, horizontal: 15.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide:
                          BorderSide(color: Color(0xffD32F2F), width: 1.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide:
                          BorderSide(color: Color(0xffD32F2F), width: 1.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide:
                          BorderSide(color: Color(0xff008000), width: 1.w),
                    ),
                  ),
                  isExpanded: true,
                  items: representativeCategories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text(category, style: TextStyle(fontSize: 16.sp)),
                      ),
                    );
                  }).toList(),
                  iconEnabledColor: Color(0xffD32F2F),
                  hint: Text("Representative Category",
                      style: TextStyle(
                          color: Color(0xffD32F2F),
                          fontWeight: FontWeight.w400)),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      // Reset other selections when category changes
                      selectedDivision = null;
                      selectedDistrict = null;
                      selectedThana = null;
                      selectedUnion = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a representative category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.sp),

                // Institutional Category Fields
                if (selectedCategory == 'Institutional') ...[
                  Text("Institutional",
                      style: TextStyle(
                          color: Color(0xffD32F2F),
                          fontWeight: FontWeight.w400,
                          fontSize: 19.sp)),
                  SizedBox(height: 5.sp),

                  // Institute Selection Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                    ),
                    isExpanded: true,
                    items: districts.keys.map((division) {
                      return DropdownMenuItem<String>(
                        value: division,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text(division, style: TextStyle(fontSize: 16.sp)),
                        ),
                      );
                    }).toList(),
                    iconEnabledColor: Color(0xffD32F2F),
                    hint: Text("Select Institute",
                        style: TextStyle(
                            color: Color(0xffD32F2F),
                            fontWeight: FontWeight.w400)),
                    onChanged: (value) {
                      setState(() {
                        selectedDivision = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an institute';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.sp),

                  // Institute Name Field
                  TextFormField(
                    controller: instituteName,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                      hintText: "Institute Name",
                      hintStyle: TextStyle(
                          color: Color(0xffD32F2F),
                          fontWeight: FontWeight.w400),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter institute name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Representative Code Field
                  TextFormField(
                    controller: representativeCodeController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                      hintText: "Representative Code",
                      hintStyle: TextStyle(
                          color: Color(0xffD32F2F),
                          fontWeight: FontWeight.w400),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter representative code';
                      }
                      return null;
                    },
                  ),
                ]

                // Regional Category Fields
                else if (selectedCategory == 'Regional') ...[
                  Text("Regional",
                      style: TextStyle(
                          color: Color(0xffD32F2F),
                          fontWeight: FontWeight.w400,
                          fontSize: 19.sp)),
                  SizedBox(height: 5.sp),

                  // Division Selection Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                    ),
                    isExpanded: true,
                    items: districts.keys.map((division) {
                      return DropdownMenuItem<String>(
                        value: division,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text(division, style: TextStyle(fontSize: 16.sp)),
                        ),
                      );
                    }).toList(),
                    iconEnabledColor: Color(0xffD32F2F),
                    hint: Text("Select Division",
                        style: TextStyle(
                            color: Color(0xffD32F2F),
                            fontWeight: FontWeight.w400)),
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
                  ),
                  SizedBox(height: 15.sp),

                  // District Selection Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                    ),
                    isExpanded: true,
                    items: selectedDivision != null
                        ? districts[selectedDivision]!.map((district) {
                            return DropdownMenuItem<String>(
                              value: district,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(district,
                                    style: TextStyle(fontSize: 16.sp)),
                              ),
                            );
                          }).toList()
                        : [],
                    iconEnabledColor: Color(0xffD32F2F),
                    hint: Text("Select District",
                        style: TextStyle(
                            color: Color(0xffD32F2F),
                            fontWeight: FontWeight.w400)),
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
                  ),
                  SizedBox(height: 15.sp),

                  // Upazila Selection Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                    ),
                    isExpanded: true,
                    items: selectedDistrict != null &&
                            selectedDivision != null &&
                            thanas[selectedDivision]?[selectedDistrict] != null
                        ? thanas[selectedDivision]![selectedDistrict]!
                            .map((thana) {
                            return DropdownMenuItem<String>(
                              value: thana,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(thana,
                                    style: TextStyle(fontSize: 16.sp)),
                              ),
                            );
                          }).toList()
                        : [],
                    iconEnabledColor: Color(0xffD32F2F),
                    hint: Text("Select Thana",
                        style: TextStyle(
                            color: Color(0xffD32F2F),
                            fontWeight: FontWeight.w400)),
                    onChanged: (value) {
                      setState(() {
                        selectedThana = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an thana';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.sp),

                  // Union Name Field
                  TextFormField(
                    controller: unionNameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                      hintText: "Union/city Corporation name",
                      hintStyle: TextStyle(
                          color: Color(0xffD32F2F),
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedUnion = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a union name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.sp),

                  // Local Address Field
                  TextFormField(
                    controller: localAddressController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                      hintText: "Local Address",
                      hintStyle: TextStyle(
                          color: Color(0xffD32F2F),
                          fontWeight: FontWeight.w400),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter local address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.sp),

                  // Representative Code Field
                  TextFormField(
                    controller: representativeCodeController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 21.5.h, horizontal: 15.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xffD32F2F), width: 1.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide:
                            BorderSide(color: Color(0xff008000), width: 1.w),
                      ),
                      hintText: "Representative Code",
                      hintStyle: TextStyle(
                          color: Color(0xffD32F2F),
                          fontWeight: FontWeight.w400),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter representative code';
                      }
                      return null;
                    },
                  ),
                ],

                // Show error message if exists
                if (errorMessage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),

                SizedBox(height: 25.h),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submitForm,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Submit"),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xff008000)),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      )),
                      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                          horizontal: 60.w, vertical: 15.h)),
                    ),
                  ),
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
    // Dispose controllers to prevent memory leaks
    instituteName.dispose();
    representativeCodeController.dispose();
    localAddressController.dispose();
    unionNameController.dispose();
    super.dispose();
  }
}
