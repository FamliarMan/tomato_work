package com.jianglei.tomato_work;

import android.os.CountDownTimer;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

/**
 * @author longyi created on 19-8-27
 */
public class TickProvider {

    public static final int STATUS_WORK = 0;
    public static final int STATUS_REST = 1;
    /**
     * 初始状态
     */
    public static final int STATUS_INIT = 2;

    /**
     * 某次计时结束状态
     */
    public static final int STATUS_TICK_END = 3;

    private int curStatus = STATUS_INIT;
    private CountDownTimer curTimer;
    private OnStatusChangeListener onStatusChangeListener;
    private OnTickListener onTickListener;

    /**
     * 开始计时
     *
     * @param time 此次计时总时间
     */
    private void startTick(int time, boolean isWork) {
        if (curTimer != null) {
            curTimer.cancel();
        }

        Calendar c = Calendar.getInstance();
        c.set(Calendar.HOUR, 0);
        c.set(Calendar.MINUTE, time);
        c.set(Calendar.SECOND, 0);
        SimpleDateFormat sdf = new SimpleDateFormat("mm:ss", Locale.CHINA);
        curTimer = new CountDownTimer(time * 60 * 1000,
                1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                if (onTickListener == null) {
                    return;
                }
                c.add(Calendar.SECOND, -1);
                String timeStr = sdf.format(c.getTime());
                onTickListener.onTick(timeStr, isWork);
            }

            @Override
            public void onFinish() {
                curStatus = STATUS_TICK_END;
                if (onStatusChangeListener != null) {
                    if (isWork) {
                        onStatusChangeListener.onWorkEnd();
                    } else {
                        onStatusChangeListener.onRestEnd();
                    }
                }
            }
        };
        curTimer.start();
    }

    /**
     * 开始番茄工作
     *
     * @param tomatoTime 一次番茄工作计时，单位分钟
     */
    public void startWork(int tomatoTime) {
        if (curStatus == STATUS_WORK) {
            return;
        }
        curStatus = STATUS_WORK;
        startTick(tomatoTime, true);
        if (onStatusChangeListener != null) {
            onStatusChangeListener.onWorkStart();
        }
    }

    /**
     * 开启休息时间
     *
     * @param restTime 休息总时间，单位分钟
     */
    public void startRest(int restTime) {
        if (curStatus == STATUS_REST) {
            return;
        }
        curStatus = STATUS_REST;
        startTick(restTime, false);
        if (onStatusChangeListener != null) {
            onStatusChangeListener.onRestStart();
        }
    }

    /**
     * 取消计时
     */
    public void cancel() {
        if (curTimer == null) {
            return;
        }
        curTimer.cancel();
        curStatus = STATUS_INIT;
        if (onStatusChangeListener != null) {
            onStatusChangeListener.onCancel();
        }
    }


    public void setOnStatusChangeListener(OnStatusChangeListener onStatusChangeListener) {
        this.onStatusChangeListener = onStatusChangeListener;
    }

    public void setOnTickListener(OnTickListener onTickListener) {
        this.onTickListener = onTickListener;
    }

    public int getStatus() {
        return curStatus;
    }

    interface OnTickListener {
        /**
         * 倒计时回调
         *
         * @param timeStr 格式化好的数据，比如12:21
         * @param isWork  当前倒计时时间段是工作还是休息
         */
        void onTick(String timeStr, boolean isWork);
    }


    interface OnStatusChangeListener {
        /**
         * 一次番茄工作开始
         */
        void onWorkStart();

        /**
         * 一次番茄工作结束
         */
        void onWorkEnd();

        /**
         * 计时被取消
         */
        void onCancel();

        /**
         * 一次休息开始，会在{@link OnStatusChangeListener#onWorkEnd()} 之后调用
         */
        void onRestStart();

        /**
         * 一次休息时间结束，会在{@link OnStatusChangeListener#onWorkStart()} 之前调用
         */
        void onRestEnd();
    }
}
