package com.jianglei.tomato_work;


import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.FrameLayout;

import com.r0adkll.slidr.Slidr;
import com.r0adkll.slidr.model.SlidrConfig;
import com.r0adkll.slidr.model.SlidrPosition;

import io.flutter.app.FlutterActivity;
import io.flutter.view.FlutterMain;

public class ScreenLockActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        FlutterMain.startInitialization(getApplicationContext());
        super.onCreate(savedInstanceState);

        //屏蔽系统的锁屏界面，将此activity设置为锁屏界面
        this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
                | WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED);
        setContentView(R.layout.activity_screen_lock);
        setRightSlide();
//        View mFlutterView = Flutter.createView(this, getLify, "main_flutter");
//        FrameLayout.LayoutParams mParams = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT,
//                FrameLayout.LayoutParams.MATCH_PARENT);
//        addContentView(mFlutterView, mParams);
    }
    //右滑解锁
    private void setRightSlide(){
        SlidrConfig config = new SlidrConfig.Builder()
                .position(SlidrPosition.LEFT)
                .sensitivity(1f)
                .scrimColor(Color.BLACK)
                .scrimStartAlpha(0.8f)
                .scrimEndAlpha(0f)
                .velocityThreshold(2400)
                .distanceThreshold(0.5f)
                .build();
        Slidr.attach(this, config);
    }

    @Override
    public void onUserLeaveHint() {
        //用户手动点击Home键或者手动切换app时，此方法会被调用，在这里销毁掉此界面。
        this.finish();
        super.onUserLeaveHint();
        Log.d("longyi","退出锁屏界面");
    }

    @Override
    public void onBackPressed() {
//        super.onBackPressed();    屏蔽返回按钮
    }

}
