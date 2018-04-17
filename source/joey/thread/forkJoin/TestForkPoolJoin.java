package joey.thread.forkJoin;

import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.ForkJoinTask;
import java.util.concurrent.RecursiveTask;

/**
 * Created by yp-tc-m-7179 on 2018/4/16.
 *
 */
public class TestForkPoolJoin extends RecursiveTask {

    @Override
    protected Integer compute() {

        return 10;
    }

    public static void main(String[] args) throws Exception{
        TestForkPoolJoin forkJoinTask = new TestForkPoolJoin();
        ForkJoinPool forkJoinPool = new ForkJoinPool();
        System.out.println(forkJoinPool.submit(forkJoinTask).get());
    }
}
