package com.meari.test.device;

import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.meari.sdk.MeariDeviceController;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.callback.IDeviceAlarmMessageTimeCallback;
import com.meari.sdk.callback.IPlaybackDaysCallback;
import com.meari.sdk.json.BaseJSONArray;
import com.meari.sdk.listener.MeariDeviceListener;
import com.meari.sdk.listener.MeariDeviceRecordMp4Listener;
import com.meari.sdk.listener.MeariDeviceTalkVolumeListener;
import com.meari.sdk.listener.MeariDeviceVideoStopListener;
import com.meari.sdk.utils.Logger;
import com.meari.sdk.utils.MeariDeviceUtil;
import com.meari.test.R;
import com.meari.test.user.CloudStatusActivity;
import com.ppstrong.ppsplayer.PPSGLSurfaceView;
import com.ppstrong.ppsplayer.VideoTimeRecord;

import org.json.JSONException;

import java.io.File;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Locale;

public class DeviceMonitorActivity extends AppCompatActivity {

    private Button btnPreview, btnPlayback, btnCloudPlayback, btnCloudService, btnSetting, btnScreenshot, btnRecord;
    private boolean isReady = false;
    private PPSGLSurfaceView videoSurfaceView;
    private CameraInfo cameraInfo;
    private MeariDeviceController deviceController;
    private ImageView imgMute, imgSpeak;

    private int position = 0;// 0-preview; 1-playback;

