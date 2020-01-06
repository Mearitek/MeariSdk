package com.meari.test.adapter;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import androidx.annotation.RequiresApi;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.meari.sdk.MeariUser;
import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.bean.DeviceMessageStatusInfo;
import com.meari.sdk.bean.NVRInfo;
import com.meari.test.MessageDeviceActivity;
import com.meari.test.R;
import com.meari.test.common.Constant;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.Logger;
import com.meari.test.utils.NetUtil;
import com.meari.test.viewholder.CameraHolder;
import com.ppstrong.ppsplayer.BaseDeviceInfo;

import java.util.List;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/27
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class CameraSquareAdapter extends BaseQuickAdapter<BaseDeviceInfo, CameraHolder> {
    private int mNvrNum;

    public CameraSquareAdapter(CameraSquareCallback fragment) {
        super(R.layout.item_square_camera);
        mfragment = fragment;
    }

    @Override
    protected void convert(CameraHolder holder, BaseDeviceInfo deviceInfo) {
        if (deviceInfo instanceof CameraInfo && deviceInfo.getDevTypeID() != 1) {
            CameraInfo cameraInfo = (CameraInfo) deviceInfo;
            /**设置设备名称  */
            holder.txtName.setText(cameraInfo.getDeviceName());
            /**设置设备访问量 */
            holder.status_layout.setTag(holder.getLayoutPosition());
            holder.imgViewState.setImageResource(getHomePlayView());
            holder.img_rotate_state.clearAnimation();
            holder.img_rotate_state.setVisibility(View.GONE);
            holder.imgViewState.setVisibility(View.VISIBLE);
            holder.loadImage.setVisibility(View.GONE);
            if (cameraInfo.isState()) {
                holder.imgViewState.setImageResource(getHomePlayView());
                holder.img_rotate_state.clearAnimation();
                holder.img_rotate_state.setVisibility(View.GONE);
                holder.imgViewState.setVisibility(View.VISIBLE);
                holder.loadImage.setVisibility(View.GONE);
            } else {
                holder.imgViewState.setVisibility(View.GONE);
                //或加载视频的
                if (cameraInfo.getIsRotate()) {
                    holder.loadImage.setVisibility(View.VISIBLE);
                    holder.img_rotate_state.setVisibility(View.GONE);

                } else {
                    holder.loadImage.setVisibility(View.GONE);
                    holder.img_rotate_state.setVisibility(View.VISIBLE);
                    holder.img_rotate_state.setImageResource(R.mipmap.ic_offline_n);
                }
            }
            if (cameraInfo.isHasAlertMsg())
                holder.btn_message.setImageResource(R.mipmap.ic_message_h);
            else
                holder.btn_message.setImageResource(R.drawable.btn_message);
            holder.btn_message.setTag(cameraInfo);
            holder.btn_message.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    CameraInfo info = (CameraInfo) v.getTag();
                    Bundle bundle = new Bundle();
                    DeviceMessageStatusInfo msgInfo = new DeviceMessageStatusInfo();
                    msgInfo.setDeviceUUID(info.getDeviceUUID());
                    msgInfo.setDeviceID(Long.valueOf(info.getDeviceID()));
                    msgInfo.setSnNum(info.getSnNum());
                    msgInfo.setUserAccount(info.getUserAccount());
                    msgInfo.setDeviceName(info.getDeviceName());
                    bundle.putSerializable("msgInfo", msgInfo);
                    Intent intent = new Intent(mContext, MessageDeviceActivity.class);
                    intent.putExtras(bundle);
                    mContext.startActivity(intent);
                }
            });
            holder.status_layout.setOnClickListener(new View.OnClickListener() {
                @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
                @Override
                public void onClick(View v) {
                    int tag = (int) v.getTag();
                    ImageView stateImage =  v.findViewById(R.id.img_rotate_state);
                    View loadingView = v.findViewById(R.id.loading_dialog_img);
                    BaseDeviceInfo cameraInfo = getItem(tag);
                    if (cameraInfo.isState()) {
                        if (cameraInfo instanceof CameraInfo) {
                            CameraInfo info = (CameraInfo) cameraInfo;
                            mfragment.startSingleVideo(info, v);
                        }
                        return;
                    } else if (cameraInfo.getIsRotate()) {
                        return;
                    } else {
                        // 检查网络是否可用
                        if (!NetUtil.checkNet(mContext)) {
                            CommonUtils.showToast(mContext.getString(R.string.network_unavailable));
                            return;
                        }
                        stateImage.setVisibility(View.GONE);
                        loadingView.setVisibility(View.VISIBLE);
                        mfragment.startCheckStatus(cameraInfo);
                        return;
                    }
                }
            });
            //门铃添加，长按删除该门铃
            holder.status_layout.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View view) {
                    //弹出对话框提示是否删除该设备
                    return false;
                }
            });
            if (cameraInfo.getUserID() == MeariUser.getInstance().getUserInfo().getUserID()) {
                holder.txtName.setTextColor(Color.parseColor("#010101"));
            } else
                setShareTextColor(holder.txtName);
            String snPathString = Constant.DOCUMENT_CACHE_PATH + cameraInfo.getSnNum() + ".jpg";
            Logger.i(TAG, "snPathString==>" + snPathString);
            //from puLan:setImageURI有问题，不能够及时更新首页的预览图！换成setiamgebitmap
            holder.preView.setImageURI(Uri.parse("file://" + snPathString));
