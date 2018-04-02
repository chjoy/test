package joey.thread.countDownLatch;

import java.util.concurrent.CountDownLatch;

/**
 * Created by yp-tc-m-7179 on 2018/3/14.
 *
 */
public class TestCountDownLatch implements Runnable{
    static CountDownLatch countDownLatch = new CountDownLatch(5);

    @Override
    public void run() {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(Thread.currentThread().getName());
        countDownLatch.countDown();
    }

    public static void main(String[] args) throws Exception{
//        for (int i = 0; i < 5; i++) {
        for (int i = 0; i < 4; i++) {
            new Thread(new TestCountDownLatch()).start();
        }
        countDownLatch.await();
        System.out.println("end");
    }
}
