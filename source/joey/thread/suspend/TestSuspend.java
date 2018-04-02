package joey.thread.suspend;

/**
 * Created by yp-tc-m-7179 on 2018/3/9.
 *
 */
public class TestSuspend {
    static Object o = new Object();
    static TestThread t1 = new TestThread("t1");
    static TestThread t2 = new TestThread("t2");
    static class TestThread extends Thread{
        public TestThread(String name){
            super.setName(name);
        }
        @Override
        public void run() {
            synchronized (o){
                System.out.println(getName());
                Thread.currentThread().suspend();
            }
        }
    }

    public static void main(String[] args) throws Exception{
        t1.start();
        Thread.sleep(1000);
        t2.start();
        t1.resume();
        Thread.sleep(1000);
        t2.resume();
        t1.join();
        t2.join();
    }

}
