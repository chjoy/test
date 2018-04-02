package joey.thread.cyclicBarrier;

import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

/**
 * Created by yp-tc-m-7179 on 2018/3/21.
 */
public class TestCyclicBarry extends Thread {

    private int interval;

    TestCyclicBarry(int second) {
        interval = second;
    }

    static CyclicBarrier c = new CyclicBarrier(5);

    @Override
    public void run() {
        try {
            Thread.sleep(interval * 1000);
            System.out.println(interval + "一阶段完成");
            c.await();
            Thread.sleep(interval * 1000);
            System.out.println(interval + " 二阶段完成");
            c.await();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws Exception {
//        for (int i = 0; i < 4; i++) {//小于5时阻塞
//        for (int i = 0; i < 5; i++) {//大于等于5时解锁
        for (int i = 0; i < 10; i++) {
            new TestCyclicBarry(i).start();
        }
//        c.await();//i<5时可以尝试在主线程处理
        System.out.println("~~");
    }

}
