package com.jianglei.tomato_work;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import java.util.ArrayList;
import java.util.List;

/**
 * @author longyi created on 19-8-27
 */
public class TickService extends Service {
    private TickBinder binder = new TickBinder();
    private TickProvider tickProvider = new TickProvider();
    private List<TickProvider.OnTickListener> onTickListeners = new ArrayList<>();
    private List<TickProvider.OnStatusChangeListener> onStatusChangeListeners = new ArrayList<>();
    private int notificationId = 100;

    @androidx.annotation.Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        int res = super.onStartCommand(intent, flags, startId);
        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(this);
        createNotificationChannel();
        tickProvider.setOnTickListener((timeStr, isWork) -> {
            notificationManagerCompat.notify(notificationId, createNotification(timeStr));
            notifyTick(timeStr, isWork);
        });
        tickProvider.setOnStatusChangeListener(new TickProvider.OnStatusChangeListener() {
            @Override
            public void onWorkStart() {
                for (TickProvider.OnStatusChangeListener listener : onStatusChangeListeners) {
                    listener.onWorkStart();
                }

            }

            @Override
            public void onWorkEnd() {
                for (TickProvider.OnStatusChangeListener listener : onStatusChangeListeners) {
                    listener.onWorkEnd();
                }

            }

            @Override
            public void onCancel() {
                for (TickProvider.OnStatusChangeListener listener : onStatusChangeListeners) {
                    listener.onCancel();
                }
                notificationManagerCompat.notify(notificationId, createNotification(""));

            }

            @Override
            public void onRestStart() {
                for (TickProvider.OnStatusChangeListener listener : onStatusChangeListeners) {
                    listener.onRestStart();
                }


            }

            @Override
            public void onRestEnd() {
                for (TickProvider.OnStatusChangeListener listener : onStatusChangeListeners) {
                    listener.onRestEnd();
                }
            }
        });

        startForeground(notificationId, createNotification(""));
        return res;
    }


    /**
     * 获取一个通知
     *
     * @param timeStr
     * @return
     */
    private Notification createNotification(String timeStr) {

        String content;
        if (tickProvider.getStatus() == TickProvider.STATUS_REST) {
            content = getString(R.string.notification_content_rest, timeStr);
        } else if (tickProvider.getStatus() == TickProvider.STATUS_WORK) {
            content = getString(R.string.notification_content_work, timeStr);
        } else {
            content = getString(R.string.notification_content_default);

        }
        return new NotificationCompat.Builder(this, "tick")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(content)
                .build();
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = getString(R.string.channel_name);
            String description = getString(R.string.channel_desc);
            int importance = NotificationManager.IMPORTANCE_LOW;
            NotificationChannel channel = new NotificationChannel("tick", name, importance);
            channel.setDescription(description);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private void notifyTick(String timeStr, boolean isWork) {
        for (TickProvider.OnTickListener tickListener : onTickListeners) {
            tickListener.onTick(timeStr, isWork);
        }
    }

    public class TickBinder extends Binder {
        public TickService getService() {
            return TickService.this;
        }
    }

    public void addTickListener(TickProvider.OnTickListener onTickListener) {
        onTickListeners.add(onTickListener);
    }

    public void removeTickListener(TickProvider.OnTickListener onTickListener) {
        onTickListeners.remove(onTickListener);
    }

    public void addStatusChangeListener(TickProvider.OnStatusChangeListener listener){
        onStatusChangeListeners.add(listener);
    }

    public void removeStatusChangeListener(TickProvider.OnStatusChangeListener listener){
        onStatusChangeListeners.remove(listener);
    }

    public void startWork(int time) {
        tickProvider.startWork(time);
    }

    public void startRest(int time) {
        tickProvider.startRest(time);
    }

    public void cancelWork() {
        tickProvider.cancel();
    }

    public void stopService() {
        stopSelf();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        tickProvider.cancel();
    }
}
