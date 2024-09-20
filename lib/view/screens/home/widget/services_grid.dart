import 'package:flutter/material.dart';
import 'package:glamcode/data/api/api_helper.dart';
import 'package:glamcode/data/model/main_categories_model.dart';
import 'package:glamcode/util/dimensions.dart';
import 'package:glamcode/view/base/error_screen.dart';
import 'package:glamcode/view/screens/packages/packages_screen.dart';

class ServicesGrid extends StatefulWidget {
  final String? title;
  const ServicesGrid({Key? key, this.title}) : super(key: key);
  @override
  State<ServicesGrid> createState() => _ServicesGridState();
}

class _ServicesGridState extends State<ServicesGrid>
    with AutomaticKeepAliveClientMixin {
  late Future<MainCategoriesModel?> mainCategoriesModel;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mainCategoriesModel = DioClient().getMainCategories();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<MainCategoriesModel?>(
        future: mainCategoriesModel,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(
            //     child: CircularProgressIndicator(
            //   color: Color(0xFFA854FC),
            // ));
            return GridView.builder(
              padding:
                  const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 11,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return dummyimageGridCard(
                    "assets/images/app.png", "", 0, context);
              },
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Maincat> mainCatModelData;
            if (snapshot.hasData && snapshot.data?.status == "success") {
              mainCatModelData = snapshot.data?.maincat ?? [];
              // return dummyListviewCell();
              return GridView.builder(
                padding:
                    const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: mainCatModelData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return imageGridCard(
                      mainCatModelData[index].mainCategoryImageUrl ?? "",
                      mainCatModelData[index].name ?? "",
                      mainCatModelData[index].id ?? 0,
                      context);
                },
              );
            } else {
              return const CustomError();
            }
          } else {
            return const CustomError();
          }
        });
  }
}

Widget imageGridCard(
    String imageUrl, String title, int id, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => PackagesScreen(
                    mainCategoryId: id,
                    mainCategoryName: title,
                  )),
          ModalRoute.withName('/index'));
      print("mainCategoryId $id");
    },
    child: Column(
      children: [
        Card(
            surfaceTintColor: Colors.white,
            elevation: 4,
            shadowColor: const Color.fromARGB(255, 254, 19, 3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
                height: 70,
                width: 95,
                child:
                    // (imageUrl == "")
                    //     ? Image(image: AssetImage("assets/images/fob.png"))
                    //     :
                    Image(image: NetworkImage(imageUrl)))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
    // child: SizedBox(
    //   height: 50,
    //   width: 50,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       CircleAvatar(
    //         radius: 30,
    //         // backgroundImage: NetworkImage(imageUrl),
    //         backgroundColor: Colors.white,
    //         child: ClipOval(
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 image: DecorationImage(
    //               image: NetworkImage(imageUrl),
    //             )),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(
    //           title,
    //           textAlign: TextAlign.center,
    //         ),
    //       )
    //     ],
    //   ),
    // ),
  );
}

Widget dummyimageGridCard(
    String imageUrl, String title, int id, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => PackagesScreen(
                    mainCategoryId: id,
                    mainCategoryName: title,
                  )),
          ModalRoute.withName('/index'));
      print("mainCategoryId $id");
    },
    child: Column(
      children: [
        Card(
            surfaceTintColor: Colors.white,
            elevation: 4,
            shadowColor: const Color.fromARGB(255, 254, 19, 3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
                height: 70,
                width: 95,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 239, 233, 233),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFEBEBF4),
                        Color(0xFFF4F4F4),
                        Color(0xFFEBEBF4),
                      ],
                      stops: [
                        0.1,
                        0.3,
                        0.4,
                      ],
                      begin: Alignment(-1.0, -0.3),
                      end: Alignment(1.0, 0.3),
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        )
      ],
    ),
    // child: SizedBox(
    //   height: 50,
    //   width: 50,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       CircleAvatar(
    //         radius: 30,
    //         // backgroundImage: NetworkImage(imageUrl),
    //         backgroundColor: Colors.white,
    //         child: ClipOval(
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 image: DecorationImage(
    //               image: NetworkImage(imageUrl),
    //             )),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(
    //           title,
    //           textAlign: TextAlign.center,
    //         ),
    //       )
    //     ],
    //   ),
    // ),
  );
}
