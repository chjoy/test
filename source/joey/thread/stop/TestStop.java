package joey.thread.stop;

/**
 * Created by yp-tc-m-7179 on 2018/3/7.
 *
 */
public class TestStop {
    static class TestThread extends Thread{
        @Override
        public void run() {
            System.out.println("test thread sleeping...");
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("test thread over!");
        }
    }
    public static void main(String[] args) {
        Thread t = new TestThread();
        t.start();
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        t.stop();
    }

}
