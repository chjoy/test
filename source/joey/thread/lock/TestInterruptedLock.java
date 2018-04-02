package joey.thread.lock;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by yp-tc-m-7179 on 2018/3/9.
 */
public class TestInterruptedLock {
    static Lock lock = new ReentrantLock();
    static class TestThread extends Thread{
        TestThread(String name){
            setName(name);
        }
        @Override
        public void run() {
            try {
//                lock.lockInterruptibly();
                lock.lock();
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName());
            lock.unlock();
        }
    }

    public static void main(String[] args) {
        Thread t1 = new TestThread("t1");
        Thread t2 = new TestThread("t2");
        t1.start();
        t2.start();
        t1.interrupt();
    }
}
