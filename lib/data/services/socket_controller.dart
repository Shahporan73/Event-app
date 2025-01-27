// ignore_for_file: avoid_print


import 'dart:async';

import 'package:event_app/data/token_manager/const_veriable.dart';
import 'package:event_app/data/token_manager/local_storage.dart';
import 'package:event_app/view/message_view/controller/my_chatList_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../view/message_view/model/chat_list_model.dart';
import '../api/end_point.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  bool isSocketInitialized = false;
  RxBool isLoading = false.obs;
  Timer? _activeUsersTimer;

  // messages
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  // online users
  RxList<Map<String, dynamic>> onlineUsers = <Map<String, dynamic>>[].obs;


  final MyChatListController _myChatListController =
      Get.put(MyChatListController());


  Future<void> initializeSocket() async {
    if (isSocketInitialized) return;

    String? accessToken = await LocalStorage.getData(key: 'access_token');
    String? id = await LocalStorage.getData(key: 'myID');
    String? communityId = await LocalStorage.getData(key: 'communityId');

    if (accessToken == null || id == null) {
      print('Access token or user ID not found. Cannot initialize socket.');
      return;
    }

    print('myID: $id');

    socket = IO.io(
      Endpoints.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      if (kDebugMode) print('===============================Socket connected');

      /*// Emit seen event
      if (communityId != null) {
        seenMessage(chatId: communityId, token: accessToken);
      }*/

      // for getting real time chat list
      chatList();

      // online user
      listenForActiveUsers();
      /*// start listening after 30 seconds
      startListeningForActiveUsers();*/



      // for fetching realtime community message
      fetchMessages(chatId: communityId.toString());

      // Listen for 'seen::<communityId>' events
      if (communityId != null) {
        print("////////////////////////////////////// seen");
        socket.on('my-chat-lis::$id', (data) {
          print('Received seen::$communityId event data: $data');
          seenMessage(chatId: communityId, token: accessToken);
        });
      }

    });

    // for getting real time chat list
    socket.on('my-chat-list::$id', (data) {
      print("======================chat list$data");
      try {
        if (data != null) {
          var messageData = data['data'];
          if (messageData is List && messageData.isNotEmpty) {
            _myChatListController.chatList.value =
                messageData.map((item) => ChatList.fromJson(item)).toList();

            _myChatListController.communityChatList.value =
                _myChatListController.chatList
                    .where((chat) => chat.isCommunity == true)
                    .toList();

            _myChatListController.singleChatList.value = _myChatListController
                .chatList
                .where((chat) => chat.isCommunity == false)
                .toList();

            print("Updated chat list from real-time update: ${_myChatListController.chatList.length} messages.");
            print("Community chat list1: ${_myChatListController.communityChatList.length} messages.");
            print("Single chat list: ${_myChatListController.singleChatList.length} messages.");

            print('Body of my-chat-list::$id event: $data');

          } else {
            print("No messages available in the real-time chat list update.");
          }
        } else {
          print("Received null or empty data for real-time chat list update.");
        }
      } catch (e) {
        print("Error processing real-time chat list update: $e");
      }
    });

    // for getting real time messages
    socket.on('messages::$communityId', (data) {
      _handleIncomingMessages(data);
    });

    /// online user
   /* socket.on('active-users', (data) {
      if (kDebugMode) {
        print('===============online user =====================: $data');
      }

      try {
        if (data is List) {
          onlineUsers.clear();
          for (var user in data) {
            if (user is String) {
              onlineUsers.add(user);
            }
          }
          print('Updated online user list: ${onlineUsers.length} users');
          if (kDebugMode) {
            print('Updated online user list: $onlineUsers');
          }
        } else {
          if (kDebugMode) {
            print('Unexpected data format for online users: $data');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error processing online user data: $e");
        }
      }
    });*/




    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket.onConnectError((data) {
      print('Connection error: $data');
    });

    socket.onError((data) {
      print('Socket error: $data');
    });

    isSocketInitialized = true;
  }





  Future<void> chatList() async {
    String? accessToken = await LocalStorage.getData(key: 'access_token');
    if (socket.connected) {
      isLoading.value = true;

      // Emit the event and wait for acknowledgment
      socket.emitWithAck(
        'my-chat-list',
        {'token': accessToken},
        ack: (response) {
          isLoading.value = false;
          if (response != null) {
            print('==============Server acknowledgment: $response');

            // Handle and update chat list dynamically
            try {
              if (response['success'] == true) {
                var messageData = response['data'];
                if (messageData is List && messageData.isNotEmpty) {
                  // Update chat list in MyChatListController
                  _myChatListController.chatList.value = messageData
                      .map((item) => ChatList.fromJson(item))
                      .toList();

                  _myChatListController.communityChatList.value =
                      _myChatListController.chatList
                          .where((chat) => chat.isCommunity == true)
                          .toList();

                  _myChatListController.singleChatList.value =
                      _myChatListController.chatList
                          .where((chat) => chat.isCommunity == false)
                          .toList();

                  print("Updated chat list from socket: ${_myChatListController.chatList.length} messages.");

                  print("Community chat list: ${_myChatListController.communityChatList.length} messages.");

                  print("Single chat list: ${_myChatListController.singleChatList.length} messages.");

                } else {
                  print("No messages available in the chat list.");
                }
              } else {
                print('Chat list fetch failed: ${response['message']}');
              }
            } catch (e) {
              print("Error updating chat list from socket: $e");
            }
          } else {
            print(
                'No acknowledgment received or null response from the server.');
          }
        },
      );
    } else {
      print('Socket is not connected');
    }
  }



  Future<void> fetchMessages({required String chatId}) async {
    isLoading.value = true;
    try {
      // Retrieve access token
      String? accessToken = await LocalStorage.getData(key: 'access_token');

      if (accessToken == null) {
        print("Access token is null. Cannot fetch messages.");
        return;
      }

      if (!socket.connected) {
        print("Socket not connected. Please ensure the socket is initialized and connected.");
        return;
      }

      // Clear any existing listener for the same chatId to avoid duplicates
      socket.off('messages::$chatId');

      // Listen to real-time messages for the chatId
      socket.on('messages::$chatId', (data) {
        print("Received real-time message data for chatId $chatId: $data");
        _handleIncomingMessages(data);
      });

      // Emit the 'messages' event to fetch messages for the given chatId
      print("Emitting 'messages' event for chatId: $chatId with token: $accessToken");

      socket.emitWithAck(
        'messages',
        {
          "token": accessToken,
          "chatId": chatId,
        },
        ack: (response) {
          if (response != null) {
            if (response['success'] == true) {
              print("Messages fetched successfully for chatId: $chatId");
              _handleIncomingMessages(response['data']);
            } else {
              print("Failed to fetch messages. Server response: ${response['message']}");
            }
          } else {
            print("Acknowledgment is null or empty. Check server configuration.");
          }
        },
      );
    } catch (e) {
      print("Error in fetchMessages: $e");
    }finally {
      isLoading.value = false;
    }
  }

  void _handleIncomingMessages(dynamic data) {
    isLoading.value = true;
    messages.clear();
    try {
      if (data is List) {
        for (var message in data) {
          messages.add({
            'id': message['id'] ?? '',
            'text': message['content'] ?? '',
            'images': message['files'] ?? [],
            'videos': message['videos'] ?? [],
            'senderId': message['senderId'] ?? '',
            'chatId': message['chatId'] ?? '',
            'type': message['type'] ?? null,
            'senderName': message['sender']?['name'] ?? '',
            'senderProfilePicture': message['sender']?['profilePicture'] ?? '',
            'createdAt': message['createdAt'] ?? '',
          });
        }
      } else if (data is Map && data.containsKey('data') && data['data'] is List) {
        for (var message in data['data']) {
          messages.add({
            'id': message['id'] ?? '',
            'text': message['content'] ?? '',
            'images': message['files'] ?? [],
            'videos': message['videos'] ?? [],
            'senderId': message['senderId'] ?? '',
            'chatId': message['chatId'] ?? '',
            'type': message['type'] ?? null,
            'senderName': message['sender']?['name'] ?? '',
            'senderProfilePicture': message['sender']?['profilePicture'] ?? '',
            'createdAt': message['createdAt'] ?? '',
          });
        }
      } else {
        print('Unexpected data format: $data');
      }

      if (kDebugMode) {
        print('Updated messages list: ${messages.length} items');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing message data: $e');
      }
    }finally {
      isLoading.value = false;
    }
  }



  Future<void> submitMessage({
    required String text,
    required String chatId,
    required List<dynamic> imagesUrls,
    required List<dynamic> videosUrls,
  }) async {
    String? accessToken = await LocalStorage.getData(key: 'accessToken');

    if (socket.connected == true) {
      // Emit message with acknowledgment
      socket.emitWithAck(
        'send-message',
        {
          'token': accessToken,
          "content": text,
          "chatId": chatId,
          "files": imagesUrls,
          "videos": videosUrls,
        },
        ack: (response) {
          if (response != null && response is Map<String, dynamic>) {
            // Add sent message to the messages list using response data
            messages.add({
              'id': response['id'] ?? '',
              'text': text ?? '',
              'images': imagesUrls,
              'videos': videosUrls,
              'senderId': response['sender']?['id'] ?? '',
              'chatId': chatId,
              'type': response['type'] ?? null,
              'senderName': response['sender']?['name'] ?? '',
              'senderProfilePicture': response['sender']?['profilePicture'] ?? '',
              'createdAt': response['createdAt'] ?? '',
            });
            // Log the message sent
            if (kDebugMode) {
              print('Message sent successfully: $response');
            }
          } else {
            if (kDebugMode) {
              print('No acknowledgment or invalid response from server for the sent message.');
            }
          }
        },
      );

      if (kDebugMode) {
        print('Submit Message emitted: chatId = $chatId');
      }
    } else {
      if (kDebugMode) {
        print('Socket is not connected');
      }
      throw Exception('Socket not connected');
    }
  }



  Future<void> seenMessage({
    required String chatId,
    required String token,
  }) async {
    try {
      // Ensure the socket is connected
      if (!socket.connected) {
        print('Socket is not connected. Cannot emit seen event.');
        throw Exception('Socket not connected');
      }
      print('========seen=====================');
      // Emit the 'seen' event with the required data
      socket.emitWithAck(
        'seen', // Event name
        {
          "chatId": chatId, // Payload structure with chatId as key
          "token": token,   // Include token if required by the server
        },
        ack: (response) {
          if (response != null) {
            print('Seen event acknowledgment received: $response');
            if (response['success'] == true) {
              print('Seen event processed successfully.');
              print('========seen1=====================');
            } else {
              print('Failed to process seen event: ${response['message']}');
            }
          } else {
            print('No acknowledgment received for seen event.');
            print('========seen3=====================');
          }
        },
      );

      print('Seen event emitted with chatId: $chatId');
    } catch (e) {
      print('Error in seenMessage method: $e');
    }
  }


