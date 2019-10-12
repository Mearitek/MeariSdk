package com.meari.test.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.view.View;
import android.widget.RelativeLayout;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.backends.pipeline.PipelineDraweeController;
import com.facebook.imagepipeline.common.ResizeOptions;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.DeviceAlarmMessage;
import com.meari.sdk.bean.UserInfo;
import com.meari.test.ImagePagerActivity;
import com.meari.test.R;
import com.meari.test.common.Constant;
import com.meari.test.db.AlertMsgDb;
import com.meari.test.fragment.MessageDeviceFragment;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.utils.DisplayUtil;
import com.meari.test.utils.StringUtil;
import com.meari.test.viewholder.MsgHolderView;

import java.util.ArrayList;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/5/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class MsgDeviceAdapter extends BaseQuickAdapter<DeviceAlarmMessage, MsgHolderView> {
    private final MessageDeviceFragment mFragment;
    private final UserInfo mUserInfo;
    private boolean isEditStaus;
    private AlertMsgDb mAlertMsgDb;

    public MsgDeviceAdapter(Context context, MessageDeviceFragment fragment) {
        super(R.layout.item_message_detail);
        this.mFragment = fragment;
        this.mUserInfo = MeariUser.getInstance().getUserInfo();
    }


    public boolean isSelectAll() {
        for (int i = 0; i < getItemCount(); i++) {
            if (getData().get(i).getDelMsgFlag() == 1 || getData().get(i).getDelMsgFlag() == 0) {
                return false;
            }
        }
        return true;
    }

    protected String[] getImageUrls() {
        String[] urls = new String[getItemCount()];
        for (int i = 0; i < urls.length; i++) {
            urls[i] = getData().get(i).getImgUrl();
        }
        return urls;
    }

    public ArrayList<Long> getselect_imgDTOList() {
        ArrayList<Long> alertMsgIDDel = new ArrayList<Long>();
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (getData().get(i).getDelMsgFlag() == 2) {
                    alertMsgIDDel.add(getData().get(i).getMsgID());
                }
            }
        }
        return alertMsgIDDel;
    }

    public void changeStatus(int flag) {
        for (DeviceAlarmMessage info : getData()) {
            info.setDelMsgFlag(flag);
        }
        notifyDataSetChanged();
    }

    public boolean isEditStatus() {
        return isEditStaus;
    }

    public void setEditStatus(boolean isEditStaus) {
        this.isEditStaus = isEditStaus;
    }

    public void setMarkRead(String markRead) {
        if (getData() == null || getData().size() == 0)
            return;
        for (DeviceAlarmMessage info : getData()) {
            if (info.getIsRead().equals("N")) {
                info.setIsRead("Y");
            }

        }
    }

    @Override
    protected void convert(MsgHolderView holder, DeviceAlarmMessage deviceAlarmMessage) {
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) holder.getConvertView().findViewById(R.id.item_select_layout).getLayoutParams();
        RelativeLayout.LayoutParams lineParams = (RelativeLayout.LayoutParams) holder.getConvertView().findViewById(R.id.line3).getLayoutParams();
        RelativeLayout.LayoutParams preParam = (RelativeLayout.LayoutParams) holder.img_pre.getLayoutParams();
        String format = "%s?userID=%d&userToken=%s&deviceID=%d";
        if (holder.getLayoutPosition() == 0) {
            holder.getConvertView().findViewById(R.id.time_info_h).setVisibility(View.GONE);
            holder.getConvertView().findViewById(R.id.time_info_v).setVisibility(View.VISIBLE);
            int width = (Constant.width - DisplayUtil.dpToPx(mContext, 105));
            int height = width * 9 / 16;
            preParam.width = width;
            preParam.height = height;
            params.height = height;
            lineParams.height = DisplayUtil.dip2px(mContext, 66);
            params.width = (Constant.width - DisplayUtil.dpToPx(mContext, 28));
            holder.line1.setVisibility(View.GONE);
            if (getItemCount() > 1) {
                holder.line2.setVisibility(View.VISIBLE);
                holder.line3.setVisibility(View.VISIBLE);
            } else {
                holder.line2.setVisibility(View.GONE);
                holder.line3.setVisibility(View.GONE);
            }

        } else {
            holder.getConvertView().findViewById(R.id.time_info_h).setVisibility(View.VISIBLE);
            holder.getConvertView().findViewById(R.id.time_info_v).setVisibility(View.GONE);
            int width = (Constant.width - DisplayUtil.dpToPx(mContext, 77)) / 2;
            int height = width * 9 / 16;
            params.height = height;
            preParam.width = width;
            preParam.height = height;
            holder.line1.setVisibility(View.VISIBLE);
            if (holder.getLayoutPosition() == getItemCount() - 1) {
                holder.line2.setVisibility(View.GONE);
                holder.line3.setVisibility(View.GONE);
            } else {
                holder.line2.setVisibility(View.VISIBLE);
                holder.line3.setVisibility(View.VISIBLE);
            }
            lineParams.height = DisplayUtil.dip2px(mContext, 26);
        }
        holder.getConvertView().findViewById(R.id.item_select_layout).setLayoutParams(params);
        holder.img_pre.setLayoutParams(preParam);
        holder.line3.setLayoutParams(lineParams);
        if (!deviceAlarmMessage.getIsRead().isEmpty() && deviceAlarmMessage.getIsRead().equals("N")) {
            //如果未读且报警类型不是访客事件
            if (deviceAlarmMessage.getImageAlertType() != 3) {
                holder.txt_time_v.setTextColor(Color.parseColor("#f44336"));
                holder.text_time.setTextColor(Color.parseColor("#f44336"));
                if (holder.getLayoutPosition() != 0) {
                    holder.btn_paly.setImageResource(R.mipmap.ic_message_play_n);
                } else {
                    holder.btn_paly.setImageResource(R.mipmap.ic_message_fir_play_n);
                }
            } else if (deviceAlarmMessage.getImageAlertType() == 3) {
                //文字设置成黄色
                holder.txt_time_v.setTextColor(Color.parseColor("#EDE545"));
                holder.text_time.setTextColor(Color.parseColor("#EDE545"));
                //
                if (holder.getLayoutPosition() != 0) {
                    //图标设置成黄标
                    holder.btn_paly.setImageResource(R.mipmap.ic_message_play_y_n);
                } else {
                    //图标设置成黄标
                    holder.btn_paly.setImageResource(R.mipmap.ic_message_fir_play_y_n);
                }
            }
        } else {
            holder.txt_time_v.setTextColor(Color.parseColor("#9a9a9a"));
            holder.text_time.setTextColor(Color.parseColor("#9a9a9a"));
            if (holder.getLayoutPosition() != 0)
                holder.btn_paly.setImageResource(R.mipmap.ic_message_play_p);
            else
                holder.btn_paly.setImageResource(R.mipmap.ic_message_fir_play_p);
        }
        if (!isEditStatus()) {
            holder.btn_paly.setVisibility(View.VISIBLE);
            holder.select_img.setVisibility(View.GONE);
            holder.img_pre.setEnabled(true);
        } else {
            holder.img_pre.setEnabled(false);
            if (deviceAlarmMessage.getDelMsgFlag() == 1) {
                holder.btn_paly.setVisibility(View.GONE);
                holder.select_img.setVisibility(View.VISIBLE);
                holder.select_img.setImageResource(R.mipmap.ic_select_n);
            } else {
                holder.btn_paly.setVisibility(View.GONE);
                holder.select_img.setImageResource(R.mipmap.icon_select_p);
                holder.select_img.setVisibility(View.VISIBLE);
            }
        }
        //报警类型
        if (deviceAlarmMessage.getImageAlertType() == 6) {
            String decibelFormat = mContext.getString(R.string.decibel_format);
            holder.text_type_v.setText(String.format(decibelFormat, mContext.getString(R.string.decibel_detection), deviceAlarmMessage.getDecibel(), "db"));
            holder.text_motion_type.setText(String.format(decibelFormat, mContext.getString(R.string.decibel_detection), deviceAlarmMessage.getDecibel(), "db"));
        } else if (deviceAlarmMessage.getImageAlertType() == 1) {
            holder.text_type_v.setText(mContext.getString(R.string.motion));
            holder.text_motion_type.setText(mContext.getString(R.string.motion));
        } else if (deviceAlarmMessage.getImageAlertType() == 2) {
            //原来以前就有这个pir了，真有远见
            holder.text_type_v.setText(mContext.getString(R.string.pir));
            holder.text_motion_type.setText(mContext.getString(R.string.pir));
        } else if (deviceAlarmMessage.getImageAlertType() == 3) {
            //这里是添加的内容
            holder.text_type_v.setText(mContext.getString(R.string.bell_visit));
            //文字变成有客来访
            holder.text_motion_type.setText(mContext.getString(R.string.bell_visit));
        }
        if (StringUtil.isNotNull(deviceAlarmMessage.getCreateDate())) {
            String picDetailMsg = deviceAlarmMessage.getCreateDate();
            holder.text_time.setText(picDetailMsg);
            String[] times = picDetailMsg.split(" ");
            if (times.length >= 2) {
                holder.txt_time_v.setText(times[0] + "\n" + times[1]);
            }
        }
        holder.img_pre.setTag(holder.getLayoutPosition());
        holder.img_pre.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int position = (Integer) v.getTag();
                DeviceAlarmMessage deviceAlarmMessage = getData().get(position);
                if (mAlertMsgDb == null) {
                    mAlertMsgDb = new AlertMsgDb(mContext);
                }
                mAlertMsgDb.updateAlertMsgIsRead(deviceAlarmMessage.getMsgID());
                getData().get(position).setIsRead("Y");
                Intent intent = new Intent(mContext, ImagePagerActivity.class);
                intent.putExtra(ImagePagerActivity.EXTRA_IMAGE_URLS, deviceAlarmMessage.getUrList());
                intent.putExtra(ImagePagerActivity.EXTRA_IMAGE_INDEX, 0);
                intent.putExtra(ImagePagerActivity.EXTRA_DEVICEID, deviceAlarmMessage.getDeviceID());
                mContext.startActivity(intent);
                notifyDataSetChanged();
            }
        });
        holder.btn_paly.setTag(holder.getLayoutPosition());
        holder.btn_paly.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int tag = (int) v.getTag();
                if (mFragment != null) {
                    mFragment.startPlay(tag);
                }
            }
        });
        if (deviceAlarmMessage.getTumbnailPic() != null && !deviceAlarmMessage.getTumbnailPic().isEmpty()) {
            holder.img_pre.setImageURI(Uri.parse(String.format(format, deviceAlarmMessage.getTumbnailPic(), mUserInfo.getUserID(), mUserInfo.getUserToken(), deviceAlarmMessage.getDeviceID())));
        } else if (StringUtil.isNotNull(deviceAlarmMessage.getImgUrl())) {
            if (deviceAlarmMessage.getUrList().size() > 0) {
                int width = 320, height = 180;
                String pic = String.format(deviceAlarmMessage.getUrList().get(0), mUserInfo.getUserID(), mUserInfo.getUserToken(), deviceAlarmMessage.getDeviceID());
                Uri uri = Uri.parse(pic);
                ImageRequest request = ImageRequestBuilder
                        .newBuilderWithSource(uri)
                        .setResizeOptions(new ResizeOptions(width, height))
                        .build();
                PipelineDraweeController controller = (PipelineDraweeController) Fresco.newDraweeControllerBuilder().setOldController(holder.img_pre.getController()).setImageRequest(request)
                        .build();
                holder.img_pre.setController(controller);
            }
        }
    }

    public void clearDelData() {
        ArrayList<DeviceAlarmMessage> arrayList = new ArrayList<DeviceAlarmMessage>();
        for (DeviceAlarmMessage ppsDeviceAlarmMessage : getData()) {
            if (ppsDeviceAlarmMessage.getDelMsgFlag() != 2) {
                arrayList.add(ppsDeviceAlarmMessage);
            }
        }
        getData().clear();
        setNewData(arrayList);
    }
}

