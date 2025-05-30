import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whazlansaja/models/dosen_model.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List<DosenModel> listDosen = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  bool isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    loadDosenJson();

    searchFocus.addListener(() {
      setState(() {
        isSearchFocused = searchFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  Future<void> loadDosenJson() async {
    final String response =
        await rootBundle.loadString('assets/json_data_chat_dosen/dosen_chat.json');
    final data = json.decode(response) as List;
    setState(() {
      listDosen = data.map((e) => DosenModel.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WhAzlansaja'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Kotak pencarian
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  focusNode: searchFocus,
                  decoration: const InputDecoration(
                    hintText: 'Cari dosen dan mulai chat',
                    prefixIcon:  Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
          ),

          // Tampilkan "Belum ada pencarian" jika fokus & belum mengetik
          if (isSearchFocused && !isSearching)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Belum ada pencarian',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),
              ),
            )
          else
            // Daftar dosen
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final dosen = listDosen[index];
                  final lastMessage = dosen.messages.isNotEmpty
                      ? dosen.messages.last.message
                      : 'Belum ada pesan';

                  int unreadCount = dosen.messages
                      .where((msg) => msg.isRead == false && msg.from == 0)
                      .length;

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PesanScreen(dosen: dosen),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(dosen.avatar),
                    ),
                    title: Text(
                      dosen.fullName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      lastMessage,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (dosen.fullName == 'Azlan, S.Kom., M.Kom.' && unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 8),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          dosen.fullName == 'Azlan, S.Kom., M.Kom.' ? '2 menit lalu' : 'kemarin',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
                childCount: listDosen.length,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Pembaruan'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Komunitas'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Panggilan'),
        ],
      ),
    );
  }
}
