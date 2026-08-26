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
import 'package:carely_caregiver/screens/message_screen/widgets/expandable_chat_text.dart';

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText(
                  text: conversation != null ? conversation.name : 'Chat',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                Obx(() {
                  if (controller.isPartnerTyping.value) {
                    return CommonText(
                      text: 'typing...',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.instance.primary,
                    );
                  }
                  return CommonText(
                    text: conversation != null ? conversation.role : '',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.instance.textGrey,
                  );
                }),
              ],
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
                // Partner Avatar
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.instance.boxBg,
                  backgroundImage: chat.userImage.isNotEmpty
                      ? NetworkImage(chat.userImage)
                      : null,
                  child: chat.userImage.isEmpty
                      ? Icon(Icons.person, size: 18, color: AppColors.instance.primary)
                      : null,
                ),
                const SizedBox(width: 8),
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
    final hasImage = chat.files.isNotEmpty;
    final hasText = chat.content.isNotEmpty;

    return Container(
      clipBehavior: Clip.antiAlias,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasImage)
            Stack(
              children: [
                CommonImage(
                  src: chat.files.first,
                  width: 240,
                  height: 240,
                  fill: BoxFit.cover,
                ),
                if (isMe && !hasText)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _StatusTicks(status: chat.status),
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
                        padding: EdgeInsets.fromLTRB(12, hasImage ? 8 : 10, isMe ? 40 : 12, 10),
                        child: ExpandableChatText(
                          text: chat.content,
                          isMe: isMe,
                        ),
                      ),
                      if (isMe)
                        Positioned(
                          bottom: 6,
                          right: 8,
                          child: _StatusTicks(status: chat.status),
                        ),
                    ],
                  ),
                ),
              ],
            ),

          if (chat.isSending || chat.isSendingFailed)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (chat.isSending) ...[
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
                  ] else if (chat.isSendingFailed) ...[
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
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _messageInputWidget(MessageScreenController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                padding: const EdgeInsets.only(bottom: 16, left: 40),
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
                          border: Border.all(color: Colors.grey.shade200, width: 2),
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
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.red.withAlpha(50), blurRadius: 5)],
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
            // Single Pill Bubble containing everything
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              padding: const EdgeInsets.only(left: 6, right: 4),
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
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.add, size: 24, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // TextField
                  Expanded(
                    child: TextField(
                      controller: controller.messageTextController,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                      cursorColor: Colors.black87,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        isDense: true,
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // 3. Green Send Button
                  Obx(() {
                    final canSend = controller.message.value.trim().isNotEmpty ||
                        controller.selectedImage.value != null;
                    return GestureDetector(
                      onTap: canSend ? () => controller.send() : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: canSend
                              ? const Color(0xFF22C55E)
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
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
  const _StatusTicks({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 'SENT') {
      return const Icon(Icons.done_rounded, size: 16, color: Colors.white70);
    } else if (status == 'DELIVERED') {
      return const Icon(Icons.done_all_rounded, size: 16, color: Colors.white70);
    } else if (status == 'SEEN') {
      return const Icon(Icons.done_all_rounded, size: 16, color: Color(0xFF00E676)); // Vibrant green for seen
    }
    return const SizedBox.shrink();
  }
}




