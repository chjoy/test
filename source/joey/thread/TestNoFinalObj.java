package joey.thread;

/**
 * Created by yp-tc-m-7179 on 2018/3/9.
 *
 */
public class TestNoFinalObj {
    static Object o1 = new Object();
    static Object o2 = new Object();
    static Object o = o1;
    static class TestThread extends Thread{
        @Override
        public void run() {
            synchronized (o){
                System.out.println(o);
//                o=o2;//注释此行看到不同效果
                try {
                    Thread.sleep(5000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void main(String[] args) throws Exception{
        Thread t1 = new TestThread();
        Thread t2 = new TestThread();
        t1.start();
        Thread.sleep(1000);
        t2.start();

    }
}
