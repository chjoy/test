package joey.thread.threadpool;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by yp-tc-m-7179 on 2018/4/12.
 *
 */
public class TestFixPool {

    public static void main(String[] args) {
        ExecutorService executorService = Executors.newFixedThreadPool(2);
        executorService.submit(() -> {
            System.out.println("start...");
            System.out.println(1/0);//线程池会吃掉该异常，导致没有异常堆栈信息
//                System.out.println(1/1);
        });
    }
}
