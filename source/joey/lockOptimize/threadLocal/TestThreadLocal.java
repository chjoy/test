package joey.lockOptimize.threadLocal;

import java.util.Random;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * Created by yp-tc-m-7179 on 2018/4/17.
 * 个人理解：
 * 1.threadlocal并不是解决并发问题的
 * 2.threadlocal用于单线程内，数据的共享：例如controller中set一个值，在service（需要确认controller和service的调用是在一个线程中）
 * 中调用，如果不通过参数传递，那么就可以用threadlocal去存取
 * 3.线程池使用过程中最好记得remove，避免长期保存大的数据导致内存溢出
 * 4.性能对比请运行该类：该类居然看不出性能差别，让我怀疑书上《java高并发程序设计》写得有问题
 */
public class TestThreadLocal {

    static int count = 10000000;
    static int tCount = 40;
    static Random random = new Random();
    static ThreadLocal<Random> tl = new ThreadLocal<Random>() {
        @Override
        protected Random initialValue() {
            return new Random();
        }
    };

    static class r implements Callable<Long> {
        @Override
        public Long call() {
            long start = System.currentTimeMillis();
            for (int i = 0; i < count; i++) {
                random.nextInt();//对比不同方式导致的性能开销
//            tl.get().nextInt();//对比不同方式导致的性能开销
            }
            return System.currentTimeMillis() - start;
        }
    }

    public static void main(String[] args) throws Exception {
        ExecutorService executor = Executors.newFixedThreadPool(tCount);
        long sum =0;
        for (int i = 0; i < 40; i++) {
            sum +=executor.submit(new r()).get();
        }
        System.out.println(sum);
    }
}
