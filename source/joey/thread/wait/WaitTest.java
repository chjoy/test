package joey.thread.wait;

/**
 * Created by yp-tc-m-7179 on 2018/2/26.
 *
 */
public class WaitTest {
    static final Object o = new Object();
    public static class T1Wait extends Thread{
        @Override
        public void run() {
            synchronized (o){
                System.out.println("thread1 start...");
                try {
                    System.out.println("o.wait...");
                    o.wait(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("t1 end!");
            }
        }
    }
    public static class T2Notify extends Thread{
        @Override
        public void run() {
            synchronized (o){
                System.out.println("thread2 start...");
                System.out.println("o.notify()...");
//                o.notify();
                System.out.println("t2 end!");
            }
        }
    }

    public static void main(String[] args) {
        T1Wait t1 = new T1Wait();
        T2Notify t2 = new T2Notify();
        t1.start();
        t2.start();
    }

}
