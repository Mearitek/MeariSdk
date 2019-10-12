package com.meari.test;

import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.RequiresApi;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.meari.sdk.bean.CameraInfo;
import com.meari.sdk.json.BaseJSONObject;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.BaseActivity;
import com.meari.test.utils.CommonUtils;
import com.meari.test.viewholder.MotionViewHolder;
import com.meari.test.widget.IndicatorView;
import com.ppstrong.ppsplayer.CameraPlayer;
import com.ppstrong.ppsplayer.CameraPlayerListener;

import org.json.JSONException;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 铃铛设置页面
 *
 * @author pupu
 * @time 2017年7月26日16:03:41
 */
public class CharmSettingActivity extends BaseActivity {

    private static final String TAG = "CharmSettingActivity";
    @BindView(R.id.indicatorView_volume)
    IndicatorView indicatorView_volume;//档位条控件，copy改
    @BindView(R.id.indicatorView_repeat)
    IndicatorView indicatorView_repeat;
    @BindView(R.id.tv_volume)
    TextView tv_volume;//铃铛音量档位指示文字
    @BindView(R.id.tv_repeat)
    TextView tv_repeat;//重复次数档位文字
    @BindView(R.id.rv_ring)
    RecyclerView rv_ring;//铃声列表选择
    ArrayList<String> listRing;//铃声备选项,打洞查询一次后，本地存储一份
    BaseQuickAdapter ringAdapter;//铃声适配器
    String selectRing;//选中的铃声
    int charmVol;//门铃铃铛音量,1:低；2：中；3：高
    int charmRepeat;//门铃铃铛铃声重复次数

    //通用cameraplayer
    CameraPlayer cameraPlayer;
    //门铃设备基本信息
    CameraInfo cameraInfo;

    //消息统一处理
    final static int MSG_UPDATE_TV_VOL = 0x1001;//更新音量指示器文字
    final static int MSG_UPDATE_TV_REP = 0x1002;//更新次数指示器文字
    final static int MSG_SET_CHARM_SUCCESS = 0x1003;//设置铃铛成功
    final static int MSG_GET_CHARM_SUCCESS = 0x1004;//获取铃铛设置信息成功
    final static int MSG_SET_CHARM_FAILED = 0x1005;//铃铛设置失败
    final static int MSG_GET_CHARM_FAILED = 0x1006;//获取铃铛设置信息失败
    final static int MSG_CONNECT_IPC_SUCCESS = 0x1007;//连接IPC成功
    final static int MSG_CONNECT_IPC_FAILED = 0x1008;//连接IPC失败
    Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_CONNECT_IPC_SUCCESS:
                    //去获取设置信息
                    getCharmSetting();
                    break;
                case MSG_CONNECT_IPC_FAILED:
                    //提示连接失败
                    CommonUtils.showToast(R.string.connectFail);
                    break;
                case MSG_GET_CHARM_FAILED:
                    //提示失败
                    CommonUtils.showToast(R.string.connectFail);
                    break;
                case MSG_SET_CHARM_FAILED:
                    //提示失败
                    CommonUtils.showToast(R.string.setting_failded);
                    break;
                case MSG_UPDATE_TV_VOL:
                    int mVolumePos = msg.getData().getInt("volumePos");
                    if (mVolumePos == 0) {
                        tv_volume.setText(R.string.low);
                    } else if (mVolumePos == 1) {
                        tv_volume.setText(R.string.medium);
                    } else {
                        tv_volume.setText(R.string.high);
                    }
                    charmVol = mVolumePos + 1;
                    break;
                case MSG_UPDATE_TV_REP:
                    int mRepeatPos = msg.getData().getInt("repeatPos");
                    //这里注意从0开始计数，要+1
                    String temp2 = getResources().getString(R.string.times);
                    tv_repeat.setText(String.format(temp2, (mRepeatPos + 1) + ""));
                    charmRepeat = mRepeatPos + 1;
                    break;
                case MSG_SET_CHARM_SUCCESS:
                    //TODO:相关操作
                    //提示成功
                    CommonUtils.showToast(R.string.setting_successfully);
                    //关闭加载框
                    stopProgressDialog();
                    //关闭页面
                    finish();
                    break;
                case MSG_GET_CHARM_SUCCESS:
                    //更新列表
                    ringAdapter.notifyDataSetChanged();
                    //更新铃声音量
                    if (charmVol == 0) {
                        //防止设备异常影响app
                        charmVol = 1;
                    }
                    indicatorView_volume.setIndicatorPos(charmVol - 1);
                    //音量文字
                    //初始化音量文字
                    if (charmVol == 1) {
                        tv_volume.setText(R.string.low);
                    } else if (charmVol == 2) {
                        tv_volume.setText(R.string.medium);
                    } else {
                        tv_volume.setText(R.string.high);
                    }
                    //更新铃声时长
                    indicatorView_repeat.setIndicatorPos(charmRepeat - 1);
                    String temp3 = getResources().getString(R.string.times);
                    tv_repeat.setText(String.format(temp3, charmRepeat + ""));

