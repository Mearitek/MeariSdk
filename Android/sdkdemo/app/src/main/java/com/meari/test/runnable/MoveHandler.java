package com.meari.test.runnable;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 云端控制，任务队列
 * Created by chengjianjia on 2016/1/28.
 */
public class MoveHandler extends Handler {

    private final List<MoveRunnable> threadQueue = Collections.synchronizedList(new ArrayList<MoveRunnable>());

    /**
     * 是否退出
     */
    private volatile boolean isQuit = false;

    public boolean isMove;

    public final static MoveHandler newMoveHandler() {
        HandlerThread handlerThread = new HandlerThread(MoveHandler.class.getSimpleName());
        handlerThread.start();
        MoveHandler moveHandler = new MoveHandler(handlerThread.getLooper());
        return moveHandler;
    }

    public MoveHandler(Looper looper) {
        super(looper);
    }

    @Override
    public void handleMessage(Message msg) {
        if (!isQuit) {
            if (threadQueue.size() > 0) {
                MoveRunnable r = threadQueue.get(0);
                threadQueue.remove(0);
                if (r != null) {
                    if (r.isMove() && !this.isMove) {
                        r.run();
                        this.isMove = r.isMove();
                    } else if (!r.isMove() && this.isMove) {
                        r.run();
                        this.isMove = r.isMove();
                    }
                }
                this.sendEmptyMessage(0);
            } else {
                this.sendEmptyMessageDelayed(0, 300);
            }
        }
    }

    /**
     * 添加任务
     * @param r
     */
    public void addRunnable(MoveRunnable r) {
        if (isQuit) {
            return;
        }
        threadQueue.add(r);
        this.sendEmptyMessage(0);
    }

    public void close() {
        isQuit = true;
    }
}
