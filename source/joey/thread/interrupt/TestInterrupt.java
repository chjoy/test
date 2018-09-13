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
                }finally {
                    Thread.currentThread().interrupt();//如果此处不再中断一把，循环不会终止，且下面打印出来会是false
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
