package com.jianglei.tomato_work;

import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.health.TimerStat;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private MethodChannel methodChannel;

    private TickService tickService;

    private TickProvider.OnTickListener onTickListener = new TickProvider.OnTickListener() {
        @Override
        public void onTick(String timeStr, boolean isWork) {
            if (methodChannel == null) {
                return;
            }
            //通知flutter更新ui
            Map<String, String> args = new HashMap<>();
            args.put("timeStr", timeStr);
            args.put("isWork", isWork ? "true" : "false");
            methodChannel.invokeMethod("update", args);
        }
    };
    private TickProvider.OnStatusChangeListener onStatusChangeListener = new TickProvider.OnStatusChangeListener() {
        @Override
        public void onWorkStart() {
            if(methodChannel == null){
                return;
            }
            methodChannel.invokeMethod("onWorkStart",null);
        }

        @Override
        public void onWorkEnd() {
            methodChannel.invokeMethod("onWorkEnd",null);

        }

        @Override
        public void onCancel() {
            methodChannel.invokeMethod("onCancel",null);

        }

        @Override
        public void onRestStart() {
            methodChannel.invokeMethod("onRestStart",null);

        }

        @Override
        public void onRestEnd() {

            methodChannel.invokeMethod("onRestEnd",null);
        }
    };
    private ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            TickService.TickBinder tickBinder = (TickService.TickBinder) service;
            tickService = tickBinder.getService();
            tickService.addTickListener(onTickListener);
            tickService.addStatusChangeListener(onStatusChangeListener);
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intent = new Intent(this, TickService.class);
        bindService(intent, serviceConnection, BIND_AUTO_CREATE);
        GeneratedPluginRegistrant.registerWith(this);
        methodChannel = new MethodChannel(getFlutterView(), ChannelConst.TICK_SERVICE);
        methodChannel.setMethodCallHandler((methodCall, result) -> {
            if (methodCall.method.equals("startWork")) {
                Log.d("longyi","接收到flutter调用：startWork");
                Integer time = methodCall.argument("tomatoTime");
                if (time == null) {
                    time = 25;
                }
                startWork(time);
            } else if (methodCall.method.equals("startRest")) {
                Log.d("longyi","接收到flutter调用：startRest");
                Integer time = methodCall.argument("restTime");
                if (time == null) {
                    time = 5;
                }
                startRest(time);

            }else if(methodCall.method.equals("cancel")){
                Log.d("longyi","接收到flutter调用：cancel");
                cancel();
            }

        });
    }

    private void startWork(int tomatoTime) {
        if (tickService == null) {
            return;
        }
        tickService.startWork(tomatoTime);
    }

    private void startRest(int restTime) {
        if (tickService == null) {
            return;
        }
        tickService.startRest(restTime);

    }

    private void cancel(){
        if(tickService == null){
            return;
        }
        tickService.cancelWork();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unbindService(serviceConnection);
        if(tickService != null){
            tickService.removeTickListener(onTickListener);
            tickService.removeStatusChangeListener(onStatusChangeListener);
        }

    }
}
