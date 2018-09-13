package joey.thread.completionService;

import java.util.concurrent.*;

/**
 * Created by yp-tc-m-7179 on 2018/9/12.
 * CompletionService每次产生一个future，与executorService不同，后者用invokeAll可以返回一个future集合
 * 当然，CompletionService也可以用
 */
public class TestCompletionService {
    public static void main(String[] args) throws Exception{
        Executor executor = Executors.newFixedThreadPool(5);
        CompletionService completionService = new ExecutorCompletionService(executor);
        for (int i = 0; i < 5; i++) {
            completionService.submit(new Callable() {
                @Override
                public Object call() throws Exception {
                    return Thread.currentThread().getName();
                }
            });
        }

        for (int i = 0; i < 10; i++) {
            Future future = completionService.take();
            System.out.println(future.get());
        }
    }
}
