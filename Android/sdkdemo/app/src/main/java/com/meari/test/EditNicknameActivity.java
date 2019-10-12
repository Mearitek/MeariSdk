package com.meari.test;

import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;

import com.meari.sdk.MeariUser;
import com.meari.sdk.callback.IResultCallback;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.utils.EmojiFilter;
import com.meari.test.widget.ClearEditText;

import butterknife.BindView;
import butterknife.OnClick;

public class EditNicknameActivity extends BaseActivity {
    @BindView(R.id.nickname_text)
    ClearEditText mNicknameEdit;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_nickname);
        getTopTitleView();
        this.mCenter.setText(R.string.edit_nickname_title);
        initView();
    }

    private void initView() {
        this.mNicknameEdit.setText(MeariUser.getInstance().getUserInfo().getNickName());
        this.mNicknameEdit.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                //这里注意要作判断处理，ActionDown、ActionUp都会回调到这里，不作处理的话就会调用两次
                if (KeyEvent.KEYCODE_ENTER == keyCode && KeyEvent.ACTION_DOWN == event.getAction()) {
                    onPostNicknameData();
                    return true;
                }
                return false;
            }
        });
    }

    @OnClick(R.id.btn_save)
    public void onPostNicknameData() {
        String nickname = this.mNicknameEdit.getText().toString().trim();
        if (nickname.length() == 0) {
            CommonUtils.showToast(R.string.nicknameIsNull);
            mNicknameEdit.clearFocus();
            mNicknameEdit.setShakeAnimation();
            return;
        } else if (!EmojiFilter.isNormalString(nickname)) {
            CommonUtils.showToast(R.string.name_format_error);
            mNicknameEdit.clearFocus();
            mNicknameEdit.setShakeAnimation();
            return;
        } else if (nickname.equals(MeariUser.getInstance().getUserInfo().getNickName())) {
            CommonUtils.showToast(R.string.niname_unchanged);
            mNicknameEdit.clearFocus();
            mNicknameEdit.setShakeAnimation();
            return;
        }
        startProgressDialog();
        MeariUser.getInstance().renameNickname(nickname, this ,new IResultCallback() {
            @Override
            public void onSuccess() {
                stopProgressDialog();
                showToast(getString(R.string.edit_success));
                setResult(RESULT_OK);
                finish();
            }

            @Override
            public void onError(int code, String error) {
                stopProgressDialog();
                CommonUtils.showToast(error);
            }
        });
    }

}
