package com.meari.test.fragment;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.meari.test.R;
import com.meari.test.recyclerview.BaseQuickAdapter;
import com.meari.test.recyclerview.BaseViewHolder;
import com.meari.test.utils.ListHelper;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Yaoll
 *  2015-8-21 上午10:18:27
 *  基类ListFragment，包含设置属性及设置Adapter，不需要再新建一个Adapter类，
 * 只需要实现该类的newView与bindView两个方法
 */
public abstract class BaseRecyclerFragment<T> extends BaseFragment implements ListHelper.ListCallBack<T> {
    /**
     * 管理listView adapter工具类
     */
    protected ListHelper<T> mListHelper;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mListHelper = new ListHelper<>(mActivity, getListView(), getListAdapter());
        mListHelper.setListCallBack(this);
        mListHelper.setEmptyDrawable(getEmptyDrawable());
        mListHelper.setEmptyText(getEmptyText());
        mListHelper.setErrorDrawable(getErrorDrawable());
        mListHelper.bindLoading();
    }
    /**
     * @param list 数据
     *  添加数据到列表 ，对应界面上拉
     */
    protected void addList(ArrayList<T> list) {
        mListHelper.addList(list);
    }

    /**
     * @param list 数据
     *  刷新数据，对应界面下拉
     */
    protected void resetList(ArrayList<T> list) {
        mListHelper.resetList(list);
    }

    protected List<T> getArrayListData() {
        return mListHelper.getDataSource();
    }

    /**
     *  清空数据
     */
    protected void emptyList() {
        mListHelper.emptyList();
    }



    /**
     * @return List<T>
     *  获取整个listView数据
     */
    protected List<T> getDataSource() {
        return mListHelper.getDataSource();
    }

    /**
     * @return int count
     *  获取整个listView数目
     */
    protected int getCount() {
        return mListHelper.getCount();
    }

    /**
     * @return boolean true为空 false不为空
     *  判断listView是否为空
     */
    protected boolean isEmpty() {
        return mListHelper.isEmpty();
    }

    // 解析网络错误时显示界面
    protected void bindError(String errorText) {
        if (mListHelper != null) {
            mListHelper.bindError(errorText);
            setRefreshHint();
        }

    }

    /**
     *  列表为空时显示
     */
    protected void showLoading() {
        mListHelper.bindEmpty();
        setRefreshHint();
    }
    //camera 列表为空

    protected void bindAddEmpty() {
        if (mListHelper == null)
            return;
        mListHelper.bindAddEmpty();
        setRefreshHint();
    }

    /**
     *  列表为空时显示
     */
    protected void bindEmpty() {
        if (mListHelper == null)
            return;
        mListHelper.bindEmpty();
        setRefreshHint();
    }

    protected void bindLoading() {
        if (mListHelper != null) {
            mListHelper.bindLoading();
        }

    }

    protected void showBindLoading(boolean bshow) {
        if (mListHelper != null) {
            mListHelper.showBindLoading(bshow);
        }

    }

    protected void bindEmpty(String emptyText) {
        mListHelper.bindEmpty(emptyText);
        setRefreshHint();
    }

    /**
     *  当列表为空时关闭刷新时用到的对象
     */
    protected void setRefreshHint() {
        stopProgressDialog();
    }

    /**
     * @return String
     *  返回列表为空时提示字符串
     */
    protected String getEmptyText() {
        return getString(R.string.pps_str_default_list_no_data);
    }

    /**
     * @return Drawable
     *  返回列表为空时提示图标
     */
    @SuppressWarnings("deprecation")
    protected Drawable getEmptyDrawable() {
        return getResources().getDrawable(R.mipmap.ic_error);
    }

    /**
     * @return Drawable
     *  网络请求错误时提示图标
     */
    @SuppressWarnings("deprecation")
    protected Drawable getErrorDrawable() {
        return getResources().getDrawable(R.mipmap.ic_error);
    }

    // 同ListView的OnItemClick

    @Override
    public void onItemClick(View view, T data, int position) {

    }

    /*
     * (non-Javadoc)
     *
     * @see com.lizi.app.utils.LiziListHelper.ListCallBack#onEmptyClick()
     */
    @Override
    public void onEmptyClick(boolean addDev) {
        onRefresh();
    }

    protected void onNextPage() {

    }

    protected abstract RecyclerView getListView(); // 得到该listView对象

    protected abstract BaseQuickAdapter<T,BaseViewHolder> getListAdapter();


}