//            Bitmap bmp;
//            File file = new File(snPathString);
//            try {
//                bmp = MediaStore.Images.Media.getBitmap(mContext.getContentResolver(), Uri.fromFile(file));
//                holder.preView.setImageBitmap(bmp);
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
            holder.deviceTypeImg.setImageURI(Uri.parse(cameraInfo.getDeviceIcon()));
            holder.btn_setting.setTag(cameraInfo);

            if (cameraInfo.isUpdateVersion()) {
                holder.btn_setting.setImageResource(R.drawable.btn_home_update_setting);
            } else {
                holder.btn_setting.setImageResource(R.drawable.btn_home_setting);
            }
            holder.btn_setting.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    CameraInfo info = (CameraInfo) v.getTag();
                    mfragment.goSettingActivity(info);

                }
            });
            holder.deviceLayout.setTag(cameraInfo);
            holder.deviceLayout.setOnClickListener(new View.OnClickListener() {
                @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
                @Override
                public void onClick(View v) {
                    CameraInfo info = (CameraInfo) v.getTag();
                    if (info.isState()) {
                        mfragment.startSingleVideo(info, v);
                    }
                }
            });
            holder.deviceLayout.setVisibility(View.VISIBLE);
            holder.getConvertView().findViewById(R.id.device_info_layout).setVisibility(View.VISIBLE);
            holder.layout_nvr.setVisibility(View.GONE);
            holder.deviceTypeImg.setVisibility(View.VISIBLE);

        } else if (deviceInfo instanceof NVRInfo) {
            NVRInfo info = (NVRInfo) deviceInfo;
            holder.nvr_name_text.setText(deviceInfo.getDeviceName());
            holder.nvrImg.setImageURI(Uri.parse(deviceInfo.getDeviceIcon()));
            holder.deviceLayout.setVisibility(View.GONE);
            holder.getConvertView().findViewById(R.id.device_info_layout).setVisibility(View.GONE);
            holder.layout_nvr.setVisibility(View.VISIBLE);
            holder.deviceTypeImg.setVisibility(View.GONE);
            if (holder.getLayoutPosition() == getItemCount() - mNvrNum) {
                holder.getConvertView().findViewById(R.id.top_line).setVisibility(View.VISIBLE);
            } else {
                holder.getConvertView().findViewById(R.id.top_line).setVisibility(View.GONE);
            }
            holder.layout_nvr.setTag(info);
            holder.layout_nvr.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    NVRInfo info = (NVRInfo) v.getTag();
                    mfragment.goSettingActivity(info);
                }
            });
        }

    }

    private CameraSquareCallback mfragment;
    private CameraInfo mCameraInfo;


    public void setShareTextColor(TextView txtName) {
        Resources resource = mContext.getResources();
        ColorStateList csl = resource.getColorStateList(R.color.com_blue);
        if (csl != null) {
            txtName.setTextColor(csl);
        }
    }






    private void changeBindTypeByUUId(String deviceUUID, String isBindingTY) {
        for (int i = 0; i < getData().size(); i++) {
            BaseDeviceInfo info = getData().get(i);
            if (info.getDeviceUUID().equals(deviceUUID)) {
                if (info instanceof CameraInfo) {
                    ((CameraInfo) (getData().get(i))).setBindingTy(isBindingTY);
                }
                notifyDataSetChanged();
                return;
            }
        }
    }

    public void changeStatusByUuid(String uuid, int status) {
        if (getData() == null || getData().size() == 0)
            return;
        for (BaseDeviceInfo info : getData()) {
            if (info.getDeviceUUID().equals(uuid)) {
                if (status > 0)
                    info.setState(true);
                else if (status == -1)
                    info.setState(false);
                if (info instanceof BaseDeviceInfo) {
                    info.setIsRotate(false);
                }
                return;
            }
        }
    }

    public void changeDeviceStatus(String deviceId, boolean onLine) {
        List<BaseDeviceInfo> cameraInfos = getData();
        if (cameraInfos != null) {
            for (BaseDeviceInfo cameraInfo : cameraInfos) {
                if (cameraInfo.getDeviceID().equals(deviceId)) {
                    cameraInfo.setIsRotate(false);
                    cameraInfo.setState(onLine);
                    break;
                }
            }
        }
        notifyDataSetChanged();
    }



    public int getHomePlayView() {
        return R.drawable.btn_homepage_play;
    }

    public void setNvrNum(int nvrNum) {
        this.mNvrNum = nvrNum;
    }

    public interface CameraSquareCallback {
        void startSingleVideo(CameraInfo cameraInfo, View v);

        void startCheckStatus(BaseDeviceInfo cameraInfo);

        void goSettingActivity(BaseDeviceInfo info);

        void goActivityForResult(Intent intent, int activitySigplay);
    }

}
