package joey.thread.lock.condition;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by yp-tc-m-7179 on 2018/3/9.
 */
public class TestCondition implements Runnable{
    static Lock lock = new ReentrantLock();
    static Condition condition = lock.newCondition();
    @Override
    public void run() {
        try {
            lock.lock();
            condition.await();
            System.out.println("go on...");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }finally {
            lock.unlock();
        }
    }

    public static void main(String[] args) throws Exception{
        Thread t1 = new Thread(new TestCondition());
        t1.start();
        Thread.sleep(5000);
        lock.lock();
        condition.signal();
        lock.unlock();
    }
}
