package joey.thread.lock;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by yp-tc-m-7179 on 2018/2/26.
 *
 */
public class TestLock {
    static Lock lock = new ReentrantLock();
    static int i = 2;

    static class T extends Thread{
        @Override
        public void run() {
//            lock.lock();
            System.out.println(Thread.currentThread().getName()+":"+i++);
//            lock.unlock();
        }
    }
    static class K extends Thread{
        @Override
        public void run() {
            lock.lock();
            System.out.println(Thread.currentThread().getName()+":"+i--);
            lock.unlock();
        }
    }

    public static void main(String[] args) throws InterruptedException {
        T t1 = new T();
        t1.setName("t");
        K t2 = new K();
        t2.setName("k");
        t2.start();
        t1.start();
        t1.join();
        t2.join();
        System.out.println(i);
    }
}
