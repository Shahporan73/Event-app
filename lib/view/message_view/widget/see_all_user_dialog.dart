// ignore_for_file: prefer_const_constructors

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/res/app_images/App_images.dart';
import 'package:event_app/res/common_widget/RoundTextField.dart';
import 'package:event_app/res/common_widget/custom_network_image_widget.dart';
import 'package:event_app/view/message_view/controller/personal_chat_controller.dart';
import 'package:event_app/view/message_view/model/chat_list_model.dart';
import 'package:event_app/view/message_view/view/personal_chat_screen.dart';
import 'package:event_app/view/profile_view/view/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../res/app_colors/App_Colors.dart';
import '../../../res/common_widget/custom_app_bar.dart';

class SeeAllUsersDialog extends StatefulWidget {
  final List<Participant> members;
  SeeAllUsersDialog({super.key, required this.members});

  @override
  _SeeAllUsersDialogState createState() => _SeeAllUsersDialogState();
}

class _SeeAllUsersDialogState extends State<SeeAllUsersDialog> {
  late TextEditingController _searchController;
  List<Participant> filteredMembers = [];

  final PersonalChatController personalChatController = Get.put(PersonalChatController());

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredMembers = widget.members;

    // Listen to changes in the search input
    _searchController.addListener(() {
      filterMembers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterMembers() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredMembers = widget.members.where((member) {
        final name = member.user?.name?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                appBarName: "Members",
                widget: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),

              RoundTextField(
                controller: _searchController,
                hint: "Search Members",
                borderRadius: 8,
                focusBorderRadius: 8,
                prefixIcon: Icon(
                    Icons.search_outlined
                ),
              ),
              SizedBox(height: 20),
              filteredMembers.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                itemCount: filteredMembers.length,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  var data = filteredMembers[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CustomNetworkImage(
                        imageUrl: data.user?.profilePicture ?? placeholderImage,
                        width: 35,
                        height: 35,
                      ),
                    ),
                    title: Text(
                      data.user?.name ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Image.asset(AppImages.chatIcon, scale: 4),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Action for the message button
                        if(data.user == null){
                          Get.rawSnackbar(message: "User not found");
                        }else{
                          personalChatController.getChatList(
                              receiverId: data.user?.id ?? "",
                              userName: data.user?.name ?? "",
                              userImage: data.user?.profilePicture ?? ""
                          );
                        }

                      },
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      // Navigate to UserProfileScreen
                      LocalStorage.saveData(key: userProfileId, data: data.user?.id);

                      print('id ${data.user?.id}, locally saved id ${LocalStorage.getData(key: userProfileId)}');

                      Get.to(
                            () => UserProfileScreen(),
                        transition: Transition.leftToRight,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                  );
                },
              )
                  : Center(
                child: Text(
                  "No members found",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showSeeAllUserDialog(BuildContext context, List<Participant> members) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SeeAllUsersDialog(members: members);
    },
  );
}
