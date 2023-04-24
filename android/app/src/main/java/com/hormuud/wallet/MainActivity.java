package com.hormuud.wallet;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;
import android.app.Activity;

import com.hover.sdk.api.Hover;
import com.hover.sdk.api.HoverParameters;
import com.hover.sdk.permissions.PermissionActivity;

import java.util.Map;

import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;


public class MainActivity extends FlutterActivity {

    // Hover Action function
    private static final String CHANNEL = "kikoba.co.tz/hover";
    String sessionTextssArr;
    private  void SendMoney(String number,String money, String userid, String storeid, String amountdata, String byuser, String usernum){
        try {
            Hover.initialize(this);
            Log.d("MainActivity", "Sims are = " + Hover.getPresentSims(this));
            Log.d("MainActivity", "Hover actions are = " + Hover.getAllValidActions(this));
        } catch (Exception e) {
            Log.e("MainActivity", "hover exception", e);

        }

        //add your action Id from dashboard
        Intent i = new HoverParameters.Builder(this)
                .request("c13dbc1f")
                .extra("number", number)
                .extra("money", money)
                .buildIntent();

        startActivityForResult(i,0);
    }
    @Override
    protected void onActivityResult (int requestCode, int resultCode, Intent data) {
        if (requestCode == 0 && resultCode == Activity.RESULT_OK) {
            String[] sessionTextArr = data.getStringArrayExtra("session_messages");
            sessionTextssArr = sessionTextArr[sessionTextArr.length-1];
            Toast.makeText(this, "Error: " +  sessionTextArr[sessionTextArr.length-1], Toast.LENGTH_LONG).show();

            String uuid = data.getStringExtra("uuid");
        } else if (requestCode == 0 && resultCode == Activity.RESULT_CANCELED) {
            Toast.makeText(this, "Error: " + data.getStringExtra("error"), Toast.LENGTH_LONG).show();
        }
    }
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        Hover.initialize(this);
        //  startActivityForResult(new Intent(this, PermissionActivity.class), 0);



        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
// Get arguments from flutter code
                    final Map<String,Object> arguments = call.arguments();
                    String number = (String) arguments.get("number");
                    String money = (String) arguments.get("money");
                    String userid = (String) arguments.get("userid");
                    String storeid = (String) arguments.get("storeid");
                    String amountdata = (String) arguments.get("amountdata");
                    String byuser = (String) arguments.get("byuser");
                    String usernum = (String) arguments.get("usernum");
                    if (call.method.equals("sendMoney")) {
                        SendMoney(number,money,userid,storeid,amountdata,byuser,usernum);
                        String response = result.toString();
                        result.success(response);
                    }
                });
    }
}


// import android.util.Log;
// import androidx.annotation.NonNull;
// import io.flutter.embedding.android.FlutterActivity;
// import io.flutter.embedding.engine.FlutterEngine;
// import io.flutter.plugin.common.MethodChannel;

// class MainActivity : FlutterActivity() {
//     private val CHANNEL = "com.example.flutter/device_info"; // Unique Channel

//     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//         super.configureFlutterEngine(flutterEngine);

//         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//             // Note: this method is invoked on the main thread.
//             call, result -> {

//             }


//         }
//     }

// }