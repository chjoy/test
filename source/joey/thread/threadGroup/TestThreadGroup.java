package joey.thread.threadGroup;

/**
 * Created by yp-tc-m-7179 on 2018/3/9.
 */
public class TestThreadGroup {
    static class Run implements Runnable{
        @Override
        public void run() {
            System.out.println(Thread.currentThread().getThreadGroup().getName()+Thread.currentThread().getName());
        }
    }
    public static void main(String[] args) {
        ThreadGroup tg = new ThreadGroup("tg1");
        Thread t1 = new Thread(tg,new Run(),"t1");
        Thread t2 = new Thread(tg,new Run(),"t2");
        t1.start();
        t2.start();
    }
}