    public static final String DOCUMENT_PATH = Environment.getExternalStorageDirectory().getAbsolutePath() + "/xtest/media";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_monitor);
        initData();
        initView();
    }

    private void initData() {
        if (getIntent().getExtras() != null) {
            cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        }
        deviceController = new MeariDeviceController();
        deviceController.setCameraInfo(cameraInfo);

        // Set the device to be controlled
        MeariUser.getInstance().setCameraInfo(cameraInfo);
        MeariUser.getInstance().setController(deviceController);

//        cameraInfo.setBps(4010);
//        getVideoId(cameraInfo);

    }

    private void initView() {
        File file = new File(DOCUMENT_PATH);
        if (!file.exists()) {
            file.mkdirs();
        }

        DisplayMetrics localDisplayMetrics = getResources()
                .getDisplayMetrics();
        int widthDisplay = localDisplayMetrics.widthPixels;
        int heightDisplay = localDisplayMetrics.heightPixels;
        int width = widthDisplay < heightDisplay ? widthDisplay : heightDisplay;
        int height = heightDisplay > widthDisplay ? heightDisplay : widthDisplay;

        LinearLayout ll_video_view = findViewById(R.id.ll_video);
        videoSurfaceView = new PPSGLSurfaceView(this, width, height);
        videoSurfaceView.setKeepScreenOn(true);
        ll_video_view.addView(videoSurfaceView);

        btnPreview = findViewById(R.id.btn_preview);
        btnPlayback = findViewById(R.id.btn_playback);
        btnCloudPlayback = findViewById(R.id.btn_cloud_playback);
        btnCloudService = findViewById(R.id.btn_cloud_service);
        btnSetting = findViewById(R.id.btn_setting);
        btnScreenshot = findViewById(R.id.btn_screenshot);
        btnRecord = findViewById(R.id.btn_record);
        imgMute = findViewById(R.id.img_mute);
        imgSpeak = findViewById(R.id.img_speak);

        btnPreview.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (position == 0) {
                    return;
                }
                stopPlaybackSDCard();
                startPreview();
                position = 0;
            }
        });

        btnPlayback.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (position == 1) {
                    return;
                }
                stopPreview();
                playback();
                position = 1;
            }
        });

        // Whether to support cloud storage service
        if (cameraInfo.getCst() > 0) {
            btnCloudPlayback.setVisibility(View.VISIBLE);
            btnCloudService.setVisibility(View.VISIBLE);
        } else {
            btnCloudPlayback.setVisibility(View.GONE);
            btnCloudService.setVisibility(View.GONE);
        }

        btnCloudPlayback.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DeviceMonitorActivity.this, DeviceCloudPlayActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable("cameraInfo", cameraInfo);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        btnCloudService.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(DeviceMonitorActivity.this, CloudStatusActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable("cameraInfo", cameraInfo);
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        btnScreenshot.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                screenshot();
            }
        });

        btnRecord.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isRecording) {
                    stopRecordMP4();
                } else {
                    startRecordMP4();
                }
            }
        });

        btnSetting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!isReady) {
                    return;
                }
                Intent intent = new Intent(DeviceMonitorActivity.this, DeviceSettingActivity.class);
                Bundle bundle = new Bundle();
                bundle.putSerializable("cameraInfo", cameraInfo);
                intent.putExtras(bundle);
                startActivityForResult(intent, 100);
            }
        });

        imgMute.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isMute) {
                    setMute(false);
                    imgMute.setImageResource(R.drawable.btn_camera_preview_volume_selected);
                } else {
                    setMute(true);
                    imgMute.setImageResource(R.drawable.btn_camera_preview_mute_normal);
                }
            }
        });

        imgSpeak.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isTalking) {
                    stopVoiceTalk();
                    imgSpeak.setImageResource(R.drawable.ic_pronunciation_n);
                } else {
                    startVoiceTalk();
                    imgSpeak.setImageResource(R.drawable.ic_pronunciation_p);
                }
            }
        });

        // connect Device
        connect();
    }

    private void toastSuccess() {
        runOnUiThread(() -> Toast.makeText(DeviceMonitorActivity.this, R.string.toast_success, Toast.LENGTH_LONG).show());
    }

    private void toastFailed() {
        runOnUiThread(() -> Toast.makeText(DeviceMonitorActivity.this, R.string.toast_fail, Toast.LENGTH_LONG).show());

    }

    private void showToast(String string) {
        Toast.makeText(DeviceMonitorActivity.this, string, Toast.LENGTH_LONG).show();
    }

    private void connect() {
        deviceController.startConnect(new MeariDeviceListener() {
            @Override
            public void onSuccess(String successMsg) {
                isReady = true;
                if (position == 0) {
                    startPreview();
                } else {
                    startPlaybackSDCard();
                }
                // 保存设备信息和控制器
                MeariUser.getInstance().setCameraInfo(cameraInfo);
                MeariUser.getInstance().setController(deviceController);
            }

            @Override
            public void onFailed(String errorMsg) {

            }
        });
    }

    private void startPreview() {
        if (deviceController.isConnected()) {
            deviceController.startPreview(videoSurfaceView, 0, new MeariDeviceListener() {
                @Override
                public void onSuccess(String successMsg) {
                    toastSuccess();
                    setMute(isMute);
                }

                @Override
                public void onFailed(String errorMsg) {
                    toastFailed();
                }
            }, new MeariDeviceVideoStopListener() {
                @Override
                public void onVideoClosed(int code) {

                }
            });
        } else {
            connect();
        }

    }

    private void stopPreview() {
        deviceController.stopPreview(new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {

            }

            @Override
            public void onFailed(String s) {

            }
        });
    }

    private void playback() {
        getDayOfMonth(2020, 6);
        getVideoRecordByDay(2020, 6, 8);
        getEventTime(2020, 6, 8);
    }

    private void getDayOfMonth(int year, int month) {
        // Get the date of the video in a month
        deviceController.getPlaybackVideoDaysInMonth(year, month, 0, new IPlaybackDaysCallback() {
            @Override
            public void onSuccess(ArrayList<Integer> arrayList) {

            }

            @Override
            public void onFailed(String s) {

            }
        });
    }

    private void getVideoRecordByDay(int year, int month, int day) {
        // Get a video clip of a day
        deviceController.getPlaybackVideoTimesInDay(year, month, day, 0, new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {

//                ArrayList<VideoTimeRecord> list = getVideoRecords(s);
                ArrayList<VideoTimeRecord> list = MeariDeviceUtil.getSDCardVideoRecords(s);
                mVideoList.clear();
                mVideoList.addAll(list);
                startPlaybackSDCard();
            }

            @Override
            public void onFailed(String s) {

            }
        });
    }

    private ArrayList<VideoTimeRecord> getVideoRecords(String record) {
        ArrayList<VideoTimeRecord> records = new ArrayList<>();
        try {
            BaseJSONArray jsonArray = new BaseJSONArray(record);
            for (int i = 0; i < jsonArray.length(); i++) {
                VideoTimeRecord vtr = new VideoTimeRecord();
                String str = jsonArray.get(i).toString();
                String[] subStr = str.split("-");
                if (subStr.length != 2) {
                    continue;
                }
                vtr.StartHour = Integer.parseInt(subStr[0].substring(0, 2));
                vtr.StartMinute = Integer.parseInt(subStr[0].substring(2, 4));
                vtr.StartSecond = Integer.parseInt(subStr[0].substring(4, 6));
                vtr.EndHour = Integer.parseInt(subStr[1].substring(0, 2));
                vtr.EndMinute = Integer.parseInt(subStr[1].substring(2, 4));
                vtr.EndSecond = Integer.parseInt(subStr[1].substring(4, 6));
                records.add(vtr);
            }
        } catch (JSONException e) {
            Logger.e(getClass().getName(), e.getMessage());
        }
        return records;
    }

    ArrayList<VideoTimeRecord> mVideoList = new ArrayList<>();

    private void getEventTime(int year, int month, int day) {
        // Alarm event time segment
        String deviceID = String.valueOf(cameraInfo.getDeviceID());
        String format = "%d%02d%02d";
        String dayTime = String.format(Locale.CHINA, format, year, month, day);
        MeariUser.getInstance().getDeviceAlarmMessageTimeForDate(deviceID, dayTime, new IDeviceAlarmMessageTimeCallback() {
            @Override
            public void onSuccess(ArrayList<VideoTimeRecord> arrayList) {

            }

            @Override
            public void onError(int i, String s) {

            }
        });
    }


    private void startPlaybackSDCard() {
        VideoTimeRecord videoTime = mVideoList.get(0);
        String playtime = "";
        playtime = String.format(Locale.CHINA, "%04d%02d%02d%02d%02d%02d", 2020, 6, 8, videoTime.StartHour, videoTime.StartMinute, videoTime.StartSecond);

//        ArrayList<Integer> videoIdList = getVideoId(cameraInfo);
        ArrayList<Integer> videoIdList = MeariDeviceUtil.getVideoStreamId(cameraInfo);

        if (deviceController.isConnected()) {
            deviceController.startPlaybackSDCard(videoSurfaceView, videoIdList.get(0), playtime,
                    new MeariDeviceListener() {
                        @Override
                        public void onSuccess(String s) {
                            toastSuccess();
                            setMute(isMute);
                        }

                        @Override
                        public void onFailed(String s) {
                            toastFailed();
                        }
                    }, new MeariDeviceVideoStopListener() {
                        @Override
                        public void onVideoClosed(int i) {

                        }
                    });
        }
    }

    public static ArrayList<Integer> getVideoId(CameraInfo cameraInfo) {
        ArrayList<Integer> strings = new ArrayList<>();
        if (cameraInfo.getBps() > 0) {
            int bps = cameraInfo.getBps();
            BigInteger bi = new BigInteger(String.valueOf(bps));
            String str = bi.toString(2);
            for (int i = str.length() - 1; i >= 0; i--) {
                if (String.valueOf(str.charAt(i)).equals("1")) {
                    strings.add(str.length() - 1 - i);
                }
            }
        } else {
            strings.add(0);
            strings.add(1);
        }

        for (int i = 0; i < strings.size(); i++) {
            Log.i("tag", "--bps: " + strings.get(i));
        }


        return strings;
    }

    private void stopPlaybackSDCard() {
        deviceController.stopPlaybackSDCard(new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {

            }

            @Override
            public void onFailed(String s) {

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (deviceController != null && deviceController.isConnected()) {
                if (position == 0) {
                    startPreview();
                } else {
                    startPlaybackSDCard();
                }
            } else {
                connect();
            }
        }
    }

    @Override
    protected void onStop() {
        if (position == 0) {
            deviceController.stopPreview(new MeariDeviceListener() {
                @Override
                public void onSuccess(String s) {

                }

                @Override
                public void onFailed(String s) {

                }
            });
        } else {
            deviceController.stopPlaybackSDCard(new MeariDeviceListener() {
                @Override
                public void onSuccess(String s) {

                }

                @Override
                public void onFailed(String s) {

                }
            });
        }
        super.onStop();
    }

    @Override
    public void finish() {
        deviceController.stopConnect(new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {

            }

            @Override
            public void onFailed(String s) {

            }
        });
        super.finish();
    }

    private void screenshot() {
        String path = DOCUMENT_PATH + "/" + System.currentTimeMillis() + ".jpg";
        deviceController.snapshot(path, new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {
                toastSuccess();
            }

            @Override
            public void onFailed(String s) {
                toastFailed();
            }
        });
    }

    private boolean isRecording = false;

    private void startRecordMP4() {
        String path = DOCUMENT_PATH + "/" + System.currentTimeMillis() + ".mp4";
        deviceController.startRecordMP4(path, new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {
                isRecording = true;
            }

            @Override
            public void onFailed(String s) {
                isRecording = false;
            }
        }, new MeariDeviceRecordMp4Listener() {
            @Override
            public void RecordMp4Interrupt(int i) {
                if (i > 0) {
                    toastSuccess();
                } else {
                    toastFailed();
                }
            }
        });
    }

    // Need to record more than 3 seconds, otherwise it is easy to fail
    private void stopRecordMP4() {
        deviceController.stopRecordMP4(new MeariDeviceListener() {
            @Override
            public void onSuccess(String s) {
                isRecording = false;
                toastSuccess();
            }

            @Override
            public void onFailed(String s) {
                isRecording = false;
                toastFailed();
            }
        });
    }

    private boolean isMute = false;

    private void setMute(boolean mute) {
        deviceController.setMute(mute);
        isMute = mute;
    }

    private boolean isTalking = false;

    public void startVoiceTalk() {

        int talkType = getTalkType(cameraInfo);
        // Manifest.permission.RECORD_AUDIO permission required
        deviceController.startVoiceTalk(talkType, new MeariDeviceListener() {
            @Override
            public void onSuccess(String successMsg) {
                isTalking = true;
                toastSuccess();
            }

            @Override
            public void onFailed(String errorMsg) {
                isTalking = false;
                toastFailed();
            }
        }, new MeariDeviceTalkVolumeListener() {
            @Override
            public void onTalkVolume(int volume) {
                // Intercom volume
            }

            @Override
            public void onFailed(String errorMsg) {
                // No microphone found
            }
        });
    }

    public void stopVoiceTalk() {
        deviceController.stopVoiceTalk(new MeariDeviceListener() {
            @Override
            public void onSuccess(String successMsg) {
                isTalking = false;
                toastSuccess();
            }

            @Override
            public void onFailed(String errorMsg) {
                isTalking = false;
                toastFailed();
            }
        });
    }

    private int getTalkType(CameraInfo cameraInfo) {
        int vtk = cameraInfo.getVtk();
        if (vtk == 0) {
            return 1;
        } else {
            return 2;
        }
    }


}
