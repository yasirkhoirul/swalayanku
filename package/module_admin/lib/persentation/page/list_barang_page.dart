import 'package:flutter/material.dart';
import 'package:module_core/common/color.dart';

class ListBarangPage extends StatelessWidget {
  const ListBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 700;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: SearchBar(
                
                hintText: "Cari Pesanan",
                trailing: [Icon(Icons.search, color: MyColor.hijau)],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    
                    maxCrossAxisExtent: 400,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) =>
                      _buildOrderCard(context, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, int index) {
    // Determine if it's "Pesanan Bambang" or "Pemesanan"
    bool isPesananBambang = index % 2 == 0;

    return Center(
      child: Card(
        margin: EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header: Title and Date
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPesananBambang ? 'Pesanan Bambang' : 'Pemesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '17-10-2025 07:00',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                // Item List
                Expanded(
                  child:
                      // Total and Notes
                      ListView(
                        children: [
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [Text('Nama Barang'), Text('Rp2000')],
                                  ),),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [Text('Nama Barang'), Text('Rp2000')],
                                  ),),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [Text('Nama Barang'), Text('Rp2000')],
                                  ),),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [Text('Nama Barang'), Text('Rp2000')],
                                  ),),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [Text('Nama Barang'), Text('Rp2000')],
                                  ),),
                              Divider(height: 24, thickness: 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Harga',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Rp10000',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Catatan :',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ],
                      ),
                ),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Tolak action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.merah,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Tolak'),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Verifikasi action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.hijau,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Verifikasi'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
