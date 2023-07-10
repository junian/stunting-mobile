import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnkPage extends StatelessWidget {
  const SnkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi ketika ikon kembali ditekan
            Get.back();
            // Anda dapat menambahkan Navigator.pop atau tindakan lain di sini
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Syarat dan Ketentuan penggunaan primaku'.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Perbaruan Terakhir : 1/12/2022',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus blandit sapien vel feugiat consectetur. Ut tincidunt faucibus purus a dignissim. Morbi non congue nunc, eget ultricies ex. Quisque non mi malesuada, suscipit ex a, convallis libero. Nulla consequat pellentesque quam id condimentum. Nulla sodales rutrum fringilla. Nullam vitae nibh et purus ullamcorper accumsan at vel nisi. Donec eleifend placerat arcu sed semper. Integer nec tincidunt urna.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
