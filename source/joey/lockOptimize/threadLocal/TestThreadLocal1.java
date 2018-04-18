package joey.lockOptimize.threadLocal;

import java.util.Random;

/**
 * Created by yp-tc-m-7179 on 2018/4/18.
 * 测试static的threadlocal，在各个线程中所持有的对象，是否是同一个
 * 结果显示：虽然tl是静态的，且看上去只初始化了一次，但是通过测试可以看出是不同的random对象
 * 结论：同时，通过查看源代码，新线程的threadlocal的get()方法都会去调用一次initialValue()，所以每次的random都不同
 */
public class TestThreadLocal1 {
    static ThreadLocal<Random> tl = new ThreadLocal<Random>() {
        @Override
        protected Random initialValue() {
            return new Random();
        }
    };

    static class r implements Runnable {
        @Override
        public void run() {
            System.out.println(tl.get());
        }
    }

    public static void main(String[] args) throws Exception {
        new Thread(new r()).start();
        new Thread(new r()).start();
    }
}
