import 'package:carely_caregiver/widgets/default_background_template.dart';
import 'package:carely_caregiver/widgets/profile_avatar/profile_avatar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:carely_caregiver/screens/message_screen/controller/message_screen_controller.dart';
import 'package:carely_caregiver/screens/message_screen/model/chat_model.dart';

import '../../gen/assets.gen.dart';

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
          CommonText(
            text: chat.content,
            fontSize: 14,
            textColor: isMe ? Colors.white : AppColors.instance.textPrimary,
            fontWeight: FontWeight.w500,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
             child: Row(
                children: [
                  Expanded(
                    child: CommonTextField(
                      controller: controller.messageTextController,
                      backgroundColor: AppColors.instance.secondaryColor
                          .withAlpha(30),
                      validationType: ValidationType.notRequired,
                      hintText: 'Type a message',
                    ),
                  ),
                ],
              ),
            ),
            12.width,
            Obx(() {
              return GestureDetector(
                onTap: controller.message.value.trim().isEmpty
                    ? null
                    : () => controller.send(),
                child: CommonImage(
                  src: Assets.icons.messageSend,
                  height: 48,
                  width: 48,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
