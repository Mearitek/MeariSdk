package com.meari.test.utils;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.support.v7.widget.RecyclerView;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.interfaces.DraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.meari.test.R;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;

import java.util.ArrayList;
import java.util.List;

/**
 * ================================================
 * 作    者：ljh
 * 版    本：2.0
 * 创建日期：2017/4/27
 * 描    述：管理PulltoRefreshRecycler
 * 修订历史：
 * ================================================
 */

public class ListHelper<T> implements AdapterView.OnItemClickListener, View.OnClickListener {

    private final Context mContext;
    private final RecyclerView mRecyclerView;
    private final BaseQuickAdapter<T, BaseViewHolder> mListAdapter;
    /**
     * list为空时显示在text上方的图片
     */
    private Drawable mEmptyDrawable;
    private Drawable mAddDrawable;
    /**
     * list为空时显示的text提示
     */
    private String mEmptyText;
    private String mEmptyAddText;
    /**
     * list数据请求错误时显示在text上方错误图片
     */
    private Drawable mErrorDrawable;
    /**
     * list数据请求错误时error提示
     */
    private String mErrorText;
    /** 第一次加载数据是显示加载UI */
    // private View mLoading;
    /**
     * list为空时的空TextView
     */
    private View mEmpty;
    private boolean mIsAddDevice = false;//是否要添加摄像头

    /**
     * 构造方法
     *
     * @param context
     * @param listView    管理的listView
     * @param listAdapter 管理的ListAdapter
     */
    public ListHelper(Context context, RecyclerView listView, BaseQuickAdapter listAdapter) {
        if (listView == null)
            throw new NullPointerException("the listView can not be null");
        if (listAdapter == null)
            throw new NullPointerException("the listAdapter can not be null");
        this.mContext = context;
        this.mRecyclerView = listView;
        this.mListAdapter = listAdapter;
        initView();
    }

    /**
     * @Description: 初始化listView
     */
    @SuppressWarnings("deprecation")
    private void initView() {
        mRecyclerView.setVerticalScrollBarEnabled(false);
        mRecyclerView.setHorizontalScrollBarEnabled(false);
        mRecyclerView.setBackgroundColor(mContext.getResources().getColor(R.color.transparent));
        mRecyclerView.setAdapter(mListAdapter);
        this.mEmptyDrawable = mContext.getResources().getDrawable(R.mipmap.ic_error);
        this.mAddDrawable = mContext.getResources().getDrawable(R.mipmap.ic_add_empty_devecis);
        this.mEmptyText = mContext.getString(R.string.pps_str_default_list_no_data);
        this.mEmptyAddText = mContext.getString(R.string.pps_str_default_list_no_data);
        this.mErrorDrawable = mContext.getResources().getDrawable(R.mipmap.ic_error);
        // initDefaultView();
    }

    /**
     * @Description: listView为空且刷新时调用
     */
    public void bindLoading() {
        mListAdapter.emptyList();
        showLoadingView(true);
        showEmptyText(false, getEmptyText(), getEmptyDrawable());
    }

    public void showBindLoading(boolean bshow) {
        mListAdapter.emptyList();
        showLoadingView(bshow);
        showEmptyText(bshow, getEmptyText(), getEmptyDrawable());
    }

    /**
     * @Description: listView为空时调用
     */
    public void bindEmpty() {
        showLoadingView(false);
        showEmptyText(true, getEmptyText(), getEmptyDrawable());
    }

    /**
     * @Description: listView为空时调用
     */
    public void bindAddEmpty() {
        showLoadingView(false);
        showAddText(true, getAddText(), getAddDrawable());
    }

    private void showAddText(boolean show, String text, Drawable drawable) {
        SpannableStringBuilder builder = new SpannableStringBuilder("");
        builder.append(text);
        builder.append("“");
        int pos = builder.length();
        builder.append(" + ");
        ColorClickableSpan colorSpan = new ColorClickableSpan(0xff21bba3, null);
        builder.setSpan(colorSpan, pos, builder.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        builder.append("“");
        builder.append(mContext.getString(R.string.meari_add));
        TextView empty =  getEmpty().findViewById(R.id.empty);
        if (empty != null) {
            empty.setVisibility(show ? View.VISIBLE : View.GONE);
            empty.setText(builder);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
            empty.setCompoundDrawables(null, drawable, null, null);
        }
        mIsAddDevice = true;

    }

    /**
     * @param emptyText
     * @Description: listView为空时调用
     */
    public void bindEmpty(String emptyText) {
        showLoadingView(false);
        showEmptyText(true, emptyText, getEmptyDrawable());
    }

    /**
     * @param errorText
     * @Description: 数据请求错误时调用
     */
    public void bindError(String errorText) {
        showLoadingView(false);
        showEmptyText(true, errorText, getErrorDrawable());
    }

    private void showLoadingView(boolean show) {
        View loading = getEmpty().findViewById(R.id.loading);
        if (loading != null) {
            loading.setVisibility(show ? View.VISIBLE : View.GONE);
        }
    }

    private void showEmptyText(boolean show, String text, Drawable drawable) {
        TextView empty =  getEmpty().findViewById(R.id.empty);
        if (empty != null) {
            empty.setVisibility(show ? View.VISIBLE : View.GONE);
            empty.setText(text);
            drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
            empty.setCompoundDrawables(null, drawable, null, null);
        }
        mIsAddDevice = false;
    }

    /*
     * (non-Javadoc) listView点击事件
     */
    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (mListAdapter.getData() == null || mListAdapter.getData().size() <= position) {
            return;
        }
        T data = mListAdapter.getData().get(position);
        if (data != null && mCallBack != null) {
            mCallBack.onItemClick(view, data, position);
        }
    }

