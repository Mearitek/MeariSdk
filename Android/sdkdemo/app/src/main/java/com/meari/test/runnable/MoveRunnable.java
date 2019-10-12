package com.meari.test.runnable;

/**
 * 云端控制，Runnable
 * Created by chengjianjia on 2016/1/28.
 */
public interface MoveRunnable extends Runnable {
    /**
     * 是否移动
     * @return  ture:移动，false:停止
     */
    public boolean isMove();
}