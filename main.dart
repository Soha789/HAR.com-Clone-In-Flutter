import 'package:flutter/material.dart';

void main() {
  runApp(const RealEstateApp());
}

class RealEstateApp extends StatelessWidget {
  const RealEstateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Estate App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

/// ---------------- LOGIN PAGE ----------------

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to browse and list properties.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // TODO: Replace with real Firebase Auth login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );
                  },
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement sign up flow
                  },
                  child: const Text("Don't have an account? Sign up"),
                ),
              ),
              const Spacer(),
              const Center(
                child: Text(
                  'Demo UI – Firebase integration pending',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- HOME (BOTTOM NAV) ----------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ExplorePage(),
    MyListingsPage(),
    ChatsPage(),
    ProfilePage(),
  ];

  final List<String> _titles = const [
    'Explore',
    'My Listings',
    'Chats',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              onPressed: () {
                // TODO: Implement notifications (e.g., FCM)
              },
              icon: const Icon(Icons.notifications_outlined),
            ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'My Listings',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateListingPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('New Listing'),
            )
          : null,
    );
  }
}

/// ---------------- DUMMY DATA MODEL ----------------

class Property {
  final String title;
  final String location;
  final int price;
  final String type; // House, Apartment, etc.
  final int beds;
  final int baths;
  final bool forRent;

  Property({
    required this.title,
    required this.location,
    required this.price,
    required this.type,
    required this.beds,
    required this.baths,
    required this.forRent,
  });
}

final List<Property> demoProperties = [
  Property(
    title: 'Modern 3BR Apartment',
    location: 'Downtown City Center',
    price: 250000,
    type: 'Apartment',
    beds: 3,
    baths: 2,
    forRent: false,
  ),
  Property(
    title: 'Cozy 2BR House',
    location: 'Lakeside Community',
    price: 1500,
    type: 'House',
    beds: 2,
    baths: 1,
    forRent: true,
  ),
  Property(
    title: 'Luxury Villa with Pool',
    location: 'Hillside District',
    price: 980000,
    type: 'Villa',
    beds: 5,
    baths: 4,
    forRent: false,
  ),
];

