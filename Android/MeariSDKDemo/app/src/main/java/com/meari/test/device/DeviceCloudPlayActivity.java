package com.meari.test.device;

import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.util.DisplayMetrics;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.meari.sdk.CloudPlayerController;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.VideoTimeRecord;
import com.meari.sdk.callback.ICloudAlarmMessageTimeCallback;
import com.meari.sdk.callback.ICloudGetVideoCallback;
import com.meari.sdk.callback.ICloudPlayerCallback;
import com.meari.sdk.callback.ICloudVideoTimeRecordCallback;
import com.meari.sdk.utils.Logger;
import com.meari.test.R;
import com.ppstrong.weeye.widget.media.IjkVideoView;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.time.Year;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class DeviceCloudPlayActivity extends AppCompatActivity implements ICloudPlayerCallback {

    private String TAG = this.getClass().getSimpleName();
    private Button btnScreenshot, btnRecord;
    private CameraInfo cameraInfo;
    private ImageView imgMute;

    private IjkVideoView mVideoView;
    private CloudPlayerController cloudPlayerController;

    private List<VideoTimeRecord> mVideoRecordList;
    private int mYear;
    private int mMonth;
    private int mDay;

    public static final String DOCUMENT_PATH = Environment.getExternalStorageDirectory().getAbsolutePath() + "/xtest/media";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_device_cloud_play);
        initData();
        initView();
    }

    private void initData() {
        if (getIntent().getExtras() != null) {
            cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        }
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

        FrameLayout layout_video_view = findViewById(R.id.layout_video_view);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) layout_video_view.getLayoutParams();
        params.width = width;
        params.height = width * 9 / 16;
        layout_video_view.setLayoutParams(params);

        btnScreenshot = findViewById(R.id.btn_screenshot);
        btnRecord = findViewById(R.id.btn_record);
        imgMute = findViewById(R.id.img_mute);

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

        mVideoView = findViewById(R.id.video_view);
        // 开启移动和缩放
        mVideoView.enableMoveAndScale();

        if (cloudPlayerController == null) {
            cloudPlayerController = new CloudPlayerController(DeviceCloudPlayActivity.this, mVideoView, this);
        }

        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH) + 1;
        int day = calendar.get(Calendar.DATE);

        getCloudVideoTimeRecordInDay(year, month, day);
        postEventTime(year, month, day);

    }

    private int mCurIndex;

    private void getCloudVideoTimeRecordInDay(int year, int month, int day) {
        mYear = year;
        mMonth = month;
        mDay = day;
        MeariUser.getInstance().getCloudVideoTimeRecordInDay(String.valueOf(cameraInfo.getDeviceID()),
                year, month, day, "", new ICloudVideoTimeRecordCallback() {
                    @Override
                    public void onSuccess(String yearMonthDay, ArrayList<VideoTimeRecord> recordList) {
                        if (recordList == null || recordList.size() <= 0) {
                            Logger.i(TAG, "getCloudVideoTimeRecordInDay: have no record");
                        } else {
                            mVideoRecordList = recordList;
                            mCurIndex = getIndex(recordList);
                            getCloudVideo(mCurIndex);
                        }

                    }

                    @Override
                    public void onError(int errorCode, String errorMsg) {
                        Logger.i(TAG, "getCloudVideoTimeRecordInDay--errorCode：" + errorCode + "; errorMsg: " + errorMsg);
                    }
                });
    }

    private int getIndex(ArrayList<VideoTimeRecord> recordList) {
        Logger.i(TAG, "getCloudVideoTimeRecordInDay--size: " + recordList.size());
        VideoTimeRecord videoInfo = recordList.get(0);
        int min = videoInfo.StartHour * 60 + videoInfo.StartMinute;
        int index = min / 30;
        return index;
    }

    private void getCloudVideo(int index) {
        MeariUser.getInstance().getCloudVideo(String.valueOf(cameraInfo.getDeviceID()), index, mYear, mMonth, mDay, "",
                new ICloudGetVideoCallback() {
                    @Override
                    public void onSuccess(String videoInfo, String startTime, String endTime) {
                        toM3U8(videoInfo, startTime, endTime);
                    }

                    @Override
                    public void onError(int errorCode, String errorMsg) {
                        Logger.i(TAG, "getCloudVideo--errorCode：" + errorCode + "; errorMsg: " + errorMsg);
                    }
                });
    }

    private String mSeekString = "";

    private void toM3U8(String content, String startTime, String endTime) {

        String path = getExternalCacheDir().getAbsolutePath() + System.currentTimeMillis() + ".m3u8";
        File file = new File(path);
        if (file.exists()) {
            file.delete();
        }
        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            FileOutputStream fileOutputStream = new FileOutputStream(file, true);
            fileOutputStream.write(content.getBytes());
            fileOutputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Logger.i(TAG, "cameraPlayer-云回放开始-mSeekString：" + mSeekString + "; startTime: " + startTime + "; endTime: " + endTime);


        if (mVideoRecordList != null && mVideoRecordList.size() > 0) {
            VideoTimeRecord video = mVideoRecordList.get(0);
            mSeekString = String.format(Locale.CHINA, "%04d%02d%02d%02d%02d%02d", mYear, mMonth, mDay,
                    video.StartHour, video.StartMinute, video.StartSecond);
        }
        cloudPlayerController.play(path, mSeekString);
    }

    private void postEventTime(int year, int month, int day) {
        String format = "%d%02d%02d";
        String deviceID = String.valueOf(cameraInfo.getDeviceID());
        String alertDate = String.format(Locale.CHINA, format, year, month, day);
        MeariUser.getInstance().getCloudAlarmMessageTimeForDate(deviceID, alertDate, "", new ICloudAlarmMessageTimeCallback() {
            @Override
            public void onSuccess(ArrayList<VideoTimeRecord> videoTimeList) {
                // alarm event list
            }

            @Override
            public void onError(int code, String error) {

            }
        });
    }


    private void toastSuccess() {
        runOnUiThread(() -> Toast.makeText(DeviceCloudPlayActivity.this, R.string.toast_success, Toast.LENGTH_LONG).show());
    }

    private void toastFailed() {
        runOnUiThread(() -> Toast.makeText(DeviceCloudPlayActivity.this, R.string.toast_fail, Toast.LENGTH_LONG).show());

    }

    private void showToast(String string) {
        runOnUiThread(() -> Toast.makeText(DeviceCloudPlayActivity.this, string, Toast.LENGTH_LONG).show());
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {

        }
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    public void finish() {
        cloudPlayerController.stop();
        super.finish();
    }

    private void screenshot() {
        String path = DOCUMENT_PATH + "/" + System.currentTimeMillis() + ".jpg";
        cloudPlayerController.screenshot(path);
    }

    private boolean isRecording = false;

    private void startRecordMP4() {
        String path = DOCUMENT_PATH + "/" + System.currentTimeMillis() + ".mp4";
        cloudPlayerController.startRecordMP4(path);

        isRecording = true;
    }

    // Need to record more than 3 seconds, otherwise it is easy to fail
    private void stopRecordMP4() {
        cloudPlayerController.stopRecordMP4();

        isRecording = false;
    }

    private boolean isMute = false;

    private void setMute(boolean mute) {
        cloudPlayerController.setMute(mute);
        isMute = mute;
    }

    @Override
    public void mediaPlayingCallback() {
        // Play successfully callback
    }

    @Override
    public void mediaPauseCallback() {
        // Play pause callback
    }

    @Override
    public void upDateProgress(long l) {
        // play time
    }

    @Override
    public void mediaPlayFailedCallback() {
        //Play failed callback
    }

    @Override
    public void playNext() {
        // One part for half an hour, 24 parts a day in total, after the playback is complete, get the next part
        int nexIndex = getNextIndex(mCurIndex);
        if (mCurIndex < nexIndex) {
            mCurIndex = nexIndex;
            getCloudVideo(mCurIndex);
        }
    }

    private int getNextIndex(int curIndex) {
        if (mVideoRecordList.size() == 0) {
            return curIndex;
        }
        for (int i = curIndex + 1; i < 47; i++) {
            if (isHasVideoByIndex(i)) {
                return i;
            }
        }
        return curIndex;
    }

    private boolean isHasVideoByIndex(int index) {
        int startTime = 1800 * index;
        int endTime = 1800 * (index + 1);
        if (mVideoRecordList.size() == 0) {
            return false;
        } else {
            for (int i = 0; i < mVideoRecordList.size(); i++) {
                VideoTimeRecord videoInfo = mVideoRecordList.get(i);
                int videoStartTime = videoInfo.StartHour * 3600 + videoInfo.StartMinute * 60 + videoInfo.StartSecond;
                int videoEndTime = videoInfo.EndHour * 3600 + videoInfo.EndMinute * 60 + videoInfo.EndSecond;
                if (startTime > videoEndTime || endTime < videoStartTime) {
                    continue;
                } else {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public void stopRecordVideo() {

    }

    @Override
    public void showStopRecordVideoView(String s) {
        if (s.length() > 0) {
            showToast("Recording successful");
        } else {
            showToast("Recording failed");
        }
    }

    @Override
    public void screenshotSuccess(String s) {
        if (s.length() > 0) {
            showToast("Screenshot successful");
        } else {
            showToast("Screenshot failed");
        }
    }
}