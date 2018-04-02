package joey.thread.join;

/**
 * Created by yp-tc-m-7179 on 2018/3/9.
 *
 */
public class TestJoin {
    static class TestThread extends Thread{
        @Override
        public void run() {
            System.out.println("running");
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("thread over!");
        }
    }

    public static void main(String[] args) throws Exception{
        Thread t1 = new TestThread();
        t1.start();
        t1.join();//注释看不同效果
        System.out.println("main over!");
    }
}
