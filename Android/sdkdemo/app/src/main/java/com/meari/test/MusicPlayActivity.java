package com.meari.test;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.SeekBar;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.MeariMusic;
import com.meari.sdk.bean.SongBean;
import com.meari.sdk.callback.IGetMusicListCallback;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.adapter.SongAdapter;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.widget.CustomDialog;
import com.ppstrong.listener.SongPlayerListener;
import com.ppstrong.listener.SongStatusListener;
import com.ppstrong.listener.SongVolumeListener;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/25
 * 描    述：播放音乐
 * 修订历史：
 * ================================================
 */

public class MusicPlayActivity extends BaseActivity implements SongAdapter.SongPlayCallback {
    private final int MESSAGE_GET_SONG_LIST = 10001;
    private final int MESSAGE_SWITCH_SONG = 10002;
    private final int MESSAGE_GET_VOLUME = 10003;
    private final int MESSAGE_GET_CURCENT_SONG = 10004;
    private final int MESSAGE_PLAY_SUCCESS = 10005;
    private final int MESSAGE_STOP_PLAY_MUSIC = 10006;
    private boolean mPlayStatus = false;
    private String mCurMusicId;
    private String mCurMode;
    private ArrayList<MeariMusic> mListSong = new ArrayList<>();
    @BindView(R.id.song_recyclerView)
    public RecyclerView mRecyclerView;
    public SongAdapter mAdapter;
    @BindView(R.id.text_sound_bar)
    public TextView mTextSeek;
    @BindView(R.id.btn_song_mode)
    public ImageView mModeImage;
    @BindView(R.id.img_sound)
    public ImageView mImg_sound;
    private Dialog mDialog;
    @BindView(R.id.sound_bar)
    public SeekBar mSeekBar;
    @BindView(R.id.btn_left_click)
    public ImageView mBtnLeft;
    @BindView(R.id.btn_right_click)
    public ImageView mBtnNext;
    @BindView(R.id.btn_play_click)
    public ImageView mBtnPlay;
    @BindView(R.id.btn_song_name)
    public TextView mSongName;
    @BindView(R.id.btn_play_status)
    public ProgressBar mProgressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.activity_music);
        initView();
        postSongData();
        getCurrentStatus();
    }

    @OnClick(R.id.btn_play_click)
    public void onPlayClick(View v) {
        if (!SingleVideoActivity.getInstance().getSDCardStatus()) {
            showToast(getString(R.string.no_sdcard));
            return;
        }
        int tag = (int) v.getTag();
        if (tag == 0) {
            if (mCurMusicId != null && !mCurMusicId.isEmpty()) {
                setImagePlayView(1);
                continueMusicPlay(mCurMusicId);
                if (mAdapter != null) {
                    mAdapter.setIsPlay(true);
                    mAdapter.setCurMusicId(mCurMusicId);
                    mAdapter.notifyDataSetChanged();
                }
            }
        } else {
            setImagePlayView(0);
            pauseMusicPlay();
            if (mAdapter != null) {
                mAdapter.setIsPlay(false);
                mAdapter.notifyDataSetChanged();
            }
        }
    }

    public void setImagePlayView(int imagePlayView) {
        int tag = (int) mBtnPlay.getTag();
        if (imagePlayView == tag)
            return;
        if (imagePlayView == 0) {
            this.mBtnPlay.setTag(imagePlayView);
            this.mBtnPlay.setImageResource(R.mipmap.ic_pause_p);
            this.mProgressBar.setVisibility(View.GONE);
        } else {
            this.mBtnPlay.setTag(imagePlayView);
            this.mBtnPlay.setImageResource(R.mipmap.ic_play_status_n);
            this.mProgressBar.setVisibility(View.VISIBLE);
        }
    }

    private void initView() {
        this.mSeekBar.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                mTextSeek.setText(String.valueOf(progress));
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                if (CommonUtils.getSdkUtil() != null) {
                    int value = seekBar.getProgress();
                    setSoundView(value);
                    CommonUtils.getSdkUtil().setDeviceSongVolume(value, new CameraPlayerListener() {
                        @Override
                        public void PPSuccessHandler(String successMsg) {

                        }

                        @Override
                        public void PPFailureError(String errorMsg) {

                        }
                    });
                }
            }
        });
        this.mSeekBar.setEnabled(false);
        this.mImg_sound.setEnabled(false);
        initRecyclerView();
        this.mBtnPlay.setTag(0);
        this.mBtnPlay.setImageResource(R.mipmap.ic_pause_p);
        this.mCenter.setText(R.string.move_music_title);
        this.mModeImage.setEnabled(false);
        mProgressBar.setVisibility(View.GONE);
    }

    public void postSongData() {
        MeariUser.getInstance().getMusicList(this ,new IGetMusicListCallback() {
            @Override
            public void onSuccess(ArrayList<MeariMusic> songInfos) {
                mListSong.clear();
                mListSong.addAll(songInfos);
                if (songInfos.size() > 0 && mCurMusicId == null) {
                    mCurMusicId = songInfos.get(0).getMusicID();
                    mSongName.setText(songInfos.get(0).getMusicName());
                }
                setLeftNextBtnStatus();
                mAdapter.setCurMusicId(mCurMusicId);
                mAdapter.setSongInfos(songInfos);
                mAdapter.notifyDataSetChanged();
                findViewById(R.id.song_loading_iv).setVisibility(View.GONE);
                if (songAnimationDrawable != null)
                    songAnimationDrawable.stop();
                mRecyclerView.setVisibility(View.VISIBLE);
            }

            @Override
            public void onError(int code, String error) {

            }
        });
        getCurrentStatus();
    }

    public void getCurrentStatus() {
        postVolumeData();
        if (mRefreshStatus == null)
            return;
        mRefreshStatus.removeCallbacks(mRefrshSongStatusRunnale);
        mRefreshStatus.postDelayed(mRefrshSongStatusRunnale, 500);
    }


    public CustomDialog showSdDlg(Context context, String title, String message, String positiveBtnName,
                                  DialogInterface.OnClickListener positiveListener, String NegativeBtnName,
                                  DialogInterface.OnClickListener negativeListener, boolean bCance) {
        try {
            CustomDialog.Builder localBuilder = new CustomDialog.Builder(context);
            localBuilder.setTitle(title).setMessage(message);
            localBuilder.setPositiveResouce(R.drawable.shape_big_common_yellow);
            localBuilder.setNegativeResouce(R.drawable.shape_yellow);
            if (positiveBtnName != null)
                localBuilder.setPositiveButton(positiveBtnName, positiveListener);
            if (NegativeBtnName != null)
                localBuilder.setNegativeButton(NegativeBtnName, negativeListener);
            CustomDialog dlg = localBuilder.create();
            dlg.setCancelable(bCance);
            dlg.setCanceledOnTouchOutside(bCance);

            return dlg;
        } catch (Exception e) {
            return null;
        }
    }

    public void postVolumeData() {
        if (CommonUtils.getSdkUtil() != null) {
            CommonUtils.getSdkUtil().queryDeviceSongVolume(new SongVolumeListener() {
                @Override
                public void PPSuccessHandler(int volume) {
                    if (mEventHandler == null)
                        return;
                    Message msg = new Message();
                    msg.what = MESSAGE_GET_VOLUME;
                    msg.arg1 = volume;
                    mEventHandler.sendMessage(msg);

                }

                @Override
                public void PPFailureError(String errorMsg) {
                    if (mEventHandler == null)
                        return;
                    Message msg = new Message();
                    msg.what = MESSAGE_GET_VOLUME;
                    msg.arg1 = 0;
                    mEventHandler.sendMessage(msg);
                }
            });
        }

    }

    public void setSoundView(int sound) {
        mSeekBar.setProgress(sound);
        if (sound == 0) {
            this.mImg_sound.setImageResource(R.mipmap.ic_sound_dis);
        } else {
            this.mImg_sound.setImageResource(R.mipmap.ic_sound_n);
        }
    }

    /**
     * 初始化歌曲RecyclerView
     */
    public void initRecyclerView() {
        View layoutLoading = findViewById(R.id.prodlg_loading_layout);
        layoutLoading.setVisibility(View.VISIBLE);
        ImageView loaigndview = findViewById(R.id.song_loading_iv);
        songAnimationDrawable = (AnimationDrawable) loaigndview.getDrawable();
        songAnimationDrawable.start();
        mAdapter = new SongAdapter(this, null, this);
        this.mRecyclerView.setAdapter(mAdapter);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mRecyclerView.setLayoutManager(linearLayoutManager);
        mRecyclerView.setVisibility(View.GONE);
    }

    private AnimationDrawable songAnimationDrawable;
    private Handler mRefreshStatus = new Handler();

    private Runnable mRefrshSongStatusRunnale = new Runnable() {
        @Override
        public void run() {
            if (CommonUtils.getSdkUtil() != null) {
                postSongStatus();
            }
        }
    };

    public void postSongStatus() {
        CommonUtils.getSdkUtil().querySongStatus(new SongStatusListener() {
            @Override
            public void onSuccess(SongBean songBean) {
                mCurMusicId = songBean.getCurMusicId();
                mPlayStatus = songBean.getPlayStatus();
                mCurMode = songBean.getCurMode();
                ArrayList<MeariMusic> infos = songBean.getList();
                Message msg = new Message();
                msg.what = MESSAGE_GET_SONG_LIST;
                msg.obj = infos;
                if (mEventHandler != null) {
                    mEventHandler.sendMessage(msg);
                }
                if (mRefreshStatus != null)
                    mRefreshStatus.postDelayed(mRefrshSongStatusRunnale, 3000);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                if (mRefreshStatus != null)
                    mRefreshStatus.postDelayed(mRefrshSongStatusRunnale, 3000);
            }
        });
    }

    /**
     * 处理回调消息
     */
    @SuppressLint("HandlerLeak")
    private Handler mEventHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {

            switch (msg.what) {
                case MESSAGE_GET_SONG_LIST:
                    ArrayList<MeariMusic> list = (ArrayList<MeariMusic>) msg.obj;
                    MeariMusic info = getSongNameById(mCurMusicId, list);
                    boolean bNeedRefresh;
                    setModeView(mCurMode);
//                    mModeImage.setEnabled(true);
                    if (info != null && info.getDownload_percent() < 100) {
                        bNeedRefresh = true;
                    } else
                        bNeedRefresh = isNeedFresh(info, mCurMusicId, mPlayStatus);
                    mAdapter.setSongInfos(list);
                    View layoutLoading = findViewById(R.id.song_loading_iv);
                    if (layoutLoading.getVisibility() == View.VISIBLE) {
                        layoutLoading.setVisibility(View.GONE);
                        mRecyclerView.setVisibility(View.VISIBLE);
                    }
                    if (mCurMusicId == null || mCurMusicId.isEmpty()) {
                        if (mAdapter.getSongInfos() != null && mAdapter.getSongInfos().size() > 0) {
                            mCurMusicId = mAdapter.getSongInfos().get(0).getMusicID();
                        }
                    }
                    mAdapter.setCurMusicId(mCurMusicId);
                    mAdapter.setIsPlay(mPlayStatus);
                    if (bNeedRefresh)
                        mAdapter.notifyDataSetChanged();
                    if (info != null)
                        mSongName.setText(info.getMusicName());
                    setImagePlayView(mPlayStatus ? 1 : 0);
                    setLeftNextBtnStatus();
                    break;
                case MESSAGE_GET_CURCENT_SONG:
                    if (mAdapter.getSongInfos() != null) {
                        MeariMusic songinfo = getSongNameById(mCurMusicId, mAdapter.getSongInfos());
                        MeariMusic curInfo = new MeariMusic();
                        curInfo.setMusicID(mCurMusicId);
                        curInfo.setDownload_percent(msg.arg1);
                        curInfo.setIs_playing(mPlayStatus);
                        if (mCurMusicId != null) {
                            if (mCurMusicId.equals(mAdapter.getCurMusicId())) {
                                if (curInfo.equals(songinfo)) {
                                    return;
                                }
                            } else {
                                mAdapter.setCurMusicId(mCurMusicId);
                                mAdapter.isChangeDataBySongInfo(curInfo);
                                mAdapter.notifyDataSetChanged();
                            }
                        } else {
                            mAdapter.setCurMusicId("");
                            mAdapter.changeStopPlayStatus();
                            mAdapter.notifyDataSetChanged();
                        }
                    }
                    break;
                case MESSAGE_SWITCH_SONG:
                    mCurMusicId = (String) msg.obj;
                    showPlaySongView();
                    break;
                case MESSAGE_GET_VOLUME:
                    mSeekBar.setEnabled(true);
                    setSoundView(msg.arg1);
                    break;
                case MESSAGE_PLAY_SUCCESS:
                    String curMusicId = (String) msg.obj;
                    setPlayView(curMusicId, true);
                    break;
                case MESSAGE_STOP_PLAY_MUSIC:
                    mAdapter.setIsPlay(false);
                default:
                    break;
            }
        }
    };

    private void showPlaySongView() {
        MeariMusic info = getSongNameById(mCurMusicId, mListSong);
        if (info != null) {
            mSongName.setText(info.getMusicName());
            setLeftNextBtnStatus();
        }

    }

    public void setPlayView(String musicId, boolean play) {
        if (musicId == null)
            return;
        MeariMusic info = mAdapter.getMusicInfoById(musicId);
        if (info == null)
            return;
        this.mCurMusicId = musicId;
        mAdapter.setCurMusicId(musicId);
        mAdapter.setIsPlay(play);
        if (info != null) {
            info.setIs_playing(play);
            mAdapter.isChangeDataBySongInfo(info);
        }
        if (info != null)
            mSongName.setText(info.getMusicName());
        setImagePlayView(1);
    }

    /**
     * 设置下一首和上一首btn状态
     */
    public void setLeftNextBtnStatus() {
        if (mListSong == null || mListSong.size() == 0) {
            mBtnLeft.setEnabled(false);
            mBtnNext.setEnabled(false);
        } else {
            if (isFirstSong(mCurMusicId)) {
                mBtnLeft.setEnabled(false);
            } else {
                mBtnLeft.setEnabled(true);
            }
            if (isLastSong(mCurMusicId)) {
                mBtnNext.setEnabled(false);
            } else {
                mBtnNext.setEnabled(true);
            }
        }
    }

    public boolean isFirstSong(String songId) {
        if (mListSong != null && mListSong.size() > 0 && mListSong.get(0).getMusicID().equals(songId))
            return true;
        else
            return false;
    }

    public boolean isLastSong(String songId) {
        if (mListSong == null || mListSong == null) {
            return false;
        }
        if (mListSong.get(mListSong.size() - 1).getMusicID().equals(songId)) {
            return true;
        } else
            return false;
    }

    public void continueMusicPlay(final String curMusicId) {
        if (curMusicId == null || curMusicId.isEmpty())
            return;
        this.mCurMusicId = curMusicId;
        CommonUtils.getSdkUtil().continueMusicPlay(curMusicId, new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                try {
                    if (mEventHandler == null)
                        return;
                    if (successMsg == null || successMsg.isEmpty()) {
                        Message msg = new Message();
                        msg.what = MESSAGE_PLAY_SUCCESS;
                        msg.obj = curMusicId;
                        mEventHandler.sendMessage(msg);
                    } else {
                        BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                        String musicId = jsonObject.optString("current_musicID", "");
                        Message msg = new Message();
                        msg.what = MESSAGE_PLAY_SUCCESS;
                        msg.obj = musicId;
                        mEventHandler.sendMessage(msg);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void PPFailureError(String errorMsg) {

            }
        });
    }

    @Override
    public void pauseMusicPlay() {
        CommonUtils.getSdkUtil().pauseMusicPlay(new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                if (mEventHandler != null)
                    mEventHandler.sendEmptyMessage(MESSAGE_STOP_PLAY_MUSIC);
            }

            @Override
            public void PPFailureError(String errorMsg) {

            }
        });


    }

    @OnClick(R.id.btn_left_click)
    public void onBtnLeftClick() {
        if (SingleVideoActivity.getInstance() == null || !SingleVideoActivity.getInstance().getSDCardStatus()) {
            showToast(getString(R.string.no_sdcard));
            return;
        }
        CommonUtils.getSdkUtil().playLastSong(new SongPlayerListener() {


            @Override
            public void PPSuccessHandler(String musicId) {
                Message msg = new Message();
                msg.obj = musicId;
                msg.what = MESSAGE_SWITCH_SONG;
                if (mEventHandler != null)
                    mEventHandler.sendMessage(msg);

            }
            @Override
            public void PPFailureError(String errorMsg) {

            }
        });
    }

    @OnClick(R.id.btn_song_mode)
    public void onSongModeClick() {
        if (CommonUtils.getSdkUtil() == null || mEventHandler == null)
            return;
        if (!SingleVideoActivity.getInstance().getSDCardStatus()) {
            showToast(getString(R.string.no_sdcard));
            return;
        }
        String tag = (String) mModeImage.getTag();
        String mode;
        if (tag.equals("single")) {
            mModeImage.setTag("random");
            setModeView("random");
            mode = "random";
        } else {
            mModeImage.setTag("single");
            setModeView("single");
            mode = "single";
        }
        if (CommonUtils.getSdkUtil() != null && mEventHandler != null) {
            CommonUtils.getSdkUtil().changePlaySongMode(mode, new CameraPlayerListener() {
                @Override
                public void PPSuccessHandler(String successMsg) {
                    try {
                        BaseJSONObject jsonObject = new BaseJSONObject(successMsg);
                        String current_musicID = jsonObject.optString("current_musicID");
                        Message msg = new Message();
                        msg.what = MESSAGE_PLAY_SUCCESS;
                        msg.obj = current_musicID;
                        mEventHandler.sendMessage(msg);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }

                @Override
                public void PPFailureError(String errorMsg) {

                }
            });
        }
    }

    @OnClick(R.id.btn_right_click)
    public void onBtnRightClick() {
        if (!SingleVideoActivity.getInstance().getSDCardStatus()) {
            showToast(getString(R.string.no_sdcard));
            return;
        }
        CommonUtils.getSdkUtil().playNextSong(new SongPlayerListener() {
            @Override
            public void PPSuccessHandler(String songId) {
                Message msg = new Message();
                msg.obj = songId;
                msg.what = MESSAGE_SWITCH_SONG;
                if (mEventHandler != null)
                    mEventHandler.sendMessage(msg);
            }

            @Override
            public void PPFailureError(String errorMsg) {

            }
        });
    }

    @Override
    public void showDlg(Context context, String title, String message, DialogInterface.OnClickListener postiveClick, String string2) {
        if (mDialog == null)
            mDialog = showSdDlg(context, title, message, string2, postiveClick, null, null, false);
        mDialog.show();
    }

    public MeariMusic getSongNameById(String id, ArrayList<MeariMusic> list) {
        for (MeariMusic info : list) {
            if (info.getMusicID().equals(id))
                return info;
        }
        return null;
    }

    private boolean isNeedFresh(MeariMusic info, String mCurMusicId, boolean playStatus) {
        MeariMusic songinfo = mAdapter.getMusicInfoById(mCurMusicId);
        if (mCurMusicId == null)
            return true;
        if (!playStatus)
            return true;
        if (info == null || songinfo == null)
            return true;
        if (info != null && info.getDownload_percent() != songinfo.getDownload_percent())
            return true;
        if (mAdapter.isPlay() == playStatus && mCurMusicId.equals(mAdapter.getCurMusicId())) {
            return false;
        } else
            return true;
    }

    public void setModeView(String model) {
        mModeImage.setTag(model);
        if (model != null && model.equals("single")) {
            mModeImage.setImageResource(R.drawable.btn_single_mode);
        } else if (model != null && model.equals("random")) {
            mModeImage.setImageResource(R.drawable.btn_random_mode);
        } else {
            mModeImage.setTag("single");
            mModeImage.setImageResource(R.drawable.btn_single_mode);
        }
    }

    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(R.anim.out_to_top, R.anim.in_from_bottom);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mRefreshStatus != null)
            mRefreshStatus.removeCallbacks(mRefrshSongStatusRunnale);
        mRefreshStatus = null;
        mEventHandler = null;
    }
}
