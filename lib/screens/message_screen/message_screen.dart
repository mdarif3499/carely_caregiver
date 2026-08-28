import 'dart:io';

import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/profile_avatar/profile_avatar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/message_screen/controller/message_screen_controller.dart';
import 'package:carely_caregiver/screens/message_screen/model/chat_model.dart';
import 'package:carely_caregiver/screens/message_screen/widgets/expandable_chat_text.dart';

import '../../routes/app_routes.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MessageScreenController controller = Get.find<MessageScreenController>();
    return DefaultBackgroundTemplate(
      onBackPress: Get.back,
      backgroundImage: 'assets/images/img_1.png',

      titleWidget: Obx(() {
        final conversation = controller.selectedConversation.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileAvatar(
              size: 48.h,
              imageUrl: conversation?.avatarUrl ??
                  'https://img.freepik.com/free-photo/beautiful-young-female-doctor-looking-camera-office_1301-7807.jpg?semt=ais_user_personalization&w=740&q=80',
              borderColor: AppColors.instance.transparent,
            ),
            2.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText(
                  text: conversation != null ? conversation.name : 'Chat',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.white,
                ),
                Obx(() {
                  if (controller.isPartnerTyping.value) {
                    return const CommonText(
                      text: 'typing...',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: Color(0xFF22C55E), // WhatsApp-like green
                    );
                  }
                  ///  Caregiver Profiles API Response   Caregiver Profiles API Response

                  return CommonText(
                    text: conversation != null ? conversation.role : '',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: Colors.white70,
                  );
                }),
              ],
            )
          ],
        );
      }),
      appBarBackgroundColor: const Color(0xFF1F2C34),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(
                  () => Skeletonizer(
                    enabled: controller.isLoading.value,
                    child: SmartListLoader(
                      isReverse: true,
                      onLoadMore: (index) async {
                        await controller.loadMore();
                      },
                      isLoading: controller.isLoading.value,
                      itemCount: controller.chats.length,
                      itemBuilder: (context, index) => _chatItem(
                        controller.chats[index],
                        context,
                        controller,
                        index,
                      ),
                    ),
                  ),
                ),
              ),
            ),
             _messageInputWidget(controller),
          ],
        ),
      ),
    );
  }
  Widget _chatItem(
    ChatMessage chat,
    BuildContext context,
    MessageScreenController controller,
    int index,
  ) {
    final isMe = chat.userId == controller.userId;
    final showDate = _shouldShowDate(controller.chats, index);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDate) _dateHeader(chat.createdAt),
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe) ...[
                SizedBox(width: 50.w),
                Flexible(
                  child: _messageBubble(
                    chat: chat,
                    isMe: isMe,
                    controller: controller,
                  ),
                ),
              ] else ...[
                // Partner Avatar
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.instance.boxBg,
                  backgroundImage: chat.userImage.isNotEmpty
                      ? NetworkImage(chat.userImage)
                      : null,
                  child: chat.userImage.isEmpty
                      ? Icon(Icons.person, size: 18.sp, color: AppColors.instance.primary)
                      : null,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: _messageBubble(
                    chat: chat,
                    isMe: isMe,
                    controller: controller,
                  ),
                ),
                SizedBox(width: 50.w),
              ],
            ],
          ),
        ),
      ],
    );
  }

  bool _shouldShowDate(List<ChatMessage> chats, int index) {
    if (index == chats.length - 1) return true;

    final currentDate = chats[index].createdAt;
    final previousDate = chats[index + 1].createdAt;

    return currentDate.year != previousDate.year ||
        currentDate.month != previousDate.month ||
        currentDate.day != previousDate.day;
  }

  Widget _dateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMM dd, yyyy').format(date);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.instance.boxBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: CommonText(
            text: dateText,
            fontSize: 12.sp,
            textColor: AppColors.instance.textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _messageBubble({
    required ChatMessage chat,
    required bool isMe,
    required MessageScreenController controller,
  }) {
    final hasImage = chat.files.isNotEmpty;
    final hasText = chat.content.isNotEmpty;
    final timeStr = DateFormat('hh:mm a').format(chat.createdAt);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
          bottomLeft: isMe ? Radius.circular(12.r) : Radius.circular(2.r),
          bottomRight: isMe ? Radius.circular(2.r) : Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 1.r,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasImage)
            Stack(
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.instance.fullScreenImage, arguments: chat.files.first),
                  child: Hero(
                    tag: chat.files.first,
                    child: CommonImage(
                      src: chat.files.first,
                      width: 240.w,
                      height: 240.h,
                      fill: BoxFit.cover,
                    ),
                  ),
                ),
                if (isMe && !hasText)
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: _StatusTicks(
                        status: chat.status,
                        isFailed: chat.isSendingFailed,
                      ),
                    ),
                  ),
              ],
            ),
          
          if (hasText)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(12.w, (hasImage ? 8 : 10).h, isMe ? 40.w : 12.w, 10.h),
                        child: ExpandableChatText(
                          text: chat.content,
                          isMe: isMe,
                        ),
                      ),
                      if (isMe)
                        Positioned(
                          bottom: 6.h,
                          right: 8.w,
                          child: _StatusTicks(
                            status: chat.status,
                            isFailed: chat.isSendingFailed,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

          if (chat.isSending)
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 8.w,
                    height: 8.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.w,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'sending...',
                    style: TextStyle(fontSize: 9.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _messageInputWidget(MessageScreenController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      color: Colors.transparent,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Preview Area (Keep this as is)
            Obx(() {
              final xfile = controller.selectedImage.value;
              if (xfile == null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h, left: 40.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 90.h,
                        width: 90.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: Colors.grey.shade200, width: 2.w),
                          image: DecorationImage(
                            image: FileImage(File(xfile.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -10.h,
                        right: -10.w,
                        child: GestureDetector(
                          onTap: controller.clearSelectedImage,
                          child: Container(
                            padding: EdgeInsets.all(5.r),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.red.withAlpha(50), blurRadius: 5.r)],
                            ),
                            child: Icon(Icons.close_rounded, size: 16.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            // Single Pill Bubble containing everything
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.grey.shade300, width: 1.w),
              ),
              padding: EdgeInsets.only(left: 6.w, right: 4.w),
              child: Row(
                children: [
                  // 1. Plus Icon (Inside, no splash circle)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: controller.pickImage,
                      customBorder: const CircleBorder(),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(Icons.add, size: 24.sp, color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  // TextField
                  Expanded(
                    child: TextField(
                      controller: controller.messageTextController,
                      style: TextStyle(fontSize: 15.sp, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15.sp),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        isDense: true,
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // 3. Green Send Button
                  Obx(() {
                    final canSend = controller.message.value.trim().isNotEmpty ||
                        controller.selectedImage.value != null;
                    return GestureDetector(
                      onTap: canSend ? () => controller.send() : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: canSend
                              ? const Color(0xFF22C55E)
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20.sp),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTicks extends StatelessWidget {
  final String status;
  final bool isFailed;
  const _StatusTicks({required this.status, this.isFailed = false});

  @override
  Widget build(BuildContext context) {
    if (isFailed) {
      return Icon(Icons.error_outline_rounded, size: 14.sp, color: Colors.redAccent);
    }
    if (status == 'SENT') {
      return Icon(Icons.done_rounded, size: 14.sp, color: Colors.grey);
    } else if (status == 'DELIVERED') {
      return Icon(Icons.done_all_rounded, size: 14.sp, color: Colors.grey);
    } else if (status == 'SEEN') {
      return Icon(Icons.done_all_rounded, size: 14.sp, color: const Color(0xFF34B7F1)); // WhatsApp blue for seen
    }
    return const SizedBox.shrink();
  }
}
