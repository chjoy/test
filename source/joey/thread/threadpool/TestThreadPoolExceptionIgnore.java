package joey.thread.threadpool;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Created by yp-tc-m-7179 on 2018/4/13.
 * 用execute方法取代submit方法，避免异常信息被'吃'
 * 同时：
 * 直接使用execute方法出现异常时，仅抛出runnable里的信息，并不能定位到外围
 * 所以
 * 包装runnable并带入异常参数，打印日志，异常栈才会打印到main函数位置
 */
public class TestThreadPoolExceptionIgnore extends ThreadPoolExecutor{

    public TestThreadPoolExceptionIgnore(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue);
    }

    @Override
    public void execute(Runnable command) {
        super.execute(command);
    }

    public static void main(String[] args) {
        TestThreadPoolExceptionIgnore poolExceptionIgnore = new TestThreadPoolExceptionIgnore(2,2,0L,TimeUnit.SECONDS,new SynchronousQueue<>());
//        poolExceptionIgnore.submit(wrapper(new Exception("抛异常")));
        poolExceptionIgnore.execute(wrapper(new Exception("抛异常")));
        poolExceptionIgnore.shutdown();
    }

    private static Runnable wrapper(Exception e0){
        return new Runnable() {
            @Override
            public void run() {
                try {
                    int i = 1/0;
                } catch (Exception e) {
                    e0.printStackTrace();
                    throw e;
                }
            }
        };
    }

}
