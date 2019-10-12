package com.meari.test.adapter;

import android.content.Context;
import android.content.DialogInterface;
import android.net.Uri;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.interfaces.DraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.sdk.bean.MeariMusic;
import com.meari.test.R;
import com.meari.test.SingleVideoActivity;
import com.meari.test.widget.RoundProgressBar;

import java.util.ArrayList;

/**
 * Created by Administrator on 2017/3/8.
 * 播放音乐适配器
 */

public class SongAdapter extends RecyclerView.Adapter<SongAdapter.ViewHolder> {
    private Context mContext;
    private ArrayList<MeariMusic> mList;//正在歌曲列表
    private String mCurMusicId = "";//正在播放歌曲的id
    private boolean isPlay = false;//正在播放歌曲的id
    private SongPlayCallback mCallback;

    public SongAdapter(Context context, ArrayList<MeariMusic> songList, SongPlayCallback callback) {
        this.mContext = context;
        this.mList = songList;
        this.mCallback = callback;
    }

    public ArrayList<MeariMusic> getSongInfos() {
        return mList;
    }

    public void setSongInfos(ArrayList<MeariMusic> list) {
        if (mList == null) {
            mList = new ArrayList<>();
        }
        mList.clear();
        mList.addAll(list);
    }

    /**
     * @param parent
     * @param viewType
     * @return
     */
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View convertView = LayoutInflater.from(mContext).inflate(R.layout.item_song, null);
        ViewHolder viewHolder = new ViewHolder(convertView);
        viewHolder.text_down =  convertView.findViewById(R.id.text_down_status);
        viewHolder.btn_play =  convertView.findViewById(R.id.btn_play);
        viewHolder.progressBar =  convertView.findViewById(R.id.btn_down_load);
        viewHolder.text_name =convertView.findViewById(R.id.text_name);
        convertView.setTag(viewHolder);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        MeariMusic songInfo = mList.get(position);
        viewHolder.text_name.setText(songInfo.getMusicName());
        if (songInfo.getDownload_percent() < 0) {
            viewHolder.text_down.setText(mContext.getString(R.string.downloading));
        } else if (songInfo.getDownload_percent() >= 100) {
            viewHolder.text_down.setText(mContext.getString(R.string.downloading));

        } else {
            viewHolder.text_down.setText(mContext.getString(R.string.downloading));
        }
        if (songInfo.getMusicID().equals(mCurMusicId)) {
            if (isPlay) {
                DraweeController mDraweeController = Fresco.newDraweeControllerBuilder()
                        .setAutoPlayAnimations(true)
                        .setUri(Uri.parse("res://" + mContext.getPackageName() + "/" + R.mipmap.ic_play_anin))//设置uri
                        .build();
                viewHolder.btn_play.setController(mDraweeController);
                if (songInfo.getDownload_percent() <= 0) {
                    viewHolder.btn_play.setVisibility(View.GONE);
                    viewHolder.progressBar.setVisibility(View.VISIBLE);
                    viewHolder.progressBar.setContent("0%");
                    viewHolder.progressBar.setProgress(1);
                } else if (songInfo.getDownload_percent() >= 100) {
                    viewHolder.btn_play.setVisibility(View.VISIBLE);
                    viewHolder.progressBar.setVisibility(View.GONE);
                    viewHolder.progressBar.setContent("100%");
                    viewHolder.progressBar.setProgress(100);
                } else {
                    viewHolder.progressBar.setContent(songInfo.getDownload_percent() + "%");
                    viewHolder.progressBar.setProgress(songInfo.getDownload_percent());
                    viewHolder.btn_play.setVisibility(View.GONE);
                    viewHolder.progressBar.setVisibility(View.VISIBLE);
                }
            } else {
                viewHolder.btn_play.setImageURI(Uri.parse("res://" + mContext.getPackageName() + "/" + R.mipmap.ic_musi_play));//设置uri
                viewHolder.btn_play.setVisibility(View.VISIBLE);
                viewHolder.progressBar.setVisibility(View.GONE);
            }
        } else {
            viewHolder.btn_play.setImageURI(Uri.parse("res://" + mContext.getPackageName() + "/" + R.mipmap.ic_musi_play));//设置uri
            viewHolder.progressBar.setVisibility(View.GONE);
            viewHolder.btn_play.setVisibility(View.VISIBLE);
        }
        viewHolder.progressBar.setTag(position);
        viewHolder.progressBar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (SingleVideoActivity.getInstance() == null)
                    return;
                if (SingleVideoActivity.getInstance() != null) {
                    if (!SingleVideoActivity.getInstance().getSDCardStatus()) {
                        mCallback.showDlg(mContext, mContext.getString(R.string.install_sd), mContext.getString(R.string.install_sd_warning), positiveClick, mContext.getString(R.string.ok));
                        return;
                    }
                }
                isPlay = false;
                mCallback.pauseMusicPlay();
                notifyDataSetChanged();
            }
        });
        viewHolder.btn_play.setTag(position);
        viewHolder.btn_play.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (SingleVideoActivity.getInstance() == null)
                    return;
                if (SingleVideoActivity.getInstance() != null) {
                    if (!SingleVideoActivity.getInstance().getSDCardStatus()) {
                        mCallback.showDlg(mContext, mContext.getString(R.string.install_sd), mContext.getString(R.string.install_sd_warning), positiveClick, mContext.getString(R.string.ok));
                        return;
                    }
                }
                int position = (int) v.getTag();
                MeariMusic info = mList.get(position);
                changeSongPlayStatus(info);
                if (info.getMusicID().equals(mCurMusicId)) {
                    if (!isPlay) {
                        isPlay = true;
                        mCallback.continueMusicPlay(info.getMusicID());
                    } else {
                        isPlay = false;
                        mCallback.pauseMusicPlay();
                    }

                } else {
                    isPlay = true;
                    mCurMusicId = info.getMusicID();
                    mCallback.continueMusicPlay(info.getMusicID());
                }
                notifyDataSetChanged();
            }
        });
        viewHolder.text_down.setVisibility(View.GONE);
    }

    public DialogInterface.OnClickListener positiveClick = new DialogInterface.OnClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int which) {
            dialog.dismiss();
        }
    };

    private void changeSongPlayStatus(MeariMusic info) {
        for (MeariMusic songInfo : mList) {
            if (songInfo.getMusicID().equals(info.getMusicID())) {
                songInfo.setIs_playing(!info.getIs_playing());
            } else
                songInfo.setIs_playing(false);
        }
    }

    public void changeStopPlayStatus() {
        for (MeariMusic songInfo : mList) {
            songInfo.setIs_playing(false);
        }
    }


    @Override
    public int getItemCount() {
        return this.mList == null ? 0 : this.mList.size();
    }

    public String getCurMusicId() {
        return mCurMusicId;
    }

    public void setCurMusicId(String mCurMusicId) {
        this.mCurMusicId = mCurMusicId;
    }

    public void isChangeDataBySongInfo(MeariMusic curInfo) {
        if (mList == null || curInfo == null)
            return;
        for (MeariMusic info : mList) {
            if (info.getMusicID().equals(curInfo.getMusicID())) {
                int progress = curInfo.getDownload_percent();
                if (progress < 0) {
                    progress = 0;
                } else if (progress > 100) {
                    progress = 100;
                }
                info.setDownload_percent(progress);
                info.setIs_playing(curInfo.getIs_playing());
            } else {
                info.setIs_playing(false);
            }
        }
    }

    public MeariMusic getMusicInfoById(String musicId) {
        if (mList == null)
            return null;
        for (MeariMusic info : mList) {
            if (info.getMusicID() != null && info.getMusicID().equals(musicId)) {
                return info;
            }
        }
        return null;
    }

    public void setIsPlay(boolean isPlay) {
        this.isPlay = isPlay;
    }

    public boolean isPlay() {
        return this.isPlay;
    }


    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView text_name;
        TextView text_down;
        SimpleDraweeView btn_play;
        RoundProgressBar progressBar;


        public ViewHolder(View itemView) {
            super(itemView);
        }
    }

    public interface SongPlayCallback {
        void continueMusicPlay(String songId);

        void pauseMusicPlay();

        void showDlg(Context mContext, String string, String string1, DialogInterface.OnClickListener positiveClick, String string2);
    }

}

