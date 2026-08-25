import 'dart:io';

import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/profile_avatar/profile_avatar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/message_screen/controller/message_screen_controller.dart';
import 'package:carely_caregiver/screens/message_screen/model/chat_model.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MessageScreenController controller = Get.find<MessageScreenController>();
    return DefaultBackgroundTemplate(
      onBackPress: Get.back,

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
            CommonText(
              text: conversation != null
                  ? '${conversation.name}, ${conversation.role}'
                  : 'Chat',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )
          ],
        );
      }),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => SmartListLoader(
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
          _messageInputWidget(controller),
        ],
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
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe) ...[
                const SizedBox(width: 50),
                Flexible(
                  child: _messageBubble(
                    chat: chat,
                    isMe: isMe,
                    controller: controller,
                  ),
                ),
              ] else ...[
                Flexible(
                  child: _messageBubble(
                    chat: chat,
                    isMe: isMe,
                    controller: controller,
                  ),
                ),
                const SizedBox(width: 50),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.instance.boxBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CommonText(
            text: dateText,
            fontSize: 12,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isMe
            ? AppColors.instance.secondaryColor
            : AppColors.instance.secondaryColor.withAlpha(50),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: isMe
              ? const Radius.circular(16)
              : const Radius.circular(4),
          bottomRight: isMe
              ? const Radius.circular(4)
              : const Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chat.files.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CommonImage(
                  src: chat.files.first,
                  width: 200,
                  height: 200,
                  fill: BoxFit.cover,
                ),
              ),
            ),
          if (chat.content.isNotEmpty)
            CommonText(
              text: chat.content,
              fontSize: 14,
              textColor: isMe ? Colors.white : AppColors.instance.textPrimary,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
            ),
          if (chat.isSending) ...[
            4.height,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isMe ? Colors.white70 : AppColors.instance.textGrey,
                    ),
                  ),
                ),
                4.width,
                CommonText(
                  text: 'Sending...',
                  fontSize: 10,
                  textColor: isMe
                      ? Colors.white70
                      : AppColors.instance.textGrey,
                ),
              ],
            ),
          ] else if (chat.isSendingFailed) ...[
            4.height,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 12,
                  color: AppColors.instance.error,
                ),
                4.width,
                CommonText(
                  text: 'Failed',
                  fontSize: 10,
                  textColor: AppColors.instance.error,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _messageInputWidget(MessageScreenController controller) {
    final colors = AppColors.instance;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Preview Area
            Obx(() {
              final xfile = controller.selectedImage.value;
              if (xfile == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colors.boxBg, width: 2),
                          image: DecorationImage(
                            image: FileImage(File(xfile.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: GestureDetector(
                          onTap: controller.clearSelectedImage,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: colors.error,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colors.error.withAlpha(50),
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.boxBg.withAlpha(40),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colors.primary.withAlpha(15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add_photo_alternate_rounded, color: colors.primary, size: 22),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: controller.messageTextController,
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w500, 
                              color: colors.textPrimary,
                              height: 1.2,
                            ),
                            cursorColor: colors.primary,
                            cursorWidth: 2,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: Colors.grey, 
                                fontSize: 15, 
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(() {
                  final canSend = controller.message.value.trim().isNotEmpty || 
                                 controller.selectedImage.value != null;
                  return GestureDetector(
                    onTap: canSend ? () => controller.send() : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: canSend ? colors.primary : Colors.grey.shade200,
                        shape: BoxShape.circle,
                        boxShadow: canSend ? [
                          BoxShadow(
                            color: colors.primary.withAlpha(60),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ] : null,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.send_rounded, 
                          color: canSend ? Colors.white : Colors.grey.shade400, 
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
