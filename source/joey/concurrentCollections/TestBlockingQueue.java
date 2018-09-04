package joey.concurrentCollections;

import java.util.concurrent.ArrayBlockingQueue;

/**
 * Created by yp-tc-m-7179 on 2018/8/31.
 */
public class TestBlockingQueue {
    public static void main(String[] args) {
        ArrayBlockingQueue q = new ArrayBlockingQueue(5);
        //直接查源码看
        q.add("aaa");
    }
}