                    //关闭加载框
                    stopProgressDialog();

                    break;
            }
            return false;
        }
    });

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_charm_setting);

        startProgressDialog();

        initData();

        //topbar
        initTopBar();

        initView();
    }

    private void initData() {
        //获取设备信息
        cameraInfo = (CameraInfo) getIntent().getExtras().getSerializable("cameraInfo");
        //获取通用cameraplayer
        cameraPlayer = CommonUtils.getSdkUtil();
        if (cameraPlayer.IsLogined()) {
            //获取门铃铃铛相关设置
            getCharmSetting();
        } else {
            //重新打洞连接设备
            connectIPC();
        }
    }

    /**
     * 当通用cameraplayer未连接设备时，重新打洞连接设备
     */
    private void connectIPC() {
        cameraPlayer.connectIPC2(CommonUtils.getCameraString(cameraInfo),
                new CameraPlayerListener() {
                    @Override
                    public void PPSuccessHandler(String successMsg) {
                        //连接成功
                        handler.sendEmptyMessage(MSG_CONNECT_IPC_SUCCESS);
                    }

                    @Override
                    public void PPFailureError(String errorMsg) {
                        //提示失败
                        handler.sendEmptyMessage(MSG_CONNECT_IPC_FAILED);
                    }
                });
    }

    /**
     * 获取门铃铃铛相关设置
     */
    private void getCharmSetting() {
        BaseJSONObject json = new BaseJSONObject();
        json.put("action", "GET");
        json.put("deviceurl", "http://127.0.0.1/devices/settings");
        cameraPlayer.commondeviceparams2(json.toString(), new CameraPlayerListener() {
            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPSuccessHandler(String successMsg) {
                try {
                    BaseJSONObject successMsgJson = new BaseJSONObject(successMsg);
                    //这里只拿门铃的json
                    BaseJSONObject bellJson = successMsgJson.optBaseJSONObject("bell");
                    //获取铃铛设置相关
                    BaseJSONObject charmJson = bellJson.optBaseJSONObject("charm");
                    int tmpVol = charmJson.getInt("volume");
                    //tmpVol，25:低；50：中；75：高
                    if (tmpVol == 25) {
                        charmVol = 1;
                    } else if (tmpVol == 50) {
                        charmVol = 2;
                    } else if (tmpVol == 75) {
                        charmVol = 3;
                    }
                    charmRepeat = charmJson.getInt("repetition");
                    //获取铃声备选项
                    String songs = charmJson.getString("song");
                    //解析歌曲字段
                    String[] tmpSongs = songs.split(",");
                    for (int i = 0; i < tmpSongs.length; i++) {
                        if (i == 0) {
                            //去掉中括号
                            String song = tmpSongs[0].substring(2, tmpSongs[0].lastIndexOf("\""));
                            listRing.add(song);
                        } else if (i == tmpSongs.length - 1) {
                            //去掉中括号
                            String song = tmpSongs[i].substring(1, tmpSongs[i].lastIndexOf("\""));
                            listRing.add(song);
                        } else {
                            //只去掉引号
                            String song = tmpSongs[i].substring(1, tmpSongs[i].lastIndexOf("\""));
                            listRing.add(song);
                        }
                    }
                    selectRing = charmJson.getString("selected");

                    handler.sendEmptyMessage(MSG_GET_CHARM_SUCCESS);

                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR1)
            @Override
            public void PPFailureError(String errorMsg) {
                //提示设置信息获取失败
                handler.sendEmptyMessage(MSG_GET_CHARM_FAILED);
            }
        });
    }

    private void initView() {
        //初始化档位控件条
        initIndicator();

        //初始化铃声列表,后期打洞查询或者从服务器获取
        listRing = new ArrayList<>();

        rv_ring.setLayoutManager(new LinearLayoutManager(this));
        rv_ring.setAdapter(ringAdapter = new BaseQuickAdapter<String, MotionViewHolder>(R.layout.item_comom_setting, listRing) {

            @Override
            protected void convert(MotionViewHolder helper, String item) {
                if (item.equals(selectRing)) {
                    //初始化时设置好选中状态
                    helper.bitRateImg.setVisibility(View.VISIBLE);
                }
                helper.bitRateText.setText(item);
                //文字设置成黑色
                helper.bitRateText.setTextColor(ContextCompat.getColor(CharmSettingActivity.this, R.color.dark));
            }

            @Override
            public void onBindViewHolder(MotionViewHolder holder, int positions) {
                super.onBindViewHolder(holder, positions);
            }

            @Override
            public MotionViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
                return super.onCreateViewHolder(parent, viewType);
            }
        });

        //设置item点击
        ringAdapter.setOnItemClickListener(new BaseQuickAdapter.OnItemClickListener<String>() {
            @Override
            public void onItemClick(BaseQuickAdapter<String, ? extends BaseViewHolder> adapter, View view, int position) {
                //显示当前itemview中的对号
                view.findViewById(R.id.frameRateImg).setVisibility(View.VISIBLE);
                selectRing = listRing.get(position);

                //其它的对号要消失
                int len = listRing.size();
                for (int i = 0; i < len; i++) {
                    if (i != position) {
                        adapter.getViewByPosition(rv_ring, i, R.id.frameRateImg).setVisibility(View.GONE);
                    }
                }
            }
        });

    }

    /**
     * 初始化档位控件
     */
    private void initIndicator() {
        //铃声音量档位
        indicatorView_volume.setOnIndicatorChangeListener(new IndicatorView.OnIndicatorChangeListener() {
            @Override
            public void onIndicatorChange(int currentPos, int oldPos) {
                Message msg = Message.obtain();
                msg.what = MSG_UPDATE_TV_VOL;
                Bundle bundle = new Bundle();
                bundle.putInt("volumePos", currentPos);
                msg.setData(bundle);
                handler.sendMessage(msg);
            }
        });

        //铃声重复次数档位
        indicatorView_repeat.setOnIndicatorChangeListener(new IndicatorView.OnIndicatorChangeListener() {
            @Override
            public void onIndicatorChange(int currentPos, int oldPos) {
                Message msg = Message.obtain();
                msg.what = MSG_UPDATE_TV_REP;
                Bundle bundle = new Bundle();
                bundle.putInt("repeatPos", currentPos);
                msg.setData(bundle);
                handler.sendMessage(msg);
            }
        });

    }


    /**
     * 初始化topbar
     */
    private void initTopBar() {
        getTopTitleView();
        this.mCenter.setText(getString(R.string.charm_setting));
        this.mRightBtn.setVisibility(View.GONE);
        this.action_bar_rl.setVisibility(View.VISIBLE);
        this.mRightText.setVisibility(View.VISIBLE);
        this.mRightText.setText(getString(R.string.save));
        //确定按钮逻辑操作
        this.mRightText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //开启加载对话框
                startProgressDialog();
                //上传表单请求
                sendCharmSetting();
            }
        });
    }

    /**
     * 发送设置门铃铃铛设置
     */
    private void sendCharmSetting() {
        //组合charmJson
        BaseJSONObject charmJson = new BaseJSONObject();
        BaseJSONObject tmpJson = new BaseJSONObject();
        if (charmVol == 1) {
            //低
            tmpJson.put("volume", 25);
        } else if (charmVol == 2) {
            //中
            tmpJson.put("volume", 50);
        } else if (charmVol == 3) {
            //高
            tmpJson.put("volume", 75);
        }

        tmpJson.put("repetition", charmRepeat);
        tmpJson.put("selected", selectRing);
        charmJson.put("charm", tmpJson);

        BaseJSONObject json = new BaseJSONObject();
        json.put("action", "POST");
        json.put("deviceurl", "http://127.0.0.1/devices/settings");
        json.put("bell", charmJson);
        cameraPlayer.commondeviceparams2(json.toString(), new CameraPlayerListener() {
            @Override
            public void PPSuccessHandler(String successMsg) {
                Log.i(TAG, successMsg);
                //设置成功
                handler.sendEmptyMessage(MSG_SET_CHARM_SUCCESS);
            }

            @Override
            public void PPFailureError(String errorMsg) {
                //提示设置失败
                handler.sendEmptyMessage(MSG_SET_CHARM_FAILED);
            }
        });
    }

    @OnClick({R.id.rl_charmMatches})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.rl_charmMatches:
                //跳转至铃铛配对页面
                Bundle bundle = new Bundle();
                bundle.putSerializable("cameraInfo", cameraInfo);
                start2Activity(CharmMatchesActivity.class, bundle);
                break;
        }
    }


}