    /**
     * listView回调方法
     */
    private ListCallBack<T> mCallBack;

    public void setListCallBack(ListCallBack<T> callBack) {
        this.mCallBack = callBack;
    }

    public String getAddText() {
        return mContext.getString(R.string.pps_str_default_list_add_data);
    }

    public interface ListCallBack<T> {
        /**
         * @param data     点击的数据
         * @param position 点击的位置
         * @Description: list item 点击回调
         */

        void onItemClick(View view, T data, int position);

        /**
         * @Description:list为空时点击
         */
        void onEmptyClick(boolean bAddDevice);

    }

    /**
     * @param data 添加的数据
     * @Description: 添加一个数据
     */
    public void addData(T data) {
        mListAdapter.addData(data);
    }

    /**
     * 获取这个list集合
     *
     * @return
     */
    public List<T> getListArray() {
        return mListAdapter.getData();
    }

    /**
     * @param index 添加数据的位置
     * @param data  添加的数据
     * @Description: 添加一个数据
     */
    public void addData(int index, T data) {
        mListAdapter.addData(index, data);
    }

    /**
     * @Description: 添加数据到列表 ，对应界面上拉
     * @param list
     *            数据
     */
    /**
     * @param list
     * @return void
     * @Description: TODO
     */
    public void addList(ArrayList<T> list) {
        mListAdapter.addData(list);
    }

    /**
     * @param list 数据
     * @Description: 刷新数据，对应界面下拉
     */
    public void resetList(ArrayList<T> list) {
        mListAdapter.setNewData(list);
    }

    /**
     * @Description: 清空数据
     */
    public void emptyList() {
        mListAdapter.emptyList();
    }


    /**
     * @return List<T>
     * @Description: 获取list数据集合
     */
    public List<T> getDataSource() {
        return mListAdapter.getData();
    }

    /**
     * @return int list数据总数
     * @Description: 获取数据总数
     */
    public int getCount() {
        return mListAdapter.getItemCount();
    }

    /**
     * @return boolean true为空 false不为空
     * @Description: 判断列表为空
     */
    public boolean isEmpty() {
        return getCount() == 0;
    }

    /**
     * @param position 位置
     * @return T 数据
     * @Description: 获取某个位置的数据
     */
    public T getDetail(int position) {
        return mListAdapter.getData().get(position);
    }

    public Drawable getEmptyDrawable() {
        return mEmptyDrawable;
    }

    public Drawable getAddDrawable() {
        return mAddDrawable;
    }

    public void setEmptyDrawable(Drawable emptyDrawable) {
        this.mEmptyDrawable = emptyDrawable;
    }

    public Drawable getErrorDrawable() {
        return mErrorDrawable;
    }

    public void setErrorDrawable(Drawable errorDrawable) {
        this.mErrorDrawable = errorDrawable;
    }

    public String getEmptyText() {
        return mEmptyText;
    }

    public void setEmptyText(String emptyText) {
        this.mEmptyText = emptyText;
    }

    public String getErrorText() {
        return mErrorText;
    }

    public void setErrorText(String errorText) {
        this.mErrorText = errorText;
    }

    public View getEmpty() {
        if (mEmpty == null) {
            mEmpty = initDefaultView();
        }
        return mEmpty;
    }

    public void setEmpty(View empty) {
        mEmpty = empty;
    }

    public RecyclerView getListView() {
        return mRecyclerView;
    }

    public BaseQuickAdapter getListAdapter() {
        return mListAdapter;
    }

    /**
     * @return View
     */
    @SuppressLint("InflateParams")
    private View initDefaultView() {
        View view = LayoutInflater.from(mContext).inflate(R.layout.layout_list_empty, null);
        ImageView loaigndview = view.findViewById(R.id.prodlg_loading_iv);
        AnimationDrawable animationDrawable = (AnimationDrawable) loaigndview .getDrawable();
        animationDrawable.start();
        TextView empty =  view.findViewById(R.id.empty);
        empty.setOnClickListener(this);
        mListAdapter.setEmptyView(view);
        return view;
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.empty && mCallBack != null) {
            mCallBack.onEmptyClick(mIsAddDevice);
        }
    }
}
