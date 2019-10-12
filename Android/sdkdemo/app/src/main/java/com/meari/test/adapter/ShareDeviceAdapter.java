package com.meari.test.adapter;

import android.net.Uri;

import com.meari.sdk.bean.MeariSharedDevice;
import com.meari.test.R;
import com.meari.test.common.Constant;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.viewholder.ShareFriendDeviceHoler;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/9/15
 * 描    述：
 * 修订历史：
 * ================================================
 */

public class ShareDeviceAdapter extends BaseQuickAdapter<MeariSharedDevice, ShareFriendDeviceHoler> {

    public ShareDeviceAdapter() {
        super(R .layout.item_friend_device);

    }
    @Override
    protected void convert(ShareFriendDeviceHoler helper, MeariSharedDevice info) {
        String snPathString = Constant.DOCUMENT_CACHE_PATH + info.getSnNum() + ".jpg";
        helper.headIcon.setImageURI(Uri.parse("file://" + snPathString));
        helper.userNickname.setText(info.getDeviceName());
        if (info.isShared())
            helper.shareCheck.setImageResource(R.mipmap.ic_select_p);
        else
            helper.shareCheck.setImageResource(R.mipmap.ic_select_n);
        helper.shareCheck.setTag(info);
    }

    public void changeDateFriendDetail(String deviceID, boolean flags) {
        if (getData() != null && getData().size() > 0) {
            for (int i = 0; i < getData().size(); i++) {
                if (deviceID.equals(getData().get(i).getDeviceID())) {
                    getData().get(i).setShared(flags);
                }
            }
        }
    }
}
