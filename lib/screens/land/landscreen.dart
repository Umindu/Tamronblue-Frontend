import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tamronblue_frontend/controllers/land_controller.dart';
import 'package:tamronblue_frontend/screens/land/landadd.dart';
import 'package:tamronblue_frontend/screens/land/landdetail.dart';
import 'package:tamronblue_frontend/shimmer/shimmerlist.dart';
import 'package:tamronblue_frontend/utils/widgets.dart';

class LandScreen extends StatefulWidget {
  const LandScreen({super.key});

  @override
  State<LandScreen> createState() => _LandScreenState();
}

class _LandScreenState extends State<LandScreen> {
  LandController landController = Get.put(LandController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        title: const Text(
          'Lands',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // show popup menu
          IconButton(
            onPressed: () {
              popUpMenu(context);
            },
            icon: const Icon(Iconsax.more),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddLand())?.then((result) {
            if (result == true) {
              setState(() {});
            }
          });
        },
        child: const Icon(Iconsax.add),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: landController.getMyAllLandsList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SizedBox(
                    child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.withOpacity(0.6),
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                const ShimmerList(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 16,
                                ),
                            itemCount: 15)),
                  ),
                );
              } else {
                if (snapshot.data.length == 0) {
                  return const Center(
                    child: Text('No Lands'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data[index].name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      subtitle: Text(snapshot.data[index].address+ ', ' + snapshot.data[index].district + ', ' + snapshot.data[index].region,),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.more,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      onTap: () {
                        Get.to(() => LandDetail(land_id: snapshot.data[index].id, isCustomerField: false,));
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
