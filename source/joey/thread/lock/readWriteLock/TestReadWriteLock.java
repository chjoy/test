package joey.thread.lock.readWriteLock;

import joey.thread.TestRunnable;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * Created by yp-tc-m-7179 on 2018/3/13.
 */
public class TestReadWriteLock  implements Runnable{
    private static Lock relock = new ReentrantLock();
    private static ReentrantReadWriteLock readWriteLock = new ReentrantReadWriteLock();
    private Lock readLock = readWriteLock.readLock();
    private Lock writeLock = readWriteLock.writeLock();

    @Override
    public void run() {
        try {
//            work(relock);
//            read(readLock);
            write(writeLock);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    static void work(Lock lock) throws Exception{
        try {
            lock.lock();
            Thread.sleep(1000);
            System.out.println("worked");
        }finally {
            lock.unlock();
        }
    }
    static void read(Lock lock) throws Exception{
        try {
            lock.lock();
            Thread.sleep(1000);
            System.out.println("readed");
        }finally {
            lock.unlock();
        }
    }
    static void write(Lock lock) throws Exception{
        try {
            lock.lock();
            Thread.sleep(1000);
            System.out.println("writed");
        }finally {
            lock.unlock();
        }
    }

    public static void main(String[] args) {
        for (int i = 0; i < 10; i++) {
            new Thread(new TestReadWriteLock()).start();
        }
    }
}
