import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leftover_food_app/edit_user.dart';
import 'package:leftover_food_app/edit_request.dart';
import 'package:leftover_food_app/screens/analytics_tab.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap in a TabController to switch between Users and Requests
    return DefaultTabController(
      length: 3, // 3 tabs: Users, Requests, Analytics
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
 
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Requests'),
              Tab(text: 'Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Users Tab
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) { // connects to the users info from the database
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final userId = doc.id;
                    // makes sure the user has an email and name
                    return ListTile(
                      title: Text(data['email'] ?? 'No Email'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['name'] ?? 'No Name'),
                          Text(
                            data['isActive'] == true ? 'Status: Active' : 'Status: Inactive',
                            style: TextStyle(
                              color: data['isActive'] == true ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch( // toggles user status active/unactive
                            value: data['isActive'] ?? false,
                            onChanged: (value) async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .update({'isActive': value});
                            },
                          ),
                          IconButton( // edits user with the new file added
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => EditUserDialog(
                                userData: data,
                                userId: userId,
                              ),
                            ),
                          ),
                          IconButton( // deletes user
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('User deleted')),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // Requests Tab
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('receiver_requests')
                  .snapshots(),
              builder: (context, snapshot) { // connects to the submitted requests info from the database
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final requestId = doc.id;

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(data['name'] ?? 'No Name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // show key details
                            Text(data['address'] ?? 'No Address'),
                            Text('Food: ${data['foodTypes'] ?? 'N/A'}'),
                            Text('Qty: ${data['quantity'] ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            // display status
                            Text(
                              'Status: ${data['status'] ?? 'pending'}',
                              style: TextStyle(
                                color: (data['status'] == 'approved')
                                    ? Colors.green
                                    : (data['status'] == 'rejected')
                                        ? Colors.red
                                        : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // show flagged marker if flagged
                            if (data['flagged'] == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '⚠️ Flagged as inappropriate',
                                  style: TextStyle(
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton( // edit request
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => EditRequestDialog(
                                  requestData: data,
                                  requestId: requestId,
                                ),
                              ),
                            ),
                            IconButton( // approve request
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('receiver_requests')
                                    .doc(requestId)
                                    .update({'status': 'approved'});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Request approved')),
                                );
                              },
                            ),
                            IconButton( // reject request
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('receiver_requests')
                                    .doc(requestId)
                                    .update({'status': 'rejected'});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Request rejected')),
                                );
                              },
                            ),
                            IconButton( // report/flag inappropriate
                              icon: const Icon(Icons.flag, color: Colors.orange),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('receiver_requests')
                                    .doc(requestId)
                                    .update({'flagged': true});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Request flagged as inappropriate')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
         
            // Analytics Tab
            const AnalyticsTab(),
          ],
        ),
      ),
    );
  }
}