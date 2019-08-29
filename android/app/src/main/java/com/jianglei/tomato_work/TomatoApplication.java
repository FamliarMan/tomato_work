package com.jianglei.tomato_work;


import android.content.Intent;
import android.os.Looper;

import io.flutter.app.FlutterApplication;

/**
 * @author longyi created on 19-8-28
 */
public class TomatoApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        Looper.myQueue().addIdleHandler(() -> {
            //空闲情况下启动服务
            Intent intent = new Intent(TomatoApplication.this, TickService.class);
            startService(intent);
            return false;
        });
    }
}