/// Listen for active users
  Future<void> listenForActiveUsers() async {
    try {
      String? accessToken = await LocalStorage.getData(key: 'access_token');
      if (accessToken == null) {
        print("Access token is null. Cannot listen for active users.");
        return;
      }

      if (!socket.connected) {
        print('Socket is not connected. Trying to reconnect...');
        socket.connect();
        return;
      }

      socket.emitWithAck(
        'active-users',
        {"token": accessToken},
        ack: (response) {
          if (response is Map<String, dynamic> && response['success'] == true) {
            var data = response['data'];
            if (data is List) {
              _updateOnlineUsers(data);
              print('Active users acknowledgment received: ${data.length} users');
            } else {
              print('Unexpected data format in acknowledgment: $response');
            }
          } else {
            print('Failed to receive acknowledgment: $response');
          }
        },
      );

      socket.on('active-users', (data) {
        if (data is Map<String, dynamic> && data['success'] == true) {
          var users = data['data'];
          if (users is List) {
            _updateOnlineUsers(users);
          } else {
            print('Unexpected data format in real-time update: $data');
          }
        } else {
          print('Invalid format for real-time update: $data');
        }
      });
    } catch (e) {
      print("Error in listenForActiveUsers: $e");
    }
  }
/// Update online users
  void _updateOnlineUsers(List<dynamic> data) {
    try {
      onlineUsers.clear();
      for (var user in data) {
        if (user is Map<String, dynamic> && user['id'] != null) {
          onlineUsers.add({
            "id": user['id'],
            "name": user['name'] ?? '',
            "profilePicture": user['profilePicture'] ?? '',
          });
        } else {
          print('Invalid user object format: $user');
        }
      }
      print('Updated online users: ${onlineUsers.length} users');
    } catch (e) {
      print('Error updating online users: $e');
    }
  }





  /// Update community picture
  Future<void> updateCommunityPicture({
    required String communityId,
    required String picture
  }) async {
    try {
      // Ensure the socket is connected
      if (!socket.connected) {
        print('Socket not connected. Reconnecting...');
        await socket.connect();
      }

      print('========Updating community picture=====================');

      // Emit the 'update-community' event with the required data
      socket.emitWithAck(
        'update-community', // Event name
        {
          "token": LocalStorage.getData(key: 'access_token'),
          "communityId": communityId,
          "communityProfile": picture,
        },
        ack: (response) {
          if (response != null) {
            print('Update acknowledgment received: $response');
            if (response['success'] == true) {
              print('Community picture updated successfully.');
              Get.rawSnackbar(message: response['message']);

              // Emit a UI update event
              /*socket.emit('my-chat-list::${LocalStorage.getData(key: myID)}', {
                "communityId": communityId,
                "communityProfile": picture,
              });*/

            } else {
              print('Failed to update community picture: ${response['message']}');
            }
          } else {
            print('No acknowledgment received for update event.');
          }
        },
      );
      print('Update event emitted with communityId: $communityId');
    } catch (e) {
      print('Error in updateCommunityPicture method: $e');
    }
  }

  /// Update community Name
  Future<void> updateCommunityName({
    required String communityId,
    required String communityName,
  }) async {
    try {
      // Ensure the socket is connected
      if (!socket.connected) {
        print('Socket not connected. Reconnecting...');
        await socket.connect();
      }

      print('========Updating community Name=====================');

      // Emit the 'update-community' event with the required data
      socket.emitWithAck(
        'update-community', // Event name
        {
          "token": LocalStorage.getData(key: 'access_token'),
          "communityId": communityId,
          "communityName": communityName,
        },
        ack: (response) {
          if (response != null) {
            print('Update acknowledgment received: $response');
            if (response['success'] == true) {
              print('Community Name updated successfully.');
              Get.rawSnackbar(message: response['message']);

              // Emit a UI update event
              /*socket.emit('my-chat-list::${LocalStorage.getData(key: myID)}', {
                "communityId": communityId,
                "communityProfile": picture,
              });*/

              socket.emit('update-community', {
                "communityId": communityId,
                "communityName": communityName,
              });

            } else {
              print('Failed to update community picture: ${response['message']}');
            }
          } else {
            print('No acknowledgment received for update event.');
          }
        },
      );
      print('Update event emitted with communityId: $communityId');
    } catch (e) {
      print('Error in updateCommunityPicture method: $e');
    }
  }


  /// Leave community
  Future<void> LeaveCommunity({
    required String communityId,
  }) async {
    try {
      // Ensure the socket is connected
      if (!socket.connected) {
        print('Socket not connected. Reconnecting...');
        await socket.connect();
      }

      print('========Leave community =====================');

      // Emit the 'update-community' event with the required data
      socket.emitWithAck(
        'leave-community', // Event name
        {
          "token": LocalStorage.getData(key: 'access_token'),
          "communityId": communityId,
        },
        ack: (response) {
          if (response != null) {
            print('Leave acknowledgment received: $response');
            if (response['success'] == true) {
              print('Community Leave successfully.');
              Get.rawSnackbar(message: response['message']);

            } else {
              print('Failed to Leave community: ${response['message']}');
            }
          } else {
            print('No acknowledgment received for update event.');
          }
        },
      );
      print('Leave emitted with communityId: $communityId');
    } catch (e) {
      print('Error in Leave method: $e');
    }
  }


  /*void startListeningForActiveUsers() {
    print('Starting to listen for active users...');
    _activeUsersTimer?.cancel(); // Cancel any existing timer to avoid duplication
    _activeUsersTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('Starting to listen for active users...');
      listenForActiveUsers(); // Re-invoke the method every 30 seconds
    });
  }

  @override
  void onClose() {
    _activeUsersTimer?.cancel(); // Stop the timer when the service is closed
    if (isSocketInitialized) {
      socket.dispose();
    }
    super.onClose();
  }*/

}
