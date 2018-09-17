package joey.thread.sleep;

import java.util.concurrent.CountDownLatch;

/**
 * Created by yp-tc-m-7179 on 2018/2/26.
 *
 */
public class SleepTest {
    public static void main(String[] args) throws Exception{
        int num = 50;
        final CountDownLatch start = new CountDownLatch(1);
        final CountDownLatch end = new CountDownLatch(num);
        for (int i = 0; i < num; i++) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        start.await();
                        Thread.sleep(3000);
                        System.out.println(Thread.currentThread().getName());
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }finally {
                        end.countDown();
                    }
                }
            }).start();
        }
        start.countDown();
    }
}
