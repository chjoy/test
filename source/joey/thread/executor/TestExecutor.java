package joey.thread.executor;

import joey.thread.futureTask.TestFutrueTask;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by yp-tc-m-7179 on 2018/9/12.
 *
 */
public class TestExecutor {
    public static void main(String[] args) {
        ExecutorService exec = Executors.newFixedThreadPool(5);
        for (int i = 0; i < 10; i++) {
            exec.submit(new Runnable() {
                @Override
                public void run() {
                    System.out.println(111);
                }
            });
        }
    }
}
