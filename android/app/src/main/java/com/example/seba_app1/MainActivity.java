package com.example.seba_app1;

import io.flutter.embedding.android.FlutterActivity;



import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.database.Cursor;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.content.pm.PackageManager;
import android.util.Log;
import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL1 = "com.example.app/gallery";
    private static final int IMAGE_PICK_CODE = 1000;
    private static final int PERMISSION_CODE = 1001;
    private MethodChannel.Result pendingResult;
    private static final String CHANNEL = "com.yourapp/link_opener";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("pickImage")) {
                        pendingResult = result;
                        checkAndRequestPermissions();
                    }
                    if (call.method.equals("openLink")) {
                        String link = call.arguments.toString();
                        try {
                            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(link));
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                            startActivity(intent);
                            result.success(true);
                        } catch (Exception e) {
                            result.error("OPEN_ERROR", "Could not open link", e.getMessage());
                        }
                    } else if (call.method.equals("dialNumber")) { // New case for opening dial pad
                        String phoneNumber = call.arguments.toString();
                        if (phoneNumber != null && !phoneNumber.isEmpty()) {
                            try {
                                Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse("tel:" + phoneNumber));
                                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                startActivity(intent);
                                result.success(true);
                            } catch (Exception e) {
                                result.error("DIAL_ERROR", "Could not open dial pad", e.getMessage());
                            }
                        } else {
                            result.error("INVALID_NUMBER", "Phone number is empty", null);
                        }
                    }
                    else {
                        result.notImplemented();
                    }
                });
    }

    private void checkAndRequestPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            // Android 13+ (API 33+) uses READ_MEDIA_IMAGES permission
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_MEDIA_IMAGES)
                    == PackageManager.PERMISSION_GRANTED) {
                pickImage();
            } else {
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.READ_MEDIA_IMAGES}, PERMISSION_CODE);
            }
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // Android 11+ (API 30+) doesn't require runtime permission for specific media files
            // when using the system picker, but we'll handle it cleanly
            pickImage();
        } else {
            // Android 7-10 uses READ_EXTERNAL_STORAGE
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE)
                    == PackageManager.PERMISSION_GRANTED) {
                pickImage();
            } else {
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, PERMISSION_CODE);
            }
        }
    }

    private void pickImage() {
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, IMAGE_PICK_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pickImage();
            } else {
                if (pendingResult != null) {
                    pendingResult.error("PERMISSION_DENIED", "Storage permission denied", null);
                    pendingResult = null;
                }
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == IMAGE_PICK_CODE && resultCode == Activity.RESULT_OK && data != null) {
            Uri selectedImage = data.getData();
            if (selectedImage != null && pendingResult != null) {
                String imagePath = getPathFromUri(selectedImage);
                pendingResult.success(imagePath);
                pendingResult = null;
            } else if (pendingResult != null) {
                pendingResult.error("NO_IMAGE", "No image selected", null);
                pendingResult = null;
            }
        } else if (requestCode == IMAGE_PICK_CODE && pendingResult != null) {
            pendingResult.error("CANCELED", "Image selection canceled", null);
            pendingResult = null;
        }
    }

    private String getPathFromUri(Uri uri) {
        String result = null;
        String[] projection = {MediaStore.Images.Media.DATA};

        try {
            Cursor cursor = getContentResolver().query(uri, projection, null, null, null);
            if (cursor != null) {
                int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                cursor.moveToFirst();
                result = cursor.getString(column_index);
                cursor.close();
            }
        } catch (Exception e) {
            // On Android 10+ this might throw exceptions in some cases
            // Return the URI string as fallback
            result = uri.toString();
        }

        return result;
    }
}