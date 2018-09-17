package joey.thread.deadLock;

import java.util.concurrent.*;

/**
 * Created by yp-tc-m-7179 on 2018/9/13.
 * 实际上不是常见的那种相互之间持有锁的死锁，而是"饥饿"
 */
public class TestDeadLock {
    public final static ExecutorService executorService = Executors.newSingleThreadExecutor();
//    final static ExecutorService executorService1 = Executors.newSingleThreadExecutor();

    public static void main(String[] args) throws Exception{
        System.out.println(executorService.submit(new FutureTask<String>(new Render())).get());//（1）
    }

    public static class Render implements Callable{
        @Override
        public String call() throws Exception {
            System.out.println(111);
            //由于只有一条线程，在（1）没有运行完之前，一直会等待资源释放
            Future<String> A=executorService.submit(new Callable<String>() {
                @Override
                public String call() throws Exception {
                    return "aaa";
                }
            });
            return A.get();
        }
    }

}
