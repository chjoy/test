package joey.thread.futureTask;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;

/**
 * Created by yp-tc-m-7179 on 2018/8/29.
 */
public class TestFutrueTask {
    private final FutureTask<String> futureTask = new FutureTask<String>(new Callable<String>() {
        @Override
        public String call() throws Exception {
            return "future!";
        }
    });
    private final Thread thread = new Thread(futureTask);

    public void start(){thread.start();}

    public String get(){
        try {
            return futureTask.get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }
    public static void main(String[] args) {
        TestFutrueTask testFutrueTask = new TestFutrueTask();
        testFutrueTask.start();
        System.out.println(testFutrueTask.get());
    }
}
