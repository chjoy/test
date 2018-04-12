package joey.thread.lockSupport;

import java.util.concurrent.locks.LockSupport;

/**
 * Created by yp-tc-m-7179 on 2018/4/4.
 * LockSupport其它的api也可以多关注
 */
public class TestLockSupport implements Runnable {
    @Override
    public void run() {
        LockSupport.park();
        System.out.println(Thread.currentThread().getName()+" over");
    }

    public static void main(String[] args) throws Exception{
        Thread t1 = new Thread(new TestLockSupport());
        Thread t2 = new Thread(new TestLockSupport());
        t1.start();
        Thread.sleep(3000);
        t2.start();
        LockSupport.unpark(t1);
//        LockSupport.unpark(t2);
//        t2.join();
//        t1.join();
//        System.out.println("all over");
    }

}
