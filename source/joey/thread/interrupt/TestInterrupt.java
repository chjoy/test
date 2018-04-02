package joey.thread.interrupt;

import joey.thread.stop.TestStop;

/**
 * Created by yp-tc-m-7179 on 2018/3/8.
 *
 */
public class TestInterrupt {
    static class TestThread extends Thread{
        @Override
        public void run() {
            while (true){
                if (Thread.currentThread().isInterrupted()){
                    System.out.println("interrupted!");
                    break;
                }
                try {
                    Thread.sleep(2000);
                } catch (InterruptedException e) {
                    System.out.println("sleep interrupted exception!");
                    Thread.currentThread().interrupt();
                }

                System.out.println(Thread.currentThread().isInterrupted());
            }
        }
    }
    public static void main(String[] args) {
        Thread t = new TestThread();
        t.start();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
        }
        t.interrupt();
    }
}