/// ---------------- EXPLORE PAGE ----------------

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _selectedDealType = 'All'; // All, Buy, Rent
  String _selectedPropertyType = 'All'; // All, House, Apartment, Villa
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = demoProperties.where((p) {
      if (_selectedDealType == 'Buy' && p.forRent) return false;
      if (_selectedDealType == 'Rent' && !p.forRent) return false;
      if (_selectedPropertyType != 'All' && p.type != _selectedPropertyType) {
        return false;
      }
      if (_searchQuery.isNotEmpty &&
          !('${p.title} ${p.location}'.toLowerCase())
              .contains(_searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search by city, area, or keyword',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              FilterChip(
                label: const Text('All'),
                selected: _selectedDealType == 'All',
                onSelected: (_) {
                  setState(() => _selectedDealType = 'All');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Buy'),
                selected: _selectedDealType == 'Buy',
                onSelected: (_) {
                  setState(() => _selectedDealType = 'Buy');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Rent'),
                selected: _selectedDealType == 'Rent',
                onSelected: (_) {
                  setState(() => _selectedDealType = 'Rent');
                },
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('House'),
                selected: _selectedPropertyType == 'House',
                onSelected: (_) {
                  setState(() => _selectedPropertyType = 'House');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Apartment'),
                selected: _selectedPropertyType == 'Apartment',
                onSelected: (_) {
                  setState(() => _selectedPropertyType = 'Apartment');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Villa'),
                selected: _selectedPropertyType == 'Villa',
                onSelected: (_) {
                  setState(() => _selectedPropertyType = 'Villa');
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('All Types'),
                selected: _selectedPropertyType == 'All',
                onSelected: (_) {
                  setState(() => _selectedPropertyType = 'All');
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final property = filtered[index];
              return PropertyCard(property: property);
            },
          ),
        ),
      ],
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PropertyDetailPage(property: property),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dummy header image placeholder
            Container(
              height: 160,
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(
                  Icons.home_work_outlined,
                  size: 48,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.location,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.bed_outlined,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text('${property.beds}'),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.bathtub_outlined,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text('${property.baths}'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: property.forRent
                              ? Colors.green.shade50
                              : Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          property.forRent ? 'For Rent' : 'For Sale',
                          style: TextStyle(
                            fontSize: 12,
                            color: property.forRent
                                ? Colors.green.shade700
                                : Colors.indigo.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.forRent
                        ? '\$${property.price} / month'
                        : '\$${property.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// ---------------- PROPERTY DETAIL + CHAT BUTTON ----------------

class PropertyDetailPage extends StatelessWidget {
  final Property property;

  const PropertyDetailPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(
                Icons.home_outlined,
                size: 60,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  property.forRent
                      ? '\$${property.price} / month'
                      : '\$${property.price}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.bed_outlined),
                    const SizedBox(width: 4),
                    Text('${property.beds} Beds'),
                    const SizedBox(width: 16),
                    const Icon(Icons.bathtub_outlined),
                    const SizedBox(width: 4),
                    Text('${property.baths} Baths'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Spacious property with modern finishes and a great location. '
                  'This is demo text – replace with real description from your backend.',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatDetailPage(
                          otherUserName: 'Agent Smith',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Chat with Agent'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    // TODO: Implement inquiry / call / email
                  },
                  child: const Text('Request Info'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------- MY LISTINGS PAGE ----------------

class MyListingsPage extends StatelessWidget {
  const MyListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, re-use demo properties as "my" listings
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: demoProperties.length,
      itemBuilder: (context, index) {
        final property = demoProperties[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: const Icon(Icons.home_work_outlined),
          title: Text(property.title),
          subtitle: Text(property.location),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PropertyDetailPage(property: property),
              ),
            );
          },
        );
      },
    );
  }
}

/// ---------------- CREATE LISTING PAGE ----------------

class CreateListingPage extends StatelessWidget {
  const CreateListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final priceController = TextEditingController();

    String dealType = 'Sale';
    String propertyType = 'House';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Listing'),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Deal Type',
                    border: OutlineInputBorder(),
                  ),
                  value: dealType,
                  items: const [
                    DropdownMenuItem(
                      value: 'Sale',
                      child: Text('For Sale'),
                    ),
                    DropdownMenuItem(
                      value: 'Rent',
                      child: Text('For Rent'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => dealType = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Property Type',
                    border: OutlineInputBorder(),
                  ),
                  value: propertyType,
                  items: const [
                    DropdownMenuItem(
                      value: 'House',
                      child: Text('House'),
                    ),
                    DropdownMenuItem(
                      value: 'Apartment',
                      child: Text('Apartment'),
                    ),
                    DropdownMenuItem(
                      value: 'Villa',
                      child: Text('Villa'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => propertyType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Image picker + upload
                  },
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('Add Photos'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // TODO: Save listing to backend
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Listing saved (demo only).'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Publish Listing'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ---------------- CHATS PAGE ----------------

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final demoChats = [
      'Agent Smith',
      'Owner - Modern 3BR Apartment',
      'Broker - Lakeside House',
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final name = demoChats[index];
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(name),
          subtitle: const Text('Tap to open chat'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailPage(otherUserName: name),
              ),
            );
          },
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: demoChats.length,
    );
  }
}

class ChatDetailPage extends StatefulWidget {
  final String otherUserName;

  const ChatDetailPage({super.key, required this.otherUserName});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final List<String> _messages = [
    'Hi, is this property still available?',
    'Yes, it is. When would you like to schedule a visit?',
  ];
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(text);
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = index % 2 == 1;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- PROFILE PAGE ----------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(
          leading: CircleAvatar(
            radius: 26,
            child: Icon(Icons.person),
          ),
          title: Text('Demo User'),
          subtitle: Text('demo@example.com'),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.notifications_outlined),
          title: Text('Notification Settings'),
        ),
        const ListTile(
          leading: Icon(Icons.favorite_border),
          title: Text('Saved Properties'),
        ),
        const ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text('Account Settings'),
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            // TODO: Clear auth, navigate back to login
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          },
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Demo UI – connect Firebase Auth & backend later.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
